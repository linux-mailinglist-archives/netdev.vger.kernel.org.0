Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABF84DB2B
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 22:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbfFTUYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 16:24:35 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43291 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726677AbfFTUYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 16:24:34 -0400
Received: by mail-pf1-f193.google.com with SMTP id i189so2282760pfg.10
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 13:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=pmzuYfeKYl/xfscPRBW4yEBN1fAxXHQnmZl5DKveMok=;
        b=SPsa+z9CPEMRnHmiBBBY5Pfq1xkdiHD2J/JAzD2ZZJ8Rg+LL8mFb2COKWWri+XCWmF
         MEIychPR82DKZoK478aEOSORZBaOmfVaRpDRzVFb3oq8gPR0PlJtRCiKLLsBuZuTztV4
         Jx6mFZmEcOzkYk/i+vm3kRtkSED6qm7bdgBbWAOY4KNvZF2PFjAhygj3s0hIta+PXeET
         kbDwSJ5Mzd5LKtQVbISi5bSCXtDXn4ACb6hR22eWvGAOhrX/Sh2C1wmVZOFWQ8756Yq5
         vWY8PdNTPN6ZlelthmLDsElvw/Ym2XY9ZTE5Q6JSXGQIIXfDy1qU/nJkEEjtFtFLEnVS
         qbww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=pmzuYfeKYl/xfscPRBW4yEBN1fAxXHQnmZl5DKveMok=;
        b=dTWOSz6ZEYxjVy3B0iczmNPHVcAk+nDpAmMpp+ErZ/zFhchesEKQRQnY/E0cup1V74
         qvdS9NhsI7P+Y9cKRCOYdTf5neE7UXzgY4mP0R2VI/67dBiuM+ZWJf1uMc0+2h1Fn506
         ojEXyA2IF/KknZ4eViIzwUl+WoDtjPRtX7pEbnCN3kJOGk3+SWAaXz1a3so45Nd3iJLO
         hHHwcPuWMo1J+QqOblw+itN5AD6vyx5cvFN0G64uwlP4KcVJei+/H+uIMAxSvUZmLmRW
         56s5fM4HJNJcXczJT7t6NBBRiKKedrwur6rkofMWjUmwMmtf0DEITr5X17wjh/JghzGe
         tcKA==
X-Gm-Message-State: APjAAAVT6UTSvu2X0nCutfKSfw7V46SeoDTBMKol5iSfrN+Nnsqx39is
        mKuMNkYGE3HsPkPvq3fHV2vbZ2CXREI=
X-Google-Smtp-Source: APXvYqwhnKTFpOyeLJxpWZQFkh46tcChFnUkCUJMyUDaEjLmMwDkfbOPbTGyxxEgLYTSbVqkt0vtrA==
X-Received: by 2002:a63:3710:: with SMTP id e16mr14335794pga.391.1561062273401;
        Thu, 20 Jun 2019 13:24:33 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id h26sm340537pfq.64.2019.06.20.13.24.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 13:24:32 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org
Subject: [PATCH net-next 04/18] ionic: Add basic lif support
Date:   Thu, 20 Jun 2019 13:24:10 -0700
Message-Id: <20190620202424.23215-5-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190620202424.23215-1-snelson@pensando.io>
References: <20190620202424.23215-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The LIF is the Logical Interface, which represents the external
connections.  The NIC can multiplex many LIFs to a single port,
but in most setups, LIF0 is the primary control for the port.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/Makefile  |   3 +-
 drivers/net/ethernet/pensando/ionic/ionic.h   |   8 +-
 .../net/ethernet/pensando/ionic/ionic_bus.h   |   2 +
 .../ethernet/pensando/ionic/ionic_bus_pci.c   |  48 +++
 .../ethernet/pensando/ionic/ionic_debugfs.c   |  47 +++
 .../ethernet/pensando/ionic/ionic_debugfs.h   |   6 +
 .../net/ethernet/pensando/ionic/ionic_dev.c   |  34 ++
 .../net/ethernet/pensando/ionic/ionic_dev.h   |   7 +
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 299 ++++++++++++++++++
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  76 +++++
 .../net/ethernet/pensando/ionic/ionic_main.c  |   1 +
 11 files changed, 529 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_lif.c
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_lif.h

