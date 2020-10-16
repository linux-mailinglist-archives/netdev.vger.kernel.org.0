Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23A11290492
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 14:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407120AbgJPMBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 08:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407113AbgJPMBA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 08:01:00 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ADB5C061755;
        Fri, 16 Oct 2020 05:01:00 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id p21so1280140pju.0;
        Fri, 16 Oct 2020 05:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vuJV7Qqxep+dGEQ1DgV5OJVSyiE0PR0hmBK9fymK9/0=;
        b=hb9y6jqr8j7hvPaJhh2tkIU9wzRuiWQ/xeccaWtjwC7zIQQdD8AqlHLqQ4g7GT2xdv
         LxmOdkLjfGGOK4MYo+HVoc3giqSDo51ied8qHdYLBU9lquHnwp29v3hkVouOT7msAfbr
         jFDRyMDSzt6f3jwrNUXBH7SH2jw7T/l5lcfRR+KBqb9W1wUGTtQ9sGj/Nhql168WH5S2
         Eft6itQbmojZRFp4ncoKDPJjCai2tl+9IqG875OpeSvs36mDZpAdM0ATTA9kldZrgtHQ
         I+dpzV8N7P4G+lLYL/4NGKlkaCiar63jYlWvURUBNF434yUEOAxWNCOPHdUCrGIYsRX/
         JnJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vuJV7Qqxep+dGEQ1DgV5OJVSyiE0PR0hmBK9fymK9/0=;
        b=bPDXZCvSAyqOOlihAaVFviOUtvLkni5zQ6h2qOSUb7druFNQSXgmYpZwubPCV38GGY
         nuF8qCJxaZaPPOrnqxG5tKm0VLY6R1jOrpLOgdUZmfhxuvT40iTra6hGwuZeyV5JpO5D
         REJYPdHYyixuBe+axZRQEhajbjNDXxZskvoM0d5KO1vUsJuxWsE1HleliB3zNDxeQe6K
         JCN931sU9N5icp/kgufKVBnOzfzHLpKMV1+GLwKp5xhdThREnm9BpRa5/gSCVSj2LGdV
         adC0EkFdimS+a3Ek7M/vV9JzkoBX/0y+G7RTwwPo0ReS1240q3BIZX+M9ekJTgVtXpgC
         cIbQ==
X-Gm-Message-State: AOAM531ZNLQVGMH7V1hNNmnnBFmF/9GELZI8CnYwIKXE2Bpl/67v52qE
        BwQkgPbjc7C9m/LZpcjzwew=
X-Google-Smtp-Source: ABdhPJxLop/DCtwl6getw3G2xExKJL8dlsfk1jrdga0h1MW492rTQj2aDyLG7/UF7dVb1QL2exzm8g==
X-Received: by 2002:a17:90a:c587:: with SMTP id l7mr3661336pjt.103.1602849659816;
        Fri, 16 Oct 2020 05:00:59 -0700 (PDT)
Received: from localhost ([160.16.113.140])
        by smtp.gmail.com with ESMTPSA id n5sm2615602pgm.82.2020.10.16.05.00.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 05:00:59 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     devel@driverdev.osuosl.org
Cc:     Benjamin Poirier <benjamin.poirier@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com (supporter:QLOGIC QLGE 10Gb ETHERNET
        DRIVER), Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org (open list),
        netdev@vger.kernel.org (open list:QLOGIC QLGE 10Gb ETHERNET DRIVER)
Subject: [PATCH v3 2/8] staging: qlge: Initialize devlink health dump framework
Date:   Fri, 16 Oct 2020 19:54:01 +0800
Message-Id: <20201016115407.170821-3-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016115407.170821-1-coiby.xu@gmail.com>
References: <20201016115407.170821-1-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Initialize devlink health dump framework for the qlge driver so the
coredump could be done via devlink.

