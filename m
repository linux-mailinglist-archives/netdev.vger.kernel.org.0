Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A572A612AFF
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 15:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbiJ3O32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Oct 2022 10:29:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiJ3O31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Oct 2022 10:29:27 -0400
Received: from mail-ed1-x54a.google.com (mail-ed1-x54a.google.com [IPv6:2a00:1450:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 226F2211
        for <netdev@vger.kernel.org>; Sun, 30 Oct 2022 07:29:26 -0700 (PDT)
Received: by mail-ed1-x54a.google.com with SMTP id b13-20020a056402350d00b0045d0fe2004eso6151159edd.18
        for <netdev@vger.kernel.org>; Sun, 30 Oct 2022 07:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=G934zpWq0rzM4munA+aQabtHan6NJW/9gXBqNmPe9rQ=;
        b=U9FhY/ZtCX84S3bjfnatLbbeEWqdiGkkS9tIWy+OD0JHx3huwmJIFJqvzd1peUs+nI
         8l7B8FbxenUf7gSLz40IFNiER3F5SCNtNO+4Hgw0oQuQ7lbEGyxw3xui+yVjFXN3ABdf
         2O5Ga0e48I5YvypV4ErxS4e5R/+u+II5efX5gK0L6CBbLhJ49olo7sZq0KMURyzCbsb+
         wu+kdZ92v+kVeo/Ft47gP8D0cNr4I0Jj8+RbMia0l3MRkUsThdAgK2phdAYlY9/mBmjR
         R+ntDUT6ZjNWy9xajFiokWJYfonve6VdZINyGrRw8wdcIT1B4YCwE8L1GfNfRhvgvu1K
         JxsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G934zpWq0rzM4munA+aQabtHan6NJW/9gXBqNmPe9rQ=;
        b=hOCMl6YedTYcpwfMyNFp75qkucBXm21xzpul7hwGSS2Ku9BC8uCmJMqyjH/gbGLJHo
         01f/ugN2jUugdg2zbnfZSwutz5X+dCKFUaizCY23782o4vCe67Uaof1m5BreZHQQBDqu
         N1iphBzR+2d5Yth2nCLKM6MjTm+aDRVu2p1FkVSWDa1c+KOS0cmJWmqdA7Ium5bSi89n
         hU8aFq4oc0jtZNfAt0ORk2YqKEX0SOzROEGfDdUnUVEHBdmvBAt6lWnd5Qeb9RJONvLa
         9M6g0hX2y2k8qgcearWRx1YanaC0yHsN9uXqD9Zq5b+D/j9iGpxAZZcpkBoSl0MG0Ea+
         uG5Q==
X-Gm-Message-State: ACrzQf2RIWqC1qZyNceyATo/MnZNbREfxXCgbPghSPfGIKTgID5x3Bd+
        ZRqFyEsj/CEEOZBZkK+o2z+8HQTRfObx
X-Google-Smtp-Source: AMsMyM42zx4e0ldkmZ8VfFZwkpBXv0EJau1GuesU0gw0G2x1F/+cW2KwDRUILTfOeEeqRXXQNIKhvdv11AHm
X-Received: from dvyukov-desk.muc.corp.google.com ([2a00:79e0:9c:201:9511:b66:ed30:9ace])
 (user=dvyukov job=sendgmr) by 2002:a17:907:9627:b0:78d:a7d8:9407 with SMTP id
 gb39-20020a170907962700b0078da7d89407mr8197562ejc.675.1667140164602; Sun, 30
 Oct 2022 07:29:24 -0700 (PDT)
Date:   Sun, 30 Oct 2022 15:29:19 +0100
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221030142919.3196780-1-dvyukov@google.com>
Subject: [PATCH] nfc: Allow to create multiple virtual nci devices
From:   Dmitry Vyukov <dvyukov@google.com>
To:     bongsu.jeon@samsung.com, krzysztof.kozlowski@linaro.org,
        netdev@vger.kernel.org
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
 drivers/nfc/virtual_ncidev.c | 143 ++++++++++++++++-------------------
 1 file changed, 66 insertions(+), 77 deletions(-)

diff --git a/drivers/nfc/virtual_ncidev.c b/drivers/nfc/virtual_ncidev.c
index 85c06dbb2c449..8c2836a174ba2 100644
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
@@ -41,31 +35,29 @@ static int virtual_nci_open(struct nci_dev *ndev)
 
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
-		kfree_skb(skb);
-		return 0;
-	}
+	struct virtual_nci_dev *vdev = nci_get_drvdata(ndev);
 
-	if (send_buff) {
-		mutex_unlock(&nci_mutex);
+	mutex_lock(&vdev->mtx);
+	if (vdev->send_buff) {
+		mutex_unlock(&vdev->mtx);
 		kfree_skb(skb);
 		return -1;
 	}
-	send_buff = skb_copy(skb, GFP_KERNEL);
-	mutex_unlock(&nci_mutex);
-	wake_up_interruptible(&wq);
+	vdev->send_buff = skb_copy(skb, GFP_KERNEL);
+	mutex_unlock(&vdev->mtx);
+	wake_up_interruptible(&vdev->wq);
 	consume_skb(skb);
 
 	return 0;
@@ -80,29 +72,30 @@ static const struct nci_ops virtual_nci_ops = {
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
@@ -111,6 +104,7 @@ static ssize_t virtual_ncidev_write(struct file *file,
 				    const char __user *buf,
 				    size_t count, loff_t *ppos)
 {
+	struct virtual_nci_dev *vdev = file->private_data;
 	struct sk_buff *skb;
 
 	skb = alloc_skb(count, GFP_KERNEL);
@@ -122,63 +116,57 @@ static ssize_t virtual_ncidev_write(struct file *file,
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
-
-		nci_unregister_device(ndev);
-		nci_free_device(ndev);
-
-		mutex_lock(&nci_mutex);
-	}
+	struct virtual_nci_dev *vdev = file->private_data;
 
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
@@ -199,14 +187,15 @@ static const struct file_operations virtual_ncidev_fops = {
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
 

base-commit: 02a97e02c64fb3245b84835cbbed1c3a3222e2f1
-- 
2.38.1.273.g43a17bfeac-goog