diff --git a/drivers/net/ethernet/pensando/ionic/Makefile b/drivers/net/ethernet/pensando/ionic/Makefile
index 49a8e28a5c84..04d519d00be6 100644
--- a/drivers/net/ethernet/pensando/ionic/Makefile
+++ b/drivers/net/ethernet/pensando/ionic/Makefile
@@ -3,4 +3,5 @@
 
 obj-$(CONFIG_IONIC) := ionic.o
 
-ionic-y := ionic_main.o ionic_bus_pci.o ionic_dev.o ionic_debugfs.o
+ionic-y := ionic_main.o ionic_bus_pci.o ionic_dev.o ionic_debugfs.o \
+	   ionic_lif.o
diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
index a1ed9bc486dd..fe3a2153a880 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -6,7 +6,6 @@
 
 #include "ionic_if.h"
 #include "ionic_dev.h"
-#include "ionic_debugfs.h"
 
 #define DRV_NAME		"ionic"
 #define DRV_DESCRIPTION		"Pensando Ethernet NIC Driver"
@@ -34,7 +33,14 @@ struct ionic {
 	struct ionic_dev_bar bars[IONIC_BARS_MAX];
 	unsigned int num_bars;
 	struct identity ident;
+	struct list_head lifs;
 	bool is_mgmt_nic;
+	unsigned int nnqs_per_lif;
+	unsigned int neqs_per_lif;
+	unsigned int ntxqs_per_lif;
+	unsigned int nrxqs_per_lif;
+	DECLARE_BITMAP(lifbits, IONIC_LIFS_MAX);
+	unsigned int nintrs;
 };
 
 int ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_wait);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus.h b/drivers/net/ethernet/pensando/ionic/ionic_bus.h
index 24b4c01ec03f..3b1e2d0ebf8f 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus.h
@@ -5,6 +5,8 @@
 #define _IONIC_BUS_H_
 
 const char *ionic_bus_info(struct ionic *ionic);
+int ionic_bus_alloc_irq_vectors(struct ionic *ionic, unsigned int nintrs);
+void ionic_bus_free_irq_vectors(struct ionic *ionic);
 int ionic_bus_register_driver(void);
 void ionic_bus_unregister_driver(void);
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index 407988f17796..850f8b4d5322 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -8,6 +8,8 @@
 
 #include "ionic.h"
 #include "ionic_bus.h"
+#include "ionic_lif.h"
+#include "ionic_debugfs.h"
 
 /* Supported devices */
 static const struct pci_device_id ionic_id_table[] = {
@@ -23,6 +25,17 @@ const char *ionic_bus_info(struct ionic *ionic)
 	return pci_name(ionic->pdev);
 }
 
+int ionic_bus_alloc_irq_vectors(struct ionic *ionic, unsigned int nintrs)
+{
+	return pci_alloc_irq_vectors(ionic->pdev, nintrs, nintrs,
+				     PCI_IRQ_MSIX);
+}
+
+void ionic_bus_free_irq_vectors(struct ionic *ionic)
+{
+	pci_free_irq_vectors(ionic->pdev);
+}
+
 static int ionic_map_bars(struct ionic *ionic)
 {
 	struct pci_dev *pdev = ionic->pdev;
@@ -158,10 +171,42 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_out_reset;
 	}
 
+	/* Configure LIFs */
+	err = ionic_lif_identify(ionic, IONIC_LIF_TYPE_CLASSIC,
+				 &ionic->ident.lif);
+	if (err) {
+		dev_err(dev, "Cannot identify LIFs: %d, aborting\n", err);
+		goto err_out_port_reset;
+	}
+
+	err = ionic_lifs_size(ionic);
+	if (err) {
+		dev_err(dev, "Cannot size LIFs: %d, aborting\n", err);
+		goto err_out_port_reset;
+	}
+
+	err = ionic_lifs_alloc(ionic);
+	if (err) {
+		dev_err(dev, "Cannot allocate LIFs: %d, aborting\n", err);
+		goto err_out_free_irqs;
+	}
+
+	err = ionic_lifs_init(ionic);
+	if (err) {
+		dev_err(dev, "Cannot init LIFs: %d, aborting\n", err);
+		goto err_out_free_lifs;
+	}
+
 	dev_info(ionic->dev, "attached\n");
 
 	return 0;
 
+err_out_free_lifs:
+	ionic_lifs_free(ionic);
+err_out_free_irqs:
+	ionic_bus_free_irq_vectors(ionic);
+err_out_port_reset:
+	ionic_port_reset(ionic);
 err_out_reset:
 	ionic_reset(ionic);
 err_out_teardown:
