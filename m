Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFE4CA76F6
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 00:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727286AbfICW2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 18:28:55 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43285 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727056AbfICW2x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 18:28:53 -0400
Received: by mail-pf1-f196.google.com with SMTP id d15so2285154pfo.10
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 15:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=yzpLbHT+itzsWqGl12tvx08vddKLQuz5MqqK0OxFrnc=;
        b=DzhiHzO/rRAHWK30xbE8E7i72NMM1951A2eccRYrLvj4NQxSoeHRDJd2ZZJyMJ4P8X
         +HWnDlEgxpQC7tat2/+XhIt3aK6dJc/fOhFGnHBIk25pHVCEBRpVcStbHHe2gokobH5s
         C1NCcUU/qppWSlQDVPbKv82mXrGuwRvog2leYvI+DpYPEb9/7+1ruMCepHzvHPUCYZ+f
         zcX0khybCOpn+t7t0IoHgc6uetCCCFC7jau1mE9BpSQ1903kTo49rzitPcJTTDd2/D3a
         63ghg3rHwYjkxtWHtSq7jq96BRgiuuiW+ktbKjuKIIId06G1tzb6i3NpkdzxcRIQDnYP
         QcWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=yzpLbHT+itzsWqGl12tvx08vddKLQuz5MqqK0OxFrnc=;
        b=Jy67m63lN0R4uiTPvTDFirn275xwZcnmq00svfi0glqywxSFyeMEZUIPGA0KwpLjP0
         dxoqxd3eKmDj3cmtPZ8UOnQ0Xa3i+yWzSsBgMRExKv61qxc6/WlTeYGdw9f9k/BlXypQ
         6aI0Ri/HFYkOf8H4c8ydv4G3kcZrDVEo6z5FTaVQFAhfonNvLUd1YVlWAZHOMGXZhXdq
         OZ+ZvvKx+WXcIn1j8e2JjIFU4S12UnT9+7q2937QkG1LiqqqUDDOJcIeAfg4AIjJ4goY
         +DT3Kmq1QKN5xIbkaPRHFc3fMW/HV2D5GgMHfID/IV2Y3UOunPqvaKHqIqCixLJVpuAc
         at2A==
X-Gm-Message-State: APjAAAWwS/EpP7cAvLBPK63iruEeB8AD10PJ3p9cr7zpK77eo9hDYnDR
        4ZzGJJsJFZ2P873Ng/8vUJwYSg==
X-Google-Smtp-Source: APXvYqwEd5g9+zx1k2CK9Ab0YEYAUenwoEOft0UhuRzmxSzN/jnJvR3BiiTWiYiHftn2RqGrQVTRfw==
X-Received: by 2002:a62:5214:: with SMTP id g20mr25655412pfb.103.1567549732094;
        Tue, 03 Sep 2019 15:28:52 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id e17sm520520pjt.6.2019.09.03.15.28.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Sep 2019 15:28:51 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH v7 net-next 05/19] ionic: Add basic lif support
Date:   Tue,  3 Sep 2019 15:28:07 -0700
Message-Id: <20190903222821.46161-6-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190903222821.46161-1-snelson@pensando.io>
References: <20190903222821.46161-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The LIF is the Logical Interface, which represents the external
connections.  The NIC can multiplex many LIFs to a single port,
but in most setups, LIF0 is the primary control for the port.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/Makefile  |   2 +-
 drivers/net/ethernet/pensando/ionic/ionic.h   |   7 +
 .../net/ethernet/pensando/ionic/ionic_bus.h   |   2 +
 .../ethernet/pensando/ionic/ionic_bus_pci.c   |  47 +++
 .../ethernet/pensando/ionic/ionic_debugfs.c   |  36 +++
 .../ethernet/pensando/ionic/ionic_debugfs.h   |   6 +
 .../net/ethernet/pensando/ionic/ionic_dev.c   |  34 ++
 .../net/ethernet/pensando/ionic/ionic_dev.h   |   7 +
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 291 ++++++++++++++++++
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  45 +++
 .../net/ethernet/pensando/ionic/ionic_main.c  |   1 +
 11 files changed, 477 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_lif.c
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_lif.h

