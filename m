Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB834805D3
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 04:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234698AbhL1DJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 22:09:30 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:50906 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234588AbhL1DJ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 22:09:29 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=xianting.tian@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V00WRJo_1640660966;
Received: from localhost(mailfrom:xianting.tian@linux.alibaba.com fp:SMTPD_---0V00WRJo_1640660966)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 28 Dec 2021 11:09:27 +0800
From:   Xianting Tian <xianting.tian@linux.alibaba.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xianting Tian <xianting.tian@linux.alibaba.com>
Subject: [PATCH] vhost/test: fix memory leak of vhost virtqueues
Date:   Tue, 28 Dec 2021 11:09:24 +0800
Message-Id: <20211228030924.3468439-1-xianting.tian@linux.alibaba.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need free the vqs in .release(), which are allocated in .open().

Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
---
 drivers/vhost/test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
index a09dedc79..05740cba1 100644
--- a/drivers/vhost/test.c
+++ b/drivers/vhost/test.c
@@ -166,6 +166,7 @@ static int vhost_test_release(struct inode *inode, struct file *f)
 	/* We do an extra flush before freeing memory,
 	 * since jobs can re-queue themselves. */
 	vhost_test_flush(n);
+	kfree(n->dev.vqs);
 	kfree(n);
 	return 0;
 }
-- 
2.17.1