struct qlge_adapter is now used as the private data structure of
struct devlink so it could exist independently of struct net_device
and devlink reload could be supported in the future. The private data
of PCIe driver now points to qlge_adapter.

Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
---
 drivers/staging/qlge/Kconfig        |   1 +
 drivers/staging/qlge/Makefile       |   2 +-
 drivers/staging/qlge/qlge.h         |  13 +++
 drivers/staging/qlge/qlge_devlink.c |  31 +++++++
 drivers/staging/qlge/qlge_devlink.h |   9 ++
 drivers/staging/qlge/qlge_ethtool.c |  36 ++++----
 drivers/staging/qlge/qlge_main.c    | 124 +++++++++++++++++-----------
 7 files changed, 151 insertions(+), 65 deletions(-)
 create mode 100644 drivers/staging/qlge/qlge_devlink.c
 create mode 100644 drivers/staging/qlge/qlge_devlink.h

diff --git a/drivers/staging/qlge/Kconfig b/drivers/staging/qlge/Kconfig
index a3cb25a3ab80..6d831ed67965 100644
--- a/drivers/staging/qlge/Kconfig
+++ b/drivers/staging/qlge/Kconfig
@@ -3,6 +3,7 @@
 config QLGE
 	tristate "QLogic QLGE 10Gb Ethernet Driver Support"
 	depends on ETHERNET && PCI
+	select NET_DEVLINK
 	help
 	This driver supports QLogic ISP8XXX 10Gb Ethernet cards.
 
diff --git a/drivers/staging/qlge/Makefile b/drivers/staging/qlge/Makefile
index 1dc2568e820c..07c1898a512e 100644
--- a/drivers/staging/qlge/Makefile
+++ b/drivers/staging/qlge/Makefile
@@ -5,4 +5,4 @@
 
 obj-$(CONFIG_QLGE) += qlge.o
 
-qlge-objs := qlge_main.o qlge_dbg.o qlge_mpi.o qlge_ethtool.o
+qlge-objs := qlge_main.o qlge_dbg.o qlge_mpi.o qlge_ethtool.o qlge_devlink.o
diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
index 57947f9336a8..0a470f02b0c6 100644
--- a/drivers/staging/qlge/qlge.h
+++ b/drivers/staging/qlge/qlge.h
@@ -2060,6 +2060,18 @@ struct nic_operations {
 	int (*port_initialize)(struct qlge_adapter *qdev);
 };
 
+struct qlge_netdev_priv {
+	struct qlge_adapter *qdev;
+	struct net_device *ndev;
+};
+
+static inline
+struct qlge_adapter *netdev_to_qdev(struct net_device *ndev)
+{
+	struct qlge_netdev_priv *ndev_priv = netdev_priv(ndev);
+
+	return ndev_priv->qdev;
+}
 /*
  * The main Adapter structure definition.
  * This structure has all fields relevant to the hardware.
@@ -2077,6 +2089,7 @@ struct qlge_adapter {
 	struct pci_dev *pdev;
 	struct net_device *ndev;	/* Parent NET device */
 
+	struct devlink_health_reporter *reporter;
 	/* Hardware information */
 	u32 chip_rev_id;
 	u32 fw_rev_id;
