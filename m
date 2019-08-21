Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73FA997FBE
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 18:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728445AbfHUQMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 12:12:35 -0400
Received: from ja.ssi.bg ([178.16.129.10]:56260 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726828AbfHUQMf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 12:12:35 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id x7LGBcO7018952;
        Wed, 21 Aug 2019 19:11:38 +0300
Date:   Wed, 21 Aug 2019 19:11:38 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Hangbin Liu <liuhangbin@gmail.com>
cc:     netdev@vger.kernel.org, Stefano Brivio <sbrivio@redhat.com>,
        wenxu <wenxu@ucloud.cn>, Alexei Starovoitov <ast@fb.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 1/2] ipv4/icmp: fix rt dst dev null pointer dereference
In-Reply-To: <20190819075327.32412-2-liuhangbin@gmail.com>
Message-ID: <alpine.LFD.2.21.1908211858200.18164@ja.home.ssi.bg>
References: <20190815060904.19426-1-liuhangbin@gmail.com> <20190819075327.32412-1-liuhangbin@gmail.com> <20190819075327.32412-2-liuhangbin@gmail.com>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Mon, 19 Aug 2019, Hangbin Liu wrote:

> In __icmp_send() there is a possibility that the rt->dst.dev is NULL,
> e,g, with tunnel collect_md mode, which will cause kernel crash.
> Here is what the code path looks like, for GRE:
> 
> - ip6gre_tunnel_xmit
>   - ip6gre_xmit_ipv4
>     - __gre6_xmit
>       - ip6_tnl_xmit
>         - if skb->len - t->tun_hlen - eth_hlen > mtu; return -EMSGSIZE
>     - icmp_send
>       - net = dev_net(rt->dst.dev); <-- here
> 
> The reason is __metadata_dst_init() init dst->dev to NULL by default.
> We could not fix it in __metadata_dst_init() as there is no dev supplied.
> On the other hand, the reason we need rt->dst.dev is to get the net.
> So we can just get it from skb->dev, just like commit 8d9336704521
> ("ipv6: make icmp6_send() robust against null skb->dev") did.
> 
> Fixes: c8b34e680a09 ("ip_tunnel: Add tnl_update_pmtu in ip_md_tunnel_xmit")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  net/ipv4/icmp.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
> index 1510e951f451..5f00c9d18b02 100644
> --- a/net/ipv4/icmp.c
> +++ b/net/ipv4/icmp.c
> @@ -582,7 +582,10 @@ void __icmp_send(struct sk_buff *skb_in, int type, int code, __be32 info,
>  
>  	if (!rt)
>  		goto out;
> -	net = dev_net(rt->dst.dev);
> +
> +	if (!skb_in->dev)
> +		goto out;

	This looks wrong to me. IIRC, we should be able to send
ICMP errors from the OUTPUT hook where skb->dev is NULL. It is
true even for IPv6: net/ipv6/netfilter/ip6t_REJECT.c works for
NF_INET_LOCAL_OUT. nf_send_unreach6() and other IPv6 places have 
workarounds to avoid skb->dev being NULL but IPv4 and IPv6 are
different: IPv4 never required skb->dev to be non-NULL, so better
do not change that. Just check dst.dev to avoid crash.

> +	net = dev_net(skb_in->dev);
>  
>  	/*
>  	 *	Find the original header. It is expected to be valid, of course.
> -- 
> 2.19.2

Regards

--
Julian Anastasov <ja@ssi.bg>