@@ -187,6 +232,9 @@ static void ionic_remove(struct pci_dev *pdev)
 	struct ionic *ionic = pci_get_drvdata(pdev);
 
 	if (ionic) {
+		ionic_lifs_deinit(ionic);
+		ionic_lifs_free(ionic);
+		ionic_bus_free_irq_vectors(ionic);
 		ionic_port_reset(ionic);
 		ionic_reset(ionic);
 		ionic_dev_teardown(ionic);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
index e5e45e6bec9d..4f2c4bc48de0 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
@@ -1,10 +1,12 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright(c) 2017 - 2019 Pensando Systems, Inc */
 
+#include <linux/pci.h>
 #include <linux/netdevice.h>
 
 #include "ionic.h"
 #include "ionic_bus.h"
+#include "ionic_lif.h"
 #include "ionic_debugfs.h"
 
 #ifdef CONFIG_DEBUG_FS
@@ -236,4 +238,49 @@ int ionic_debugfs_add_ident(struct ionic *ionic)
 				   ionic, &identity_fops) ? 0 : -ENOTSUPP;
 }
 
+int ionic_debugfs_add_sizes(struct ionic *ionic)
+{
+	debugfs_create_u32("nlifs", 0400, ionic->dentry,
+			   (u32 *)&ionic->ident.dev.nlifs);
+	debugfs_create_u32("nintrs", 0400, ionic->dentry, &ionic->nintrs);
+
+	debugfs_create_u32("ntxqs_per_lif", 0400, ionic->dentry,
+			   (u32 *)&ionic->ident.lif.eth.config.queue_count[IONIC_QTYPE_TXQ]);
+	debugfs_create_u32("nrxqs_per_lif", 0400, ionic->dentry,
+			   (u32 *)&ionic->ident.lif.eth.config.queue_count[IONIC_QTYPE_RXQ]);
+
+	return 0;
+}
+
+static int netdev_show(struct seq_file *seq, void *v)
+{
+	struct net_device *netdev = seq->private;
+
+	seq_printf(seq, "%s\n", netdev->name);
+
+	return 0;
+}
+single(netdev);
+
+int ionic_debugfs_add_lif(struct lif *lif)
+{
+	struct dentry *netdev_dentry;
+
+	lif->dentry = debugfs_create_dir(lif->name, lif->ionic->dentry);
+	if (IS_ERR_OR_NULL(lif->dentry))
+		return PTR_ERR(lif->dentry);
+
+	netdev_dentry = debugfs_create_file("netdev", 0400, lif->dentry,
+					    lif->netdev, &netdev_fops);
+	if (IS_ERR_OR_NULL(netdev_dentry))
+		return PTR_ERR(netdev_dentry);
+
+	return 0;
+}
+
+void ionic_debugfs_del_lif(struct lif *lif)
+{
+	debugfs_remove_recursive(lif->dentry);
+	lif->dentry = NULL;
+}
 #endif
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.h b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.h
index c3958b0c15b1..cb00166e7c30 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.h
@@ -15,6 +15,9 @@ void ionic_debugfs_del_dev(struct ionic *ionic);
 int ionic_debugfs_add_bars(struct ionic *ionic);
 int ionic_debugfs_add_dev_cmd(struct ionic *ionic);
 int ionic_debugfs_add_ident(struct ionic *ionic);
+int ionic_debugfs_add_sizes(struct ionic *ionic);
+int ionic_debugfs_add_lif(struct lif *lif);
+void ionic_debugfs_del_lif(struct lif *lif);
 #else
 static inline void ionic_debugfs_create(void) { }
 static inline void ionic_debugfs_destroy(void) { }
@@ -23,6 +26,9 @@ static inline void ionic_debugfs_del_dev(struct ionic *ionic) { }
 static inline int ionic_debugfs_add_bars(struct ionic *ionic) { return 0; }
 static inline int ionic_debugfs_add_dev_cmd(struct ionic *ionic) { return 0; }
 static inline int ionic_debugfs_add_ident(struct ionic *ionic) { return 0; }
