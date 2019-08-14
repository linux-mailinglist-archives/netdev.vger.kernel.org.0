Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B766D8CE59
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 10:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726585AbfHNI0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 04:26:47 -0400
Received: from mx2.mailbox.org ([80.241.60.215]:43628 "EHLO mx2.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725280AbfHNI0q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 04:26:46 -0400
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mx2.mailbox.org (Postfix) with ESMTPS id 89BF5A0207;
        Wed, 14 Aug 2019 10:26:44 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter03.heinlein-hosting.de (spamfilter03.heinlein-hosting.de [80.241.56.117]) (amavisd-new, port 10030)
        with ESMTP id qwECdbNVkTdT; Wed, 14 Aug 2019 10:26:30 +0200 (CEST)
Subject: Re: [PATCH] net: ethernet: mediatek: Add MT7628/88 SoC support
To:     =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@openwrt.org>,
        John Crispin <john@phrozen.org>,
        Daniel Golle <daniel@makrotopia.org>
References: <20190717125345.Horde.JcDE_nBChPFDDjEgIRfPSl3@www.vdorst.com>
From:   Stefan Roese <sr@denx.de>
Message-ID: <a92d7207-80b2-e88d-d869-64c9758ef1da@denx.de>
Date:   Wed, 14 Aug 2019 10:26:29 +0200
MIME-Version: 1.0
In-Reply-To: <20190717125345.Horde.JcDE_nBChPFDDjEgIRfPSl3@www.vdorst.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rene,

On 17.07.19 14:53, René van Dorst wrote:

<snip>

>> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
>> @@ -39,7 +39,8 @@
>>   				 NETIF_F_SG | NETIF_F_TSO | \
>>   				 NETIF_F_TSO6 | \
>>   				 NETIF_F_IPV6_CSUM)
>> -#define NEXT_RX_DESP_IDX(X, Y)	(((X) + 1) & ((Y) - 1))
>> +#define MTK_HW_FEATURES_MT7628	(NETIF_F_SG | NETIF_F_RXCSUM)
>> +#define NEXT_DESP_IDX(X, Y)	(((X) + 1) & ((Y) - 1))
>>
>>   #define MTK_MAX_RX_RING_NUM	4
>>   #define MTK_HW_LRO_DMA_SIZE	8
>> @@ -118,6 +119,7 @@
>>   /* PDMA Global Configuration Register */
>>   #define MTK_PDMA_GLO_CFG	0xa04
>>   #define MTK_MULTI_EN		BIT(10)
>> +#define MTK_PDMA_SIZE_8DWORDS	(1 << 4)
>>
>>   /* PDMA Reset Index Register */
>>   #define MTK_PDMA_RST_IDX	0xa08
>> @@ -276,11 +278,18 @@
>>   #define TX_DMA_OWNER_CPU	BIT(31)
>>   #define TX_DMA_LS0		BIT(30)
>>   #define TX_DMA_PLEN0(_x)	(((_x) & MTK_TX_DMA_BUF_LEN) << 16)
>> +#define TX_DMA_PLEN1(_x)	((_x) & MTK_TX_DMA_BUF_LEN)
>>   #define TX_DMA_SWC		BIT(14)
>>   #define TX_DMA_SDL(_x)		(((_x) & 0x3fff) << 16)
>>
>> +/* PDMA on MT7628 */
>> +#define TX_DMA_DONE		BIT(31)
>> +#define TX_DMA_LS1		BIT(14)
>> +#define TX_DMA_DESP2_DEF	(TX_DMA_LS0 | TX_DMA_DONE)
>> +
>>   /* QDMA descriptor rxd2 */
>>   #define RX_DMA_DONE		BIT(31)
>> +#define RX_DMA_LSO		BIT(30)
>>   #define RX_DMA_PLEN0(_x)	(((_x) & 0x3fff) << 16)
>>   #define RX_DMA_GET_PLEN0(_x)	(((_x) >> 16) & 0x3fff)
>>
>> @@ -289,6 +298,7 @@
>>
>>   /* QDMA descriptor rxd4 */
>>   #define RX_DMA_L4_VALID		BIT(24)
>> +#define RX_DMA_L4_VALID_PDMA	BIT(30)		/* when PDMA is used */
>>   #define RX_DMA_FPORT_SHIFT	19
>>   #define RX_DMA_FPORT_MASK	0x7
>>
>> @@ -412,6 +422,19 @@
>>   #define CO_QPHY_SEL            BIT(0)
>>   #define GEPHY_MAC_SEL          BIT(1)
>>
>> +/* MT7628/88 specific stuff */
>> +#define MT7628_PDMA_OFFSET	0x0800
>> +#define MT7628_SDM_OFFSET	0x0c00
>> +
>> +#define MT7628_TX_BASE_PTR0	(MT7628_PDMA_OFFSET + 0x00)
>> +#define MT7628_TX_MAX_CNT0	(MT7628_PDMA_OFFSET + 0x04)
>> +#define MT7628_TX_CTX_IDX0	(MT7628_PDMA_OFFSET + 0x08)
>> +#define MT7628_TX_DTX_IDX0	(MT7628_PDMA_OFFSET + 0x0c)
>> +#define MT7628_PST_DTX_IDX0	BIT(0)
>> +
>> +#define MT7628_SDM_MAC_ADRL	(MT7628_SDM_OFFSET + 0x0c)
>> +#define MT7628_SDM_MAC_ADRH	(MT7628_SDM_OFFSET + 0x10)
>> +
>>   struct mtk_rx_dma {
>>   	unsigned int rxd1;
>>   	unsigned int rxd2;
>> @@ -509,6 +532,7 @@ enum mtk_clks_map {
>>   				 BIT(MTK_CLK_SGMII_CK) | \
>>   				 BIT(MTK_CLK_ETH2PLL))
>>   #define MT7621_CLKS_BITMAP	(0)
>> +#define MT7628_CLKS_BITMAP	(0)
>>   #define MT7629_CLKS_BITMAP	(BIT(MTK_CLK_ETHIF) | BIT(MTK_CLK_ESW) |  \
>>   				 BIT(MTK_CLK_GP0) | BIT(MTK_CLK_GP1) | \
>>   				 BIT(MTK_CLK_GP2) | BIT(MTK_CLK_FE) | \
>> @@ -563,6 +587,10 @@ struct mtk_tx_ring {
>>   	struct mtk_tx_dma *last_free;
>>   	u16 thresh;
>>   	atomic_t free_count;
>> +	int dma_size;
>> +	struct mtk_tx_dma *dma_pdma;	/* For MT7628/88 PDMA handling */
>> +	dma_addr_t phys_pdma;
>> +	int cpu_idx;
>>   };
>>
>>   /* PDMA rx ring mode */
>> @@ -604,6 +632,7 @@ enum mkt_eth_capabilities {
>>   	MTK_HWLRO_BIT,
>>   	MTK_SHARED_INT_BIT,
>>   	MTK_TRGMII_MT7621_CLK_BIT,
>> +	MTK_SOC_MT7628,
> 
> This should be MTK_SOC_MT7628_BIT, this only defines the bit number!
> 
> and futher on #define MTK_SOC_MT7628 BIT(MTK_SOC_MT7628_BIT)

Okay, thanks.
  
> Based on this commit [0], MT7621 also needs the PDMA for the RX path.
> I know that is not your issue but I think it is better to add a extra
> capability bit for the PDMA bits so it can also be used on other socs.

Yes, MT7621 also uses PDMA for RX. The code for RX is pretty much
shared (re-used), with slight changes for the MT7628/88 to work
correctly on this SoC.

I'll work on a capability bit for PDMA vs QDMA on TX though. This
might make things a little more transparent.
  
> Greats,
> 
> René
> 
> [0] https://lkml.org/lkml/2018/3/14/1038

Thanks,
Stefan
