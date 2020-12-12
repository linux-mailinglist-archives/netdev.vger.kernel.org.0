Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB002D8A40
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 23:13:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408061AbgLLWMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 17:12:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:56868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408047AbgLLWMP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 17:12:15 -0500
Date:   Sat, 12 Dec 2020 14:11:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607811094;
        bh=g5hk368oUAGBt3OEq1gP3g9cF4odoBxjHhEnA8O/Qcs=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=mGgJlT5TcpKisKmQ6EjoIySJYNgXHpUwEsK+DD2U0oTtH41jJREn//dEAId3cHkMQ
         o4tHY+p/QOoJ4keX8Kcxl6wUGNXIpTiWRf9ErTWQfBTVGHKQrFiKBNhArL1h2KKFUO
         FySDD/Y4zo765bxU7KtTFnbSH/trwOspfXOqlMVM3asF1biWYAx6B8ADD97MHSqMkx
         LT26vS+0+s5Ms/+mP/eclqCqkbtk/hLU5LDvKcM1rWdDP5yB9BROawpjllItZF3cLD
         X+xcU+Jc54r2GKPpRNeBwCcSLKwfko1PLIP0kOCRM7L1WWqjg1BRssyKOi58HnKk7D
         qSEX5ItT9BhjQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pravin B Shelar <pbshelar@fb.com>
Cc:     <netdev@vger.kernel.org>, <pablo@netfilter.org>,
        <laforge@gnumonks.org>, <jonas@norrbonn.se>, <pravin.ovn@gmail.com>
Subject: Re: [PATCH net-next v2] GTP: add support for flow based tunneling
 API
Message-ID: <20201212141133.63874784@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201212044017.55865-1-pbshelar@fb.com>
References: <20201212044017.55865-1-pbshelar@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Dec 2020 20:40:17 -0800 Pravin B Shelar wrote:
> Following patch add support for flow based tunneling API
> to send and recv GTP tunnel packet over tunnel metadata API.
> This would allow this device integration with OVS or eBPF using
> flow based tunneling APIs.
> 
> Signed-off-by: Pravin B Shelar <pbshelar@fb.com>
> ---
> Fixed according to comments from Jonas Bonn

This adds a sparse warning:

drivers/net/gtp.c:218:39: warning: incorrect type in assignment (different base types)
drivers/net/gtp.c:218:39:    expected restricted __be16 [usertype] protocol
drivers/net/gtp.c:218:39:    got int

Coding nits below.