diff --git a/drivers/net/ethernet/pensando/ionic/Makefile b/drivers/net/ethernet/pensando/ionic/Makefile
index a23d58519c63..215ed1ea44df 100644
--- a/drivers/net/ethernet/pensando/ionic/Makefile
+++ b/drivers/net/ethernet/pensando/ionic/Makefile
@@ -4,4 +4,4 @@
 obj-$(CONFIG_IONIC) := ionic.o
 
 ionic-y := ionic_main.o ionic_bus_pci.o ionic_devlink.o ionic_dev.o \
-	   ionic_debugfs.o
+	   ionic_debugfs.o ionic_lif.o
diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
index 4960effd2bcc..723b2ba6874e 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -32,6 +32,13 @@ struct ionic {
 	struct ionic_dev_bar bars[IONIC_BARS_MAX];
 	unsigned int num_bars;
 	struct ionic_identity ident;
+	struct list_head lifs;
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
index 804dd43e92a6..f0e0daee45bc 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -8,6 +8,7 @@
 
 #include "ionic.h"
 #include "ionic_bus.h"
+#include "ionic_lif.h"
 #include "ionic_debugfs.h"
 
 /* Supported devices */
@@ -23,6 +24,17 @@ const char *ionic_bus_info(struct ionic *ionic)
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
@@ -151,12 +163,44 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
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
 	err = ionic_devlink_register(ionic);
 	if (err)
 		dev_err(dev, "Cannot register devlink: %d\n", err);
 
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
@@ -185,6 +229,9 @@ static void ionic_remove(struct pci_dev *pdev)
 		return;
 
 	ionic_devlink_unregister(ionic);
+	ionic_lifs_deinit(ionic);
+	ionic_lifs_free(ionic);
+	ionic_bus_free_irq_vectors(ionic);
 	ionic_port_reset(ionic);
 	ionic_reset(ionic);
 	ionic_dev_teardown(ionic);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
index c57a7e4f35d1..840b3da5da3e 100644
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
@@ -58,4 +60,38 @@ void ionic_debugfs_add_ident(struct ionic *ionic)
 			    ionic, &identity_fops) ? 0 : -EOPNOTSUPP;
 }
 
+void ionic_debugfs_add_sizes(struct ionic *ionic)
+{
+	debugfs_create_u32("nlifs", 0400, ionic->dentry,
+			   (u32 *)&ionic->ident.dev.nlifs);
+	debugfs_create_u32("nintrs", 0400, ionic->dentry, &ionic->nintrs);
+
+	debugfs_create_u32("ntxqs_per_lif", 0400, ionic->dentry,
+			   (u32 *)&ionic->ident.lif.eth.config.queue_count[IONIC_QTYPE_TXQ]);
+	debugfs_create_u32("nrxqs_per_lif", 0400, ionic->dentry,
+			   (u32 *)&ionic->ident.lif.eth.config.queue_count[IONIC_QTYPE_RXQ]);
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
+DEFINE_SHOW_ATTRIBUTE(netdev);
+
+void ionic_debugfs_add_lif(struct ionic_lif *lif)
+{
+	lif->dentry = debugfs_create_dir(lif->name, lif->ionic->dentry);
+	debugfs_create_file("netdev", 0400, lif->dentry,
+			    lif->netdev, &netdev_fops);
+}
+
+void ionic_debugfs_del_lif(struct ionic_lif *lif)
+{
+	debugfs_remove_recursive(lif->dentry);
+	lif->dentry = NULL;
+}
 #endif
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.h b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.h
index 7073a8b4e2f9..f742acf56adf 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.h
@@ -13,12 +13,18 @@ void ionic_debugfs_destroy(void);
 void ionic_debugfs_add_dev(struct ionic *ionic);
 void ionic_debugfs_del_dev(struct ionic *ionic);
 void ionic_debugfs_add_ident(struct ionic *ionic);
+void ionic_debugfs_add_sizes(struct ionic *ionic);
+void ionic_debugfs_add_lif(struct ionic_lif *lif);
+void ionic_debugfs_del_lif(struct ionic_lif *lif);
 #else
 static inline void ionic_debugfs_create(void) { }
 static inline void ionic_debugfs_destroy(void) { }
 static inline void ionic_debugfs_add_dev(struct ionic *ionic) { }
 static inline void ionic_debugfs_del_dev(struct ionic *ionic) { }
 static inline void ionic_debugfs_add_ident(struct ionic *ionic) { }
+static inline void ionic_debugfs_add_sizes(struct ionic *ionic) { }
+static inline void ionic_debugfs_add_lif(struct ionic_lif *lif) { }
+static inline void ionic_debugfs_del_lif(struct ionic_lif *lif) { }
 #endif
 
 #endif /* _IONIC_DEBUGFS_H_ */
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index 3137776e9191..01e922fa9366 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -226,3 +226,37 @@ void ionic_dev_cmd_port_pause(struct ionic_dev *idev, u8 pause_type)
 
 	ionic_dev_cmd_go(idev, &cmd);
 }
