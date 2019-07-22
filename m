Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56DFE70B9C
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 23:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732776AbfGVVkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 17:40:36 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33162 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732761AbfGVVke (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 17:40:34 -0400
Received: by mail-pf1-f194.google.com with SMTP id g2so18004139pfq.0
        for <netdev@vger.kernel.org>; Mon, 22 Jul 2019 14:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=nsDxtpf3EAmrLmKLvUo3e2Wsm7clt0a2a32D4MTlkXw=;
        b=X8Mu8dEzev7E+/54OCRIuE1QH4CeOcOkjELUcDIvNnklYKy0A+977KT1OemvZwW8dq
         5ikZIr1KCr+0kchmXNjGFowEYRsxTEvkFdzLWw0Fqc0dqnL2O3PXab/tgLRH6uZK3GrS
         S23svTPIBAKd+5OlBgVeGfdkHiNejfzBDrsjGwuOh7rLsFDEZ622gvWZ8YN7tjFWGbXP
         m0JYwd3qgTnnutGS02dG/5du6ZCV3cwN3ZNkx/HwOEw9imd2za171kft4Px8NRDOdKy1
         8URFLWAvDY5XbaMHyWdgax1wptoCxFg5M1CE1/cQuG0/JM8+27ArEQS48B4tqRIhmYQT
         o/HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=nsDxtpf3EAmrLmKLvUo3e2Wsm7clt0a2a32D4MTlkXw=;
        b=L1crJMiSzMRglsO789krTnA9F5Ntpv/JaQMmDRWKrtNGSkeLkmk3+yC15HAtRsUYG1
         UW5eITb3uNaevxcN5kLeYFZbLf1Bk5xJZQoKn+0llAwNByQr0MtgxmRRWmd3JVJO/jx+
         BNbewdYyH16j+tUNmq5YT9QtQJNHDn9ypddrI5Va28kTdNh103752y2JIKwQnwIziIXt
         2jNMQDQV/Kj6pTh5dUaaEPlzEMZXwT04SaIoEwOMpN7cL3yynlK3Yxg7gzFlf6XmMkzn
         88p4WVZK+ENfcRxyqXNjo/0B9sNERZJarLz0swUXox87ipIfZZyim9u0Pm4P7VjR2ssU
         88VA==
X-Gm-Message-State: APjAAAXDWurKvOPdDafT554Oq3nDi41i7TLbR6Rn2AwMUxUfiG9QD9sy
        pH0DJvrOrw3elvyByFIeL+0iyw==
X-Google-Smtp-Source: APXvYqy/F8JIUC6svUFsoBK0ug51RWbxzu/akh07HtGCc8sKgV51HdNDBTFevbugtsHm6na7TYuXXg==
X-Received: by 2002:a05:6a00:4c:: with SMTP id i12mr2298184pfk.134.1563831634098;
        Mon, 22 Jul 2019 14:40:34 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id p65sm40593714pfp.58.2019.07.22.14.40.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Jul 2019 14:40:33 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH v4 net-next 05/19] ionic: Add interrupts and doorbells
Date:   Mon, 22 Jul 2019 14:40:09 -0700
Message-Id: <20190722214023.9513-6-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190722214023.9513-1-snelson@pensando.io>
References: <20190722214023.9513-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ionic interrupt model is based on interrupt control blocks
accessed through the PCI BAR.  Doorbell registers are used by
the driver to signal to the NIC that requests are waiting on
the message queues.  Interrupts are used by the NIC to signal
to the driver that answers are waiting on the completion queues.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic.h   |  3 +
 .../net/ethernet/pensando/ionic/ionic_bus.h   |  2 +
 .../ethernet/pensando/ionic/ionic_bus_pci.c   | 12 ++++
 .../net/ethernet/pensando/ionic/ionic_dev.c   |  6 ++
 .../net/ethernet/pensando/ionic/ionic_dev.h   | 21 ++++++
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 64 +++++++++++++++++++
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  4 ++
 7 files changed, 112 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
index afff2e074f1a..c86a08752b3b 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -4,6 +4,8 @@
 #ifndef _IONIC_H_
 #define _IONIC_H_
 
