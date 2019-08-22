Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD8D99F26
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 20:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387695AbfHVSrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 14:47:13 -0400
Received: from ja.ssi.bg ([178.16.129.10]:57600 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728671AbfHVSrN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 14:47:13 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id x7MIkZQk017962;
        Thu, 22 Aug 2019 21:46:35 +0300
Date:   Thu, 22 Aug 2019 21:46:35 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Hangbin Liu <liuhangbin@gmail.com>
cc:     netdev@vger.kernel.org, Stefano Brivio <sbrivio@redhat.com>,
        wenxu <wenxu@ucloud.cn>, Alexei Starovoitov <ast@fb.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCHv4 net 1/2] ipv4/icmp: fix rt dst dev null pointer
 dereference
In-Reply-To: <20190822141949.29561-2-liuhangbin@gmail.com>
Message-ID: <alpine.LFD.2.21.1908222144440.17675@ja.home.ssi.bg>
References: <20190815060904.19426-1-liuhangbin@gmail.com> <20190822141949.29561-1-liuhangbin@gmail.com> <20190822141949.29561-2-liuhangbin@gmail.com>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Thu, 22 Aug 2019, Hangbin Liu wrote:

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
> So we can just try get it from skb->dev when rt->dst.dev is NULL.
> 
> v4: Julian Anastasov remind skb->dev also could be NULL. We'd better
> still use dst.dev and do a check to avoid crash.
> 
> v3: No changes.
> 
> v2: fix the issue in __icmp_send() instead of updating shared dst dev
> in {ip_md, ip6}_tunnel_xmit.
> 
> Fixes: c8b34e680a09 ("ip_tunnel: Add tnl_update_pmtu in ip_md_tunnel_xmit")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

	This patch looks good to me, thanks!

Reviewed-by: Julian Anastasov <ja@ssi.bg>

> ---
>  net/ipv4/icmp.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
> index 1510e951f451..001f03f76bc4 100644
> --- a/net/ipv4/icmp.c
> +++ b/net/ipv4/icmp.c
> @@ -582,7 +582,13 @@ void __icmp_send(struct sk_buff *skb_in, int type, int code, __be32 info,
>  
>  	if (!rt)
>  		goto out;
> -	net = dev_net(rt->dst.dev);
> +
> +	if (rt->dst.dev)
> +		net = dev_net(rt->dst.dev);
> +	else if (skb_in->dev)
> +		net = dev_net(skb_in->dev);
> +	else
> +		goto out;
>  
>  	/*
>  	 *	Find the original header. It is expected to be valid, of course.
> -- 
> 2.19.2

Regards

--
Julian Anastasov <ja@ssi.bg>
