Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E72AE3014A3
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 11:48:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbhAWKrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 05:47:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726628AbhAWKr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 05:47:27 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A65CC0613D6;
        Sat, 23 Jan 2021 02:46:47 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id d4so4736815plh.5;
        Sat, 23 Jan 2021 02:46:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kzhmlzHFwKVMczcl37Q2M/FnMTDPxqt7X3ifDW3cE9w=;
        b=tbqBZzNMJVg2xse/nD5j9z4YOoY0DrWIKP4CqbIS+kn+Xr9UToJQaVdE08SN1b5772
         DxSKYp2TWv8bDAJZzfsof4N0NFDtuPvwTrnt2aa3xVJQpq/VPzvotAZEdxxmrWPO5/bo
         ltml03LbpplvwMEmkM7Sf385EVWZQNTFmvcNgmrPlxDE3XDY7XKkTfZiDAwcA+O8+iQT
         zGeAStGK+89C9UZNDY/VPGTuoBk2cHNffFD6/u+r53nPaIF3dGM52RTRjZ+i9vidyUEF
         ZJ8g35rkXdeXZkjoIIpTahPEM6U/jeN7/rvhiQ34ikd95JJF5H+rKZk2jI3tNlY+nelD
         T2Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kzhmlzHFwKVMczcl37Q2M/FnMTDPxqt7X3ifDW3cE9w=;
        b=DGbe0lD5ndi68GmB0KDKPLEW5k1GEhwf5I4WTYitMNWMrR5xoDAl+HxFFqq5KySbHP
         p6QgIl4oo6Zjm2uu+WKNYmV8FdzsvOYTMFO+YWv0ycxLr/9vd9lF5lxYznqWGmWPpdW4
         oFjf67qFaatGo8Xd06Npph9/UW1SGjL979kqtteMi4fjg1iyGyjNmD68T/0lgkqXRwoP
         N+7COYJ3d2zuAC3YNQLivSX/dOrNafM5RsxqIGZP6zr6vVLh9m96LQVDv346QO+/5Qls
         ertmJuTDV3DJoqEw0HxCjv7s6hCpGUBd+BpCvN3+ouN11vgcsjFd8+cF+PSIH6FnlaHL
         yQ6Q==
X-Gm-Message-State: AOAM531oorBRCDtnQL8+9buc+UUfKXYJnKTu2ovSZozuV3bPLyZ4xGbX
        +Z2i1WW+ETk6B+don+IbFFw=
X-Google-Smtp-Source: ABdhPJzaEXyjHQQnegHyPu1PpDcYPl7WO9IlaPbdeTd1RYk94v2KZtksPT5m2lAMAsHe0pb1VbZd6Q==
X-Received: by 2002:a17:90b:18a:: with SMTP id t10mr6391330pjs.28.1611398806913;
        Sat, 23 Jan 2021 02:46:46 -0800 (PST)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id n15sm11679157pgl.31.2021.01.23.02.46.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jan 2021 02:46:46 -0800 (PST)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     devel@driverdev.osuosl.org
Cc:     Benjamin Poirier <benjamin.poirier@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        GR-Linux-NIC-Dev@marvell.com, Manish Chopra <manishc@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org (open list),
        netdev@vger.kernel.org (open list:QLOGIC QLGE 10Gb ETHERNET DRIVER)
Subject: [PATCH v4 2/8] staging: qlge: Initialize devlink health dump framework
Date:   Sat, 23 Jan 2021 18:46:07 +0800
Message-Id: <20210123104613.38359-3-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210123104613.38359-1-coiby.xu@gmail.com>
References: <20210123104613.38359-1-coiby.xu@gmail.com>
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

Since devlink_alloc will zero out struct qlge_adapter, memset in
qlge_init_device is not necessary.

Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
---
 drivers/staging/qlge/Kconfig        |   1 +
 drivers/staging/qlge/Makefile       |   2 +-
 drivers/staging/qlge/qlge.h         |  13 +++
 drivers/staging/qlge/qlge_devlink.c |  31 +++++++
 drivers/staging/qlge/qlge_devlink.h |   9 ++
 drivers/staging/qlge/qlge_ethtool.c |  36 ++++----
 drivers/staging/qlge/qlge_main.c    | 125 +++++++++++++++++-----------
 7 files changed, 151 insertions(+), 66 deletions(-)
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
index 1ac85f2f770f..41f69751d34d 100644
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
index 4042ea8d36a5..bb9fc590d97b 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -42,6 +42,7 @@
 #include <net/ip6_checksum.h>
 
 #include "qlge.h"
