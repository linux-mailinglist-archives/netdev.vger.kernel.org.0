Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F36C29D977
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389723AbgJ1Wyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:54:50 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:16474 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389713AbgJ1Wyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:54:46 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f997e1e0000>; Wed, 28 Oct 2020 07:20:14 -0700
Received: from mtl-vdi-166.wap.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 28 Oct
 2020 14:20:08 +0000
Date:   Wed, 28 Oct 2020 16:20:04 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, <lingshan.zhu@intel.com>
Subject: [PATCH] vhost: Use mutex to protect vq_irq setup
Message-ID: <20201028142004.GA100353@mtl-vdi-166.wap.labs.mlnx>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1603894814; bh=1UqLxryNwpAoBkVqxCn+8MfW4GniDM/9EYbPYP3IOJ4=;
        h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
         Content-Disposition:User-Agent:X-Originating-IP:X-ClientProxiedBy;
        b=W+0RGDwY1l7fHb5lOSqguXXvdEXnvYtJar85ZogO08r/irrRUt7xlLMvY/ekW+Jj9
         Uh3++n3undl/blZoAXxiStMcr9ldMIWltaJNHDGMqAUkNtx8LfYI4svP7ZYVVdtAMP
         aMPmR/FNkc0qnjDrrJpp8pdGe4w7oSwvdc6Y5guNj6MzMSOLRMcwxyCVDbUD9T/OTL
         wTyLWnXIb0uvVVV2vFcNNzH3k9Iy1FFs+lcbku82wxluLK/Kj4UnReDiU6fvsuBasf
         GnwgoYLcb3RA77XVz4kquZngFe+0qIcl2snFH7yGxG8dalOonJcBV9eCRI1j+eo0LP
         z8vuI10EN9qVQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both irq_bypass_register_producer() and irq_bypass_unregister_producer()
require process context to run. Change the call context lock from
spinlock to mutex to protect the setup process to avoid deadlocks.

Fixes: 265a0ad8731d ("vhost: introduce vhost_vring_call")
Signed-off-by: Eli Cohen <elic@nvidia.com>
---
 drivers/vhost/vdpa.c  | 10 +++++-----
 drivers/vhost/vhost.c |  6 +++---
 drivers/vhost/vhost.h |  3 ++-
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index be783592fe58..0a744f2b6e76 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -98,26 +98,26 @@ static void vhost_vdpa_setup_vq_irq(struct vhost_vdpa *v, u16 qid)
 		return;
 
 	irq = ops->get_vq_irq(vdpa, qid);
-	spin_lock(&vq->call_ctx.ctx_lock);
+	mutex_lock(&vq->call_ctx.ctx_lock);
 	irq_bypass_unregister_producer(&vq->call_ctx.producer);
 	if (!vq->call_ctx.ctx || irq < 0) {
-		spin_unlock(&vq->call_ctx.ctx_lock);
+		mutex_unlock(&vq->call_ctx.ctx_lock);
 		return;
 	}
 
 	vq->call_ctx.producer.token = vq->call_ctx.ctx;
 	vq->call_ctx.producer.irq = irq;
 	ret = irq_bypass_register_producer(&vq->call_ctx.producer);
-	spin_unlock(&vq->call_ctx.ctx_lock);
+	mutex_unlock(&vq->call_ctx.ctx_lock);
 }
 
 static void vhost_vdpa_unsetup_vq_irq(struct vhost_vdpa *v, u16 qid)
 {
 	struct vhost_virtqueue *vq = &v->vqs[qid];
 
-	spin_lock(&vq->call_ctx.ctx_lock);
+	mutex_lock(&vq->call_ctx.ctx_lock);
 	irq_bypass_unregister_producer(&vq->call_ctx.producer);
-	spin_unlock(&vq->call_ctx.ctx_lock);
+	mutex_unlock(&vq->call_ctx.ctx_lock);
 }
 
 static void vhost_vdpa_reset(struct vhost_vdpa *v)
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 9ad45e1d27f0..938239e11455 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -302,7 +302,7 @@ static void vhost_vring_call_reset(struct vhost_vring_call *call_ctx)
 {
 	call_ctx->ctx = NULL;
 	memset(&call_ctx->producer, 0x0, sizeof(struct irq_bypass_producer));
-	spin_lock_init(&call_ctx->ctx_lock);
+	mutex_init(&call_ctx->ctx_lock);
 }
 
 static void vhost_vq_reset(struct vhost_dev *dev,
@@ -1650,9 +1650,9 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
 			break;
 		}
 
-		spin_lock(&vq->call_ctx.ctx_lock);
+		mutex_lock(&vq->call_ctx.ctx_lock);
 		swap(ctx, vq->call_ctx.ctx);
-		spin_unlock(&vq->call_ctx.ctx_lock);
+		mutex_unlock(&vq->call_ctx.ctx_lock);
 		break;
 	case VHOST_SET_VRING_ERR:
 		if (copy_from_user(&f, argp, sizeof f)) {
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 9032d3c2a9f4..e8855ea04205 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -64,7 +64,8 @@ enum vhost_uaddr_type {
 struct vhost_vring_call {
 	struct eventfd_ctx *ctx;
 	struct irq_bypass_producer producer;
-	spinlock_t ctx_lock;
+	/* protect vq irq setup */
+	struct mutex ctx_lock;
 };
 
 /* The virtqueue structure describes a queue attached to a device. */
-- 
2.27.0

