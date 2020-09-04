Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DED4225CEB1
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 02:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729502AbgIDAFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 20:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728311AbgIDAFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 20:05:47 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D36DC061244
        for <netdev@vger.kernel.org>; Thu,  3 Sep 2020 17:05:46 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id z15so294757plo.7
        for <netdev@vger.kernel.org>; Thu, 03 Sep 2020 17:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=hv8U5wBBTOc7Jh8QmR2U7H36mn4gsQ30N/sRp+7pWtg=;
        b=I99DabDSHicBfHJSmrP+wKE2dJ/ftLUTxQHkVqyG30HNsd/HaI6n1fK4bunEaY2fr8
         Dz4EaAtQ4XRWeQ8orV4juEXOBn0GGGBA09MBEDXUL5dWS064A3k+W/K1se1nYdeY6o57
         a/By5L1JvjZvEgvjzA9JhNwSQIFuu2OC9zUDQzjdy3L3SJdisWVFb/R43ap6J6LlSYM9
         5MWjiJqSPSieWtNTmdG65EHNXyhQVb5H80e2HYb/VnlO/MmuC4HR3obW39+TGV68RC4r
         3y60AR8AajN9TuIdpXgyqoLheaIO0Dlv9CHYA29tz0Mqg4loAhhck0Fgqqpxn1OqoZW9
         szCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=hv8U5wBBTOc7Jh8QmR2U7H36mn4gsQ30N/sRp+7pWtg=;
        b=mN0LvIKilM2cQ3lwa9wHkWxSNnpsc8LtNzAOq0ByOy9P6Qu2ta/rFF5Df9luiVc0nr
         gXq2gogNf9p4JEADUNtSUYOYRlE+2ZXpg7t3yBqigurgaH4J+4FnPT2P25vIg4MeyocA
         JwPQYYXGKPwdeM+wMgyhClccZb7tl/0DyK41Hm2kUX3wGx8NF4NOz2/w9o/NneMWewIu
         xh3zyBR0dfRqxzuw8axHIpslM2op4O8gHWvGkZvIs+kCJDT8RaMeWfQHpQeY5nrzj81u
         l7pDoGrhD907rhmhfhwlIiC8ppE6bjkWEnQqbVKDTL76CHUIxirhPw0rcOK2eokAUjMT
         /PfA==
X-Gm-Message-State: AOAM531p+FB3pDFUNhx15r53lOP5UVWLzHu86DKsLnqhtwutWoVyLaTE
        /8bABl5up95d8OhVl4A+NAIrG2NNGyLZYg==
X-Google-Smtp-Source: ABdhPJwNf4y8mocdBxvV4jdATdL43B0TwtNLqewOWVCHJbsdOghum8tPF586Sd+8Gp0PIeyHagCkVQ==
X-Received: by 2002:a17:90a:cd06:: with SMTP id d6mr5347539pju.202.1599177945066;
        Thu, 03 Sep 2020 17:05:45 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id w5sm3924602pgk.20.2020.09.03.17.05.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Sep 2020 17:05:44 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 2/2] ionic: add devlink firmware update
Date:   Thu,  3 Sep 2020 17:05:34 -0700
Message-Id: <20200904000534.58052-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200904000534.58052-1-snelson@pensando.io>
References: <20200904000534.58052-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for firmware update through the devlink interface.
This update copies the firmware object into the device, asks
the current firmware to install it, then asks the firmware to
select the new firmware for the next boot-up.

The install and select steps are launched as asynchronous
requests, which are then followed up with status request
commands.  These status request commands will be answered with
an EAGAIN return value and will try again until the request
has completed or reached the timeout specified.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/Makefile  |   2 +-
 .../ethernet/pensando/ionic/ionic_devlink.c   |  14 ++
 .../ethernet/pensando/ionic/ionic_devlink.h   |   3 +
 .../net/ethernet/pensando/ionic/ionic_fw.c    | 195 ++++++++++++++++++
 .../net/ethernet/pensando/ionic/ionic_main.c  |  13 +-
 5 files changed, 222 insertions(+), 5 deletions(-)
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_fw.c

