Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65BF523CCBA
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 18:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728382AbgHEQ73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 12:59:29 -0400
Received: from mga05.intel.com ([192.55.52.43]:36356 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728197AbgHEQ6G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Aug 2020 12:58:06 -0400
IronPort-SDR: r0cb1ZQZX6dLlWw2Ga5M2var144iy1E0LleoBlrYPIUvzCXQFT+Gsv6AA51+p2vjBHeYyJBeEh
 ZhtlEorFyx/A==
X-IronPort-AV: E=McAfee;i="6000,8403,9703"; a="237376266"
X-IronPort-AV: E=Sophos;i="5.75,436,1589266800"; 
   d="scan'208";a="237376266"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2020 04:42:21 -0700
IronPort-SDR: vNbn1vEX5/bKMuCyBYWNsn2Dbcj1dnl8nyAIPRWOxH/odcQoy7qUJGnkOeSSB0b3GEimUs6M4N
 QU5DANQ0Ryzg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,436,1589266800"; 
   d="scan'208";a="437142946"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.131])
  by orsmga004.jf.intel.com with ESMTP; 05 Aug 2020 04:42:18 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, eli@mellanox.com, shahafs@mellanox.com,
        parav@mellanox.com, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 2/2] vhost_vdpa: unified set_vq_irq() and update_vq_irq()
Date:   Wed,  5 Aug 2020 19:38:32 +0800
Message-Id: <20200805113832.3755-1-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.18.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit merge vhost_vdpa_update_vq_irq() logics into
vhost_vdpa_setup_vq_irq(), so that code are unified.

In vhost_vdpa_setup_vq_irq(), added checks for the existence
for get_vq_irq().

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vhost/vdpa.c | 28 ++++++----------------------
 1 file changed, 6 insertions(+), 22 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 26f166a8192e..044e1f54582a 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -122,8 +122,12 @@ static void vhost_vdpa_setup_vq_irq(struct vhost_vdpa *v, u16 qid)
 	struct vdpa_device *vdpa = v->vdpa;
 	int ret, irq;
 
-	spin_lock(&vq->call_ctx.ctx_lock);
+	if (!ops->get_vq_irq)
+		return;
+
 	irq = ops->get_vq_irq(vdpa, qid);
+	spin_lock(&vq->call_ctx.ctx_lock);
+	irq_bypass_unregister_producer(&vq->call_ctx.producer);
 	if (!vq->call_ctx.ctx || irq < 0) {
 		spin_unlock(&vq->call_ctx.ctx_lock);
 		return;
@@ -144,26 +148,6 @@ static void vhost_vdpa_unsetup_vq_irq(struct vhost_vdpa *v, u16 qid)
 	spin_unlock(&vq->call_ctx.ctx_lock);
 }
 
-static void vhost_vdpa_update_vq_irq(struct vhost_virtqueue *vq)
-{
-	spin_lock(&vq->call_ctx.ctx_lock);
-	/*
-	 * if it has a non-zero irq, means there is a
-	 * previsouly registered irq_bypass_producer,
-	 * we should update it when ctx (its token)
-	 * changes.
-	 */
-	if (!vq->call_ctx.producer.irq) {
-		spin_unlock(&vq->call_ctx.ctx_lock);
-		return;
-	}
-
-	irq_bypass_unregister_producer(&vq->call_ctx.producer);
-	vq->call_ctx.producer.token = vq->call_ctx.ctx;
-	irq_bypass_register_producer(&vq->call_ctx.producer);
-	spin_unlock(&vq->call_ctx.ctx_lock);
-}
-
 static void vhost_vdpa_reset(struct vhost_vdpa *v)
 {
 	struct vdpa_device *vdpa = v->vdpa;
@@ -452,7 +436,7 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 			cb.private = NULL;
 		}
 		ops->set_vq_cb(vdpa, idx, &cb);
-		vhost_vdpa_update_vq_irq(vq);
+		vhost_vdpa_setup_vq_irq(v, idx);
 		break;
 
 	case VHOST_SET_VRING_NUM:
-- 
2.18.4

