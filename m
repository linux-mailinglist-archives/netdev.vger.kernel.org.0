Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22DE7582AE
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 14:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbfF0Mfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 08:35:55 -0400
Received: from mail.us.es ([193.147.175.20]:35116 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726308AbfF0Mfz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jun 2019 08:35:55 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F13D411ED89
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 14:35:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E16D76E7AC
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 14:35:52 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D62F364491; Thu, 27 Jun 2019 14:35:52 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AD555DA4D0;
        Thu, 27 Jun 2019 14:35:50 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 27 Jun 2019 14:35:50 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 880944265A2F;
        Thu, 27 Jun 2019 14:35:50 +0200 (CEST)
Date:   Thu, 27 Jun 2019 14:35:50 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@ucloud.cnf
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 2/2 nf-next] netfilter:nft_meta: add NFT_META_VLAN support
Message-ID: <20190627123550.vx7r4rmzduzabig6@salvia>
References: <1561601357-20486-1-git-send-email-wenxu@ucloud.cn>
 <1561601357-20486-2-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1561601357-20486-2-git-send-email-wenxu@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 10:09:17AM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> This patch provide a meta vlan to set the vlan tag of the packet.
> 
> for q-in-q vlan id 20:
> meta vlan set 0x88a8:20

Actually, I think this is not very useful for stacked vlan since this
just sets/mangles the existing meta vlan data.

We'll need infrastructure that uses skb_vlan_push() and _pop().

Patch looks good anyway, such infrastructure to push/pop can be added
later on.

Thanks.

> set the default 0x8100 vlan type with vlan id 20
> meta vlan set 20
> 
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
>  include/uapi/linux/netfilter/nf_tables.h |  4 ++++
>  net/netfilter/nft_meta.c                 | 27 ++++++++++++++++++++++++++-
>  2 files changed, 30 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index 0b18646..cf037f2 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -797,6 +797,7 @@ enum nft_exthdr_attributes {
>   * @NFT_META_OIFKIND: packet output interface kind name (dev->rtnl_link_ops->kind)
>   * @NFT_META_BRI_PVID: packet input bridge port pvid
>   * @NFT_META_BRI_VLAN_PROTO: packet input bridge vlan proto
> + * @NFT_META_VLAN: packet vlan metadata
>   */
>  enum nft_meta_keys {
>  	NFT_META_LEN,
> @@ -829,6 +830,7 @@ enum nft_meta_keys {
>  	NFT_META_OIFKIND,
>  	NFT_META_BRI_PVID,
>  	NFT_META_BRI_VLAN_PROTO,
> +	NFT_META_VLAN,
>  };
>  
>  /**
> @@ -895,12 +897,14 @@ enum nft_hash_attributes {
>   * @NFTA_META_DREG: destination register (NLA_U32)
>   * @NFTA_META_KEY: meta data item to load (NLA_U32: nft_meta_keys)
>   * @NFTA_META_SREG: source register (NLA_U32)
> + * @NFTA_META_SREG2: source register (NLA_U32)
>   */
>  enum nft_meta_attributes {
>  	NFTA_META_UNSPEC,
>  	NFTA_META_DREG,
>  	NFTA_META_KEY,
>  	NFTA_META_SREG,
> +	NFTA_META_SREG2,
>  	__NFTA_META_MAX
>  };
>  #define NFTA_META_MAX		(__NFTA_META_MAX - 1)
> diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
> index e3adf6a..29a6679 100644
> --- a/net/netfilter/nft_meta.c
> +++ b/net/netfilter/nft_meta.c
> @@ -28,7 +28,10 @@ struct nft_meta {
>  	enum nft_meta_keys	key:8;
>  	union {
>  		enum nft_registers	dreg:8;
> -		enum nft_registers	sreg:8;
> +		struct {
> +			enum nft_registers	sreg:8;
> +			enum nft_registers	sreg2:8;
> +		};
>  	};
>  };
>  
> @@ -312,6 +315,17 @@ static void nft_meta_set_eval(const struct nft_expr *expr,
>  		skb->secmark = value;
>  		break;
>  #endif
> +	case NFT_META_VLAN: {
> +		u32 *sreg2 = &regs->data[meta->sreg2];
> +		__be16 vlan_proto;
> +		u16 vlan_tci;
> +
> +		vlan_tci = nft_reg_load16(sreg);
> +		vlan_proto = nft_reg_load16(sreg2);
> +
> +		__vlan_hwaccel_put_tag(skb, vlan_proto, vlan_tci);
> +		break;
> +	}
>  	default:
>  		WARN_ON(1);
>  	}
> @@ -321,6 +335,7 @@ static void nft_meta_set_eval(const struct nft_expr *expr,
>  	[NFTA_META_DREG]	= { .type = NLA_U32 },
>  	[NFTA_META_KEY]		= { .type = NLA_U32 },
>  	[NFTA_META_SREG]	= { .type = NLA_U32 },
> +	[NFTA_META_SREG2]	= { .type = NLA_U32 },
>  };
>  
>  static int nft_meta_get_init(const struct nft_ctx *ctx,
> @@ -483,6 +498,13 @@ static int nft_meta_set_init(const struct nft_ctx *ctx,
>  	case NFT_META_PKTTYPE:
>  		len = sizeof(u8);
>  		break;
> +	case NFT_META_VLAN:
> +		len = sizeof(u16);
> +		priv->sreg2 = nft_parse_register(tb[NFTA_META_SREG2]);
> +		err = nft_validate_register_load(priv->sreg2, len);
> +		if (err < 0)
> +			return err;
> +		break;
>  	default:
>  		return -EOPNOTSUPP;
>  	}
> @@ -521,6 +543,9 @@ static int nft_meta_set_dump(struct sk_buff *skb, const struct nft_expr *expr)
>  		goto nla_put_failure;
>  	if (nft_dump_register(skb, NFTA_META_SREG, priv->sreg))
>  		goto nla_put_failure;
> +	if (priv->key == NFT_META_VLAN &&
> +	    nft_dump_register(skb, NFTA_META_SREG2, priv->sreg2))
> +		goto nla_put_failure;
>  
>  	return 0;
>  
> -- 
> 1.8.3.1
> 
