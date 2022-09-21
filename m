Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9DEA5BF9CD
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 10:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbiIUItD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 04:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231470AbiIUIso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 04:48:44 -0400
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 209887B794;
        Wed, 21 Sep 2022 01:48:41 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.93,332,1654527600"; 
   d="scan'208";a="135683819"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 21 Sep 2022 17:48:39 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 2CBCC41D8A13;
        Wed, 21 Sep 2022 17:48:39 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     kishon@ti.com, vkoul@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        richardcochran@gmail.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, geert+renesas@glider.be
Cc:     andrew@lunn.ch, linux-phy@lists.infradead.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH v2 5/8] net: ethernet: renesas: Add Ethernet Switch driver
Date:   Wed, 21 Sep 2022 17:47:42 +0900
Message-Id: <20220921084745.3355107-6-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220921084745.3355107-1-yoshihiro.shimoda.uh@renesas.com>
References: <20220921084745.3355107-1-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Renesas Ethernet Switch driver for R-Car S4-8 to be used as an
ethernet controller.

Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 drivers/net/ethernet/renesas/Kconfig   |   11 +
 drivers/net/ethernet/renesas/Makefile  |    4 +
 drivers/net/ethernet/renesas/rswitch.c | 1631 ++++++++++++++++++++++++
 drivers/net/ethernet/renesas/rswitch.h |  965 ++++++++++++++
 4 files changed, 2611 insertions(+)
 create mode 100644 drivers/net/ethernet/renesas/rswitch.c
 create mode 100644 drivers/net/ethernet/renesas/rswitch.h

diff --git a/drivers/net/ethernet/renesas/Kconfig b/drivers/net/ethernet/renesas/Kconfig
index 8008b2f45934..4ae170056ac8 100644
--- a/drivers/net/ethernet/renesas/Kconfig
+++ b/drivers/net/ethernet/renesas/Kconfig
@@ -42,4 +42,15 @@ config RAVB
 	  This driver supports the following SoCs:
 		- R8A779x.
 
+config RENESAS_ETHER_SWITCH
+	tristate "Renesas Ethernet Switch support"
+	depends on ARCH_RENESAS || COMPILE_TEST
+	select CRC32
+	select MII
+	select PHYLIB
+	help
+	  Renesas Ethernet Switch device driver.
+	  This driver supports the following SoCs:
+		- R8A779Fx.
+
 endif # NET_VENDOR_RENESAS
diff --git a/drivers/net/ethernet/renesas/Makefile b/drivers/net/ethernet/renesas/Makefile
index f21ab8c02af0..32845ba53970 100644
--- a/drivers/net/ethernet/renesas/Makefile
+++ b/drivers/net/ethernet/renesas/Makefile
@@ -8,3 +8,7 @@ obj-$(CONFIG_SH_ETH) += sh_eth.o
 ravb-objs := ravb_main.o ravb_ptp.o
 
 obj-$(CONFIG_RAVB) += ravb.o
