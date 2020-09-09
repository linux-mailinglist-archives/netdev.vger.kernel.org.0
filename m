Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C98E262777
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 08:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbgIIG4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 02:56:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:10875 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725863AbgIIG4h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 02:56:37 -0400
IronPort-SDR: 2SvAl+G/BBmNFyTcPIeDYMX6xILvbkNkmw6PnVjtPAqkTH0xy7j0N0Bd1sA6tTkGyMdKdGU8Ro
 PPxLWr7PTyKg==
X-IronPort-AV: E=McAfee;i="6000,8403,9738"; a="146000131"
X-IronPort-AV: E=Sophos;i="5.76,408,1592895600"; 
   d="scan'208";a="146000131"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2020 23:56:34 -0700
IronPort-SDR: 5UP/sIfL/rWJEF3Ko3MrK1EBOkpl5CzTGdDbSw9ZvoV/o2a9F2zZoWAtExymUduV/YcJ6dFlR4
 nSD6w6q5KsyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,408,1592895600"; 
   d="scan'208";a="449094397"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.131])
  by orsmga004.jf.intel.com with ESMTP; 08 Sep 2020 23:56:32 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH] vhost_vdpa: remove unnecessary spin_lock in vhost_vring_call
Date:   Wed,  9 Sep 2020 14:52:34 +0800
Message-Id: <20200909065234.3313-1-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.18.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit removed unnecessary spin_locks in vhost_vring_call
and related operations. Because we manipulate irq offloading
contents in vhost_vdpa ioctl code path which is already
protected by dev mutex and vq mutex.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vhost/vdpa.c  | 8 +-------
 drivers/vhost/vhost.c | 3 ---
 drivers/vhost/vhost.h | 1 -
 3 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 3fab94f88894..bc679d0b7b87 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -97,26 +97,20 @@ static void vhost_vdpa_setup_vq_irq(struct vhost_vdpa *v, u16 qid)
 		return;
 
 	irq = ops->get_vq_irq(vdpa, qid);
-	spin_lock(&vq->call_ctx.ctx_lock);
 	irq_bypass_unregister_producer(&vq->call_ctx.producer);
-	if (!vq->call_ctx.ctx || irq < 0) {
-		spin_unlock(&vq->call_ctx.ctx_lock);
+	if (!vq->call_ctx.ctx || irq < 0)
 		return;
-	}
 
 	vq->call_ctx.producer.token = vq->call_ctx.ctx;
 	vq->call_ctx.producer.irq = irq;
 	ret = irq_bypass_register_producer(&vq->call_ctx.producer);
-	spin_unlock(&vq->call_ctx.ctx_lock);
 }
 
 static void vhost_vdpa_unsetup_vq_irq(struct vhost_vdpa *v, u16 qid)
 {
 	struct vhost_virtqueue *vq = &v->vqs[qid];
 
-	spin_lock(&vq->call_ctx.ctx_lock);
 	irq_bypass_unregister_producer(&vq->call_ctx.producer);
-	spin_unlock(&vq->call_ctx.ctx_lock);
 }
 
 static void vhost_vdpa_reset(struct vhost_vdpa *v)
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index b45519ca66a7..99f27ce982da 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -302,7 +302,6 @@ static void vhost_vring_call_reset(struct vhost_vring_call *call_ctx)
 {
 	call_ctx->ctx = NULL;
 	memset(&call_ctx->producer, 0x0, sizeof(struct irq_bypass_producer));
-	spin_lock_init(&call_ctx->ctx_lock);
 }
 
 static void vhost_vq_reset(struct vhost_dev *dev,
@@ -1637,9 +1636,7 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
 			break;
 		}
 
-		spin_lock(&vq->call_ctx.ctx_lock);
 		swap(ctx, vq->call_ctx.ctx);
-		spin_unlock(&vq->call_ctx.ctx_lock);
 		break;
 	case VHOST_SET_VRING_ERR:
 		if (copy_from_user(&f, argp, sizeof f)) {
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 9032d3c2a9f4..486dcf371e06 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -64,7 +64,6 @@ enum vhost_uaddr_type {
 struct vhost_vring_call {
 	struct eventfd_ctx *ctx;
 	struct irq_bypass_producer producer;
-	spinlock_t ctx_lock;
 };
 
 /* The virtqueue structure describes a queue attached to a device. */
-- 
2.18.4

