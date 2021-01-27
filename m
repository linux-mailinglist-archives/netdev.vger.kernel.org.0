Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3B7305CA6
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 14:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343797AbhA0NMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 08:12:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343654AbhA0NKv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 08:10:51 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DF00C06178B;
        Wed, 27 Jan 2021 05:09:02 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id n25so1573191pgb.0;
        Wed, 27 Jan 2021 05:09:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=akOAnHugAHPJeCqi35Sqlt5ZAXSR+liw5k5JrKdtLYY=;
        b=MYlSv3Gwyb2U5Zh9P4j4dxu4cFXuanCeDSbq7Uc5oaY6BOJ99A0rtOPAD03gbvzXZA
         HAIGgYhcDx3YUc01Z8e8M+Vkxyxa1dplJurYzPviBohFMSq/X6RSxcKKP9fHLmHIDq90
         qZlVkveGM2aGLBc1gUCAQ5yULIDvynO2dBEhiqG9C7urcxOK8ocX28MfukHRZd5Y28gv
         DdED5Kczdwx+e+60BbEb2tdMBydOKNgt4dikY03fiha5eltaEQqqgS6ppiSC0w7WFFco
         PhKX1lrTarNI3sgTWykuCj4rT5iIp3a4ChxntyRtfP77Ooa0owoea3yb89lUu+qZIUoE
         Zstg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=akOAnHugAHPJeCqi35Sqlt5ZAXSR+liw5k5JrKdtLYY=;
        b=ZV7bGhgMI/8vOBrwQwu3WSYLmy9O2GTHJlfIe4iMpteBozUjtHFBUfCUat35jfFN3M
         YNQX4gpGEig8KLc6tnQuqVeqsotdWHEzuTqWKSr1B/q6vuJhTAjlnDAnQkxDOe1ThzBh
         K2tLnpRP645jjr8cPtDUg6iZHlnfMADvIoa8Hg9yNsCH8fV9Ud4qQeZZZYprUs9HRef8
         nNmyaFo/JkI85/G1dkw26mUHr3zWYYpnxj2IFZzxNriAhP0un/XP+JimbLecJ2Injrj2
         Hjt5uBYVA64WlDETkgHNAhIC2ko+KFiQ6Q6kqz0k0M8FT959/hB//PXY9dmqQXEp6CAk
         Yx0A==
X-Gm-Message-State: AOAM53038Spo0QK+IWxu0dzCTwrhPMevdq/ZSgPm35jp7Cd3tPv3s9Sc
        V9y77P2289wnl/G+y/Yc7Ogb8ymV0YoZWw==
X-Google-Smtp-Source: ABdhPJyZ3KaVZn4++y4J2UNI5jeYjHxlohfF95NPiFPnE0ZvJK0exxtdOd5pT2V8nGM49tJ20bV4pw==
X-Received: by 2002:a63:6fce:: with SMTP id k197mr11309643pgc.423.1611752941709;
        Wed, 27 Jan 2021 05:09:01 -0800 (PST)
Received: from localhost.localdomain ([182.226.226.37])
        by smtp.googlemail.com with ESMTPSA id 6sm2163343pjm.31.2021.01.27.05.08.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 05:09:01 -0800 (PST)
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
X-Google-Original-From: Bongsu Jeon
To:     kuba@kernel.org, shuah@kernel.org
Cc:     krzk@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-nfc@lists.01.org,
        linux-kselftest@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: [PATCH net-next v4 1/2] nfc: Add a virtual nci device driver
Date:   Wed, 27 Jan 2021 22:08:28 +0900
Message-Id: <20210127130829.4026-2-bongsu.jeon@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210127130829.4026-1-bongsu.jeon@samsung.com>
References: <20210127130829.4026-1-bongsu.jeon@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

NCI virtual device simulates a NCI device to the user. It can be used to
validate the NCI module and applications. This driver supports
communication between the virtual NCI device and NCI module.

Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
---
 drivers/nfc/Kconfig          |  11 ++
 drivers/nfc/Makefile         |   1 +
 drivers/nfc/virtual_ncidev.c | 215 +++++++++++++++++++++++++++++++++++
 3 files changed, 227 insertions(+)
 create mode 100644 drivers/nfc/virtual_ncidev.c

