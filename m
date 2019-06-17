Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C27B549527
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 00:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727419AbfFQWaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 18:30:09 -0400
Received: from mail.us.es ([193.147.175.20]:60840 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbfFQWaJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 18:30:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4DCF7BEBA4
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 00:30:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3BF65DA709
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 00:30:07 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3159DDA706; Tue, 18 Jun 2019 00:30:07 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 17EF2DA703;
        Tue, 18 Jun 2019 00:30:05 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 18 Jun 2019 00:30:05 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E674C4265A2F;
        Tue, 18 Jun 2019 00:30:04 +0200 (CEST)
Date:   Tue, 18 Jun 2019 00:30:04 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     wenxu@ucloud.cn, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: nft_paylaod: add base type
 NFT_PAYLOAD_LL_HEADER_NO_TAG
Message-ID: <20190617223004.tnqz2bl7qp63fcfy@salvia>
References: <1560151280-28908-1-git-send-email-wenxu@ucloud.cn>
 <20190610094433.3wjmpfiph7iwguan@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610094433.3wjmpfiph7iwguan@breakpoint.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Mon, Jun 10, 2019 at 11:44:33AM +0200, Florian Westphal wrote:
> wenxu@ucloud.cn <wenxu@ucloud.cn> wrote:
> > From: wenxu <wenxu@ucloud.cn>
> > 
> > nft add rule bridge firewall rule-100-ingress ip protocol icmp drop
> 
> nft --debug=netlink add rule bridge firewall rule-100-ingress ip protocol icmp drop
> bridge firewall rule-100-ingress
>   [ payload load 2b @ link header + 12 => reg 1 ]
>   [ cmp eq reg 1 0x00000008 ]
>   [ payload load 1b @ network header + 9 => reg 1 ]
>   [ cmp eq reg 1 0x00000001 ]
>   [ immediate reg 0 drop ]
> 
> so problem is that nft inserts a dependency on the ethernet protocol
> type (0x800).
> 
> But when vlan is involved, that will fail to compare.
> 
> It would also fail for qinq etc.
> 
> Because of vlan tag offload, the rule about will probably already work
> just fine when nft userspace is patched to insert the dependency based
> on 'meta protocol'.  Can you see if this patch works?
> 
> Subject: Change bridge l3 dependency to meta protocol
> 
> This examines skb->protocol instead of ethernet header type, which
> might be different when vlan is involved.
> 
> nft payload expression will re-insert the vlan tag so ether type
> will not be ETH_P_IP.
> 
> ---
>  src/meta.c    |  6 +++++-
>  src/payload.c | 20 ++++++++++++++++++++
>  2 files changed, 25 insertions(+), 1 deletion(-)
> 
> diff --git a/src/meta.c b/src/meta.c
> index 583e790ff47d..1e8964eb48c4 100644
> --- a/src/meta.c
> +++ b/src/meta.c
> @@ -539,7 +539,11 @@ static void meta_expr_pctx_update(struct proto_ctx *ctx,
>  		proto_ctx_update(ctx, PROTO_BASE_TRANSPORT_HDR, &expr->location, desc);
>  		break;
>  	case NFT_META_PROTOCOL:
> -		if (h->base < PROTO_BASE_NETWORK_HDR && ctx->family != NFPROTO_NETDEV)
> +		if (h->base != PROTO_BASE_LL_HDR)
> +			return;
> +
> +		if (ctx->family != NFPROTO_NETDEV &&
> +		    ctx->family != NFPROTO_BRIDGE)
>  			return;
>  
>  		desc = proto_find_upper(h->desc, ntohs(mpz_get_uint16(right->value)));
> diff --git a/src/payload.c b/src/payload.c
> index 6a8118ece890..c99bb2f69977 100644
> --- a/src/payload.c
> +++ b/src/payload.c
> @@ -18,6 +18,7 @@
>  #include <net/if_arp.h>
>  #include <arpa/inet.h>
>  #include <linux/netfilter.h>
> +#include <linux/if_ether.h>
>  
>  #include <rule.h>
>  #include <expression.h>
> @@ -307,6 +308,19 @@ payload_gen_special_dependency(struct eval_ctx *ctx, const struct expr *expr)
>  	return NULL;
>  }
>  
> +static const struct proto_desc proto_metaeth = {
> +	.name		= "ethmeta",
> +	.base		= PROTO_BASE_LL_HDR,
> +	.protocols	= {
> +		PROTO_LINK(__constant_htons(ETH_P_IP),	 &proto_ip),
> +		PROTO_LINK(__constant_htons(ETH_P_ARP),	 &proto_arp),
> +		PROTO_LINK(__constant_htons(ETH_P_IPV6), &proto_ip6),
> +	},
> +	.templates	= {
> +		[0]	= PROTO_META_TEMPLATE("protocol", &ethertype_type, NFT_META_PROTOCOL, 16),
> +	},
> +};
> +
>  /**
>   * payload_gen_dependency - generate match expression on payload dependency
>   *
> @@ -369,6 +383,12 @@ int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
>  				  "no %s protocol specified",
>  				  proto_base_names[expr->payload.base - 1]);
>  
> +	if (ctx->pctx.family == NFPROTO_BRIDGE && desc == &proto_eth) {
> +		if (expr->payload.desc == &proto_ip ||
> +		    expr->payload.desc == &proto_ip6)
> +			desc = &proto_metaeth;
> +	}i

Is this sufficient to restrict the matching? Is this still buggy from
ingress?

I wonder if an explicit NFT_PAYLOAD_CHECK_VLAN flag would be useful in
the kernel, if so we could rename NFTA_PAYLOAD_CSUM_FLAGS to
NFTA_PAYLOAD_FLAGS and place it there. Just an idea.

Thanks!
