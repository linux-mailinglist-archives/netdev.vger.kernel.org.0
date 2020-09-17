Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABF3326D16E
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 05:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbgIQDIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 23:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbgIQDIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 23:08:01 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24BDBC06121E
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 20:02:20 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id x123so297719pfc.7
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 20:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Z/biRr2gfnCnTs7yX/rFy/CA+d7qiqpvAKA568Ikjq4=;
        b=us5wky7nYPlCS8JnVe2CS4s/1mqlw1Nr8VM0vA3Xws4Zk/UxdMjn64QVifi/54Nc3U
         2YhAR9jOeYAa2sA+nKWfZ+y2RvnVE462HtIBQBoHBJ2zUJ8NF2BswZ0jE3+a6AtiOAC/
         MDKkM6unjTANPh8RmTcu2BrC1e5eHjhKyxjOt2eNtHd3OZYSmHs9eOh2RTaejlD7dGOG
         rK1eG86f8c/J8htDhGDx1sdXcDAuSopb2e0cAes3q4tkFPQ5XGYwpwNy70GCl7W8lJXg
         vrVDfw/s96zjJgAACX22n6m0zF6oH9+bAJPw5DcfPH60XqfwfXRnAIfRe2dAo0UN2y7k
         V4jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Z/biRr2gfnCnTs7yX/rFy/CA+d7qiqpvAKA568Ikjq4=;
        b=QFQIqUz6LJqcwvO/9W6j1jTygMghq68Z/U8KnS1DksD6eOtMnwoqA4pFmftmlJFPBo
         SJ8664aRcBC+NFSEjiXqLq+ekpCM4mn2SuW4T3imxroV4G9MNHjVi5zJKSQDR6GWuMKC
         dW3L7Hz2JZiQcxNTHMKQ3HCSx4QEoysAYsP/wXVN09gjez/k2Zo0hTX2CDxSh21bVNPa
         eEdXw0bZArrXUqgVHJIoX7EXDC7XSXYXpvb8Pr25lnA6lnQmc4QQLKtplNLKxcyIJvZq
         jitNWzFOkuhyYtFYbOX2TDRg4v6Uiwmt3jG2Il4zNcaBNOJh1fGfHaBAY390RTwc8bIB
         0uqg==
X-Gm-Message-State: AOAM530fQUmR5SPlcRHzqslyFXWoM5UY2UgeogZyzifL2eZ52SAlDefu
        QK1gssdfYrE1OZ26HzpjJ3qpAA6s+yu6PQ==
X-Google-Smtp-Source: ABdhPJxKAQri0T7+B6WmE9pFKT09Z3BH5zILZE2KW8E4M6owbLMak7cnpQ0sH45Mn9kFhh4Qorc2uA==
X-Received: by 2002:a63:d841:: with SMTP id k1mr4213641pgj.59.1600311739133;
        Wed, 16 Sep 2020 20:02:19 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id b2sm12072498pfp.3.2020.09.16.20.02.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Sep 2020 20:02:18 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v4 net-next 5/5] ionic: add devlink firmware update
