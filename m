Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30EBD2B7204
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 00:16:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgKQXO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 18:14:56 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:19854 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725613AbgKQXOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 18:14:55 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb459720000>; Tue, 17 Nov 2020 15:14:58 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 17 Nov
 2020 23:14:53 +0000
Received: from vdi.nvidia.com (172.20.13.39) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1473.3 via Frontend
 Transport; Tue, 17 Nov 2020 23:14:53 +0000
From:   David Thompson <davthompson@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        David Thompson <davthompson@nvidia.com>,
        Asmaa Mnebhi <asmaa@nvidia.com>
Subject: [PATCH net-next v3] Add Mellanox BlueField Gigabit Ethernet driver
Date:   Tue, 17 Nov 2020 18:14:30 -0500
Message-ID: <1605654870-14859-1-git-send-email-davthompson@nvidia.com>
X-Mailer: git-send-email 2.1.2
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605654898; bh=pIN5gQvmnwdcEvQn5/bCa2XLHi2ZTRJrJVheL8e96mI=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Type;
        b=WHfhbNxYU35lKT3uEgrovFfkOG37Vv3pwJcwx2TgvDrnAqxj2mTSr00ywJrpTeswn
         Gm3U0FWXij7dhtoHX5+dn2qIbsV5bQ4I1F6uKuOsVGpImtfyGKKX9aLqeHhW3bo4kV
         egeDNkLki09O0K2qn70fYfw00AWRruMsPM6lZD5aBClLXN27nxNPjxhtDndmupTx7J
         TTkqPhlGqCfyOOmC2WkSchQiRLFHfOdTEgsmy7uVQSirZH1cl6f1AtNS2GYuMTMGNk
         ZXAxiIosYLEDQnWn6F6Bn5k7skHpM0nxUDsm0TrX1ZBM2DYFfPjKr2rCq545VUsmhq
         4PDJdIzERSUrw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds build and driver logic for the "mlxbf_gige"
Ethernet driver from Mellanox Technologies. The second
generation BlueField SoC from Mellanox supports an
out-of-band GigaBit Ethernet management port to the Arm
subsystem.  This driver supports TCP/IP network connectivity
for that port, and provides back-end routines to handle
basic ethtool requests.

The logic in "mlxbf_gige_main.c" is the driver performing
packet processing and handling ethtool management requests.
The driver interfaces to the Gigabit Ethernet block of
BlueField SoC via MMIO accesses to registers, which contain
control information or pointers describing transmit and
receive resources.  There is a single transmit queue, and
the port supports transmit ring sizes of 4 to 256 entries.
There is a single receive queue, and the port supports
receive ring sizes of 32 to 32K entries. The transmit and
receive rings are allocated from DMA coherent memory. There
is a 16-bit producer and consumer index per ring to denote
software ownership and hardware ownership, respectively.
The main driver supports the handling of some basic ethtool
requests: get driver info, get/set ring parameters, get
registers, and get statistics.

The logic in "mlxbf_gige_mdio.c" is the driver controlling
the Mellanox BlueField hardware that interacts with a PHY
device via MDIO/MDC pins.  This driver does the following:
  - At driver probe time, it configures several BlueField MDIO
    parameters such as sample rate, full drive, voltage and MDC
  - It defines functions to read and write MDIO registers and
    registers the MDIO bus.
  - It defines the phy interrupt handler reporting a
    link up/down status change
  - This driver's probe is invoked from the main driver logic
    while the phy interrupt handler is registered in ndo_open.

Driver limitations
  - Only supports 1Gbps speed
  - Only supports GMII protocol
  - Supports maximum packet size of 2KB
  - Does not support scatter-gather buffering

Testing
  - Successful build of kernel for ARM64, ARM32, X86_64
  - Tested ARM64 build on FastModels & Palladium
  - Tested ARM64 build on several Mellanox boards that are built with
    the BlueField-2 SoC.  The testing includes coverage in the areas
    of networking (e.g. ping, iperf, ifconfig, route), file transfers
    (e.g. SCP), and various ethtool options relevant to this driver.

v2 -> v3
  Added logic to handle PHY link up/down interrupts
  Use streaming DMA mapping for packet buffers
  Changed logic to use standard iopoll methods
  Changed PHY logic to not allow C45 transactions
  Enhanced the error handling in open() method
  Enhanced start_xmit() method to use xmit_more mechanism
  Added support for ndo_get_stats64
  Removed standard stats from "ethtool -S" output
v1 -> v2:
  Fixed all warnings raised by "make C=1" and "make W=1"
    a) Changed logic in mlxbf_gige_rx_deinit() and mlxbf_gige_tx_deinit()
       to initialize relevant pointers as NULL, not 0
    b) Change mlxbf_gige_get_mac_rx_filter() to return void,
       as this function's return status is not used by caller
    c) Fixed type definition of "buff" in mlxbf_gige_get_regs()

Signed-off-by: David Thompson <davthompson@nvidia.com>
Signed-off-by: Asmaa Mnebhi <asmaa@nvidia.com>
Reviewed-by: Liming Sun <limings@nvidia.com>
---
 drivers/net/ethernet/mellanox/Kconfig              |    1 +
 drivers/net/ethernet/mellanox/Makefile             |    1 +
 drivers/net/ethernet/mellanox/mlxbf_gige/Kconfig   |   13 +
 drivers/net/ethernet/mellanox/mlxbf_gige/Makefile  |    5 +
 .../net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h  |  159 +++
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c | 1292 ++++++++++++++++++++
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c |  286 +++++
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_regs.h |   78 ++
 8 files changed, 1835 insertions(+)
 create mode 100644 drivers/net/ethernet/mellanox/mlxbf_gige/Kconfig
 create mode 100644 drivers/net/ethernet/mellanox/mlxbf_gige/Makefile
 create mode 100644 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h
 create mode 100644 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
 create mode 100644 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c
 create mode 100644 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_regs.h

diff --git a/drivers/net/ethernet/mellanox/Kconfig b/drivers/net/ethernet/mellanox/Kconfig
index ff6613a..b4f66eb 100644
--- a/drivers/net/ethernet/mellanox/Kconfig
+++ b/drivers/net/ethernet/mellanox/Kconfig
@@ -22,5 +22,6 @@ source "drivers/net/ethernet/mellanox/mlx4/Kconfig"
 source "drivers/net/ethernet/mellanox/mlx5/core/Kconfig"
 source "drivers/net/ethernet/mellanox/mlxsw/Kconfig"
 source "drivers/net/ethernet/mellanox/mlxfw/Kconfig"
+source "drivers/net/ethernet/mellanox/mlxbf_gige/Kconfig"
 
 endif # NET_VENDOR_MELLANOX
diff --git a/drivers/net/ethernet/mellanox/Makefile b/drivers/net/ethernet/mellanox/Makefile
index 79773ac..d4b5f54 100644
--- a/drivers/net/ethernet/mellanox/Makefile
+++ b/drivers/net/ethernet/mellanox/Makefile
@@ -7,3 +7,4 @@ obj-$(CONFIG_MLX4_CORE) += mlx4/
 obj-$(CONFIG_MLX5_CORE) += mlx5/core/
 obj-$(CONFIG_MLXSW_CORE) += mlxsw/
 obj-$(CONFIG_MLXFW) += mlxfw/
