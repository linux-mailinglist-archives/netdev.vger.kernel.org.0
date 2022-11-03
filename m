Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 109B161874A
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 19:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbiKCSSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 14:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbiKCSSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 14:18:44 -0400
Received: from mail-ed1-x54a.google.com (mail-ed1-x54a.google.com [IPv6:2a00:1450:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90BEE13D1A
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 11:18:42 -0700 (PDT)
Received: by mail-ed1-x54a.google.com with SMTP id z11-20020a056402274b00b00461dba91468so1908025edd.6
        for <netdev@vger.kernel.org>; Thu, 03 Nov 2022 11:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HcdPmIk7C9waVQYe82uiKXEA1RmjBCvt/Og9cHH/6/g=;
        b=BMdzJ4QpxBM1dxHKiuXW84F0+TfXXIkmxF+LZaq0Xd/DqajVHVAsBfGvXtK8VN83/6
         yDBn9U0G2VkpqOlqVDzka2fBISghOPie90xujYyp0TmdXo/Rv4HX6N+gKnUWEgCAOzt1
         csIXFr0Lk1yZNgvtymQdrQh7m1AualsKRNOsFZ37TmKCD8qq7hLKosXM/1rLPjLQfapj
         lkpShD44WQW/mkhtM0DgK4M0U+CR2TJjDw26XAHEG8t0l/MiClfQ7flGmKaqktDbaK0A
         pjlSF0TqS/SZaTNveh/5q7oZByzLTKeXeFAEY+QQLrfup/6hl/kQTYJgx9Fmd7haSZFq
         danQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HcdPmIk7C9waVQYe82uiKXEA1RmjBCvt/Og9cHH/6/g=;
        b=WloRZltxfXC9of7mLdC3kq2j0yOoXK0FTf9p92Cli6Dd9oub0mlbtw8jmg0txZ6dyh
         VQ31g24A8soMVFCPr1YXF28FEmAd1tzGAxm9wbuFTB7VJoD7Frk84f0JVYZKsI20KnrT
         /2LXCl4m3rQIIL0SbEuhmDnC72+W5t+bmbwC2yxfQ85Zrg6QR19sPqZeVnM4rqTU92EV
         wNQezQRKi2LwuIRMkwJzLiNnHj98+WqsULgD8TRdQsxcFPs2w4seHezVC5RIjWHAgj1F
         f4MCQM1wWIlCX7/5iEqVrS1wlaMm1Dr+gAq5IdnO3UzYpa8mCpMpfjpId4mC5Ln9a2V5
         KuaA==
X-Gm-Message-State: ACrzQf1RYLPHU0jbUQ1A76qox2X4kGFK34xoCNcGdmbk/pcAA8t48oBC
        B8eg7JI2IDyYl/V9BIsJV5IUckWIgowU
X-Google-Smtp-Source: AMsMyM7oDLVtAhPW8lnjhn9oYDvhbJb9vILK6xFGYdrNATiLJB6q4wvx+er9DokZucMscWXmjGR700t3Cx4+
X-Received: from dvyukov-desk.muc.corp.google.com ([2a00:79e0:9c:201:3ce9:1db7:560d:d934])
 (user=dvyukov job=sendgmr) by 2002:a05:6402:5288:b0:457:22e5:8022 with SMTP
 id en8-20020a056402528800b0045722e58022mr8195949edb.244.1667499521057; Thu,
 03 Nov 2022 11:18:41 -0700 (PDT)
Date:   Thu,  3 Nov 2022 19:18:36 +0100
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221103181836.766399-1-dvyukov@google.com>
Subject: [PATCH net-next v2] nfc: Allow to create multiple virtual nci devices
From:   Dmitry Vyukov <dvyukov@google.com>
To:     leon@kernel.org, bongsu.jeon@samsung.com,
        krzysztof.kozlowski@linaro.org, netdev@vger.kernel.org
Cc:     syzkaller@googlegroups.com, Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current virtual nci driver is great for testing and fuzzing.
But it allows to create at most one "global" device which does not allow
to run parallel tests and harms fuzzing isolation and reproducibility.
Restructure the driver to allow creation of multiple independent devices.
This should be backwards compatible for existing tests.

Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Bongsu Jeon <bongsu.jeon@samsung.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: netdev@vger.kernel.org

---
Changes in v2:
 - check return value of skb_clone()
 - rebase onto currnet net-next
---
 drivers/nfc/virtual_ncidev.c | 146 +++++++++++++++++------------------
 1 file changed, 70 insertions(+), 76 deletions(-)

diff --git a/drivers/nfc/virtual_ncidev.c b/drivers/nfc/virtual_ncidev.c
index 85c06dbb2c449..48d6d09e2f6fd 100644
--- a/drivers/nfc/virtual_ncidev.c
+++ b/drivers/nfc/virtual_ncidev.c
@@ -13,12 +13,6 @@
 #include <linux/wait.h>
 #include <net/nfc/nci_core.h>
 
-enum virtual_ncidev_mode {
-	virtual_ncidev_enabled,
-	virtual_ncidev_disabled,
-	virtual_ncidev_disabling,
-};
-
 #define IOCTL_GET_NCIDEV_IDX    0
 #define VIRTUAL_NFC_PROTOCOLS	(NFC_PROTO_JEWEL_MASK | \
 				 NFC_PROTO_MIFARE_MASK | \
@@ -27,12 +21,12 @@ enum virtual_ncidev_mode {
 				 NFC_PROTO_ISO14443_B_MASK | \
 				 NFC_PROTO_ISO15693_MASK)
 
-static enum virtual_ncidev_mode state;
-static DECLARE_WAIT_QUEUE_HEAD(wq);
-static struct miscdevice miscdev;
-static struct sk_buff *send_buff;
-static struct nci_dev *ndev;
-static DEFINE_MUTEX(nci_mutex);
+struct virtual_nci_dev {
+	struct nci_dev *ndev;
+	struct mutex mtx;
+	struct sk_buff *send_buff;
+	struct wait_queue_head wq;
+};
 
 static int virtual_nci_open(struct nci_dev *ndev)
 {
@@ -41,31 +35,34 @@ static int virtual_nci_open(struct nci_dev *ndev)
 
 static int virtual_nci_close(struct nci_dev *ndev)
 {
-	mutex_lock(&nci_mutex);
-	kfree_skb(send_buff);
-	send_buff = NULL;
-	mutex_unlock(&nci_mutex);
+	struct virtual_nci_dev *vdev = nci_get_drvdata(ndev);
+
+	mutex_lock(&vdev->mtx);
+	kfree_skb(vdev->send_buff);
+	vdev->send_buff = NULL;
+	mutex_unlock(&vdev->mtx);
 
 	return 0;
 }
 
 static int virtual_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
 {
-	mutex_lock(&nci_mutex);
-	if (state != virtual_ncidev_enabled) {
-		mutex_unlock(&nci_mutex);
+	struct virtual_nci_dev *vdev = nci_get_drvdata(ndev);
+
+	mutex_lock(&vdev->mtx);
+	if (vdev->send_buff) {
+		mutex_unlock(&vdev->mtx);
 		kfree_skb(skb);
-		return 0;
+		return -1;
 	}
-
-	if (send_buff) {
-		mutex_unlock(&nci_mutex);
+	vdev->send_buff = skb_copy(skb, GFP_KERNEL);
+	if (!vdev->send_buff) {
+		mutex_unlock(&vdev->mtx);
 		kfree_skb(skb);
 		return -1;
 	}
-	send_buff = skb_copy(skb, GFP_KERNEL);
-	mutex_unlock(&nci_mutex);
-	wake_up_interruptible(&wq);
+	mutex_unlock(&vdev->mtx);
+	wake_up_interruptible(&vdev->wq);
 	consume_skb(skb);
 
 	return 0;
@@ -80,29 +77,30 @@ static const struct nci_ops virtual_nci_ops = {
 static ssize_t virtual_ncidev_read(struct file *file, char __user *buf,
 				   size_t count, loff_t *ppos)
 {
+	struct virtual_nci_dev *vdev = file->private_data;
 	size_t actual_len;
 
-	mutex_lock(&nci_mutex);
-	while (!send_buff) {
-		mutex_unlock(&nci_mutex);
-		if (wait_event_interruptible(wq, send_buff))
+	mutex_lock(&vdev->mtx);
+	while (!vdev->send_buff) {
+		mutex_unlock(&vdev->mtx);
+		if (wait_event_interruptible(vdev->wq, vdev->send_buff))
 			return -EFAULT;
-		mutex_lock(&nci_mutex);
+		mutex_lock(&vdev->mtx);
 	}
 
-	actual_len = min_t(size_t, count, send_buff->len);
+	actual_len = min_t(size_t, count, vdev->send_buff->len);
 
-	if (copy_to_user(buf, send_buff->data, actual_len)) {
-		mutex_unlock(&nci_mutex);
+	if (copy_to_user(buf, vdev->send_buff->data, actual_len)) {
+		mutex_unlock(&vdev->mtx);
 		return -EFAULT;
 	}
 
-	skb_pull(send_buff, actual_len);
-	if (send_buff->len == 0) {
-		consume_skb(send_buff);
-		send_buff = NULL;
+	skb_pull(vdev->send_buff, actual_len);
+	if (vdev->send_buff->len == 0) {
+		consume_skb(vdev->send_buff);
+		vdev->send_buff = NULL;
 	}
-	mutex_unlock(&nci_mutex);
+	mutex_unlock(&vdev->mtx);
 
 	return actual_len;
 }
@@ -111,6 +109,7 @@ static ssize_t virtual_ncidev_write(struct file *file,
 				    const char __user *buf,
 				    size_t count, loff_t *ppos)
 {
+	struct virtual_nci_dev *vdev = file->private_data;
 	struct sk_buff *skb;
 
 	skb = alloc_skb(count, GFP_KERNEL);
@@ -122,63 +121,57 @@ static ssize_t virtual_ncidev_write(struct file *file,
 		return -EFAULT;
 	}
 
-	nci_recv_frame(ndev, skb);
+	nci_recv_frame(vdev->ndev, skb);
 	return count;
 }
 
 static int virtual_ncidev_open(struct inode *inode, struct file *file)
 {
 	int ret = 0;
+	struct virtual_nci_dev *vdev;
 
-	mutex_lock(&nci_mutex);
-	if (state != virtual_ncidev_disabled) {
-		mutex_unlock(&nci_mutex);
-		return -EBUSY;
-	}
-
-	ndev = nci_allocate_device(&virtual_nci_ops, VIRTUAL_NFC_PROTOCOLS,
-				   0, 0);
-	if (!ndev) {
-		mutex_unlock(&nci_mutex);
+	vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
+	if (!vdev)
+		return -ENOMEM;
+	vdev->ndev = nci_allocate_device(&virtual_nci_ops,
+		VIRTUAL_NFC_PROTOCOLS, 0, 0);
+	if (!vdev->ndev) {
+		kfree(vdev);
 		return -ENOMEM;
 	}
 
-	ret = nci_register_device(ndev);
+	mutex_init(&vdev->mtx);
+	init_waitqueue_head(&vdev->wq);
+	file->private_data = vdev;
+	nci_set_drvdata(vdev->ndev, vdev);
+
+	ret = nci_register_device(vdev->ndev);
 	if (ret < 0) {
-		nci_free_device(ndev);
-		mutex_unlock(&nci_mutex);
+		mutex_destroy(&vdev->mtx);
+		nci_free_device(vdev->ndev);
+		kfree(vdev);
 		return ret;
 	}
-	state = virtual_ncidev_enabled;
-	mutex_unlock(&nci_mutex);
 
 	return 0;
 }
 
 static int virtual_ncidev_close(struct inode *inode, struct file *file)
 {
-	mutex_lock(&nci_mutex);
-
-	if (state == virtual_ncidev_enabled) {
-		state = virtual_ncidev_disabling;
-		mutex_unlock(&nci_mutex);
+	struct virtual_nci_dev *vdev = file->private_data;
 
-		nci_unregister_device(ndev);
-		nci_free_device(ndev);
-
-		mutex_lock(&nci_mutex);
-	}
-
-	state = virtual_ncidev_disabled;
-	mutex_unlock(&nci_mutex);
+	nci_unregister_device(vdev->ndev);
+	nci_free_device(vdev->ndev);
+	mutex_destroy(&vdev->mtx);
 
 	return 0;
 }
 
-static long virtual_ncidev_ioctl(struct file *flip, unsigned int cmd,
+static long virtual_ncidev_ioctl(struct file *file, unsigned int cmd,
 				 unsigned long arg)
 {
-	const struct nfc_dev *nfc_dev = ndev->nfc_dev;
+	struct virtual_nci_dev *vdev = file->private_data;
+	const struct nfc_dev *nfc_dev = vdev->ndev->nfc_dev;
 	void __user *p = (void __user *)arg;
 
 	if (cmd != IOCTL_GET_NCIDEV_IDX)
@@ -199,14 +192,15 @@ static const struct file_operations virtual_ncidev_fops = {
 	.unlocked_ioctl = virtual_ncidev_ioctl
 };
 
+static struct miscdevice miscdev = {
+	.minor = MISC_DYNAMIC_MINOR,
+	.name = "virtual_nci",
+	.fops = &virtual_ncidev_fops,
+	.mode = 0600,
+};
+
 static int __init virtual_ncidev_init(void)
 {
-	state = virtual_ncidev_disabled;
-	miscdev.minor = MISC_DYNAMIC_MINOR;
-	miscdev.name = "virtual_nci";
-	miscdev.fops = &virtual_ncidev_fops;
-	miscdev.mode = 0600;
-
 	return misc_register(&miscdev);
 }
 

base-commit: d9095f92950bd16745b9ec24ebebc12d14b3a3e8
-- 
2.38.1.431.g37b22c650d-goog

