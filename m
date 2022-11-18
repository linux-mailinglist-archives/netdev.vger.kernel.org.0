Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB046302AF
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 00:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbiKRXNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 18:13:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232912AbiKRXNF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 18:13:05 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9606CC143
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:57:44 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id v17so5825353plo.1
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:57:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=k/lEo1Gd6f9xRnFnxl6qFW1+wwzsbRLbnIq7hEq2cBA=;
        b=1Q+BofZq/rXhR9AnpQb7v+rhUnfT2AshA3mYx0cbUTA7DM9dx7dTjto7NXzpRB5PbR
         T2l6eXjJUv90m761PiCkSQ64x4Cx8kD4lZ6DCLJxMwZClTkDjztUxCYZutnx9NnEk/se
         sw+g4PWoAfhoFamXeeKlhAlII66+86PzblcvMnIgt1om35ehnOSbA5rPF4aLhzJFBzkh
         3WL68grAi8Y8b7P4vW9dLOJEoRVw2fGOOMgLbns+nZ2EpvUi0InlyY0xgpJM7Bo9fesM
         9/qV8i3lfViQoErYFcQxl6LGnV+hM8rQGZuhVZLS/s0VnrRDB1iaDogI2zhYht36hIOT
         yVTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k/lEo1Gd6f9xRnFnxl6qFW1+wwzsbRLbnIq7hEq2cBA=;
        b=uaMc30LPbA1eWt2OANd+8Fe+BgoL3nGxTHe0gyCLKSeCQRyCs0YM6Nn9o3EawOL9GV
         DuGiFVPwlA3vH+kMzqDvhQOMevrOCEsieyh+7Io40FAncS3TKgT6anWnWXN+2ffwoU5c
         F3wI12iMe/l8oPzcP6z0HgUN477nGBFg7MC1pEQ+gGODKirF/wmu5bXBfgG6kHZQOI5q
         ZuudWubOI3C7wzYjdRnp0DRBRdpeGV+GgjCjeudGLMth8qRY9CB5IPlKZvC4kCNNcQSm
         GRXx/gw4S6l0nr811X25zTWDYXHHXj8E23yArS0j59HlJbR2Q/hLarL5MCtsGkvuixzF
         S1cg==
X-Gm-Message-State: ANoB5pkX6SDgOjRs6AUjl60QYuclSrXwu5TT1VHI8E0FrXZHrI9j7dkf
        NKzfobiMm6IddNi9UqjYicqMyOEXGOjDdw==
X-Google-Smtp-Source: AA0mqf6DUU5O2oWUQzVBopglj0MpBqCqmYOkiTDY2MS4ebRwaYQ0sYxVQ5TfIhANWGGSTBmagJ01/A==
X-Received: by 2002:a17:902:b20f:b0:188:d4ea:251f with SMTP id t15-20020a170902b20f00b00188d4ea251fmr1642717plr.36.1668812240453;
        Fri, 18 Nov 2022 14:57:20 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id k89-20020a17090a3ee200b002005fcd2cb4sm6004818pjc.2.2022.11.18.14.57.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 14:57:19 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [RFC PATCH net-next 06/19] pds_core: add FW update feature to devlink
Date:   Fri, 18 Nov 2022 14:56:43 -0800
Message-Id: <20221118225656.48309-7-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221118225656.48309-1-snelson@pensando.io>
References: <20221118225656.48309-1-snelson@pensando.io>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add in the support for doing firmware updates, and for selecting
the next firmware image to boot on, and tie them into the
devlink flash and parameter handling.  The FW flash is the same
as in the ionic driver.  However, this device has the ability
to report what is in the firmware slots on the device and
allows you to select the slot to use on the next device boot.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/pds_core/Makefile   |   3 +-
 drivers/net/ethernet/pensando/pds_core/core.h |   8 +
 .../net/ethernet/pensando/pds_core/devlink.c  | 103 ++++++++++
 drivers/net/ethernet/pensando/pds_core/fw.c   | 192 ++++++++++++++++++
 4 files changed, 305 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/pensando/pds_core/fw.c