+#include "qlge_devlink.h"
 
 char qlge_driver_name[] = DRV_NAME;
 const char qlge_driver_version[] = DRV_VERSION;
@@ -2229,7 +2230,7 @@ static int qlge_napi_poll_msix(struct napi_struct *napi, int budget)
 
 static void qlge_vlan_mode(struct net_device *ndev, netdev_features_t features)
 {
-	struct qlge_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_to_qdev(ndev);
 
 	if (features & NETIF_F_HW_VLAN_CTAG_RX) {
 		qlge_write32(qdev, NIC_RCV_CFG, NIC_RCV_CFG_VLAN_MASK |
@@ -2246,9 +2247,9 @@ static void qlge_vlan_mode(struct net_device *ndev, netdev_features_t features)
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
@@ -2307,7 +2308,7 @@ static int __qlge_vlan_rx_add_vid(struct qlge_adapter *qdev, u16 vid)
 
 static int qlge_vlan_rx_add_vid(struct net_device *ndev, __be16 proto, u16 vid)
 {
-	struct qlge_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_to_qdev(ndev);
 	int status;
 	int err;
 
@@ -2338,7 +2339,7 @@ static int __qlge_vlan_rx_kill_vid(struct qlge_adapter *qdev, u16 vid)
 
 static int qlge_vlan_rx_kill_vid(struct net_device *ndev, __be16 proto, u16 vid)
 {
-	struct qlge_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_to_qdev(ndev);
 	int status;
 	int err;
 
@@ -2531,9 +2532,9 @@ static void qlge_hw_csum_setup(struct sk_buff *skb,
 
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
@@ -3728,7 +3729,7 @@ static int qlge_adapter_reset(struct qlge_adapter *qdev)
 
 static void qlge_display_dev_info(struct net_device *ndev)
 {
-	struct qlge_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_to_qdev(ndev);
 
 	netif_info(qdev, probe, qdev->ndev,
 		   "Function #%d, Port %d, NIC Roll %d, NIC Rev = %d, XG Roll = %d, XG Rev = %d.\n",
@@ -3886,7 +3887,7 @@ static int qlge_get_adapter_resources(struct qlge_adapter *qdev)
 
 static int qlge_close(struct net_device *ndev)
 {
-	struct qlge_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_to_qdev(ndev);
 	int i;
 
 	/* If we hit pci_channel_io_perm_failure
@@ -3993,8 +3994,8 @@ static int qlge_configure_rings(struct qlge_adapter *qdev)
 
 static int qlge_open(struct net_device *ndev)
 {
+	struct qlge_adapter *qdev = netdev_to_qdev(ndev);
 	int err = 0;
-	struct qlge_adapter *qdev = netdev_priv(ndev);
 
 	err = qlge_adapter_reset(qdev);
 	if (err)
@@ -4062,7 +4063,7 @@ static int qlge_change_rx_buffers(struct qlge_adapter *qdev)
 
 static int qlge_change_mtu(struct net_device *ndev, int new_mtu)
 {
-	struct qlge_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_to_qdev(ndev);
 	int status;
 
 	if (ndev->mtu == 1500 && new_mtu == 9000)
@@ -4092,7 +4093,7 @@ static int qlge_change_mtu(struct net_device *ndev, int new_mtu)
 static struct net_device_stats *qlge_get_stats(struct net_device
 					       *ndev)
 {
-	struct qlge_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_to_qdev(ndev);
 	struct rx_ring *rx_ring = &qdev->rx_ring[0];
 	struct tx_ring *tx_ring = &qdev->tx_ring[0];
 	unsigned long pkts, mcast, dropped, errors, bytes;
@@ -4128,7 +4129,7 @@ static struct net_device_stats *qlge_get_stats(struct net_device
 
 static void qlge_set_multicast_list(struct net_device *ndev)
 {
-	struct qlge_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_to_qdev(ndev);
 	struct netdev_hw_addr *ha;
 	int i, status;
 
@@ -4218,7 +4219,7 @@ static void qlge_set_multicast_list(struct net_device *ndev)
 
 static int qlge_set_mac_address(struct net_device *ndev, void *p)
 {
-	struct qlge_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_to_qdev(ndev);
 	struct sockaddr *addr = p;
 	int status;
 
@@ -4242,7 +4243,7 @@ static int qlge_set_mac_address(struct net_device *ndev, void *p)
 
 static void qlge_tx_timeout(struct net_device *ndev, unsigned int txqueue)
 {
-	struct qlge_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_to_qdev(ndev);
 
 	qlge_queue_asic_error(qdev);
 }
@@ -4359,8 +4360,7 @@ static int qlge_get_board_info(struct qlge_adapter *qdev)
 
 static void qlge_release_all(struct pci_dev *pdev)
 {
-	struct net_device *ndev = pci_get_drvdata(pdev);
-	struct qlge_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = pci_get_drvdata(pdev);
 
 	if (qdev->workqueue) {
 		destroy_workqueue(qdev->workqueue);
@@ -4375,22 +4375,20 @@ static void qlge_release_all(struct pci_dev *pdev)
 	pci_release_regions(pdev);
 }
 
-static int qlge_init_device(struct pci_dev *pdev, struct net_device *ndev,
+static int qlge_init_device(struct pci_dev *pdev, struct qlge_adapter *qdev,
 			    int cards_found)
 {
-	struct qlge_adapter *qdev = netdev_priv(ndev);
+	struct net_device *ndev = qdev->ndev;
 	int err = 0;
 
-	memset((void *)qdev, 0, sizeof(*qdev));
 	err = pci_enable_device(pdev);
 	if (err) {
 		dev_err(&pdev->dev, "PCI device enable failed.\n");
 		return err;
 	}
 
-	qdev->ndev = ndev;
 	qdev->pdev = pdev;
-	pci_set_drvdata(pdev, ndev);
+	pci_set_drvdata(pdev, qdev);
 
 	/* Set PCIe read request size */
 	err = pcie_set_readrq(pdev, 4096);
@@ -4541,27 +4539,38 @@ static void qlge_timer(struct timer_list *t)
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
@@ -4603,9 +4612,14 @@ static int qlge_probe(struct pci_dev *pdev,
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
@@ -4616,6 +4630,13 @@ static int qlge_probe(struct pci_dev *pdev,
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
@@ -4630,22 +4651,26 @@ int qlge_clean_lb_rx_ring(struct rx_ring *rx_ring, int budget)
 
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
@@ -4671,8 +4696,8 @@ static void qlge_eeh_close(struct net_device *ndev)
 static pci_ers_result_t qlge_io_error_detected(struct pci_dev *pdev,
 					       pci_channel_state_t state)
 {
-	struct net_device *ndev = pci_get_drvdata(pdev);
-	struct qlge_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = pci_get_drvdata(pdev);
+	struct net_device *ndev = qdev->ndev;
 
 	switch (state) {
 	case pci_channel_io_normal:
@@ -4705,8 +4730,7 @@ static pci_ers_result_t qlge_io_error_detected(struct pci_dev *pdev,
  */
 static pci_ers_result_t qlge_io_slot_reset(struct pci_dev *pdev)
 {
-	struct net_device *ndev = pci_get_drvdata(pdev);
-	struct qlge_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = pci_get_drvdata(pdev);
 
 	pdev->error_state = pci_channel_io_normal;
 
@@ -4729,8 +4753,8 @@ static pci_ers_result_t qlge_io_slot_reset(struct pci_dev *pdev)
 
 static void qlge_io_resume(struct pci_dev *pdev)
 {
-	struct net_device *ndev = pci_get_drvdata(pdev);
-	struct qlge_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = pci_get_drvdata(pdev);
+	struct net_device *ndev = qdev->ndev;
 	int err = 0;
 
 	if (netif_running(ndev)) {
@@ -4756,10 +4780,13 @@ static const struct pci_error_handlers qlge_err_handler = {
 
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
 
@@ -4776,11 +4803,15 @@ static int __maybe_unused qlge_suspend(struct device *dev_d)
 
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
2.29.2

