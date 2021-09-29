Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC19041C815
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345152AbhI2PNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 11:13:12 -0400
Received: from smtp2.axis.com ([195.60.68.18]:4228 "EHLO smtp2.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345079AbhI2PNG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 11:13:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1632928285;
  x=1664464285;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EFIpbunJhnllJPsXEwPg7K/UgW6ZduAMd7ddna2m6Vo=;
  b=WxaTyNI9zHzve4/bWfcc5gyqdmds+b7+3V0bJDYC+T9SMwz0VxRhWhcc
   R9c4zRo7ZtdYXkwpInoCAAfX8QdckSZKh+5YFzkSU0gwIlBDkNJqIX5TW
   qWN7l4A1ApXXHKedzDACHtnKgFHeSXTs24sW8SVc+bB2TSZMjhS1Rw7v9
   djTVsLEV6zZsgb2x7i5SE1YrU5tTXC2vb+QchAPopYqjES8LQpJui824A
   +1piurBMepgFUFXJV3IqnhbAR8+nw6XS4oktPCBgQJ7gvjh9sMGHqVDC3
   XUJn21QBNk37tmAPL9cV5iSeTvAjr+hSR8KLQl3RzEF0coptUbyxKlHsX
   w==;
From:   Vincent Whitchurch <vincent.whitchurch@axis.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>
CC:     <kernel@axis.com>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>, <stefanha@redhat.com>,
        <sgarzare@redhat.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>
Subject: [RFC PATCH 01/10] vhost: scsi: use copy_to_iter()
Date:   Wed, 29 Sep 2021 17:11:10 +0200
Message-ID: <20210929151119.14778-2-vincent.whitchurch@axis.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210929151119.14778-1-vincent.whitchurch@axis.com>
References: <20210929151119.14778-1-vincent.whitchurch@axis.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use copy_to_iter() instead of __copy_to_user() when accessing the virtio
buffers as a preparation for supporting kernel-space buffers in vhost.

It also makes the code consistent since the driver is already using
copy_to_iter() in the other places it accesses the queued buffers.

Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
---
 drivers/vhost/scsi.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 532e204f2b1b..bcf53685439d 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -462,7 +462,7 @@ vhost_scsi_do_evt_work(struct vhost_scsi *vs, struct vhost_scsi_evt *evt)
 {
 	struct vhost_virtqueue *vq = &vs->vqs[VHOST_SCSI_VQ_EVT].vq;
 	struct virtio_scsi_event *event = &evt->event;
-	struct virtio_scsi_event __user *eventp;
+	struct iov_iter iov_iter;
 	unsigned out, in;
 	int head, ret;
 
@@ -499,9 +499,10 @@ vhost_scsi_do_evt_work(struct vhost_scsi *vs, struct vhost_scsi_evt *evt)
 		vs->vs_events_missed = false;
 	}
 
-	eventp = vq->iov[out].iov_base;
-	ret = __copy_to_user(eventp, event, sizeof(*event));
-	if (!ret)
+	iov_iter_init(&iov_iter, READ, &vq->iov[out], in, sizeof(*event));
+
+	ret = copy_to_iter(event, sizeof(*event), &iov_iter);
+	if (ret == sizeof(*event))
 		vhost_add_used_and_signal(&vs->dev, vq, head, 0);
 	else
 		vq_err(vq, "Faulted on vhost_scsi_send_event\n");
@@ -802,17 +803,18 @@ static void vhost_scsi_target_queue_cmd(struct vhost_scsi_cmd *cmd)
 static void
 vhost_scsi_send_bad_target(struct vhost_scsi *vs,
 			   struct vhost_virtqueue *vq,
-			   int head, unsigned out)
+			   int head, unsigned out, unsigned in)
 {
-	struct virtio_scsi_cmd_resp __user *resp;
 	struct virtio_scsi_cmd_resp rsp;
+	struct iov_iter iov_iter;
 	int ret;
 
+	iov_iter_init(&iov_iter, READ, &vq->iov[out], in, sizeof(rsp));
+
 	memset(&rsp, 0, sizeof(rsp));
 	rsp.response = VIRTIO_SCSI_S_BAD_TARGET;
-	resp = vq->iov[out].iov_base;
-	ret = __copy_to_user(resp, &rsp, sizeof(rsp));
-	if (!ret)
+	ret = copy_to_iter(&rsp, sizeof(rsp), &iov_iter);
+	if (ret == sizeof(rsp))
 		vhost_add_used_and_signal(&vs->dev, vq, head, 0);
 	else
 		pr_err("Faulted on virtio_scsi_cmd_resp\n");
@@ -1124,7 +1126,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 		if (ret == -ENXIO)
 			break;
 		else if (ret == -EIO)
-			vhost_scsi_send_bad_target(vs, vq, vc.head, vc.out);
+			vhost_scsi_send_bad_target(vs, vq, vc.head, vc.out, vc.in);
 	} while (likely(!vhost_exceeds_weight(vq, ++c, 0)));
 out:
 	mutex_unlock(&vq->mutex);
@@ -1347,7 +1349,7 @@ vhost_scsi_ctl_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 		if (ret == -ENXIO)
 			break;
 		else if (ret == -EIO)
-			vhost_scsi_send_bad_target(vs, vq, vc.head, vc.out);
+			vhost_scsi_send_bad_target(vs, vq, vc.head, vc.out, vc.in);
 	} while (likely(!vhost_exceeds_weight(vq, ++c, 0)));
 out:
 	mutex_unlock(&vq->mutex);
-- 
2.28.0