+
+/* LIF commands */
+void ionic_dev_cmd_lif_identify(struct ionic_dev *idev, u8 type, u8 ver)
+{
+	union ionic_dev_cmd cmd = {
+		.lif_identify.opcode = IONIC_CMD_LIF_IDENTIFY,
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
+	union ionic_dev_cmd cmd = {
+		.lif_init.opcode = IONIC_CMD_LIF_INIT,
+		.lif_init.index = cpu_to_le16(lif_index),
+		.lif_init.info_pa = cpu_to_le64(info_pa),
+	};
+
+	ionic_dev_cmd_go(idev, &cmd);
+}
+
+void ionic_dev_cmd_lif_reset(struct ionic_dev *idev, u16 lif_index)
+{
+	union ionic_dev_cmd cmd = {
+		.lif_init.opcode = IONIC_CMD_LIF_RESET,
+		.lif_init.index = cpu_to_le16(lif_index),
+	};
+
+	ionic_dev_cmd_go(idev, &cmd);
+}
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index 81b6910aabc1..e8d4fc888333 100644
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
@@ -148,4 +150,9 @@ void ionic_dev_cmd_port_autoneg(struct ionic_dev *idev, u8 an_enable);
 void ionic_dev_cmd_port_fec(struct ionic_dev *idev, u8 fec_type);
 void ionic_dev_cmd_port_pause(struct ionic_dev *idev, u8 pause_type);
 
+void ionic_dev_cmd_lif_identify(struct ionic_dev *idev, u8 type, u8 ver);
+void ionic_dev_cmd_lif_init(struct ionic_dev *idev, u16 lif_index,
+			    dma_addr_t addr);
+void ionic_dev_cmd_lif_reset(struct ionic_dev *idev, u16 lif_index);
+
 #endif /* _IONIC_DEV_H_ */
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
new file mode 100644
index 000000000000..5528043095d8
--- /dev/null
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -0,0 +1,291 @@
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
+static struct ionic_lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index)
+{
+	struct device *dev = ionic->dev;
+	struct net_device *netdev;
+	struct ionic_lif *lif;
+	int err;
+
+	netdev = alloc_etherdev_mqs(sizeof(*lif),
+				    ionic->ntxqs_per_lif, ionic->ntxqs_per_lif);
+	if (!netdev) {
+		dev_err(dev, "Cannot allocate netdev, aborting\n");
+		return ERR_PTR(-ENOMEM);
+	}
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
+	struct ionic_lif *lif;
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
+static void ionic_lif_reset(struct ionic_lif *lif)
+{
+	struct ionic_dev *idev = &lif->ionic->idev;
+
+	mutex_lock(&lif->ionic->dev_cmd_lock);
+	ionic_dev_cmd_lif_reset(idev, lif->index);
+	ionic_dev_cmd_wait(lif->ionic, DEVCMD_TIMEOUT);
+	mutex_unlock(&lif->ionic->dev_cmd_lock);
+}
+
+static void ionic_lif_free(struct ionic_lif *lif)
+{
+	struct device *dev = lif->ionic->dev;
+
+	ionic_lif_reset(lif);
+
+	/* free lif info */
+	dma_free_coherent(dev, lif->info_sz, lif->info, lif->info_pa);
+	lif->info = NULL;
+	lif->info_pa = 0;
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
+	struct ionic_lif *lif;
+
+	list_for_each_safe(cur, tmp, &ionic->lifs) {
+		lif = list_entry(cur, struct ionic_lif, list);
+
+		ionic_lif_free(lif);
+	}
+}
+
+static void ionic_lif_deinit(struct ionic_lif *lif)
+{
+	if (!test_bit(IONIC_LIF_INITED, lif->state))
+		return;
+
+	clear_bit(IONIC_LIF_INITED, lif->state);
+
+	ionic_lif_reset(lif);
+}
+
+void ionic_lifs_deinit(struct ionic *ionic)
+{
+	struct list_head *cur, *tmp;
+	struct ionic_lif *lif;
+
+	list_for_each_safe(cur, tmp, &ionic->lifs) {
+		lif = list_entry(cur, struct ionic_lif, list);
+		ionic_lif_deinit(lif);
+	}
+}
+
+static int ionic_lif_init(struct ionic_lif *lif)
+{
+	struct ionic_dev *idev = &lif->ionic->idev;
+	struct ionic_lif_init_comp comp;
+	int err;
+
+	ionic_debugfs_add_lif(lif);
+
+	mutex_lock(&lif->ionic->dev_cmd_lock);
+	ionic_dev_cmd_lif_init(idev, lif->index, lif->info_pa);
+	err = ionic_dev_cmd_wait(lif->ionic, DEVCMD_TIMEOUT);
+	ionic_dev_cmd_comp(idev, (union ionic_dev_cmd_comp *)&comp);
+	mutex_unlock(&lif->ionic->dev_cmd_lock);
+	if (err)
+		return err;
+
+	lif->hw_index = le16_to_cpu(comp.hw_index);
+
+	set_bit(IONIC_LIF_INITED, lif->state);
+
+	return 0;
+}
+
+int ionic_lifs_init(struct ionic *ionic)
+{
+	struct list_head *cur, *tmp;
+	struct ionic_lif *lif;
+	int err;
+
+	list_for_each_safe(cur, tmp, &ionic->lifs) {
+		lif = list_entry(cur, struct ionic_lif, list);
+		err = ionic_lif_init(lif);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+int ionic_lif_identify(struct ionic *ionic, u8 lif_type,
+		       union ionic_lif_identity *lid)
+{
+	struct ionic_dev *idev = &ionic->idev;
+	size_t sz;
+	int err;
+
+	sz = min(sizeof(*lid), sizeof(idev->dev_cmd_regs->data));
+
+	mutex_lock(&ionic->dev_cmd_lock);
+	ionic_dev_cmd_lif_identify(idev, lif_type, IONIC_IDENTITY_VERSION_1);
+	err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
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
+	struct ionic_identity *ident = &ionic->ident;
+	unsigned int nintrs, dev_nintrs;
+	union ionic_lif_config *lc;
+	unsigned int ntxqs_per_lif;
+	unsigned int nrxqs_per_lif;
+	unsigned int neqs_per_lif;
+	unsigned int nnqs_per_lif;
+	unsigned int nxqs, neqs;
+	unsigned int min_intrs;
+	int err;
+
+	lc = &ident->lif.eth.config;
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
+	ionic_debugfs_add_sizes(ionic);
+
+	return 0;
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
index 000000000000..fff4fc287b89
--- /dev/null
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -0,0 +1,45 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2017 - 2019 Pensando Systems, Inc */
+
+#ifndef _IONIC_LIF_H_
+#define _IONIC_LIF_H_
+
+#include <linux/pci.h>
+
+enum ionic_lif_state_flags {
+	IONIC_LIF_INITED,
+
+	/* leave this as last */
+	IONIC_LIF_STATE_SIZE
+};
+
+#define IONIC_LIF_NAME_MAX_SZ		32
+struct ionic_lif {
+	char name[IONIC_LIF_NAME_MAX_SZ];
+	struct list_head list;
+	struct net_device *netdev;
+	DECLARE_BITMAP(state, IONIC_LIF_STATE_SIZE);
+	struct ionic *ionic;
+	bool registered;
+	unsigned int index;
+	unsigned int hw_index;
+	unsigned int neqs;
+	unsigned int nxqs;
+
+	struct ionic_lif_info *info;
+	dma_addr_t info_pa;
+	u32 info_sz;
+
+	struct dentry *dentry;
+	u32 flags;
+};
+
+int ionic_lifs_alloc(struct ionic *ionic);
+void ionic_lifs_free(struct ionic *ionic);
+void ionic_lifs_deinit(struct ionic *ionic);
+int ionic_lifs_init(struct ionic *ionic);
+int ionic_lif_identify(struct ionic *ionic, u8 lif_type,
+		       union ionic_lif_identity *lif_ident);
+int ionic_lifs_size(struct ionic *ionic);
+
+#endif /* _IONIC_LIF_H_ */
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index d7e62d31bff0..d6d77abbc4af 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -8,6 +8,7 @@
 
 #include "ionic.h"
 #include "ionic_bus.h"
+#include "ionic_lif.h"
 #include "ionic_debugfs.h"
 
 MODULE_DESCRIPTION(IONIC_DRV_DESCRIPTION);
-- 
2.17.1

