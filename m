Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24AFD323B7F
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 12:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235077AbhBXLuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 06:50:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234493AbhBXLt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 06:49:56 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28717C061574;
        Wed, 24 Feb 2021 03:49:16 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id o38so1269733pgm.9;
        Wed, 24 Feb 2021 03:49:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iKXu5MTD/qNOkcWSg8bnOE00gDFp+RLdj201NypZGkc=;
        b=KKBBnpxYRiqICn8VUoFHfqlpocIoktHL4QfBR1OT8Xvc1+/veBc+D5nj8QMdgbjEwK
         1yes/Xz/5+dBGfZfK5rBMgrvkm8wyTUv9ozrjZqeorOJwYfVaXIgvVOeaTxScEgm6uxe
         ShSM1T4kGf/HKJ7o92OvMPKvMd2MtMwNXJfpv4zWmtN4vZFk68JK9AeETv6DaSkPTaX2
         Q0eNTMfrQyKvVO3cB9nEzDjn+uugTxpR1NA/SAkxX9dttovsdlENoepSTauut08ZtS6D
         RIhc0TTMYYczzbwHhAkg659qMxVfsalOutdE5pYFZ7KFyMTQEQL71StaqkENpqS+OQ3X
         YjkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iKXu5MTD/qNOkcWSg8bnOE00gDFp+RLdj201NypZGkc=;
        b=jBR5EKN+RAZu9+d/+Mw8Ko/X5j/u7FZMe3lAG+5267MG1+J8SstH2PfBCdx+DmsXEi
         MQX+BjkaVsYiQtZEZ+AfxokNds97PIRUl18lYrc9oO9DqYFbSCdmbp5uHsyP1Ozy68q6
         XKN/RS10fwtPwjZclaqtXpLGmx5IE/iVf+qPbth+lJpdIMwzt/ypqkshgvwdsjpVqbLU
         gdXQDjVXUu/3ERS1T8fz/1nyBbx9h/YPBDPhIehqWEJs6hyfWAHrImqDGkfVlf0EMaHN
         E1134jmcY16kbhgQEJgXG/6bKml5lBehFHbOyxkY5QIYynEOi3bpti5ZbzJjRBaVvY3D
         72hQ==
X-Gm-Message-State: AOAM531QAYrBKid6nlhvoyluTFIFc7oziyMzvxg1SeLJYpfHywzeKUqs
        mqUaaVtbVH8CEv6FDoGXr9Xg0JBc1MplMLzv
X-Google-Smtp-Source: ABdhPJy6zT+ozN8jYuxk5CjeXkIK3JoA1vELHsGjU/enp38Jl4Qv64XF+ot1sMiM9QL4epMFQG0Dlw==
X-Received: by 2002:a05:6a00:16c7:b029:1bc:6eb9:ee47 with SMTP id l7-20020a056a0016c7b02901bc6eb9ee47mr32285893pfc.0.1614167355611;
        Wed, 24 Feb 2021 03:49:15 -0800 (PST)
Received: from ndr730u.nd.solarflarecom.com ([182.71.24.30])
        by smtp.googlemail.com with ESMTPSA id q23sm2533479pfl.123.2021.02.24.03.49.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Feb 2021 03:49:15 -0800 (PST)
From:   Gautam Dawar <gdawar.xilinx@gmail.com>
To:     mst@redhat.com
Cc:     martinh@xilinx.com, hanand@xilinx.com, gdawar@xilinx.com,
        Gautam Dawar <gdawar.xilinx@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] vhost_vdpa: fix the missing irq_bypass_unregister_producer() invocation
Date:   Wed, 24 Feb 2021 17:18:45 +0530
Message-Id: <20210224114845.104173-1-gdawar.xilinx@gmail.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When qemu with vhost-vdpa netdevice is run for the first time,
it works well. But after the VM is powered off, the next qemu run
causes kernel panic due to a NULL pointer dereference in
irq_bypass_register_producer().

When the VM is powered off, vhost_vdpa_clean_irq() misses on calling
irq_bypass_unregister_producer() for irq 0 because of the existing check.

This leaves stale producer nodes, which are reset in
vhost_vring_call_reset() when vhost_dev_init() is invoked during the
second qemu run.

As the node member of struct irq_bypass_producer is also initialized
to zero, traversal on the producers list causes crash due to NULL
pointer dereference.

Fixes: 2cf1ba9a4d15c ("vhost_vdpa: implement IRQ offloading in vhost_vdpa")
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=211711
Signed-off-by: Gautam Dawar <gdawar.xilinx@gmail.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/vdpa.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 62a9bb0efc55..e00573b87aba 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -844,14 +844,10 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 
 static void vhost_vdpa_clean_irq(struct vhost_vdpa *v)
 {
-	struct vhost_virtqueue *vq;
 	int i;
 
-	for (i = 0; i < v->nvqs; i++) {
-		vq = &v->vqs[i];
-		if (vq->call_ctx.producer.irq)
-			irq_bypass_unregister_producer(&vq->call_ctx.producer);
-	}
+	for (i = 0; i < v->nvqs; i++)
+		vhost_vdpa_unsetup_vq_irq(v, i);
 }
 
 static int vhost_vdpa_release(struct inode *inode, struct file *filep)
-- 
2.30.1

