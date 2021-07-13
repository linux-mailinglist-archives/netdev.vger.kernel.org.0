Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C86513C76BC
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 20:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234254AbhGMS7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 14:59:36 -0400
Received: from mail.netfilter.org ([217.70.188.207]:38818 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbhGMS7f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 14:59:35 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 18F1862440;
        Tue, 13 Jul 2021 20:56:26 +0200 (CEST)
Date:   Tue, 13 Jul 2021 20:56:41 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        ryder.lee@mediatek.com
Subject: Re: [RFC 3/7] net: ethernet: mtk_eth_soc: implement flow offloading
 to WED devices
Message-ID: <20210713185641.GB26070@salvia>
References: <20210713160745.59707-1-nbd@nbd.name>
 <20210713160745.59707-4-nbd@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210713160745.59707-4-nbd@nbd.name>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 13, 2021 at 06:07:41PM +0200, Felix Fietkau wrote:
> This allows hardware flow offloading from Ethernet to WLAN on MT7622 SoC
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---
>  drivers/net/ethernet/mediatek/mtk_ppe.c       | 18 +++++
>  drivers/net/ethernet/mediatek/mtk_ppe.h       | 14 ++--
>  .../net/ethernet/mediatek/mtk_ppe_offload.c   | 67 ++++++++++++-------
>  include/linux/netdevice.h                     |  7 ++
>  net/core/dev.c                                |  4 ++
>  5 files changed, 78 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethernet/mediatek/mtk_ppe.c
> index 3ad10c793308..472bcd3269a7 100644
> --- a/drivers/net/ethernet/mediatek/mtk_ppe.c
> +++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
> @@ -329,6 +329,24 @@ int mtk_foe_entry_set_pppoe(struct mtk_foe_entry *entry, int sid)
>  	return 0;
>  }
>  
> +int mtk_foe_entry_set_wdma(struct mtk_foe_entry *entry, int wdma_idx, int txq,
> +			   int bss, int wcid)
> +{
> +	struct mtk_foe_mac_info *l2 = mtk_foe_entry_l2(entry);
> +	u32 *ib2 = mtk_foe_entry_ib2(entry);
> +
> +	*ib2 &= ~MTK_FOE_IB2_PORT_MG;
> +	*ib2 |= MTK_FOE_IB2_WDMA_WINFO;
> +	if (wdma_idx)
> +		*ib2 |= MTK_FOE_IB2_WDMA_DEVIDX;
> +
> +	l2->vlan2 = FIELD_PREP(MTK_FOE_VLAN2_WINFO_BSS, bss) |
> +		    FIELD_PREP(MTK_FOE_VLAN2_WINFO_WCID, wcid) |
> +		    FIELD_PREP(MTK_FOE_VLAN2_WINFO_RING, txq);
> +
> +	return 0;
> +}
> +
>  static inline bool mtk_foe_entry_usable(struct mtk_foe_entry *entry)
>  {
>  	return !(entry->ib1 & MTK_FOE_IB1_STATIC) &&
> diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.h b/drivers/net/ethernet/mediatek/mtk_ppe.h
> index 242fb8f2ae65..df8ccaf48171 100644
> --- a/drivers/net/ethernet/mediatek/mtk_ppe.h
> +++ b/drivers/net/ethernet/mediatek/mtk_ppe.h
> @@ -48,9 +48,9 @@ enum {
>  #define MTK_FOE_IB2_DEST_PORT		GENMASK(7, 5)
>  #define MTK_FOE_IB2_MULTICAST		BIT(8)
>  
> -#define MTK_FOE_IB2_WHNAT_QID2		GENMASK(13, 12)
> -#define MTK_FOE_IB2_WHNAT_DEVIDX	BIT(16)
> -#define MTK_FOE_IB2_WHNAT_NAT		BIT(17)
> +#define MTK_FOE_IB2_WDMA_QID2		GENMASK(13, 12)
> +#define MTK_FOE_IB2_WDMA_DEVIDX		BIT(16)
> +#define MTK_FOE_IB2_WDMA_WINFO		BIT(17)
>  
>  #define MTK_FOE_IB2_PORT_MG		GENMASK(17, 12)
>  
> @@ -58,9 +58,9 @@ enum {
>  
>  #define MTK_FOE_IB2_DSCP		GENMASK(31, 24)
>  
> -#define MTK_FOE_VLAN2_WHNAT_BSS		GEMMASK(5, 0)
> -#define MTK_FOE_VLAN2_WHNAT_WCID	GENMASK(13, 6)
> -#define MTK_FOE_VLAN2_WHNAT_RING	GENMASK(15, 14)
> +#define MTK_FOE_VLAN2_WINFO_BSS		GENMASK(5, 0)
> +#define MTK_FOE_VLAN2_WINFO_WCID	GENMASK(13, 6)
> +#define MTK_FOE_VLAN2_WINFO_RING	GENMASK(15, 14)
>  
>  enum {
>  	MTK_FOE_STATE_INVALID,
> @@ -281,6 +281,8 @@ int mtk_foe_entry_set_ipv6_tuple(struct mtk_foe_entry *entry,
>  int mtk_foe_entry_set_dsa(struct mtk_foe_entry *entry, int port);
>  int mtk_foe_entry_set_vlan(struct mtk_foe_entry *entry, int vid);
>  int mtk_foe_entry_set_pppoe(struct mtk_foe_entry *entry, int sid);
> +int mtk_foe_entry_set_wdma(struct mtk_foe_entry *entry, int wdma_idx, int txq,
> +			   int bss, int wcid);
>  int mtk_foe_entry_commit(struct mtk_ppe *ppe, struct mtk_foe_entry *entry,
>  			 u16 timestamp);
>  int mtk_ppe_debugfs_init(struct mtk_ppe *ppe);
> diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
> index b5f68f66d42a..00b1d06f60d1 100644
> --- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
> +++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
> @@ -10,6 +10,7 @@
>  #include <net/pkt_cls.h>
>  #include <net/dsa.h>
>  #include "mtk_eth_soc.h"
> +#include "mtk_wed.h"
>  
>  struct mtk_flow_data {
>  	struct ethhdr eth;
> @@ -39,6 +40,7 @@ struct mtk_flow_entry {
>  	struct rhash_head node;
>  	unsigned long cookie;
>  	u16 hash;
> +	s8 wed_index;
>  };
>  
>  static const struct rhashtable_params mtk_flow_ht_params = {
> @@ -127,35 +129,38 @@ mtk_flow_mangle_ipv4(const struct flow_action_entry *act,
>  }
>  
>  static int
> -mtk_flow_get_dsa_port(struct net_device **dev)
> +mtk_flow_set_output_device(struct mtk_eth *eth, struct mtk_foe_entry *foe,
> +			   struct net_device *dev, const u8 *dest_mac,
> +			   int *wed_index)
>  {
> -#if IS_ENABLED(CONFIG_NET_DSA)
> -	struct dsa_port *dp;
> -
> -	dp = dsa_port_from_netdev(*dev);
> -	if (IS_ERR(dp))
> -		return -ENODEV;
> -
> -	if (dp->cpu_dp->tag_ops->proto != DSA_TAG_PROTO_MTK)
> -		return -ENODEV;
> +	struct net_device_path_ctx ctx = {
> +		.dev    = dev,
> +		.daddr  = dest_mac,
> +	};
> +	struct net_device_path path = {};
> +	int pse_port;
>  
> -	*dev = dp->cpu_dp->master;
> +	if (!dev->netdev_ops->ndo_fill_forward_path ||
> +	    dev->netdev_ops->ndo_fill_forward_path(&ctx, &path) < 0)
> +		path.type = DEV_PATH_ETHERNET;

Maybe expose this through flow offload API so there is no need to call
ndo_fill_forward_path again from the driver?

> -	return dp->index;
> -#else
> -	return -ENODEV;
> -#endif
> -}
> -
> -static int
> -mtk_flow_set_output_device(struct mtk_eth *eth, struct mtk_foe_entry *foe,
> -			   struct net_device *dev)
> -{
> -	int pse_port, dsa_port;
> +	switch (path.type) {
> +	case DEV_PATH_DSA:

This DSA update is not related, right?