diff --git a/drivers/staging/qlge/qlge_devlink.c b/drivers/staging/qlge/qlge_devlink.c
new file mode 100644
index 000000000000..d9c71f45211f
--- /dev/null
+++ b/drivers/staging/qlge/qlge_devlink.c
@@ -0,0 +1,31 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#include "qlge.h"
+#include "qlge_devlink.h"
+
+static int
+qlge_reporter_coredump(struct devlink_health_reporter *reporter,
+		       struct devlink_fmsg *fmsg, void *priv_ctx,
+		       struct netlink_ext_ack *extack)
+{
+	return 0;
+}
+
+static const struct devlink_health_reporter_ops qlge_reporter_ops = {
+	.name = "dummy",
+	.dump = qlge_reporter_coredump,
+};
+
+void qlge_health_create_reporters(struct qlge_adapter *priv)
+{
+	struct devlink_health_reporter *reporter;
+	struct devlink *devlink;
+
+	devlink = priv_to_devlink(priv);
+	priv->reporter =
+		devlink_health_reporter_create(devlink, &qlge_reporter_ops,
+					       0, priv);
+	if (IS_ERR(priv->reporter))
+		netdev_warn(priv->ndev,
+			    "Failed to create reporter, err = %ld\n",
+			    PTR_ERR(reporter));
+}
diff --git a/drivers/staging/qlge/qlge_devlink.h b/drivers/staging/qlge/qlge_devlink.h
new file mode 100644
index 000000000000..19078e1ac694
--- /dev/null
+++ b/drivers/staging/qlge/qlge_devlink.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef QLGE_DEVLINK_H
+#define QLGE_DEVLINK_H
+
+#include <net/devlink.h>
+
+void qlge_health_create_reporters(struct qlge_adapter *priv);
+
+#endif /* QLGE_DEVLINK_H */
diff --git a/drivers/staging/qlge/qlge_ethtool.c b/drivers/staging/qlge/qlge_ethtool.c
index 3e577e1bc27c..24b079523d5c 100644
--- a/drivers/staging/qlge/qlge_ethtool.c
+++ b/drivers/staging/qlge/qlge_ethtool.c
@@ -366,7 +366,7 @@ static void
 qlge_get_ethtool_stats(struct net_device *ndev,
 		       struct ethtool_stats *stats, u64 *data)
 {
-	struct qlge_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_to_qdev(ndev);
 	int index, length;
 
 	length = QLGE_STATS_LEN;
@@ -383,7 +383,7 @@ qlge_get_ethtool_stats(struct net_device *ndev,
 static int qlge_get_link_ksettings(struct net_device *ndev,
 				   struct ethtool_link_ksettings *ecmd)
 {
-	struct qlge_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_to_qdev(ndev);
 	u32 supported, advertising;
 
 	supported = SUPPORTED_10000baseT_Full;
@@ -415,7 +415,7 @@ static int qlge_get_link_ksettings(struct net_device *ndev,
 static void qlge_get_drvinfo(struct net_device *ndev,
 			     struct ethtool_drvinfo *drvinfo)
 {
-	struct qlge_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_to_qdev(ndev);
 
 	strlcpy(drvinfo->driver, qlge_driver_name, sizeof(drvinfo->driver));
 	strlcpy(drvinfo->version, qlge_driver_version,
@@ -431,7 +431,7 @@ static void qlge_get_drvinfo(struct net_device *ndev,
 
 static void qlge_get_wol(struct net_device *ndev, struct ethtool_wolinfo *wol)
 {
-	struct qlge_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_to_qdev(ndev);
 	unsigned short ssys_dev = qdev->pdev->subsystem_device;
 
 	/* WOL is only supported for mezz card. */
@@ -444,7 +444,7 @@ static void qlge_get_wol(struct net_device *ndev, struct ethtool_wolinfo *wol)
 
 static int qlge_set_wol(struct net_device *ndev, struct ethtool_wolinfo *wol)
 {
-	struct qlge_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_to_qdev(ndev);
 	unsigned short ssys_dev = qdev->pdev->subsystem_device;
 
 	/* WOL is only supported for mezz card. */
@@ -466,7 +466,7 @@ static int qlge_set_phys_id(struct net_device *ndev,
 			    enum ethtool_phys_id_state state)
 
 {
-	struct qlge_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_to_qdev(ndev);
 
 	switch (state) {
 	case ETHTOOL_ID_ACTIVE:
@@ -574,7 +574,7 @@ static int qlge_loopback_test(struct qlge_adapter *qdev, u64 *data)
 static void qlge_self_test(struct net_device *ndev,
 			   struct ethtool_test *eth_test, u64 *data)
 {
-	struct qlge_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_to_qdev(ndev);
 
 	memset(data, 0, sizeof(u64) * QLGE_TEST_LEN);
 
@@ -603,7 +603,7 @@ static void qlge_self_test(struct net_device *ndev,
 
 static int qlge_get_regs_len(struct net_device *ndev)
 {
-	struct qlge_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_to_qdev(ndev);
 
 	if (!test_bit(QL_FRC_COREDUMP, &qdev->flags))
 		return sizeof(struct qlge_mpi_coredump);
@@ -614,7 +614,7 @@ static int qlge_get_regs_len(struct net_device *ndev)
 static void qlge_get_regs(struct net_device *ndev,
 			  struct ethtool_regs *regs, void *p)
 {
-	struct qlge_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_to_qdev(ndev);
 
 	qlge_get_dump(qdev, p);
 	qdev->core_is_dumped = 0;
@@ -624,9 +624,9 @@ static void qlge_get_regs(struct net_device *ndev,
 		regs->len = sizeof(struct qlge_reg_dump);
 }
 
-static int qlge_get_coalesce(struct net_device *dev, struct ethtool_coalesce *c)
+static int qlge_get_coalesce(struct net_device *ndev, struct ethtool_coalesce *c)
 {
-	struct qlge_adapter *qdev = netdev_priv(dev);
+	struct qlge_adapter *qdev = netdev_to_qdev(ndev);
 
 	c->rx_coalesce_usecs = qdev->rx_coalesce_usecs;
 	c->tx_coalesce_usecs = qdev->tx_coalesce_usecs;
@@ -649,7 +649,7 @@ static int qlge_get_coalesce(struct net_device *dev, struct ethtool_coalesce *c)
 
 static int qlge_set_coalesce(struct net_device *ndev, struct ethtool_coalesce *c)
 {
-	struct qlge_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_to_qdev(ndev);
 
 	/* Validate user parameters. */
 	if (c->rx_coalesce_usecs > qdev->rx_ring_size / 2)
@@ -677,10 +677,10 @@ static int qlge_set_coalesce(struct net_device *ndev, struct ethtool_coalesce *c
 	return qlge_update_ring_coalescing(qdev);
 }
 
-static void qlge_get_pauseparam(struct net_device *netdev,
+static void qlge_get_pauseparam(struct net_device *ndev,
 				struct ethtool_pauseparam *pause)
 {
-	struct qlge_adapter *qdev = netdev_priv(netdev);
+	struct qlge_adapter *qdev = netdev_to_qdev(ndev);
 
 	qlge_mb_get_port_cfg(qdev);
 	if (qdev->link_config & CFG_PAUSE_STD) {
@@ -689,10 +689,10 @@ static void qlge_get_pauseparam(struct net_device *netdev,
 	}
 }
 
-static int qlge_set_pauseparam(struct net_device *netdev,
+static int qlge_set_pauseparam(struct net_device *ndev,
 			       struct ethtool_pauseparam *pause)
 {
-	struct qlge_adapter *qdev = netdev_priv(netdev);
+	struct qlge_adapter *qdev = netdev_to_qdev(ndev);
 
 	if ((pause->rx_pause) && (pause->tx_pause))
 		qdev->link_config |= CFG_PAUSE_STD;
@@ -706,14 +706,14 @@ static int qlge_set_pauseparam(struct net_device *netdev,
 
 static u32 qlge_get_msglevel(struct net_device *ndev)
 {
-	struct qlge_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_to_qdev(ndev);
 
 	return qdev->msg_enable;
 }
 
 static void qlge_set_msglevel(struct net_device *ndev, u32 value)
 {
-	struct qlge_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_to_qdev(ndev);
 
 	qdev->msg_enable = value;
 }
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 856b387e79b4..888179fbf98c 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -42,6 +42,7 @@
 #include <net/ip6_checksum.h>
 
 #include "qlge.h"
+#include "qlge_devlink.h"
 
 char qlge_driver_name[] = DRV_NAME;
 const char qlge_driver_version[] = DRV_VERSION;
@@ -2234,7 +2235,7 @@ static int qlge_napi_poll_msix(struct napi_struct *napi, int budget)
 
 static void qlge_vlan_mode(struct net_device *ndev, netdev_features_t features)
 {
-	struct qlge_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_to_qdev(ndev);
 
 	if (features & NETIF_F_HW_VLAN_CTAG_RX) {
 		qlge_write32(qdev, NIC_RCV_CFG, NIC_RCV_CFG_VLAN_MASK |
@@ -2251,9 +2252,9 @@ static void qlge_vlan_mode(struct net_device *ndev, netdev_features_t features)
 static int qlge_update_hw_vlan_features(struct net_device *ndev,
 					netdev_features_t features)
 {
-	struct qlge_adapter *qdev = netdev_priv(ndev);
-	int status = 0;
+	struct qlge_adapter *qdev = netdev_to_qdev(ndev);
 	bool need_restart = netif_running(ndev);
+	int status = 0;
 
 	if (need_restart) {
 		status = qlge_adapter_down(qdev);
@@ -2312,7 +2313,7 @@ static int __qlge_vlan_rx_add_vid(struct qlge_adapter *qdev, u16 vid)
 
 static int qlge_vlan_rx_add_vid(struct net_device *ndev, __be16 proto, u16 vid)
 {
-	struct qlge_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_to_qdev(ndev);
 	int status;
 	int err;
 
@@ -2343,7 +2344,7 @@ static int __qlge_vlan_rx_kill_vid(struct qlge_adapter *qdev, u16 vid)
 
 static int qlge_vlan_rx_kill_vid(struct net_device *ndev, __be16 proto, u16 vid)
 {
-	struct qlge_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_to_qdev(ndev);
 	int status;
 	int err;
 
@@ -2537,9 +2538,9 @@ static void qlge_hw_csum_setup(struct sk_buff *skb,
 
 static netdev_tx_t qlge_send(struct sk_buff *skb, struct net_device *ndev)
 {
-	struct tx_ring_desc *tx_ring_desc;
+	struct qlge_adapter *qdev = netdev_to_qdev(ndev);
 	struct qlge_ob_mac_iocb_req *mac_iocb_ptr;
-	struct qlge_adapter *qdev = netdev_priv(ndev);
+	struct tx_ring_desc *tx_ring_desc;
 	int tso;
 	struct tx_ring *tx_ring;
 	u32 tx_ring_idx = (u32)skb->queue_mapping;
@@ -3735,7 +3736,7 @@ static int qlge_adapter_reset(struct qlge_adapter *qdev)
 
 static void qlge_display_dev_info(struct net_device *ndev)
 {
-	struct qlge_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_to_qdev(ndev);
 
 	netif_info(qdev, probe, qdev->ndev,
 		   "Function #%d, Port %d, NIC Roll %d, NIC Rev = %d, XG Roll = %d, XG Rev = %d.\n",
@@ -3894,7 +3895,7 @@ static int qlge_get_adapter_resources(struct qlge_adapter *qdev)
 
 static int qlge_close(struct net_device *ndev)
 {
-	struct qlge_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_to_qdev(ndev);
 	int i;
 
 	/* If we hit pci_channel_io_perm_failure
@@ -4001,8 +4002,8 @@ static int qlge_configure_rings(struct qlge_adapter *qdev)
 
 static int qlge_open(struct net_device *ndev)
 {
+	struct qlge_adapter *qdev = netdev_to_qdev(ndev);
 	int err = 0;
-	struct qlge_adapter *qdev = netdev_priv(ndev);
 
 	err = qlge_adapter_reset(qdev);
 	if (err)
@@ -4070,7 +4071,7 @@ static int qlge_change_rx_buffers(struct qlge_adapter *qdev)
 
 static int qlge_change_mtu(struct net_device *ndev, int new_mtu)
 {
-	struct qlge_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_to_qdev(ndev);
 	int status;
 
 	if (ndev->mtu == 1500 && new_mtu == 9000)
@@ -4100,7 +4101,7 @@ static int qlge_change_mtu(struct net_device *ndev, int new_mtu)
 static struct net_device_stats *qlge_get_stats(struct net_device
 					       *ndev)
 {
-	struct qlge_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_to_qdev(ndev);
 	struct rx_ring *rx_ring = &qdev->rx_ring[0];
 	struct tx_ring *tx_ring = &qdev->tx_ring[0];
 	unsigned long pkts, mcast, dropped, errors, bytes;
@@ -4136,7 +4137,7 @@ static struct net_device_stats *qlge_get_stats(struct net_device
 
 static void qlge_set_multicast_list(struct net_device *ndev)
 {
-	struct qlge_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_to_qdev(ndev);
 	struct netdev_hw_addr *ha;
 	int i, status;
 
@@ -4226,7 +4227,7 @@ static void qlge_set_multicast_list(struct net_device *ndev)
 
 static int qlge_set_mac_address(struct net_device *ndev, void *p)
 {
-	struct qlge_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_to_qdev(ndev);
 	struct sockaddr *addr = p;
 	int status;
 
@@ -4250,7 +4251,7 @@ static int qlge_set_mac_address(struct net_device *ndev, void *p)
 
 static void qlge_tx_timeout(struct net_device *ndev, unsigned int txqueue)
 {
-	struct qlge_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_to_qdev(ndev);
 
 	qlge_queue_asic_error(qdev);
 }
@@ -4367,8 +4368,7 @@ static int qlge_get_board_info(struct qlge_adapter *qdev)
 
 static void qlge_release_all(struct pci_dev *pdev)
 {
-	struct net_device *ndev = pci_get_drvdata(pdev);
-	struct qlge_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = pci_get_drvdata(pdev);
 
 	if (qdev->workqueue) {
 		destroy_workqueue(qdev->workqueue);
@@ -4383,10 +4383,10 @@ static void qlge_release_all(struct pci_dev *pdev)
 	pci_release_regions(pdev);
 }
 
-static int qlge_init_device(struct pci_dev *pdev, struct net_device *ndev,
+static int qlge_init_device(struct pci_dev *pdev, struct qlge_adapter *qdev,
 			    int cards_found)
 {
-	struct qlge_adapter *qdev = netdev_priv(ndev);
+	struct net_device *ndev = qdev->ndev;
 	int err = 0;
 
 	memset((void *)qdev, 0, sizeof(*qdev));
@@ -4396,9 +4396,8 @@ static int qlge_init_device(struct pci_dev *pdev, struct net_device *ndev,
 		return err;
 	}
 
-	qdev->ndev = ndev;
 	qdev->pdev = pdev;
-	pci_set_drvdata(pdev, ndev);
+	pci_set_drvdata(pdev, qdev);
 
 	/* Set PCIe read request size */
 	err = pcie_set_readrq(pdev, 4096);
@@ -4549,27 +4548,38 @@ static void qlge_timer(struct timer_list *t)
 	mod_timer(&qdev->timer, jiffies + (5 * HZ));
 }
 
+static const struct devlink_ops qlge_devlink_ops;
+
 static int qlge_probe(struct pci_dev *pdev,
 		      const struct pci_device_id *pci_entry)
 {
-	struct net_device *ndev = NULL;
+	struct qlge_netdev_priv *ndev_priv;
 	struct qlge_adapter *qdev = NULL;
+	struct net_device *ndev = NULL;
+	struct devlink *devlink;
 	static int cards_found;
 	int err = 0;
 
-	ndev = alloc_etherdev_mq(sizeof(struct qlge_adapter),
+	devlink = devlink_alloc(&qlge_devlink_ops, sizeof(struct qlge_adapter));
+	if (!devlink)
+		return -ENOMEM;
+
+	qdev = devlink_priv(devlink);
+
+	ndev = alloc_etherdev_mq(sizeof(struct qlge_netdev_priv),
 				 min(MAX_CPUS,
 				     netif_get_num_default_rss_queues()));
 	if (!ndev)
-		return -ENOMEM;
+		goto devlink_free;
 
-	err = qlge_init_device(pdev, ndev, cards_found);
-	if (err < 0) {
-		free_netdev(ndev);
-		return err;
-	}
+	ndev_priv = netdev_priv(ndev);
+	ndev_priv->qdev = qdev;
+	ndev_priv->ndev = ndev;
+	qdev->ndev = ndev;
+	err = qlge_init_device(pdev, qdev, cards_found);
+	if (err < 0)
+		goto netdev_free;
 
-	qdev = netdev_priv(ndev);
 	SET_NETDEV_DEV(ndev, &pdev->dev);
 	ndev->hw_features = NETIF_F_SG |
 		NETIF_F_IP_CSUM |
@@ -4611,9 +4621,14 @@ static int qlge_probe(struct pci_dev *pdev,
 		dev_err(&pdev->dev, "net device registration failed.\n");
 		qlge_release_all(pdev);
 		pci_disable_device(pdev);
-		free_netdev(ndev);
-		return err;
+		goto netdev_free;
 	}
+
+	err = devlink_register(devlink, &pdev->dev);
+	if (err)
+		goto netdev_free;
+
+	qlge_health_create_reporters(qdev);
 	/* Start up the timer to trigger EEH if
 	 * the bus goes dead
 	 */
@@ -4624,6 +4639,13 @@ static int qlge_probe(struct pci_dev *pdev,
 	atomic_set(&qdev->lb_count, 0);
 	cards_found++;
 	return 0;
+
+netdev_free:
+	free_netdev(ndev);
+devlink_free:
+	devlink_free(devlink);
+
+	return err;
 }
 
 netdev_tx_t qlge_lb_send(struct sk_buff *skb, struct net_device *ndev)
@@ -4638,22 +4660,26 @@ int qlge_clean_lb_rx_ring(struct rx_ring *rx_ring, int budget)
 
 static void qlge_remove(struct pci_dev *pdev)
 {
-	struct net_device *ndev = pci_get_drvdata(pdev);
-	struct qlge_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = pci_get_drvdata(pdev);
+	struct net_device *ndev = qdev->ndev;
+	struct devlink *devlink = priv_to_devlink(qdev);
 
 	del_timer_sync(&qdev->timer);
 	qlge_cancel_all_work_sync(qdev);
 	unregister_netdev(ndev);
 	qlge_release_all(pdev);
 	pci_disable_device(pdev);
+	devlink_health_reporter_destroy(qdev->reporter);
+	devlink_unregister(devlink);
+	devlink_free(devlink);
 	free_netdev(ndev);
 }
 
 /* Clean up resources without touching hardware. */
 static void qlge_eeh_close(struct net_device *ndev)
 {
+	struct qlge_adapter *qdev = netdev_to_qdev(ndev);
 	int i;
-	struct qlge_adapter *qdev = netdev_priv(ndev);
 
 	if (netif_carrier_ok(ndev)) {
 		netif_carrier_off(ndev);
@@ -4679,8 +4705,8 @@ static void qlge_eeh_close(struct net_device *ndev)
 static pci_ers_result_t qlge_io_error_detected(struct pci_dev *pdev,
 					       pci_channel_state_t state)
 {
-	struct net_device *ndev = pci_get_drvdata(pdev);
-	struct qlge_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = pci_get_drvdata(pdev);
+	struct net_device *ndev = qdev->ndev;
 
 	switch (state) {
 	case pci_channel_io_normal:
@@ -4713,8 +4739,7 @@ static pci_ers_result_t qlge_io_error_detected(struct pci_dev *pdev,
  */
 static pci_ers_result_t qlge_io_slot_reset(struct pci_dev *pdev)
 {
-	struct net_device *ndev = pci_get_drvdata(pdev);
-	struct qlge_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = pci_get_drvdata(pdev);
 
 	pdev->error_state = pci_channel_io_normal;
 
@@ -4737,8 +4762,8 @@ static pci_ers_result_t qlge_io_slot_reset(struct pci_dev *pdev)
 
 static void qlge_io_resume(struct pci_dev *pdev)
 {
-	struct net_device *ndev = pci_get_drvdata(pdev);
-	struct qlge_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = pci_get_drvdata(pdev);
+	struct net_device *ndev = qdev->ndev;
 	int err = 0;
 
 	if (netif_running(ndev)) {
@@ -4764,10 +4789,13 @@ static const struct pci_error_handlers qlge_err_handler = {
 
 static int __maybe_unused qlge_suspend(struct device *dev_d)
 {
-	struct net_device *ndev = dev_get_drvdata(dev_d);
-	struct qlge_adapter *qdev = netdev_priv(ndev);
+	struct pci_dev *pdev = to_pci_dev(dev_d);
+	struct qlge_adapter *qdev;
+	struct net_device *ndev;
 	int err;
 
+	qdev = pci_get_drvdata(pdev);
+	ndev = qdev->ndev;
 	netif_device_detach(ndev);
 	del_timer_sync(&qdev->timer);
 
@@ -4784,11 +4812,15 @@ static int __maybe_unused qlge_suspend(struct device *dev_d)
 
 static int __maybe_unused qlge_resume(struct device *dev_d)
 {
-	struct net_device *ndev = dev_get_drvdata(dev_d);
-	struct qlge_adapter *qdev = netdev_priv(ndev);
+	struct pci_dev *pdev = to_pci_dev(dev_d);
+	struct qlge_adapter *qdev;
+	struct net_device *ndev;
 	int err;
 
-	pci_set_master(to_pci_dev(dev_d));
+	qdev = pci_get_drvdata(pdev);
+	ndev = qdev->ndev;
+
+	pci_set_master(pdev);
 
 	device_wakeup_disable(dev_d);
 
-- 
2.28.0

