Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E39064BF46
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 19:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbfFSRGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 13:06:48 -0400
Received: from mail.us.es ([193.147.175.20]:58030 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbfFSRGs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 13:06:48 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 26186C1DED
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 19:06:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 14E57DA705
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 19:06:46 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0A23BDA708; Wed, 19 Jun 2019 19:06:46 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F3B7CDA705;
        Wed, 19 Jun 2019 19:06:43 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 19 Jun 2019 19:06:43 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D05B44265A31;
        Wed, 19 Jun 2019 19:06:43 +0200 (CEST)
Date:   Wed, 19 Jun 2019 19:06:43 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@ucloud.cn
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 2/2 nf-next] netfilter: nft_meta: Add NFT_META_BRI_VLAN
 support
Message-ID: <20190619170643.7gw4ohaoogqqybua@salvia>
References: <1560928585-18352-1-git-send-email-wenxu@ucloud.cn>
 <1560928585-18352-2-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1560928585-18352-2-git-send-email-wenxu@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 19, 2019 at 03:16:25PM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> nft add table bridge firewall
> nft add chain bridge firewall zones { type filter hook prerouting priority - 300 \; }
> nft add rule bridge firewall zones counter ct zone set vlan id map { 100 : 1, 200 : 2 }
> 
> As above set the bridge port with pvid, the received packet don't contain
> the vlan tag which means the packet should belong to vlan 200 through pvid.
> With this pacth user can set the pvid in the prerouting hook before set zone
> id and conntrack: "meta brvlan set meta brpvid"

A real ruleset explaining how you use this would help in the commit
message would help. I also would like to see the patch for nftables.

> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
>  include/uapi/linux/netfilter/nf_tables.h |  2 ++
>  net/netfilter/nft_meta.c                 | 20 ++++++++++++++++++++
>  2 files changed, 22 insertions(+)
> 
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index 4a16124..7be0307 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -794,6 +794,7 @@ enum nft_exthdr_attributes {
>   * @NFT_META_IIFKIND: packet input interface kind name (dev->rtnl_link_ops->kind)
>   * @NFT_META_OIFKIND: packet output interface kind name (dev->rtnl_link_ops->kind)
>   * @NFT_META_BRI_PVID: packet input bridge port pvid
> + * @NFT_META_BRI_VLAN: set vlan tag on packet
>   */
>  enum nft_meta_keys {
>  	NFT_META_LEN,
> @@ -825,6 +826,7 @@ enum nft_meta_keys {
>  	NFT_META_IIFKIND,
>  	NFT_META_OIFKIND,
>  	NFT_META_BRI_PVID,
> +	NFT_META_BRI_VLAN,
>  };
>  
>  /**
> diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
> index 1fdb565..5c3817b 100644
> --- a/net/netfilter/nft_meta.c
> +++ b/net/netfilter/nft_meta.c
> @@ -282,8 +282,13 @@ static void nft_meta_set_eval(const struct nft_expr *expr,
>  {
>  	const struct nft_meta *meta = nft_expr_priv(expr);
>  	struct sk_buff *skb = pkt->skb;
> +	const struct net_device *in = nft_in(pkt);
>  	u32 *sreg = &regs->data[meta->sreg];
> +#ifdef CONFIG_NF_TABLES_BRIDGE
> +	const struct net_bridge_port *p;
> +#endif
>  	u32 value = *sreg;
> +	u16 value16;
>  	u8 value8;
>  
>  	switch (meta->key) {
> @@ -306,6 +311,14 @@ static void nft_meta_set_eval(const struct nft_expr *expr,
>  
>  		skb->nf_trace = !!value8;
>  		break;
> +#ifdef CONFIG_NF_TABLES_BRIDGE
> +	case NFT_META_BRI_VLAN:
> +		value16 = nft_reg_load16(sreg);
> +		if (in && (p = br_port_get_rtnl_rcu(in)) &&
> +		    !skb_vlan_tag_present(skb))

Why does this skip if there is a vlan tag?

I guess it should be possible to update an existing vlan tag?

Thanks.
