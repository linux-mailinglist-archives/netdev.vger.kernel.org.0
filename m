Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A42E35B16B
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 22:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbfF3UCh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 16:02:37 -0400
Received: from ja.ssi.bg ([178.16.129.10]:43110 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726719AbfF3UCg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Jun 2019 16:02:36 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id x5UK1rfw006820;
        Sun, 30 Jun 2019 23:01:53 +0300
Date:   Sun, 30 Jun 2019 23:01:53 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Vadim Fedorenko <vfedorenko@yandex-team.ru>
cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] ipvs: allow tunneling with gre encapsulation
In-Reply-To: <2caa3152-f90d-1ad6-3f98-b07960fed171@yandex-team.ru>
Message-ID: <alpine.LFD.2.21.1906302242150.3788@ja.home.ssi.bg>
References: <2caa3152-f90d-1ad6-3f98-b07960fed171@yandex-team.ru>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Tue, 25 Jun 2019, Vadim Fedorenko wrote:

> windows real servers can handle gre tunnels, this patch allows
> gre encapsulation with the tunneling method, thereby letting ipvs
> be load balancer for windows-based services
> 
> Signed-off-by: Vadim Fedorenko <vfedorenko@yandex-team.ru>

	Looks like your patch is not encoded properly.
Check Documentation/process/email-clients.rst for your
mail client to avoid the format=flowed in Content-Type.
To be sure, send patch to yourself and try to apply it.
As alternative, use git send-email to send patches, for example:

git send-email --envelope-sender 'YOUR EMAIL' \
	[--suppress-from] [--confirm=always] \
	--to 'TO_EMAIL' --cc 'CC_EMAIL1' --cc 'CC_EMAIL2' \
	file_or_dir

	You can test it by sending first to yourself only.
Also, test every patch before sending for problems:

scripts/checkpatch.pl --strict file.patch

	It shows some problems you should fix.

	So, your patch works but you have to send v2 with
some changes...

> ---
>  include/uapi/linux/ip_vs.h      |  1 +
>  net/netfilter/ipvs/ip_vs_xmit.c | 76
>  +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 77 insertions(+)
> 

> diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
> index 71fc6d6..fad3f33 100644
> --- a/net/netfilter/ipvs/ip_vs_xmit.c
> +++ b/net/netfilter/ipvs/ip_vs_xmit.c
> @@ -29,6 +29,7 @@
>  #include <linux/tcp.h>                  /* for tcphdr */
>  #include <net/ip.h>
>  #include <net/gue.h>
> +#include <net/gre.h>
>  #include <net/tcp.h>                    /* for csum_tcpudp_magic */
>  #include <net/udp.h>
>  #include <net/icmp.h>                   /* for icmp_send */
> @@ -389,6 +390,12 @@ static inline bool decrement_ttl(struct netns_ipvs *ipvs,
>  			    skb->ip_summed == CHECKSUM_PARTIAL)
>  				mtu -= GUE_PLEN_REMCSUM + GUE_LEN_PRIV;
>  		}
> +		if (dest->tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GRE) {
> +			__be16 tflags = 0;

	Empty line needed

> +			if (dest->tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_CSUM)
> +				tflags |= TUNNEL_CSUM;
> +			mtu -= gre_calc_hlen(tflags);
> +		}
>  		if (mtu < 68) {
>  			IP_VS_DBG_RL("%s(): mtu less than 68\n", __func__);
>  			goto err_put;
> @@ -549,6 +556,12 @@ static inline bool decrement_ttl(struct netns_ipvs *ipvs,
>  			    skb->ip_summed == CHECKSUM_PARTIAL)
>  				mtu -= GUE_PLEN_REMCSUM + GUE_LEN_PRIV;
>  		}
> +		if (dest->tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GRE) {
> +			__be16 tflags = 0;

	Empty line needed

> +			if (dest->tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_CSUM)
> +				tflags |= TUNNEL_CSUM;
> +			mtu -= gre_calc_hlen(tflags);
> +		}
>  		if (mtu < IPV6_MIN_MTU) {
>  			IP_VS_DBG_RL("%s(): mtu less than %d\n", __func__,
>  				     IPV6_MIN_MTU);
> @@ -1079,6 +1092,24 @@ static inline int __tun_gso_type_mask(int encaps_af,
> int orig_af)
>  	return 0;
>  }
> 
> +static void
> +ipvs_gre_encap(struct net *net, struct sk_buff *skb,
> +	       struct ip_vs_conn *cp, __u8 *next_protocol)
> +{
> +	size_t hdrlen;
> +	__be16 tflags = 0;
> +	__be16 proto = *next_protocol == IPPROTO_IPIP ? htons(ETH_P_IP) :
> htons(ETH_P_IPV6);

	This line is too long. You can also order the lines from long
to short.

> +
> +	if (cp->dest->tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_CSUM)
> +		tflags |= TUNNEL_CSUM;

	Many empty lines are not needed...

> +
> +	hdrlen = gre_calc_hlen(tflags);
> +
> +	gre_build_header(skb, hdrlen, tflags, proto, 0, 0);
> +
> +	*next_protocol = IPPROTO_GRE;
> +}
> +
>  /*
>   *   IP Tunneling transmitter
>   *

> @@ -1328,6 +1400,10 @@ static inline int __tun_gso_type_mask(int encaps_af,
> int orig_af)
>  		udp6_set_csum(!check, skb, &saddr, &cp->daddr.in6, skb->len);
>  	}
> 
> +	if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GRE) {
> +		ipvs_gre_encap(net, skb, cp, &next_protocol);
> +	}

	Braces are not needed, at both places where ipvs_gre_encap is 
called.

> +
>  	skb_push(skb, sizeof(struct ipv6hdr));
>  	skb_reset_network_header(skb);
>  	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));

	As part of your patch, the new tunnel type should be registered 
also in ip_vs_rs_hash(), GRE will use port 0 just like IPIP, eg:

                case IP_VS_CONN_F_TUNNEL_TYPE_IPIP:
+               case IP_VS_CONN_F_TUNNEL_TYPE_GRE:
                        port = 0;
                        break;

	Then I'll post a patch for ip_vs_in_icmp() that strips
the GRE header from ICMP errors by adding ipvs_gre_decap().
I also created ipvsadm patch for GRE.

Regards

--
Julian Anastasov <ja@ssi.bg>