+
+rswitch_drv-objs := rswitch.o
+
+obj-$(CONFIG_RENESAS_ETHER_SWITCH) += rswitch_drv.o
diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
new file mode 100644
index 000000000000..2723dffad93a
--- /dev/null
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -0,0 +1,1631 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Renesas Ethernet Switch device driver
+ *
+ * Copyright (C) 2022 Renesas Electronics Corporation
+ */
+
+#include <linux/clk.h>
+#include <linux/dma-mapping.h>
+#include <linux/err.h>
+#include <linux/etherdevice.h>
+#include <linux/iopoll.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/net_tstamp.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/of_irq.h>
+#include <linux/of_mdio.h>
+#include <linux/of_net.h>
+#include <linux/phy/phy.h>
+#include <linux/pm_runtime.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+
+#include "rswitch.h"
+
+static int rswitch_reg_wait(void __iomem *addr, u32 offs, u32 mask, u32 expected)
+{
+	u32 val;
+
+	return readl_poll_timeout_atomic(addr + offs, val, (val & mask) == expected,
+					 1, RSWITCH_TIMEOUT_US);
+}
+
+static void rswitch_modify(void __iomem *addr, enum rswitch_reg reg, u32 clear, u32 set)
+{
+	iowrite32((ioread32(addr + reg) & ~clear) | set, addr + reg);
+}
+
+/* Common Agent block (COMA) */
+static void rswitch_reset(struct rswitch_private *priv)
+{
+	iowrite32(RRC_RR, priv->addr + RRC);
+	iowrite32(RRC_RR_CLR, priv->addr + RRC);
+}
+
+static void rswitch_clock_enable(struct rswitch_private *priv)
+{
+	iowrite32(GENMASK(RSWITCH_NUM_HW - 1, 0) | RCEC_RCE, priv->addr + RCEC);
+}
+
+static void rswitch_clock_disable(struct rswitch_private *priv)
+{
+	iowrite32(RCDC_RCD, priv->addr + RCDC);
+}
+
+static bool rswitch_agent_clock_is_enabled(void __iomem *coma_addr, int port)
+{
+	u32 val = ioread32(coma_addr + RCEC);
+
+	if (val & RCEC_RCE)
+		return (val & BIT(port)) ? true : false;
+	else
+		return false;
+}
+
+static void rswitch_agent_clock_ctrl(void __iomem *coma_addr, int port, int enable)
+{
+	u32 val;
+
+	if (enable) {
+		val = ioread32(coma_addr + RCEC);
+		iowrite32(val | RCEC_RCE | BIT(port), coma_addr + RCEC);
+	} else {
+		val = ioread32(coma_addr + RCDC);
+		iowrite32(val | BIT(port), coma_addr + RCDC);
+	}
+}
+
+static int rswitch_bpool_config(struct rswitch_private *priv)
+{
+	u32 val;
+
+	val = ioread32(priv->addr + CABPIRM);
+	if (val & CABPIRM_BPR)
+		return 0;
+
+	iowrite32(CABPIRM_BPIOG, priv->addr + CABPIRM);
+
+	return rswitch_reg_wait(priv->addr, CABPIRM, CABPIRM_BPR, CABPIRM_BPR);
+}
+
+/* R-Switch-2 block (TOP) */
+static void rswitch_top_init(struct rswitch_private *priv)
+{
+	int i;
+
+	for (i = 0; i < RSWITCH_MAX_NUM_CHAINS; i++)
+		iowrite32((i / 16) << (GWCA_INDEX * 8), priv->addr + TPEMIMC7(i));
+}
+
+/* Forwarding engine block (MFWD) */
+static void rswitch_fwd_init(struct rswitch_private *priv)
+{
+	int i;
+
+	for (i = 0; i < RSWITCH_NUM_HW; i++) {
+		iowrite32(FWPC0_DEFAULT, priv->addr + FWPC0(i));
+		iowrite32(0, priv->addr + FWPBFC(i));
+	}
+
+	for (i = 0; i < RSWITCH_NUM_ETHA; i++) {
+		iowrite32(priv->rdev[i]->rx_chain->index,
+			  priv->addr + FWPBFCSDC(GWCA_INDEX, i));
+		iowrite32(BIT(priv->gwca.index), priv->addr + FWPBFC(i));
+	}
+	iowrite32(GENMASK(RSWITCH_NUM_ETHA - 1, 0), priv->addr + FWPBFC(3));
+}
+
+/* Gateway CPU agent block (GWCA) */
+static int rswitch_gwca_change_mode(struct rswitch_private *priv,
+				    enum rswitch_gwca_mode mode)
+{
+	int ret;
+
+	if (!rswitch_agent_clock_is_enabled(priv->addr, priv->gwca.index))
+		rswitch_agent_clock_ctrl(priv->addr, priv->gwca.index, 1);
+
+	iowrite32(mode, priv->addr + GWMC);
+
+	ret = rswitch_reg_wait(priv->addr, GWMS, GWMS_OPS_MASK, mode);
+
+	if (mode == GWMC_OPC_DISABLE)
+		rswitch_agent_clock_ctrl(priv->addr, priv->gwca.index, 0);
+
+	return ret;
+}
+
+static int rswitch_gwca_mcast_table_reset(struct rswitch_private *priv)
+{
+	iowrite32(GWMTIRM_MTIOG, priv->addr + GWMTIRM);
+
+	return rswitch_reg_wait(priv->addr, GWMTIRM, GWMTIRM_MTR, GWMTIRM_MTR);
+}
+
+static int rswitch_gwca_axi_ram_reset(struct rswitch_private *priv)
+{
+	iowrite32(GWARIRM_ARIOG, priv->addr + GWARIRM);
+
+	return rswitch_reg_wait(priv->addr, GWARIRM, GWARIRM_ARR, GWARIRM_ARR);
+}
+
+static void rswitch_gwca_set_rate_limit(struct rswitch_private *priv, int rate)
+{
+	u32 gwgrlulc, gwgrlc;
+
+	switch (rate) {
+	case 1000:
+		gwgrlulc = 0x0000005f;
+		gwgrlc = 0x00010260;
+		break;
+	default:
+		dev_err(&priv->pdev->dev, "%s: This rate is not supported (%d)\n", __func__, rate);
+		return;
+	}
+
+	iowrite32(gwgrlulc, priv->addr + GWGRLULC);
+	iowrite32(gwgrlc, priv->addr + GWGRLC);
+}
+
+static bool rswitch_is_any_data_irq(struct rswitch_private *priv, u32 *dis, bool tx)
+{
+	u32 *mask = tx ? priv->gwca.tx_irq_bits : priv->gwca.rx_irq_bits;
+	int i;
+
+	for (i = 0; i < RSWITCH_NUM_IRQ_REGS; i++) {
+		if (dis[i] & mask[i])
+			return true;
+	}
+
+	return false;
+}
+
+static void rswitch_get_data_irq_status(struct rswitch_private *priv, u32 *dis)
+{
+	int i;
+
+	for (i = 0; i < RSWITCH_NUM_IRQ_REGS; i++) {
+		dis[i] = ioread32(priv->addr + GWDIS(i));
+		dis[i] &= ioread32(priv->addr + GWDIE(i));
+	}
+}
+
+static void rswitch_enadis_data_irq(struct rswitch_private *priv, int index, bool enable)
+{
+	u32 offs = enable ? GWDIE(index / 32) : GWDID(index / 32);
+
+	iowrite32(BIT(index % 32), priv->addr + offs);
+}
+
+static void rswitch_ack_data_irq(struct rswitch_private *priv, int index)
+{
+	u32 offs = GWDIS(index / 32);
+
+	iowrite32(BIT(index % 32), priv->addr + offs);
+}
+
+static bool rswitch_is_chain_rxed(struct rswitch_gwca_chain *c)
+{
+	struct rswitch_ext_ts_desc *desc;
+	int entry;
+
+	entry = c->dirty % c->num_ring;
+	desc = &c->ts_ring[entry];
+
+	if ((desc->die_dt & DT_MASK) != DT_FEMPTY)
+		return true;
+
+	return false;
+}
+
+static int rswitch_gwca_chain_alloc_skb(struct rswitch_gwca_chain *c,
+					int start, int num)
+{
+	int i, index;
+
+	for (i = start; i < (start + num); i++) {
+		index = i % c->num_ring;
+		if (c->skb[index])
+			continue;
+		c->skb[index] = dev_alloc_skb(PKT_BUF_SZ + RSWITCH_ALIGN - 1);
+		if (!c->skb[index])
+			goto err;
+		skb_reserve(c->skb[index], NET_IP_ALIGN);
+	}
+
+	return 0;
+
+err:
+	for (i--; i >= start; i--) {
+		index = i % c->num_ring;
+		dev_kfree_skb(c->skb[index]);
+		c->skb[index] = NULL;
+	}
+
+	return -ENOMEM;
+}
+
+static void rswitch_gwca_chain_free(struct net_device *ndev,
+				    struct rswitch_gwca_chain *c)
+{
+	int i;
+
+	if (c->gptp) {
+		dma_free_coherent(ndev->dev.parent,
+				  sizeof(struct rswitch_ext_ts_desc) *
+				  (c->num_ring + 1), c->ts_ring, c->ring_dma);
+		c->ts_ring = NULL;
+	} else {
+		dma_free_coherent(ndev->dev.parent,
+				  sizeof(struct rswitch_ext_desc) *
+				  (c->num_ring + 1), c->ring, c->ring_dma);
+		c->ring = NULL;
+	}
+
+	if (!c->dir_tx) {
+		for (i = 0; i < c->num_ring; i++)
+			dev_kfree_skb(c->skb[i]);
+	}
+
+	kfree(c->skb);
+	c->skb = NULL;
+}
+
+static int rswitch_gwca_chain_alloc(struct net_device *ndev,
+				    struct rswitch_private *priv,
+				    struct rswitch_gwca_chain *c,
+				    bool dir_tx, bool gptp, int num_ring)
+{
+	int i, bit;
+
+	c->dir_tx = dir_tx;
+	c->gptp = gptp;
+	c->num_ring = num_ring;
+	c->ndev = ndev;
+
+	c->skb = kcalloc(c->num_ring, sizeof(*c->skb), GFP_KERNEL);
+	if (!c->skb)
+		return -ENOMEM;
+
+	if (!dir_tx)
+		rswitch_gwca_chain_alloc_skb(c, 0, c->num_ring);
+
+	if (gptp)
+		c->ts_ring = dma_alloc_coherent(ndev->dev.parent,
+						sizeof(struct rswitch_ext_ts_desc) *
+						(c->num_ring + 1), &c->ring_dma, GFP_KERNEL);
+	else
+		c->ring = dma_alloc_coherent(ndev->dev.parent,
+					     sizeof(struct rswitch_ext_desc) *
+					     (c->num_ring + 1), &c->ring_dma, GFP_KERNEL);
+	if (!c->ts_ring && !c->ring)
+		goto out;
+
+	i = c->index / 32;
+	bit = BIT(c->index % 32);
+	if (dir_tx)
+		priv->gwca.tx_irq_bits[i] |= bit;
+	else
+		priv->gwca.rx_irq_bits[i] |= bit;
+
+	return 0;
+
+out:
+	rswitch_gwca_chain_free(ndev, c);
+
+	return -ENOMEM;
+}
+
+static int rswitch_gwca_chain_format(struct net_device *ndev,
+				     struct rswitch_private *priv,
+				     struct rswitch_gwca_chain *c)
+{
+	int tx_ring_size = sizeof(struct rswitch_ext_desc) * c->num_ring;
+	struct rswitch_ext_desc *ring;
+	struct rswitch_desc *desc;
+	dma_addr_t dma_addr;
+	int i;
+
+	memset(c->ring, 0, tx_ring_size);
+	for (i = 0, ring = c->ring; i < c->num_ring; i++, ring++) {
+		if (!c->dir_tx) {
+			dma_addr = dma_map_single(ndev->dev.parent,
+						  c->skb[i]->data, PKT_BUF_SZ,
+						  DMA_FROM_DEVICE);
+			if (dma_mapping_error(ndev->dev.parent, dma_addr))
+				goto err;
+
+			ring->info_ds = cpu_to_le16(PKT_BUF_SZ);
+			ring->dptrl = cpu_to_le32(lower_32_bits(dma_addr));
+			ring->dptrh = cpu_to_le32(upper_32_bits(dma_addr));
+			ring->die_dt = DT_FEMPTY | DIE;
+		} else {
+			ring->die_dt = DT_EEMPTY | DIE;
+		}
+	}
+	ring->dptrl = cpu_to_le32(lower_32_bits(c->ring_dma));
+	ring->dptrh = cpu_to_le32(upper_32_bits(c->ring_dma));
+	ring->die_dt = DT_LINKFIX;
+
+	desc = &priv->desc_bat[c->index];
+	desc->die_dt = DT_LINKFIX;
+	desc->dptrl = cpu_to_le32(lower_32_bits(c->ring_dma));
+	desc->dptrh = cpu_to_le32(upper_32_bits(c->ring_dma));
+
+	iowrite32(GWDCC_BALR | (c->dir_tx ? GWDCC_DQT : 0) | GWDCC_EDE,
+		  priv->addr + GWDCC_OFFS(c->index));
+
+	return 0;
+
+err:
+	if (!c->dir_tx) {
+		for (i--, ring = c->ring; i >= 0; i--, ring++) {
+			dma_addr = le32_to_cpu(ring->dptrl) |
+				   ((__le64)le32_to_cpu(ring->dptrh) << 32);
+			dma_unmap_single(ndev->dev.parent, dma_addr, PKT_BUF_SZ,
+					 DMA_FROM_DEVICE);
+		}
+	}
+
+	return -ENOMEM;
+}
+
+static int rswitch_gwca_chain_ts_fill(struct net_device *ndev,
+				      struct rswitch_gwca_chain *c,
+				      int start, int num)
+{
+	struct rswitch_ext_ts_desc *ring;
+	dma_addr_t dma_addr;
+	int i, index;
+
+	for (i = start; i < (start + num); i++) {
+		index = i % c->num_ring;
+		ring = &c->ts_ring[index];
+		if (!c->dir_tx) {
+			dma_addr = dma_map_single(ndev->dev.parent,
+						  c->skb[index]->data, PKT_BUF_SZ,
+						  DMA_FROM_DEVICE);
+			if (dma_mapping_error(ndev->dev.parent, dma_addr))
+				goto err;
+
+			ring->info_ds = cpu_to_le16(PKT_BUF_SZ);
+			ring->dptrl = cpu_to_le32(lower_32_bits(dma_addr));
+			ring->dptrh = cpu_to_le32(upper_32_bits(dma_addr));
+			dma_wmb();
+			ring->die_dt = DT_FEMPTY | DIE;
+		} else {
+			ring->die_dt = DT_EEMPTY | DIE;
+		}
+	}
+
+	return 0;
+
+err:
+	if (!c->dir_tx) {
+		for (i--; i >= start; i--) {
+			index = (i + start) % c->num_ring;
+			ring = &c->ts_ring[index];
+			dma_addr = le32_to_cpu(ring->dptrl) |
+				   ((__le64)le32_to_cpu(ring->dptrh) << 32);
+			dma_unmap_single(ndev->dev.parent, dma_addr, PKT_BUF_SZ,
+					 DMA_FROM_DEVICE);
+		}
+	}
+
+	return -ENOMEM;
+}
+
+static int rswitch_gwca_chain_ts_format(struct net_device *ndev,
+					struct rswitch_private *priv,
+					struct rswitch_gwca_chain *c)
+{
+	int tx_ts_ring_size = sizeof(struct rswitch_ext_ts_desc) * c->num_ring;
+	struct rswitch_ext_ts_desc *ring;
+	struct rswitch_desc *desc;
+	int err;
+
+	memset(c->ts_ring, 0, tx_ts_ring_size);
+	err = rswitch_gwca_chain_ts_fill(ndev, c, 0, c->num_ring);
+	if (err < 0)
+		return err;
+
+	ring = &c->ts_ring[c->num_ring];	/* Last */
+	ring->dptrl = cpu_to_le32(lower_32_bits(c->ring_dma));
+	ring->dptrh = cpu_to_le32(upper_32_bits(c->ring_dma));
+	ring->die_dt = DT_LINKFIX;
+
+	desc = &priv->desc_bat[c->index];
+	desc->die_dt = DT_LINKFIX;
+	desc->dptrl = cpu_to_le32(lower_32_bits(c->ring_dma));
+	desc->dptrh = cpu_to_le32(upper_32_bits(c->ring_dma));
+
+	iowrite32(GWDCC_BALR | (c->dir_tx ? GWDCC_DQT : 0) | GWDCC_ETS | GWDCC_EDE,
+		  priv->addr + GWDCC_OFFS(c->index));
+
+	return 0;
+}
+
+static int rswitch_gwca_desc_alloc(struct rswitch_private *priv)
+{
+	int i, num_chains = priv->gwca.num_chains;
+	struct device *dev = &priv->pdev->dev;
+
+	priv->desc_bat_size = sizeof(struct rswitch_desc) * num_chains;
+	priv->desc_bat = dma_alloc_coherent(dev, priv->desc_bat_size,
+					    &priv->desc_bat_dma, GFP_KERNEL);
+	if (!priv->desc_bat)
+		return -ENOMEM;
+	for (i = 0; i < num_chains; i++)
+		priv->desc_bat[i].die_dt = DT_EOS;
+
+	return 0;
+}
+
+static void rswitch_gwca_desc_free(struct rswitch_private *priv)
+{
+	if (priv->desc_bat)
+		dma_free_coherent(&priv->pdev->dev, priv->desc_bat_size,
+				  priv->desc_bat, priv->desc_bat_dma);
+	priv->desc_bat = NULL;
+}
+
+static struct rswitch_gwca_chain *rswitch_gwca_get(struct rswitch_private *priv)
+{
+	struct rswitch_gwca_chain *c;
+	int index;
+
+	index = find_first_zero_bit(priv->gwca.used, priv->gwca.num_chains);
+	if (index >= priv->gwca.num_chains)
+		return NULL;
+	set_bit(index, priv->gwca.used);
+	c = &priv->gwca.chains[index];
+	memset(c, 0, sizeof(*c));
+	c->index = index;
+
+	return c;
+}
+
+static void rswitch_gwca_put(struct rswitch_private *priv,
+			     struct rswitch_gwca_chain *c)
+{
+	clear_bit(c->index, priv->gwca.used);
+}
+
+static int rswitch_txdmac_alloc(struct net_device *ndev)
+{
+	struct rswitch_device *rdev = netdev_priv(ndev);
+	struct rswitch_private *priv = rdev->priv;
+	int err;
+
+	rdev->tx_chain = rswitch_gwca_get(priv);
+	if (!rdev->tx_chain)
+		return -EBUSY;
+
+	err = rswitch_gwca_chain_alloc(ndev, priv, rdev->tx_chain, true, false,
+				       TX_RING_SIZE);
+	if (err < 0) {
+		rswitch_gwca_put(priv, rdev->tx_chain);
+		return err;
+	}
+
+	return 0;
+}
+
+static void rswitch_txdmac_free(struct net_device *ndev)
+{
+	struct rswitch_device *rdev = netdev_priv(ndev);
+
+	rswitch_gwca_chain_free(ndev, rdev->tx_chain);
+	rswitch_gwca_put(rdev->priv, rdev->tx_chain);
+}
+
+static int rswitch_txdmac_init(struct rswitch_private *priv, int index)
+{
+	struct rswitch_device *rdev = priv->rdev[index];
+
+	return rswitch_gwca_chain_format(rdev->ndev, priv, rdev->tx_chain);
+}
+
+static int rswitch_rxdmac_alloc(struct net_device *ndev)
+{
+	struct rswitch_device *rdev = netdev_priv(ndev);
+	struct rswitch_private *priv = rdev->priv;
+	int err;
+
+	rdev->rx_chain = rswitch_gwca_get(priv);
+	if (!rdev->rx_chain)
+		return -EBUSY;
+
+	err = rswitch_gwca_chain_alloc(ndev, priv, rdev->rx_chain, false, true,
+				       RX_RING_SIZE);
+	if (err < 0) {
+		rswitch_gwca_put(priv, rdev->rx_chain);
+		return err;
+	}
+
+	return 0;
+}
+
+static void rswitch_rxdmac_free(struct net_device *ndev)
+{
+	struct rswitch_device *rdev = netdev_priv(ndev);
+
+	rswitch_gwca_chain_free(ndev, rdev->rx_chain);
+	rswitch_gwca_put(rdev->priv, rdev->rx_chain);
+}
+
+static int rswitch_rxdmac_init(struct rswitch_private *priv, int index)
+{
+	struct rswitch_device *rdev = priv->rdev[index];
+	struct net_device *ndev = rdev->ndev;
+
+	return rswitch_gwca_chain_ts_format(ndev, priv, rdev->rx_chain);
+}
+
+static int rswitch_gwca_hw_init(struct rswitch_private *priv)
+{
+	int i, err;
+
+	err = rswitch_gwca_change_mode(priv, GWMC_OPC_DISABLE);
+	if (err < 0)
+		return err;
+	err = rswitch_gwca_change_mode(priv, GWMC_OPC_CONFIG);
+	if (err < 0)
+		return err;
+
+	err = rswitch_gwca_mcast_table_reset(priv);
+	if (err < 0)
+		return err;
+	err = rswitch_gwca_axi_ram_reset(priv);
+	if (err < 0)
+		return err;
+
+	iowrite32(GWVCC_VEM_SC_TAG, priv->addr + GWVCC);
+	iowrite32(0, priv->addr + GWTTFC);
+	iowrite32(lower_32_bits(priv->desc_bat_dma), priv->addr + GWDCBAC1);
+	iowrite32(upper_32_bits(priv->desc_bat_dma), priv->addr + GWDCBAC0);
+	rswitch_gwca_set_rate_limit(priv, priv->gwca.speed);
+
+	for (i = 0; i < RSWITCH_NUM_NDEV; i++) {
+		err = rswitch_rxdmac_init(priv, i);
+		if (err < 0)
+			return err;
+		err = rswitch_txdmac_init(priv, i);
+		if (err < 0)
+			return err;
+	}
+
+	err = rswitch_gwca_change_mode(priv, GWMC_OPC_DISABLE);
+	if (err < 0)
+		return err;
+	return rswitch_gwca_change_mode(priv, GWMC_OPC_OPERATION);
+}
+
+static int rswitch_gwca_hw_deinit(struct rswitch_private *priv)
+{
+	int err;
+
+	err = rswitch_gwca_change_mode(priv, GWMC_OPC_DISABLE);
+	if (err < 0)
+		return err;
+	err = rswitch_gwca_change_mode(priv, GWMC_OPC_RESET);
+	if (err < 0)
+		return err;
+
+	return rswitch_gwca_change_mode(priv, GWMC_OPC_DISABLE);
+}
+
+static int rswitch_gwca_halt(struct rswitch_private *priv)
+{
+	int err;
+
+	priv->gwca_halt = true;
+	err = rswitch_gwca_hw_deinit(priv);
+	dev_err(&priv->pdev->dev, "halted (%d)\n", err);
+
+	return err;
+}
+
+static bool rswitch_rx(struct net_device *ndev, int *quota)
+{
+	struct rswitch_device *rdev = netdev_priv(ndev);
+	struct rswitch_gwca_chain *c = rdev->rx_chain;
+	int entry = c->cur % c->num_ring;
+	struct rswitch_ext_ts_desc *desc;
+	int limit, boguscnt, num, ret;
+	struct sk_buff *skb;
+	dma_addr_t dma_addr;
+	u16 pkt_len;
+
+	boguscnt = min_t(int, c->dirty + c->num_ring - c->cur, *quota);
+	limit = boguscnt;
+
+	desc = &c->ts_ring[entry];
+	while ((desc->die_dt & DT_MASK) != DT_FEMPTY) {
+		dma_rmb();
+		pkt_len = le16_to_cpu(desc->info_ds) & RX_DS;
+		if (--boguscnt < 0)
+			break;
+		skb = c->skb[entry];
+		c->skb[entry] = NULL;
+		dma_addr = le32_to_cpu(desc->dptrl) | ((__le64)le32_to_cpu(desc->dptrh) << 32);
+		dma_unmap_single(ndev->dev.parent, dma_addr, PKT_BUF_SZ, DMA_FROM_DEVICE);
+		skb_put(skb, pkt_len);
+		skb->protocol = eth_type_trans(skb, ndev);
+		netif_receive_skb(skb);
+		rdev->ndev->stats.rx_packets++;
+		rdev->ndev->stats.rx_bytes += pkt_len;
+
+		entry = (++c->cur) % c->num_ring;
+		desc = &c->ts_ring[entry];
+	}
+
+	num = c->cur - c->dirty;
+	ret = rswitch_gwca_chain_alloc_skb(c, c->dirty, num);
+	if (ret < 0)
+		goto err;
+	ret = rswitch_gwca_chain_ts_fill(ndev, c, c->dirty, num);
+	if (ret < 0)
+		goto err;
+	c->dirty += num;
+
+	*quota -= limit - (++boguscnt);
+
+	return boguscnt <= 0;
+
+err:
+	rswitch_gwca_halt(rdev->priv);
+
+	return 0;
+}
+
+static int rswitch_tx_free(struct net_device *ndev, bool free_txed_only)
+{
+	struct rswitch_device *rdev = netdev_priv(ndev);
+	struct rswitch_gwca_chain *c = rdev->tx_chain;
+	struct rswitch_ext_desc *desc;
+	dma_addr_t dma_addr;
+	struct sk_buff *skb;
+	int free_num = 0;
+	int entry, size;
+
+	for (; c->cur - c->dirty > 0; c->dirty++) {
+		entry = c->dirty % c->num_ring;
+		desc = &c->ring[entry];
+		if (free_txed_only && (desc->die_dt & DT_MASK) != DT_FEMPTY)
+			break;
+
+		dma_rmb();
+		size = le16_to_cpu(desc->info_ds) & TX_DS;
+		skb = c->skb[entry];
+		if (skb) {
+			dma_addr = le32_to_cpu(desc->dptrl) |
+				   ((__le64)le32_to_cpu(desc->dptrh) << 32);
+			dma_unmap_single(ndev->dev.parent, dma_addr,
+					 size, DMA_TO_DEVICE);
+			dev_kfree_skb_any(c->skb[entry]);
+			c->skb[entry] = NULL;
+			free_num++;
+		}
+		desc->die_dt = DT_EEMPTY;
+		rdev->ndev->stats.tx_packets++;
+		rdev->ndev->stats.tx_bytes += size;
+	}
+
+	return free_num;
+}
+
+static int rswitch_poll(struct napi_struct *napi, int budget)
+{
+	struct net_device *ndev = napi->dev;
+	struct rswitch_private *priv;
+	struct rswitch_device *rdev;
+	int quota = budget;
+
+	rdev = netdev_priv(ndev);
+	priv = rdev->priv;
+
+retry:
+	rswitch_tx_free(ndev, true);
+
+	if (rswitch_rx(ndev, &quota))
+		goto out;
+	else if (rdev->priv->gwca_halt)
+		goto err;
+	else if (rswitch_is_chain_rxed(rdev->rx_chain))
+		goto retry;
+
+	netif_wake_subqueue(ndev, 0);
+
+	napi_complete(napi);
+
+	rswitch_enadis_data_irq(priv, rdev->tx_chain->index, true);
+	rswitch_enadis_data_irq(priv, rdev->rx_chain->index, true);
+
+out:
+	return budget - quota;
+
+err:
+	napi_complete(napi);
+
+	return 0;
+}
+
+static void rswitch_queue_interrupt(struct net_device *ndev)
+{
+	struct rswitch_device *rdev = netdev_priv(ndev);
+
+	if (napi_schedule_prep(&rdev->napi)) {
+		rswitch_enadis_data_irq(rdev->priv, rdev->tx_chain->index, false);
+		rswitch_enadis_data_irq(rdev->priv, rdev->rx_chain->index, false);
+		__napi_schedule(&rdev->napi);
+	}
+}
+
+static irqreturn_t rswitch_data_irq(struct rswitch_private *priv, u32 *dis)
+{
+	struct rswitch_gwca_chain *c;
+	int i, index, bit;
+
+	for (i = 0; i < priv->gwca.num_chains; i++) {
+		c = &priv->gwca.chains[i];
+		index = c->index / 32;
+		bit = BIT(c->index % 32);
+		if (!(dis[index] & bit))
+			continue;
+
+		rswitch_ack_data_irq(priv, c->index);
+		rswitch_queue_interrupt(c->ndev);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t rswitch_gwca_irq(int irq, void *dev_id)
+{
+	struct rswitch_private *priv = dev_id;
+	u32 dis[RSWITCH_NUM_IRQ_REGS];
+	irqreturn_t ret = IRQ_NONE;
+
+	rswitch_get_data_irq_status(priv, dis);
+
+	if (rswitch_is_any_data_irq(priv, dis, true) ||
+	    rswitch_is_any_data_irq(priv, dis, false))
+		ret = rswitch_data_irq(priv, dis);
+
+	return ret;
+}
+
+static int rswitch_gwca_request_irqs(struct rswitch_private *priv)
+{
+	char *resource_name, *irq_name;
+	int i, ret, irq;
+
+	for (i = 0; i < GWCA_NUM_IRQS; i++) {
+		resource_name = kasprintf(GFP_KERNEL, GWCA_IRQ_RESOURCE_NAME, i);
+		if (!resource_name)
+			return -ENOMEM;
+
+		irq = platform_get_irq_byname(priv->pdev, resource_name);
+		kfree(resource_name);
+		if (irq < 0)
+			return irq;
+
+		irq_name = devm_kasprintf(&priv->pdev->dev, GFP_KERNEL,
+					  GWCA_IRQ_NAME, i);
+		if (!irq_name)
+			return -ENOMEM;
+
+		ret = devm_request_irq(&priv->pdev->dev, irq, rswitch_gwca_irq,
+				       0, irq_name, priv);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+/* Ethernet TSN Agent block (ETHA) and Ethernet MAC IP block (RMAC) */
+static int rswitch_etha_change_mode(struct rswitch_etha *etha,
+				    enum rswitch_etha_mode mode)
+{
+	int ret;
+
+	if (!rswitch_agent_clock_is_enabled(etha->coma_addr, etha->index))
+		rswitch_agent_clock_ctrl(etha->coma_addr, etha->index, 1);
+
+	iowrite32(mode, etha->addr + EAMC);
+
+	ret = rswitch_reg_wait(etha->addr, EAMS, EAMS_OPS_MASK, mode);
+
+	if (mode == EAMC_OPC_DISABLE)
+		rswitch_agent_clock_ctrl(etha->coma_addr, etha->index, 0);
+
+	return ret;
+}
+
+static void rswitch_etha_read_mac_address(struct rswitch_etha *etha)
+{
+	u32 mrmac0 = ioread32(etha->addr + MRMAC0);
+	u32 mrmac1 = ioread32(etha->addr + MRMAC1);
+	u8 *mac = &etha->mac_addr[0];
+
+	mac[0] = (mrmac0 >>  8) & 0xFF;
+	mac[1] = (mrmac0 >>  0) & 0xFF;
+	mac[2] = (mrmac1 >> 24) & 0xFF;
+	mac[3] = (mrmac1 >> 16) & 0xFF;
+	mac[4] = (mrmac1 >>  8) & 0xFF;
+	mac[5] = (mrmac1 >>  0) & 0xFF;
+}
+
+static void rswitch_etha_write_mac_address(struct rswitch_etha *etha, const u8 *mac)
+{
+	iowrite32((mac[0] << 8) | mac[1], etha->addr + MRMAC0);
+	iowrite32((mac[2] << 24) | (mac[3] << 16) | (mac[4] << 8) | mac[5],
+		  etha->addr + MRMAC1);
+}
+
+static bool rswitch_etha_wait_link_verification(struct rswitch_etha *etha)
+{
+	iowrite32(MLVC_PLV, etha->addr + MLVC);
+
+	return rswitch_reg_wait(etha->addr, MLVC, MLVC_PLV, 0);
+}
+
+static void rswitch_rmac_setting(struct rswitch_etha *etha, const u8 *mac)
+{
+	u32 val;
+
+	rswitch_etha_write_mac_address(etha, mac);
+
+	switch (etha->speed) {
+	case 100:
+		val = MPIC_LSC_100M;
+		break;
+	case 1000:
+		val = MPIC_LSC_1G;
+		break;
+	case 2500:
+		val = MPIC_LSC_2_5G;
+		break;
+	default:
+		return;
+	}
+
+	iowrite32(MPIC_PIS_GMII | val, etha->addr + MPIC);
+}
+
+static void rswitch_etha_enable_mii(struct rswitch_etha *etha)
+{
+	rswitch_modify(etha->addr, MPIC, MPIC_PSMCS_MASK | MPIC_PSMHT_MASK,
+		       MPIC_PSMCS(0x05) | MPIC_PSMHT(0x06));
+	rswitch_modify(etha->addr, MPSM, 0, MPSM_MFF_C45);
+}
+
+static int rswitch_etha_hw_init(struct rswitch_etha *etha, const u8 *mac)
+{
+	int err;
+
+	err = rswitch_etha_change_mode(etha, EAMC_OPC_DISABLE);
+	if (err < 0)
+		return err;
+	err = rswitch_etha_change_mode(etha, EAMC_OPC_CONFIG);
+	if (err < 0)
+		return err;
+
+	iowrite32(EAVCC_VEM_SC_TAG, etha->addr + EAVCC);
+	rswitch_rmac_setting(etha, mac);
+	rswitch_etha_enable_mii(etha);
+
+	err = rswitch_etha_wait_link_verification(etha);
+	if (err < 0)
+		return err;
+
+	err = rswitch_etha_change_mode(etha, EAMC_OPC_DISABLE);
+	if (err < 0)
+		return err;
+
+	return rswitch_etha_change_mode(etha, EAMC_OPC_OPERATION);
+}
+
+static int rswitch_etha_set_access(struct rswitch_etha *etha, bool read,
+				   int phyad, int devad, int regad, int data)
+{
+	int pop = read ? MDIO_READ_C45 : MDIO_WRITE_C45;
+	u32 val;
+	int ret;
+
+	if (devad == 0xffffffff)
+		return -ENODEV;
+
+	writel(MMIS1_CLEAR_FLAGS, etha->addr + MMIS1);
+
+	val = MPSM_PSME | MPSM_MFF_C45;
+	iowrite32((regad << 16) | (devad << 8) | (phyad << 3) | val, etha->addr + MPSM);
+
+	ret = rswitch_reg_wait(etha->addr, MMIS1, MMIS1_PAACS, MMIS1_PAACS);
+	if (ret)
+		return ret;
+
+	rswitch_modify(etha->addr, MMIS1, MMIS1_PAACS, MMIS1_PAACS);
+
+	if (read) {
+		writel((pop << 13) | (devad << 8) | (phyad << 3) | val, etha->addr + MPSM);
+
+		ret = rswitch_reg_wait(etha->addr, MMIS1, MMIS1_PRACS, MMIS1_PRACS);
+		if (ret)
+			return ret;
+
+		ret = (ioread32(etha->addr + MPSM) & MPSM_PRD_MASK) >> 16;
+
+		rswitch_modify(etha->addr, MMIS1, MMIS1_PRACS, MMIS1_PRACS);
+	} else {
+		iowrite32((data << 16) | (pop << 13) | (devad << 8) | (phyad << 3) | val,
+			  etha->addr + MPSM);
+
+		ret = rswitch_reg_wait(etha->addr, MMIS1, MMIS1_PWACS, MMIS1_PWACS);
+	}
+
+	return ret;
+}
+
+static int rswitch_etha_mii_read(struct mii_bus *bus, int addr, int regnum)
+{
+	struct rswitch_etha *etha = bus->priv;
+	int mode, devad, regad;
+
+	mode = regnum & MII_ADDR_C45;
+	devad = (regnum >> MII_DEVADDR_C45_SHIFT) & 0x1f;
+	regad = regnum & MII_REGADDR_C45_MASK;
+
+	/* Not support Clause 22 access method */
+	if (!mode)
+		return -EOPNOTSUPP;
+
+	return rswitch_etha_set_access(etha, true, addr, devad, regad, 0);
+}
+
+static int rswitch_etha_mii_write(struct mii_bus *bus, int addr, int regnum, u16 val)
+{
+	struct rswitch_etha *etha = bus->priv;
+	int mode, devad, regad;
+
+	mode = regnum & MII_ADDR_C45;
+	devad = (regnum >> MII_DEVADDR_C45_SHIFT) & 0x1f;
+	regad = regnum & MII_REGADDR_C45_MASK;
+
+	/* Not support Clause 22 access method */
+	if (!mode)
+		return -EOPNOTSUPP;
+
+	return rswitch_etha_set_access(etha, false, addr, devad, regad, val);
+}
+
+/* Call of_node_put(port) after done */
+static struct device_node *rswitch_get_port_node(struct rswitch_device *rdev)
+{
+	struct device_node *ports, *port;
+	int err = 0;
+	u32 index;
+
+	ports = of_get_child_by_name(rdev->ndev->dev.parent->of_node,
+				     "ethernet-ports");
+	if (!ports)
+		return NULL;
+
+	for_each_child_of_node(ports, port) {
+		err = of_property_read_u32(port, "reg", &index);
+		if (err < 0) {
+			port = NULL;
+			goto out;
+		}
+		if (index == rdev->etha->index)
+			break;
+	}
+
+out:
+	of_node_put(ports);
+
+	return port;
+}
+
+/* Call of_node_put(phy) after done */
+static struct device_node *rswitch_get_phy_node(struct rswitch_device *rdev)
+{
+	struct device_node *port, *phy = NULL;
+
+	port = rswitch_get_port_node(rdev);
+	if (!port)
+		return NULL;
+
+	phy = of_parse_phandle(port, "phy-handle", 0);
+	of_node_put(port);
+
+	return phy;
+}
+
+/* Call of_node_put(mdio) after done */
+static struct device_node *rswitch_get_mdio_node(struct rswitch_device *rdev)
+{
+	struct device_node *port, *mdio;
+
+	port = rswitch_get_port_node(rdev);
+	if (!port)
+		return NULL;
+
+	mdio = of_get_child_by_name(port, "mdio");
+	of_node_put(port);
+
+	return mdio;
+}
+
+static int rswitch_etha_get_params(struct rswitch_device *rdev)
+{
+	struct device_node *port;
+	int err;
+
+	port = rswitch_get_port_node(rdev);
+	if (!port)
+		return -ENODEV;
+
+	err = of_get_phy_mode(port, &rdev->etha->phy_interface);
+	of_node_put(port);
+
+	switch (rdev->etha->phy_interface) {
+	case PHY_INTERFACE_MODE_MII:
+		rdev->etha->speed = SPEED_100;
+		break;
+	case PHY_INTERFACE_MODE_SGMII:
+		rdev->etha->speed = SPEED_1000;
+		break;
+	case PHY_INTERFACE_MODE_USXGMII:
+		rdev->etha->speed = SPEED_2500;
+		break;
+	default:
+		err = -EINVAL;
+		break;
+	}
+
+	return err;
+}
+
+static int rswitch_mii_register(struct rswitch_device *rdev)
+{
+	struct device_node *mdio_np;
+	struct mii_bus *mii_bus;
+	int err;
+
+	mii_bus = mdiobus_alloc();
+	if (!mii_bus)
+		return -ENOMEM;
+
+	mii_bus->name = "rswitch_mii";
+	sprintf(mii_bus->id, "etha%d", rdev->etha->index);
+	mii_bus->priv = rdev->etha;
+	mii_bus->read = rswitch_etha_mii_read;
+	mii_bus->write = rswitch_etha_mii_write;
+	mii_bus->parent = &rdev->ndev->dev;
+
+	mdio_np = rswitch_get_mdio_node(rdev);
+	err = of_mdiobus_register(mii_bus, mdio_np);
+	if (err < 0) {
+		mdiobus_free(mii_bus);
+		goto out;
+	}
+
+	rdev->etha->mii = mii_bus;
+
+out:
+	of_node_put(mdio_np);
+
+	return err;
+}
+
+static void rswitch_mii_unregister(struct rswitch_device *rdev)
+{
+	if (rdev->etha && rdev->etha->mii) {
+		mdiobus_unregister(rdev->etha->mii);
+		mdiobus_free(rdev->etha->mii);
+		rdev->etha->mii = NULL;
+	}
+}
+
+static void rswitch_adjust_link(struct net_device *ndev)
+{
+	struct rswitch_device *rdev = netdev_priv(ndev);
+	struct phy_device *phydev = ndev->phydev;
+
+	/* Current hardware cannot change speed at runtime */
+	if (phydev->link != rdev->etha->link) {
+		phy_print_status(phydev);
+		rdev->etha->link = phydev->link;
+	}
+}
+
+static void rswitch_phy_remove_link_mode(struct rswitch_device *rdev,
+					 struct phy_device *phydev)
+{
+	/* Current hardware cannot change speed at runtime */
+	switch (rdev->etha->speed) {
+	case SPEED_2500:
+		phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_1000baseT_Full_BIT);
+		fallthrough;
+	case SPEED_1000:
+		phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_100baseT_Full_BIT);
+		fallthrough;
+	case SPEED_100:
+		phy_set_max_speed(phydev, rdev->etha->speed);
+		break;
+	default:
+		break;
+	}
+}
+
+static int rswitch_phy_init(struct rswitch_device *rdev, struct device_node *phy)
+{
+	struct phy_device *phydev;
+	int err = 0;
+
+	phydev = of_phy_connect(rdev->ndev, phy, rswitch_adjust_link, 0,
+				rdev->etha->phy_interface);
+	if (!phydev) {
+		err = -ENOENT;
+		goto out;
+	}
+
+	/* The hardware supports 100, 1000 and 2500Mbps with full-duplex */
+	phy_set_max_speed(phydev, SPEED_2500);
+	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Half_BIT);
+	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Full_BIT);
+	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_100baseT_Half_BIT);
+	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
+
+	rswitch_phy_remove_link_mode(rdev, phydev);
+
+	phy_attached_info(phydev);
+
+out:
+	return err;
+}
+
+static void rswitch_phy_deinit(struct rswitch_device *rdev)
+{
+	if (rdev->ndev->phydev) {
+		phy_disconnect(rdev->ndev->phydev);
+		rdev->ndev->phydev = NULL;
+	}
+}
+
+static int rswitch_serdes_init(struct rswitch_device *rdev)
+{
+	struct device_node *port = rswitch_get_port_node(rdev);
+	struct phy *serdes;
+	int err;
+
+	serdes = devm_of_phy_get(&rdev->priv->pdev->dev, port, NULL);
+	of_node_put(port);
+	if (IS_ERR(serdes))
+		return PTR_ERR(serdes);
+
+	err = phy_set_mode_ext(serdes, PHY_MODE_ETHERNET,
+			       rdev->etha->phy_interface);
+	if (err < 0)
+		return err;
+	err = phy_set_speed(serdes, rdev->etha->speed);
+	if (err < 0)
+		return err;
+
+	return phy_init(serdes);
+}
+
+static int rswitch_open(struct net_device *ndev)
+{
+	struct rswitch_device *rdev = netdev_priv(ndev);
+	struct device_node *phy;
+	int err = 0;
+
+	if (rdev->etha) {
+		if (!rdev->etha->operated) {
+			err = rswitch_etha_hw_init(rdev->etha, ndev->dev_addr);
+			if (err < 0)
+				return err;
+			rdev->etha->operated = true;
+		}
+
+		err = rswitch_mii_register(rdev);
+		if (err < 0)
+			return err;
+		phy = rswitch_get_phy_node(rdev);
+		if (!phy) {
+			err = -ENODEV;
+			goto err_phy_node;
+		}
+		err = rswitch_phy_init(rdev, phy);
+		of_node_put(phy);
+		if (err < 0)
+			goto err_phy_init;
+
+		phy_start(ndev->phydev);
+
+		err = rswitch_serdes_init(rdev);
+		if (err < 0)
+			goto err_serdes_init;
+	}
+
+	napi_enable(&rdev->napi);
+	netif_start_queue(ndev);
+
+	rswitch_enadis_data_irq(rdev->priv, rdev->tx_chain->index, true);
+	rswitch_enadis_data_irq(rdev->priv, rdev->rx_chain->index, true);
+
+	return err;
+
+err_serdes_init:
+	phy_stop(ndev->phydev);
+	rswitch_phy_deinit(rdev);
+
+err_phy_init:
+err_phy_node:
+	rswitch_mii_unregister(rdev);
+
+	return err;
+};
+
+static int rswitch_stop(struct net_device *ndev)
+{
+	struct rswitch_device *rdev = netdev_priv(ndev);
+
+	netif_tx_stop_all_queues(ndev);
+
+	rswitch_enadis_data_irq(rdev->priv, rdev->tx_chain->index, false);
+	rswitch_enadis_data_irq(rdev->priv, rdev->rx_chain->index, false);
+
+	if (rdev->etha) {
+		phy_stop(ndev->phydev);
+		rswitch_phy_deinit(rdev);
+		rswitch_mii_unregister(rdev);
+	}
+
+	napi_disable(&rdev->napi);
+
+	return 0;
+};
+
+static int rswitch_start_xmit(struct sk_buff *skb, struct net_device *ndev)
+{
+	struct rswitch_device *rdev = netdev_priv(ndev);
+	struct rswitch_gwca_chain *c = rdev->tx_chain;
+	struct rswitch_ext_desc *desc;
+	int ret = NETDEV_TX_OK;
+	dma_addr_t dma_addr;
+	int entry;
+
+	if (c->cur - c->dirty > c->num_ring - 1) {
+		netif_stop_subqueue(ndev, 0);
+		return ret;
+	}
+
+	if (skb_put_padto(skb, ETH_ZLEN))
+		return ret;
+
+	dma_addr = dma_map_single(ndev->dev.parent, skb->data, skb->len, DMA_TO_DEVICE);
+	if (dma_mapping_error(ndev->dev.parent, dma_addr)) {
+		dev_kfree_skb_any(skb);
+		return ret;
+	}
+
+	entry = c->cur % c->num_ring;
+	c->skb[entry] = skb;
+	desc = &c->ring[entry];
+	desc->dptrl = cpu_to_le32(lower_32_bits(dma_addr));
+	desc->dptrh = cpu_to_le32(upper_32_bits(dma_addr));
+	desc->info_ds = cpu_to_le16(skb->len);
+
+	dma_wmb();
+
+	desc->die_dt = DT_FSINGLE | DIE;
+	wmb();	/* c->cur must be incremented after die_dt was set */
+
+	c->cur++;
+	rswitch_modify(rdev->addr, GWTRC(c->index), 0, BIT(c->index % 32));
+
+	return ret;
+}
+
+static struct net_device_stats *rswitch_get_stats(struct net_device *ndev)
+{
+	return &ndev->stats;
+}
+
+static int rswitch_eth_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
+{
+	struct phy_device *phydev = ndev->phydev;
+
+	if (!netif_running(ndev))
+		return -EINVAL;
+	if (!phydev)
+		return -ENODEV;
+
+	return phy_mii_ioctl(phydev, req, cmd);
+}
+
+static const struct net_device_ops rswitch_netdev_ops = {
+	.ndo_open = rswitch_open,
+	.ndo_stop = rswitch_stop,
+	.ndo_start_xmit = rswitch_start_xmit,
+	.ndo_get_stats = rswitch_get_stats,
+	.ndo_eth_ioctl = rswitch_eth_ioctl,
+	.ndo_validate_addr = eth_validate_addr,
+	.ndo_set_mac_address = eth_mac_addr,
+};
+
+static const struct of_device_id renesas_eth_sw_of_table[] = {
+	{ .compatible = "renesas,r8a779f0-ether-switch", },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, renesas_eth_sw_of_table);
+
+static void rswitch_etha_init(struct rswitch_private *priv, int index)
+{
+	struct rswitch_etha *etha = &priv->etha[index];
+
+	memset(etha, 0, sizeof(*etha));
+	etha->index = index;
+	etha->addr = priv->addr + RSWITCH_ETHA_OFFSET + index * RSWITCH_ETHA_SIZE;
+	etha->coma_addr = priv->addr;
+}
+
+static int rswitch_device_alloc(struct rswitch_private *priv, int index)
+{
+	struct platform_device *pdev = priv->pdev;
+	struct rswitch_device *rdev;
+	struct net_device *ndev;
+	int err;
+
+	ndev = alloc_etherdev_mqs(sizeof(struct rswitch_device), 1, 1);
+	if (!ndev)
+		return -ENOMEM;
+
+	SET_NETDEV_DEV(ndev, &pdev->dev);
+	ether_setup(ndev);
+
+	rdev = netdev_priv(ndev);
+	rdev->ndev = ndev;
+	rdev->priv = priv;
+	priv->rdev[index] = rdev;
+	/* TODO: netdev instance : ETHA port is 1:1 mapping */
+	if (index < RSWITCH_MAX_NUM_ETHA) {
+		rdev->port = index;
+		rdev->etha = &priv->etha[index];
+	} else {
+		rdev->port = -1;
+		rdev->etha = NULL;
+	}
+	rdev->addr = priv->addr;
+
+	ndev->base_addr = (unsigned long)rdev->addr;
+	snprintf(ndev->name, IFNAMSIZ, "tsn%d", index);
+	ndev->netdev_ops = &rswitch_netdev_ops;
+
+	netif_napi_add(ndev, &rdev->napi, rswitch_poll, 64);
+
+	err = of_get_ethdev_address(pdev->dev.of_node, ndev);
+	if (err) {
+		if (rdev->etha && is_valid_ether_addr(rdev->etha->mac_addr))
+			eth_hw_addr_set(ndev, rdev->etha->mac_addr);
+		else
+			eth_hw_addr_random(ndev);
+	}
+
+	err = rswitch_etha_get_params(rdev);
+	if (err < 0)
+		goto out_get_params;
+
+	if (rdev->priv->gwca.speed < rdev->etha->speed)
+		rdev->priv->gwca.speed = rdev->etha->speed;
+
+	err = rswitch_rxdmac_alloc(ndev);
+	if (err < 0)
+		goto out_rxdmac;
+
+	err = rswitch_txdmac_alloc(ndev);
+	if (err < 0)
+		goto out_txdmac;
+
+	return 0;
+
+out_txdmac:
+	rswitch_rxdmac_free(ndev);
+
+out_rxdmac:
+out_get_params:
+	netif_napi_del(&rdev->napi);
+	free_netdev(ndev);
+
+	return err;
+}
+
+static void rswitch_device_free(struct rswitch_private *priv, int index)
+{
+	struct rswitch_device *rdev = priv->rdev[index];
+	struct net_device *ndev = rdev->ndev;
+
+	rswitch_txdmac_free(ndev);
+	rswitch_rxdmac_free(ndev);
+	netif_napi_del(&rdev->napi);
+	free_netdev(ndev);
+}
+
+static int rswitch_init(struct rswitch_private *priv)
+{
+	int i, err;
+
+	for (i = 0; i < RSWITCH_NUM_ETHA; i++)
+		rswitch_etha_init(priv, i);
+
+	rswitch_clock_enable(priv);
+	for (i = 0; i < RSWITCH_NUM_ETHA; i++)
+		rswitch_etha_read_mac_address(&priv->etha[i]);
+
+	rswitch_reset(priv);
+
+	rswitch_clock_enable(priv);
+	rswitch_top_init(priv);
+	err = rswitch_bpool_config(priv);
+	if (err < 0)
+		return err;
+
+	err = rswitch_gwca_desc_alloc(priv);
+	if (err < 0)
+		return -ENOMEM;
+
+	for (i = 0; i < RSWITCH_NUM_NDEV; i++) {
+		err = rswitch_device_alloc(priv, i);
+		if (err < 0) {
+			for (i--; i >= 0; i--)
+				rswitch_device_free(priv, i);
+			goto err_device_alloc;
+		}
+	}
+
+	rswitch_fwd_init(priv);
+
+	err = rswitch_gwca_request_irqs(priv);
+	if (err < 0)
+		goto err_gwca_request_irq;
+
+	err = rswitch_gwca_hw_init(priv);
+	if (err < 0)
+		goto err_gwca_hw_init;
+
+	for (i = 0; i < RSWITCH_NUM_NDEV; i++) {
+		err = register_netdev(priv->rdev[i]->ndev);
+		if (err) {
+			for (i--; i >= 0; i--)
+				unregister_netdev(priv->rdev[i]->ndev);
+			goto err_register_netdev;
+		}
+
+		netdev_info(priv->rdev[i]->ndev, "MAC address %pMn",
+			    priv->rdev[i]->ndev->dev_addr);
+	}
+
+	return 0;
+
+err_register_netdev:
+	rswitch_gwca_hw_deinit(priv);
+
+err_gwca_hw_init:
+err_gwca_request_irq:
+	for (i = 0; i < RSWITCH_NUM_NDEV; i++)
+		rswitch_device_free(priv, i);
+
+err_device_alloc:
+	rswitch_gwca_desc_free(priv);
+
+	return err;
+}
+
+static int renesas_eth_sw_probe(struct platform_device *pdev)
+{
+	struct rswitch_private *priv;
+	struct resource *res;
+	int ret;
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "secure_base");
+	if (!res) {
+		dev_err(&pdev->dev, "invalid resource\n");
+		return -EINVAL;
+	}
+
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->tsn_clk = devm_clk_get(&pdev->dev, "tsn");
+	if (IS_ERR(priv->tsn_clk)) {
+		dev_err(&pdev->dev, "Failed to get tsn clock: %ld\n", PTR_ERR(priv->tsn_clk));
+		return PTR_ERR(priv->tsn_clk);
+	}
+
+	platform_set_drvdata(pdev, priv);
+	priv->pdev = pdev;
+	priv->addr = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(priv->addr))
+		return PTR_ERR(priv->addr);
+
+	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(40));
+	if (ret < 0) {
+		ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
+		if (ret < 0)
+			return ret;
+	}
+
+	priv->gwca.index = AGENT_INDEX_GWCA;
+	priv->gwca.num_chains = min(RSWITCH_NUM_NDEV * NUM_CHAINS_PER_NDEV,
+				    RSWITCH_MAX_NUM_CHAINS);
+	priv->gwca.chains = devm_kcalloc(&pdev->dev, priv->gwca.num_chains,
+					 sizeof(*priv->gwca.chains), GFP_KERNEL);
+	if (!priv->gwca.chains)
+		return -ENOMEM;
+
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_get_sync(&pdev->dev);
+	clk_prepare(priv->tsn_clk);
+	clk_enable(priv->tsn_clk);
+
+	ret = rswitch_init(priv);
+
+	device_set_wakeup_capable(&pdev->dev, 1);
+
+	return ret;
+}
+
+static void rswitch_deinit(struct rswitch_private *priv)
+{
+	int i;
+
+	rswitch_gwca_hw_deinit(priv);
+
+	for (i = 0; i < RSWITCH_NUM_NDEV; i++) {
+		struct rswitch_device *rdev = priv->rdev[i];
+
+		rswitch_phy_deinit(rdev);
+		rswitch_mii_unregister(rdev);
+		unregister_netdev(rdev->ndev);
+		rswitch_device_free(priv, i);
+	}
+
+	rswitch_gwca_desc_free(priv);
+
+	rswitch_clock_disable(priv);
+}
+
+static int renesas_eth_sw_remove(struct platform_device *pdev)
+{
+	struct rswitch_private *priv = platform_get_drvdata(pdev);
+
+	rswitch_deinit(priv);
+
+	pm_runtime_put(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+	clk_disable(priv->tsn_clk);
+
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+static struct platform_driver renesas_eth_sw_driver_platform = {
+	.probe = renesas_eth_sw_probe,
+	.remove = renesas_eth_sw_remove,
+	.driver = {
+		.name = "renesas_eth_sw",
+		.of_match_table = renesas_eth_sw_of_table,
+	}
+};
+module_platform_driver(renesas_eth_sw_driver_platform);
+MODULE_AUTHOR("Yoshihiro Shimoda");
+MODULE_DESCRIPTION("Renesas Ethernet Switch device driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/ethernet/renesas/rswitch.h b/drivers/net/ethernet/renesas/rswitch.h
new file mode 100644
index 000000000000..3dd62f82abb1
--- /dev/null
+++ b/drivers/net/ethernet/renesas/rswitch.h
@@ -0,0 +1,965 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Renesas Ethernet Switch device driver
+ *
+ * Copyright (C) 2022 Renesas Electronics Corporation
+ */
+
+#ifndef __RSWITCH_H__
+#define __RSWITCH_H__
+
+#include <linux/platform_device.h>
+
+#define RSWITCH_NUM_HW		5
+#define RSWITCH_MAX_NUM_ETHA	3
+#define RSWITCH_MAX_NUM_CHAINS	128
+
+/* TODO: hardcoded number of ndev and etha for now */
+#define RSWITCH_NUM_NDEV	1
+#define RSWITCH_NUM_ETHA	1
+
+#define TX_RING_SIZE		1024
+#define RX_RING_SIZE		1024
+
+#define PKT_BUF_SZ		1584
+#define RSWITCH_ALIGN		128
+#define RSWITCH_MAX_CTAG_PCP	7
+
+#define RSWITCH_TIMEOUT_US	100000
+
+#define RSWITCH_TOP_OFFSET	0x00008000
+#define RSWITCH_COMA_OFFSET	0x00009000
+#define RSWITCH_ETHA_OFFSET	0x0000a000	/* with RMAC */
+#define RSWITCH_ETHA_SIZE	0x00002000	/* with RMAC */
+#define RSWITCH_GWCA0_OFFSET	0x00010000
+#define RSWITCH_GWCA1_OFFSET	0x00012000
+
+/* TODO: hardcoded GWCA settings for now */
+#define GWCA_IRQ_RESOURCE_NAME	"gwca0_rxtx%d"
+#define GWCA_IRQ_NAME		"rswitch: gwca0_rxtx%d"
+#define GWCA_NUM_IRQS		8
+#define GWCA_INDEX		0
+#define AGENT_INDEX_GWCA	3
+#define GWRO			RSWITCH_GWCA0_OFFSET
+
+#define FWRO	0
+#define TPRO	RSWITCH_TOP_OFFSET
+#define CARO	RSWITCH_COMA_OFFSET
+#define TARO	0
+#define RMRO	0x1000
+enum rswitch_reg {
+	FWGC		= FWRO + 0x0000,
+	FWTTC0		= FWRO + 0x0010,
+	FWTTC1		= FWRO + 0x0014,
+	FWLBMC		= FWRO + 0x0018,
+	FWCEPTC		= FWRO + 0x0020,
+	FWCEPRC0	= FWRO + 0x0024,
+	FWCEPRC1	= FWRO + 0x0028,
+	FWCEPRC2	= FWRO + 0x002c,
+	FWCLPTC		= FWRO + 0x0030,
+	FWCLPRC		= FWRO + 0x0034,
+	FWCMPTC		= FWRO + 0x0040,
+	FWEMPTC		= FWRO + 0x0044,
+	FWSDMPTC	= FWRO + 0x0050,
+	FWSDMPVC	= FWRO + 0x0054,
+	FWLBWMC0	= FWRO + 0x0080,
+	FWPC00		= FWRO + 0x0100,
+	FWPC10		= FWRO + 0x0104,
+	FWPC20		= FWRO + 0x0108,
+	FWCTGC00	= FWRO + 0x0400,
+	FWCTGC10	= FWRO + 0x0404,
+	FWCTTC00	= FWRO + 0x0408,
+	FWCTTC10	= FWRO + 0x040c,
+	FWCTTC200	= FWRO + 0x0410,
+	FWCTSC00	= FWRO + 0x0420,
+	FWCTSC10	= FWRO + 0x0424,
+	FWCTSC20	= FWRO + 0x0428,
+	FWCTSC30	= FWRO + 0x042c,
+	FWCTSC40	= FWRO + 0x0430,
+	FWTWBFC0	= FWRO + 0x1000,
+	FWTWBFVC0	= FWRO + 0x1004,
+	FWTHBFC0	= FWRO + 0x1400,
+	FWTHBFV0C0	= FWRO + 0x1404,
+	FWTHBFV1C0	= FWRO + 0x1408,
+	FWFOBFC0	= FWRO + 0x1800,
+	FWFOBFV0C0	= FWRO + 0x1804,
+	FWFOBFV1C0	= FWRO + 0x1808,
+	FWRFC0		= FWRO + 0x1c00,
+	FWRFVC0		= FWRO + 0x1c04,
+	FWCFC0		= FWRO + 0x2000,
+	FWCFMC00	= FWRO + 0x2004,
+	FWIP4SC		= FWRO + 0x4008,
+	FWIP6SC		= FWRO + 0x4018,
+	FWIP6OC		= FWRO + 0x401c,
+	FWL2SC		= FWRO + 0x4020,
+	FWSFHEC		= FWRO + 0x4030,
+	FWSHCR0		= FWRO + 0x4040,
+	FWSHCR1		= FWRO + 0x4044,
+	FWSHCR2		= FWRO + 0x4048,
+	FWSHCR3		= FWRO + 0x404c,
+	FWSHCR4		= FWRO + 0x4050,
+	FWSHCR5		= FWRO + 0x4054,
+	FWSHCR6		= FWRO + 0x4058,
+	FWSHCR7		= FWRO + 0x405c,
+	FWSHCR8		= FWRO + 0x4060,
+	FWSHCR9		= FWRO + 0x4064,
+	FWSHCR10	= FWRO + 0x4068,
+	FWSHCR11	= FWRO + 0x406c,
+	FWSHCR12	= FWRO + 0x4070,
+	FWSHCR13	= FWRO + 0x4074,
+	FWSHCRR		= FWRO + 0x4078,
+	FWLTHHEC	= FWRO + 0x4090,
+	FWLTHHC		= FWRO + 0x4094,
+	FWLTHTL0	= FWRO + 0x40a0,
+	FWLTHTL1	= FWRO + 0x40a4,
+	FWLTHTL2	= FWRO + 0x40a8,
+	FWLTHTL3	= FWRO + 0x40ac,
+	FWLTHTL4	= FWRO + 0x40b0,
+	FWLTHTL5	= FWRO + 0x40b4,
+	FWLTHTL6	= FWRO + 0x40b8,
+	FWLTHTL7	= FWRO + 0x40bc,
+	FWLTHTL80	= FWRO + 0x40c0,
+	FWLTHTL9	= FWRO + 0x40d0,
+	FWLTHTLR	= FWRO + 0x40d4,
+	FWLTHTIM	= FWRO + 0x40e0,
+	FWLTHTEM	= FWRO + 0x40e4,
+	FWLTHTS0	= FWRO + 0x4100,
+	FWLTHTS1	= FWRO + 0x4104,
+	FWLTHTS2	= FWRO + 0x4108,
+	FWLTHTS3	= FWRO + 0x410c,
+	FWLTHTS4	= FWRO + 0x4110,
+	FWLTHTSR0	= FWRO + 0x4120,
+	FWLTHTSR1	= FWRO + 0x4124,
+	FWLTHTSR2	= FWRO + 0x4128,
+	FWLTHTSR3	= FWRO + 0x412c,
+	FWLTHTSR40	= FWRO + 0x4130,
+	FWLTHTSR5	= FWRO + 0x4140,
+	FWLTHTR		= FWRO + 0x4150,
+	FWLTHTRR0	= FWRO + 0x4154,
+	FWLTHTRR1	= FWRO + 0x4158,
+	FWLTHTRR2	= FWRO + 0x415c,
+	FWLTHTRR3	= FWRO + 0x4160,
+	FWLTHTRR4	= FWRO + 0x4164,
+	FWLTHTRR5	= FWRO + 0x4168,
+	FWLTHTRR6	= FWRO + 0x416c,
+	FWLTHTRR7	= FWRO + 0x4170,
+	FWLTHTRR8	= FWRO + 0x4174,
+	FWLTHTRR9	= FWRO + 0x4180,
+	FWLTHTRR10	= FWRO + 0x4190,
+	FWIPHEC		= FWRO + 0x4214,
+	FWIPHC		= FWRO + 0x4218,
+	FWIPTL0		= FWRO + 0x4220,
+	FWIPTL1		= FWRO + 0x4224,
+	FWIPTL2		= FWRO + 0x4228,
+	FWIPTL3		= FWRO + 0x422c,
+	FWIPTL4		= FWRO + 0x4230,
+	FWIPTL5		= FWRO + 0x4234,
+	FWIPTL6		= FWRO + 0x4238,
+	FWIPTL7		= FWRO + 0x4240,
+	FWIPTL8		= FWRO + 0x4250,
+	FWIPTLR		= FWRO + 0x4254,
+	FWIPTIM		= FWRO + 0x4260,
+	FWIPTEM		= FWRO + 0x4264,
+	FWIPTS0		= FWRO + 0x4270,
+	FWIPTS1		= FWRO + 0x4274,
+	FWIPTS2		= FWRO + 0x4278,
+	FWIPTS3		= FWRO + 0x427c,
+	FWIPTS4		= FWRO + 0x4280,
+	FWIPTSR0	= FWRO + 0x4284,
+	FWIPTSR1	= FWRO + 0x4288,
+	FWIPTSR2	= FWRO + 0x428c,
+	FWIPTSR3	= FWRO + 0x4290,
+	FWIPTSR4	= FWRO + 0x42a0,
+	FWIPTR		= FWRO + 0x42b0,
+	FWIPTRR0	= FWRO + 0x42b4,
+	FWIPTRR1	= FWRO + 0x42b8,
+	FWIPTRR2	= FWRO + 0x42bc,
+	FWIPTRR3	= FWRO + 0x42c0,
+	FWIPTRR4	= FWRO + 0x42c4,
+	FWIPTRR5	= FWRO + 0x42c8,
+	FWIPTRR6	= FWRO + 0x42cc,
+	FWIPTRR7	= FWRO + 0x42d0,
+	FWIPTRR8	= FWRO + 0x42e0,
+	FWIPTRR9	= FWRO + 0x42f0,
+	FWIPHLEC	= FWRO + 0x4300,
+	FWIPAGUSPC	= FWRO + 0x4500,
+	FWIPAGC		= FWRO + 0x4504,
+	FWIPAGM0	= FWRO + 0x4510,
+	FWIPAGM1	= FWRO + 0x4514,
+	FWIPAGM2	= FWRO + 0x4518,
+	FWIPAGM3	= FWRO + 0x451c,
+	FWIPAGM4	= FWRO + 0x4520,
+	FWMACHEC	= FWRO + 0x4620,
+	FWMACHC		= FWRO + 0x4624,
+	FWMACTL0	= FWRO + 0x4630,
+	FWMACTL1	= FWRO + 0x4634,
+	FWMACTL2	= FWRO + 0x4638,
+	FWMACTL3	= FWRO + 0x463c,
+	FWMACTL4	= FWRO + 0x4640,
+	FWMACTL5	= FWRO + 0x4650,
+	FWMACTLR	= FWRO + 0x4654,
+	FWMACTIM	= FWRO + 0x4660,
+	FWMACTEM	= FWRO + 0x4664,
+	FWMACTS0	= FWRO + 0x4670,
+	FWMACTS1	= FWRO + 0x4674,
+	FWMACTSR0	= FWRO + 0x4678,
+	FWMACTSR1	= FWRO + 0x467c,
+	FWMACTSR2	= FWRO + 0x4680,
+	FWMACTSR3	= FWRO + 0x4690,
+	FWMACTR		= FWRO + 0x46a0,
+	FWMACTRR0	= FWRO + 0x46a4,
+	FWMACTRR1	= FWRO + 0x46a8,
+	FWMACTRR2	= FWRO + 0x46ac,
+	FWMACTRR3	= FWRO + 0x46b0,
+	FWMACTRR4	= FWRO + 0x46b4,
+	FWMACTRR5	= FWRO + 0x46c0,
+	FWMACTRR6	= FWRO + 0x46d0,
+	FWMACHLEC	= FWRO + 0x4700,
+	FWMACAGUSPC	= FWRO + 0x4880,
+	FWMACAGC	= FWRO + 0x4884,
+	FWMACAGM0	= FWRO + 0x4888,
+	FWMACAGM1	= FWRO + 0x488c,
+	FWVLANTEC	= FWRO + 0x4900,
+	FWVLANTL0	= FWRO + 0x4910,
+	FWVLANTL1	= FWRO + 0x4914,
+	FWVLANTL2	= FWRO + 0x4918,
+	FWVLANTL3	= FWRO + 0x4920,
+	FWVLANTL4	= FWRO + 0x4930,
+	FWVLANTLR	= FWRO + 0x4934,
+	FWVLANTIM	= FWRO + 0x4940,
+	FWVLANTEM	= FWRO + 0x4944,
+	FWVLANTS	= FWRO + 0x4950,
+	FWVLANTSR0	= FWRO + 0x4954,
+	FWVLANTSR1	= FWRO + 0x4958,
+	FWVLANTSR2	= FWRO + 0x4960,
+	FWVLANTSR3	= FWRO + 0x4970,
+	FWPBFC0		= FWRO + 0x4a00,
+	FWPBFCSDC00	= FWRO + 0x4a04,
+	FWL23URL0	= FWRO + 0x4e00,
+	FWL23URL1	= FWRO + 0x4e04,
+	FWL23URL2	= FWRO + 0x4e08,
+	FWL23URL3	= FWRO + 0x4e0c,
+	FWL23URLR	= FWRO + 0x4e10,
+	FWL23UTIM	= FWRO + 0x4e20,
+	FWL23URR	= FWRO + 0x4e30,
+	FWL23URRR0	= FWRO + 0x4e34,
+	FWL23URRR1	= FWRO + 0x4e38,
+	FWL23URRR2	= FWRO + 0x4e3c,
+	FWL23URRR3	= FWRO + 0x4e40,
+	FWL23URMC0	= FWRO + 0x4f00,
+	FWPMFGC0	= FWRO + 0x5000,
+	FWPGFC0		= FWRO + 0x5100,
+	FWPGFIGSC0	= FWRO + 0x5104,
+	FWPGFENC0	= FWRO + 0x5108,
+	FWPGFENM0	= FWRO + 0x510c,
+	FWPGFCSTC00	= FWRO + 0x5110,
+	FWPGFCSTC10	= FWRO + 0x5114,
+	FWPGFCSTM00	= FWRO + 0x5118,
+	FWPGFCSTM10	= FWRO + 0x511c,
+	FWPGFCTC0	= FWRO + 0x5120,
+	FWPGFCTM0	= FWRO + 0x5124,
+	FWPGFHCC0	= FWRO + 0x5128,
+	FWPGFSM0	= FWRO + 0x512c,
+	FWPGFGC0	= FWRO + 0x5130,
+	FWPGFGL0	= FWRO + 0x5500,
+	FWPGFGL1	= FWRO + 0x5504,
+	FWPGFGLR	= FWRO + 0x5518,
+	FWPGFGR		= FWRO + 0x5510,
+	FWPGFGRR0	= FWRO + 0x5514,
+	FWPGFGRR1	= FWRO + 0x5518,
+	FWPGFRIM	= FWRO + 0x5520,
+	FWPMTRFC0	= FWRO + 0x5600,
+	FWPMTRCBSC0	= FWRO + 0x5604,
+	FWPMTRC0RC0	= FWRO + 0x5608,
+	FWPMTREBSC0	= FWRO + 0x560c,
+	FWPMTREIRC0	= FWRO + 0x5610,
+	FWPMTRFM0	= FWRO + 0x5614,
+	FWFTL0		= FWRO + 0x6000,
+	FWFTL1		= FWRO + 0x6004,
+	FWFTLR		= FWRO + 0x6008,
+	FWFTOC		= FWRO + 0x6010,
+	FWFTOPC		= FWRO + 0x6014,
+	FWFTIM		= FWRO + 0x6020,
+	FWFTR		= FWRO + 0x6030,
+	FWFTRR0		= FWRO + 0x6034,
+	FWFTRR1		= FWRO + 0x6038,
+	FWFTRR2		= FWRO + 0x603c,
+	FWSEQNGC0	= FWRO + 0x6100,
+	FWSEQNGM0	= FWRO + 0x6104,
+	FWSEQNRC	= FWRO + 0x6200,
+	FWCTFDCN0	= FWRO + 0x6300,
+	FWLTHFDCN0	= FWRO + 0x6304,
+	FWIPFDCN0	= FWRO + 0x6308,
+	FWLTWFDCN0	= FWRO + 0x630c,
+	FWPBFDCN0	= FWRO + 0x6310,
+	FWMHLCN0	= FWRO + 0x6314,
+	FWIHLCN0	= FWRO + 0x6318,
+	FWICRDCN0	= FWRO + 0x6500,
+	FWWMRDCN0	= FWRO + 0x6504,
+	FWCTRDCN0	= FWRO + 0x6508,
+	FWLTHRDCN0	= FWRO + 0x650c,
+	FWIPRDCN0	= FWRO + 0x6510,
+	FWLTWRDCN0	= FWRO + 0x6514,
+	FWPBRDCN0	= FWRO + 0x6518,
+	FWPMFDCN0	= FWRO + 0x6700,
+	FWPGFDCN0	= FWRO + 0x6780,
+	FWPMGDCN0	= FWRO + 0x6800,
+	FWPMYDCN0	= FWRO + 0x6804,
+	FWPMRDCN0	= FWRO + 0x6808,
+	FWFRPPCN0	= FWRO + 0x6a00,
+	FWFRDPCN0	= FWRO + 0x6a04,
+	FWEIS00		= FWRO + 0x7900,
+	FWEIE00		= FWRO + 0x7904,
+	FWEID00		= FWRO + 0x7908,
+	FWEIS1		= FWRO + 0x7a00,
+	FWEIE1		= FWRO + 0x7a04,
+	FWEID1		= FWRO + 0x7a08,
+	FWEIS2		= FWRO + 0x7a10,
+	FWEIE2		= FWRO + 0x7a14,
+	FWEID2		= FWRO + 0x7a18,
+	FWEIS3		= FWRO + 0x7a20,
+	FWEIE3		= FWRO + 0x7a24,
+	FWEID3		= FWRO + 0x7a28,
+	FWEIS4		= FWRO + 0x7a30,
+	FWEIE4		= FWRO + 0x7a34,
+	FWEID4		= FWRO + 0x7a38,
+	FWEIS5		= FWRO + 0x7a40,
+	FWEIE5		= FWRO + 0x7a44,
+	FWEID5		= FWRO + 0x7a48,
+	FWEIS60		= FWRO + 0x7a50,
+	FWEIE60		= FWRO + 0x7a54,
+	FWEID60		= FWRO + 0x7a58,
+	FWEIS61		= FWRO + 0x7a60,
+	FWEIE61		= FWRO + 0x7a64,
+	FWEID61		= FWRO + 0x7a68,
+	FWEIS62		= FWRO + 0x7a70,
+	FWEIE62		= FWRO + 0x7a74,
+	FWEID62		= FWRO + 0x7a78,
+	FWEIS63		= FWRO + 0x7a80,
+	FWEIE63		= FWRO + 0x7a84,
+	FWEID63		= FWRO + 0x7a88,
+	FWEIS70		= FWRO + 0x7a90,
+	FWEIE70		= FWRO + 0x7A94,
+	FWEID70		= FWRO + 0x7a98,
+	FWEIS71		= FWRO + 0x7aa0,
+	FWEIE71		= FWRO + 0x7aa4,
+	FWEID71		= FWRO + 0x7aa8,
+	FWEIS72		= FWRO + 0x7ab0,
+	FWEIE72		= FWRO + 0x7ab4,
+	FWEID72		= FWRO + 0x7ab8,
+	FWEIS73		= FWRO + 0x7ac0,
+	FWEIE73		= FWRO + 0x7ac4,
+	FWEID73		= FWRO + 0x7ac8,
+	FWEIS80		= FWRO + 0x7ad0,
+	FWEIE80		= FWRO + 0x7ad4,
+	FWEID80		= FWRO + 0x7ad8,
+	FWEIS81		= FWRO + 0x7ae0,
+	FWEIE81		= FWRO + 0x7ae4,
+	FWEID81		= FWRO + 0x7ae8,
+	FWEIS82		= FWRO + 0x7af0,
+	FWEIE82		= FWRO + 0x7af4,
+	FWEID82		= FWRO + 0x7af8,
+	FWEIS83		= FWRO + 0x7b00,
+	FWEIE83		= FWRO + 0x7b04,
+	FWEID83		= FWRO + 0x7b08,
+	FWMIS0		= FWRO + 0x7c00,
+	FWMIE0		= FWRO + 0x7c04,
+	FWMID0		= FWRO + 0x7c08,
+	FWSCR0		= FWRO + 0x7d00,
+	FWSCR1		= FWRO + 0x7d04,
+	FWSCR2		= FWRO + 0x7d08,
+	FWSCR3		= FWRO + 0x7d0c,
+	FWSCR4		= FWRO + 0x7d10,
+	FWSCR5		= FWRO + 0x7d14,
+	FWSCR6		= FWRO + 0x7d18,
+	FWSCR7		= FWRO + 0x7d1c,
+	FWSCR8		= FWRO + 0x7d20,
+	FWSCR9		= FWRO + 0x7d24,
+	FWSCR10		= FWRO + 0x7d28,
+	FWSCR11		= FWRO + 0x7d2c,
+	FWSCR12		= FWRO + 0x7d30,
+	FWSCR13		= FWRO + 0x7d34,
+	FWSCR14		= FWRO + 0x7d38,
+	FWSCR15		= FWRO + 0x7d3c,
+	FWSCR16		= FWRO + 0x7d40,
+	FWSCR17		= FWRO + 0x7d44,
+	FWSCR18		= FWRO + 0x7d48,
+	FWSCR19		= FWRO + 0x7d4c,
+	FWSCR20		= FWRO + 0x7d50,
+	FWSCR21		= FWRO + 0x7d54,
+	FWSCR22		= FWRO + 0x7d58,
+	FWSCR23		= FWRO + 0x7d5c,
+	FWSCR24		= FWRO + 0x7d60,
+	FWSCR25		= FWRO + 0x7d64,
+	FWSCR26		= FWRO + 0x7d68,
+	FWSCR27		= FWRO + 0x7d6c,
+	FWSCR28		= FWRO + 0x7d70,
+	FWSCR29		= FWRO + 0x7d74,
+	FWSCR30		= FWRO + 0x7d78,
+	FWSCR31		= FWRO + 0x7d7c,
+	FWSCR32		= FWRO + 0x7d80,
+	FWSCR33		= FWRO + 0x7d84,
+	FWSCR34		= FWRO + 0x7d88,
+	FWSCR35		= FWRO + 0x7d8c,
+	FWSCR36		= FWRO + 0x7d90,
+	FWSCR37		= FWRO + 0x7d94,
+	FWSCR38		= FWRO + 0x7d98,
+	FWSCR39		= FWRO + 0x7d9c,
+	FWSCR40		= FWRO + 0x7da0,
+	FWSCR41		= FWRO + 0x7da4,
+	FWSCR42		= FWRO + 0x7da8,
+	FWSCR43		= FWRO + 0x7dac,
+	FWSCR44		= FWRO + 0x7db0,
+	FWSCR45		= FWRO + 0x7db4,
+	FWSCR46		= FWRO + 0x7db8,
+
+	TPEMIMC0	= TPRO + 0x0000,
+	TPEMIMC1	= TPRO + 0x0004,
+	TPEMIMC2	= TPRO + 0x0008,
+	TPEMIMC3	= TPRO + 0x000c,
+	TPEMIMC4	= TPRO + 0x0010,
+	TPEMIMC5	= TPRO + 0x0014,
+	TPEMIMC60	= TPRO + 0x0080,
+	TPEMIMC70	= TPRO + 0x0100,
+	TSIM		= TPRO + 0x0700,
+	TFIM		= TPRO + 0x0704,
+	TCIM		= TPRO + 0x0708,
+	TGIM0		= TPRO + 0x0710,
+	TGIM1		= TPRO + 0x0714,
+	TEIM0		= TPRO + 0x0720,
+	TEIM1		= TPRO + 0x0724,
+	TEIM2		= TPRO + 0x0728,
+
+	RIPV		= CARO + 0x0000,
+	RRC		= CARO + 0x0004,
+	RCEC		= CARO + 0x0008,
+	RCDC		= CARO + 0x000c,
+	RSSIS		= CARO + 0x0010,
+	RSSIE		= CARO + 0x0014,
+	RSSID		= CARO + 0x0018,
+	CABPIBWMC	= CARO + 0x0020,
+	CABPWMLC	= CARO + 0x0040,
+	CABPPFLC0	= CARO + 0x0050,
+	CABPPWMLC0	= CARO + 0x0060,
+	CABPPPFLC00	= CARO + 0x00a0,
+	CABPULC		= CARO + 0x0100,
+	CABPIRM		= CARO + 0x0140,
+	CABPPCM		= CARO + 0x0144,
+	CABPLCM		= CARO + 0x0148,
+	CABPCPM		= CARO + 0x0180,
+	CABPMCPM	= CARO + 0x0200,
+	CARDNM		= CARO + 0x0280,
+	CARDMNM		= CARO + 0x0284,
+	CARDCN		= CARO + 0x0290,
+	CAEIS0		= CARO + 0x0300,
+	CAEIE0		= CARO + 0x0304,
+	CAEID0		= CARO + 0x0308,
+	CAEIS1		= CARO + 0x0310,
+	CAEIE1		= CARO + 0x0314,
+	CAEID1		= CARO + 0x0318,
+	CAMIS0		= CARO + 0x0340,
+	CAMIE0		= CARO + 0x0344,
+	CAMID0		= CARO + 0x0348,
+	CAMIS1		= CARO + 0x0350,
+	CAMIE1		= CARO + 0x0354,
+	CAMID1		= CARO + 0x0358,
+	CASCR		= CARO + 0x0380,
+
+	EAMC		= TARO + 0x0000,
+	EAMS		= TARO + 0x0004,
+	EAIRC		= TARO + 0x0010,
+	EATDQSC		= TARO + 0x0014,
+	EATDQC		= TARO + 0x0018,
+	EATDQAC		= TARO + 0x001c,
+	EATPEC		= TARO + 0x0020,
+	EATMFSC0	= TARO + 0x0040,
+	EATDQDC0	= TARO + 0x0060,
+	EATDQM0		= TARO + 0x0080,
+	EATDQMLM0	= TARO + 0x00a0,
+	EACTQC		= TARO + 0x0100,
+	EACTDQDC	= TARO + 0x0104,
+	EACTDQM		= TARO + 0x0108,
+	EACTDQMLM	= TARO + 0x010c,
+	EAVCC		= TARO + 0x0130,
+	EAVTC		= TARO + 0x0134,
+	EATTFC		= TARO + 0x0138,
+	EACAEC		= TARO + 0x0200,
+	EACC		= TARO + 0x0204,
+	EACAIVC0	= TARO + 0x0220,
+	EACAULC0	= TARO + 0x0240,
+	EACOEM		= TARO + 0x0260,
+	EACOIVM0	= TARO + 0x0280,
+	EACOULM0	= TARO + 0x02a0,
+	EACGSM		= TARO + 0x02c0,
+	EATASC		= TARO + 0x0300,
+	EATASENC0	= TARO + 0x0320,
+	EATASCTENC	= TARO + 0x0340,
+	EATASENM0	= TARO + 0x0360,
+	EATASCTENM	= TARO + 0x0380,
+	EATASCSTC0	= TARO + 0x03a0,
+	EATASCSTC1	= TARO + 0x03a4,
+	EATASCSTM0	= TARO + 0x03a8,
+	EATASCSTM1	= TARO + 0x03ac,
+	EATASCTC	= TARO + 0x03b0,
+	EATASCTM	= TARO + 0x03b4,
+	EATASGL0	= TARO + 0x03c0,
+	EATASGL1	= TARO + 0x03c4,
+	EATASGLR	= TARO + 0x03c8,
+	EATASGR		= TARO + 0x03d0,
+	EATASGRR	= TARO + 0x03d4,
+	EATASHCC	= TARO + 0x03e0,
+	EATASRIRM	= TARO + 0x03e4,
+	EATASSM		= TARO + 0x03e8,
+	EAUSMFSECN	= TARO + 0x0400,
+	EATFECN		= TARO + 0x0404,
+	EAFSECN		= TARO + 0x0408,
+	EADQOECN	= TARO + 0x040c,
+	EADQSECN	= TARO + 0x0410,
+	EACKSECN	= TARO + 0x0414,
+	EAEIS0		= TARO + 0x0500,
+	EAEIE0		= TARO + 0x0504,
+	EAEID0		= TARO + 0x0508,
+	EAEIS1		= TARO + 0x0510,
+	EAEIE1		= TARO + 0x0514,
+	EAEID1		= TARO + 0x0518,
+	EAEIS2		= TARO + 0x0520,
+	EAEIE2		= TARO + 0x0524,
+	EAEID2		= TARO + 0x0528,
+	EASCR		= TARO + 0x0580,
+
+	MPSM		= RMRO + 0x0000,
+	MPIC		= RMRO + 0x0004,
+	MPIM		= RMRO + 0x0008,
+	MIOC		= RMRO + 0x0010,
+	MIOM		= RMRO + 0x0014,
+	MXMS		= RMRO + 0x0018,
+	MTFFC		= RMRO + 0x0020,
+	MTPFC		= RMRO + 0x0024,
+	MTPFC2		= RMRO + 0x0028,
+	MTPFC30		= RMRO + 0x0030,
+	MTATC0		= RMRO + 0x0050,
+	MTIM		= RMRO + 0x0060,
+	MRGC		= RMRO + 0x0080,
+	MRMAC0		= RMRO + 0x0084,
+	MRMAC1		= RMRO + 0x0088,
+	MRAFC		= RMRO + 0x008c,
+	MRSCE		= RMRO + 0x0090,
+	MRSCP		= RMRO + 0x0094,
+	MRSCC		= RMRO + 0x0098,
+	MRFSCE		= RMRO + 0x009c,
+	MRFSCP		= RMRO + 0x00a0,
+	MTRC		= RMRO + 0x00a4,
+	MRIM		= RMRO + 0x00a8,
+	MRPFM		= RMRO + 0x00ac,
+	MPFC0		= RMRO + 0x0100,
+	MLVC		= RMRO + 0x0180,
+	MEEEC		= RMRO + 0x0184,
+	MLBC		= RMRO + 0x0188,
+	MXGMIIC		= RMRO + 0x0190,
+	MPCH		= RMRO + 0x0194,
+	MANC		= RMRO + 0x0198,
+	MANM		= RMRO + 0x019c,
+	MPLCA1		= RMRO + 0x01a0,
+	MPLCA2		= RMRO + 0x01a4,
+	MPLCA3		= RMRO + 0x01a8,
+	MPLCA4		= RMRO + 0x01ac,
+	MPLCAM		= RMRO + 0x01b0,
+	MHDC1		= RMRO + 0x01c0,
+	MHDC2		= RMRO + 0x01c4,
+	MEIS		= RMRO + 0x0200,
+	MEIE		= RMRO + 0x0204,
+	MEID		= RMRO + 0x0208,
+	MMIS0		= RMRO + 0x0210,
+	MMIE0		= RMRO + 0x0214,
+	MMID0		= RMRO + 0x0218,
+	MMIS1		= RMRO + 0x0220,
+	MMIE1		= RMRO + 0x0224,
+	MMID1		= RMRO + 0x0228,
+	MMIS2		= RMRO + 0x0230,
+	MMIE2		= RMRO + 0x0234,
+	MMID2		= RMRO + 0x0238,
+	MMPFTCT		= RMRO + 0x0300,
+	MAPFTCT		= RMRO + 0x0304,
+	MPFRCT		= RMRO + 0x0308,
+	MFCICT		= RMRO + 0x030c,
+	MEEECT		= RMRO + 0x0310,
+	MMPCFTCT0	= RMRO + 0x0320,
+	MAPCFTCT0	= RMRO + 0x0330,
+	MPCFRCT0	= RMRO + 0x0340,
+	MHDCC		= RMRO + 0x0350,
+	MROVFC		= RMRO + 0x0354,
+	MRHCRCEC	= RMRO + 0x0358,
+	MRXBCE		= RMRO + 0x0400,
+	MRXBCP		= RMRO + 0x0404,
+	MRGFCE		= RMRO + 0x0408,
+	MRGFCP		= RMRO + 0x040c,
+	MRBFC		= RMRO + 0x0410,
+	MRMFC		= RMRO + 0x0414,
+	MRUFC		= RMRO + 0x0418,
+	MRPEFC		= RMRO + 0x041c,
+	MRNEFC		= RMRO + 0x0420,
+	MRFMEFC		= RMRO + 0x0424,
+	MRFFMEFC	= RMRO + 0x0428,
+	MRCFCEFC	= RMRO + 0x042c,
+	MRFCEFC		= RMRO + 0x0430,
+	MRRCFEFC	= RMRO + 0x0434,
+	MRUEFC		= RMRO + 0x043c,
+	MROEFC		= RMRO + 0x0440,
+	MRBOEC		= RMRO + 0x0444,
+	MTXBCE		= RMRO + 0x0500,
+	MTXBCP		= RMRO + 0x0504,
+	MTGFCE		= RMRO + 0x0508,
+	MTGFCP		= RMRO + 0x050c,
+	MTBFC		= RMRO + 0x0510,
+	MTMFC		= RMRO + 0x0514,
+	MTUFC		= RMRO + 0x0518,
+	MTEFC		= RMRO + 0x051c,
+
+	GWMC		= GWRO + 0x0000,
+	GWMS		= GWRO + 0x0004,
+	GWIRC		= GWRO + 0x0010,
+	GWRDQSC		= GWRO + 0x0014,
+	GWRDQC		= GWRO + 0x0018,
+	GWRDQAC		= GWRO + 0x001c,
+	GWRGC		= GWRO + 0x0020,
+	GWRMFSC0	= GWRO + 0x0040,
+	GWRDQDC0	= GWRO + 0x0060,
+	GWRDQM0		= GWRO + 0x0080,
+	GWRDQMLM0	= GWRO + 0x00a0,
+	GWMTIRM		= GWRO + 0x0100,
+	GWMSTLS		= GWRO + 0x0104,
+	GWMSTLR		= GWRO + 0x0108,
+	GWMSTSS		= GWRO + 0x010c,
+	GWMSTSR		= GWRO + 0x0110,
+	GWMAC0		= GWRO + 0x0120,
+	GWMAC1		= GWRO + 0x0124,
+	GWVCC		= GWRO + 0x0130,
+	GWVTC		= GWRO + 0x0134,
+	GWTTFC		= GWRO + 0x0138,
+	GWTDCAC00	= GWRO + 0x0140,
+	GWTDCAC10	= GWRO + 0x0144,
+	GWTSDCC0	= GWRO + 0x0160,
+	GWTNM		= GWRO + 0x0180,
+	GWTMNM		= GWRO + 0x0184,
+	GWAC		= GWRO + 0x0190,
+	GWDCBAC0	= GWRO + 0x0194,
+	GWDCBAC1	= GWRO + 0x0198,
+	GWIICBSC	= GWRO + 0x019c,
+	GWMDNC		= GWRO + 0x01a0,
+	GWTRC0		= GWRO + 0x0200,
+	GWTPC0		= GWRO + 0x0300,
+	GWARIRM		= GWRO + 0x0380,
+	GWDCC0		= GWRO + 0x0400,
+	GWAARSS		= GWRO + 0x0800,
+	GWAARSR0	= GWRO + 0x0804,
+	GWAARSR1	= GWRO + 0x0808,
+	GWIDAUAS0	= GWRO + 0x0840,
+	GWIDASM0	= GWRO + 0x0880,
+	GWIDASAM00	= GWRO + 0x0900,
+	GWIDASAM10	= GWRO + 0x0904,
+	GWIDACAM00	= GWRO + 0x0980,
+	GWIDACAM10	= GWRO + 0x0984,
+	GWGRLC		= GWRO + 0x0a00,
+	GWGRLULC	= GWRO + 0x0a04,
+	GWRLIVC0	= GWRO + 0x0a80,
+	GWRLULC0	= GWRO + 0x0a84,
+	GWIDPC		= GWRO + 0x0b00,
+	GWIDC0		= GWRO + 0x0c00,
+	GWDIS0		= GWRO + 0x1100,
+	GWDIE0		= GWRO + 0x1104,
+	GWDID0		= GWRO + 0x1108,
+	GWTSDIS		= GWRO + 0x1180,
+	GWTSDIE		= GWRO + 0x1184,
+	GWTSDID		= GWRO + 0x1188,
+	GWEIS0		= GWRO + 0x1190,
+	GWEIE0		= GWRO + 0x1194,
+	GWEID0		= GWRO + 0x1198,
+	GWEIS1		= GWRO + 0x11a0,
+	GWEIE1		= GWRO + 0x11a4,
+	GWEID1		= GWRO + 0x11a8,
+	GWEIS20		= GWRO + 0x1200,
+	GWEIE20		= GWRO + 0x1204,
+	GWEID20		= GWRO + 0x1208,
+	GWEIS3		= GWRO + 0x1280,
+	GWEIE3		= GWRO + 0x1284,
+	GWEID3		= GWRO + 0x1288,
+	GWEIS4		= GWRO + 0x1290,
+	GWEIE4		= GWRO + 0x1294,
+	GWEID4		= GWRO + 0x1298,
+	GWEIS5		= GWRO + 0x12a0,
+	GWEIE5		= GWRO + 0x12a4,
+	GWEID5		= GWRO + 0x12a8,
+	GWSCR0		= GWRO + 0x1800,
+	GWSCR1		= GWRO + 0x1900,
+};
+
+/* ETHA/RMAC */
+enum rswitch_etha_mode {
+	EAMC_OPC_RESET,
+	EAMC_OPC_DISABLE,
+	EAMC_OPC_CONFIG,
+	EAMC_OPC_OPERATION,
+};
+
+#define EAMS_OPS_MASK		EAMC_OPC_OPERATION
+
+#define EAVCC_VEM_SC_TAG	(0x3 << 16)
+
+#define MPIC_PIS_MII		0x00
+#define MPIC_PIS_GMII		0x02
+#define MPIC_PIS_XGMII		0x04
+#define MPIC_LSC_SHIFT		3
+#define MPIC_LSC_100M		(1 << MPIC_LSC_SHIFT)
+#define MPIC_LSC_1G		(2 << MPIC_LSC_SHIFT)
+#define MPIC_LSC_2_5G		(3 << MPIC_LSC_SHIFT)
+
+#define MDIO_READ_C45		0x03
+#define MDIO_WRITE_C45		0x01
+
+#define MPSM_PSME		BIT(0)
+#define MPSM_MFF_C45		BIT(2)
+#define MPSM_PRD_SHIFT		16
+#define MPSM_PRD_MASK		GENMASK(31, MPSM_PRD_SHIFT)
+
+/* Completion flags */
+#define MMIS1_PAACS             BIT(2) /* Address */
+#define MMIS1_PWACS             BIT(1) /* Write */
+#define MMIS1_PRACS             BIT(0) /* Read */
+#define MMIS1_CLEAR_FLAGS       0xf
+
+#define MPIC_PSMCS_SHIFT	16
+#define MPIC_PSMCS_MASK		GENMASK(22, MPIC_PSMCS_SHIFT)
+#define MPIC_PSMCS(val)		((val) << MPIC_PSMCS_SHIFT)
+
+#define MPIC_PSMHT_SHIFT	24
+#define MPIC_PSMHT_MASK		GENMASK(26, MPIC_PSMHT_SHIFT)
+#define MPIC_PSMHT(val)		((val) << MPIC_PSMHT_SHIFT)
+
+#define MLVC_PLV		BIT(16)
+
+/* GWCA */
+enum rswitch_gwca_mode {
+	GWMC_OPC_RESET,
+	GWMC_OPC_DISABLE,
+	GWMC_OPC_CONFIG,
+	GWMC_OPC_OPERATION,
+};
+
+#define GWMS_OPS_MASK		GWMC_OPC_OPERATION
+
+#define GWMTIRM_MTIOG		BIT(0)
+#define GWMTIRM_MTR		BIT(1)
+
+#define GWVCC_VEM_SC_TAG	(0x3 << 16)
+
+#define GWARIRM_ARIOG		BIT(0)
+#define GWARIRM_ARR		BIT(1)
+
+#define GWDCC_BALR		BIT(24)
+#define GWDCC_DQT		BIT(11)
+#define GWDCC_ETS		BIT(9)
+#define GWDCC_EDE		BIT(8)
+
+#define GWTRC(chain)		(GWTRC0 + (chain) / 32 * 4)
+#define GWDCC_OFFS(chain)	(GWDCC0 + (chain) * 4)
+
+#define GWDIS(i)		(GWDIS0 + (i) * 0x10)
+#define GWDIE(i)		(GWDIE0 + (i) * 0x10)
+#define GWDID(i)		(GWDID0 + (i) * 0x10)
+
+/* COMA */
+#define RRC_RR			BIT(0)
+#define RRC_RR_CLR		0
+#define RCEC_RCE		BIT(16)
+#define RCDC_RCD		BIT(16)
+
+#define CABPIRM_BPIOG		BIT(0)
+#define CABPIRM_BPR		BIT(1)
+
+/* MFWD */
+#define FWPC0_LTHTA		BIT(0)
+#define FWPC0_IP4UE		BIT(3)
+#define FWPC0_IP4TE		BIT(4)
+#define FWPC0_IP4OE		BIT(5)
+#define FWPC0_L2SE		BIT(9)
+#define FWPC0_IP4EA		BIT(10)
+#define FWPC0_IPDSA		BIT(12)
+#define FWPC0_IPHLA		BIT(18)
+#define FWPC0_MACSDA		BIT(20)
+#define FWPC0_MACHLA		BIT(26)
+#define FWPC0_MACHMA		BIT(27)
+#define FWPC0_VLANSA		BIT(28)
+
+#define FWPC0(i)		(FWPC00 + (i) * 0x10)
+#define FWPC0_DEFAULT		(FWPC0_LTHTA | FWPC0_IP4UE | FWPC0_IP4TE | \
+				 FWPC0_IP4OE | FWPC0_L2SE | FWPC0_IP4EA | \
+				 FWPC0_IPDSA | FWPC0_IPHLA | FWPC0_MACSDA | \
+				 FWPC0_MACHLA |	FWPC0_MACHMA | FWPC0_VLANSA)
+
+#define	FWPBFC(i)		(FWPBFC0 + (i) * 0x10)
+
+#define FWPBFCSDC(j, i)         (FWPBFCSDC00 + (i) * 0x10 + (j) * 0x04)
+
+/* TOP */
+#define TPEMIMC7(chain)		(TPEMIMC70 + (chain) * 4)
+
+/* Descriptors */
+enum RX_DS_CC_BIT {
+	RX_DS	= 0x0fff, /* Data size */
+	RX_TR	= 0x1000, /* Truncation indication */
+	RX_EI	= 0x2000, /* Error indication */
+	RX_PS	= 0xc000, /* Padding selection */
+};
+
+enum TX_DS_TAGL_BIT {
+	TX_DS	= 0x0fff, /* Data size */
+	TX_TAGL	= 0xf000, /* Frame tag LSBs */
+};
+
+enum DIE_DT {
+	/* Frame data */
+	DT_FSINGLE	= 0x80,
+	DT_FSTART	= 0x90,
+	DT_FMID		= 0xa0,
+	DT_FEND		= 0xb8,
+
+	/* Chain control */
+	DT_LEMPTY	= 0xc0,
+	DT_EEMPTY	= 0xd0,
+	DT_LINKFIX	= 0x00,
+	DT_LINK		= 0xe0,
+	DT_EOS		= 0xf0,
+	/* HW/SW arbitration */
+	DT_FEMPTY	= 0x40,
+	DT_FEMPTY_IS	= 0x10,
+	DT_FEMPTY_IC	= 0x20,
+	DT_FEMPTY_ND	= 0x38,
+	DT_FEMPTY_START	= 0x50,
+	DT_FEMPTY_MID	= 0x60,
+	DT_FEMPTY_END	= 0x70,
+
+	DT_MASK		= 0xf0,
+	DIE		= 0x08,	/* Descriptor Interrupt Enable */
+};
+
+struct rswitch_desc {
+	__le16 info_ds;	/* Descriptor size */
+	u8 die_dt;	/* Descriptor interrupt enable and type */
+	__u8  dptrh;	/* Descriptor pointer MSB */
+	__le32 dptrl;	/* Descriptor pointer LSW */
+} __packed;
+
+struct rswitch_ts_desc {
+	__le16 info_ds;	/* Descriptor size */
+	u8 die_dt;	/* Descriptor interrupt enable and type */
+	__u8  dptrh;	/* Descriptor pointer MSB */
+	__le32 dptrl;	/* Descriptor pointer LSW */
+	__le32 ts_nsec;
+	__le32 ts_sec;
+} __packed;
+
+struct rswitch_ext_desc {
+	__le16 info_ds;	/* Descriptor size */
+	u8 die_dt;	/* Descriptor interrupt enable and type */
+	__u8  dptrh;	/* Descriptor pointer MSB */
+	__le32 dptrl;	/* Descriptor pointer LSW */
+	__le64 info1;
+} __packed;
+
+struct rswitch_ext_ts_desc {
+	__le16 info_ds;	/* Descriptor size */
+	u8 die_dt;	/* Descriptor interrupt enable and type */
+	__u8  dptrh;	/* Descriptor pointer MSB */
+	__le32 dptrl;	/* Descriptor pointer LSW */
+	__le64 info1;
+	__le32 ts_nsec;
+	__le32 ts_sec;
+} __packed;
+
+struct rswitch_etha {
+	int index;
+	void __iomem *addr;
+	void __iomem *coma_addr;
+	bool external_phy;
+	struct mii_bus *mii;
+	phy_interface_t phy_interface;
+	u8 mac_addr[MAX_ADDR_LEN];
+	int link;
+	int speed;
+
+	/* This hardware could not be initialized twice so that marked
+	 * this flag to avoid multiple initialization.
+	 */
+	bool operated;
+};
+
+struct rswitch_gwca_chain {
+	int index;
+	bool dir_tx;
+	bool gptp;
+	union {
+		struct rswitch_ext_desc *ring;
+		struct rswitch_ext_ts_desc *ts_ring;
+	};
+	dma_addr_t ring_dma;
+	u32 num_ring;
+	u32 cur;
+	u32 dirty;
+	struct sk_buff **skb;
+
+	struct net_device *ndev;	/* chain to ndev for irq */
+};
+
+#define RSWITCH_NUM_IRQ_REGS	(RSWITCH_MAX_NUM_CHAINS / BITS_PER_TYPE(u32))
+struct rswitch_gwca {
+	int index;
+	struct rswitch_gwca_chain *chains;
+	int num_chains;
+	DECLARE_BITMAP(used, RSWITCH_MAX_NUM_CHAINS);
+	u32 tx_irq_bits[RSWITCH_NUM_IRQ_REGS];
+	u32 rx_irq_bits[RSWITCH_NUM_IRQ_REGS];
+	int speed;
+};
+
+#define NUM_CHAINS_PER_NDEV	2
+struct rswitch_device {
+	struct rswitch_private *priv;
+	struct net_device *ndev;
+	struct napi_struct napi;
+	void __iomem *addr;
+	struct rswitch_gwca_chain *tx_chain;
+	struct rswitch_gwca_chain *rx_chain;
+	u8 ts_tag;
+
+	int port;
+	struct rswitch_etha *etha;
+};
+
+struct rswitch_mfwd_mac_table_entry {
+	int chain_index;
+	unsigned char addr[MAX_ADDR_LEN];
+};
+
+struct rswitch_mfwd {
+	struct rswitch_mac_table_entry *mac_table_entries;
+	int num_mac_table_entries;
+};
+
+struct rswitch_private {
+	struct platform_device *pdev;
+	void __iomem *addr;
+	struct rswitch_desc *desc_bat;
+	dma_addr_t desc_bat_dma;
+	u32 desc_bat_size;
+
+	struct rswitch_device *rdev[RSWITCH_NUM_NDEV];
+
+	struct rswitch_gwca gwca;
+	struct rswitch_etha etha[RSWITCH_MAX_NUM_ETHA];
+	struct rswitch_mfwd mfwd;
+
+	struct clk *tsn_clk;
+
+	bool gwca_halt;
+};
+
+#endif	/* #ifndef __RSWITCH_H__ */
-- 
2.25.1