diff --git a/drivers/nfc/Kconfig b/drivers/nfc/Kconfig
index 75c65d339018..288c6f1c6979 100644
--- a/drivers/nfc/Kconfig
+++ b/drivers/nfc/Kconfig
@@ -49,6 +49,17 @@ config NFC_PORT100
 
 	  If unsure, say N.
 
+config NFC_VIRTUAL_NCI
+	tristate "NCI device simulator driver"
+	depends on NFC_NCI
+	help
+	  NCI virtual device simulates a NCI device to the user.
+	  It can be used to validate the NCI module and applications.
+	  This driver supports communication between the virtual NCI device and
+	  module.
+
+	  If unsure, say N.
+
 source "drivers/nfc/fdp/Kconfig"
 source "drivers/nfc/pn544/Kconfig"
 source "drivers/nfc/pn533/Kconfig"
diff --git a/drivers/nfc/Makefile b/drivers/nfc/Makefile
index 5393ba59b17d..7b1bfde1d971 100644
--- a/drivers/nfc/Makefile
+++ b/drivers/nfc/Makefile
@@ -17,3 +17,4 @@ obj-$(CONFIG_NFC_ST_NCI)	+= st-nci/
 obj-$(CONFIG_NFC_NXP_NCI)	+= nxp-nci/
 obj-$(CONFIG_NFC_S3FWRN5)	+= s3fwrn5/
 obj-$(CONFIG_NFC_ST95HF)	+= st95hf/
