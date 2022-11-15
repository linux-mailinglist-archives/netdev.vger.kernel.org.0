Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E77AF62951E
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 11:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbiKOKAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 05:00:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238216AbiKOKAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 05:00:23 -0500
Received: from mail-ed1-x54a.google.com (mail-ed1-x54a.google.com [IPv6:2a00:1450:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E45240B2
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 02:00:21 -0800 (PST)
Received: by mail-ed1-x54a.google.com with SMTP id f17-20020a056402355100b00466481256f6so9699352edd.19
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 02:00:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DYi10Hk8qGIFbCMCgggo6PPNZwx68QiyzTeeMvDd1vI=;
        b=mXwqVkLhK+XlXfKDFf/ymQD//jdHKo4eCG88zANsba5PCzSvlHjA449BvfwE9+Ht0C
         ZfHQHi7IGCGxiVwjdWnEEeflwKYXedc2QcogYa08a/03W92GA5AuQCOHQ8tYaxd2F+nL
         J8r+Q3EGNhJePM6SJ4LWVFe/vU1GUmN8ZoucxWMNbQKaRRv0iEJsMMKsCdZsJsT+2O1J
         eVDMOIF3GFXgRM9ygwJkCsMftABnxNqQu/B1g9UniboykSTfKfDL6vD4Cc45uJEdEJIp
         +PdjPUk37QS3ItqzrpGaCFZosk8ZU4v1oUrFeaTF2Yesazbq3MVTNNnXBISoW1O2QUl7
         GvbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DYi10Hk8qGIFbCMCgggo6PPNZwx68QiyzTeeMvDd1vI=;
        b=xgfA0CxxAAz3HocSeHfwFAKq4zGwcDlnszqp+2jdLMfVzQbHTCHJpSjMU438S0/rQj
         81Y/eoVdWHmqG3klnldMQ7OixU65UNrNt0E21xNtnmuqU3uVVIKjwVF5UkiZ838hEp9V
         Z4ECyxlKpjXwlQJz7h+6rGdGUTLNyoHlIKHPjVoIwU5DMNl8V5cjifDi3ETsrpBP118E
         1fUnraZ8/3GBr+FvzE5IVZCkxrjx5A4+176tdH4auxtnLVU1YOxrwUs/fd1R3d+trEig
         f78C1aL98C3/xyh0Us+z97vYuY6XztTrHuseZqvsu06EaP+u6TrY4qQZdkrzTTtw2+as
         e/vQ==
X-Gm-Message-State: ANoB5pnWzuMHXL3PkjYDMzV7KMMMARA4BxBRX4bN6cInMMkOn24UBfcF
        RlQZMkCLKFFWS++0NSNHTz5GV9OKA+0O
X-Google-Smtp-Source: AA0mqf4ab5zl7ZUDdutZs1jl24gjJXKInVJB3vluj+gthcjTRtYJscoo6WfpJ1ifMnygjZlNL7dBKFoxZOBY
X-Received: from dvyukov-desk.muc.corp.google.com ([2a00:79e0:9c:201:45dd:dca2:ac94:b937])
 (user=dvyukov job=sendgmr) by 2002:aa7:ce03:0:b0:461:72cb:e5d with SMTP id
 d3-20020aa7ce03000000b0046172cb0e5dmr14299566edv.410.1668506420449; Tue, 15
 Nov 2022 02:00:20 -0800 (PST)
Date:   Tue, 15 Nov 2022 11:00:17 +0100
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221115100017.787929-1-dvyukov@google.com>
Subject: [PATCH net-next v4] NFC: nci: Allow to create multiple virtual nci devices
From:   Dmitry Vyukov <dvyukov@google.com>
To:     leon@kernel.org, bongsu.jeon@samsung.com,
        krzysztof.kozlowski@linaro.org, netdev@vger.kernel.org
Cc:     syzkaller@googlegroups.com, Dmitry Vyukov <dvyukov@google.com>,
        Jakub Kicinski <kuba@kernel.org>
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
Reviewed-by: Bongsu Jeon <bongsu.jeon@samsung.com>
Cc: Bongsu Jeon <bongsu.jeon@samsung.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org

---
Changes in v4:
 - add Reviewed-by tag
 - rebase onto currnet net-next

Changes in v3:
 - free vdev in virtual_ncidev_close()

Changes in v2:
 - check return value of skb_clone()
 - rebase onto currnet net-next
---
 drivers/nfc/virtual_ncidev.c | 147 +++++++++++++++++------------------
 1 file changed, 71 insertions(+), 76 deletions(-)

diff --git a/drivers/nfc/virtual_ncidev.c b/drivers/nfc/virtual_ncidev.c
index 85c06dbb2c449..bb76c7c7cc822 100644
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
@@ -122,63 +121,58 @@ static ssize_t virtual_ncidev_write(struct file *file,
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
+		nci_free_device(vdev->ndev);
+		mutex_destroy(&vdev->mtx);
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
+	kfree(vdev);
 
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
@@ -199,14 +193,15 @@ static const struct file_operations virtual_ncidev_fops = {
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
 

base-commit: f12ed9c04804eec4f1819097a0fd0b4800adac2f
-- 
2.38.1.431.g37b22c650d-goog

