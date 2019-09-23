Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF977BAEB4
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 09:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405191AbfIWHuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 03:50:18 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:57472 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404826AbfIWHuR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Sep 2019 03:50:17 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D70204B363A47E3BE127;
        Mon, 23 Sep 2019 15:50:15 +0800 (CST)
Received: from use12-sp2.huawei.com (10.67.188.167) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.439.0; Mon, 23 Sep 2019 15:50:14 +0800
From:   wangxu <wangxu72@huawei.com>
To:     <jasowang@redhat.com>, <mst@redhat.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] vhost: It's better to use size_t for the 3rd parameter of vhost_exceeds_weight()
Date:   Mon, 23 Sep 2019 15:46:41 +0800
Message-ID: <1569224801-101248-1-git-send-email-wangxu72@huawei.com>
X-Mailer: git-send-email 1.8.5.6
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.188.167]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Xu <wangxu72@huawei.com>

Caller of vhost_exceeds_weight(..., total_len) in drivers/vhost/net.c
usually pass size_t total_len, which may be affected by rx/tx package.

Signed-off-by: Wang Xu <wangxu72@huawei.com>
---
 drivers/vhost/vhost.c | 4 ++--
 drivers/vhost/vhost.h | 7 ++++---
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 36ca2cf..159223a 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -412,7 +412,7 @@ static void vhost_dev_free_iovecs(struct vhost_dev *dev)
 }
 
 bool vhost_exceeds_weight(struct vhost_virtqueue *vq,
-			  int pkts, int total_len)
+			  int pkts, size_t total_len)
 {
 	struct vhost_dev *dev = vq->dev;
 
@@ -454,7 +454,7 @@ static size_t vhost_get_desc_size(struct vhost_virtqueue *vq,
 
 void vhost_dev_init(struct vhost_dev *dev,
 		    struct vhost_virtqueue **vqs, int nvqs,
-		    int iov_limit, int weight, int byte_weight)
+		    int iov_limit, int weight, size_t byte_weight)
 {
 	struct vhost_virtqueue *vq;
 	int i;
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index e9ed272..8d80389d 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -172,12 +172,13 @@ struct vhost_dev {
 	wait_queue_head_t wait;
 	int iov_limit;
 	int weight;
-	int byte_weight;
+	size_t byte_weight;
 };
 
-bool vhost_exceeds_weight(struct vhost_virtqueue *vq, int pkts, int total_len);
+bool vhost_exceeds_weight(struct vhost_virtqueue *vq, int pkts,
+			  size_t total_len);
 void vhost_dev_init(struct vhost_dev *, struct vhost_virtqueue **vqs,
-		    int nvqs, int iov_limit, int weight, int byte_weight);
+		    int nvqs, int iov_limit, int weight, size_t byte_weight);
 long vhost_dev_set_owner(struct vhost_dev *dev);
 bool vhost_dev_has_owner(struct vhost_dev *dev);
 long vhost_dev_check_owner(struct vhost_dev *);
-- 
1.8.5.6

