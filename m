Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85AEF527F3
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 11:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731453AbfFYJXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 05:23:19 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:58178 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726423AbfFYJXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 05:23:19 -0400
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 2C44A41B62;
        Tue, 25 Jun 2019 17:23:07 +0800 (CST)
Subject: Re: [PATCH nf-next v2 1/2] netfilter: nft_meta: add NFT_META_BRI_PVID
 support
From:   wenxu <wenxu@ucloud.cn>
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
References: <1560993460-25569-1-git-send-email-wenxu@ucloud.cn>
Message-ID: <5d8a5ac6-88d4-3a32-ca9b-7fb21077be57@ucloud.cn>
Date:   Tue, 25 Jun 2019 17:23:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <1560993460-25569-1-git-send-email-wenxu@ucloud.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUhXWQgYFAkeWUFZVkpVSExDS0tLSk9LSkJLSklZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Ngw6Eyo5Pzg3FBROFRkvIxoo
        F0wKCTVVSlVKTk1KT05PTkNMTEhMVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBSEJLSzcG
X-HM-Tid: 0a6b8df22def2086kuqy2c44a41b62
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi pablo,


Any idea about these two patches?


BR

wenxu

On 6/20/2019 9:17 AM, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
>
> nft add table bridge firewall
> nft add chain bridge firewall zones { type filter hook prerouting priority - 300 \; }
> nft add rule bridge firewall zones counter ct zone set vlan id map { 100 : 1, 200 : 2 }
>
> As above set the bridge port with pvid, the received packet don't contain
> the vlan tag which means the packet should belong to vlan 200 through pvid.
> With this pacth user can get the pvid of bridge ports.
>
> So add the following rule for as the first rule in the chain of zones.
>
> nft add rule bridge firewall zones counter meta brvlan set meta brpvid
>
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
>  include/uapi/linux/netfilter/nf_tables.h |  2 ++
>  net/netfilter/nft_meta.c                 | 13 +++++++++++++
>  2 files changed, 15 insertions(+)
>
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index 31a6b8f..4a16124 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -793,6 +793,7 @@ enum nft_exthdr_attributes {
>   * @NFT_META_SECPATH: boolean, secpath_exists (!!skb->sp)
>   * @NFT_META_IIFKIND: packet input interface kind name (dev->rtnl_link_ops->kind)
>   * @NFT_META_OIFKIND: packet output interface kind name (dev->rtnl_link_ops->kind)
> + * @NFT_META_BRI_PVID: packet input bridge port pvid
>   */
>  enum nft_meta_keys {
>  	NFT_META_LEN,
> @@ -823,6 +824,7 @@ enum nft_meta_keys {
>  	NFT_META_SECPATH,
>  	NFT_META_IIFKIND,
>  	NFT_META_OIFKIND,
> +	NFT_META_BRI_PVID,
>  };
>  
>  /**
> diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
> index 987d2d6..cb877e01 100644
> --- a/net/netfilter/nft_meta.c
> +++ b/net/netfilter/nft_meta.c
> @@ -243,6 +243,14 @@ void nft_meta_get_eval(const struct nft_expr *expr,
>  			goto err;
>  		strncpy((char *)dest, p->br->dev->name, IFNAMSIZ);
>  		return;
> +	case NFT_META_BRI_PVID:
> +		if (in == NULL || (p = br_port_get_rtnl_rcu(in)) == NULL)
> +			goto err;
> +		if (br_opt_get(p->br, BROPT_VLAN_ENABLED)) {
> +			nft_reg_store16(dest, br_get_pvid(nbp_vlan_group_rcu(p)));
> +			return;
> +		}
> +		goto err;
>  #endif
>  	case NFT_META_IIFKIND:
>  		if (in == NULL || in->rtnl_link_ops == NULL)
> @@ -370,6 +378,11 @@ static int nft_meta_get_init(const struct nft_ctx *ctx,
>  			return -EOPNOTSUPP;
>  		len = IFNAMSIZ;
>  		break;
> +	case NFT_META_BRI_PVID:
> +		if (ctx->family != NFPROTO_BRIDGE)
> +			return -EOPNOTSUPP;
> +		len = sizeof(u16);
> +		break;
>  #endif
>  	default:
>  		return -EOPNOTSUPP;