+static inline int ionic_debugfs_add_sizes(struct ionic *ionic) { return 0; }
+static inline int ionic_debugfs_add_lif(struct lif *lif) { return 0; }
+static inline void ionic_debugfs_del_lif(struct lif *lif) { return 0; }
 #endif
 
 #endif /* _IONIC_DEBUGFS_H_ */
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index 55fd2881aac3..c34ae9ea30cc 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -246,3 +246,37 @@ void ionic_dev_cmd_port_loopback(struct ionic_dev *idev, u8 loopback_mode)
 
 	ionic_dev_cmd_go(idev, &cmd);
 }
+
+/* LIF commands */
+void ionic_dev_cmd_lif_identify(struct ionic_dev *idev, u8 type, u8 ver)
+{
+	union dev_cmd cmd = {
+		.lif_identify.opcode = CMD_OPCODE_LIF_IDENTIFY,
+		.lif_identify.type = type,
+		.lif_identify.ver = ver,
+	};
+
+	ionic_dev_cmd_go(idev, &cmd);
+}
+
+void ionic_dev_cmd_lif_init(struct ionic_dev *idev, u16 lif_index,
+			    dma_addr_t info_pa)
+{
+	union dev_cmd cmd = {
+		.lif_init.opcode = CMD_OPCODE_LIF_INIT,
+		.lif_init.index = cpu_to_le16(lif_index),
+		.lif_init.info_pa = cpu_to_le64(info_pa),
+	};
+
+	ionic_dev_cmd_go(idev, &cmd);
+}
+
+void ionic_dev_cmd_lif_reset(struct ionic_dev *idev, u16 lif_index)
+{
+	union dev_cmd cmd = {
+		.lif_init.opcode = CMD_OPCODE_LIF_RESET,
+		.lif_init.index = cpu_to_le16(lif_index),
+	};
+
+	ionic_dev_cmd_go(idev, &cmd);
+}
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index fe5e1b0e8d55..a8a84734b433 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -10,6 +10,8 @@
 #include "ionic_if.h"
 #include "ionic_regs.h"
 
