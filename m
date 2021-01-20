Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D80F2FD0C3
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 13:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729895AbhATMwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 07:52:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732626AbhATL5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 06:57:30 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7BC4C0613CF;
        Wed, 20 Jan 2021 03:57:04 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id v19so15013460pgj.12;
        Wed, 20 Jan 2021 03:57:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Mn+Z4RMlE5IV3+B+MFiO9hubAKqGK7Hejtc2y8hOBR4=;
        b=e199QWs8RTlwD0qY9AZtyNbwzyOtfOfZiL0mIvY0OuDVAhU6RRWWSZxbq48C2/u55K
         bI7RNBlGBkxI3u5zyZXLb/CUgrN7+lNUcDpwj7pEbaxpQe1KccEVMs/AmGOtQGyFLacF
         AQLs+c9xYbx74OPowsl+6ZGDoGSkgtOLmWwnuz7l4ixFCAxRFaHsH5eGVs30TX7aeBis
         IdvenfzxXXUNI/frDQfpfr+yJ/fas/7wjhGGxeIvFkQbqkPMagadnqmJZqCZquzUI6pP
         e4/r8Df11Tq3C5ef+XOHGSoQ29kPj40zabcqmZZdirvkT1+7LFIWYk0OSD2/KZRVSwCo
         /i6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Mn+Z4RMlE5IV3+B+MFiO9hubAKqGK7Hejtc2y8hOBR4=;
        b=dk/OJB87w94YWKCs3QESaGAi2fck6kfICH1BnFnQkckIRfh1x+riLwTEqQv0RBPoG0
         1jSIFDLDA+amXd1U4Utc8LTM/M2frOTGLYPCoTMPln1CEEA0fSBz+Y5+8oGZk2iQ6fPG
         R7xppjClFsPwvTxVx6cQGcbrDomGMhS4TheQhv0bUyHa/oAEnUm5sqi/JNnrsrnDYIGe
         YhE2vJuuJcRcUcELHY2ZOcwtws8eMkZxdZlGh1JtnMuDlPr07GE9GxQZkZQQqUWRLID6
         jfy6DvGPR3v5cmmPYq7ZtLxzv6xHcLKdgUdGjseYDLQ8FCZFcSwE0y2GUeqkhi1CUqID
         SlXw==
X-Gm-Message-State: AOAM532lLci5x8SGJ0h82GeP2bYrfluL5vnCpQdUUWrHVfw9TT/WHYKl
        xt07PANGMVPQGGn6l0h49Ck=
X-Google-Smtp-Source: ABdhPJzw4XRUe1yzEGcOkUL+VZMP31H/VckglXVIuF+6GCN0EznoPr+2aWaRnUDnxBrDldLkmI+bHQ==
X-Received: by 2002:a63:d42:: with SMTP id 2mr3127783pgn.236.1611143824375;
        Wed, 20 Jan 2021 03:57:04 -0800 (PST)
Received: from localhost.localdomain ([182.226.226.37])
        by smtp.googlemail.com with ESMTPSA id f13sm6487856pjj.1.2021.01.20.03.57.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 03:57:03 -0800 (PST)
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
X-Google-Original-From: Bongsu Jeon
To:     kuba@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, linux-nfc@lists.01.org,
        linux-kselftest@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: [PATCH net-next v2 1/2] nfc: Add a virtual nci device driver
Date:   Wed, 20 Jan 2021 20:56:44 +0900
Message-Id: <20210120115645.32798-2-bongsu.jeon@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210120115645.32798-1-bongsu.jeon@samsung.com>
References: <20210120115645.32798-1-bongsu.jeon@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

A NCI virtual device can be made to simulate a NCI device in user space.
Using the virtual NCI device, The NCI module and application can be
validated. This driver supports to communicate between the virtual NCI
device and NCI module.

Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
---
 drivers/nfc/Kconfig          |  11 ++
 drivers/nfc/Makefile         |   1 +
 drivers/nfc/virtual_ncidev.c | 235 +++++++++++++++++++++++++++++++++++
 3 files changed, 247 insertions(+)
 create mode 100644 drivers/nfc/virtual_ncidev.c