> @@ -179,33 +183,107 @@ static bool gtp_check_ms(struct sk_buff *skb, struct pdp_ctx *pctx,
>  	return false;
>  }
>  
> -static int gtp_rx(struct pdp_ctx *pctx, struct sk_buff *skb,
> -			unsigned int hdrlen, unsigned int role)
> +static int gtp_rx(struct gtp_dev *gtp, struct sk_buff *skb,
> +		  unsigned int hdrlen, u8 gtp_version, unsigned int role,
> +		  __be64 tid, u8 flags, u8 type)
>  {
> -	if (!gtp_check_ms(skb, pctx, hdrlen, role)) {
> -		netdev_dbg(pctx->dev, "No PDP ctx for this MS\n");
> -		return 1;
> -	}
> +	if (ip_tunnel_collect_metadata() || gtp->collect_md) {

nit: this is a static function which is almost entirely indented now.
Please refactor.

> +		struct metadata_dst *tun_dst;
> +		int opts_len = 0;
> +
> +		if (unlikely(flags & GTP1_F_MASK))
> +			opts_len = sizeof(struct gtpu_metadata);
> +
> +		tun_dst =
> +			udp_tun_rx_dst(skb, gtp->sk1u->sk_family, TUNNEL_KEY, tid, opts_len);

Strange why to break a like after =, rather than just wrap function
args.

> +		if (!tun_dst) {
> +			netdev_dbg(gtp->dev, "Failed to allocate tun_dst");
> +			goto err;
> +		}
>  
> -	/* Get rid of the GTP + UDP headers. */
> -	if (iptunnel_pull_header(skb, hdrlen, skb->protocol,
> -				 !net_eq(sock_net(pctx->sk), dev_net(pctx->dev))))
> -		return -1;
> +		netdev_dbg(gtp->dev, "attaching metadata_dst to skb, gtp ver %d hdrlen %d\n",
> +			   gtp_version, hdrlen);
> +		if (unlikely(opts_len)) {
> +			struct gtpu_metadata *opts = ip_tunnel_info_opts(&tun_dst->u.tun_info);
> +			struct gtp1_header *gtp1 = (struct gtp1_header *)(skb->data +
> +									  sizeof(struct udphdr));

Why bother initializing inline if it creates very long lines?
Please move both of those to separate statements.

> +			opts->ver = GTP_METADATA_V1;
> +			opts->flags = gtp1->flags;
> +			opts->type = gtp1->type;
> +			netdev_dbg(gtp->dev, "recved control pkt: flag %x type: %d\n",
> +				   opts->flags, opts->type);
> +			tun_dst->u.tun_info.key.tun_flags |= TUNNEL_GTPU_OPT;
> +			tun_dst->u.tun_info.options_len = opts_len;
> +			skb->protocol = 0xffff;         /* Unknown */
> +		}
> +		/* Get rid of the GTP + UDP headers. */
> +		if (iptunnel_pull_header(skb, hdrlen, skb->protocol,
> +					 !net_eq(sock_net(gtp->sk1u), dev_net(gtp->dev)))) {
> +			gtp->dev->stats.rx_length_errors++;
> +			goto err;
> +		}
> +
> +		skb_dst_set(skb, &tun_dst->dst);
> +	} else {
> +		struct pdp_ctx *pctx;
> +
> +		if (flags & GTP1_F_MASK)
> +			hdrlen += 4;
> +
> +		if (type != GTP_TPDU)
> +			return 1;
>  
> -	netdev_dbg(pctx->dev, "forwarding packet from GGSN to uplink\n");
> +		if (gtp_version == GTP_V0)
> +			pctx = gtp0_pdp_find(gtp, be64_to_cpu(tid));
> +		else
> +			pctx = gtp1_pdp_find(gtp, be64_to_cpu(tid));
> +		if (!pctx) {
> +			netdev_dbg(gtp->dev, "No PDP ctx to decap skb=%p\n", skb);
> +			return 1;
> +		}
> +
> +		if (!gtp_check_ms(skb, pctx, hdrlen, role)) {
> +			netdev_dbg(pctx->dev, "No PDP ctx for this MS\n");
> +			return 1;
> +		}
> +		/* Get rid of the GTP + UDP headers. */
> +		if (iptunnel_pull_header(skb, hdrlen, skb->protocol,
> +					 !net_eq(sock_net(pctx->sk), dev_net(gtp->dev)))) {
> +			gtp->dev->stats.rx_length_errors++;
> +			goto err;
> +		}
> +	}
> +	netdev_dbg(gtp->dev, "forwarding packet from GGSN to uplink\n");
>  
>  	/* Now that the UDP and the GTP header have been removed, set up the
>  	 * new network header. This is required by the upper layer to
>  	 * calculate the transport header.
>  	 */
>  	skb_reset_network_header(skb);
> +	if (pskb_may_pull(skb, sizeof(struct iphdr))) {
> +		struct iphdr *iph;
> +
> +		iph = ip_hdr(skb);
> +		if (iph->version == 4) {
> +			netdev_dbg(gtp->dev, "inner pkt: ipv4");
> +			skb->protocol = htons(ETH_P_IP);
> +		} else if (iph->version == 6) {
> +			netdev_dbg(gtp->dev, "inner pkt: ipv6");
> +			skb->protocol = htons(ETH_P_IPV6);
> +		} else {
> +			netdev_dbg(gtp->dev, "inner pkt error: Unknown type");
> +		}
> +	}
>  
> -	skb->dev = pctx->dev;
> -
> -	dev_sw_netstats_rx_add(pctx->dev, skb->len);
> -
> +	skb->dev = gtp->dev;
> +	dev_sw_netstats_rx_add(gtp->dev, skb->len);
>  	netif_rx(skb);
>  	return 0;
> +
> +err:
> +	gtp->dev->stats.rx_dropped++;
> +	return -1;
>  }
>  
>  /* 1 means pass up to the stack, -1 means drop and 0 means decapsulated. */

> @@ -329,7 +391,7 @@ static int gtp_encap_recv(struct sock *sk, struct sk_buff *skb)
>  	if (!gtp)
>  		return 1;
>  
> -	netdev_dbg(gtp->dev, "encap_recv sk=%p\n", sk);
> +	netdev_dbg(gtp->dev, "encap_recv sk=%p type %d\n", sk, udp_sk(sk)->encap_type);

Prefer wrapping code at 80 chars.

>  	switch (udp_sk(sk)->encap_type) {
>  	case UDP_ENCAP_GTP0:

> @@ -737,6 +912,9 @@ static int gtp_fill_info(struct sk_buff *skb, const struct net_device *dev)
>  	if (nla_put_u32(skb, IFLA_GTP_PDP_HASHSIZE, gtp->hash_size))
>  		goto nla_put_failure;
>  
> +	if (gtp->collect_md  && nla_put_flag(skb, IFLA_GTP_COLLECT_METADATA))

Double space before &&

> +		goto nla_put_failure;
> +
>  	return 0;
>  
>  nla_put_failure:
