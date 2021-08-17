Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 438B43EED78
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 15:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240077AbhHQN3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 09:29:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239905AbhHQN3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 09:29:10 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2258FC061764;
        Tue, 17 Aug 2021 06:28:37 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id u21-20020a17090a8915b02901782c36f543so5130942pjn.4;
        Tue, 17 Aug 2021 06:28:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wcNwkyqHnyOxur4uTjpp7x91gvUF6Xp/CC0LQ31yEz8=;
        b=Fes/h8guWo1SeIPktXNitT1SK2PYt3hOT4+ySFUpvR+oqczLSlhvtvC4bAGUj2vsvr
         vVq0DW+d5aRrdYIq+uSPhqx96S5RPbCM1jxctb+RxVy+pwFWxyQ3Fex18JBgTSZB39Mz
         GMlaoX3nhUsO9HFWYgWtNlsV9EIwDuttIu7lgrDHIATYwAq8S/zk0wS/lrMptOAYdmNV
         SqxIxQlVloDNvJ0pUTKBsQXq4fADQKwlK8Ft07EuLnNW2/GzXIh2ibERchlnnll6RIn1
         BBUy9AmMKgVeECwQ/o4JCKg5C4h/6mZo+qthUxSdaOS+9qvA45VtivPH49SeqH38naRb
         ISKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wcNwkyqHnyOxur4uTjpp7x91gvUF6Xp/CC0LQ31yEz8=;
        b=WWhw0gN0uvoxtUQtvW/ECmfxRvbft0Gc3JWuWb5HQlVxr8T/PrgUZOsb0Ka74S+9Ti
         Zqe/qpROBd0EHMguVi/JYlZv+tKVDU8KG8NbKSYLvdG518y8GUkZVBYwzh0eWLgx7AkO
         tefrbTEBM0CnHd2CPtCciwJl3mUgc0fWwifW0wi6jOxiMYFrNzxj8FloWH5iqbbX/QSZ
         Yze87dSWB5Ww7L4OK0FVJ/dc8qd/1XQ/SLvpR67TZlBGJphsT9KMdkcLCXZy7G9Cs+lR
         HqUW6ypBxnG4BbMtl2E9jjpjPtZvc7TfJeXuTeNY/BKnfhnz1qL8pMy6amPNWN8w5RpY
         nrqQ==
X-Gm-Message-State: AOAM532HxMO5ejk6+cochcPdnHiw2vyrIPYUk7A0uGkvrNs4wyuBd9+V
        1p/8SAeCElTocvwxp9cSLqQ=
X-Google-Smtp-Source: ABdhPJwDBkQ7wJ9HiGwi6g8wNAJnIXwdCjS5r+Xud+k7+V56KidoBT3/L2TVcvKde/Twutti806/Yg==
X-Received: by 2002:a05:6a00:8c7:b029:3a1:119b:736 with SMTP id s7-20020a056a0008c7b02903a1119b0736mr3780009pfu.52.1629206916759;
        Tue, 17 Aug 2021 06:28:36 -0700 (PDT)
Received: from ubuntu.localdomain ([182.226.226.37])
        by smtp.gmail.com with ESMTPSA id j6sm2791577pfi.220.2021.08.17.06.28.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 06:28:36 -0700 (PDT)
From:   bongsu.jeon2@gmail.com
To:     shuah@kernel.org, krzysztof.kozlowski@canonical.com
Cc:     netdev@vger.kernel.org, linux-nfc@lists.01.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: [PATCH v2 net-next 1/8] nfc: virtual_ncidev: Use wait queue instead of polling
Date:   Tue, 17 Aug 2021 06:28:11 -0700
Message-Id: <20210817132818.8275-2-bongsu.jeon2@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210817132818.8275-1-bongsu.jeon2@gmail.com>
References: <20210817132818.8275-1-bongsu.jeon2@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

In previous version, the user level virtual device application that used
this driver should have the polling scheme to read a NCI frame.
To remove this polling scheme, use Wait Queue.

Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
---
 drivers/nfc/virtual_ncidev.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/virtual_ncidev.c b/drivers/nfc/virtual_ncidev.c
index 2ee0ec4bb739..221fa3bb8705 100644
--- a/drivers/nfc/virtual_ncidev.c
+++ b/drivers/nfc/virtual_ncidev.c
@@ -10,6 +10,7 @@
 #include <linux/module.h>
 #include <linux/miscdevice.h>
 #include <linux/mutex.h>
+#include <linux/wait.h>
 #include <net/nfc/nci_core.h>
 
 enum virtual_ncidev_mode {
@@ -27,6 +28,7 @@ enum virtual_ncidev_mode {
 				 NFC_PROTO_ISO15693_MASK)
 
 static enum virtual_ncidev_mode state;
+static DECLARE_WAIT_QUEUE_HEAD(wq);
 static struct miscdevice miscdev;
 static struct sk_buff *send_buff;
 static struct nci_dev *ndev;
@@ -61,6 +63,7 @@ static int virtual_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
 	}
 	send_buff = skb_copy(skb, GFP_KERNEL);
 	mutex_unlock(&nci_mutex);
+	wake_up_interruptible(&wq);
 
 	return 0;
 }
@@ -77,9 +80,11 @@ static ssize_t virtual_ncidev_read(struct file *file, char __user *buf,
 	size_t actual_len;
 
 	mutex_lock(&nci_mutex);
-	if (!send_buff) {
+	while (!send_buff) {
 		mutex_unlock(&nci_mutex);
-		return 0;
+		if (wait_event_interruptible(wq, send_buff))
+			return -EFAULT;
+		mutex_lock(&nci_mutex);
 	}
 
 	actual_len = min_t(size_t, count, send_buff->len);
-- 
2.32.0