diff --git a/drivers/nfc/Kconfig b/drivers/nfc/Kconfig
index 75c65d339018..d32c3a8937ed 100644
--- a/drivers/nfc/Kconfig
+++ b/drivers/nfc/Kconfig
@@ -49,6 +49,17 @@ config NFC_PORT100
 
 	  If unsure, say N.
 
+config NFC_VIRTUAL_NCI
+	tristate "NCI device simulator driver"
+	depends on NFC_NCI
+	help
+	  A NCI virtual device can be made to simulate a NCI device in user
+	  level. Using the virtual NCI device, The NCI module and application
+	  can be validated. This driver supports to communicate between the
+	  virtual NCI device and NCI module.
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
index 000000000000..0e327c08327c
--- /dev/null
+++ b/drivers/nfc/virtual_ncidev.c
@@ -0,0 +1,235 @@
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
+static struct mutex nci_send_mutex;
+static struct miscdevice miscdev;
+static struct sk_buff *send_buff;
+static struct mutex nci_mutex;
+static struct nci_dev *ndev;
+static bool full_txbuff;
+
+static bool virtual_ncidev_check_enabled(void)
+{
+	bool ret = true;
+
+	mutex_lock(&nci_mutex);
+	if (state != virtual_ncidev_enabled)
+		ret = false;
+	mutex_unlock(&nci_mutex);
+
+	return ret;
+}
+
+static int virtual_nci_open(struct nci_dev *ndev)
+{
+	return 0;
+}
+
+static int virtual_nci_close(struct nci_dev *ndev)
+{
+	mutex_lock(&nci_send_mutex);
+	if (full_txbuff)
+		kfree_skb(send_buff);
+	full_txbuff = false;
+	mutex_unlock(&nci_send_mutex);
+
+	return 0;
+}
+
+static int virtual_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
+{
+	if (virtual_ncidev_check_enabled() == false)
+		return 0;
+
+	mutex_lock(&nci_send_mutex);
+	if (full_txbuff) {
+		mutex_unlock(&nci_send_mutex);
+		return -1;
+	}
+	send_buff = skb_copy(skb, GFP_KERNEL);
+	full_txbuff = true;
+	mutex_unlock(&nci_send_mutex);
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
+	mutex_lock(&nci_send_mutex);
+	if (!full_txbuff) {
+		mutex_unlock(&nci_send_mutex);
+		return 0;
+	}
+
+	actual_len = count > send_buff->len ? send_buff->len : count;
+
+	if (copy_to_user(buf, send_buff->data, actual_len)) {
+		mutex_unlock(&nci_send_mutex);
+		return -EFAULT;
+	}
+
+	skb_pull(send_buff, actual_len);
+	if (send_buff->len == 0) {
+		kfree_skb(send_buff);
+		full_txbuff = false;
+	}
+	mutex_unlock(&nci_send_mutex);
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
+	if (copy_from_user(skb_put(skb, count), buf, count))
+		return -EFAULT;
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
+	mutex_init(&nci_send_mutex);
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
+	long res = -ENOTTY;
+
+	if (cmd == IOCTL_GET_NCIDEV_IDX) {
+		struct nfc_dev *nfc_dev = ndev->nfc_dev;
+		void __user *p = (void __user *)arg;
+
+		if (copy_to_user(p, &nfc_dev->idx, sizeof(nfc_dev->idx)))
+			return -EFAULT;
+		res = 0;
+	}
+
+	return res;
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
+	int ret;
+
+	mutex_init(&nci_mutex);
+	state = virtual_ncidev_disabled;
+	miscdev.minor = MISC_DYNAMIC_MINOR;
+	miscdev.name = "virtual_nci";
+	miscdev.fops = &virtual_ncidev_fops;
+	miscdev.mode = S_IALLUGO;
+	ret = misc_register(&miscdev);
+
+	return ret;
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