diff --git a/drivers/net/ethernet/pensando/ionic/Makefile b/drivers/net/ethernet/pensando/ionic/Makefile
index 29f304d75261..8d3c2d3cb10d 100644
--- a/drivers/net/ethernet/pensando/ionic/Makefile
+++ b/drivers/net/ethernet/pensando/ionic/Makefile
@@ -5,4 +5,4 @@ obj-$(CONFIG_IONIC) := ionic.o
 
 ionic-y := ionic_main.o ionic_bus_pci.o ionic_devlink.o ionic_dev.o \
 	   ionic_debugfs.o ionic_lif.o ionic_rx_filter.o ionic_ethtool.o \
-	   ionic_txrx.o ionic_stats.o
+	   ionic_txrx.o ionic_stats.o ionic_fw.o
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
index 8d9fb2e19cca..5348f05ebc32 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
@@ -9,6 +9,19 @@
 #include "ionic_lif.h"
 #include "ionic_devlink.h"
 
+static int ionic_dl_flash_update(struct devlink *dl,
+				 const char *fwname,
+				 const char *component,
+				 struct netlink_ext_ack *extack)
+{
+	struct ionic *ionic = devlink_priv(dl);
+
+	if (component)
+		return -EOPNOTSUPP;
+
+	return ionic_firmware_update(ionic->lif, fwname, extack);
+}
+
 static int ionic_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 			     struct netlink_ext_ack *extack)
 {
@@ -48,6 +61,7 @@ static int ionic_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 
 static const struct devlink_ops ionic_dl_ops = {
 	.info_get	= ionic_dl_info_get,
+	.flash_update	= ionic_dl_flash_update,
 };
 
 struct ionic *ionic_devlink_alloc(struct device *dev)
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.h b/drivers/net/ethernet/pensando/ionic/ionic_devlink.h
index 0690172fc57a..5c01a9e306d8 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_devlink.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.h
@@ -6,6 +6,9 @@
 
 #include <net/devlink.h>
 
+int ionic_firmware_update(struct ionic_lif *lif, const char *fw_name,
+			  struct netlink_ext_ack *extack);
+
 struct ionic *ionic_devlink_alloc(struct device *dev);
 void ionic_devlink_free(struct ionic *ionic);
 int ionic_devlink_register(struct ionic *ionic);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_fw.c b/drivers/net/ethernet/pensando/ionic/ionic_fw.c
new file mode 100644
index 000000000000..e8886893227a
--- /dev/null
+++ b/drivers/net/ethernet/pensando/ionic/ionic_fw.c
@@ -0,0 +1,195 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2020 Pensando Systems, Inc */
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/firmware.h>
+
+#include "ionic.h"
+#include "ionic_dev.h"
+#include "ionic_lif.h"
+#include "ionic_devlink.h"
+
+/* The worst case wait for the install activity is about 25 minutes when
+ * installing a new CPLD, which is very seldom.  Normal is about 30-35
+ * seconds.  Since the driver can't tell if a CPLD update will happen we
+ * set the timeout for the ugly case.
+ */
+#define IONIC_FW_INSTALL_TIMEOUT	(25 * 60)
+#define IONIC_FW_ACTIVATE_TIMEOUT	30
+
+/* Number of periodic log updates during fw file download */
+#define IONIC_FW_INTERVAL_FRACTION	32
+
+static void ionic_dev_cmd_firmware_download(struct ionic_dev *idev, u64 addr,
+					    u32 offset, u32 length)
+{
+	union ionic_dev_cmd cmd = {
+		.fw_download.opcode = IONIC_CMD_FW_DOWNLOAD,
+		.fw_download.offset = offset,
+		.fw_download.addr = addr,
+		.fw_download.length = length
+	};
+
+	ionic_dev_cmd_go(idev, &cmd);
+}
+
+static void ionic_dev_cmd_firmware_install(struct ionic_dev *idev)
+{
+	union ionic_dev_cmd cmd = {
+		.fw_control.opcode = IONIC_CMD_FW_CONTROL,
+		.fw_control.oper = IONIC_FW_INSTALL_ASYNC
+	};
+
+	ionic_dev_cmd_go(idev, &cmd);
+}
+
+static void ionic_dev_cmd_firmware_install_status(struct ionic_dev *idev)
+{
+	union ionic_dev_cmd cmd = {
+		.fw_control.opcode = IONIC_CMD_FW_CONTROL,
+		.fw_control.oper = IONIC_FW_INSTALL_STATUS
+	};
+
+	ionic_dev_cmd_go(idev, &cmd);
+}
+
+static void ionic_dev_cmd_firmware_activate(struct ionic_dev *idev, u8 slot)
+{
+	union ionic_dev_cmd cmd = {
+		.fw_control.opcode = IONIC_CMD_FW_CONTROL,
+		.fw_control.oper = IONIC_FW_ACTIVATE_ASYNC,
+		.fw_control.slot = slot
+	};
+
+	ionic_dev_cmd_go(idev, &cmd);
+}
+
+static void ionic_dev_cmd_firmware_activate_status(struct ionic_dev *idev)
+{
+	union ionic_dev_cmd cmd = {
+		.fw_control.opcode = IONIC_CMD_FW_CONTROL,
+		.fw_control.oper = IONIC_FW_ACTIVATE_STATUS,
+	};
+
+	ionic_dev_cmd_go(idev, &cmd);
+}
+
+int ionic_firmware_update(struct ionic_lif *lif, const char *fw_name,
+			  struct netlink_ext_ack *extack)
+{
+	struct ionic_dev *idev = &lif->ionic->idev;
+	struct net_device *netdev = lif->netdev;
+	struct ionic *ionic = lif->ionic;
+	union ionic_dev_cmd_comp comp;
+	u32 buf_sz, copy_sz, offset;
+	const struct firmware *fw;
+	struct devlink *dl;
+	int next_interval;
+	int err = 0;
+	u8 fw_slot;
+
+	netdev_info(netdev, "Installing firmware %s\n", fw_name);
+
+	dl = priv_to_devlink(ionic);
+	devlink_flash_update_begin_notify(dl);
+	devlink_flash_update_status_notify(dl, "Preparing to flash", NULL, 0, 0);
+
+	err = request_firmware(&fw, fw_name, ionic->dev);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Unable to find firmware file");
+		goto err_out;
+	}
+
+	buf_sz = sizeof(idev->dev_cmd_regs->data);
+
+	netdev_dbg(netdev,
+		   "downloading firmware - size %d part_sz %d nparts %lu\n",
+		   (int)fw->size, buf_sz, DIV_ROUND_UP(fw->size, buf_sz));
+
+	devlink_flash_update_status_notify(dl, "Downloading", NULL, 0, fw->size);
+	offset = 0;
+	next_interval = fw->size / IONIC_FW_INTERVAL_FRACTION;
+	while (offset < fw->size) {
+		copy_sz = min_t(unsigned int, buf_sz, fw->size - offset);
+		mutex_lock(&ionic->dev_cmd_lock);
+		memcpy_toio(&idev->dev_cmd_regs->data, fw->data + offset, copy_sz);
+		ionic_dev_cmd_firmware_download(idev,
+						offsetof(union ionic_dev_cmd_regs, data),
+						offset, copy_sz);
+		err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
+		mutex_unlock(&ionic->dev_cmd_lock);
+		if (err) {
+			netdev_err(netdev,
+				   "download failed offset 0x%x addr 0x%lx len 0x%x\n",
+				   offset, offsetof(union ionic_dev_cmd_regs, data),
+				   copy_sz);
+			NL_SET_ERR_MSG_MOD(extack, "Segment download failed");
+			goto err_out;
+		}
+		offset += copy_sz;
+
+		if (offset > next_interval) {
+			devlink_flash_update_status_notify(dl, "Downloading",
+							   NULL, offset, fw->size);
+			next_interval = offset + (fw->size / IONIC_FW_INTERVAL_FRACTION);
+		}
+	}
+	devlink_flash_update_status_notify(dl, "Downloading", NULL, 1, 1);
+
+	devlink_flash_update_status_notify(dl, "Installing", NULL, 0, 2);
+
+	mutex_lock(&ionic->dev_cmd_lock);
+	ionic_dev_cmd_firmware_install(idev);
+	err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
+	ionic_dev_cmd_comp(idev, (union ionic_dev_cmd_comp *)&comp);
+	fw_slot = comp.fw_control.slot;
+	mutex_unlock(&ionic->dev_cmd_lock);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to start firmware install");
+		goto err_out;
+	}
+
+	devlink_flash_update_status_notify(dl, "Installing", NULL, 1, 2);
+	mutex_lock(&ionic->dev_cmd_lock);
+	ionic_dev_cmd_firmware_install_status(idev);
+	err = ionic_dev_cmd_wait(ionic, IONIC_FW_INSTALL_TIMEOUT);
+	mutex_unlock(&ionic->dev_cmd_lock);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Firmware install failed");
+		goto err_out;
+	}
+	devlink_flash_update_status_notify(dl, "Installing", NULL, 2, 2);
+
+	devlink_flash_update_status_notify(dl, "Selecting", NULL, 0, 2);
+
+	mutex_lock(&ionic->dev_cmd_lock);
+	ionic_dev_cmd_firmware_activate(idev, fw_slot);
+	err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
+	mutex_unlock(&ionic->dev_cmd_lock);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to start firmware select");
+		goto err_out;
+	}
+
+	devlink_flash_update_status_notify(dl, "Selecting", NULL, 1, 2);
+	mutex_lock(&ionic->dev_cmd_lock);
+	ionic_dev_cmd_firmware_activate_status(idev);
+	err = ionic_dev_cmd_wait(ionic, IONIC_FW_ACTIVATE_TIMEOUT);
+	mutex_unlock(&ionic->dev_cmd_lock);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Firmware select failed");
+		goto err_out;
+	}
+	devlink_flash_update_status_notify(dl, "Selecting", NULL, 2, 2);
+
+	netdev_info(netdev, "Firmware update completed\n");
+
+err_out:
+	if (err)
+		devlink_flash_update_status_notify(dl, "Flash failed", NULL, 0, 0);
+	release_firmware(fw);
+	devlink_flash_update_end_notify(dl);
+	return err;
+}
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index f1fd9a98ae4a..4b4ff885ebf8 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -361,17 +361,22 @@ int ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_seconds)
 	 */
 	max_wait = jiffies + (max_seconds * HZ);
 try_again:
