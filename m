Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1847745704D
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 15:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235675AbhKSOKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 09:10:32 -0500
Received: from sitav-80046.hsr.ch ([152.96.80.46]:36730 "EHLO
        mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbhKSOKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 09:10:32 -0500
X-Greylist: delayed 465 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Nov 2021 09:10:32 EST
Received: from [IPv6:2a01:8b81:5407:c100:b5ce:a52d:54a9:bd1c] (unknown [IPv6:2a01:8b81:5407:c100:b5ce:a52d:54a9:bd1c])
        by mail.strongswan.org (Postfix) with ESMTPSA id 9241C40867;
        Fri, 19 Nov 2021 14:59:44 +0100 (CET)
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        David Ahern <dsahern@kernel.org>
References: <20211119013758.2740195-1-eric.dumazet@gmail.com>
From:   Tobias Brunner <tobias@strongswan.org>
Subject: Re: [PATCH net] ipv6: fix typos in __ip6_finish_output()
Message-ID: <d107273f-f538-cdad-d8ff-294fdce5d8e2@strongswan.org>
Date:   Fri, 19 Nov 2021 14:59:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211119013758.2740195-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19.11.21 02:37, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> We deal with IPv6 packets, so we need to use IP6CB(skb)->flags and
> IP6SKB_REROUTED, instead of IPCB(skb)->flags and IPSKB_REROUTED
> 
> Found by code inspection, please double check that fixing this bug
> does not surface other bugs.
> 
> Fixes: 09ee9dba9611 ("ipv6: Reinject IPv6 packets if IPsec policy matches after SNAT")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Tobias Brunner <tobias@strongswan.org>
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Cc: David Ahern <dsahern@kernel.org>
> ---
>   net/ipv6/ip6_output.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
> index 2f044a49afa8cf3586c36607c34073edecafc69c..ff4e83e2a5068322bb93391c7c5e2a8cb932730b 100644
> --- a/net/ipv6/ip6_output.c
> +++ b/net/ipv6/ip6_output.c
> @@ -174,7 +174,7 @@ static int __ip6_finish_output(struct net *net, struct sock *sk, struct sk_buff
>   #if defined(CONFIG_NETFILTER) && defined(CONFIG_XFRM)
>   	/* Policy lookup after SNAT yielded a new policy */
>   	if (skb_dst(skb)->xfrm) {
> -		IPCB(skb)->flags |= IPSKB_REROUTED;
> +		IP6CB(skb)->flags |= IP6SKB_REROUTED;
>   		return dst_output(net, sk, skb);
>   	}
>   #endif
> 

Thanks for catching this.

Tested-by: Tobias Brunner <tobias@strongswan.org>
Acked-by: Tobias Brunner <tobias@strongswan.org>
