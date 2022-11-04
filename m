Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE529619E0D
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 18:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiKDREg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 13:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231634AbiKDRE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 13:04:28 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154A7326E5
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 10:04:27 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-370624ca2e8so51400087b3.16
        for <netdev@vger.kernel.org>; Fri, 04 Nov 2022 10:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=RasSXULbk/kqVIo9om/BuLlJHeeno7gtcmXyU/JN+3I=;
        b=iMK0+v8PjkZSvNgtGWApzMKzvArVjQiTbGF/kloonDjqBXc99twgt6CbYyi/thycD4
         zW2srkWrF2OUWhRMhknZV9MhCEMul5X/me+BnLrQgvaaJd3XrTitt/WS0g36tNEdrilT
         SMLTkhDXSN3pUZVtLEor+2nEm416DGVAwpfCkTRh2MLoRBmiOStCPTCJoexA9sdnd/iE
         taNT+s+XTFyJyDn3VT7DQ2HevDBpd/V9fnfS7okZxWKPtjd60H3iU65DCsGp4UBpZfzA
         HHMYbemllN5maOrgclkmmorSPPhC6JgH5FyDYy7m7Zu9NIv28CxWn0GnOMPBVRXnDnG+
         uvhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RasSXULbk/kqVIo9om/BuLlJHeeno7gtcmXyU/JN+3I=;
        b=CUgbLUqyiHqHdxV8Y4MrOy3NUGi3o1jti9d6lmd7zcbX3wHMMtBp933Y7VpxbNW0eF
         oaGWhdYeF+1VF2SWO6JYPPBrPQrHuiE3oseWhRelJS/olcM+LPyFJ8n1wZSDKmbxtaKw
         r8tINrRKoPG4pSW0S9aYhfNDFJ5qF+O42j7/S/sl4wC6x6iDnZAv88q27B8sK31Jesoi
         TVUF6hP0lPCPu5V/v74Vz6yP+GjhIBi9wMX5Vxtq3yyes+0dzuRmf+YvBoYzf7a7hcEE
         FPNOPeIoI3NaRPpiS332ltOQCUMz/OkVS75s7t+zR2oso2zmoMJES9TR5oAFY8JvL+r9
         iJKg==
X-Gm-Message-State: ACrzQf0/XA+KYLreSe3vI66F0sHV86i7FDxbjS1VwWgyMeLnvYRhLPbn
        gEnbv6vLtSHjJ5+k6Lw2szfPGPf6rUIK
X-Google-Smtp-Source: AMsMyM7MtWCPpnfAB+mhwEyVtRwSHONjc8FXNkx5gRXe51a5XbA1962hSJ0zbTEJo8DZyfFU2GPTNAzjTnIm
X-Received: from dvyukov-desk.muc.corp.google.com ([2a00:79e0:9c:201:9f98:375e:323b:bb91])
 (user=dvyukov job=sendgmr) by 2002:a0d:f383:0:b0:36a:40d7:8847 with SMTP id
 c125-20020a0df383000000b0036a40d78847mr323676ywf.236.1667581466351; Fri, 04
 Nov 2022 10:04:26 -0700 (PDT)
Date:   Fri,  4 Nov 2022 18:04:22 +0100
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221104170422.979558-1-dvyukov@google.com>
Subject: [PATCH net-next v3] nfc: Allow to create multiple virtual nci devices
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
 

base-commit: d9095f92950bd16745b9ec24ebebc12d14b3a3e8
-- 
2.38.1.431.g37b22c650d-goog