diff --git a/drivers/net/ethernet/pensando/pds_core/Makefile b/drivers/net/ethernet/pensando/pds_core/Makefile
index c7a722f7d9b8..06bd3da8c38b 100644
--- a/drivers/net/ethernet/pensando/pds_core/Makefile
+++ b/drivers/net/ethernet/pensando/pds_core/Makefile
@@ -7,6 +7,7 @@ pds_core-y := main.o \
 	      devlink.o \
 	      dev.o \
 	      adminq.o \
-	      core.o
+	      core.o \
+	      fw.o
 
 pds_core-$(CONFIG_DEBUG_FS) += debugfs.o
diff --git a/drivers/net/ethernet/pensando/pds_core/core.h b/drivers/net/ethernet/pensando/pds_core/core.h
index 87b221aa7b44..687e1debd079 100644
--- a/drivers/net/ethernet/pensando/pds_core/core.h
+++ b/drivers/net/ethernet/pensando/pds_core/core.h
@@ -123,6 +123,11 @@ struct pdsc_qcq {
 	struct dentry *dentry;
 };
 
+enum pdsc_devlink_param_id {
+	PDSC_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
+	PDSC_DEVLINK_PARAM_ID_FW_BOOT,
+};
+
 /* No state flags set means we are in a steady running state */
 enum pdsc_state_flags {
 	PDSC_S_FW_DEAD,		    /* fw stopped, waiting for startup or recovery */
@@ -287,4 +292,7 @@ void pdsc_process_adminq(struct pdsc_qcq *qcq);
 void pdsc_work_thread(struct work_struct *work);
 irqreturn_t pdsc_adminq_isr(int irq, void *data);
 
+int pdsc_firmware_update(struct pdsc *pdsc, const struct firmware *fw,
+			 struct netlink_ext_ack *extack);
+
 #endif /* _PDSC_H_ */
diff --git a/drivers/net/ethernet/pensando/pds_core/devlink.c b/drivers/net/ethernet/pensando/pds_core/devlink.c
index 42cf17229ace..0568e8b7391c 100644
--- a/drivers/net/ethernet/pensando/pds_core/devlink.c
+++ b/drivers/net/ethernet/pensando/pds_core/devlink.c
@@ -8,6 +8,100 @@
 
 #include "core.h"
 
+static char *slot_labels[] = { "fw.gold", "fw.mainfwa", "fw.mainfwb" };
+
+static int pdsc_dl_fw_boot_get(struct devlink *dl, u32 id,
+			       struct devlink_param_gset_ctx *ctx)
+{
+	struct pdsc *pdsc = devlink_priv(dl);
+	union pds_core_dev_cmd cmd = {
+		.fw_control.opcode = PDS_CORE_CMD_FW_CONTROL,
+		.fw_control.oper = PDS_CORE_FW_GET_BOOT,
+	};
+	union pds_core_dev_comp comp;
+	int err;
+
+	err = pdsc_devcmd(pdsc, &cmd, &comp, pdsc->devcmd_timeout);
+	if (err) {
+		if (err == -EIO) {
+			snprintf(ctx->val.vstr, sizeof(ctx->val.vstr), "(unknown)");
+			return 0;
+		} else {
+			return err;
+		}
+	}
+
+	if (comp.fw_control.slot >= ARRAY_SIZE(slot_labels))
+		snprintf(ctx->val.vstr, sizeof(ctx->val.vstr),
+			 "fw.slot%02d", comp.fw_control.slot);
+	else
+		snprintf(ctx->val.vstr, sizeof(ctx->val.vstr),
+			 "%s", slot_labels[comp.fw_control.slot]);
+
+	return 0;
+}
+
+static int pdsc_dl_fw_boot_set(struct devlink *dl, u32 id,
+			       struct devlink_param_gset_ctx *ctx)
+{
+	struct pdsc *pdsc = devlink_priv(dl);
+	union pds_core_dev_cmd cmd = {
+		.fw_control.opcode = PDS_CORE_CMD_FW_CONTROL,
+		.fw_control.oper = PDS_CORE_FW_SET_BOOT,
+	};
+	union pds_core_dev_comp comp;
+	enum pds_core_fw_slot slot;
+	int timeout;
+
+	for (slot = 0; slot < ARRAY_SIZE(slot_labels); slot++)
+		if (!strcmp(ctx->val.vstr, slot_labels[slot]))
+			break;
+
+	if (slot >= ARRAY_SIZE(slot_labels))
+		return -EINVAL;
+
+	cmd.fw_control.slot = slot;
+
+	/* This is known to be a longer running command, so be sure
+	 * to use a larger timeout on the command than usual
+	 */
+#define PDSC_SET_BOOT_TIMEOUT	10
+	timeout = max_t(int, PDSC_SET_BOOT_TIMEOUT, pdsc->devcmd_timeout);
+	return pdsc_devcmd(pdsc, &cmd, &comp, timeout);
+}
+
+static int pdsc_dl_fw_boot_validate(struct devlink *dl, u32 id,
+				    union devlink_param_value val,
+				    struct netlink_ext_ack *extack)
+{
+	enum pds_core_fw_slot slot;
+
+	for (slot = 0; slot < ARRAY_SIZE(slot_labels); slot++)
+		if (!strcmp(val.vstr, slot_labels[slot]))
+			return 0;
+
+	return -EINVAL;
+}
+
+static const struct devlink_param pdsc_dl_params[] = {
+	DEVLINK_PARAM_DRIVER(PDSC_DEVLINK_PARAM_ID_FW_BOOT,
+			     "boot_fw",
+			     DEVLINK_PARAM_TYPE_STRING,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     pdsc_dl_fw_boot_get,
+			     pdsc_dl_fw_boot_set,
+			     pdsc_dl_fw_boot_validate),
+};
+
+static int pdsc_dl_flash_update(struct devlink *dl,
+				struct devlink_flash_update_params *params,
+				struct netlink_ext_ack *extack)
+{
+	struct pdsc *pdsc = devlink_priv(dl);
+
+	return pdsc_firmware_update(pdsc, params->fw, extack);
+}
+
 static int pdsc_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 			    struct netlink_ext_ack *extack)
 {
@@ -71,6 +165,7 @@ static int pdsc_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 
 static const struct devlink_ops pdsc_dl_ops = {
 	.info_get	= pdsc_dl_info_get,
+	.flash_update	= pdsc_dl_flash_update,
 };
 
 struct pdsc *pdsc_dl_alloc(struct device *dev)
@@ -94,6 +189,12 @@ void pdsc_dl_free(struct pdsc *pdsc)
 int pdsc_dl_register(struct pdsc *pdsc)
 {
 	struct devlink *dl = priv_to_devlink(pdsc);
+	int err;
+
+	err = devlink_params_register(dl, pdsc_dl_params,
+				      ARRAY_SIZE(pdsc_dl_params));
+	if (err)
+		return err;
 
 	devlink_register(dl);
 
@@ -105,4 +206,6 @@ void pdsc_dl_unregister(struct pdsc *pdsc)
 	struct devlink *dl = priv_to_devlink(pdsc);
 
 	devlink_unregister(dl);
+	devlink_params_unregister(dl, pdsc_dl_params,
+				  ARRAY_SIZE(pdsc_dl_params));
 }
diff --git a/drivers/net/ethernet/pensando/pds_core/fw.c b/drivers/net/ethernet/pensando/pds_core/fw.c
new file mode 100644
index 000000000000..3c64deef5549
--- /dev/null
+++ b/drivers/net/ethernet/pensando/pds_core/fw.c
@@ -0,0 +1,192 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2022 Pensando Systems, Inc */
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/firmware.h>
+
+#include "core.h"
+
+/* The worst case wait for the install activity is about 25 minutes when
+ * installing a new CPLD, which is very seldom.  Normal is about 30-35
+ * seconds.  Since the driver can't tell if a CPLD update will happen we
+ * set the timeout for the ugly case.
+ */
+#define PDSC_FW_INSTALL_TIMEOUT	(25 * 60)
+#define PDSC_FW_SELECT_TIMEOUT	30
+
+/* Number of periodic log updates during fw file download */
+#define PDSC_FW_INTERVAL_FRACTION	32
+
+static int pdsc_devcmd_firmware_download(struct pdsc *pdsc, u64 addr,
+					 u32 offset, u32 length)
+{
+	union pds_core_dev_cmd cmd = {
+		.fw_download.opcode = PDS_CORE_CMD_FW_DOWNLOAD,
+		.fw_download.offset = cpu_to_le32(offset),
+		.fw_download.addr = cpu_to_le64(addr),
+		.fw_download.length = cpu_to_le32(length),
+	};
+	union pds_core_dev_comp comp;
+
+	return pdsc_devcmd_locked(pdsc, &cmd, &comp, pdsc->devcmd_timeout);
+}
+
+static int pdsc_devcmd_firmware_install(struct pdsc *pdsc)
+{
+	union pds_core_dev_cmd cmd = {
+		.fw_control.opcode = PDS_CORE_CMD_FW_CONTROL,
+		.fw_control.oper = PDS_CORE_FW_INSTALL_ASYNC
+	};
+	union pds_core_dev_comp comp;
+	int err;
+
+	err = pdsc_devcmd(pdsc, &cmd, &comp, pdsc->devcmd_timeout);
+	if (err < 0)
+		return err;
+
+	return comp.fw_control.slot;
+}
+
+static int pdsc_devcmd_firmware_activate(struct pdsc *pdsc,
+					 enum pds_core_fw_slot slot)
+{
+	union pds_core_dev_cmd cmd = {
+		.fw_control.opcode = PDS_CORE_CMD_FW_CONTROL,
+		.fw_control.oper = PDS_CORE_FW_ACTIVATE_ASYNC,
+		.fw_control.slot = slot
+	};
+	union pds_core_dev_comp comp;
+
+	return pdsc_devcmd(pdsc, &cmd, &comp, pdsc->devcmd_timeout);
+}
+
+static int pdsc_fw_status_long_wait(struct pdsc *pdsc,
+				    const char *label,
+				    unsigned long timeout,
+				    u8 fw_cmd,
+				    struct netlink_ext_ack *extack)
+{
+	union pds_core_dev_cmd cmd = {
+		.fw_control.opcode = PDS_CORE_CMD_FW_CONTROL,
+		.fw_control.oper = fw_cmd,
+	};
+	union pds_core_dev_comp comp;
+	unsigned long start_time;
+	unsigned long end_time;
+	int err;
+
+	/* Ping on the status of the long running async install
+	 * command.  We get EAGAIN while the command is still
+	 * running, else we get the final command status.
+	 */
+	start_time = jiffies;
+	end_time = start_time + (timeout * HZ);
+	do {
+		err = pdsc_devcmd(pdsc, &cmd, &comp, pdsc->devcmd_timeout);
+		msleep(20);
+	} while (time_before(jiffies, end_time) &&
+		 (err == -EAGAIN || err == -ETIMEDOUT));
+
+	if (err == -EAGAIN || err == -ETIMEDOUT) {
+		NL_SET_ERR_MSG_MOD(extack, "Firmware wait timed out");
+		dev_err(pdsc->dev, "DEV_CMD firmware wait %s timed out\n", label);
+	} else if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Firmware wait failed");
+	}
+
+	return err;
+}
+
+int pdsc_firmware_update(struct pdsc *pdsc, const struct firmware *fw,
+			 struct netlink_ext_ack *extack)
+{
+	u32 buf_sz, copy_sz, offset;
+	struct devlink *dl;
+	int next_interval;
+	u64 data_addr;
+	int err = 0;
+	u8 fw_slot;
+
+	dev_info(pdsc->dev, "Installing firmware\n");
+
+	dl = priv_to_devlink(pdsc);
+	devlink_flash_update_status_notify(dl, "Preparing to flash", NULL, 0, 0);
+
+	buf_sz = sizeof(pdsc->cmd_regs->data);
+
+	dev_dbg(pdsc->dev,
+		"downloading firmware - size %d part_sz %d nparts %lu\n",
+		(int)fw->size, buf_sz, DIV_ROUND_UP(fw->size, buf_sz));
+
+	offset = 0;
+	next_interval = 0;
+	data_addr = offsetof(struct pds_core_dev_cmd_regs, data);
+	while (offset < fw->size) {
+		if (offset >= next_interval) {
+			devlink_flash_update_status_notify(dl, "Downloading", NULL,
+							   offset, fw->size);
+			next_interval = offset + (fw->size / PDSC_FW_INTERVAL_FRACTION);
+		}
+
+		copy_sz = min_t(unsigned int, buf_sz, fw->size - offset);
+		mutex_lock(&pdsc->devcmd_lock);
+		memcpy_toio(&pdsc->cmd_regs->data, fw->data + offset, copy_sz);
+		err = pdsc_devcmd_firmware_download(pdsc, data_addr, offset, copy_sz);
+		mutex_unlock(&pdsc->devcmd_lock);
+		if (err) {
+			dev_err(pdsc->dev,
+				"download failed offset 0x%x addr 0x%llx len 0x%x: %pe\n",
+				offset, data_addr, copy_sz, ERR_PTR(err));
+			NL_SET_ERR_MSG_MOD(extack, "Segment download failed");
+			goto err_out;
+		}
+		offset += copy_sz;
+	}
+	devlink_flash_update_status_notify(dl, "Downloading", NULL,
+					   fw->size, fw->size);
+
+	devlink_flash_update_timeout_notify(dl, "Installing", NULL,
+					    PDSC_FW_INSTALL_TIMEOUT);
+
+	fw_slot = pdsc_devcmd_firmware_install(pdsc);
+	if (fw_slot < 0) {
+		err = fw_slot;
+		dev_err(pdsc->dev, "install failed: %pe\n", ERR_PTR(err));
+		NL_SET_ERR_MSG_MOD(extack, "Failed to start firmware install");
+		goto err_out;
+	}
+
+	err = pdsc_fw_status_long_wait(pdsc, "Installing",
+				       PDSC_FW_INSTALL_TIMEOUT,
+				       PDS_CORE_FW_INSTALL_STATUS,
+				       extack);
+	if (err)
+		goto err_out;
+
+	devlink_flash_update_timeout_notify(dl, "Selecting", NULL,
+					    PDSC_FW_SELECT_TIMEOUT);
+
+	err = pdsc_devcmd_firmware_activate(pdsc, fw_slot);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to start firmware select");
+		goto err_out;
+	}
+
+	err = pdsc_fw_status_long_wait(pdsc, "Selecting",
+				       PDSC_FW_SELECT_TIMEOUT,
+				       PDS_CORE_FW_ACTIVATE_STATUS,
+				       extack);
+	if (err)
+		goto err_out;
+
+	dev_info(pdsc->dev, "Firmware update completed, slot %d\n", fw_slot);
+
+err_out:
+	if (err)
+		devlink_flash_update_status_notify(dl, "Flash failed", NULL, 0, 0);
+	else
+		devlink_flash_update_status_notify(dl, "Flash done", NULL, 0, 0);
+	return err;
+}
-- 
2.17.1

