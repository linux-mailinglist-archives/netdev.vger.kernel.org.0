Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACC05A678
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 23:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbfF1VkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 17:40:06 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40967 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726935AbfF1VkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 17:40:03 -0400
Received: by mail-pg1-f196.google.com with SMTP id q4so1664192pgj.8
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 14:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=B35SvTbt4vFaptzLN7UPZKP32uvlwGziDVph7pzqZaA=;
        b=a5LKbxQNfTbeEK+TDXp1mTB5L6M5uBHotm2CRq8lm25tqdWw2N+245RuAQL0BsMdcQ
         bNG3niGvbVkP0b9yKd6eWmWawGnLu44Ld+kVvNMzvsOTszTAZvCehxU9WjicZua5KF1D
         Q3n2Fvgxy0OhMhkIkvaRdfjalsaHQ605kfvsoxhjqvhx8k4izDL63pkE5u5BO4YCOYz/
         VP01dVlF5mgTcGiHnHO0mkIv/IjJTXOOiTMMQ6oIPEJvyo7q5jerYpLB8shSeiM8X3fR
         lXtwbBrpdI8WkvFPH83+VGEW4pTcdLUZ1uO1aZ0lTQRsmU7wL5hIH/D/hVstYDXUyCTt
         koXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=B35SvTbt4vFaptzLN7UPZKP32uvlwGziDVph7pzqZaA=;
        b=lebCwvN0hbbPSv6LR1ehJbLEmRyZ/5sJ15Fj+ibti++aDql8Eb+mGNk45jWQUFcAU0
         SF0yjyiR5lSDMR4N8sDEujY8O9nzfb1n9nnzJ5reqfLoXwrMsE/v/BveNj0xyjSrsYTT
         D6eLfZyj7tJXSe9CFeITHAdsHMAOcpWLWxL0s+NJqzgWLo4BLM16d5GUqIuJEYs9XO4D
         ivyl72y9Nq8Er6dw7ofoEbOoY4TSBHiL86KrEUfgOU9YlVYfCju4IAXWKHscwnMZov+r
         en6LHyqG0hrSXWq7ZlMd8s5u4o8kkbZuJWtm+BIlR+3eA16UecLeCOaUOtntOcWl38bZ
         A0TQ==
X-Gm-Message-State: APjAAAXBhwGFSTVrqPd6XslaFyKGCjDy2Vhh0SnW6TJIuHO6DR3C5GSc
        xctwB9lg5bCZElsNA/e+cHDkneqWJ2A=
X-Google-Smtp-Source: APXvYqxryBRj5Ffs5sfoojwEZiG+69GozqBW2wajcA3i+oxPIQS6v0CLD2Cn75h0iIqZoDhg9IdgtA==
X-Received: by 2002:a17:90a:26ea:: with SMTP id m97mr5673230pje.59.1561758002769;
        Fri, 28 Jun 2019 14:40:02 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id 135sm3516920pfb.137.2019.06.28.14.40.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Jun 2019 14:40:02 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org
Subject: [PATCH v2 net-next 19/19] ionic: Add basic devlink interface
Date:   Fri, 28 Jun 2019 14:39:34 -0700
Message-Id: <20190628213934.8810-20-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190628213934.8810-1-snelson@pensando.io>
References: <20190628213934.8810-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a devlink interface for access to information that isn't
normally available through ethtool or the iplink interface.

Example:
	$ ./devlink -j -p dev info pci/0000:b6:00.0
	{
	    "info": {
		"pci/0000:b6:00.0": {
		    "driver": "ionic",
		    "serial_number": "FLM18420073",
		    "versions": {
			"fixed": {
			    "fw_version": "0.11.0-50",
			    "fw_status": "0x1",
			    "fw_heartbeat": "0x716ce",
			    "asic_type": "0x0",
			    "asic_rev": "0x0"
			}
		    }
		}
	    }
	}

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/Makefile  |  2 +-
 drivers/net/ethernet/pensando/ionic/ionic.h   |  1 +
 .../ethernet/pensando/ionic/ionic_bus_pci.c   |  7 ++
 .../ethernet/pensando/ionic/ionic_devlink.c   | 89 +++++++++++++++++++
 .../ethernet/pensando/ionic/ionic_devlink.h   | 12 +++
 5 files changed, 110 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_devlink.c
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_devlink.h

diff --git a/drivers/net/ethernet/pensando/ionic/Makefile b/drivers/net/ethernet/pensando/ionic/Makefile
index 4f3cfbf36c23..ce187c7b33a8 100644
--- a/drivers/net/ethernet/pensando/ionic/Makefile
+++ b/drivers/net/ethernet/pensando/ionic/Makefile
@@ -5,4 +5,4 @@ obj-$(CONFIG_IONIC) := ionic.o
 
 ionic-y := ionic_main.o ionic_bus_pci.o ionic_dev.o ionic_ethtool.o \
 	   ionic_lif.o ionic_rx_filter.o ionic_txrx.o ionic_debugfs.o \