+obj-$(CONFIG_MLXBF_GIGE) += mlxbf_gige/
diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/Kconfig b/drivers/net/ethernet/mellanox/mlxbf_gige/Kconfig
new file mode 100644
index 0000000..08a4487
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/Kconfig
@@ -0,0 +1,13 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-3-Clause
+#
+# Mellanox GigE driver configuration
+#
+
+config MLXBF_GIGE
+	tristate "Mellanox Technologies BlueField Gigabit Ethernet support"
+	depends on (ARM64 || COMPILE_TEST) && ACPI
+	select PHYLIB
+	help
+	  The second generation BlueField SoC from Mellanox Technologies
+	  supports an out-of-band Gigabit Ethernet management port to the
+	  Arm subsystem.
diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/Makefile b/drivers/net/ethernet/mellanox/mlxbf_gige/Makefile
new file mode 100644
index 0000000..e99fc19
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/Makefile
@@ -0,0 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-3-Clause
+
+obj-$(CONFIG_MLXBF_GIGE) += mlxbf_gige.o
+
+mlxbf_gige-y := mlxbf_gige_main.o mlxbf_gige_mdio.o
diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h
new file mode 100644
index 0000000..c3cb50e
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h
@@ -0,0 +1,159 @@
+/* SPDX-License-Identifier: GPL-2.0-only OR BSD-3-Clause */
+
+/* Header file for Gigabit Ethernet driver for Mellanox BlueField SoC
+ * - this file contains software data structures and any chip-specific
+ *   data structures (e.g. TX WQE format) that are memory resident.
+ *
+ * Copyright (c) 2020 NVIDIA Corporation.
+ */
+
+#ifndef __MLXBF_GIGE_H__
+#define __MLXBF_GIGE_H__
+
+#include <linux/irqreturn.h>
+#include <linux/netdevice.h>
+
+/* The silicon design supports a maximum RX ring size of
+ * 32K entries. Based on current testing this maximum size
+ * is not required to be supported.  Instead the RX ring
+ * will be capped at a realistic value of 1024 entries.
+ */
+#define MLXBF_GIGE_MIN_RXQ_SZ     32
+#define MLXBF_GIGE_MAX_RXQ_SZ     1024
+#define MLXBF_GIGE_DEFAULT_RXQ_SZ 128
+
+#define MLXBF_GIGE_MIN_TXQ_SZ     4
+#define MLXBF_GIGE_MAX_TXQ_SZ     256
+#define MLXBF_GIGE_DEFAULT_TXQ_SZ 128
+
+#define MLXBF_GIGE_DEFAULT_BUF_SZ 2048
+
+#define MLXBF_GIGE_DMA_PAGE_SZ    4096
+#define MLXBF_GIGE_DMA_PAGE_SHIFT 12
+
+/* There are four individual MAC RX filters. Currently
+ * two of them are being used: one for the broadcast MAC
+ * (index 0) and one for local MAC (index 1)
+ */
+#define MLXBF_GIGE_BCAST_MAC_FILTER_IDX 0
+#define MLXBF_GIGE_LOCAL_MAC_FILTER_IDX 1
+
+/* Define for broadcast MAC literal */
+#define BCAST_MAC_ADDR 0xFFFFFFFFFFFF
+
+/* There are three individual interrupts:
+ *   1) Errors, "OOB" interrupt line
+ *   2) Receive Packet, "OOB_LLU" interrupt line
+ *   3) LLU and PLU Events, "OOB_PLU" interrupt line
+ */
+#define MLXBF_GIGE_ERROR_INTR_IDX       0
+#define MLXBF_GIGE_RECEIVE_PKT_INTR_IDX 1
+#define MLXBF_GIGE_LLU_PLU_INTR_IDX     2
+#define MLXBF_GIGE_PHY_INT_N            3
+
+#define MLXBF_GIGE_MDIO_DEFAULT_PHY_ADDR 0x3
+
+struct mlxbf_gige_stats {
+	u64 hw_access_errors;
+	u64 tx_invalid_checksums;
+	u64 tx_small_frames;
+	u64 tx_index_errors;
+	u64 sw_config_errors;
+	u64 sw_access_errors;
+	u64 rx_truncate_errors;
+	u64 rx_mac_errors;
+	u64 rx_din_dropped_pkts;
+	u64 tx_fifo_full;
+	u64 rx_filter_passed_pkts;
+	u64 rx_filter_discard_pkts;
+};
+
+struct mlxbf_gige {
+	void __iomem *base;
+	void __iomem *llu_base;
+	void __iomem *plu_base;
+	struct device *dev;
+	struct net_device *netdev;
+	struct platform_device *pdev;
+	void __iomem *mdio_io;
+	struct mii_bus *mdiobus;
+	void __iomem *gpio_io;
+	u32 phy_int_gpio_mask;
+	spinlock_t lock;
+	spinlock_t gpio_lock;
+	u16 rx_q_entries;
+	u16 tx_q_entries;
+	u64 *tx_wqe_base;
+	dma_addr_t tx_wqe_base_dma;
+	u64 *tx_wqe_next;
+	u64 *tx_cc;
+	dma_addr_t tx_cc_dma;
+	dma_addr_t *rx_wqe_base;
+	dma_addr_t rx_wqe_base_dma;
+	u64 *rx_cqe_base;
+	dma_addr_t rx_cqe_base_dma;
+	u16 tx_pi;
+	u16 prev_tx_ci;
+	u64 error_intr_count;
+	u64 rx_intr_count;
+	u64 llu_plu_intr_count;
+	struct sk_buff *rx_skb[MLXBF_GIGE_MAX_RXQ_SZ];
+	struct sk_buff *tx_skb[MLXBF_GIGE_MAX_TXQ_SZ];
+	int error_irq;
+	int rx_irq;
+	int llu_plu_irq;
+	int phy_irq;
+	bool promisc_enabled;
+	struct napi_struct napi;
+	struct mlxbf_gige_stats stats;
+	u32 tx_pause;
+	u32 rx_pause;
+	u32 aneg_pause;
+};
+
+/* Rx Work Queue Element definitions */
+#define MLXBF_GIGE_RX_WQE_SZ                   8
+
+/* Rx Completion Queue Element definitions */
+#define MLXBF_GIGE_RX_CQE_SZ                   8
+#define MLXBF_GIGE_RX_CQE_PKT_LEN_MASK         GENMASK(10, 0)
+#define MLXBF_GIGE_RX_CQE_VALID_MASK           GENMASK(11, 11)
+#define MLXBF_GIGE_RX_CQE_PKT_STATUS_MASK      GENMASK(15, 12)
+#define MLXBF_GIGE_RX_CQE_PKT_STATUS_MAC_ERR   GENMASK(12, 12)
+#define MLXBF_GIGE_RX_CQE_PKT_STATUS_TRUNCATED GENMASK(13, 13)
+#define MLXBF_GIGE_RX_CQE_CHKSUM_MASK          GENMASK(31, 16)
+
+/* Tx Work Queue Element definitions */
+#define MLXBF_GIGE_TX_WQE_SZ_QWORDS            2
+#define MLXBF_GIGE_TX_WQE_SZ                   16
+#define MLXBF_GIGE_TX_WQE_PKT_LEN_MASK         GENMASK(10, 0)
+#define MLXBF_GIGE_TX_WQE_UPDATE_MASK          GENMASK(31, 31)
+#define MLXBF_GIGE_TX_WQE_CHKSUM_LEN_MASK      GENMASK(42, 32)
+#define MLXBF_GIGE_TX_WQE_CHKSUM_START_MASK    GENMASK(55, 48)
+#define MLXBF_GIGE_TX_WQE_CHKSUM_OFFSET_MASK   GENMASK(63, 56)
+
+/* Macro to return packet length of specified TX WQE */
+#define MLXBF_GIGE_TX_WQE_PKT_LEN(tx_wqe_addr) \
+	(*(tx_wqe_addr + 1) & MLXBF_GIGE_TX_WQE_PKT_LEN_MASK)
+
+/* Tx Completion Count */
+#define MLXBF_GIGE_TX_CC_SZ                    8
+
+/* List of resources in ACPI table */
+enum mlxbf_gige_res {
+	MLXBF_GIGE_RES_MAC,
+	MLXBF_GIGE_RES_MDIO9,
+	MLXBF_GIGE_RES_GPIO0,
+	MLXBF_GIGE_RES_LLU,
+	MLXBF_GIGE_RES_PLU
+};
+
+/* Version of register data returned by mlxbf_gige_get_regs() */
+#define MLXBF_GIGE_REGS_VERSION 1
+
+int mlxbf_gige_mdio_probe(struct platform_device *pdev,
+			  struct mlxbf_gige *priv);
+void mlxbf_gige_mdio_remove(struct mlxbf_gige *priv);
+irqreturn_t mlxbf_gige_mdio_handle_phy_interrupt(int irq, void *dev_id);
+
+#endif /* !defined(__MLXBF_GIGE_H__) */
diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
new file mode 100644
index 0000000..fdcb75c
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
@@ -0,0 +1,1292 @@
+// SPDX-License-Identifier: GPL-2.0-only OR BSD-3-Clause
+
+/* Gigabit Ethernet driver for Mellanox BlueField SoC
+ *
+ * Copyright (c) 2020 NVIDIA Corporation.
+ */
+
+#include <linux/acpi.h>
+#include <linux/device.h>
+#include <linux/dma-mapping.h>
+#include <linux/etherdevice.h>
+#include <linux/interrupt.h>
+#include <linux/io-64-nonatomic-lo-hi.h>
+#include <linux/iopoll.h>
+#include <linux/module.h>
+#include <linux/phy.h>
+#include <linux/platform_device.h>
+#include <linux/skbuff.h>
+
+#include "mlxbf_gige.h"
+#include "mlxbf_gige_regs.h"
+
+#define DRV_NAME    "mlxbf_gige"
+
+static void mlxbf_gige_set_mac_rx_filter(struct mlxbf_gige *priv,
+					 unsigned int index, u64 dmac)
+{
+	void __iomem *base = priv->base;
+	u64 control;
+
+	/* Write destination MAC to specified MAC RX filter */
+	writeq(dmac, base + MLXBF_GIGE_RX_MAC_FILTER +
+	       (index * MLXBF_GIGE_RX_MAC_FILTER_STRIDE));
+
+	/* Enable MAC receive filter mask for specified index */
+	control = readq(base + MLXBF_GIGE_CONTROL);
+	control |= (MLXBF_GIGE_CONTROL_EN_SPECIFIC_MAC << index);
+	writeq(control, base + MLXBF_GIGE_CONTROL);
+}
+
+static void mlxbf_gige_get_mac_rx_filter(struct mlxbf_gige *priv,
+					 unsigned int index, u64 *dmac)
+{
+	void __iomem *base = priv->base;
+
+	/* Read destination MAC from specified MAC RX filter */
+	*dmac = readq(base + MLXBF_GIGE_RX_MAC_FILTER +
+		      (index * MLXBF_GIGE_RX_MAC_FILTER_STRIDE));
+}
+
+static void mlxbf_gige_enable_promisc(struct mlxbf_gige *priv)
+{
+	void __iomem *base = priv->base;
+	u64 control;
+
+	/* Enable MAC_ID_RANGE match functionality */
+	control = readq(base + MLXBF_GIGE_CONTROL);
+	control |= MLXBF_GIGE_CONTROL_MAC_ID_RANGE_EN;
+	writeq(control, base + MLXBF_GIGE_CONTROL);
+
+	/* Set start of destination MAC range check to 0 */
+	writeq(0, base + MLXBF_GIGE_RX_MAC_FILTER_DMAC_RANGE_START);
+
+	/* Set end of destination MAC range check to all FFs */
+	writeq(0xFFFFFFFFFFFF, base + MLXBF_GIGE_RX_MAC_FILTER_DMAC_RANGE_END);
+}
+
+static void mlxbf_gige_disable_promisc(struct mlxbf_gige *priv)
+{
+	void __iomem *base = priv->base;
+	u64 control;
+
+	/* Disable MAC_ID_RANGE match functionality */
+	control = readq(base + MLXBF_GIGE_CONTROL);
+	control &= ~MLXBF_GIGE_CONTROL_MAC_ID_RANGE_EN;
+	writeq(control, base + MLXBF_GIGE_CONTROL);
+
+	/* NOTE: no need to change DMAC_RANGE_START or END;
+	 * those values are ignored since MAC_ID_RANGE_EN=0
+	 */
+}
+
+/* Allocate SKB whose payload pointer aligns with the Bluefield
+ * hardware DMA limitation, i.e. DMA operation can't cross
+ * a 4KB boundary.  A maximum packet size of 2KB is assumed in the
+ * alignment formula.  The alignment logic overallocates an SKB,
+ * and then adjusts the headroom so that the SKB data pointer is
+ * naturally aligned to a 2KB boundary.
+ */
+static struct sk_buff *mlxbf_gige_alloc_skb(struct mlxbf_gige *priv,
+					    dma_addr_t *buf_dma,
+					    enum dma_data_direction dir)
+{
+	unsigned long addr, offset;
+	struct sk_buff *skb;
+
+	/* Overallocate the SKB so that any headroom adjustment (to
+	 * provide 2KB natural alignment) does not exceed payload area
+	 */
+	skb = netdev_alloc_skb(priv->netdev, MLXBF_GIGE_DEFAULT_BUF_SZ * 2);
+	if (!skb)
+		return NULL;
+
+	/* Adjust the headroom so that skb->data is naturally aligned to
+	 * a 2KB boundary, which is the maximum packet size supported.
+	 */
+	addr = (unsigned long)skb->data;
+	offset = (addr + MLXBF_GIGE_DEFAULT_BUF_SZ - 1) &
+		~(MLXBF_GIGE_DEFAULT_BUF_SZ - 1);
+	offset -= addr;
+	if (offset)
+		skb_reserve(skb, offset);
+
+	/* Return streaming DMA mapping to caller */
+	*buf_dma = dma_map_single(priv->dev, skb->data,
+				  MLXBF_GIGE_DEFAULT_BUF_SZ, dir);
+	if (dma_mapping_error(priv->dev, *buf_dma)) {
+		dev_kfree_skb(skb);
+		*buf_dma = (dma_addr_t)0;
+		return NULL;
+	}
+
+	return skb;
+}
+
+/* Receive Initialization
+ * 1) Configures RX MAC filters via MMIO registers
+ * 2) Allocates RX WQE array using coherent DMA mapping
+ * 3) Initializes each element of RX WQE array with a receive
+ *    buffer pointer (also using coherent DMA mapping)
+ * 4) Allocates RX CQE array using coherent DMA mapping
+ * 5) Completes other misc receive initialization
+ */
+static int mlxbf_gige_rx_init(struct mlxbf_gige *priv)
+{
+	size_t wq_size, cq_size;
+	dma_addr_t *rx_wqe_ptr;
+	dma_addr_t rx_buf_dma;
+	u64 data;
+	int i, j;
+
+	/* Configure MAC RX filter #0 to allow RX of broadcast pkts */
+	mlxbf_gige_set_mac_rx_filter(priv, MLXBF_GIGE_BCAST_MAC_FILTER_IDX,
+				     BCAST_MAC_ADDR);
+
+	wq_size = MLXBF_GIGE_RX_WQE_SZ * priv->rx_q_entries;
+	priv->rx_wqe_base = dma_alloc_coherent(priv->dev, wq_size,
+					       &priv->rx_wqe_base_dma,
+					       GFP_KERNEL);
+	if (!priv->rx_wqe_base)
+		return -ENOMEM;
+
+	/* Initialize 'rx_wqe_ptr' to point to first RX WQE in array
+	 * Each RX WQE is simply a receive buffer pointer, so walk
+	 * the entire array, allocating a 2KB buffer for each element
+	 */
+	rx_wqe_ptr = priv->rx_wqe_base;
+
+	for (i = 0; i < priv->rx_q_entries; i++) {
+		priv->rx_skb[i] = mlxbf_gige_alloc_skb(priv, &rx_buf_dma, DMA_FROM_DEVICE);
+		if (!priv->rx_skb[i])
+			goto free_wqe_and_skb;
+
+		*rx_wqe_ptr++ = rx_buf_dma;
+	}
+
+	/* Write RX WQE base address into MMIO reg */
+	writeq(priv->rx_wqe_base_dma, priv->base + MLXBF_GIGE_RX_WQ_BASE);
+
+	cq_size = MLXBF_GIGE_RX_CQE_SZ * priv->rx_q_entries;
+	priv->rx_cqe_base = dma_alloc_coherent(priv->dev, cq_size,
+					       &priv->rx_cqe_base_dma,
+					       GFP_KERNEL);
+	if (!priv->rx_cqe_base)
+		goto free_wqe_and_skb;
+
+	/* Write RX CQE base address into MMIO reg */
+	writeq(priv->rx_cqe_base_dma, priv->base + MLXBF_GIGE_RX_CQ_BASE);
+
+	/* Write RX_WQE_PI with current number of replenished buffers */
+	writeq(priv->rx_q_entries, priv->base + MLXBF_GIGE_RX_WQE_PI);
+
+	/* Enable removal of CRC during RX */
+	data = readq(priv->base + MLXBF_GIGE_RX);
+	data |= MLXBF_GIGE_RX_STRIP_CRC_EN;
+	writeq(data, priv->base + MLXBF_GIGE_RX);
+
+	/* Enable RX MAC filter pass and discard counters */
+	writeq(MLXBF_GIGE_RX_MAC_FILTER_COUNT_DISC_EN,
+	       priv->base + MLXBF_GIGE_RX_MAC_FILTER_COUNT_DISC);
+	writeq(MLXBF_GIGE_RX_MAC_FILTER_COUNT_PASS_EN,
+	       priv->base + MLXBF_GIGE_RX_MAC_FILTER_COUNT_PASS);
+
+	/* Clear MLXBF_GIGE_INT_MASK 'receive pkt' bit to
+	 * indicate readiness to receive interrupts
+	 */
+	data = readq(priv->base + MLXBF_GIGE_INT_MASK);
+	data &= ~MLXBF_GIGE_INT_MASK_RX_RECEIVE_PACKET;
+	writeq(data, priv->base + MLXBF_GIGE_INT_MASK);
+
+	/* Enable RX DMA to write new packets to memory */
+	writeq(MLXBF_GIGE_RX_DMA_EN, priv->base + MLXBF_GIGE_RX_DMA);
+
+	writeq(ilog2(priv->rx_q_entries),
+	       priv->base + MLXBF_GIGE_RX_WQE_SIZE_LOG2);
+
+	return 0;
+
+free_wqe_and_skb:
+	rx_wqe_ptr = priv->rx_wqe_base;
+	for (j = 0; j < i; j++) {
+		dma_unmap_single(priv->dev, *rx_wqe_ptr,
+				 MLXBF_GIGE_DEFAULT_BUF_SZ, DMA_FROM_DEVICE);
+		dev_kfree_skb(priv->rx_skb[j]);
+		rx_wqe_ptr++;
+	}
+	dma_free_coherent(priv->dev, wq_size,
+			  priv->rx_wqe_base, priv->rx_wqe_base_dma);
+	return -ENOMEM;
+}
+
+/* Transmit Initialization
+ * 1) Allocates TX WQE array using coherent DMA mapping
+ * 2) Allocates TX completion counter using coherent DMA mapping
+ */
+static int mlxbf_gige_tx_init(struct mlxbf_gige *priv)
+{
+	size_t size;
+
+	size = MLXBF_GIGE_TX_WQE_SZ * priv->tx_q_entries;
+	priv->tx_wqe_base = dma_alloc_coherent(priv->dev, size,
+					       &priv->tx_wqe_base_dma,
+					       GFP_KERNEL);
+	if (!priv->tx_wqe_base)
+		return -ENOMEM;
+
+	priv->tx_wqe_next = priv->tx_wqe_base;
+
+	/* Write TX WQE base address into MMIO reg */
+	writeq(priv->tx_wqe_base_dma, priv->base + MLXBF_GIGE_TX_WQ_BASE);
+
+	/* Allocate address for TX completion count */
+	priv->tx_cc = dma_alloc_coherent(priv->dev, MLXBF_GIGE_TX_CC_SZ,
+					 &priv->tx_cc_dma, GFP_KERNEL);
+	if (!priv->tx_cc) {
+		dma_free_coherent(priv->dev, size,
+				  priv->tx_wqe_base, priv->tx_wqe_base_dma);
+		return -ENOMEM;
+	}
+
+	/* Write TX CC base address into MMIO reg */
+	writeq(priv->tx_cc_dma, priv->base + MLXBF_GIGE_TX_CI_UPDATE_ADDRESS);
+
+	writeq(ilog2(priv->tx_q_entries),
+	       priv->base + MLXBF_GIGE_TX_WQ_SIZE_LOG2);
+
+	priv->prev_tx_ci = 0;
+	priv->tx_pi = 0;
+
+	return 0;
+}
+
+/* Receive Deinitialization
+ * This routine will free allocations done by mlxbf_gige_rx_init(),
+ * namely the RX WQE and RX CQE arrays, as well as all RX buffers
+ */
+static void mlxbf_gige_rx_deinit(struct mlxbf_gige *priv)
+{
+	dma_addr_t *rx_wqe_ptr;
+	size_t size;
+	int i;
+
+	rx_wqe_ptr = priv->rx_wqe_base;
+
+	for (i = 0; i < priv->rx_q_entries; i++) {
+		dma_unmap_single(priv->dev, *rx_wqe_ptr, MLXBF_GIGE_DEFAULT_BUF_SZ,
+				 DMA_FROM_DEVICE);
+		dev_kfree_skb(priv->rx_skb[i]);
+		rx_wqe_ptr++;
+	}
+
+	size = MLXBF_GIGE_RX_WQE_SZ * priv->rx_q_entries;
+	dma_free_coherent(priv->dev, size,
+			  priv->rx_wqe_base, priv->rx_wqe_base_dma);
+
+	size = MLXBF_GIGE_RX_CQE_SZ * priv->rx_q_entries;
+	dma_free_coherent(priv->dev, size,
+			  priv->rx_cqe_base, priv->rx_cqe_base_dma);
+
+	priv->rx_wqe_base = NULL;
+	priv->rx_wqe_base_dma = 0;
+	priv->rx_cqe_base = NULL;
+	priv->rx_cqe_base_dma = 0;
+	writeq(0, priv->base + MLXBF_GIGE_RX_WQ_BASE);
+	writeq(0, priv->base + MLXBF_GIGE_RX_CQ_BASE);
+}
+
+/* Transmit Deinitialization
+ * This routine will free allocations done by mlxbf_gige_tx_init(),
+ * namely the TX WQE array and the TX completion counter
+ */
+static void mlxbf_gige_tx_deinit(struct mlxbf_gige *priv)
+{
+	u64 *tx_wqe_addr;
+	size_t size;
+	int i;
+
+	tx_wqe_addr = priv->tx_wqe_base;
+
+	for (i = 0; i < priv->tx_q_entries; i++) {
+		if (priv->tx_skb[i]) {
+			dma_unmap_single(priv->dev, *tx_wqe_addr,
+					 MLXBF_GIGE_DEFAULT_BUF_SZ, DMA_TO_DEVICE);
+			dev_kfree_skb(priv->tx_skb[i]);
+			priv->tx_skb[i] = NULL;
+		}
+		tx_wqe_addr += 2;
+	}
+
+	size = MLXBF_GIGE_TX_WQE_SZ * priv->tx_q_entries;
+	dma_free_coherent(priv->dev, size,
+			  priv->tx_wqe_base, priv->tx_wqe_base_dma);
+
+	dma_free_coherent(priv->dev, MLXBF_GIGE_TX_CC_SZ,
+			  priv->tx_cc, priv->tx_cc_dma);
+
+	priv->tx_wqe_base = NULL;
+	priv->tx_wqe_base_dma = 0;
+	priv->tx_cc = NULL;
+	priv->tx_cc_dma = 0;
+	priv->tx_wqe_next = NULL;
+	writeq(0, priv->base + MLXBF_GIGE_TX_WQ_BASE);
+	writeq(0, priv->base + MLXBF_GIGE_TX_CI_UPDATE_ADDRESS);
+}
+
+/* Start of struct ethtool_ops functions */
+static int mlxbf_gige_get_regs_len(struct net_device *netdev)
+{
+	return MLXBF_GIGE_MMIO_REG_SZ;
+}
+
+static void mlxbf_gige_get_regs(struct net_device *netdev,
+				struct ethtool_regs *regs, void *p)
+{
+	struct mlxbf_gige *priv = netdev_priv(netdev);
+
+	regs->version = MLXBF_GIGE_REGS_VERSION;
+
+	/* Read entire MMIO register space and store results
+	 * into the provided buffer. Each 64-bit word is converted
+	 * to big-endian to make the output more readable.
+	 *
+	 * NOTE: by design, a read to an offset without an existing
+	 *       register will be acknowledged and return zero.
+	 */
+	memcpy_fromio(p, priv->base, MLXBF_GIGE_MMIO_REG_SZ);
+}
+
+static void mlxbf_gige_get_ringparam(struct net_device *netdev,
+				     struct ethtool_ringparam *ering)
+{
+	struct mlxbf_gige *priv = netdev_priv(netdev);
+
+	ering->rx_max_pending = MLXBF_GIGE_MAX_RXQ_SZ;
+	ering->tx_max_pending = MLXBF_GIGE_MAX_TXQ_SZ;
+	ering->rx_pending = priv->rx_q_entries;
+	ering->tx_pending = priv->tx_q_entries;
+}
+
+static const struct {
+	const char string[ETH_GSTRING_LEN];
+} mlxbf_gige_ethtool_stats_keys[] = {
+	{ "hw_access_errors" },
+	{ "tx_invalid_checksums" },
+	{ "tx_small_frames" },
+	{ "tx_index_errors" },
+	{ "sw_config_errors" },
+	{ "sw_access_errors" },
+	{ "rx_truncate_errors" },
+	{ "rx_mac_errors" },
+	{ "rx_din_dropped_pkts" },
+	{ "tx_fifo_full" },
+	{ "rx_filter_passed_pkts" },
+	{ "rx_filter_discard_pkts" },
+};
+
+static int mlxbf_gige_get_sset_count(struct net_device *netdev, int stringset)
+{
+	if (stringset != ETH_SS_STATS)
+		return -EOPNOTSUPP;
+	return ARRAY_SIZE(mlxbf_gige_ethtool_stats_keys);
+}
+
+static void mlxbf_gige_get_strings(struct net_device *netdev, u32 stringset,
+				   u8 *buf)
+{
+	if (stringset != ETH_SS_STATS)
+		return;
+	memcpy(buf, &mlxbf_gige_ethtool_stats_keys,
+	       sizeof(mlxbf_gige_ethtool_stats_keys));
+}
+
+static void mlxbf_gige_get_ethtool_stats(struct net_device *netdev,
+					 struct ethtool_stats *estats,
+					 u64 *data)
+{
+	struct mlxbf_gige *priv = netdev_priv(netdev);
+
+	/* Fill data array with interface statistics
+	 *
+	 * NOTE: the data writes must be in
+	 *       sync with the strings shown in
+	 *       the mlxbf_gige_ethtool_stats_keys[] array
+	 *
+	 * NOTE2: certain statistics below are zeroed upon
+	 *        port disable, so the calculation below
+	 *        must include the "cached" value of the stat
+	 *        plus the value read directly from hardware.
+	 *        Cached statistics are currently:
+	 *          rx_din_dropped_pkts
+	 *          rx_filter_passed_pkts
+	 *          rx_filter_discard_pkts
+	 */
+	*data++ = priv->stats.hw_access_errors;
+	*data++ = priv->stats.tx_invalid_checksums;
+	*data++ = priv->stats.tx_small_frames;
+	*data++ = priv->stats.tx_index_errors;
+	*data++ = priv->stats.sw_config_errors;
+	*data++ = priv->stats.sw_access_errors;
+	*data++ = priv->stats.rx_truncate_errors;
+	*data++ = priv->stats.rx_mac_errors;
+	*data++ = (priv->stats.rx_din_dropped_pkts +
+		   readq(priv->base + MLXBF_GIGE_RX_DIN_DROP_COUNTER));
+	*data++ = priv->stats.tx_fifo_full;
+	*data++ = (priv->stats.rx_filter_passed_pkts +
+		   readq(priv->base + MLXBF_GIGE_RX_PASS_COUNTER_ALL));
+	*data++ = (priv->stats.rx_filter_discard_pkts +
+		   readq(priv->base + MLXBF_GIGE_RX_DISC_COUNTER_ALL));
+}
+
+static void mlxbf_gige_get_pauseparam(struct net_device *netdev,
+				      struct ethtool_pauseparam *pause)
+{
+	struct mlxbf_gige *priv = netdev_priv(netdev);
+
+	pause->autoneg = priv->aneg_pause;
+	pause->rx_pause = priv->tx_pause;
+	pause->tx_pause = priv->rx_pause;
+}
+
+static const struct ethtool_ops mlxbf_gige_ethtool_ops = {
+	.get_link		= ethtool_op_get_link,
+	.get_ringparam		= mlxbf_gige_get_ringparam,
+	.get_regs_len           = mlxbf_gige_get_regs_len,
+	.get_regs               = mlxbf_gige_get_regs,
+	.get_strings            = mlxbf_gige_get_strings,
+	.get_sset_count         = mlxbf_gige_get_sset_count,
+	.get_ethtool_stats      = mlxbf_gige_get_ethtool_stats,
+	.nway_reset		= phy_ethtool_nway_reset,
+	.get_pauseparam		= mlxbf_gige_get_pauseparam,
+	.get_link_ksettings	= phy_ethtool_get_link_ksettings,
+};
+
+/* Start of struct net_device_ops functions */
+static irqreturn_t mlxbf_gige_error_intr(int irq, void *dev_id)
+{
+	struct mlxbf_gige *priv;
+	u64 int_status;
+
+	priv = dev_id;
+
+	priv->error_intr_count++;
+
+	int_status = readq(priv->base + MLXBF_GIGE_INT_STATUS);
+
+	if (int_status & MLXBF_GIGE_INT_STATUS_HW_ACCESS_ERROR)
+		priv->stats.hw_access_errors++;
+
+	if (int_status & MLXBF_GIGE_INT_STATUS_TX_CHECKSUM_INPUTS) {
+		priv->stats.tx_invalid_checksums++;
+		/* This error condition is latched into MLXBF_GIGE_INT_STATUS
+		 * when the GigE silicon operates on the offending
+		 * TX WQE. The write to MLXBF_GIGE_INT_STATUS at the bottom
+		 * of this routine clears this error condition.
+		 */
+	}
+
+	if (int_status & MLXBF_GIGE_INT_STATUS_TX_SMALL_FRAME_SIZE) {
+		priv->stats.tx_small_frames++;
+		/* This condition happens when the networking stack invokes
+		 * this driver's "start_xmit()" method with a packet whose
+		 * size < 60 bytes.  The GigE silicon will automatically pad
+		 * this small frame up to a minimum-sized frame before it is
+		 * sent. The "tx_small_frame" condition is latched into the
+		 * MLXBF_GIGE_INT_STATUS register when the GigE silicon
+		 * operates on the offending TX WQE. The write to
+		 * MLXBF_GIGE_INT_STATUS at the bottom of this routine
+		 * clears this condition.
+		 */
+	}
+
+	if (int_status & MLXBF_GIGE_INT_STATUS_TX_PI_CI_EXCEED_WQ_SIZE)
+		priv->stats.tx_index_errors++;
+
+	if (int_status & MLXBF_GIGE_INT_STATUS_SW_CONFIG_ERROR)
+		priv->stats.sw_config_errors++;
+
+	if (int_status & MLXBF_GIGE_INT_STATUS_SW_ACCESS_ERROR)
+		priv->stats.sw_access_errors++;
+
+	/* Clear all error interrupts by writing '1' back to
+	 * all the asserted bits in INT_STATUS.  Do not write
+	 * '1' back to 'receive packet' bit, since that is
+	 * managed separately.
+	 */
+
+	int_status &= ~MLXBF_GIGE_INT_STATUS_RX_RECEIVE_PACKET;
+
+	writeq(int_status, priv->base + MLXBF_GIGE_INT_STATUS);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t mlxbf_gige_rx_intr(int irq, void *dev_id)
+{
+	struct mlxbf_gige *priv;
+
+	priv = dev_id;
+
+	priv->rx_intr_count++;
+
+	/* NOTE: GigE silicon automatically disables "packet rx" interrupt by
+	 *       setting MLXBF_GIGE_INT_MASK bit0 upon triggering the interrupt
+	 *       to the ARM cores.  Software needs to re-enable "packet rx"
+	 *       interrupts by clearing MLXBF_GIGE_INT_MASK bit0.
+	 */
+
+	napi_schedule(&priv->napi);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t mlxbf_gige_llu_plu_intr(int irq, void *dev_id)
+{
+	struct mlxbf_gige *priv;
+
+	priv = dev_id;
+	priv->llu_plu_intr_count++;
+
+	return IRQ_HANDLED;
+}
+
+/* Function that returns status of TX ring:
+ *          0: TX ring is full, i.e. there are no
+ *             available un-used entries in TX ring.
+ *   non-null: TX ring is not full, i.e. there are
+ *             some available entries in TX ring.
+ *             The non-null value is a measure of
+ *             how many TX entries are available, but
+ *             it is not the exact number of available
+ *             entries (see below).
+ *
+ * The algorithm makes the assumption that if
+ * (prev_tx_ci == tx_pi) then the TX ring is empty.
+ * An empty ring actually has (tx_q_entries-1)
+ * entries, which allows the algorithm to differentiate
+ * the case of an empty ring vs. a full ring.
+ */
+static u16 mlxbf_gige_tx_buffs_avail(struct mlxbf_gige *priv)
+{
+	unsigned long flags;
+	u16 avail;
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	if (priv->prev_tx_ci == priv->tx_pi)
+		avail = priv->tx_q_entries - 1;
+	else
+		avail = ((priv->tx_q_entries + priv->prev_tx_ci - priv->tx_pi)
+			  % priv->tx_q_entries) - 1;
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	return avail;
+}
+
+static bool mlxbf_gige_handle_tx_complete(struct mlxbf_gige *priv)
+{
+	struct net_device_stats *stats;
+	u16 tx_wqe_index;
+	u64 *tx_wqe_addr;
+	u64 tx_status;
+	u16 tx_ci;
+
+	tx_status = readq(priv->base + MLXBF_GIGE_TX_STATUS);
+	if (tx_status & MLXBF_GIGE_TX_STATUS_DATA_FIFO_FULL)
+		priv->stats.tx_fifo_full++;
+	tx_ci = readq(priv->base + MLXBF_GIGE_TX_CONSUMER_INDEX);
+	stats = &priv->netdev->stats;
+
+	/* Transmit completion logic needs to loop until the completion
+	 * index (in SW) equals TX consumer index (from HW).  These
+	 * parameters are unsigned 16-bit values and the wrap case needs
+	 * to be supported, that is TX consumer index wrapped from 0xFFFF
+	 * to 0 while TX completion index is still < 0xFFFF.
+	 */
+	for (; priv->prev_tx_ci != tx_ci; priv->prev_tx_ci++) {
+		tx_wqe_index = priv->prev_tx_ci % priv->tx_q_entries;
+		/* Each TX WQE is 16 bytes. The 8 MSB store the 2KB TX
+		 * buffer address and the 8 LSB contain information
+		 * about the TX WQE.
+		 */
+		tx_wqe_addr = priv->tx_wqe_base +
+			       (tx_wqe_index * MLXBF_GIGE_TX_WQE_SZ_QWORDS);
+
+		stats->tx_packets++;
+		stats->tx_bytes += MLXBF_GIGE_TX_WQE_PKT_LEN(tx_wqe_addr);
+
+		dma_unmap_single(priv->dev, *tx_wqe_addr,
+				 MLXBF_GIGE_DEFAULT_BUF_SZ, DMA_TO_DEVICE);
+		dev_consume_skb_any(priv->tx_skb[tx_wqe_index]);
+		priv->tx_skb[tx_wqe_index] = NULL;
+	}
+
+	/* Since the TX ring was likely just drained, check if TX queue
+	 * had previously been stopped and now that there are TX buffers
+	 * available the TX queue can be awakened.
+	 */
+	if (netif_queue_stopped(priv->netdev) &&
+	    mlxbf_gige_tx_buffs_avail(priv))
+		netif_wake_queue(priv->netdev);
+
+	return true;
+}
+
+static bool mlxbf_gige_rx_packet(struct mlxbf_gige *priv, int *rx_pkts)
+{
+	struct net_device *netdev = priv->netdev;
+	u16 rx_pi_rem, rx_ci_rem;
+	dma_addr_t *rx_wqe_addr;
+	dma_addr_t rx_buf_dma;
+	struct sk_buff *skb;
+	u64 *rx_cqe_addr;
+	u64 datalen;
+	u64 rx_cqe;
+	u16 rx_ci;
+	u16 rx_pi;
+
+	/* Index into RX buffer array is rx_pi w/wrap based on RX_CQE_SIZE */
+	rx_pi = readq(priv->base + MLXBF_GIGE_RX_WQE_PI);
+	rx_pi_rem = rx_pi % priv->rx_q_entries;
+	rx_wqe_addr = priv->rx_wqe_base + rx_pi_rem;
+	dma_unmap_single(priv->dev, *rx_wqe_addr,
+			 MLXBF_GIGE_DEFAULT_BUF_SZ, DMA_FROM_DEVICE);
+	rx_cqe_addr = priv->rx_cqe_base + rx_pi_rem;
+	rx_cqe = *rx_cqe_addr;
+
+	if ((rx_cqe & MLXBF_GIGE_RX_CQE_PKT_STATUS_MASK) == 0) {
+		/* Packet is OK, increment stats */
+		datalen = rx_cqe & MLXBF_GIGE_RX_CQE_PKT_LEN_MASK;
+		netdev->stats.rx_packets++;
+		netdev->stats.rx_bytes += datalen;
+
+		skb = priv->rx_skb[rx_pi_rem];
+
+		skb_put(skb, datalen);
+
+		skb->ip_summed = CHECKSUM_NONE; /* device did not checksum packet */
+
+		skb->protocol = eth_type_trans(skb, netdev);
+		netif_receive_skb(skb);
+
+		/* Alloc another RX SKB for this same index */
+		priv->rx_skb[rx_pi_rem] = mlxbf_gige_alloc_skb(priv, &rx_buf_dma,
+							       DMA_FROM_DEVICE);
+		if (!priv->rx_skb[rx_pi_rem]) {
+			netdev->stats.rx_dropped++;
+			return false;
+		}
+
+		*rx_wqe_addr = rx_buf_dma;
+	} else if (rx_cqe & MLXBF_GIGE_RX_CQE_PKT_STATUS_MAC_ERR) {
+		priv->stats.rx_mac_errors++;
+	} else if (rx_cqe & MLXBF_GIGE_RX_CQE_PKT_STATUS_TRUNCATED) {
+		priv->stats.rx_truncate_errors++;
+	}
+
+	/* Let hardware know we've replenished one buffer */
+	rx_pi++;
+	writeq(rx_pi, priv->base + MLXBF_GIGE_RX_WQE_PI);
+
+	(*rx_pkts)++;
+
+	rx_pi_rem = rx_pi % priv->rx_q_entries;
+	rx_ci = readq(priv->base + MLXBF_GIGE_RX_CQE_PACKET_CI);
+	rx_ci_rem = rx_ci % priv->rx_q_entries;
+
+	return rx_pi_rem != rx_ci_rem;
+}
+
+/* Driver poll() function called by NAPI infrastructure */
+static int mlxbf_gige_poll(struct napi_struct *napi, int budget)
+{
+	struct mlxbf_gige *priv;
+	bool remaining_pkts;
+	int work_done = 0;
+	u64 data;
+
+	priv = container_of(napi, struct mlxbf_gige, napi);
+
+	mlxbf_gige_handle_tx_complete(priv);
+
+	do {
+		remaining_pkts = mlxbf_gige_rx_packet(priv, &work_done);
+	} while (remaining_pkts && work_done < budget);
+
+	/* If amount of work done < budget, turn off NAPI polling
+	 * via napi_complete_done(napi, work_done) and then
+	 * re-enable interrupts.
+	 */
+	if (work_done < budget && napi_complete_done(napi, work_done)) {
+		/* Clear MLXBF_GIGE_INT_MASK 'receive pkt' bit to
+		 * indicate receive readiness
+		 */
+		data = readq(priv->base + MLXBF_GIGE_INT_MASK);
+		data &= ~MLXBF_GIGE_INT_MASK_RX_RECEIVE_PACKET;
+		writeq(data, priv->base + MLXBF_GIGE_INT_MASK);
+	}
+
+	return work_done;
+}
+
+static int mlxbf_gige_request_irqs(struct mlxbf_gige *priv)
+{
+	int err;
+
+	err = request_irq(priv->error_irq, mlxbf_gige_error_intr, 0,
+			  "mlxbf_gige_error", priv);
+	if (err) {
+		dev_err(priv->dev, "Request error_irq failure\n");
+		return err;
+	}
+
+	err = request_irq(priv->rx_irq, mlxbf_gige_rx_intr, 0,
+			  "mlxbf_gige_rx", priv);
+	if (err) {
+		dev_err(priv->dev, "Request rx_irq failure\n");
+		goto free_error_irq;
+	}
+
+	err = request_irq(priv->llu_plu_irq, mlxbf_gige_llu_plu_intr, 0,
+			  "mlxbf_gige_llu_plu", priv);
+	if (err) {
+		dev_err(priv->dev, "Request llu_plu_irq failure\n");
+		goto free_rx_irq;
+	}
+
+	err = request_threaded_irq(priv->phy_irq, NULL,
+				   mlxbf_gige_mdio_handle_phy_interrupt,
+				   IRQF_ONESHOT | IRQF_SHARED,
+				   "mlxbf_gige_phy", priv);
+	if (err) {
+		dev_err(priv->dev, "Request phy_irq failure\n");
+		goto free_llu_plu_irq;
+	}
+
+	return 0;
+
+free_llu_plu_irq:
+	free_irq(priv->llu_plu_irq, priv);
+
+free_rx_irq:
+	free_irq(priv->rx_irq, priv);
+
+free_error_irq:
+	free_irq(priv->error_irq, priv);
+
+	return err;
+}
+
+static void mlxbf_gige_free_irqs(struct mlxbf_gige *priv)
+{
+	free_irq(priv->error_irq, priv);
+	free_irq(priv->rx_irq, priv);
+	free_irq(priv->llu_plu_irq, priv);
+	free_irq(priv->phy_irq, priv);
+}
+
+static void mlxbf_gige_cache_stats(struct mlxbf_gige *priv)
+{
+	struct mlxbf_gige_stats *p;
+
+	/* Cache stats that will be cleared by clean port operation */
+	p = &priv->stats;
+	p->rx_din_dropped_pkts += readq(priv->base +
+					MLXBF_GIGE_RX_DIN_DROP_COUNTER);
+	p->rx_filter_passed_pkts += readq(priv->base +
+					  MLXBF_GIGE_RX_PASS_COUNTER_ALL);
+	p->rx_filter_discard_pkts += readq(priv->base +
+					   MLXBF_GIGE_RX_DISC_COUNTER_ALL);
+}
+
+static int mlxbf_gige_clean_port(struct mlxbf_gige *priv)
+{
+	u64 control;
+	u64 temp;
+	int err;
+
+	/* Set the CLEAN_PORT_EN bit to trigger SW reset */
+	control = readq(priv->base + MLXBF_GIGE_CONTROL);
+	control |= MLXBF_GIGE_CONTROL_CLEAN_PORT_EN;
+	writeq(control, priv->base + MLXBF_GIGE_CONTROL);
+
+	err = readq_poll_timeout_atomic(priv->base + MLXBF_GIGE_STATUS, temp,
+					(temp & MLXBF_GIGE_STATUS_READY),
+					100, 100000);
+
+	/* Clear the CLEAN_PORT_EN bit at end of this loop */
+	control = readq(priv->base + MLXBF_GIGE_CONTROL);
+	control &= ~MLXBF_GIGE_CONTROL_CLEAN_PORT_EN;
+	writeq(control, priv->base + MLXBF_GIGE_CONTROL);
+
+	return err;
+}
+
+static int mlxbf_gige_phy_enable_interrupt(struct phy_device *phydev)
+{
+	int err = 0;
+
+	if (phydev->drv->ack_interrupt)
+		err = phydev->drv->ack_interrupt(phydev);
+	if (err < 0)
+		return err;
+
+	phydev->interrupts = PHY_INTERRUPT_ENABLED;
+	if (phydev->drv->config_intr)
+		err = phydev->drv->config_intr(phydev);
+
+	return err;
+}
+
+static int mlxbf_gige_phy_disable_interrupt(struct phy_device *phydev)
+{
+	int err = 0;
+
+	if (phydev->drv->ack_interrupt)
+		err = phydev->drv->ack_interrupt(phydev);
+	if (err < 0)
+		return err;
+
+	phydev->interrupts = PHY_INTERRUPT_DISABLED;
+	if (phydev->drv->config_intr)
+		err = phydev->drv->config_intr(phydev);
+
+	return err;
+}
+
+static int mlxbf_gige_open(struct net_device *netdev)
+{
+	struct mlxbf_gige *priv = netdev_priv(netdev);
+	struct phy_device *phydev = netdev->phydev;
+	u64 int_en;
+	int err;
+
+	err = mlxbf_gige_request_irqs(priv);
+	if (err)
+		return err;
+	mlxbf_gige_cache_stats(priv);
+	err = mlxbf_gige_clean_port(priv);
+	if (err)
+		return err;
+	err = mlxbf_gige_rx_init(priv);
+	if (err)
+		return err;
+	err = mlxbf_gige_tx_init(priv);
+	if (err)
+		return err;
+
+	phy_start(phydev);
+	/* Always make sure interrupts are enabled since phy_start calls
+	 * __phy_resume which may reset the PHY interrupt control reg.
+	 * __phy_resume only reenables the interrupts if
+	 * phydev->irq != IRQ_IGNORE_INTERRUPT.
+	 */
+	err = mlxbf_gige_phy_enable_interrupt(phydev);
+	if (err)
+		return err;
+
+	netif_napi_add(netdev, &priv->napi, mlxbf_gige_poll, NAPI_POLL_WEIGHT);
+	napi_enable(&priv->napi);
+	netif_start_queue(netdev);
+
+	/* Set bits in INT_EN that we care about */
+	int_en = MLXBF_GIGE_INT_EN_HW_ACCESS_ERROR |
+		 MLXBF_GIGE_INT_EN_TX_CHECKSUM_INPUTS |
+		 MLXBF_GIGE_INT_EN_TX_SMALL_FRAME_SIZE |
+		 MLXBF_GIGE_INT_EN_TX_PI_CI_EXCEED_WQ_SIZE |
+		 MLXBF_GIGE_INT_EN_SW_CONFIG_ERROR |
+		 MLXBF_GIGE_INT_EN_SW_ACCESS_ERROR |
+		 MLXBF_GIGE_INT_EN_RX_RECEIVE_PACKET;
+	writeq(int_en, priv->base + MLXBF_GIGE_INT_EN);
+
+	return 0;
+}
+
+static int mlxbf_gige_stop(struct net_device *netdev)
+{
+	struct mlxbf_gige *priv = netdev_priv(netdev);
+
+	writeq(0, priv->base + MLXBF_GIGE_INT_EN);
+	netif_stop_queue(netdev);
+	napi_disable(&priv->napi);
+	netif_napi_del(&priv->napi);
+	mlxbf_gige_free_irqs(priv);
+
+	phy_stop(netdev->phydev);
+	mlxbf_gige_phy_disable_interrupt(netdev->phydev);
+
+	mlxbf_gige_rx_deinit(priv);
+	mlxbf_gige_tx_deinit(priv);
+	mlxbf_gige_cache_stats(priv);
+	mlxbf_gige_clean_port(priv);
+
+	return 0;
+}
+
+/* Function to advance the tx_wqe_next pointer to next TX WQE */
+static void mlxbf_gige_update_tx_wqe_next(struct mlxbf_gige *priv)
+{
+	/* Advance tx_wqe_next pointer */
+	priv->tx_wqe_next += MLXBF_GIGE_TX_WQE_SZ_QWORDS;
+
+	/* Check if 'next' pointer is beyond end of TX ring */
+	/* If so, set 'next' back to 'base' pointer of ring */
+	if (priv->tx_wqe_next == (priv->tx_wqe_base +
+				  (priv->tx_q_entries * MLXBF_GIGE_TX_WQE_SZ_QWORDS)))
+		priv->tx_wqe_next = priv->tx_wqe_base;
+}
+
+static netdev_tx_t mlxbf_gige_start_xmit(struct sk_buff *skb,
+					 struct net_device *netdev)
+{
+	unsigned long buff_addr, start_dma_page, end_dma_page;
+	struct mlxbf_gige *priv = netdev_priv(netdev);
+	struct sk_buff *tx_skb;
+	dma_addr_t tx_buf_dma;
+	u64 *tx_wqe_addr;
+	u64 word2;
+
+	/* If needed, linearize TX SKB as hardware DMA expects this */
+	if (skb_linearize(skb)) {
+		dev_kfree_skb(skb);
+		netdev->stats.tx_dropped++;
+		return NET_XMIT_DROP;
+	}
+
+	buff_addr = (unsigned long)skb->data;
+	start_dma_page = buff_addr >> MLXBF_GIGE_DMA_PAGE_SHIFT;
+	end_dma_page   = (buff_addr + skb->len - 1) >> MLXBF_GIGE_DMA_PAGE_SHIFT;
+
+	/* Verify that payload pointer and data length of SKB to be
+	 * transmitted does not violate the hardware DMA limitation.
+	 */
+	if (start_dma_page != end_dma_page) {
+		/* DMA operation would fail as-is, alloc new aligned SKB */
+		tx_skb = mlxbf_gige_alloc_skb(priv, &tx_buf_dma, DMA_TO_DEVICE);
+		if (!tx_skb) {
+			/* Free original skb, could not alloc new aligned SKB */
+			dev_kfree_skb(skb);
+			netdev->stats.tx_dropped++;
+			return NET_XMIT_DROP;
+		}
+
+		skb_put_data(tx_skb, skb->data, skb->len);
+		dev_kfree_skb(skb);
+	} else {
+		tx_skb = skb;
+		tx_buf_dma = dma_map_single(priv->dev, skb->data,
+					    MLXBF_GIGE_DEFAULT_BUF_SZ,
+					    DMA_TO_DEVICE);
+		if (dma_mapping_error(priv->dev, tx_buf_dma)) {
+			dev_kfree_skb(skb);
+			netdev->stats.tx_dropped++;
+			return NET_XMIT_DROP;
+		}
+	}
+
+	priv->tx_skb[priv->tx_pi % priv->tx_q_entries] = tx_skb;
+
+	/* Get address of TX WQE */
+	tx_wqe_addr = priv->tx_wqe_next;
+
+	mlxbf_gige_update_tx_wqe_next(priv);
+
+	/* Put PA of buffer address into first 64-bit word of TX WQE */
+	*tx_wqe_addr = tx_buf_dma;
+
+	/* Set TX WQE pkt_len appropriately
+	 * NOTE: GigE silicon will automatically pad up to
+	 *       minimum packet length if needed.
+	 */
+	word2 = tx_skb->len & MLXBF_GIGE_TX_WQE_PKT_LEN_MASK;
+
+	/* Write entire 2nd word of TX WQE */
+	*(tx_wqe_addr + 1) = word2;
+
+	priv->tx_pi++;
+
+	if (!netdev_xmit_more()) {
+		/* Create memory barrier before write to TX PI */
+		wmb();
+		writeq(priv->tx_pi, priv->base + MLXBF_GIGE_TX_PRODUCER_INDEX);
+	}
+
+	/* Check if the last TX entry was just used */
+	if (!mlxbf_gige_tx_buffs_avail(priv)) {
+		/* TX ring is full, inform stack */
+		netif_stop_queue(netdev);
+
+		/* Since there is no separate "TX complete" interrupt, need
+		 * to explicitly schedule NAPI poll.  This will trigger logic
+		 * which processes TX completions, and will hopefully drain
+		 * the TX ring allowing the TX queue to be awakened.
+		 */
+		napi_schedule(&priv->napi);
+	}
+
+	return NETDEV_TX_OK;
+}
+
+static int mlxbf_gige_do_ioctl(struct net_device *netdev,
+			       struct ifreq *ifr, int cmd)
+{
+	if (!(netif_running(netdev)))
+		return -EINVAL;
+
+	return phy_mii_ioctl(netdev->phydev, ifr, cmd);
+}
+
+static void mlxbf_gige_set_rx_mode(struct net_device *netdev)
+{
+	struct mlxbf_gige *priv = netdev_priv(netdev);
+	bool new_promisc_enabled;
+
+	new_promisc_enabled = netdev->flags & IFF_PROMISC;
+
+	/* Only write to the hardware registers if the new setting
+	 * of promiscuous mode is different from the current one.
+	 */
+	if (new_promisc_enabled != priv->promisc_enabled) {
+		priv->promisc_enabled = new_promisc_enabled;
+
+		if (new_promisc_enabled)
+			mlxbf_gige_enable_promisc(priv);
+		else
+			mlxbf_gige_disable_promisc(priv);
+		}
+	}
+
+static void mlxbf_gige_get_stats64(struct net_device *netdev,
+				   struct rtnl_link_stats64 *stats)
+{
+	struct mlxbf_gige *priv = netdev_priv(netdev);
+
+	netdev_stats_to_stats64(stats, &netdev->stats);
+
+	stats->rx_length_errors = priv->stats.rx_truncate_errors;
+	stats->rx_fifo_errors = priv->stats.rx_din_dropped_pkts;
+	stats->rx_crc_errors = priv->stats.rx_mac_errors;
+	stats->rx_errors = stats->rx_length_errors +
+			   stats->rx_fifo_errors +
+			   stats->rx_crc_errors;
+
+	stats->tx_fifo_errors = priv->stats.tx_fifo_full;
+	stats->tx_errors = stats->tx_fifo_errors;
+}
+
+static const struct net_device_ops mlxbf_gige_netdev_ops = {
+	.ndo_open		= mlxbf_gige_open,
+	.ndo_stop		= mlxbf_gige_stop,
+	.ndo_start_xmit		= mlxbf_gige_start_xmit,
+	.ndo_set_mac_address	= eth_mac_addr,
+	.ndo_validate_addr	= eth_validate_addr,
+	.ndo_do_ioctl		= mlxbf_gige_do_ioctl,
+	.ndo_set_rx_mode        = mlxbf_gige_set_rx_mode,
+	.ndo_get_stats64        = mlxbf_gige_get_stats64,
+};
+
+static void mlxbf_gige_initial_mac(struct mlxbf_gige *priv)
+{
+	u8 mac[ETH_ALEN];
+	u64 local_mac;
+
+	mlxbf_gige_get_mac_rx_filter(priv, MLXBF_GIGE_LOCAL_MAC_FILTER_IDX,
+				     &local_mac);
+	u64_to_ether_addr(local_mac, mac);
+
+	if (is_valid_ether_addr(mac)) {
+		ether_addr_copy(priv->netdev->dev_addr, mac);
+	} else {
+		/* Provide a random MAC if for some reason the device has
+		 * not been configured with a valid MAC address already.
+		 */
+		eth_hw_addr_random(priv->netdev);
+	}
+
+	local_mac = ether_addr_to_u64(priv->netdev->dev_addr);
+	mlxbf_gige_set_mac_rx_filter(priv, MLXBF_GIGE_LOCAL_MAC_FILTER_IDX,
+				     local_mac);
+}
+
+static void mlxbf_gige_adjust_link(struct net_device *netdev)
+{
+	/* Only one speed and one duplex supported, simply return */
+}
+
+static int mlxbf_gige_probe(struct platform_device *pdev)
+{
+	struct phy_device *phydev;
+	struct net_device *netdev;
+	struct resource *mac_res;
+	struct resource *llu_res;
+	struct resource *plu_res;
+	struct mlxbf_gige *priv;
+	void __iomem *llu_base;
+	void __iomem *plu_base;
+	void __iomem *base;
+	u64 control;
+	int err = 0;
+	int addr;
+
+	mac_res = platform_get_resource(pdev, IORESOURCE_MEM, MLXBF_GIGE_RES_MAC);
+	if (!mac_res)
+		return -ENXIO;
+
+	base = devm_ioremap_resource(&pdev->dev, mac_res);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
+
+	llu_res = platform_get_resource(pdev, IORESOURCE_MEM, MLXBF_GIGE_RES_LLU);
+	if (!llu_res)
+		return -ENXIO;
+
+	llu_base = devm_ioremap_resource(&pdev->dev, llu_res);
+	if (IS_ERR(llu_base))
+		return PTR_ERR(llu_base);
+
+	plu_res = platform_get_resource(pdev, IORESOURCE_MEM, MLXBF_GIGE_RES_PLU);
+	if (!plu_res)
+		return -ENXIO;
+
+	plu_base = devm_ioremap_resource(&pdev->dev, plu_res);
+	if (IS_ERR(plu_base))
+		return PTR_ERR(plu_base);
+
+	/* Perform general init of GigE block */
+	control = readq(base + MLXBF_GIGE_CONTROL);
+	control |= MLXBF_GIGE_CONTROL_PORT_EN;
+	writeq(control, base + MLXBF_GIGE_CONTROL);
+
+	netdev = devm_alloc_etherdev(&pdev->dev, sizeof(*priv));
+	if (!netdev)
+		return -ENOMEM;
+
+	SET_NETDEV_DEV(netdev, &pdev->dev);
+	netdev->netdev_ops = &mlxbf_gige_netdev_ops;
+	netdev->ethtool_ops = &mlxbf_gige_ethtool_ops;
+	priv = netdev_priv(netdev);
+	priv->netdev = netdev;
+
+	platform_set_drvdata(pdev, priv);
+	priv->dev = &pdev->dev;
+	priv->pdev = pdev;
+
+	spin_lock_init(&priv->lock);
+	spin_lock_init(&priv->gpio_lock);
+
+	/* Attach MDIO device */
+	err = mlxbf_gige_mdio_probe(pdev, priv);
+	if (err)
+		return err;
+
+	priv->base = base;
+	priv->llu_base = llu_base;
+	priv->plu_base = plu_base;
+
+	priv->rx_q_entries = MLXBF_GIGE_DEFAULT_RXQ_SZ;
+	priv->tx_q_entries = MLXBF_GIGE_DEFAULT_TXQ_SZ;
+
+	/* Write initial MAC address to hardware */
+	mlxbf_gige_initial_mac(priv);
+
+	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	if (err) {
+		dev_err(&pdev->dev, "DMA configuration failed: 0x%x\n", err);
+		return err;
+	}
+
+	priv->error_irq = platform_get_irq(pdev, MLXBF_GIGE_ERROR_INTR_IDX);
+	priv->rx_irq = platform_get_irq(pdev, MLXBF_GIGE_RECEIVE_PKT_INTR_IDX);
+	priv->llu_plu_irq = platform_get_irq(pdev, MLXBF_GIGE_LLU_PLU_INTR_IDX);
+	priv->phy_irq = platform_get_irq(pdev, MLXBF_GIGE_PHY_INT_N);
+
+	phydev = phy_find_first(priv->mdiobus);
+	if (!phydev)
+		return -ENODEV;
+
+	addr = phydev->mdio.addr;
+	phydev->irq = priv->mdiobus->irq[addr] = PHY_IGNORE_INTERRUPT;
+
+	/* Sets netdev->phydev to phydev; which will eventually
+	 * be used in ioctl calls.
+	 * Cannot pass NULL handler.
+	 */
+	err = phy_connect_direct(netdev, phydev,
+				 mlxbf_gige_adjust_link,
+				 PHY_INTERFACE_MODE_GMII);
+	if (err) {
+		dev_err(&pdev->dev, "Could not attach to PHY\n");
+		return err;
+	}
+
+	/* MAC only supports 1000T full duplex mode */
+	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
+	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_100baseT_Full_BIT);
+	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_100baseT_Half_BIT);
+	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Full_BIT);
+	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Half_BIT);
+
+	/* MAC supports symmetric flow control */
+	phy_support_sym_pause(phydev);
+
+	/* Enable pause */
+	priv->rx_pause = phydev->pause;
+	priv->tx_pause = phydev->pause;
+	priv->aneg_pause = AUTONEG_ENABLE;
+
+	/* Display information about attached PHY device */
+	phy_attached_info(phydev);
+
+	err = register_netdev(netdev);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to register netdev\n");
+		phy_disconnect(phydev);
+		return err;
+	}
+
+	return 0;
+}
+
+static int mlxbf_gige_remove(struct platform_device *pdev)
+{
+	struct mlxbf_gige *priv = platform_get_drvdata(pdev);
+
+	unregister_netdev(priv->netdev);
+	phy_disconnect(priv->netdev->phydev);
+	mlxbf_gige_mdio_remove(priv);
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+static void mlxbf_gige_shutdown(struct platform_device *pdev)
+{
+	struct mlxbf_gige *priv = platform_get_drvdata(pdev);
+
+	writeq(0, priv->base + MLXBF_GIGE_INT_EN);
+	mlxbf_gige_clean_port(priv);
+}
+
+static const struct acpi_device_id mlxbf_gige_acpi_match[] = {
+	{ "MLNXBF17", 0 },
+	{},
+};
+MODULE_DEVICE_TABLE(acpi, mlxbf_gige_acpi_match);
+
+static struct platform_driver mlxbf_gige_driver = {
+	.probe = mlxbf_gige_probe,
+	.remove = mlxbf_gige_remove,
+	.shutdown = mlxbf_gige_shutdown,
+	.driver = {
+		.name = DRV_NAME,
+		.acpi_match_table = ACPI_PTR(mlxbf_gige_acpi_match),
+	},
+};
+
+module_platform_driver(mlxbf_gige_driver);
+
+MODULE_DESCRIPTION("Mellanox BlueField SoC Gigabit Ethernet Driver");
+MODULE_AUTHOR("David Thompson <davthompson@nvidia.com>");
+MODULE_AUTHOR("Asmaa Mnebhi <asmaa@nvidia.com>");
+MODULE_LICENSE("Dual BSD/GPL");
\ No newline at end of file
diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c
new file mode 100644
index 0000000..dfe68ae
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c
@@ -0,0 +1,286 @@
+// SPDX-License-Identifier: GPL-2.0-only OR BSD-3-Clause
+
+/* MDIO support for Mellanox Gigabit Ethernet driver
+ *
+ * Copyright (c) 2020 NVIDIA Corporation.
+ */
+
+#include <linux/acpi.h>
+#include <linux/bitfield.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/iopoll.h>
+#include <linux/ioport.h>
+#include <linux/irqreturn.h>
+#include <linux/jiffies.h>
+#include <linux/module.h>
+#include <linux/mod_devicetable.h>
+#include <linux/phy.h>
+#include <linux/platform_device.h>
+#include <linux/property.h>
+
+#include "mlxbf_gige.h"
+
+#define MLXBF_GIGE_MDIO_GW_OFFSET	0x0
+#define MLXBF_GIGE_MDIO_CFG_OFFSET	0x4
+
+/* Support clause 22 */
+#define MLXBF_GIGE_MDIO_CL22_ST1	0x1
+#define MLXBF_GIGE_MDIO_CL22_WRITE	0x1
+#define MLXBF_GIGE_MDIO_CL22_READ	0x2
+
+/* Busy bit is set by software and cleared by hardware */
+#define MLXBF_GIGE_MDIO_SET_BUSY	0x1
+
+/* MDIO GW register bits */
+#define MLXBF_GIGE_MDIO_GW_AD_MASK	GENMASK(15, 0)
+#define MLXBF_GIGE_MDIO_GW_DEVAD_MASK	GENMASK(20, 16)
+#define MLXBF_GIGE_MDIO_GW_PARTAD_MASK	GENMASK(25, 21)
+#define MLXBF_GIGE_MDIO_GW_OPCODE_MASK	GENMASK(27, 26)
+#define MLXBF_GIGE_MDIO_GW_ST1_MASK	GENMASK(28, 28)
+#define MLXBF_GIGE_MDIO_GW_BUSY_MASK	GENMASK(30, 30)
+
+/* MDIO config register bits */
+#define MLXBF_GIGE_MDIO_CFG_MDIO_MODE_MASK		GENMASK(1, 0)
+#define MLXBF_GIGE_MDIO_CFG_MDIO3_3_MASK		GENMASK(2, 2)
+#define MLXBF_GIGE_MDIO_CFG_MDIO_FULL_DRIVE_MASK	GENMASK(4, 4)
+#define MLXBF_GIGE_MDIO_CFG_MDC_PERIOD_MASK		GENMASK(15, 8)
+#define MLXBF_GIGE_MDIO_CFG_MDIO_IN_SAMP_MASK		GENMASK(23, 16)
+#define MLXBF_GIGE_MDIO_CFG_MDIO_OUT_SAMP_MASK		GENMASK(31, 24)
+
+/* Formula for encoding the MDIO period. The encoded value is
+ * passed to the MDIO config register.
+ *
+ * mdc_clk = 2*(val + 1)*i1clk
+ *
+ * 400 ns = 2*(val + 1)*(((1/430)*1000) ns)
+ *
+ * val = (((400 * 430 / 1000) / 2) - 1)
+ */
+#define MLXBF_GIGE_I1CLK_MHZ		430
+#define MLXBF_GIGE_MDC_CLK_NS		400
+
+#define MLXBF_GIGE_MDIO_PERIOD	(((MLXBF_GIGE_MDC_CLK_NS * MLXBF_GIGE_I1CLK_MHZ / 1000) / 2) - 1)
+
+#define MLXBF_GIGE_MDIO_CFG_VAL (FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDIO_MODE_MASK, 1) | \
+				 FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDIO3_3_MASK, 1) | \
+				 FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDIO_FULL_DRIVE_MASK, 1) | \
+				 FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDC_PERIOD_MASK, \
+					    MLXBF_GIGE_MDIO_PERIOD) |   \
+				 FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDIO_IN_SAMP_MASK, 6) | \
+				 FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDIO_OUT_SAMP_MASK, 13))
+
+#define MLXBF_GIGE_GPIO_CAUSE_FALL_EN		0x48
+#define MLXBF_GIGE_GPIO_CAUSE_OR_CAUSE_EVTEN0	0x80
+#define MLXBF_GIGE_GPIO_CAUSE_OR_EVTEN0		0x94
+#define MLXBF_GIGE_GPIO_CAUSE_OR_CLRCAUSE	0x98
+
+#define MLXBF_GIGE_GPIO12_BIT			12
+#define MLXBF_GIGE_CAUSE_OR_CAUSE_EVTEN0_MASK	BIT(MLXBF_GIGE_GPIO12_BIT)
+#define MLXBF_GIGE_CAUSE_OR_EVTEN0_MASK		BIT(MLXBF_GIGE_GPIO12_BIT)
+#define MLXBF_GIGE_CAUSE_FALL_EN_MASK		BIT(MLXBF_GIGE_GPIO12_BIT)
+#define MLXBF_GIGE_CAUSE_OR_CLRCAUSE_MASK	BIT(MLXBF_GIGE_GPIO12_BIT)
+
+static u32 mlxbf_gige_mdio_create_cmd(u16 data, int phy_add,
+				      int phy_reg, u32 opcode)
+{
+	u32 gw_reg = 0;
+
+	gw_reg |= FIELD_PREP(MLXBF_GIGE_MDIO_GW_AD_MASK, data);
+	gw_reg |= FIELD_PREP(MLXBF_GIGE_MDIO_GW_DEVAD_MASK, phy_reg);
+	gw_reg |= FIELD_PREP(MLXBF_GIGE_MDIO_GW_PARTAD_MASK, phy_add);
+	gw_reg |= FIELD_PREP(MLXBF_GIGE_MDIO_GW_OPCODE_MASK, opcode);
+	gw_reg |= FIELD_PREP(MLXBF_GIGE_MDIO_GW_ST1_MASK,
+			     MLXBF_GIGE_MDIO_CL22_ST1);
+	gw_reg |= FIELD_PREP(MLXBF_GIGE_MDIO_GW_BUSY_MASK,
+			     MLXBF_GIGE_MDIO_SET_BUSY);
+
+	return gw_reg;
+}
+
+static int mlxbf_gige_mdio_read(struct mii_bus *bus, int phy_add, int phy_reg)
+{
+	struct mlxbf_gige *priv = bus->priv;
+	u32 cmd;
+	int ret;
+	u32 val;
+
+	if (phy_reg & MII_ADDR_C45)
+		return -EOPNOTSUPP;
+
+	/* Send mdio read request */
+	cmd = mlxbf_gige_mdio_create_cmd(0, phy_add, phy_reg, MLXBF_GIGE_MDIO_CL22_READ);
+
+	writel(cmd, priv->mdio_io + MLXBF_GIGE_MDIO_GW_OFFSET);
+
+	ret = readl_poll_timeout_atomic(priv->mdio_io + MLXBF_GIGE_MDIO_GW_OFFSET,
+					val, !(val & MLXBF_GIGE_MDIO_GW_BUSY_MASK), 100, 1000000);
+
+	if (ret) {
+		writel(0, priv->mdio_io + MLXBF_GIGE_MDIO_GW_OFFSET);
+		return ret;
+	}
+
+	ret = readl(priv->mdio_io + MLXBF_GIGE_MDIO_GW_OFFSET);
+	/* Only return ad bits of the gw register */
+	ret &= MLXBF_GIGE_MDIO_GW_AD_MASK;
+
+	return ret;
+}
+
+static int mlxbf_gige_mdio_write(struct mii_bus *bus, int phy_add,
+				 int phy_reg, u16 val)
+{
+	struct mlxbf_gige *priv = bus->priv;
+	u32 cmd;
+	int ret;
+	u32 temp;
+
+	if (phy_reg & MII_ADDR_C45)
+		return -EOPNOTSUPP;
+
+	/* Send mdio write request */
+	cmd = mlxbf_gige_mdio_create_cmd(val, phy_add, phy_reg,
+					 MLXBF_GIGE_MDIO_CL22_WRITE);
+	writel(cmd, priv->mdio_io + MLXBF_GIGE_MDIO_GW_OFFSET);
+
+	/* If the poll timed out, drop the request */
+	ret = readl_poll_timeout_atomic(priv->mdio_io + MLXBF_GIGE_MDIO_GW_OFFSET,
+					temp, !(temp & MLXBF_GIGE_MDIO_GW_BUSY_MASK), 100, 1000000);
+
+	return ret;
+}
+
+static void mlxbf_gige_mdio_disable_phy_int(struct mlxbf_gige *priv)
+{
+	unsigned long flags;
+	u32 val;
+
+	spin_lock_irqsave(&priv->gpio_lock, flags);
+	val = readl(priv->gpio_io + MLXBF_GIGE_GPIO_CAUSE_OR_EVTEN0);
+	val &= ~MLXBF_GIGE_CAUSE_OR_EVTEN0_MASK;
+	writel(val, priv->gpio_io + MLXBF_GIGE_GPIO_CAUSE_OR_EVTEN0);
+	spin_unlock_irqrestore(&priv->gpio_lock, flags);
+}
+
+static void mlxbf_gige_mdio_enable_phy_int(struct mlxbf_gige *priv)
+{
+	unsigned long flags;
+	u32 val;
+
+	spin_lock_irqsave(&priv->gpio_lock, flags);
+	/* The INT_N interrupt level is active low.
+	 * So enable cause fall bit to detect when GPIO
+	 * state goes low.
+	 */
+	val = readl(priv->gpio_io + MLXBF_GIGE_GPIO_CAUSE_FALL_EN);
+	val |= MLXBF_GIGE_CAUSE_FALL_EN_MASK;
+	writel(val, priv->gpio_io + MLXBF_GIGE_GPIO_CAUSE_FALL_EN);
+
+	/* Enable PHY interrupt by setting the priority level */
+	val = readl(priv->gpio_io +
+			MLXBF_GIGE_GPIO_CAUSE_OR_EVTEN0);
+	val |= MLXBF_GIGE_CAUSE_OR_EVTEN0_MASK;
+	writel(val, priv->gpio_io +
+			MLXBF_GIGE_GPIO_CAUSE_OR_EVTEN0);
+	spin_unlock_irqrestore(&priv->gpio_lock, flags);
+}
+
+/* Interrupt handler is called from mlxbf_gige_main.c
+ * driver whenever a phy interrupt is received.
+ */
+irqreturn_t mlxbf_gige_mdio_handle_phy_interrupt(int irq, void *dev_id)
+{
+	struct phy_device *phydev;
+	struct mlxbf_gige *priv;
+	u32 val;
+
+	priv = dev_id;
+	phydev = priv->netdev->phydev;
+
+	/* Check if this interrupt is from PHY device.
+	 * Return if it is not.
+	 */
+	val = readl(priv->gpio_io +
+			MLXBF_GIGE_GPIO_CAUSE_OR_CAUSE_EVTEN0);
+	if (!(val & MLXBF_GIGE_CAUSE_OR_CAUSE_EVTEN0_MASK))
+		return IRQ_NONE;
+
+	phy_mac_interrupt(phydev);
+
+	/* Clear interrupt when done, otherwise, no further interrupt
+	 * will be triggered.
+	 */
+	val = readl(priv->gpio_io +
+			MLXBF_GIGE_GPIO_CAUSE_OR_CLRCAUSE);
+	val |= MLXBF_GIGE_CAUSE_OR_CLRCAUSE_MASK;
+	writel(val, priv->gpio_io +
+			MLXBF_GIGE_GPIO_CAUSE_OR_CLRCAUSE);
+
+	/* Make sure to clear the PHY device interrupt */
+	if (phydev->drv->ack_interrupt)
+		phydev->drv->ack_interrupt(phydev);
+
+	phydev->interrupts = PHY_INTERRUPT_ENABLED;
+	if (phydev->drv->config_intr)
+		phydev->drv->config_intr(phydev);
+
+	return IRQ_HANDLED;
+}
+
+int mlxbf_gige_mdio_probe(struct platform_device *pdev, struct mlxbf_gige *priv)
+{
+	struct device *dev = &pdev->dev;
+	struct resource *res;
+	int ret;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, MLXBF_GIGE_RES_MDIO9);
+	if (!res)
+		return -ENODEV;
+
+	priv->mdio_io = devm_ioremap_resource(dev, res);
+	if (IS_ERR(priv->mdio_io))
+		return PTR_ERR(priv->mdio_io);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, MLXBF_GIGE_RES_GPIO0);
+	if (!res)
+		return -ENODEV;
+
+	priv->gpio_io = devm_ioremap(dev, res->start, resource_size(res));
+	if (!priv->gpio_io)
+		return -ENOMEM;
+
+	/* Configure mdio parameters */
+	writel(MLXBF_GIGE_MDIO_CFG_VAL,
+	       priv->mdio_io + MLXBF_GIGE_MDIO_CFG_OFFSET);
+
+	mlxbf_gige_mdio_enable_phy_int(priv);
+
+	priv->mdiobus = devm_mdiobus_alloc(dev);
+	if (!priv->mdiobus) {
+		dev_err(dev, "Failed to alloc MDIO bus\n");
+		return -ENOMEM;
+	}
+
+	priv->mdiobus->name = "mlxbf-mdio";
+	priv->mdiobus->read = mlxbf_gige_mdio_read;
+	priv->mdiobus->write = mlxbf_gige_mdio_write;
+	priv->mdiobus->parent = dev;
+	priv->mdiobus->priv = priv;
+	snprintf(priv->mdiobus->id, MII_BUS_ID_SIZE, "%s",
+		 dev_name(dev));
+
+	ret = mdiobus_register(priv->mdiobus);
+	if (ret)
+		dev_err(dev, "Failed to register MDIO bus\n");
+
+	return ret;
+}
+
+void mlxbf_gige_mdio_remove(struct mlxbf_gige *priv)
+{
+	mlxbf_gige_mdio_disable_phy_int(priv);
+	mdiobus_unregister(priv->mdiobus);
+}
diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_regs.h b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_regs.h
new file mode 100644
index 0000000..128e128
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_regs.h
@@ -0,0 +1,78 @@
+/* SPDX-License-Identifier: GPL-2.0-only OR BSD-3-Clause */
+
+/* Header file for Mellanox BlueField GigE register defines
+ *
+ * Copyright (c) 2020 NVIDIA Corporation.
+ */
+
+#ifndef __MLXBF_GIGE_REGS_H__
+#define __MLXBF_GIGE_REGS_H__
+
+#define MLXBF_GIGE_STATUS                             0x0010
+#define MLXBF_GIGE_STATUS_READY                       BIT(0)
+#define MLXBF_GIGE_INT_STATUS                         0x0028
+#define MLXBF_GIGE_INT_STATUS_RX_RECEIVE_PACKET       BIT(0)
+#define MLXBF_GIGE_INT_STATUS_RX_MAC_ERROR            BIT(1)
+#define MLXBF_GIGE_INT_STATUS_RX_TRN_ERROR            BIT(2)
+#define MLXBF_GIGE_INT_STATUS_SW_ACCESS_ERROR         BIT(3)
+#define MLXBF_GIGE_INT_STATUS_SW_CONFIG_ERROR         BIT(4)
+#define MLXBF_GIGE_INT_STATUS_TX_PI_CI_EXCEED_WQ_SIZE BIT(5)
+#define MLXBF_GIGE_INT_STATUS_TX_SMALL_FRAME_SIZE     BIT(6)
+#define MLXBF_GIGE_INT_STATUS_TX_CHECKSUM_INPUTS      BIT(7)
+#define MLXBF_GIGE_INT_STATUS_HW_ACCESS_ERROR         BIT(8)
+#define MLXBF_GIGE_INT_EN                             0x0030
+#define MLXBF_GIGE_INT_EN_RX_RECEIVE_PACKET           BIT(0)
+#define MLXBF_GIGE_INT_EN_RX_MAC_ERROR                BIT(1)
+#define MLXBF_GIGE_INT_EN_RX_TRN_ERROR                BIT(2)
+#define MLXBF_GIGE_INT_EN_SW_ACCESS_ERROR             BIT(3)
+#define MLXBF_GIGE_INT_EN_SW_CONFIG_ERROR             BIT(4)
+#define MLXBF_GIGE_INT_EN_TX_PI_CI_EXCEED_WQ_SIZE     BIT(5)
+#define MLXBF_GIGE_INT_EN_TX_SMALL_FRAME_SIZE         BIT(6)
+#define MLXBF_GIGE_INT_EN_TX_CHECKSUM_INPUTS          BIT(7)
+#define MLXBF_GIGE_INT_EN_HW_ACCESS_ERROR             BIT(8)
+#define MLXBF_GIGE_INT_MASK                           0x0038
+#define MLXBF_GIGE_INT_MASK_RX_RECEIVE_PACKET         BIT(0)
+#define MLXBF_GIGE_CONTROL                            0x0040
+#define MLXBF_GIGE_CONTROL_PORT_EN                    BIT(0)
+#define MLXBF_GIGE_CONTROL_MAC_ID_RANGE_EN            BIT(1)
+#define MLXBF_GIGE_CONTROL_EN_SPECIFIC_MAC            BIT(4)
+#define MLXBF_GIGE_CONTROL_CLEAN_PORT_EN              BIT(31)
+#define MLXBF_GIGE_RX_WQ_BASE                         0x0200
+#define MLXBF_GIGE_RX_WQE_SIZE_LOG2                   0x0208
+#define MLXBF_GIGE_RX_WQE_SIZE_LOG2_RESET_VAL         7
+#define MLXBF_GIGE_RX_CQ_BASE                         0x0210
+#define MLXBF_GIGE_TX_WQ_BASE                         0x0218
+#define MLXBF_GIGE_TX_WQ_SIZE_LOG2                    0x0220
+#define MLXBF_GIGE_TX_WQ_SIZE_LOG2_RESET_VAL          7
+#define MLXBF_GIGE_TX_CI_UPDATE_ADDRESS               0x0228
+#define MLXBF_GIGE_RX_WQE_PI                          0x0230
+#define MLXBF_GIGE_TX_PRODUCER_INDEX                  0x0238
+#define MLXBF_GIGE_RX_MAC_FILTER                      0x0240
+#define MLXBF_GIGE_RX_MAC_FILTER_STRIDE               0x0008
+#define MLXBF_GIGE_RX_DIN_DROP_COUNTER                0x0260
+#define MLXBF_GIGE_TX_CONSUMER_INDEX                  0x0310
+#define MLXBF_GIGE_TX_CONTROL                         0x0318
+#define MLXBF_GIGE_TX_CONTROL_GRACEFUL_STOP           BIT(0)
+#define MLXBF_GIGE_TX_STATUS                          0x0388
+#define MLXBF_GIGE_TX_STATUS_DATA_FIFO_FULL           BIT(1)
+#define MLXBF_GIGE_RX_MAC_FILTER_DMAC_RANGE_START     0x0520
+#define MLXBF_GIGE_RX_MAC_FILTER_DMAC_RANGE_END       0x0528
+#define MLXBF_GIGE_RX_MAC_FILTER_COUNT_DISC           0x0540
+#define MLXBF_GIGE_RX_MAC_FILTER_COUNT_DISC_EN        BIT(0)
+#define MLXBF_GIGE_RX_MAC_FILTER_COUNT_PASS           0x0548
+#define MLXBF_GIGE_RX_MAC_FILTER_COUNT_PASS_EN        BIT(0)
+#define MLXBF_GIGE_RX_PASS_COUNTER_ALL                0x0550
+#define MLXBF_GIGE_RX_DISC_COUNTER_ALL                0x0560
+#define MLXBF_GIGE_RX                                 0x0578
+#define MLXBF_GIGE_RX_STRIP_CRC_EN                    BIT(1)
+#define MLXBF_GIGE_RX_DMA                             0x0580
+#define MLXBF_GIGE_RX_DMA_EN                          BIT(0)
+#define MLXBF_GIGE_RX_CQE_PACKET_CI                   0x05b0
+#define MLXBF_GIGE_MAC_CFG                            0x05e8
+
+/* NOTE: MLXBF_GIGE_MAC_CFG is the last defined register offset,
+ * so use that plus size of single register to derive total size
+ */
+#define MLXBF_GIGE_MMIO_REG_SZ                        (MLXBF_GIGE_MAC_CFG + 8)
+
+#endif /* !defined(__MLXBF_GIGE_REGS_H__) */
-- 
2.1.2