+	opcode = idev->dev_cmd_regs->cmd.cmd.opcode;
 	start_time = jiffies;
 	do {
 		done = ionic_dev_cmd_done(idev);
 		if (done)
 			break;
-		msleep(5);
-		hb = ionic_heartbeat_check(ionic);
+		usleep_range(100, 200);
+
+		/* Don't check the heartbeat on FW_CONTROL commands as they are
+		 * notorious for interrupting the firmware's heartbeat update.
+		 */
+		if (opcode != IONIC_CMD_FW_CONTROL)
+			hb = ionic_heartbeat_check(ionic);
 	} while (!done && !hb && time_before(jiffies, max_wait));
 	duration = jiffies - start_time;
 
-	opcode = idev->dev_cmd_regs->cmd.cmd.opcode;
 	dev_dbg(ionic->dev, "DEVCMD %s (%d) done=%d took %ld secs (%ld jiffies)\n",
 		ionic_opcode_to_str(opcode), opcode,
 		done, duration / HZ, duration);
@@ -396,7 +401,7 @@ int ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_seconds)
 	err = ionic_dev_cmd_status(&ionic->idev);
 	if (err) {
 		if (err == IONIC_RC_EAGAIN && !time_after(jiffies, max_wait)) {
-			dev_err(ionic->dev, "DEV_CMD %s (%d) error, %s (%d) retrying...\n",
+			dev_dbg(ionic->dev, "DEV_CMD %s (%d), %s (%d) retrying...\n",
 				ionic_opcode_to_str(opcode), opcode,
 				ionic_error_to_str(err), err);
 
-- 
2.17.1

