Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4B2E3ECD77
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 06:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbhHPEHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 00:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbhHPEGs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 00:06:48 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F3EEC0613CF;
        Sun, 15 Aug 2021 21:06:18 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id n13-20020a17090a4e0d00b0017946980d8dso11358710pjh.5;
        Sun, 15 Aug 2021 21:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SRoGE6btz3FIzsoVU86GKd+sAIx4GipMBZ33HNO90os=;
        b=Pd9zk65/+kFF5GDGVDxQwpyZalbA3joiA6kVand7R7RU1uHhpsD7kaIuM3PCgxyhrz
         ooaT6q6u5i9zGkFo9PzovH1yiH3Mz0VXKar50oo/FkZanUZYZjfgWqD5qb+MdIm55O7m
         sSWJBHvftQ8oOjkF6g0+h6Ft0XmesX6jgxvyFYOXYkQYdav2SrMu6b1TfePXtoD53T5Y
         kkub9/FAtGHPp0h/6P6CA5zv1Sl+86MI4yJDpE+8TpuWfBh6V9x0KVMKA5/mhG31YYp1
         v5L5FjvnOBFEPOQ3oZl1kqDT9ex0cPn0W0P3rYvCx4kws6/rASYIBZDmiUoE+B1Sl9ao
         gV6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SRoGE6btz3FIzsoVU86GKd+sAIx4GipMBZ33HNO90os=;
        b=bJkL5DrgGpZKlEKbZgSY+m8PFCvQkETfzTfw7pTFUIXHqUkKC8IwWGkwMGBpHwy48V
         O62oWoaWBPL06pT+a7JtuLS3ueCGm4Zrkz68T6iZg59Ggx0Q0gy7i63iBNG51P7ZHfCt
         voI9H+9dMwKqvN50xD74gu5DlmbA7Uk/TpWyx3ONH7YdBQYL4zLBM7SoBkkzsTtDMI/C
         3MOLUS1geac0j/Zfo9qLBDhuEjlbRbBN1I9acmHLo6jRTJ3YDuovvILZemB8rWtj9WLM
         NUiKKabBLUcYxVQkQ6SHClqYusXFkPYRWkG8pNSeTqSyXxT/LXzfvlp22j5PUGgHoMdB
         zn1A==
X-Gm-Message-State: AOAM530muIVpU5AV5CKKKMOtb8te9kXJr3tST9oSdhKCBCkVChjC9hZg
        /xEC5b6VFfwpgrTmbEdFmzA=
X-Google-Smtp-Source: ABdhPJyOUpYN9GoJC+C8C2qZrzfUkPYDKbU61b/QtSTN8i0QTo860aLD7Xxl6TNxxcvcZOFhVaGZIg==
X-Received: by 2002:a17:90a:35e:: with SMTP id 30mr15452139pjf.160.1629086777396;
        Sun, 15 Aug 2021 21:06:17 -0700 (PDT)
Received: from ubuntu.localdomain ([182.226.226.37])
        by smtp.gmail.com with ESMTPSA id i6sm9436998pfa.44.2021.08.15.21.06.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Aug 2021 21:06:16 -0700 (PDT)
From:   bongsu.jeon2@gmail.com
To:     shuah@kernel.org, krzysztof.kozlowski@canonical.com
Cc:     netdev@vger.kernel.org, linux-nfc@lists.01.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: [PATCH net-next 1/3] nfc: Change the virtual NCI device driver to use Wait Queue
Date:   Sun, 15 Aug 2021 21:05:58 -0700
Message-Id: <20210816040600.175813-2-bongsu.jeon2@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816040600.175813-1-bongsu.jeon2@gmail.com>
References: <20210816040600.175813-1-bongsu.jeon2@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

In previous version, the user level virtual device application that used
this driver should have the polling scheme to read a NCI frame.
To remove this polling scheme, changed the driver code to use Wait Queue.

Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
---
 drivers/nfc/virtual_ncidev.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/nfc/virtual_ncidev.c b/drivers/nfc/virtual_ncidev.c
index 2ee0ec4bb739..1953904176a2 100644
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
@@ -76,12 +79,11 @@ static ssize_t virtual_ncidev_read(struct file *file, char __user *buf,
 {
 	size_t actual_len;
 
-	mutex_lock(&nci_mutex);
-	if (!send_buff) {
-		mutex_unlock(&nci_mutex);
+	wait_event_interruptible(wq, send_buff);
+	if (!send_buff)
 		return 0;
-	}
 
+	mutex_lock(&nci_mutex);
 	actual_len = min_t(size_t, count, send_buff->len);
 
 	if (copy_to_user(buf, send_buff->data, actual_len)) {
-- 
2.32.0

