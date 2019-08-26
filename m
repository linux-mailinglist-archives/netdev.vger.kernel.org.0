Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A542B9D87D
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 23:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729125AbfHZVd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 17:33:56 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44881 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729099AbfHZVdz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 17:33:55 -0400
Received: by mail-pl1-f194.google.com with SMTP id t14so10650134plr.11
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 14:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=EoossrAr1R9yzQV+ZbfuEZwpu/wlD13JL3KWzxoqSSI=;
        b=viW9ko42cSh8Z0crpsaA2bwVJdRdz9nD2ktOwk9kWAflLVZcwc4PfAgmglG+t0y7GR
         Gj/1hFncE4evti6KpfYoXUsE4YVWht2IA9ATs0xj1HzeuuUJQ7sVkmCi/Fnkq1la2/Ok
         AipcJjJkEz69evGaE4xLxxCqOuTtaOOWWYXKRTWZSSxJ7NLnh1PysNkQZwIiMkxrDyPW
         lswjiZTjyFVuyQkFfJ8s07oZYSvQNPwFwLM4ugvarrdUpdBw43M4arVlUWrqmSQZyBbF
         73DDveFZjGUbnrETwJZB/upXs9CUsV/AP+39weAUO5z2naYdJ+VxR+j5hW3/erz4/y7a
         WQrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=EoossrAr1R9yzQV+ZbfuEZwpu/wlD13JL3KWzxoqSSI=;
        b=QYz8cwvHWKnoTFriDJtT5vMoVToakIqZ85JH2NdfpfHJXW8W+k95bTsG98QhGBHbMP
         NLJicaRQuizTO8RjdYEdmzx9gV5GHSCqxUG5JpiqpvkS9rcd2geir2qlKWwFAhFKePHR
         f1GoBIXgwk7N5C11u86OfpqT9gBmxOhqgo3hQLuQmMeaLdS2h7GMqn+4BI6C9Q5AtJQk
         MJItonMJQU3VQSta98tx/cauSH0tTc/ebB1KRlqOC4TTRNuxA8lG4Fmq52BNd5Dcqxc5
         rro2RDo6XVOQLhkf4ilwf8++O9hfJm43NBnLNr7nuI/PFJ74suNIrW+8U7/6yy+Yc+JC
         3GOg==
X-Gm-Message-State: APjAAAWo/hfmObneet5+XdpCFaawkCN/WWEWK3JwfeQzu7pNXpV8d2F5
        2PDkfnG7qWt7GR9rtgVJJwAag/SXbYU=
X-Google-Smtp-Source: APXvYqwOaZ//+H1GblXScm+HH7Jthe10G0Rsv7+8sRMsdwCvtG29TwlfmuhjpQotfj6+rhACbLDHyw==
X-Received: by 2002:a17:902:d898:: with SMTP id b24mr9186194plz.7.1566855234615;
        Mon, 26 Aug 2019 14:33:54 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id j9sm5876905pfi.128.2019.08.26.14.33.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Aug 2019 14:33:54 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH v5 net-next 05/18] ionic: Add interrupts and doorbells
Date:   Mon, 26 Aug 2019 14:33:26 -0700
Message-Id: <20190826213339.56909-6-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190826213339.56909-1-snelson@pensando.io>
References: <20190826213339.56909-1-snelson@pensando.io>
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
index 82f0d8868379..7b4d9ff4721f 100644
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
@@ -41,6 +43,7 @@ struct ionic {
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
index 11c1ab599b88..26a2142252dd 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -9,6 +9,7 @@
 #include <linux/etherdevice.h>
 #include "ionic.h"
 #include "ionic_dev.h"
+#include "ionic_lif.h"
 
 void ionic_init_devinfo(struct ionic *ionic)
 {
@@ -284,3 +285,8 @@ void ionic_dev_cmd_lif_reset(struct ionic_dev *idev, u16 lif_index)
 
 	ionic_dev_cmd_go(idev, &cmd);
 }
+
+int ionic_db_page_num(struct ionic_lif *lif, int pid)
+{
+	return (lif->hw_index * lif->dbid_count) + pid;
+}
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index 1afd53bf3e23..a69d8359eead 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -131,8 +131,28 @@ struct ionic_dev {
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
@@ -162,4 +182,6 @@ void ionic_dev_cmd_lif_init(struct ionic_dev *idev, u16 lif_index,
 			    dma_addr_t addr);
 void ionic_dev_cmd_lif_reset(struct ionic_dev *idev, u16 lif_index);
 
+int ionic_db_page_num(struct ionic_lif *lif, int pid);
+
 #endif /* _IONIC_DEV_H_ */
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 6044dc4062c2..88effa739c70 100644
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
index cc6f907b30db..d96d350bcfd0 100644
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

