Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBAC13C7FF8
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 10:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238469AbhGNI3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 04:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbhGNI3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 04:29:03 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83F18C06175F;
        Wed, 14 Jul 2021 01:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Sv0Tb2h7rxwxRk1X2Igl1UV5dheZIeRkSJaiEEevdHY=; b=sTS6CWEFgspO/mAzLph0mBWUHo
        CPBR/HeaJ48EpY5ennHo45ZWHTV1u94Y6eYEaVRhPBKTHfCt7VM9h0ewd7dnpVjITz/3VaYsni2mc
        O0h8jKH7qR/9l4wS40ocmCrtGrwneo5n67tULkNTvidgkrMdwrFx0+yAV5BlA4xlVvwY=;
Received: from p54ae93f7.dip0.t-ipconnect.de ([84.174.147.247] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1m3aDZ-0001JC-2u; Wed, 14 Jul 2021 10:26:09 +0200
Subject: Re: [RFC 3/7] net: ethernet: mtk_eth_soc: implement flow offloading
 to WED devices
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        ryder.lee@mediatek.com
References: <20210713160745.59707-1-nbd@nbd.name>
 <20210713160745.59707-4-nbd@nbd.name> <20210713185641.GB26070@salvia>
From:   Felix Fietkau <nbd@nbd.name>
Message-ID: <ceee6c30-adc1-3a79-31c3-983fe848699c@nbd.name>
Date:   Wed, 14 Jul 2021 10:26:08 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210713185641.GB26070@salvia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021-07-13 20:56, Pablo Neira Ayuso wrote:
> On Tue, Jul 13, 2021 at 06:07:41PM +0200, Felix Fietkau wrote:
>> This allows hardware flow offloading from Ethernet to WLAN on MT7622 SoC
>> 
>> Signed-off-by: Felix Fietkau <nbd@nbd.name>
>> ---
>>  drivers/net/ethernet/mediatek/mtk_ppe.c       | 18 +++++
>>  drivers/net/ethernet/mediatek/mtk_ppe.h       | 14 ++--
>>  .../net/ethernet/mediatek/mtk_ppe_offload.c   | 67 ++++++++++++-------
>>  include/linux/netdevice.h                     |  7 ++
>>  net/core/dev.c                                |  4 ++
>>  5 files changed, 78 insertions(+), 32 deletions(-)
>> 
>> diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethernet/mediatek/mtk_ppe.c
>> index 3ad10c793308..472bcd3269a7 100644
>> --- a/drivers/net/ethernet/mediatek/mtk_ppe.c
>> +++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
>> @@ -329,6 +329,24 @@ int mtk_foe_entry_set_pppoe(struct mtk_foe_entry *entry, int sid)
>>  	return 0;
>>  }
>>  
>> +int mtk_foe_entry_set_wdma(struct mtk_foe_entry *entry, int wdma_idx, int txq,
>> +			   int bss, int wcid)
>> +{
>> +	struct mtk_foe_mac_info *l2 = mtk_foe_entry_l2(entry);
>> +	u32 *ib2 = mtk_foe_entry_ib2(entry);
>> +
>> +	*ib2 &= ~MTK_FOE_IB2_PORT_MG;
>> +	*ib2 |= MTK_FOE_IB2_WDMA_WINFO;
>> +	if (wdma_idx)
>> +		*ib2 |= MTK_FOE_IB2_WDMA_DEVIDX;
>> +
>> +	l2->vlan2 = FIELD_PREP(MTK_FOE_VLAN2_WINFO_BSS, bss) |
>> +		    FIELD_PREP(MTK_FOE_VLAN2_WINFO_WCID, wcid) |
>> +		    FIELD_PREP(MTK_FOE_VLAN2_WINFO_RING, txq);
>> +
>> +	return 0;
>> +}
>> +
>>  static inline bool mtk_foe_entry_usable(struct mtk_foe_entry *entry)
>>  {
>>  	return !(entry->ib1 & MTK_FOE_IB1_STATIC) &&
>> diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.h b/drivers/net/ethernet/mediatek/mtk_ppe.h
>> index 242fb8f2ae65..df8ccaf48171 100644
>> --- a/drivers/net/ethernet/mediatek/mtk_ppe.h
>> +++ b/drivers/net/ethernet/mediatek/mtk_ppe.h
>> @@ -48,9 +48,9 @@ enum {
>>  #define MTK_FOE_IB2_DEST_PORT		GENMASK(7, 5)
>>  #define MTK_FOE_IB2_MULTICAST		BIT(8)
>>  
>> -#define MTK_FOE_IB2_WHNAT_QID2		GENMASK(13, 12)
>> -#define MTK_FOE_IB2_WHNAT_DEVIDX	BIT(16)
>> -#define MTK_FOE_IB2_WHNAT_NAT		BIT(17)
>> +#define MTK_FOE_IB2_WDMA_QID2		GENMASK(13, 12)
>> +#define MTK_FOE_IB2_WDMA_DEVIDX		BIT(16)
>> +#define MTK_FOE_IB2_WDMA_WINFO		BIT(17)
>>  
>>  #define MTK_FOE_IB2_PORT_MG		GENMASK(17, 12)
>>  
>> @@ -58,9 +58,9 @@ enum {
>>  
>>  #define MTK_FOE_IB2_DSCP		GENMASK(31, 24)
>>  
>> -#define MTK_FOE_VLAN2_WHNAT_BSS		GEMMASK(5, 0)
>> -#define MTK_FOE_VLAN2_WHNAT_WCID	GENMASK(13, 6)
>> -#define MTK_FOE_VLAN2_WHNAT_RING	GENMASK(15, 14)
>> +#define MTK_FOE_VLAN2_WINFO_BSS		GENMASK(5, 0)
>> +#define MTK_FOE_VLAN2_WINFO_WCID	GENMASK(13, 6)
>> +#define MTK_FOE_VLAN2_WINFO_RING	GENMASK(15, 14)
>>  
>>  enum {
>>  	MTK_FOE_STATE_INVALID,
>> @@ -281,6 +281,8 @@ int mtk_foe_entry_set_ipv6_tuple(struct mtk_foe_entry *entry,
>>  int mtk_foe_entry_set_dsa(struct mtk_foe_entry *entry, int port);
>>  int mtk_foe_entry_set_vlan(struct mtk_foe_entry *entry, int vid);
>>  int mtk_foe_entry_set_pppoe(struct mtk_foe_entry *entry, int sid);
>> +int mtk_foe_entry_set_wdma(struct mtk_foe_entry *entry, int wdma_idx, int txq,
>> +			   int bss, int wcid);
>>  int mtk_foe_entry_commit(struct mtk_ppe *ppe, struct mtk_foe_entry *entry,
>>  			 u16 timestamp);
>>  int mtk_ppe_debugfs_init(struct mtk_ppe *ppe);
>> diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
>> index b5f68f66d42a..00b1d06f60d1 100644
>> --- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
>> +++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
>> @@ -10,6 +10,7 @@
>>  #include <net/pkt_cls.h>
>>  #include <net/dsa.h>
>>  #include "mtk_eth_soc.h"
>> +#include "mtk_wed.h"
>>  
>>  struct mtk_flow_data {
>>  	struct ethhdr eth;
>> @@ -39,6 +40,7 @@ struct mtk_flow_entry {
>>  	struct rhash_head node;
>>  	unsigned long cookie;
>>  	u16 hash;
>> +	s8 wed_index;
>>  };
>>  
>>  static const struct rhashtable_params mtk_flow_ht_params = {
>> @@ -127,35 +129,38 @@ mtk_flow_mangle_ipv4(const struct flow_action_entry *act,
>>  }
>>  
>>  static int
>> -mtk_flow_get_dsa_port(struct net_device **dev)
>> +mtk_flow_set_output_device(struct mtk_eth *eth, struct mtk_foe_entry *foe,
>> +			   struct net_device *dev, const u8 *dest_mac,
>> +			   int *wed_index)
>>  {
>> -#if IS_ENABLED(CONFIG_NET_DSA)
>> -	struct dsa_port *dp;
>> -
>> -	dp = dsa_port_from_netdev(*dev);
>> -	if (IS_ERR(dp))
>> -		return -ENODEV;
>> -
>> -	if (dp->cpu_dp->tag_ops->proto != DSA_TAG_PROTO_MTK)
>> -		return -ENODEV;
>> +	struct net_device_path_ctx ctx = {
>> +		.dev    = dev,
>> +		.daddr  = dest_mac,
>> +	};
>> +	struct net_device_path path = {};
>> +	int pse_port;
>>  
>> -	*dev = dp->cpu_dp->master;
>> +	if (!dev->netdev_ops->ndo_fill_forward_path ||
>> +	    dev->netdev_ops->ndo_fill_forward_path(&ctx, &path) < 0)
>> +		path.type = DEV_PATH_ETHERNET;
> 
> Maybe expose this through flow offload API so there is no need to call
> ndo_fill_forward_path again from the driver?
Can you give me a pseudo-code example? I'm not sure how you want it to
be exposed through the flow offload API.
To me it seems easier and cleaner to just have a single
ndo_fill_forward_path call for the final output device to check the
device types that don't have any corresponding sw offload.

>> -	return dp->index;
>> -#else
>> -	return -ENODEV;
>> -#endif
>> -}
>> -
>> -static int
>> -mtk_flow_set_output_device(struct mtk_eth *eth, struct mtk_foe_entry *foe,
>> -			   struct net_device *dev)
>> -{
>> -	int pse_port, dsa_port;
>> +	switch (path.type) {
>> +	case DEV_PATH_DSA:
> 
> This DSA update is not related, right?
I consider it related. Since I'm calling ndo_fill_forward_path now, it's
better to use it for both DSA and WLAN instead of having independent checks.

- Felix
