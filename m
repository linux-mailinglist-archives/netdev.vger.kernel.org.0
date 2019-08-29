Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BADCFA250F
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 20:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729464AbfH2S17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 14:27:59 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39545 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729585AbfH2S14 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 14:27:56 -0400
Received: by mail-pf1-f195.google.com with SMTP id y200so2625746pfb.6
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 11:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=XyF8PSw9Ik1sRy/1YFH4kamkPbRE7v6yXWfYOHN3QjE=;
        b=lINBW1MVSyW90DqWHTI+sY1pSpsPC6jaLnuBcOHGeFyGwdTePx5XQMDttOfCCKjkZu
         SL1g/xX4kIqKlKtfC5xkiynS87dYLv1GKCPK7O46zqZx0ejnAWkmJMEYgNwUN7IGqY3Q
         iCuJBmzqhdGG2jatu9KL+H9dXiLppYU023W9fgHenofYNMyv/8JeVnMYCyE9WCpvmifQ
         fQ8eVpf6N/cpTB6zqMvwcdTCRGcyktfIuDlkOMjfdwoSQu3oeb8CJffbDdoL5JMZU6Mu
         Z1rnIAJOfO44xp9qYDaVSTJUHCSOJkccShLM60qH4dgIKPx0AjteWWp6bTw6wJ/DMsT0
         qRlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=XyF8PSw9Ik1sRy/1YFH4kamkPbRE7v6yXWfYOHN3QjE=;
        b=MPqGh/j5vM+d+Cs2z60DEeFtkPAATywIWvd6eolEx/k471XsV1jzvB5ouxqoK+U/ja
         M5aQCHuqvpywuZt+PNlBRmIvDmJS3nnXWgdAxeGqWxwGvYYWN8fHbXgcwEXNTTG9spf0
         FjT5TYmmCJPdDNpAneh0RV1+dPbiRP71sxJVjxxQKtZbGNO+gbKOGBmYR5wnnTqAgefQ
         KrGBxJvubQX5RRCUmFJb5XIMj+wvlXGKtzxCXw6lXvj3R1dd+xoG+IecIVD+80bZcv1L
         DL7VB7tThnqHJWbzy42usk5n2RRNOaDgZS/UeoVaxwuBYym+Xu9VbwdF5JTsv7nBnQRP
         s5gg==
X-Gm-Message-State: APjAAAU42jO4EJNbV4rSzK2PfOr1jHgNHnxJO2BdHGvSx0PxsFFbjFzE
        KqTzBlNJvbb4+eZ+uIBBL1kDfsRl6Ag=
X-Google-Smtp-Source: APXvYqxXn5OCDBSBfAVe59kGiGP9AEqtjy6wciMvC8M8kbjXfpLVW6JtL3+akJFmaHijwMBRv3uQag==
X-Received: by 2002:aa7:809a:: with SMTP id v26mr13354035pff.82.1567103275961;
        Thu, 29 Aug 2019 11:27:55 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id t70sm3082824pjb.2.2019.08.29.11.27.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 11:27:55 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH v6 net-next 06/19] ionic: Add interrupts and doorbells
Date:   Thu, 29 Aug 2019 11:27:07 -0700
Message-Id: <20190829182720.68419-7-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190829182720.68419-1-snelson@pensando.io>
References: <20190829182720.68419-1-snelson@pensando.io>
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
 drivers/net/ethernet/pensando/ionic/ionic.h   |  3 ++
 .../net/ethernet/pensando/ionic/ionic_bus.h   |  2 +
 .../ethernet/pensando/ionic/ionic_bus_pci.c   | 12 ++++++
 .../net/ethernet/pensando/ionic/ionic_dev.c   |  6 +++
 .../net/ethernet/pensando/ionic/ionic_dev.h   | 22 +++++++++++
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 39 +++++++++++++++++++
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  4 ++
 .../net/ethernet/pensando/ionic/ionic_regs.h  |  3 ++
 8 files changed, 91 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
index 723b2ba6874e..affd7a88b58b 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -4,6 +4,8 @@
 #ifndef _IONIC_H_
 #define _IONIC_H_
 
+struct ionic_lif;
+
 #include "ionic_if.h"
 #include "ionic_dev.h"
 #include "ionic_devlink.h"