Date:   Wed, 16 Sep 2020 20:02:04 -0700
Message-Id: <20200917030204.50098-6-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200917030204.50098-1-snelson@pensando.io>
References: <20200917030204.50098-1-snelson@pensando.io>
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
 .../net/ethernet/pensando/ionic/ionic_fw.c    | 206 ++++++++++++++++++
 .../net/ethernet/pensando/ionic/ionic_main.c  |  23 +-
 5 files changed, 239 insertions(+), 9 deletions(-)
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
index 000000000000..f492ae406a60
--- /dev/null
+++ b/drivers/net/ethernet/pensando/ionic/ionic_fw.c
@@ -0,0 +1,206 @@
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
+#define IONIC_FW_SELECT_TIMEOUT		30
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
+static int ionic_fw_status_long_wait(struct ionic *ionic,
+				     const char *label,
+				     unsigned long timeout,
+				     u8 fw_cmd,
+				     struct netlink_ext_ack *extack)
+{
+	union ionic_dev_cmd cmd = {
+		.fw_control.opcode = IONIC_CMD_FW_CONTROL,
+		.fw_control.oper = fw_cmd,
+	};
+	unsigned long start_time;
+	unsigned long end_time;
+	int err;
+
+	start_time = jiffies;
+	end_time = start_time + (timeout * HZ);
+	do {
+		mutex_lock(&ionic->dev_cmd_lock);
+		ionic_dev_cmd_go(&ionic->idev, &cmd);
+		err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
+		mutex_unlock(&ionic->dev_cmd_lock);
+
+		msleep(20);
+	} while (time_before(jiffies, end_time) && (err == -EAGAIN || err == -ETIMEDOUT));
+
+	if (err == -EAGAIN || err == -ETIMEDOUT) {
+		NL_SET_ERR_MSG_MOD(extack, "Firmware wait timed out");
+		dev_err(ionic->dev, "DEV_CMD firmware wait %s timed out\n", label);
+	} else if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Firmware wait failed");
+	}
+
+	return err;
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
+	offset = 0;
+	next_interval = 0;
+	while (offset < fw->size) {
+		if (offset >= next_interval) {
+			devlink_flash_update_status_notify(dl, "Downloading", NULL,
+							   offset, fw->size);
+			next_interval = offset + (fw->size / IONIC_FW_INTERVAL_FRACTION);
+		}
+
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
+	}
+	devlink_flash_update_status_notify(dl, "Downloading", NULL,
+					   fw->size, fw->size);
+
+	devlink_flash_update_timeout_notify(dl, "Installing", NULL,
+					    IONIC_FW_INSTALL_TIMEOUT);
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
+	err = ionic_fw_status_long_wait(ionic, "Installing",
+					IONIC_FW_INSTALL_TIMEOUT,
+					IONIC_FW_INSTALL_STATUS,
+					extack);
+	if (err)
+		goto err_out;
+
+	devlink_flash_update_timeout_notify(dl, "Selecting", NULL,
+					    IONIC_FW_SELECT_TIMEOUT);
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
+	err = ionic_fw_status_long_wait(ionic, "Selecting",
+					IONIC_FW_SELECT_TIMEOUT,
+					IONIC_FW_ACTIVATE_STATUS,
+					extack);
+	if (err)
+		goto err_out;
+
+	netdev_info(netdev, "Firmware update completed\n");
+
+err_out:
+	if (err)
+		devlink_flash_update_status_notify(dl, "Flash failed", NULL, 0, 0);
+	else
+		devlink_flash_update_status_notify(dl, "Flash done", NULL, 0, 0);
+	release_firmware(fw);
+	devlink_flash_update_end_notify(dl);
+	return err;
+}
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 99e9dd15a303..e339216949a6 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -335,17 +335,22 @@ int ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_seconds)
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
@@ -369,8 +374,9 @@ int ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_seconds)
 
 	err = ionic_dev_cmd_status(&ionic->idev);
 	if (err) {
-		if (err == IONIC_RC_EAGAIN && !time_after(jiffies, max_wait)) {
-			dev_err(ionic->dev, "DEV_CMD %s (%d) error, %s (%d) retrying...\n",
+		if (err == IONIC_RC_EAGAIN &&
+		    time_before(jiffies, (max_wait - HZ))) {
+			dev_dbg(ionic->dev, "DEV_CMD %s (%d), %s (%d) retrying...\n",
 				ionic_opcode_to_str(opcode), opcode,
 				ionic_error_to_str(err), err);
 
@@ -380,9 +386,10 @@ int ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_seconds)
 			goto try_again;
 		}
 
-		dev_err(ionic->dev, "DEV_CMD %s (%d) error, %s (%d) failed\n",
-			ionic_opcode_to_str(opcode), opcode,
-			ionic_error_to_str(err), err);
+		if (!(opcode == IONIC_CMD_FW_CONTROL && err == IONIC_RC_EAGAIN))
+			dev_err(ionic->dev, "DEV_CMD %s (%d) error, %s (%d) failed\n",
+				ionic_opcode_to_str(opcode), opcode,
+				ionic_error_to_str(err), err);
 
 		return ionic_error_to_errno(err);
 	}
-- 
2.17.1