+obj-$(CONFIG_NFC_VIRTUAL_NCI)	+= virtual_ncidev.o
diff --git a/drivers/nfc/virtual_ncidev.c b/drivers/nfc/virtual_ncidev.c
new file mode 100644
index 000000000000..f73ee0bf3593
--- /dev/null
+++ b/drivers/nfc/virtual_ncidev.c
@@ -0,0 +1,215 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Virtual NCI device simulation driver
+ *
+ * Copyright (C) 2020 Samsung Electrnoics
+ * Bongsu Jeon <bongsu.jeon@samsung.com>
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/miscdevice.h>
+#include <linux/mutex.h>
+#include <net/nfc/nci_core.h>
+
+enum virtual_ncidev_mode {
+	virtual_ncidev_enabled,
+	virtual_ncidev_disabled,
+	virtual_ncidev_disabling,
+};
+
+#define IOCTL_GET_NCIDEV_IDX    0
+#define VIRTUAL_NFC_PROTOCOLS	(NFC_PROTO_JEWEL_MASK | \
+				 NFC_PROTO_MIFARE_MASK | \
+				 NFC_PROTO_FELICA_MASK | \
+				 NFC_PROTO_ISO14443_MASK | \
+				 NFC_PROTO_ISO14443_B_MASK | \
+				 NFC_PROTO_ISO15693_MASK)
+
+static enum virtual_ncidev_mode state;
+static struct miscdevice miscdev;
+static struct sk_buff *send_buff;
+static struct nci_dev *ndev;
+static DEFINE_MUTEX(nci_mutex);
+
+static int virtual_nci_open(struct nci_dev *ndev)
+{
+	return 0;
+}
+
+static int virtual_nci_close(struct nci_dev *ndev)
+{
+	mutex_lock(&nci_mutex);
+	kfree_skb(send_buff);
+	send_buff = NULL;
+	mutex_unlock(&nci_mutex);
+
+	return 0;
+}
+
+static int virtual_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
+{
+	mutex_lock(&nci_mutex);
+	if (state != virtual_ncidev_enabled) {
+		mutex_unlock(&nci_mutex);
+		return 0;
+	}
+
+	if (send_buff) {
+		mutex_unlock(&nci_mutex);
+		return -1;
+	}
+	send_buff = skb_copy(skb, GFP_KERNEL);
+	mutex_unlock(&nci_mutex);
+
+	return 0;
+}
+
+static struct nci_ops virtual_nci_ops = {
+	.open = virtual_nci_open,
+	.close = virtual_nci_close,
+	.send = virtual_nci_send
+};
+
+static ssize_t virtual_ncidev_read(struct file *file, char __user *buf,
+				   size_t count, loff_t *ppos)
+{
+	size_t actual_len;
+
+	mutex_lock(&nci_mutex);
+	if (!send_buff) {
+		mutex_unlock(&nci_mutex);
+		return 0;
+	}
+
+	actual_len = min_t(size_t, count, send_buff->len);
+
+	if (copy_to_user(buf, send_buff->data, actual_len)) {
+		mutex_unlock(&nci_mutex);
+		return -EFAULT;
+	}
+
+	skb_pull(send_buff, actual_len);
+	if (send_buff->len == 0) {
+		consume_skb(send_buff);
+		send_buff = NULL;
+	}
+	mutex_unlock(&nci_mutex);
+
+	return actual_len;
+}
+
+static ssize_t virtual_ncidev_write(struct file *file,
+				    const char __user *buf,
+				    size_t count, loff_t *ppos)
+{
+	struct sk_buff *skb;
+
+	skb = alloc_skb(count, GFP_KERNEL);
+	if (!skb)
+		return -ENOMEM;
+
+	if (copy_from_user(skb_put(skb, count), buf, count)) {
+		kfree_skb(skb);
+		return -EFAULT;
+	}
+
+	nci_recv_frame(ndev, skb);
+	return count;
+}
+
+static int virtual_ncidev_open(struct inode *inode, struct file *file)
+{
+	int ret = 0;
+
+	mutex_lock(&nci_mutex);
+	if (state != virtual_ncidev_disabled) {
+		mutex_unlock(&nci_mutex);
+		return -EBUSY;
+	}
+
+	ndev = nci_allocate_device(&virtual_nci_ops, VIRTUAL_NFC_PROTOCOLS,
+				   0, 0);
+	if (!ndev) {
+		mutex_unlock(&nci_mutex);
+		return -ENOMEM;
+	}
+
+	ret = nci_register_device(ndev);
+	if (ret < 0) {
+		nci_free_device(ndev);
+		mutex_unlock(&nci_mutex);
+		return ret;
+	}
+	state = virtual_ncidev_enabled;
+	mutex_unlock(&nci_mutex);
+
+	return 0;
+}
+
+static int virtual_ncidev_close(struct inode *inode, struct file *file)
+{
+	mutex_lock(&nci_mutex);
+
+	if (state == virtual_ncidev_enabled) {
+		state = virtual_ncidev_disabling;
+		mutex_unlock(&nci_mutex);
+
+		nci_unregister_device(ndev);
+		nci_free_device(ndev);
+
+		mutex_lock(&nci_mutex);
+	}
+
+	state = virtual_ncidev_disabled;
+	mutex_unlock(&nci_mutex);
+
+	return 0;
+}
+
+static long virtual_ncidev_ioctl(struct file *flip, unsigned int cmd,
+				 unsigned long arg)
+{
+	struct nfc_dev *nfc_dev = ndev->nfc_dev;
+	void __user *p = (void __user *)arg;
+
+	if (cmd != IOCTL_GET_NCIDEV_IDX)
+		return -ENOTTY;
+
+	if (copy_to_user(p, &nfc_dev->idx, sizeof(nfc_dev->idx)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static const struct file_operations virtual_ncidev_fops = {
+	.owner = THIS_MODULE,
+	.read = virtual_ncidev_read,
+	.write = virtual_ncidev_write,
+	.open = virtual_ncidev_open,
+	.release = virtual_ncidev_close,
+	.unlocked_ioctl = virtual_ncidev_ioctl
+};
+
+static int __init virtual_ncidev_init(void)
+{
+	state = virtual_ncidev_disabled;
+	miscdev.minor = MISC_DYNAMIC_MINOR;
+	miscdev.name = "virtual_nci";
+	miscdev.fops = &virtual_ncidev_fops;
+	miscdev.mode = S_IALLUGO;
+
+	return misc_register(&miscdev);
+}
+
+static void __exit virtual_ncidev_exit(void)
+{
+	misc_deregister(&miscdev);
+}
+
+module_init(virtual_ncidev_init);
+module_exit(virtual_ncidev_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Virtual NCI device simulation driver");
+MODULE_AUTHOR("Bongsu Jeon <bongsu.jeon@samsung.com>");
-- 
2.25.1