+struct lif;
+
 #include "ionic_if.h"
 #include "ionic_dev.h"
 
@@ -38,6 +40,7 @@ struct ionic {
 	unsigned int nrxqs_per_lif;
 	DECLARE_BITMAP(lifbits, IONIC_LIFS_MAX);
 	unsigned int nintrs;
+	DECLARE_BITMAP(intrs, INTR_CTRL_REGS_MAX);
 };
 
 int ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_wait);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus.h b/drivers/net/ethernet/pensando/ionic/ionic_bus.h
index 3b1e2d0ebf8f..6b29e94f81d6 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus.h
@@ -9,5 +9,7 @@ int ionic_bus_alloc_irq_vectors(struct ionic *ionic, unsigned int nintrs);
 void ionic_bus_free_irq_vectors(struct ionic *ionic);
 int ionic_bus_register_driver(void);
 void ionic_bus_unregister_driver(void);
+void __iomem *ionic_bus_map_dbpage(struct ionic *ionic, int page_num);
+void ionic_bus_unmap_dbpage(struct ionic *ionic, void __iomem *page);
 
 #endif /* _IONIC_BUS_H_ */
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index 0ed724efe117..838d7c423b2c 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -87,6 +87,18 @@ static void ionic_unmap_bars(struct ionic *ionic)
 	}
 }
 
+void __iomem *ionic_bus_map_dbpage(struct ionic *ionic, int page_num)
+{
+	return pci_iomap_range(ionic->pdev,
+			       ionic->bars[IONIC_PCI_BAR_DBELL].res_index,
+			       (u64)page_num << PAGE_SHIFT, PAGE_SIZE);
+}
+
+void ionic_bus_unmap_dbpage(struct ionic *ionic, void __iomem *page)
+{
+	iounmap(page);
+}
+
 static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	struct device *dev = &pdev->dev;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index 59d863e45072..c0710bf200a5 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -9,6 +9,7 @@
 #include <linux/etherdevice.h>
 #include "ionic.h"
 #include "ionic_dev.h"
+#include "ionic_lif.h"
 
 void ionic_init_devinfo(struct ionic_dev *idev)
 {
@@ -280,3 +281,8 @@ void ionic_dev_cmd_lif_reset(struct ionic_dev *idev, u16 lif_index)
 
 	ionic_dev_cmd_go(idev, &cmd);
 }
+
+int ionic_db_page_num(struct lif *lif, int pid)
+{
+	return (lif->hw_index * lif->dbid_count) + pid;
+}
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index a8a84734b433..6d30adeab8c5 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -132,8 +132,27 @@ struct ionic_dev {
 	struct ionic_devinfo dev_info;
 };
 
+#define INTR_INDEX_NOT_ASSIGNED		-1
+#define INTR_NAME_MAX_SZ		32
+
+struct intr {
+	char name[INTR_NAME_MAX_SZ];
+	unsigned int index;
+	unsigned int vector;
+	u64 rearm_count;
+	unsigned int cpu;
+	cpumask_t affinity_mask;
+};
+
 struct ionic;
 
+static inline void ionic_intr_init(struct ionic_dev *idev, struct intr *intr,
+				   unsigned long index)
+{
+	ionic_intr_clean(idev->intr_ctrl, index);
+	intr->index = index;
+}
+
 void ionic_init_devinfo(struct ionic_dev *idev);
 int ionic_dev_setup(struct ionic *ionic);
 void ionic_dev_teardown(struct ionic *ionic);
@@ -163,4 +182,6 @@ void ionic_dev_cmd_lif_init(struct ionic_dev *idev, u16 lif_index,
 			    dma_addr_t addr);
 void ionic_dev_cmd_lif_reset(struct ionic_dev *idev, u16 lif_index);
 
+int ionic_db_page_num(struct lif *lif, int pid);
+
 #endif /* _IONIC_DEV_H_ */
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index e32ce2a3d0ce..65ced9b469c9 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -12,6 +12,30 @@
 #include "ionic_lif.h"
 #include "ionic_debugfs.h"
 
