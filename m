Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4016F53DC9A
	for <lists+netdev@lfdr.de>; Sun,  5 Jun 2022 17:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345608AbiFEPiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jun 2022 11:38:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238133AbiFEPiD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jun 2022 11:38:03 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 040C52C64C;
        Sun,  5 Jun 2022 08:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=fage9o/WkrlxF6CHaFSVzs3PXs0ms4frqc7xdvWybXY=; b=Ld+ZYslRThTJYx7sMAt/vrjFI6
        IklFvvGj0QTnGKp/EkPLgktZvia+CIDqH9Imv+DaGiA5TyTs52f7vkeskXB7uj7d2HAOOmvf7NToQ
        nrLe9ZY8V0eos9i8IFGrSc3VLv6ivkVuHlzOCIqvXcDKoWtz9maiSDDZWQoAhLiDuS8o=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nxsKA-005eXu-EB; Sun, 05 Jun 2022 17:37:54 +0200
Date:   Sun, 5 Jun 2022 17:37:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Puranjay Mohan <p-mohan@ti.com>
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, krzysztof.kozlowski+dt@linaro.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org, nm@ti.com,
        ssantosh@kernel.org, s-anna@ti.com,
        linux-arm-kernel@lists.infradead.org, rogerq@kernel.org,
        grygorii.strashko@ti.com, vigneshr@ti.com, kishon@ti.com,
        robh+dt@kernel.org, afd@ti.com
Subject: Re: [PATCH v2 2/2] net: ti: icssg-prueth: Add ICSSG ethernet driver
Message-ID: <YpzN0u+hRgVuzPX9@lunn.ch>
References: <20220531095108.21757-1-p-mohan@ti.com>
 <20220531095108.21757-3-p-mohan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220531095108.21757-3-p-mohan@ti.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static inline u32 addr_to_da0(const u8 *addr)
> +{
> +	return (u32)(addr[0] | addr[1] << 8 |
> +		addr[2] << 16 | addr[3] << 24);
> +};
> +
> +static inline u32 addr_to_da1(const u8 *addr)
> +{
> +	return (u32)(addr[4] | addr[5] << 8);
> +};

No inline functions please.

