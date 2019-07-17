Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A54EE6BA98
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 12:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730956AbfGQKxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 06:53:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34888 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbfGQKxR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jul 2019 06:53:17 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C5A428553A;
        Wed, 17 Jul 2019 10:53:16 +0000 (UTC)
Received: from hp-dl380pg8-01.lab.eng.pek2.redhat.com (hp-dl380pg8-01.lab.eng.pek2.redhat.com [10.73.8.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D765D1001DC0;
        Wed, 17 Jul 2019 10:53:13 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jfreimann@redhat.com, tiwei.bie@intel.com,
        maxime.coquelin@redhat.com
Subject: [PATCH V3 03/15] vhost: remove unnecessary parameter of vhost_enable_notify()/vhost_disable_notify
Date:   Wed, 17 Jul 2019 06:52:43 -0400
Message-Id: <20190717105255.63488-4-jasowang@redhat.com>
In-Reply-To: <20190717105255.63488-1-jasowang@redhat.com>
References: <20190717105255.63488-1-jasowang@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Wed, 17 Jul 2019 10:53:16 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Its dev parameter is not even used, so remove it.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/net.c   | 25 ++++++++++++-------------
 drivers/vhost/scsi.c  | 12 ++++++------
 drivers/vhost/test.c  |  6 +++---
 drivers/vhost/vhost.c |  4 ++--
 drivers/vhost/vhost.h |  4 ++--
 drivers/vhost/vsock.c | 14 +++++++-------
 6 files changed, 32 insertions(+), 33 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 7d34e8cbc89b..78d248574f8e 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -500,8 +500,8 @@ static void vhost_net_busy_poll_try_queue(struct vhost_net *net,
 {
 	if (!vhost_vq_avail_empty(vq)) {
 		vhost_poll_queue(&vq->poll);
-	} else if (unlikely(vhost_enable_notify(&net->dev, vq))) {
-		vhost_disable_notify(&net->dev, vq);
+	} else if (unlikely(vhost_enable_notify(vq))) {
+		vhost_disable_notify(vq);
 		vhost_poll_queue(&vq->poll);
 	}
 }
@@ -524,7 +524,7 @@ static void vhost_net_busy_poll(struct vhost_net *net,
 	if (!mutex_trylock(&vq->mutex))
 		return;
 
-	vhost_disable_notify(&net->dev, vq);
+	vhost_disable_notify(vq);
 	sock = rvq->private_data;
 
 	busyloop_timeout = poll_rx ? rvq->busyloop_timeout:
@@ -552,7 +552,7 @@ static void vhost_net_busy_poll(struct vhost_net *net,
 	if (poll_rx || sock_has_rx_data(sock))
 		vhost_net_busy_poll_try_queue(net, vq);
 	else if (!poll_rx) /* On tx here, sock has no rx data. */
-		vhost_enable_notify(&net->dev, rvq);
+		vhost_enable_notify(rvq);
 
 	mutex_unlock(&vq->mutex);
 }
@@ -788,9 +788,8 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
 		if (head == vq->num) {
 			if (unlikely(busyloop_intr)) {
 				vhost_poll_queue(&vq->poll);
-			} else if (unlikely(vhost_enable_notify(&net->dev,
-								vq))) {
-				vhost_disable_notify(&net->dev, vq);
+			} else if (unlikely(vhost_enable_notify(vq))) {
+				vhost_disable_notify(vq);
 				continue;
 			}
 			break;
@@ -880,8 +879,8 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
 		if (head == vq->num) {
 			if (unlikely(busyloop_intr)) {
 				vhost_poll_queue(&vq->poll);
-			} else if (unlikely(vhost_enable_notify(&net->dev, vq))) {
-				vhost_disable_notify(&net->dev, vq);
+			} else if (unlikely(vhost_enable_notify(vq))) {
+				vhost_disable_notify(vq);
 				continue;
 			}
 			break;
@@ -960,7 +959,7 @@ static void handle_tx(struct vhost_net *net)
 	if (!vq_meta_prefetch(vq))
 		goto out;
 
-	vhost_disable_notify(&net->dev, vq);
+	vhost_disable_notify(vq);
 	vhost_net_disable_vq(net, vq);
 
 	if (vhost_sock_zcopy(sock))
@@ -1129,7 +1128,7 @@ static void handle_rx(struct vhost_net *net)
 	if (!vq_meta_prefetch(vq))
 		goto out;
 
-	vhost_disable_notify(&net->dev, vq);
+	vhost_disable_notify(vq);
 	vhost_net_disable_vq(net, vq);
 
 	vhost_hlen = nvq->vhost_hlen;
@@ -1156,10 +1155,10 @@ static void handle_rx(struct vhost_net *net)
 		if (!headcount) {
 			if (unlikely(busyloop_intr)) {
 				vhost_poll_queue(&vq->poll);
-			} else if (unlikely(vhost_enable_notify(&net->dev, vq))) {
+			} else if (unlikely(vhost_enable_notify(vq))) {
 				/* They have slipped one in as we were
 				 * doing that: check again. */
-				vhost_disable_notify(&net->dev, vq);
+				vhost_disable_notify(vq);
 				continue;
 			}
 			/* Nothing new?  Wait for eventfd to tell us
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index a9caf1bc3c3e..8d4e87007a8d 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -458,7 +458,7 @@ vhost_scsi_do_evt_work(struct vhost_scsi *vs, struct vhost_scsi_evt *evt)
 	}
 
 again:
-	vhost_disable_notify(&vs->dev, vq);
+	vhost_disable_notify(vq);
 	head = vhost_get_vq_desc(vq, vq->iov,
 			ARRAY_SIZE(vq->iov), &out, &in,
 			NULL, NULL);
@@ -467,7 +467,7 @@ vhost_scsi_do_evt_work(struct vhost_scsi *vs, struct vhost_scsi_evt *evt)
 		return;
 	}
 	if (head == vq->num) {
-		if (vhost_enable_notify(&vs->dev, vq))
+		if (vhost_enable_notify(vq))
 			goto again;
 		vs->vs_events_missed = true;
 		return;
@@ -828,8 +828,8 @@ vhost_scsi_get_desc(struct vhost_scsi *vs, struct vhost_virtqueue *vq,
 
 	/* Nothing new?  Wait for eventfd to tell us they refilled. */
 	if (vc->head == vq->num) {
-		if (unlikely(vhost_enable_notify(&vs->dev, vq))) {
-			vhost_disable_notify(&vs->dev, vq);
+		if (unlikely(vhost_enable_notify(vq))) {
+			vhost_disable_notify(vq);
 			ret = -EAGAIN;
 		}
 		goto done;
@@ -936,7 +936,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 	memset(&vc, 0, sizeof(vc));
 	vc.rsp_size = sizeof(struct virtio_scsi_cmd_resp);
 
-	vhost_disable_notify(&vs->dev, vq);
+	vhost_disable_notify(vq);
 
 	do {
 		ret = vhost_scsi_get_desc(vs, vq, &vc);
@@ -1189,7 +1189,7 @@ vhost_scsi_ctl_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 
 	memset(&vc, 0, sizeof(vc));
 
-	vhost_disable_notify(&vs->dev, vq);
+	vhost_disable_notify(vq);
 
 	do {
 		ret = vhost_scsi_get_desc(vs, vq, &vc);
diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
index 40589850eb33..746f5d439153 100644
--- a/drivers/vhost/test.c
+++ b/drivers/vhost/test.c
@@ -50,7 +50,7 @@ static void handle_vq(struct vhost_test *n)
 		return;
 	}
 
-	vhost_disable_notify(&n->dev, vq);
+	vhost_disable_notify(vq);
 
 	for (;;) {
 		head = vhost_get_vq_desc(vq, vq->iov,
@@ -62,8 +62,8 @@ static void handle_vq(struct vhost_test *n)
 			break;
 		/* Nothing new?  Wait for eventfd to tell us they refilled. */
 		if (head == vq->num) {
-			if (unlikely(vhost_enable_notify(&n->dev, vq))) {
-				vhost_disable_notify(&n->dev, vq);
+			if (unlikely(vhost_enable_notify(vq))) {
+				vhost_disable_notify(vq);
 				continue;
 			}
 			break;
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index ec3534bcd51b..e781db88dfca 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2964,7 +2964,7 @@ bool vhost_vq_avail_empty(struct vhost_virtqueue *vq)
 EXPORT_SYMBOL_GPL(vhost_vq_avail_empty);
 
 /* OK, now we need to know about added descriptors. */
-bool vhost_enable_notify(struct vhost_dev *dev, struct vhost_virtqueue *vq)
+bool vhost_enable_notify(struct vhost_virtqueue *vq)
 {
 	__virtio16 avail_idx;
 	int r;
@@ -3002,7 +3002,7 @@ bool vhost_enable_notify(struct vhost_dev *dev, struct vhost_virtqueue *vq)
 EXPORT_SYMBOL_GPL(vhost_enable_notify);
 
 /* We don't need to be notified again. */
-void vhost_disable_notify(struct vhost_dev *dev, struct vhost_virtqueue *vq)
+void vhost_disable_notify(struct vhost_virtqueue *vq)
 {
 	int r;
 
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index e0451c900177..e054f178d8b0 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -246,9 +246,9 @@ void vhost_add_used_and_signal(struct vhost_dev *, struct vhost_virtqueue *,
 void vhost_add_used_and_signal_n(struct vhost_dev *, struct vhost_virtqueue *,
 			       struct vring_used_elem *heads, unsigned count);
 void vhost_signal(struct vhost_dev *, struct vhost_virtqueue *);
-void vhost_disable_notify(struct vhost_dev *, struct vhost_virtqueue *);
+void vhost_disable_notify(struct vhost_virtqueue *vq);
 bool vhost_vq_avail_empty(struct vhost_virtqueue *vq);
-bool vhost_enable_notify(struct vhost_dev *, struct vhost_virtqueue *);
+bool vhost_enable_notify(struct vhost_virtqueue *vq);
 
 int vhost_log_write(struct vhost_virtqueue *vq, struct vhost_log *log,
 		    unsigned int log_num, u64 len,
diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 814bed72d793..f94021b450f0 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -96,7 +96,7 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 		goto out;
 
 	/* Avoid further vmexits, we're already processing the virtqueue */
-	vhost_disable_notify(&vsock->dev, vq);
+	vhost_disable_notify(vq);
 
 	do {
 		struct virtio_vsock_pkt *pkt;
@@ -109,7 +109,7 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 		spin_lock_bh(&vsock->send_pkt_list_lock);
 		if (list_empty(&vsock->send_pkt_list)) {
 			spin_unlock_bh(&vsock->send_pkt_list_lock);
-			vhost_enable_notify(&vsock->dev, vq);
+			vhost_enable_notify(vq);
 			break;
 		}
 
@@ -135,8 +135,8 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 			/* We cannot finish yet if more buffers snuck in while
 			 * re-enabling notify.
 			 */
-			if (unlikely(vhost_enable_notify(&vsock->dev, vq))) {
-				vhost_disable_notify(&vsock->dev, vq);
+			if (unlikely(vhost_enable_notify(vq))) {
+				vhost_disable_notify(vq);
 				continue;
 			}
 			break;
@@ -369,7 +369,7 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
 	if (!vq->private_data)
 		goto out;
 
-	vhost_disable_notify(&vsock->dev, vq);
+	vhost_disable_notify(vq);
 	do {
 		u32 len;
 
@@ -387,8 +387,8 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
 			break;
 
 		if (head == vq->num) {
-			if (unlikely(vhost_enable_notify(&vsock->dev, vq))) {
-				vhost_disable_notify(&vsock->dev, vq);
+			if (unlikely(vhost_enable_notify(vq))) {
+				vhost_disable_notify(vq);
 				continue;
 			}
 			break;
-- 
2.18.1