+static int ionic_intr_alloc(struct lif *lif, struct intr *intr)
+{
+	struct ionic *ionic = lif->ionic;
+	int index;
+
+	index = find_first_zero_bit(ionic->intrs, ionic->nintrs);
+	if (index == ionic->nintrs) {
+		netdev_warn(lif->netdev, "%s: no intr, index=%d nintrs=%d\n",
+			    __func__, index, ionic->nintrs);
+		return -ENOSPC;
+	}
+
+	set_bit(index, ionic->intrs);
+	ionic_intr_init(&ionic->idev, intr, index);
+
+	return 0;
+}
+
+static void ionic_intr_free(struct lif *lif, int index)
+{
+	if (index != INTR_INDEX_NOT_ASSIGNED && index < lif->ionic->nintrs)
+		clear_bit(index, lif->ionic->intrs);
+}
+
 static struct lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index)
 {
 	struct device *dev = ionic->dev;
@@ -96,6 +120,12 @@ static void ionic_lif_free(struct lif *lif)
 	lif->info = NULL;
 	lif->info_pa = 0;
 
+	/* unmap doorbell page */
+	ionic_bus_unmap_dbpage(lif->ionic, lif->kern_dbpage);
+	lif->kern_dbpage = NULL;
+	kfree(lif->dbid_inuse);
+	lif->dbid_inuse = NULL;
+
 	/* free netdev & lif */
 	ionic_debugfs_del_lif(lif);
 	list_del(&lif->list);
@@ -138,7 +168,9 @@ void ionic_lifs_deinit(struct ionic *ionic)
 static int ionic_lif_init(struct lif *lif)
 {
 	struct ionic_dev *idev = &lif->ionic->idev;
+	struct device *dev = lif->ionic->dev;
 	struct lif_init_comp comp;
+	int dbpage_num;
 	int err;
 
 	ionic_debugfs_add_lif(lif);
@@ -153,9 +185,41 @@ static int ionic_lif_init(struct lif *lif)
 
 	lif->hw_index = le16_to_cpu(comp.hw_index);
 
+	/* now that we have the hw_index we can figure out our doorbell page */
+	lif->dbid_count = le32_to_cpu(lif->ionic->ident.dev.ndbpgs_per_lif);
+	if (!lif->dbid_count) {
+		dev_err(dev, "No doorbell pages, aborting\n");
+		return -EINVAL;
+	}
+
+	lif->dbid_inuse = kzalloc(BITS_TO_LONGS(lif->dbid_count) * sizeof(long),
+				  GFP_KERNEL);
+	if (!lif->dbid_inuse) {
+		dev_err(dev, "Failed alloc doorbell id bitmap, aborting\n");
+		return -ENOMEM;
+	}
+
+	/* first doorbell id reserved for kernel (dbid aka pid == zero) */
+	set_bit(0, lif->dbid_inuse);
+	lif->kern_pid = 0;
+
+	dbpage_num = ionic_db_page_num(lif, lif->kern_pid);
+	lif->kern_dbpage = ionic_bus_map_dbpage(lif->ionic, dbpage_num);
+	if (!lif->kern_dbpage) {
+		dev_err(dev, "Cannot map dbpage, aborting\n");
+		err = -ENOMEM;
+		goto err_out_free_dbid;
+	}
+
 	set_bit(LIF_INITED, lif->state);
 
 	return 0;
+
+err_out_free_dbid:
+	kfree(lif->dbid_inuse);
+	lif->dbid_inuse = NULL;
+
+	return err;
 }
 
 int ionic_lifs_init(struct ionic *ionic)
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 37f79d36744a..98d0699234e9 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -23,6 +23,8 @@ struct lif {
 	bool registered;
 	unsigned int index;
 	unsigned int hw_index;
+	unsigned int kern_pid;
+	u64 __iomem *kern_dbpage;
 	unsigned int neqs;
 	unsigned int nxqs;
 
@@ -30,6 +32,8 @@ struct lif {
 	dma_addr_t info_pa;
 	u32 info_sz;
 
+	unsigned long *dbid_inuse;
+	unsigned int dbid_count;
 	struct dentry *dentry;
 	u32 flags;
 };
-- 
2.17.1