@@ -39,6 +41,7 @@ struct ionic {
 	unsigned int nrxqs_per_lif;
 	DECLARE_BITMAP(lifbits, IONIC_LIFS_MAX);
 	unsigned int nintrs;
+	DECLARE_BITMAP(intrs, IONIC_INTR_CTRL_REGS_MAX);
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
index f0e0daee45bc..4f08d915c3d2 100644
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
index 01e922fa9366..dbdde548848e 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -9,6 +9,7 @@
 #include <linux/etherdevice.h>
 #include "ionic.h"
 #include "ionic_dev.h"
+#include "ionic_lif.h"
 
 void ionic_init_devinfo(struct ionic *ionic)
 {
@@ -260,3 +261,8 @@ void ionic_dev_cmd_lif_reset(struct ionic_dev *idev, u16 lif_index)
 
 	ionic_dev_cmd_go(idev, &cmd);
 }
+
+int ionic_db_page_num(struct ionic_lif *lif, int pid)
+{
+	return (lif->hw_index * lif->dbid_count) + pid;
+}
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index e8d4fc888333..2252fa9ad0e3 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -126,8 +126,28 @@ struct ionic_dev {
 	struct ionic_devinfo dev_info;
 };
 
+#define INTR_INDEX_NOT_ASSIGNED		-1
+#define INTR_NAME_MAX_SZ		32
+
+struct ionic_intr_info {
+	char name[INTR_NAME_MAX_SZ];
+	unsigned int index;
+	unsigned int vector;
+	u64 rearm_count;
+	unsigned int cpu;
+	cpumask_t affinity_mask;
+};
+
 struct ionic;
 
+static inline void ionic_intr_init(struct ionic_dev *idev,
+				   struct ionic_intr_info *intr,
+				   unsigned long index)
+{
+	ionic_intr_clean(idev->intr_ctrl, index);
+	intr->index = index;
+}
+
 void ionic_init_devinfo(struct ionic *ionic);
 int ionic_dev_setup(struct ionic *ionic);
 void ionic_dev_teardown(struct ionic *ionic);
@@ -155,4 +175,6 @@ void ionic_dev_cmd_lif_init(struct ionic_dev *idev, u16 lif_index,
 			    dma_addr_t addr);
 void ionic_dev_cmd_lif_reset(struct ionic_dev *idev, u16 lif_index);
 
+int ionic_db_page_num(struct ionic_lif *lif, int pid);
+
 #endif /* _IONIC_DEV_H_ */
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 5528043095d8..e9dc97b968b5 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -94,6 +94,12 @@ static void ionic_lif_free(struct ionic_lif *lif)
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
@@ -136,7 +142,9 @@ void ionic_lifs_deinit(struct ionic *ionic)
 static int ionic_lif_init(struct ionic_lif *lif)
 {
 	struct ionic_dev *idev = &lif->ionic->idev;
+	struct device *dev = lif->ionic->dev;
 	struct ionic_lif_init_comp comp;
+	int dbpage_num;
 	int err;
 
 	ionic_debugfs_add_lif(lif);
@@ -151,9 +159,40 @@ static int ionic_lif_init(struct ionic_lif *lif)
 
 	lif->hw_index = le16_to_cpu(comp.hw_index);
 
+	/* now that we have the hw_index we can figure out our doorbell page */
+	lif->dbid_count = le32_to_cpu(lif->ionic->ident.dev.ndbpgs_per_lif);
+	if (!lif->dbid_count) {
+		dev_err(dev, "No doorbell pages, aborting\n");
+		return -EINVAL;
+	}
+
+	lif->dbid_inuse = bitmap_alloc(lif->dbid_count, GFP_KERNEL);
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
 	set_bit(IONIC_LIF_INITED, lif->state);
 
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
index fff4fc287b89..ec8d06ad4192 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -23,6 +23,8 @@ struct ionic_lif {
 	bool registered;
 	unsigned int index;
 	unsigned int hw_index;
+	unsigned int kern_pid;
+	u64 __iomem *kern_dbpage;
 	unsigned int neqs;
 	unsigned int nxqs;
 
@@ -30,6 +32,8 @@ struct ionic_lif {
 	dma_addr_t info_pa;
 	u32 info_sz;
 
+	unsigned long *dbid_inuse;
+	unsigned int dbid_count;
 	struct dentry *dentry;
 	u32 flags;
 };
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_regs.h b/drivers/net/ethernet/pensando/ionic/ionic_regs.h
index 3523915061ed..03ee5a36472b 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_regs.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_regs.h
@@ -22,6 +22,9 @@ struct ionic_intr {
 	u32 rsvd[3];
 };
 
+#define IONIC_INTR_CTRL_REGS_MAX	2048
+#define IONIC_INTR_CTRL_COAL_MAX	0x3F
+
 /** enum ionic_intr_mask_vals - valid values for mask and mask_assert.
  * @IONIC_INTR_MASK_CLEAR:	unmask interrupt.
  * @IONIC_INTR_MASK_SET:	mask interrupt.
-- 
2.17.1