-	   ionic_stats.o
+	   ionic_stats.o ionic_devlink.o
diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
index cd08166f73a9..a0034bc5b4a1 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -44,6 +44,7 @@ struct ionic {
 	DECLARE_BITMAP(intrs, INTR_CTRL_REGS_MAX);
 	struct work_struct nb_work;
 	struct notifier_block nb;
+	struct devlink *dl;
 };
 
 struct ionic_admin_ctx {
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index 98c12b770c7f..a8c99254489f 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -10,6 +10,7 @@
 #include "ionic_bus.h"
 #include "ionic_lif.h"
 #include "ionic_debugfs.h"
+#include "ionic_devlink.h"
 
 /* Supported devices */
 static const struct pci_device_id ionic_id_table[] = {
@@ -212,9 +213,14 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_out_deinit_lifs;
 	}
 
+	err = ionic_devlink_register(ionic);
+	if (err)
+		dev_err(dev, "Cannot register devlink (ignored): %d\n", err);
+
 	return 0;
 
 err_out_deinit_lifs:
+	ionic_devlink_unregister(ionic);
 	ionic_lifs_deinit(ionic);
 err_out_free_lifs:
 	ionic_lifs_free(ionic);
@@ -247,6 +253,7 @@ static void ionic_remove(struct pci_dev *pdev)
 	struct ionic *ionic = pci_get_drvdata(pdev);
 
 	if (ionic) {
+		ionic_devlink_unregister(ionic);
 		ionic_lifs_unregister(ionic);
 		ionic_lifs_deinit(ionic);
 		ionic_lifs_free(ionic);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
new file mode 100644
index 000000000000..fbbfcdde292f
--- /dev/null
+++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
@@ -0,0 +1,89 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2017 - 2019 Pensando Systems, Inc */
+
+#include <linux/module.h>
+#include <linux/netdevice.h>
+
+#include "ionic.h"
+#include "ionic_bus.h"
+#include "ionic_lif.h"
+#include "ionic_devlink.h"
+
+struct ionic_devlink {
+	struct ionic *ionic;
+};
+
+static int ionic_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
+			     struct netlink_ext_ack *extack)
+{
+	struct ionic *ionic = *(struct ionic **)devlink_priv(dl);
+	struct ionic_dev *idev = &ionic->idev;
+	char buf[16];
+	u32 val;
+
+	devlink_info_driver_name_put(req, DRV_NAME);
+
+	devlink_info_version_fixed_put(req, "fw_version",
+				       idev->dev_info.fw_version);
+
+	val = ioread8(&idev->dev_info_regs->fw_status);
+	snprintf(buf, sizeof(buf), "0x%x", val);
+	devlink_info_version_fixed_put(req, "fw_status", buf);
+
+	val = ioread32(&idev->dev_info_regs->fw_heartbeat);
+	snprintf(buf, sizeof(buf), "0x%x", val);
+	devlink_info_version_fixed_put(req, "fw_heartbeat", buf);
+
+	snprintf(buf, sizeof(buf), "0x%x", idev->dev_info.asic_type);
+	devlink_info_version_fixed_put(req, "asic_type", buf);
+
+	snprintf(buf, sizeof(buf), "0x%x", idev->dev_info.asic_rev);
+	devlink_info_version_fixed_put(req, "asic_rev", buf);
+
+	devlink_info_serial_number_put(req, idev->dev_info.serial_num);
+
+	return 0;
+}
+
+static const struct devlink_ops ionic_dl_ops = {
+	.info_get	= ionic_dl_info_get,
+};
+
+int ionic_devlink_register(struct ionic *ionic)
+{
+	struct devlink *dl;
+	struct ionic **ip;
+	int err;
+
+	dl = devlink_alloc(&ionic_dl_ops, sizeof(struct ionic *));
+	if (!dl) {
+		dev_warn(ionic->dev, "devlink_alloc failed");
+		return -ENOMEM;
+	}
+
+	ip = (struct ionic **)devlink_priv(dl);
+	*ip = ionic;
+	ionic->dl = dl;
+
+	err = devlink_register(dl, ionic->dev);
+	if (err) {
+		dev_warn(ionic->dev, "devlink_register failed: %d\n", err);
+		goto err_dl_free;
+	}
+
+	return 0;
+
+err_dl_free:
+	ionic->dl = NULL;
+	devlink_free(dl);
+	return err;
+}
+
+void ionic_devlink_unregister(struct ionic *ionic)
+{
+	if (!ionic->dl)
+		return;
+
+	devlink_unregister(ionic->dl);
+	devlink_free(ionic->dl);
+}
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.h b/drivers/net/ethernet/pensando/ionic/ionic_devlink.h
new file mode 100644
index 000000000000..35528884e29f
--- /dev/null
+++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2017 - 2019 Pensando Systems, Inc */
+
+#ifndef _IONIC_DEVLINK_H_
+#define _IONIC_DEVLINK_H_
+
+#include <net/devlink.h>
+
+int ionic_devlink_register(struct ionic *ionic);
+void ionic_devlink_unregister(struct ionic *ionic);
+
+#endif /* _IONIC_DEVLINK_H_ */
-- 
2.17.1

