Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED28E6BAB1
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 12:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732866AbfGQKx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 06:53:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45078 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732701AbfGQKx6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jul 2019 06:53:58 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 31DF886674;
        Wed, 17 Jul 2019 10:53:58 +0000 (UTC)
Received: from hp-dl380pg8-01.lab.eng.pek2.redhat.com (hp-dl380pg8-01.lab.eng.pek2.redhat.com [10.73.8.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 435DC1001DC0;
        Wed, 17 Jul 2019 10:53:55 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jfreimann@redhat.com, tiwei.bie@intel.com,
        maxime.coquelin@redhat.com
Subject: [PATCH V3 11/15] vhost: do not use vring_used_elem
Date:   Wed, 17 Jul 2019 06:52:51 -0400
Message-Id: <20190717105255.63488-12-jasowang@redhat.com>
In-Reply-To: <20190717105255.63488-1-jasowang@redhat.com>
References: <20190717105255.63488-1-jasowang@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Wed, 17 Jul 2019 10:53:58 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of depending on the exported vring_used_elem, this patch
switches to use a new internal structure vhost_used_elem which embed
vring_used_elem in itself. This could be used to let vhost to record
extra metadata for the incoming packed ring layout.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/net.c   | 10 +++++-----
 drivers/vhost/scsi.c  |  8 ++++----
 drivers/vhost/vhost.c | 38 +++++++++++++++++++++++---------------
 drivers/vhost/vhost.h | 21 +++++++++++++++------
 drivers/vhost/vsock.c |  4 ++--
 5 files changed, 49 insertions(+), 32 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 572d80c8c36e..7c2f320930c7 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -546,7 +546,7 @@ static void vhost_net_busy_poll(struct vhost_net *net,
 }
 
 static int vhost_net_tx_get_vq_desc(struct vhost_net *net,
-				    struct vring_used_elem *used_elem,
+				    struct vhost_used_elem *used_elem,
 				    unsigned int *out_num, unsigned int *in_num,
 				    struct msghdr *msghdr, bool *busyloop_intr)
 {
@@ -596,7 +596,7 @@ static size_t init_iov_iter(struct vhost_virtqueue *vq, struct iov_iter *iter,
 }
 
 static int get_tx_bufs(struct vhost_net *net,
-		       struct vring_used_elem *used_elem,
+		       struct vhost_used_elem *used_elem,
 		       struct vhost_net_virtqueue *nvq,
 		       struct msghdr *msg,
 		       unsigned int *out, unsigned int *in,
@@ -752,7 +752,7 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
 {
 	struct vhost_net_virtqueue *nvq = &net->vqs[VHOST_NET_VQ_TX];
 	struct vhost_virtqueue *vq = &nvq->vq;
-	struct vring_used_elem used;
+	struct vhost_used_elem used;
 	unsigned out, in;
 	struct msghdr msg = {
 		.msg_name = NULL,
@@ -847,7 +847,7 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
 		.msg_flags = MSG_DONTWAIT,
 	};
 	struct tun_msg_ctl ctl;
-	struct vring_used_elem used;
+	struct vhost_used_elem used;
 	size_t len, total_len = 0;
 	int err;
 	struct vhost_net_ubuf_ref *uninitialized_var(ubufs);
@@ -1027,7 +1027,7 @@ static int get_rx_bufs(struct vhost_virtqueue *vq,
 	 * datalen > 0.
 	 */
 	u32 uninitialized_var(len);
-	struct vring_used_elem uninitialized_var(used);
+	struct vhost_used_elem uninitialized_var(used);
 
 	while (datalen > 0 && headcount < quota) {
 		if (unlikely(seg >= UIO_MAXIOV)) {
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 4a5a75ab25ad..42c32612dc32 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -72,7 +72,7 @@ struct vhost_scsi_inflight {
 
 struct vhost_scsi_cmd {
 	/* Descriptor from vhost_get_vq_desc() for virt_queue segment */
-	struct vring_used_elem tvc_vq_used;
+	struct vhost_used_elem tvc_vq_used;
 	/* virtio-scsi initiator task attribute */
 	int tvc_task_attr;
 	/* virtio-scsi response incoming iovecs */
@@ -213,7 +213,7 @@ struct vhost_scsi {
  * Context for processing request and control queue operations.
  */
 struct vhost_scsi_ctx {
-	struct vring_used_elem head;
+	struct vhost_used_elem head;
 	unsigned int out, in;
 	size_t req_size, rsp_size;
 	size_t out_size, in_size;
@@ -449,7 +449,7 @@ vhost_scsi_do_evt_work(struct vhost_scsi *vs, struct vhost_scsi_evt *evt)
 	struct vhost_virtqueue *vq = &vs->vqs[VHOST_SCSI_VQ_EVT].vq;
 	struct virtio_scsi_event *event = &evt->event;
 	struct virtio_scsi_event __user *eventp;
-	struct vring_used_elem used;
+	struct vhost_used_elem used;
 	unsigned out, in;
 	int ret;
 
@@ -821,7 +821,7 @@ vhost_scsi_get_desc(struct vhost_scsi *vs, struct vhost_virtqueue *vq,
 				NULL, NULL);
 
 	pr_debug("vhost_get_vq_desc: head: %d, out: %u in: %u\n",
-		 vc->head.id, vc->out, vc->in);
+		 vc->head.elem.id, vc->out, vc->in);
 
 	/* Nothing new?  Wait for eventfd to tell us they refilled. */
 	if (ret == -ENOSPC) {
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index dbe4db0179a5..6044cdea124f 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2651,7 +2651,7 @@ static int get_indirect(struct vhost_virtqueue *vq,
  * never a valid descriptor number) if none was found.  A negative code is
  * returned on error. */
 int vhost_get_vq_desc(struct vhost_virtqueue *vq,
-		      struct vring_used_elem *used,
+		      struct vhost_used_elem *used,
 		      struct iovec iov[], unsigned int iov_size,
 		      unsigned int *out_num, unsigned int *in_num,
 		      struct vhost_log *log, unsigned int *log_num)
@@ -2701,7 +2701,7 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
 		return -EFAULT;
 	}
 
-	used->id = ring_head;
+	used->elem.id = ring_head;
 	head = vhost16_to_cpu(vq, ring_head);
 
 	/* If their number is silly, that's an error. */
@@ -2793,13 +2793,20 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
 }
 EXPORT_SYMBOL_GPL(vhost_get_vq_desc);
 
-static void vhost_set_used_len(struct vhost_virtqueue *vq,
-			       struct vring_used_elem *used, int len)
+void vhost_set_used_len(struct vhost_virtqueue *vq,
+			struct vhost_used_elem *used, int len)
 {
-	used->len = cpu_to_vhost32(vq, len);
+	used->elem.len = cpu_to_vhost32(vq, len);
 }
 EXPORT_SYMBOL_GPL(vhost_set_used_len);
 
+__virtio32 vhost_get_used_len(struct vhost_virtqueue *vq,
+			      struct vhost_used_elem *used)
+{
+	return vhost32_to_cpu(vq, used->elem.len);
+}
+EXPORT_SYMBOL_GPL(vhost_get_used_len);
+
 static void vhost_withdraw_shadow_used(struct vhost_virtqueue *vq, int count)
 {
 	BUG_ON(count > vq->nheads);
@@ -2824,9 +2831,10 @@ void vhost_discard_vq_desc(struct vhost_virtqueue *vq, int n)
 EXPORT_SYMBOL_GPL(vhost_discard_vq_desc);
 
 static int __vhost_add_used_n(struct vhost_virtqueue *vq,
-			    struct vring_used_elem *heads,
+			    struct vhost_used_elem *shadow,
 			    unsigned count)
 {
+	struct vring_used_elem *heads = (struct vring_used_elem *)shadow;
 	struct vring_used_elem __user *used;
 	u16 old, new;
 	int start;
@@ -2858,18 +2866,18 @@ static int __vhost_add_used_n(struct vhost_virtqueue *vq,
 void vhost_set_zc_used_len(struct vhost_virtqueue *vq,
 			       int idx, int len)
 {
-	vq->heads[idx].len = len;
+	vq->heads[idx].elem.len = len;
 }
 EXPORT_SYMBOL_GPL(vhost_set_zc_used_len);
 
 int vhost_get_zc_used_len(struct vhost_virtqueue *vq, int idx)
 {
-	return vq->heads[idx].len;
+	return vq->heads[idx].elem.len;
 }
 EXPORT_SYMBOL_GPL(vhost_get_zc_used_len);
 
-void vhost_set_zc_used(struct vhost_virtqueue *vq,
-		       int idx, struct vring_used_elem *elem, int len)
+void vhost_set_zc_used(struct vhost_virtqueue *vq, int idx,
+		       struct vhost_used_elem *elem, int len)
 {
 	vq->heads[idx] = *elem;
 	vhost_set_zc_used_len(vq, idx, len);
@@ -2877,7 +2885,7 @@ void vhost_set_zc_used(struct vhost_virtqueue *vq,
 EXPORT_SYMBOL_GPL(vhost_set_zc_used);
 
 void vhost_add_shadow_used(struct vhost_virtqueue *vq,
-			   struct vring_used_elem *elem, int len)
+			   struct vhost_used_elem *elem, int len)
 {
 	vhost_set_zc_used(vq, vq->nheads, elem, len);
 	++vq->nheads;
@@ -2893,7 +2901,7 @@ EXPORT_SYMBOL_GPL(vhost_get_shadow_used_count);
 /* After we've used one of their buffers, we tell them about it.  We'll then
  * want to notify the guest, using eventfd. */
 static int vhost_add_used_n(struct vhost_virtqueue *vq,
-			    struct vring_used_elem *heads,
+			    struct vhost_used_elem *heads,
 			    unsigned count)
 {
 	int start, n, r;
@@ -2930,7 +2938,7 @@ EXPORT_SYMBOL_GPL(vhost_add_used_n);
 
 /* After we've used one of their buffers, we tell them about it.  We'll then
  * want to notify the guest, using eventfd. */
-int vhost_add_used(struct vhost_virtqueue *vq, struct vring_used_elem *used,
+int vhost_add_used(struct vhost_virtqueue *vq, struct vhost_used_elem *used,
 		   int len)
 {
 	vhost_set_used_len(vq, used, len);
@@ -2987,7 +2995,7 @@ EXPORT_SYMBOL_GPL(vhost_signal);
 /* And here's the combo meal deal.  Supersize me! */
 void vhost_add_used_and_signal(struct vhost_dev *dev,
 			       struct vhost_virtqueue *vq,
-			       struct vring_used_elem *used, int len)
+			       struct vhost_used_elem *used, int len)
 {
 	vhost_add_used(vq, used, len);
 	vhost_signal(dev, vq);
@@ -2997,7 +3005,7 @@ EXPORT_SYMBOL_GPL(vhost_add_used_and_signal);
 /* multi-buffer version of vhost_add_used_and_signal */
 static void vhost_add_used_and_signal_n(struct vhost_dev *dev,
 					struct vhost_virtqueue *vq,
-					struct vring_used_elem *heads,
+					struct vhost_used_elem *heads,
 					unsigned count)
 {
 	vhost_add_used_n(vq, heads, count);
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index f835eefa240c..b8a5d1a2bed9 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -37,6 +37,10 @@ struct vhost_poll {
 	struct vhost_dev	 *dev;
 };
 
+struct vhost_used_elem {
+	struct vring_used_elem elem;
+};
+
 void vhost_work_init(struct vhost_work *work, vhost_work_fn_t fn);
 void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work);
 bool vhost_has_work(struct vhost_dev *dev);
@@ -162,7 +166,7 @@ struct vhost_virtqueue {
 	struct iovec iov[UIO_MAXIOV];
 	struct iovec iotlb_iov[64];
 	struct iovec *indirect;
-	struct vring_used_elem *heads;
+	struct vhost_used_elem *heads;
 	int nheads;
 	/* Protected by virtqueue mutex. */
 	struct vhost_umem *umem;
@@ -233,17 +237,22 @@ bool vhost_vq_access_ok(struct vhost_virtqueue *vq);
 bool vhost_log_access_ok(struct vhost_dev *);
 
 int vhost_get_vq_desc(struct vhost_virtqueue *,
-		      struct vring_used_elem *used_elem,
+		      struct vhost_used_elem *used_elem,
 		      struct iovec iov[], unsigned int iov_count,
 		      unsigned int *out_num, unsigned int *in_num,
 		      struct vhost_log *log, unsigned int *log_num);
 void vhost_discard_vq_desc(struct vhost_virtqueue *, int n);
 
 int vhost_vq_init_access(struct vhost_virtqueue *);
-int vhost_add_used(struct vhost_virtqueue *, struct vring_used_elem *, int);
+int vhost_add_used(struct vhost_virtqueue *, struct vhost_used_elem *, int);
 
 void vhost_add_used_and_signal(struct vhost_dev *, struct vhost_virtqueue *,
-			       struct vring_used_elem *, int);
+			       struct vhost_used_elem *, int);
+
+__virtio32 vhost_get_used_len(struct vhost_virtqueue *vq,
+			      struct vhost_used_elem *used);
+void vhost_set_used_len(struct vhost_virtqueue *vq,
+			struct vhost_used_elem *used, int len);
 
 /* Zerocopy shadow used ring API */
 void vhost_set_zc_used_len(struct vhost_virtqueue *vq,
@@ -251,11 +260,11 @@ void vhost_set_zc_used_len(struct vhost_virtqueue *vq,
 int vhost_get_zc_used_len(struct vhost_virtqueue *vq, int idx);
 void vhost_flush_zc_used_and_signal(struct vhost_virtqueue *vq, int idx, int n);
 void vhost_set_zc_used(struct vhost_virtqueue *vq, int idx,
-		       struct vring_used_elem *elem, int len);
+		       struct vhost_used_elem *elem, int len);
 
 /* Non zerocopy shadow used ring API */
 void vhost_add_shadow_used(struct vhost_virtqueue *vq,
-			   struct vring_used_elem *elem, int len);
+			   struct vhost_used_elem *elem, int len);
 void vhost_flush_shadow_used_and_signal(struct vhost_virtqueue *vq);
 void vhost_discard_shadow_used(struct vhost_virtqueue *vq, int n);
 int vhost_get_shadow_used_count(struct vhost_virtqueue *vq);
diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 1c962bfdc3a1..a33e194499cf 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -100,7 +100,7 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 
 	do {
 		struct virtio_vsock_pkt *pkt;
-		struct vring_used_elem used;
+		struct vhost_used_elem used;
 		struct iov_iter iov_iter;
 		unsigned out, in;
 		size_t nbytes;
@@ -148,7 +148,7 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 			break;
 		}
 
-		len = vhost32_to_cpu(vq, used.len);
+		len = vhost_get_used_len(&used);
 		iov_iter_init(&iov_iter, READ, &vq->iov[out], in, len);
 
 		nbytes = copy_to_iter(&pkt->hdr, sizeof(pkt->hdr), &iov_iter);
-- 
2.18.1

