Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E91D521318
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 06:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbfEQEaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 00:30:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48292 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727731AbfEQEaW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 May 2019 00:30:22 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8D11F3086224;
        Fri, 17 May 2019 04:30:22 +0000 (UTC)
Received: from hp-dl380pg8-02.lab.eng.pek2.redhat.com (hp-dl380pg8-02.lab.eng.pek2.redhat.com [10.73.8.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DDD0F1001E61;
        Fri, 17 May 2019 04:30:15 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, stefanha@redhat.com
Subject: [PATCH V2 4/4] vhost: scsi: add weight support
Date:   Fri, 17 May 2019 00:29:52 -0400
Message-Id: <1558067392-11740-5-git-send-email-jasowang@redhat.com>
In-Reply-To: <1558067392-11740-1-git-send-email-jasowang@redhat.com>
References: <1558067392-11740-1-git-send-email-jasowang@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Fri, 17 May 2019 04:30:22 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch will check the weight and exit the loop if we exceeds the
weight. This is useful for preventing scsi kthread from hogging cpu
which is guest triggerable.

This addresses CVE-2019-3900.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Fixes: 057cbf49a1f0 ("tcm_vhost: Initial merge for vhost level target fabric driver")
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/scsi.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index d830579..3a59f47 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -918,7 +918,7 @@ static void vhost_scsi_submission_work(struct work_struct *work)
 	struct iov_iter in_iter, prot_iter, data_iter;
 	u64 tag;
 	u32 exp_data_len, data_direction;
-	int ret, prot_bytes;
+	int ret, prot_bytes, c = 0;
 	u16 lun;
 	u8 task_attr;
 	bool t10_pi = vhost_has_feature(vq, VIRTIO_SCSI_F_T10_PI);
@@ -938,7 +938,7 @@ static void vhost_scsi_submission_work(struct work_struct *work)
 
 	vhost_disable_notify(&vs->dev, vq);
 
-	for (;;) {
+	do {
 		ret = vhost_scsi_get_desc(vs, vq, &vc);
 		if (ret)
 			goto err;
@@ -1118,7 +1118,7 @@ static void vhost_scsi_submission_work(struct work_struct *work)
 			break;
 		else if (ret == -EIO)
 			vhost_scsi_send_bad_target(vs, vq, vc.head, vc.out);
-	}
+	} while (likely(!vhost_exceeds_weight(vq, ++c, 0)));
 out:
 	mutex_unlock(&vq->mutex);
 }
@@ -1177,7 +1177,7 @@ static void vhost_scsi_submission_work(struct work_struct *work)
 	} v_req;
 	struct vhost_scsi_ctx vc;
 	size_t typ_size;
-	int ret;
+	int ret, c = 0;
 
 	mutex_lock(&vq->mutex);
 	/*
@@ -1191,7 +1191,7 @@ static void vhost_scsi_submission_work(struct work_struct *work)
 
 	vhost_disable_notify(&vs->dev, vq);
 
-	for (;;) {
+	do {
 		ret = vhost_scsi_get_desc(vs, vq, &vc);
 		if (ret)
 			goto err;
@@ -1270,7 +1270,7 @@ static void vhost_scsi_submission_work(struct work_struct *work)
 			break;
 		else if (ret == -EIO)
 			vhost_scsi_send_bad_target(vs, vq, vc.head, vc.out);
-	}
+	} while (likely(!vhost_exceeds_weight(vq, ++c, 0)));
 out:
 	mutex_unlock(&vq->mutex);
 }
-- 
1.8.3.1

