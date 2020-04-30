Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 890021BEE62
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 04:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbgD3Clv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 22:41:51 -0400
Received: from foss.arm.com ([217.140.110.172]:47946 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726180AbgD3Clv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 22:41:51 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 742771063;
        Wed, 29 Apr 2020 19:41:50 -0700 (PDT)
Received: from localhost.localdomain (entos-thunderx2-02.shanghai.arm.com [10.169.138.57])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D915F3F68F;
        Wed, 29 Apr 2020 19:41:47 -0700 (PDT)
From:   Jia He <justin.he@arm.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kaly.Xin@arm.com, Jia He <justin.he@arm.com>
Subject: [PATCH] vhost: add mutex_lock/unlock for vhost_vq_reset
Date:   Thu, 30 Apr 2020 10:41:40 +0800
Message-Id: <20200430024140.42065-1-justin.he@arm.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vq->mutex is to protect any vq accessing, hence adding mutex_lock/unlock
makes sense to avoid potential race condition.

Signed-off-by: Jia He <justin.he@arm.com>
---
 drivers/vhost/vhost.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index d450e16c5c25..622bfba2e5ab 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -297,6 +297,7 @@ static void vhost_vq_meta_reset(struct vhost_dev *d)
 static void vhost_vq_reset(struct vhost_dev *dev,
 			   struct vhost_virtqueue *vq)
 {
+	mutex_lock(&vq->mutex);
 	vq->num = 1;
 	vq->desc = NULL;
 	vq->avail = NULL;
@@ -323,6 +324,7 @@ static void vhost_vq_reset(struct vhost_dev *dev,
 	vq->umem = NULL;
 	vq->iotlb = NULL;
 	__vhost_vq_meta_reset(vq);
+	mutex_unlock(&vq->mutex);
 }
 
 static int vhost_worker(void *data)
-- 
2.17.1