+#define IONIC_LIFS_MAX			1024
+
 struct ionic_dev_bar {
 	void __iomem *vaddr;
 	phys_addr_t bus_addr;
@@ -156,4 +158,9 @@ void ionic_dev_cmd_port_fec(struct ionic_dev *idev, u8 fec_type);
 void ionic_dev_cmd_port_pause(struct ionic_dev *idev, u8 pause_type);
 void ionic_dev_cmd_port_loopback(struct ionic_dev *idev, u8 loopback_mode);
 
+void ionic_dev_cmd_lif_identify(struct ionic_dev *idev, u8 type, u8 ver);
+void ionic_dev_cmd_lif_init(struct ionic_dev *idev, u16 lif_index,
+			    dma_addr_t addr);
+void ionic_dev_cmd_lif_reset(struct ionic_dev *idev, u16 lif_index);
+
 #endif /* _IONIC_DEV_H_ */
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
new file mode 100644
index 000000000000..4658078a76d7
--- /dev/null
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -0,0 +1,299 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2017 - 2019 Pensando Systems, Inc */
+
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/interrupt.h>
+#include <linux/pci.h>
+#include <linux/cpumask.h>
+
+#include "ionic.h"
+#include "ionic_bus.h"
+#include "ionic_lif.h"
+#include "ionic_debugfs.h"
+
+static struct lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index)
+{
+	struct device *dev = ionic->dev;
+	struct net_device *netdev;
+	struct lif *lif;
+	int err;
+
+	netdev = alloc_etherdev_mqs(sizeof(*lif),
+				    ionic->ntxqs_per_lif, ionic->ntxqs_per_lif);
+	if (!netdev) {
+		dev_err(dev, "Cannot allocate netdev, aborting\n");
+		return ERR_PTR(-ENOMEM);
+	}
+	netif_set_real_num_tx_queues(netdev, ionic->ntxqs_per_lif);
+	netif_set_real_num_rx_queues(netdev, ionic->nrxqs_per_lif);
+
+	SET_NETDEV_DEV(netdev, dev);
+
+	lif = netdev_priv(netdev);
+	lif->netdev = netdev;
+
+	lif->neqs = ionic->neqs_per_lif;
+	lif->nxqs = ionic->ntxqs_per_lif;
+
+	lif->ionic = ionic;
+	lif->index = index;
+
+	snprintf(lif->name, sizeof(lif->name), "lif%u", index);
+
+	/* allocate lif info */
+	lif->info_sz = ALIGN(sizeof(*lif->info), PAGE_SIZE);
+	lif->info = dma_alloc_coherent(dev, lif->info_sz,
+				       &lif->info_pa, GFP_KERNEL);
+	if (!lif->info) {
+		dev_err(dev, "Failed to allocate lif info, aborting\n");
+		err = -ENOMEM;
+		goto err_out_free_netdev;
+	}
+
+	list_add_tail(&lif->list, &ionic->lifs);
+
+	return lif;
+
+err_out_free_netdev:
+	free_netdev(lif->netdev);
+	lif = NULL;
+
+	return ERR_PTR(err);
+}
+
+int ionic_lifs_alloc(struct ionic *ionic)
+{
+	struct lif *lif;
+
+	INIT_LIST_HEAD(&ionic->lifs);
+
+	/* only build the first lif, others are for later features */
+	set_bit(0, ionic->lifbits);
+	lif = ionic_lif_alloc(ionic, 0);
+
+	return PTR_ERR_OR_ZERO(lif);
+}
+
+static void ionic_lif_reset(struct lif *lif)
+{
+	struct ionic_dev *idev = &lif->ionic->idev;
+
+	mutex_lock(&lif->ionic->dev_cmd_lock);
+	ionic_dev_cmd_lif_reset(idev, lif->index);
+	ionic_dev_cmd_wait(lif->ionic, devcmd_timeout);
+	mutex_unlock(&lif->ionic->dev_cmd_lock);
+}
+
+static void ionic_lif_free(struct lif *lif)
+{
+	struct device *dev = lif->ionic->dev;
+
+	ionic_lif_reset(lif);
+
+	/* free lif info */
+	if (lif->info) {
+		dma_free_coherent(dev, lif->info_sz, lif->info, lif->info_pa);
+		lif->info = NULL;
+		lif->info_pa = 0;
+	}
+
+	/* free netdev & lif */
+	ionic_debugfs_del_lif(lif);
+	list_del(&lif->list);
+	free_netdev(lif->netdev);
+}
+
+void ionic_lifs_free(struct ionic *ionic)
+{
+	struct list_head *cur, *tmp;
+	struct lif *lif;
+
+	list_for_each_safe(cur, tmp, &ionic->lifs) {
+		lif = list_entry(cur, struct lif, list);
+
+		ionic_lif_free(lif);
+	}
+}
+
+static void ionic_lif_deinit(struct lif *lif)
+{
+	if (!test_bit(LIF_INITED, lif->state))
+		return;
+
+	clear_bit(LIF_INITED, lif->state);
+
+	ionic_lif_reset(lif);
+}
+
+void ionic_lifs_deinit(struct ionic *ionic)
+{
+	struct list_head *cur, *tmp;
+	struct lif *lif;
+
+	list_for_each_safe(cur, tmp, &ionic->lifs) {
+		lif = list_entry(cur, struct lif, list);
+		ionic_lif_deinit(lif);
+	}
+}
+
+static int ionic_lif_init(struct lif *lif)
+{
+	struct ionic_dev *idev = &lif->ionic->idev;
+	struct device *dev = lif->ionic->dev;
+	struct lif_init_comp comp;
+	int err;
+
+	err = ionic_debugfs_add_lif(lif);
+	if (err) {
+		dev_err(dev, "lif debugfs add failed: %d\n", err);
+		return err;
+	}
+
+	mutex_lock(&lif->ionic->dev_cmd_lock);
+	ionic_dev_cmd_lif_init(idev, lif->index, lif->info_pa);
+	err = ionic_dev_cmd_wait(lif->ionic, devcmd_timeout);
+	ionic_dev_cmd_comp(idev, (union dev_cmd_comp *)&comp);
+	mutex_unlock(&lif->ionic->dev_cmd_lock);
+	if (err)
+		return err;
+
+	lif->hw_index = le16_to_cpu(comp.hw_index);
+
+	set_bit(LIF_INITED, lif->state);
+
+	return 0;
+}
+
+int ionic_lifs_init(struct ionic *ionic)
+{
+	struct list_head *cur, *tmp;
+	struct lif *lif;
+	int err;
+
+	list_for_each_safe(cur, tmp, &ionic->lifs) {
+		lif = list_entry(cur, struct lif, list);
+		err = ionic_lif_init(lif);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+int ionic_lif_identify(struct ionic *ionic, u8 lif_type,
+		       union lif_identity *lid)
+{
+	struct ionic_dev *idev = &ionic->idev;
+	size_t sz;
+	int err;
+
+	sz = min(sizeof(*lid), sizeof(idev->dev_cmd_regs->data));
+
+	mutex_lock(&ionic->dev_cmd_lock);
+	ionic_dev_cmd_lif_identify(idev, lif_type, IONIC_IDENTITY_VERSION_1);
+	err = ionic_dev_cmd_wait(ionic, devcmd_timeout);
+	memcpy_fromio(lid, &idev->dev_cmd_regs->data, sz);
+	mutex_unlock(&ionic->dev_cmd_lock);
+	if (err)
+		return (err);
+
+	dev_dbg(ionic->dev, "capabilities 0x%llx\n",
+		le64_to_cpu(lid->capabilities));
+
+	dev_dbg(ionic->dev, "eth.max_ucast_filters %d\n",
+		le32_to_cpu(lid->eth.max_ucast_filters));
+	dev_dbg(ionic->dev, "eth.max_mcast_filters %d\n",
+		le32_to_cpu(lid->eth.max_mcast_filters));
+	dev_dbg(ionic->dev, "eth.features 0x%llx\n",
+		le64_to_cpu(lid->eth.config.features));
+	dev_dbg(ionic->dev, "eth.queue_count[IONIC_QTYPE_ADMINQ] %d\n",
+		le32_to_cpu(lid->eth.config.queue_count[IONIC_QTYPE_ADMINQ]));
+	dev_dbg(ionic->dev, "eth.queue_count[IONIC_QTYPE_NOTIFYQ] %d\n",
+		le32_to_cpu(lid->eth.config.queue_count[IONIC_QTYPE_NOTIFYQ]));
+	dev_dbg(ionic->dev, "eth.queue_count[IONIC_QTYPE_RXQ] %d\n",
+		le32_to_cpu(lid->eth.config.queue_count[IONIC_QTYPE_RXQ]));
+	dev_dbg(ionic->dev, "eth.queue_count[IONIC_QTYPE_TXQ] %d\n",
+		le32_to_cpu(lid->eth.config.queue_count[IONIC_QTYPE_TXQ]));
+	dev_dbg(ionic->dev, "eth.config.name %s\n", lid->eth.config.name);
+	dev_dbg(ionic->dev, "eth.config.mac %pM\n", lid->eth.config.mac);
+	dev_dbg(ionic->dev, "eth.config.mtu %d\n",
+		le32_to_cpu(lid->eth.config.mtu));
+
+	return 0;
+}
+
+int ionic_lifs_size(struct ionic *ionic)
+{
+	struct identity *ident = &ionic->ident;
+	union lif_config *lc = &ident->lif.eth.config;
+	unsigned int nintrs, dev_nintrs;
+	unsigned int ntxqs_per_lif;
+	unsigned int nrxqs_per_lif;
+	unsigned int neqs_per_lif;
+	unsigned int nnqs_per_lif;
+	unsigned int nxqs, neqs;
+	unsigned int min_intrs;
+	unsigned int nlifs;
+	int err;
+
+	nlifs = le32_to_cpu(ident->dev.nlifs);
+	dev_nintrs = le32_to_cpu(ident->dev.nintrs);
+	neqs_per_lif = le32_to_cpu(ident->lif.rdma.eq_qtype.qid_count);
+	nnqs_per_lif = le32_to_cpu(lc->queue_count[IONIC_QTYPE_NOTIFYQ]);
+	ntxqs_per_lif = le32_to_cpu(lc->queue_count[IONIC_QTYPE_TXQ]);
+	nrxqs_per_lif = le32_to_cpu(lc->queue_count[IONIC_QTYPE_RXQ]);
+
+	nxqs = min(ntxqs_per_lif, nrxqs_per_lif);
+	nxqs = min(nxqs, num_online_cpus());
+	neqs = min(neqs_per_lif, num_online_cpus());
+
+try_again:
+	/* interrupt usage:
+	 *    1 for master lif adminq/notifyq
+	 *    1 for each CPU for master lif TxRx queue pairs
+	 *    whatever's left is for RDMA queues
+	 */
+	nintrs = 1 + nxqs + neqs;
+	min_intrs = 2;  /* adminq + 1 TxRx queue pair */
+
+	if (nintrs > dev_nintrs)
+		goto try_fewer;
+
+	err = ionic_bus_alloc_irq_vectors(ionic, nintrs);
+	if (err < 0 && err != -ENOSPC) {
+		dev_err(ionic->dev, "Can't get intrs from OS: %d\n", err);
+		return err;
+	}
+	if (err == -ENOSPC)
+		goto try_fewer;
+
+	if (err != nintrs) {
+		ionic_bus_free_irq_vectors(ionic);
+		goto try_fewer;
+	}
+
+	ionic->nnqs_per_lif = nnqs_per_lif;
+	ionic->neqs_per_lif = neqs;
+	ionic->ntxqs_per_lif = nxqs;
+	ionic->nrxqs_per_lif = nxqs;
+	ionic->nintrs = nintrs;
+
+	return ionic_debugfs_add_sizes(ionic);
+
+try_fewer:
+	if (nnqs_per_lif > 1) {
+		nnqs_per_lif >>= 1;
+		goto try_again;
+	}
+	if (neqs > 1) {
+		neqs >>= 1;
+		goto try_again;
+	}
+	if (nxqs > 1) {
+		nxqs >>= 1;
+		goto try_again;
+	}
+	dev_err(ionic->dev, "Can't get minimum %d intrs from OS\n", min_intrs);
+	return -ENOSPC;
+}
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
new file mode 100644
index 000000000000..d6b72ff69e0d
--- /dev/null
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -0,0 +1,76 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2017 - 2019 Pensando Systems, Inc */
+
+#ifndef _IONIC_LIF_H_
+#define _IONIC_LIF_H_
+
+#include <linux/pci.h>
+
+enum lif_state_flags {
+	LIF_INITED,
+
+	/* leave this as last */
+	LIF_STATE_SIZE
+};
+
+#define LIF_NAME_MAX_SZ		(32)
+struct lif {
+	char name[LIF_NAME_MAX_SZ];
+	struct list_head list;
+	struct net_device *netdev;
+	DECLARE_BITMAP(state, LIF_STATE_SIZE);
+	struct ionic *ionic;
+	bool registered;
+	unsigned int index;
+	unsigned int hw_index;
+	unsigned int neqs;
+	unsigned int nxqs;
+
+	struct lif_info *info;
+	dma_addr_t info_pa;
+	u32 info_sz;
+
+	struct dentry *dentry;
+	u32 flags;
+};
+
+static inline bool ionic_is_mnic(struct ionic *ionic)
+{
+	return ionic->pdev &&
+	       ionic->pdev->device == PCI_DEVICE_ID_PENSANDO_IONIC_ETH_MGMT;
+}
+
+static inline bool ionic_is_pf(struct ionic *ionic)
+{
+	return ionic->pdev &&
+	       ionic->pdev->device == PCI_DEVICE_ID_PENSANDO_IONIC_ETH_PF;
+}
+
+static inline bool ionic_is_vf(struct ionic *ionic)
+{
+	return ionic->pdev &&
+	       ionic->pdev->device == PCI_DEVICE_ID_PENSANDO_IONIC_ETH_VF;
+}
+
+static inline bool ionic_is_25g(struct ionic *ionic)
+{
+	return ionic_is_pf(ionic) &&
+	       ionic->pdev->subsystem_device == IONIC_SUBDEV_ID_NAPLES_25;
+}
+
+static inline bool ionic_is_100g(struct ionic *ionic)
+{
+	return ionic_is_pf(ionic) &&
+	       (ionic->pdev->subsystem_device == IONIC_SUBDEV_ID_NAPLES_100_4 ||
+		ionic->pdev->subsystem_device == IONIC_SUBDEV_ID_NAPLES_100_8);
+}
+
+int ionic_lifs_alloc(struct ionic *ionic);
+void ionic_lifs_free(struct ionic *ionic);
+void ionic_lifs_deinit(struct ionic *ionic);
+int ionic_lifs_init(struct ionic *ionic);
+int ionic_lif_identify(struct ionic *ionic, u8 lif_type,
+		       union lif_identity *lif_ident);
+int ionic_lifs_size(struct ionic *ionic);
+
+#endif /* _IONIC_LIF_H_ */
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 36314f865b94..e0c1977845dd 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -8,6 +8,7 @@
 
 #include "ionic.h"
 #include "ionic_bus.h"
+#include "ionic_lif.h"
 #include "ionic_debugfs.h"
 
 MODULE_DESCRIPTION(DRV_DESCRIPTION);
-- 
2.17.1