> +
> +static void rx_class_ft1_set_start_len(struct regmap *miig_rt, int slice,
> +				       u16 start, u8 len)
> +{
> +	u32 offset, val;
> +
> +	offset = offs[slice].ft1_start_len;
> +	val = FT1_LEN(len) | FT1_START(start);
> +	regmap_write(miig_rt, offset, val);
> +}
> +
> +static void rx_class_ft1_set_da(struct regmap *miig_rt, int slice,
> +				int n, const u8 *addr)
> +{
> +	u32 offset;
> +
> +	offset = FT1_N_REG(slice, n, FT1_DA0);
> +	regmap_write(miig_rt, offset, addr_to_da0(addr));
> +	offset = FT1_N_REG(slice, n, FT1_DA1);
> +	regmap_write(miig_rt, offset, addr_to_da1(addr));
> +}
> +
> +static void rx_class_ft1_set_da_mask(struct regmap *miig_rt, int slice,
> +				     int n, const u8 *addr)
> +{
> +	u32 offset;
> +
> +	offset = FT1_N_REG(slice, n, FT1_DA0_MASK);
> +	regmap_write(miig_rt, offset, addr_to_da0(addr));
> +	offset = FT1_N_REG(slice, n, FT1_DA1_MASK);
> +	regmap_write(miig_rt, offset, addr_to_da1(addr));
> +}
> +
> +static void rx_class_ft1_cfg_set_type(struct regmap *miig_rt, int slice, int n,
> +				      enum ft1_cfg_type type)
> +{
> +	u32 offset;
> +
> +	offset = offs[slice].ft1_cfg;
> +	regmap_update_bits(miig_rt, offset, FT1_CFG_MASK(n),
> +			   type << FT1_CFG_SHIFT(n));
> +}
> +
> +static void rx_class_sel_set_type(struct regmap *miig_rt, int slice, int n,
> +				  enum rx_class_sel_type type)
> +{
> +	u32 offset;
> +
> +	offset = offs[slice].rx_class_cfg1;
> +	regmap_update_bits(miig_rt, offset, RX_CLASS_SEL_MASK(n),
> +			   type << RX_CLASS_SEL_SHIFT(n));
> +}
> +
> +static void rx_class_set_and(struct regmap *miig_rt, int slice, int n,
> +			     u32 data)
> +{
> +	u32 offset;
> +
> +	offset = RX_CLASS_N_REG(slice, n, RX_CLASS_AND_EN);
> +	regmap_write(miig_rt, offset, data);
> +}
> +
> +static void rx_class_set_or(struct regmap *miig_rt, int slice, int n,
> +			    u32 data)
> +{
> +	u32 offset;
> +
> +	offset = RX_CLASS_N_REG(slice, n, RX_CLASS_OR_EN);
> +	regmap_write(miig_rt, offset, data);
> +}
> +
> +void icssg_class_set_host_mac_addr(struct regmap *miig_rt, const u8 *mac)
> +{
> +	regmap_write(miig_rt, MAC_INTERFACE_0, addr_to_da0(mac));
> +	regmap_write(miig_rt, MAC_INTERFACE_1, addr_to_da1(mac));
> +}
> +
> +void icssg_class_set_mac_addr(struct regmap *miig_rt, int slice, u8 *mac)
> +{
> +	regmap_write(miig_rt, offs[slice].mac0, addr_to_da0(mac));
> +	regmap_write(miig_rt, offs[slice].mac1, addr_to_da1(mac));
> +}
> +
> +/* disable all RX traffic */
> +void icssg_class_disable(struct regmap *miig_rt, int slice)
> +{
> +	u32 data, offset;
> +	int n;
> +
> +	/* Enable RX_L2_G */
> +	regmap_update_bits(miig_rt, ICSSG_CFG_OFFSET, ICSSG_CFG_RX_L2_G_EN,
> +			   ICSSG_CFG_RX_L2_G_EN);
> +
> +	for (n = 0; n < ICSSG_NUM_CLASSIFIERS; n++) {
> +		/* AND_EN = 0 */
> +		rx_class_set_and(miig_rt, slice, n, 0);
> +		/* OR_EN = 0 */
> +		rx_class_set_or(miig_rt, slice, n, 0);
> +
> +		/* set CFG1 to OR */
> +		rx_class_sel_set_type(miig_rt, slice, n, RX_CLASS_SEL_TYPE_OR);
> +
> +		/* configure gate */
> +		offset = RX_CLASS_GATES_N_REG(slice, n);
> +		regmap_read(miig_rt, offset, &data);
> +		/* clear class_raw so we go through filters */
> +		data &= ~RX_CLASS_GATES_RAW_MASK;
> +		/* set allow and phase mask */
> +		data |= RX_CLASS_GATES_ALLOW_MASK | RX_CLASS_GATES_PHASE_MASK;
> +		regmap_write(miig_rt, offset, data);
> +	}
> +
> +	/* FT1 Disabled */
> +	for (n = 0; n < ICSSG_NUM_FT1_SLOTS; n++) {
> +		u8 addr[] = { 0, 0, 0, 0, 0, 0, };
> +
> +		rx_class_ft1_cfg_set_type(miig_rt, slice, n,
> +					  FT1_CFG_TYPE_DISABLED);
> +		rx_class_ft1_set_da(miig_rt, slice, n, addr);
> +		rx_class_ft1_set_da_mask(miig_rt, slice, n, addr);
> +	}
> +
> +	/* clear CFG2 */
> +	regmap_write(miig_rt, offs[slice].rx_class_cfg2, 0);
> +}
> +
> +void icssg_class_default(struct regmap *miig_rt, int slice, bool allmulti)
> +{
> +	int classifiers_in_use = 1;
> +	u32 data;
> +	int n;
> +
> +	/* defaults */
> +	icssg_class_disable(miig_rt, slice);
> +
> +	/* Setup Classifier */
> +	for (n = 0; n < classifiers_in_use; n++) {
> +		/* match on Broadcast or MAC_PRU address */
> +		data = RX_CLASS_FT_BC | RX_CLASS_FT_DA_P;
> +
> +		/* multicast? */
> +		if (allmulti)
> +			data |= RX_CLASS_FT_MC;
> +
> +		rx_class_set_or(miig_rt, slice, n, data);
> +
> +		/* set CFG1 for OR_OR_AND for classifier */
> +		rx_class_sel_set_type(miig_rt, slice, n,
> +				      RX_CLASS_SEL_TYPE_OR_OR_AND);
> +	}
> +
> +	/* clear CFG2 */
> +	regmap_write(miig_rt, offs[slice].rx_class_cfg2, 0);
> +}
> +
> +/* required for SAV check */
> +void icssg_ft1_set_mac_addr(struct regmap *miig_rt, int slice, u8 *mac_addr)
> +{
> +	u8 mask_addr[] = { 0, 0, 0, 0, 0, 0, };
> +
> +	rx_class_ft1_set_start_len(miig_rt, slice, 0, 6);
> +	rx_class_ft1_set_da(miig_rt, slice, 0, mac_addr);
> +	rx_class_ft1_set_da_mask(miig_rt, slice, 0, mask_addr);
> +	rx_class_ft1_cfg_set_type(miig_rt, slice, 0, FT1_CFG_TYPE_EQ);
> +}
> diff --git a/drivers/net/ethernet/ti/icssg_config.c b/drivers/net/ethernet/ti/icssg_config.c
> new file mode 100644
> index 000000000000..a88ea4933802
> --- /dev/null
> +++ b/drivers/net/ethernet/ti/icssg_config.c
> @@ -0,0 +1,440 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* ICSSG Ethernet driver
> + *
> + * Copyright (C) 2022 Texas Instruments Incorporated - https://www.ti.com
> + */
> +
> +#include <linux/iopoll.h>
> +#include <linux/regmap.h>
> +#include <uapi/linux/if_ether.h>
> +#include "icssg_config.h"
> +#include "icssg_prueth.h"
> +#include "icssg_switch_map.h"
> +#include "icssg_mii_rt.h"
> +
> +/* TX IPG Values to be set for 100M link speed. These values are
> + * in ocp_clk cycles. So need change if ocp_clk is changed for a specific
> + * h/w design.
> + */
> +
> +/* IPG is in core_clk cycles */
> +#define MII_RT_TX_IPG_100M	0x17
> +#define MII_RT_TX_IPG_1G	0xb
> +
> +#define	ICSSG_QUEUES_MAX		64
> +#define	ICSSG_QUEUE_OFFSET		0xd00
> +#define	ICSSG_QUEUE_PEEK_OFFSET		0xe00
> +#define	ICSSG_QUEUE_CNT_OFFSET		0xe40
> +#define	ICSSG_QUEUE_RESET_OFFSET	0xf40
> +
> +#define	ICSSG_NUM_TX_QUEUES	8
> +
> +#define	RECYCLE_Q_SLICE0	16
> +#define	RECYCLE_Q_SLICE1	17
> +
> +#define	ICSSG_NUM_OTHER_QUEUES	5	/* port, host and special queues */
> +
> +#define	PORT_HI_Q_SLICE0	32
> +#define	PORT_LO_Q_SLICE0	33
> +#define	HOST_HI_Q_SLICE0	34
> +#define	HOST_LO_Q_SLICE0	35
> +#define	HOST_SPL_Q_SLICE0	40	/* Special Queue */
> +
> +#define	PORT_HI_Q_SLICE1	36
> +#define	PORT_LO_Q_SLICE1	37
> +#define	HOST_HI_Q_SLICE1	38
> +#define	HOST_LO_Q_SLICE1	39
> +#define	HOST_SPL_Q_SLICE1	41	/* Special Queue */
> +
> +#define MII_RXCFG_DEFAULT	(PRUSS_MII_RT_RXCFG_RX_ENABLE | \
> +				 PRUSS_MII_RT_RXCFG_RX_DATA_RDY_MODE_DIS | \
> +				 PRUSS_MII_RT_RXCFG_RX_L2_EN | \
> +				 PRUSS_MII_RT_RXCFG_RX_L2_EOF_SCLR_DIS)
> +
> +#define MII_TXCFG_DEFAULT	(PRUSS_MII_RT_TXCFG_TX_ENABLE | \
> +				 PRUSS_MII_RT_TXCFG_TX_AUTO_PREAMBLE | \
> +				 PRUSS_MII_RT_TXCFG_TX_32_MODE_EN | \
> +				 PRUSS_MII_RT_TXCFG_TX_IPG_WIRE_CLK_EN)
> +
> +#define ICSSG_CFG_DEFAULT	(ICSSG_CFG_TX_L1_EN | \
> +				 ICSSG_CFG_TX_L2_EN | ICSSG_CFG_RX_L2_G_EN | \
> +				 ICSSG_CFG_TX_PRU_EN | \
> +				 ICSSG_CFG_SGMII_MODE)
> +
> +#define FDB_GEN_CFG1		0x60
> +#define SMEM_VLAN_OFFSET	8
> +#define SMEM_VLAN_OFFSET_MASK	GENMASK(25, 8)
> +
> +#define FDB_GEN_CFG2		0x64
> +#define FDB_VLAN_EN		BIT(6)
> +#define FDB_HOST_EN		BIT(2)
> +#define FDB_PRU1_EN		BIT(1)
> +#define FDB_PRU0_EN		BIT(0)
> +#define FDB_EN_ALL		(FDB_PRU0_EN | FDB_PRU1_EN | \
> +				 FDB_HOST_EN | FDB_VLAN_EN)
> +
> +struct map {
> +	int queue;
> +	u32 pd_addr_start;
> +	u32 flags;
> +	bool special;
> +};
> +
> +struct map hwq_map[2][ICSSG_NUM_OTHER_QUEUES] = {
> +	{
> +		{ PORT_HI_Q_SLICE0, PORT_DESC0_HI, 0x200000, 0 },
> +		{ PORT_LO_Q_SLICE0, PORT_DESC0_LO, 0, 0 },
> +		{ HOST_HI_Q_SLICE0, HOST_DESC0_HI, 0x200000, 0 },
> +		{ HOST_LO_Q_SLICE0, HOST_DESC0_LO, 0, 0 },
> +		{ HOST_SPL_Q_SLICE0, HOST_SPPD0, 0x400000, 1 },
> +	},
> +	{
> +		{ PORT_HI_Q_SLICE1, PORT_DESC1_HI, 0xa00000, 0 },
> +		{ PORT_LO_Q_SLICE1, PORT_DESC1_LO, 0x800000, 0 },
> +		{ HOST_HI_Q_SLICE1, HOST_DESC1_HI, 0xa00000, 0 },
> +		{ HOST_LO_Q_SLICE1, HOST_DESC1_LO, 0x800000, 0 },
> +		{ HOST_SPL_Q_SLICE1, HOST_SPPD1, 0xc00000, 1 },
> +	},
> +};
> +
> +static void icssg_config_mii_init(struct prueth_emac *emac)
> +{
> +	struct prueth *prueth = emac->prueth;
> +	struct regmap *mii_rt = prueth->mii_rt;
> +	int slice = prueth_emac_slice(emac);
> +	u32 rxcfg_reg, txcfg_reg, pcnt_reg;
> +	u32 rxcfg, txcfg;
> +
> +	rxcfg_reg = (slice == ICSS_MII0) ? PRUSS_MII_RT_RXCFG0 :
> +				       PRUSS_MII_RT_RXCFG1;
> +	txcfg_reg = (slice == ICSS_MII0) ? PRUSS_MII_RT_TXCFG0 :
> +				       PRUSS_MII_RT_TXCFG1;
> +	pcnt_reg = (slice == ICSS_MII0) ? PRUSS_MII_RT_RX_PCNT0 :
> +				       PRUSS_MII_RT_RX_PCNT1;
> +
> +	rxcfg = MII_RXCFG_DEFAULT;
> +	txcfg = MII_TXCFG_DEFAULT;
> +
> +	if (slice == ICSS_MII1)
> +		rxcfg |= PRUSS_MII_RT_RXCFG_RX_MUX_SEL;
> +
> +	/* In MII mode TX lines swapped inside ICSSG, so TX_MUX_SEL cfg need
> +	 * to be swapped also comparing to RGMII mode.
> +	 */
> +	if (emac->phy_if == PHY_INTERFACE_MODE_MII && slice == ICSS_MII0)
> +		txcfg |= PRUSS_MII_RT_TXCFG_TX_MUX_SEL;
> +	else if (emac->phy_if != PHY_INTERFACE_MODE_MII && slice == ICSS_MII1)
> +		txcfg |= PRUSS_MII_RT_TXCFG_TX_MUX_SEL;
> +
> +	regmap_write(mii_rt, rxcfg_reg, rxcfg);
> +	regmap_write(mii_rt, txcfg_reg, txcfg);
> +	regmap_write(mii_rt, pcnt_reg, 0x1);
> +}
> +
> +static void icssg_miig_queues_init(struct prueth *prueth, int slice)
> +{
> +	struct regmap *miig_rt = prueth->miig_rt;
> +	void __iomem *smem = prueth->shram.va;
> +	u8 pd[ICSSG_SPECIAL_PD_SIZE];
> +	int queue = 0, i, j;
> +	u32 *pdword;
> +
> +	/* reset hwqueues */
> +	if (slice)
> +		queue = ICSSG_NUM_TX_QUEUES;
> +
> +	for (i = 0; i < ICSSG_NUM_TX_QUEUES; i++) {
> +		regmap_write(miig_rt, ICSSG_QUEUE_RESET_OFFSET, queue);
> +		queue++;
> +	}
> +
> +	queue = slice ? RECYCLE_Q_SLICE1 : RECYCLE_Q_SLICE0;
> +	regmap_write(miig_rt, ICSSG_QUEUE_RESET_OFFSET, queue);
> +
> +	for (i = 0; i < ICSSG_NUM_OTHER_QUEUES; i++) {
> +		regmap_write(miig_rt, ICSSG_QUEUE_RESET_OFFSET,
> +			     hwq_map[slice][i].queue);
> +	}
> +
> +	/* initialize packet descriptors in SMEM */
> +	/* push pakcet descriptors to hwqueues */
> +
> +	pdword = (u32 *)pd;
> +	for (j = 0; j < ICSSG_NUM_OTHER_QUEUES; j++) {
> +		struct map *mp;
> +		int pd_size, num_pds;
> +		u32 pdaddr;
> +
> +		mp = &hwq_map[slice][j];
> +		if (mp->special) {
> +			pd_size = ICSSG_SPECIAL_PD_SIZE;
> +			num_pds = ICSSG_NUM_SPECIAL_PDS;
> +		} else	{
> +			pd_size = ICSSG_NORMAL_PD_SIZE;
> +			num_pds = ICSSG_NUM_NORMAL_PDS;
> +		}
> +
> +		for (i = 0; i < num_pds; i++) {
> +			memset(pd, 0, pd_size);
> +
> +			pdword[0] &= cpu_to_le32(ICSSG_FLAG_MASK);
> +			pdword[0] |= cpu_to_le32(mp->flags);
> +			pdaddr = mp->pd_addr_start + i * pd_size;
> +
> +			memcpy_toio(smem + pdaddr, pd, pd_size);
> +			queue = mp->queue;
> +			regmap_write(miig_rt, ICSSG_QUEUE_OFFSET + 4 * queue,
> +				     pdaddr);
> +		}
> +	}
> +}
> +
> +void icssg_config_ipg(struct prueth_emac *emac)
> +{
> +	struct prueth *prueth = emac->prueth;
> +	int slice = prueth_emac_slice(emac);
> +
> +	switch (emac->speed) {
> +	case SPEED_1000:
> +		icssg_mii_update_ipg(prueth->mii_rt, slice, MII_RT_TX_IPG_1G);
> +		break;
> +	case SPEED_100:
> +		icssg_mii_update_ipg(prueth->mii_rt, slice, MII_RT_TX_IPG_100M);
> +		break;
> +	default:
> +		/* Other links speeds not supported */
> +		netdev_err(emac->ndev, "Unsupported link speed\n");
> +		return;
> +	}
> +}
> +
> +static void emac_r30_cmd_init(struct prueth_emac *emac)
> +{
> +	int i;
> +	struct icssg_r30_cmd *p;
> +
> +	p = emac->dram.va + MGR_R30_CMD_OFFSET;
> +
> +	for (i = 0; i < 4; i++)
> +		writel(EMAC_NONE, &p->cmd[i]);
> +}
> +
> +static int emac_r30_is_done(struct prueth_emac *emac)
> +{
> +	const struct icssg_r30_cmd *p;
> +	int i;
> +	u32 cmd;
> +
> +	p = emac->dram.va + MGR_R30_CMD_OFFSET;
> +
> +	for (i = 0; i < 4; i++) {
> +		cmd = readl(&p->cmd[i]);
> +		if (cmd != EMAC_NONE)
> +			return 0;
> +	}
> +
> +	return 1;
> +}
> +
> +static int prueth_emac_buffer_setup(struct prueth_emac *emac)
> +{
> +	struct icssg_buffer_pool_cfg *bpool_cfg;
> +	struct prueth *prueth = emac->prueth;
> +	int slice = prueth_emac_slice(emac);
> +	struct icssg_rxq_ctx *rxq_ctx;
> +	u32 addr;
> +	int i;
> +
> +	/* Layout to have 64KB aligned buffer pool
> +	 * |BPOOL0|BPOOL1|RX_CTX0|RX_CTX1|
> +	 */
> +
> +	addr = lower_32_bits(prueth->msmcram.pa);
> +	if (slice)
> +		addr += PRUETH_NUM_BUF_POOLS * PRUETH_EMAC_BUF_POOL_SIZE;
> +
> +	if (addr % SZ_64K) {
> +		dev_warn(prueth->dev, "buffer pool needs to be 64KB aligned\n");
> +		return -EINVAL;
> +	}
> +
> +	bpool_cfg = emac->dram.va + BUFFER_POOL_0_ADDR_OFFSET;
> +	/* workaround for f/w bug. bpool 0 needs to be initilalized */
> +	bpool_cfg[0].addr = cpu_to_le32(addr);
> +	bpool_cfg[0].len = 0;
> +
> +	for (i = PRUETH_EMAC_BUF_POOL_START;
> +	     i < (PRUETH_EMAC_BUF_POOL_START + PRUETH_NUM_BUF_POOLS);
> +	     i++) {
> +		bpool_cfg[i].addr = cpu_to_le32(addr);
> +		bpool_cfg[i].len = cpu_to_le32(PRUETH_EMAC_BUF_POOL_SIZE);
> +		addr += PRUETH_EMAC_BUF_POOL_SIZE;
> +	}
> +
> +	if (!slice)
> +		addr += PRUETH_NUM_BUF_POOLS * PRUETH_EMAC_BUF_POOL_SIZE;
> +	else
> +		addr += PRUETH_EMAC_RX_CTX_BUF_SIZE * 2;
> +
> +	/* Pre-emptible RX buffer queue */
> +	rxq_ctx = emac->dram.va + HOST_RX_Q_PRE_CONTEXT_OFFSET;
> +	for (i = 0; i < 3; i++)
> +		rxq_ctx->start[i] = cpu_to_le32(addr);
> +
> +	addr += PRUETH_EMAC_RX_CTX_BUF_SIZE;
> +	rxq_ctx->end = cpu_to_le32(addr);
> +
> +	/* Express RX buffer queue */
> +	rxq_ctx = emac->dram.va + HOST_RX_Q_EXP_CONTEXT_OFFSET;
> +	for (i = 0; i < 3; i++)
> +		rxq_ctx->start[i] = cpu_to_le32(addr);
> +
> +	addr += PRUETH_EMAC_RX_CTX_BUF_SIZE;
> +	rxq_ctx->end = cpu_to_le32(addr);
> +
> +	return 0;
> +}
> +
> +static void icssg_init_emac_mode(struct prueth *prueth)
> +{
> +	/* When the device is configured as a bridge and it is being brought back
> +	 * to the emac mode, the host mac address has to be set as 0.
> +	 */
> +	u8 mac[ETH_ALEN] = { 0 };
> +
> +	if (prueth->emacs_initialized)
> +		return;
> +
> +	regmap_update_bits(prueth->miig_rt, FDB_GEN_CFG1, SMEM_VLAN_OFFSET_MASK, 0);
> +	regmap_write(prueth->miig_rt, FDB_GEN_CFG2, 0);
> +	/* Clear host MAC address */
> +	icssg_class_set_host_mac_addr(prueth->miig_rt, mac);
> +}
> +
> +int icssg_config(struct prueth *prueth, struct prueth_emac *emac, int slice)
> +{
> +	void *config = emac->dram.va + ICSSG_CONFIG_OFFSET;
> +	u8 *cfg_byte_ptr = config;
> +	struct icssg_flow_cfg *flow_cfg;
> +	u32 mask;
> +	int ret;
> +
> +	icssg_init_emac_mode(prueth);
> +
> +	memset_io(config, 0, TAS_GATE_MASK_LIST0);
> +	icssg_miig_queues_init(prueth, slice);
> +
> +	emac->speed = SPEED_1000;
> +	emac->duplex = DUPLEX_FULL;
> +	if (!phy_interface_mode_is_rgmii(emac->phy_if)) {
> +		emac->speed = SPEED_100;
> +		emac->duplex = DUPLEX_FULL;
> +	}
> +	regmap_update_bits(prueth->miig_rt, ICSSG_CFG_OFFSET, ICSSG_CFG_DEFAULT, ICSSG_CFG_DEFAULT);
> +	icssg_miig_set_interface_mode(prueth->miig_rt, slice, emac->phy_if);
> +	icssg_config_mii_init(emac);
> +	icssg_config_ipg(emac);
> +	icssg_update_rgmii_cfg(prueth->miig_rt, emac);
> +
> +	/* set GPI mode */
> +	pruss_cfg_gpimode(prueth->pruss, prueth->pru_id[slice],
> +			  PRUSS_GPI_MODE_MII);
> +
> +	/* enable XFR shift for PRU and RTU */
> +	mask = PRUSS_SPP_XFER_SHIFT_EN | PRUSS_SPP_RTU_XFR_SHIFT_EN;
> +	pruss_cfg_update(prueth->pruss, PRUSS_CFG_SPP, mask, mask);
> +
> +	/* set C28 to 0x100 */
> +	pru_rproc_set_ctable(prueth->pru[slice], PRU_C28, 0x100 << 8);
> +	pru_rproc_set_ctable(prueth->rtu[slice], PRU_C28, 0x100 << 8);
> +	pru_rproc_set_ctable(prueth->txpru[slice], PRU_C28, 0x100 << 8);
> +
> +	flow_cfg = config + PSI_L_REGULAR_FLOW_ID_BASE_OFFSET;
> +	flow_cfg->rx_base_flow = cpu_to_le32(emac->rx_flow_id_base);
> +	flow_cfg->mgm_base_flow = 0;
> +	*(cfg_byte_ptr + SPL_PKT_DEFAULT_PRIORITY) = 0;
> +	*(cfg_byte_ptr + QUEUE_NUM_UNTAGGED) = 0x0;
> +
> +	ret = prueth_emac_buffer_setup(emac);
> +	if (ret)
> +		return ret;
> +
> +	emac_r30_cmd_init(emac);
> +
> +	return 0;
> +}
> +
> +static struct icssg_r30_cmd emac_r32_bitmask[] = {
> +	{{0xffff0004, 0xffff0100, 0xffff0100, EMAC_NONE}},	/* EMAC_PORT_DISABLE */
> +	{{0xfffb0040, 0xfeff0200, 0xfeff0200, EMAC_NONE}},	/* EMAC_PORT_BLOCK */
> +	{{0xffbb0000, 0xfcff0000, 0xdcff0000, EMAC_NONE}},	/* EMAC_PORT_FORWARD */
> +	{{0xffbb0000, 0xfcff0000, 0xfcff2000, EMAC_NONE}},	/* EMAC_PORT_FORWARD_WO_LEARNING */
> +	{{0xffff0001, EMAC_NONE,  EMAC_NONE, EMAC_NONE}},	/* ACCEPT ALL */
> +	{{0xfffe0002, EMAC_NONE,  EMAC_NONE, EMAC_NONE}},	/* ACCEPT TAGGED */
> +	{{0xfffc0000, EMAC_NONE,  EMAC_NONE, EMAC_NONE}},	/* ACCEPT UNTAGGED and PRIO */
> +	{{EMAC_NONE,  0xffff0020, EMAC_NONE, EMAC_NONE}},	/* TAS Trigger List change */
> +	{{EMAC_NONE,  0xdfff1000, EMAC_NONE, EMAC_NONE}},	/* TAS set state ENABLE*/
> +	{{EMAC_NONE,  0xefff2000, EMAC_NONE, EMAC_NONE}},	/* TAS set state RESET*/
> +	{{EMAC_NONE,  0xcfff0000, EMAC_NONE, EMAC_NONE}},	/* TAS set state DISABLE*/
> +	{{EMAC_NONE,  EMAC_NONE,  0xffff0400, EMAC_NONE}},	/* UC flooding ENABLE*/
> +	{{EMAC_NONE,  EMAC_NONE,  0xfbff0000, EMAC_NONE}},	/* UC flooding DISABLE*/
> +	{{EMAC_NONE,  EMAC_NONE,  0xffff0800, EMAC_NONE}},	/* MC flooding ENABLE*/
> +	{{EMAC_NONE,  EMAC_NONE,  0xf7ff0000, EMAC_NONE}},	/* MC flooding DISABLE*/
> +	{{EMAC_NONE,  0xffff4000, EMAC_NONE, EMAC_NONE}},	/* Preemption on Tx ENABLE*/
> +	{{EMAC_NONE,  0xbfff0000, EMAC_NONE, EMAC_NONE}},	/* Preemption on Tx DISABLE*/
> +	{{0xffff0010,  EMAC_NONE, 0xffff0010, EMAC_NONE}},	/* VLAN AWARE*/
> +	{{0xffef0000,  EMAC_NONE, 0xffef0000, EMAC_NONE}}	/* VLAN UNWARE*/
> +};
> +
> +int emac_set_port_state(struct prueth_emac *emac,
> +			enum icssg_port_state_cmd cmd)
> +{
> +	struct icssg_r30_cmd *p;
> +	int ret = -ETIMEDOUT;
> +	int done = 0;
> +	int i;
> +
> +	p = emac->dram.va + MGR_R30_CMD_OFFSET;
> +
> +	if (cmd >= ICSSG_EMAC_PORT_MAX_COMMANDS) {
> +		netdev_err(emac->ndev, "invalid port command\n");
> +		return -EINVAL;
> +	}
> +
> +	/* only one command at a time allowed to firmware */
> +	mutex_lock(&emac->cmd_lock);
> +
> +	for (i = 0; i < 4; i++)
> +		writel(emac_r32_bitmask[cmd].cmd[i], &p->cmd[i]);
> +
> +	/* wait for done */
> +	ret = read_poll_timeout(emac_r30_is_done, done, done == 1,
> +				1000, 10000, false, emac);
> +
> +	if (ret == -ETIMEDOUT)
> +		netdev_err(emac->ndev, "timeout waiting for command done\n");
> +
> +	mutex_unlock(&emac->cmd_lock);
> +
> +	return ret;
> +}
> +
> +void icssg_config_set_speed(struct prueth_emac *emac)
> +{
> +	u8 fw_speed;
> +
> +	switch (emac->speed) {
> +	case SPEED_1000:
> +		fw_speed = FW_LINK_SPEED_1G;
> +		break;
> +	case SPEED_100:
> +		fw_speed = FW_LINK_SPEED_100M;
> +		break;
> +	default:
> +		/* Other links speeds not supported */
> +		netdev_err(emac->ndev, "Unsupported link speed\n");
> +		return;
> +	}
> +
> +	writeb(fw_speed, emac->dram.va + PORT_LINK_SPEED_OFFSET);
> +}
> diff --git a/drivers/net/ethernet/ti/icssg_config.h b/drivers/net/ethernet/ti/icssg_config.h
> new file mode 100644
> index 000000000000..43eb0922172a
> --- /dev/null
> +++ b/drivers/net/ethernet/ti/icssg_config.h
> @@ -0,0 +1,200 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Texas Instruments ICSSG Ethernet driver
> + *
> + * Copyright (C) 2022 Texas Instruments Incorporated - https://www.ti.com/
> + *
> + */
> +
> +#ifndef __NET_TI_ICSSG_CONFIG_H
> +#define __NET_TI_ICSSG_CONFIG_H
> +
> +struct icssg_buffer_pool_cfg {
> +	__le32	addr;
> +	__le32	len;
> +} __packed;
> +
> +struct icssg_flow_cfg {
> +	__le16 rx_base_flow;
> +	__le16 mgm_base_flow;
> +} __packed;
> +
> +#define PRUETH_PKT_TYPE_CMD	0x10
> +#define PRUETH_NAV_PS_DATA_SIZE	16	/* Protocol specific data size */
> +#define PRUETH_NAV_SW_DATA_SIZE	16	/* SW related data size */
> +#define PRUETH_MAX_TX_DESC	512
> +#define PRUETH_MAX_RX_DESC	512
> +#define PRUETH_MAX_RX_FLOWS	1	/* excluding default flow */
> +#define PRUETH_RX_FLOW_DATA	0
> +
> +#define PRUETH_EMAC_BUF_POOL_SIZE	SZ_8K
> +#define PRUETH_EMAC_POOLS_PER_SLICE	24
> +#define PRUETH_EMAC_BUF_POOL_START	8
> +#define PRUETH_NUM_BUF_POOLS	8
> +#define PRUETH_EMAC_RX_CTX_BUF_SIZE	SZ_16K	/* per slice */
> +#define MSMC_RAM_SIZE	\
> +	(2 * (PRUETH_EMAC_BUF_POOL_SIZE * PRUETH_NUM_BUF_POOLS + \
> +	 PRUETH_EMAC_RX_CTX_BUF_SIZE * 2))
> +
> +struct icssg_rxq_ctx {
> +	__le32 start[3];
> +	__le32 end;
> +} __packed;
> +
> +/* Load time Fiwmware Configuration */
> +
> +#define ICSSG_FW_MGMT_CMD_HEADER	0x81
> +#define ICSSG_FW_MGMT_FDB_CMD_TYPE	0x03
> +#define ICSSG_FW_MGMT_CMD_TYPE		0x04
> +#define ICSSG_FW_MGMT_PKT		0x80000000
> +
> +struct icssg_r30_cmd {
> +	u32 cmd[4];
> +} __packed;
> +
> +enum icssg_port_state_cmd {
> +	ICSSG_EMAC_PORT_DISABLE = 0,
> +	ICSSG_EMAC_PORT_BLOCK,
> +	ICSSG_EMAC_PORT_FORWARD,
> +	ICSSG_EMAC_PORT_FORWARD_WO_LEARNING,
> +	ICSSG_EMAC_PORT_ACCEPT_ALL,
> +	ICSSG_EMAC_PORT_ACCEPT_TAGGED,
> +	ICSSG_EMAC_PORT_ACCEPT_UNTAGGED_N_PRIO,
> +	ICSSG_EMAC_PORT_TAS_TRIGGER,
> +	ICSSG_EMAC_PORT_TAS_ENABLE,
> +	ICSSG_EMAC_PORT_TAS_RESET,
> +	ICSSG_EMAC_PORT_TAS_DISABLE,
> +	ICSSG_EMAC_PORT_UC_FLOODING_ENABLE,
> +	ICSSG_EMAC_PORT_UC_FLOODING_DISABLE,
> +	ICSSG_EMAC_PORT_MC_FLOODING_ENABLE,
> +	ICSSG_EMAC_PORT_MC_FLOODING_DISABLE,
> +	ICSSG_EMAC_PORT_PREMPT_TX_ENABLE,
> +	ICSSG_EMAC_PORT_PREMPT_TX_DISABLE,
> +	ICSSG_EMAC_PORT_VLAN_AWARE_ENABLE,
> +	ICSSG_EMAC_PORT_VLAN_AWARE_DISABLE,
> +	ICSSG_EMAC_PORT_MAX_COMMANDS
> +};
> +
> +#define EMAC_NONE           0xffff0000
> +#define EMAC_PRU0_P_DI      0xffff0004
> +#define EMAC_PRU1_P_DI      0xffff0040
> +#define EMAC_TX_P_DI        0xffff0100
> +
> +#define EMAC_PRU0_P_EN      0xfffb0000
> +#define EMAC_PRU1_P_EN      0xffbf0000
> +#define EMAC_TX_P_EN        0xfeff0000
> +
> +#define EMAC_P_BLOCK        0xffff0040
> +#define EMAC_TX_P_BLOCK     0xffff0200
> +#define EMAC_P_UNBLOCK      0xffbf0000
> +#define EMAC_TX_P_UNBLOCK   0xfdff0000
> +#define EMAC_LEAN_EN        0xfff70000
> +#define EMAC_LEAN_DI        0xffff0008
> +
> +#define EMAC_ACCEPT_ALL     0xffff0001
> +#define EMAC_ACCEPT_TAG     0xfffe0002
> +#define EMAC_ACCEPT_PRIOR   0xfffc0000
> +
> +/* Config area lies in DRAM */
> +#define ICSSG_CONFIG_OFFSET	0x0
> +
> +/* Config area lies in shared RAM */
> +#define ICSSG_CONFIG_OFFSET_SLICE0   0
> +#define ICSSG_CONFIG_OFFSET_SLICE1   0x8000
> +
> +#define ICSSG_NUM_NORMAL_PDS	64
> +#define ICSSG_NUM_SPECIAL_PDS	16
> +
> +#define ICSSG_NORMAL_PD_SIZE	8
> +#define ICSSG_SPECIAL_PD_SIZE	20
> +
> +#define ICSSG_FLAG_MASK		0xff00ffff
> +
> +struct icssg_setclock_desc {
> +	u8 request;
> +	u8 restore;
> +	u8 acknowledgment;
> +	u8 cmp_status;
> +	u32 margin;
> +	u32 cyclecounter0_set;
> +	u32 cyclecounter1_set;
> +	u32 iepcount_set;
> +	u32 rsvd1;
> +	u32 rsvd2;
> +	u32 CMP0_current;
> +	u32 iepcount_current;
> +	u32 difference;
> +	u32 cyclecounter0_new;
> +	u32 cyclecounter1_new;
> +	u32 CMP0_new;
> +} __packed;
> +
> +#define ICSSG_CMD_POP_SLICE0	56
> +#define ICSSG_CMD_POP_SLICE1	60
> +
> +#define ICSSG_CMD_PUSH_SLICE0	57
> +#define ICSSG_CMD_PUSH_SLICE1	61
> +
> +#define ICSSG_RSP_POP_SLICE0	58
> +#define ICSSG_RSP_POP_SLICE1	62
> +
> +#define ICSSG_RSP_PUSH_SLICE0	56
> +#define ICSSG_RSP_PUSH_SLICE1	60
> +
> +#define ICSSG_TS_POP_SLICE0	59
> +#define ICSSG_TS_POP_SLICE1	63
> +
> +#define ICSSG_TS_PUSH_SLICE0	40
> +#define ICSSG_TS_PUSH_SLICE1	41
> +
> +/* FDB FID_C2 flag definitions */
> +/* Indicates host port membership.*/
> +#define ICSSG_FDB_ENTRY_P0_MEMBERSHIP         BIT(0)
> +/* Indicates that MAC ID is connected to physical port 1 */
> +#define ICSSG_FDB_ENTRY_P1_MEMBERSHIP         BIT(1)
> +/* Indicates that MAC ID is connected to physical port 2 */
> +#define ICSSG_FDB_ENTRY_P2_MEMBERSHIP         BIT(2)
> +/* Ageable bit is set for learned entries and cleared for static entries */
> +#define ICSSG_FDB_ENTRY_AGEABLE               BIT(3)
> +/* If set for DA then packet is determined to be a special packet */
> +#define ICSSG_FDB_ENTRY_BLOCK                 BIT(4)
> +/* If set for DA then the SA from the packet is not learned */
> +#define ICSSG_FDB_ENTRY_SECURE                BIT(5)
> +/* If set, it means packet has been seen recently with source address + FID
> + * matching MAC address/FID of entry
> + */
> +#define ICSSG_FDB_ENTRY_TOUCHED               BIT(6)
> +/* Set if entry is valid */
> +#define ICSSG_FDB_ENTRY_VALID                 BIT(7)
> +
> +/**
> + * struct prueth_vlan_tbl - VLAN table entries struct in ICSSG SMEM
> + * @fid_c1: membership and forwarding rules flag to this table. See
> + *          above to defines for bit definitions
> + * @fid: FDB index for this VID (there is 1-1 mapping b/w VID and FID)
> + */
> +struct prueth_vlan_tbl {
> +	u8 fid_c1;
> +	u8 fid;
> +} __packed;
> +
> +/**
> + * struct prueth_fdb_slot - Result of FDB slot lookup
> + * @mac: MAC address
> + * @fid: fid to be associated with MAC
> + * @fid_c2: FID_C2 entry for this MAC
> + */
> +struct prueth_fdb_slot {
> +	u8 mac[ETH_ALEN];
> +	u8 fid;
> +	u8 fid_c2;
> +} __packed;
> +
> +enum icssg_ietfpe_verify_states {
> +	ICSSG_IETFPE_STATE_UNKNOWN = 0,
> +	ICSSG_IETFPE_STATE_INITIAL,
> +	ICSSG_IETFPE_STATE_VERIFYING,
> +	ICSSG_IETFPE_STATE_SUCCEEDED,
> +	ICSSG_IETFPE_STATE_FAILED,
> +	ICSSG_IETFPE_STATE_DISABLED
> +};
> +#endif /* __NET_TI_ICSSG_CONFIG_H */
> diff --git a/drivers/net/ethernet/ti/icssg_ethtool.c b/drivers/net/ethernet/ti/icssg_ethtool.c
> new file mode 100644
> index 000000000000..fd09d223b0ae
> --- /dev/null
> +++ b/drivers/net/ethernet/ti/icssg_ethtool.c
> @@ -0,0 +1,319 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Texas Instruments ICSSG Ethernet driver
> + *
> + * Copyright (C) 2018-2022 Texas Instruments Incorporated - https://www.ti.com/
> + *
> + */
> +
> +#include "icssg_prueth.h"
> +#include <linux/regmap.h>
> +
> +static u32 stats_base[] = {	0x54c,	/* Slice 0 stats start */
> +				0xb18,	/* Slice 1 stats start */
> +};
> +
> +struct miig_stats_regs {
> +	/* Rx */
> +	u32 rx_good_frames;
> +	u32 rx_broadcast_frames;
> +	u32 rx_multicast_frames;
> +	u32 rx_crc_error_frames;
> +	u32 rx_mii_error_frames;
> +	u32 rx_odd_nibble_frames;
> +	u32 rx_frame_max_size;
> +	u32 rx_max_size_error_frames;
> +	u32 rx_frame_min_size;
> +	u32 rx_min_size_error_frames;
> +	u32 rx_overrun_frames;
> +	u32 rx_class0_hits;
> +	u32 rx_class1_hits;
> +	u32 rx_class2_hits;
> +	u32 rx_class3_hits;
> +	u32 rx_class4_hits;
> +	u32 rx_class5_hits;
> +	u32 rx_class6_hits;
> +	u32 rx_class7_hits;
> +	u32 rx_class8_hits;
> +	u32 rx_class9_hits;
> +	u32 rx_class10_hits;
> +	u32 rx_class11_hits;
> +	u32 rx_class12_hits;
> +	u32 rx_class13_hits;
> +	u32 rx_class14_hits;
> +	u32 rx_class15_hits;
> +	u32 rx_smd_frags;
> +	u32 rx_bucket1_size;
> +	u32 rx_bucket2_size;
> +	u32 rx_bucket3_size;
> +	u32 rx_bucket4_size;
> +	u32 rx_64B_frames;
> +	u32 rx_bucket1_frames;
> +	u32 rx_bucket2_frames;
> +	u32 rx_bucket3_frames;
> +	u32 rx_bucket4_frames;
> +	u32 rx_bucket5_frames;
> +	u32 rx_total_bytes;
> +	u32 rx_tx_total_bytes;
> +	/* Tx */
> +	u32 tx_good_frames;
> +	u32 tx_broadcast_frames;
> +	u32 tx_multicast_frames;
> +	u32 tx_odd_nibble_frames;
> +	u32 tx_underflow_errors;
> +	u32 tx_frame_max_size;
> +	u32 tx_max_size_error_frames;
> +	u32 tx_frame_min_size;
> +	u32 tx_min_size_error_frames;
> +	u32 tx_bucket1_size;
> +	u32 tx_bucket2_size;
> +	u32 tx_bucket3_size;
> +	u32 tx_bucket4_size;
> +	u32 tx_64B_frames;
> +	u32 tx_bucket1_frames;
> +	u32 tx_bucket2_frames;
> +	u32 tx_bucket3_frames;
> +	u32 tx_bucket4_frames;
> +	u32 tx_bucket5_frames;
> +	u32 tx_total_bytes;
> +};
> +
> +#define ICSSG_STATS(field)				\
> +{							\
> +	#field,						\
> +	offsetof(struct miig_stats_regs, field),	\
> +}
> +
> +struct icssg_stats {
> +	char name[ETH_GSTRING_LEN];
> +	u32 offset;
> +};
> +
> +static const struct icssg_stats icssg_ethtool_stats[] = {
> +	/* Rx */
> +	ICSSG_STATS(rx_good_frames),
> +	ICSSG_STATS(rx_broadcast_frames),
> +	ICSSG_STATS(rx_multicast_frames),
> +	ICSSG_STATS(rx_crc_error_frames),
> +	ICSSG_STATS(rx_mii_error_frames),
> +	ICSSG_STATS(rx_odd_nibble_frames),
> +	ICSSG_STATS(rx_frame_max_size),
> +	ICSSG_STATS(rx_max_size_error_frames),
> +	ICSSG_STATS(rx_frame_min_size),
> +	ICSSG_STATS(rx_min_size_error_frames),
> +	ICSSG_STATS(rx_overrun_frames),
> +	ICSSG_STATS(rx_class0_hits),
> +	ICSSG_STATS(rx_class1_hits),
> +	ICSSG_STATS(rx_class2_hits),
> +	ICSSG_STATS(rx_class3_hits),
> +	ICSSG_STATS(rx_class4_hits),
> +	ICSSG_STATS(rx_class5_hits),
> +	ICSSG_STATS(rx_class6_hits),
> +	ICSSG_STATS(rx_class7_hits),
> +	ICSSG_STATS(rx_class8_hits),
> +	ICSSG_STATS(rx_class9_hits),
> +	ICSSG_STATS(rx_class10_hits),
> +	ICSSG_STATS(rx_class11_hits),
> +	ICSSG_STATS(rx_class12_hits),
> +	ICSSG_STATS(rx_class13_hits),
> +	ICSSG_STATS(rx_class14_hits),
> +	ICSSG_STATS(rx_class15_hits),
> +	ICSSG_STATS(rx_smd_frags),
> +	ICSSG_STATS(rx_bucket1_size),
> +	ICSSG_STATS(rx_bucket2_size),
> +	ICSSG_STATS(rx_bucket3_size),
> +	ICSSG_STATS(rx_bucket4_size),
> +	ICSSG_STATS(rx_64B_frames),
> +	ICSSG_STATS(rx_bucket1_frames),
> +	ICSSG_STATS(rx_bucket2_frames),
> +	ICSSG_STATS(rx_bucket3_frames),
> +	ICSSG_STATS(rx_bucket4_frames),
> +	ICSSG_STATS(rx_bucket5_frames),
> +	ICSSG_STATS(rx_total_bytes),
> +	ICSSG_STATS(rx_tx_total_bytes),
> +	/* Tx */
> +	ICSSG_STATS(tx_good_frames),
> +	ICSSG_STATS(tx_broadcast_frames),
> +	ICSSG_STATS(tx_multicast_frames),
> +	ICSSG_STATS(tx_odd_nibble_frames),
> +	ICSSG_STATS(tx_underflow_errors),
> +	ICSSG_STATS(tx_frame_max_size),
> +	ICSSG_STATS(tx_max_size_error_frames),
> +	ICSSG_STATS(tx_frame_min_size),
> +	ICSSG_STATS(tx_min_size_error_frames),
> +	ICSSG_STATS(tx_bucket1_size),
> +	ICSSG_STATS(tx_bucket2_size),
> +	ICSSG_STATS(tx_bucket3_size),
> +	ICSSG_STATS(tx_bucket4_size),
> +	ICSSG_STATS(tx_64B_frames),
> +	ICSSG_STATS(tx_bucket1_frames),
> +	ICSSG_STATS(tx_bucket2_frames),
> +	ICSSG_STATS(tx_bucket3_frames),
> +	ICSSG_STATS(tx_bucket4_frames),
> +	ICSSG_STATS(tx_bucket5_frames),
> +	ICSSG_STATS(tx_total_bytes),
> +};
> +
> +static void emac_get_drvinfo(struct net_device *ndev,
> +			     struct ethtool_drvinfo *info)
> +{
> +	struct prueth_emac *emac = netdev_priv(ndev);
> +	struct prueth *prueth = emac->prueth;
> +
> +	strscpy(info->driver, dev_driver_string(prueth->dev),
> +		sizeof(info->driver));
> +	strscpy(info->bus_info, dev_name(prueth->dev), sizeof(info->bus_info));
> +}
> +
> +static u32 emac_get_msglevel(struct net_device *ndev)
> +{
> +	struct prueth_emac *emac = netdev_priv(ndev);
> +
> +	return emac->msg_enable;
> +}
> +
> +static void emac_set_msglevel(struct net_device *ndev, u32 value)
> +{
> +	struct prueth_emac *emac = netdev_priv(ndev);
> +
> +	emac->msg_enable = value;
> +}
> +
> +static int emac_get_link_ksettings(struct net_device *ndev,
> +				   struct ethtool_link_ksettings *ecmd)
> +{
> +	return phy_ethtool_get_link_ksettings(ndev, ecmd);
> +}
> +
> +static int emac_set_link_ksettings(struct net_device *ndev,
> +				   const struct ethtool_link_ksettings *ecmd)
> +{
> +	return phy_ethtool_set_link_ksettings(ndev, ecmd);
> +}
> +
> +static int emac_get_eee(struct net_device *ndev, struct ethtool_eee *edata)
> +{
> +	if (!ndev->phydev)
> +		return -EOPNOTSUPP;
> +
> +	return phy_ethtool_get_eee(ndev->phydev, edata);
> +}
> +
> +static int emac_set_eee(struct net_device *ndev, struct ethtool_eee *edata)
> +{
> +	if (!ndev->phydev)
> +		return -EOPNOTSUPP;
> +
> +	return phy_ethtool_set_eee(ndev->phydev, edata);
> +}
> +
> +static int emac_nway_reset(struct net_device *ndev)
> +{
> +	return phy_ethtool_nway_reset(ndev);
> +}
> +
> +static const char emac_ethtool_priv_flags[][ETH_GSTRING_LEN] = {
> +#define EMAC_PRIV_IET_FRAME_PREEMPTION  BIT(0)
> +	"iet-frame-preemption",
> +#define EMAC_PRIV_IET_MAC_VERIFY                BIT(1)
> +	"iet-mac-verify",
> +};

Please move the #define outside of the array. They are not easy to
see.

	Andrew
