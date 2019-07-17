Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C06FF6BAAF
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 12:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732580AbfGQKx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 06:53:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48626 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731759AbfGQKxz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jul 2019 06:53:55 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BCBFB81F0E;
        Wed, 17 Jul 2019 10:53:54 +0000 (UTC)
Received: from hp-dl380pg8-01.lab.eng.pek2.redhat.com (hp-dl380pg8-01.lab.eng.pek2.redhat.com [10.73.8.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 912C21001B00;
        Wed, 17 Jul 2019 10:53:51 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jfreimann@redhat.com, tiwei.bie@intel.com,
        maxime.coquelin@redhat.com
Subject: [PATCH V3 10/15] vhost: hide used ring layout from device
Date:   Wed, 17 Jul 2019 06:52:50 -0400
Message-Id: <20190717105255.63488-11-jasowang@redhat.com>
In-Reply-To: <20190717105255.63488-1-jasowang@redhat.com>
References: <20190717105255.63488-1-jasowang@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Wed, 17 Jul 2019 10:53:54 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We used to return descriptor head by vhost_get_vq_desc() to device and
pass it back to vhost_add_used() and its friends. This exposes the
internal used ring layout to device which makes it hard to be extended for
e.g packed ring layout.

So this patch tries to hide the used ring layout by

- letting vhost_get_vq_desc() return pointer to struct vring_used_elem
- accepting pointer to struct vring_used_elem in vhost_add_used() and
  vhost_add_used_and_signal()

This could help to hide used ring layout and make it easier to
implement packed ring on top.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/net.c   | 88 ++++++++++++++++++++++---------------------
 drivers/vhost/scsi.c  | 62 ++++++++++++++++--------------
 drivers/vhost/vhost.c | 38 +++++++++++--------
 drivers/vhost/vhost.h | 11 +++---
 drivers/vhost/vsock.c | 43 +++++++++++----------
 5 files changed, 129 insertions(+), 113 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 9e087d08b199..572d80c8c36e 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -546,25 +546,28 @@ static void vhost_net_busy_poll(struct vhost_net *net,
 }
 
 static int vhost_net_tx_get_vq_desc(struct vhost_net *net,
-				    struct vhost_net_virtqueue *tnvq,
+				    struct vring_used_elem *used_elem,
 				    unsigned int *out_num, unsigned int *in_num,
 				    struct msghdr *msghdr, bool *busyloop_intr)
 {
+	struct vhost_net_virtqueue *tnvq = &net->vqs[VHOST_NET_VQ_TX];
 	struct vhost_net_virtqueue *rnvq = &net->vqs[VHOST_NET_VQ_RX];
 	struct vhost_virtqueue *rvq = &rnvq->vq;
 	struct vhost_virtqueue *tvq = &tnvq->vq;
 
-	int r = vhost_get_vq_desc(tvq, tvq->iov, ARRAY_SIZE(tvq->iov),
+	int r = vhost_get_vq_desc(tvq, used_elem, tvq->iov,
+				  ARRAY_SIZE(tvq->iov),
 				  out_num, in_num, NULL, NULL);
 
-	if (r == tvq->num && tvq->busyloop_timeout) {
+	if (r == -ENOSPC && tvq->busyloop_timeout) {
 		/* Flush batched packets first */
 		if (!vhost_sock_zcopy(tvq->private_data))
 			vhost_tx_batch(net, tnvq, tvq->private_data, msghdr);
 
 		vhost_net_busy_poll(net, rvq, tvq, busyloop_intr, false);
 
-		r = vhost_get_vq_desc(tvq, tvq->iov, ARRAY_SIZE(tvq->iov),
+		r = vhost_get_vq_desc(tvq, used_elem, tvq->iov,
+				      ARRAY_SIZE(tvq->iov),
 				      out_num, in_num, NULL, NULL);
 	}
 
@@ -593,6 +596,7 @@ static size_t init_iov_iter(struct vhost_virtqueue *vq, struct iov_iter *iter,
 }
 
 static int get_tx_bufs(struct vhost_net *net,
+		       struct vring_used_elem *used_elem,
 		       struct vhost_net_virtqueue *nvq,
 		       struct msghdr *msg,
 		       unsigned int *out, unsigned int *in,
@@ -601,9 +605,10 @@ static int get_tx_bufs(struct vhost_net *net,
 	struct vhost_virtqueue *vq = &nvq->vq;
 	int ret;
 
-	ret = vhost_net_tx_get_vq_desc(net, nvq, out, in, msg, busyloop_intr);
+	ret = vhost_net_tx_get_vq_desc(net, used_elem, out, in,
+				       msg, busyloop_intr);
 
-	if (ret < 0 || ret == vq->num)
+	if (ret < 0 || ret == -ENOSPC)
 		return ret;
 
 	if (*in) {
@@ -747,8 +752,8 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
 {
 	struct vhost_net_virtqueue *nvq = &net->vqs[VHOST_NET_VQ_TX];
 	struct vhost_virtqueue *vq = &nvq->vq;
+	struct vring_used_elem used;
 	unsigned out, in;
-	int head;
 	struct msghdr msg = {
 		.msg_name = NULL,
 		.msg_namelen = 0,
@@ -767,13 +772,11 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
 		if (vhost_get_shadow_used_count(vq) == VHOST_NET_BATCH)
 			vhost_tx_batch(net, nvq, sock, &msg);
 
-		head = get_tx_bufs(net, nvq, &msg, &out, &in, &len,
-				   &busyloop_intr);
-		/* On error, stop handling until the next kick. */
-		if (unlikely(head < 0))
-			break;
+		err = get_tx_bufs(net, &used,
+				  nvq, &msg, &out, &in, &len,
+				  &busyloop_intr);
 		/* Nothing new?  Wait for eventfd to tell us they refilled. */
-		if (head == vq->num) {
+		if (err == -ENOSPC) {
 			if (unlikely(busyloop_intr)) {
 				vhost_poll_queue(&vq->poll);
 			} else if (unlikely(vhost_enable_notify(vq))) {
@@ -782,7 +785,9 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
 			}
 			break;
 		}
-
+		/* On error, stop handling until the next kick. */
+		if (unlikely(err < 0))
+			break;
 		total_len += len;
 
 		/* For simplicity, TX batching is only enabled if
@@ -823,7 +828,7 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
 			pr_debug("Truncated TX packet: len %d != %zd\n",
 				 err, len);
 done:
-		vhost_add_shadow_used(vq, cpu_to_vhost32(vq, head), 0);
+		vhost_add_shadow_used(vq, &used, 0);
 	} while (likely(!vhost_exceeds_weight(vq, ++sent_pkts, total_len)));
 
 	vhost_tx_batch(net, nvq, sock, &msg);
@@ -834,7 +839,6 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
 	struct vhost_net_virtqueue *nvq = &net->vqs[VHOST_NET_VQ_TX];
 	struct vhost_virtqueue *vq = &nvq->vq;
 	unsigned out, in;
-	int head;
 	struct msghdr msg = {
 		.msg_name = NULL,
 		.msg_namelen = 0,
@@ -843,6 +847,7 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
 		.msg_flags = MSG_DONTWAIT,
 	};
 	struct tun_msg_ctl ctl;
+	struct vring_used_elem used;
 	size_t len, total_len = 0;
 	int err;
 	struct vhost_net_ubuf_ref *uninitialized_var(ubufs);
@@ -856,13 +861,10 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
 		vhost_zerocopy_signal_used(net, vq);
 
 		busyloop_intr = false;
-		head = get_tx_bufs(net, nvq, &msg, &out, &in, &len,
-				   &busyloop_intr);
-		/* On error, stop handling until the next kick. */
-		if (unlikely(head < 0))
-			break;
+		err = get_tx_bufs(net, &used, nvq, &msg, &out, &in, &len,
+				  &busyloop_intr);
 		/* Nothing new?  Wait for eventfd to tell us they refilled. */
-		if (head == vq->num) {
+		if (err == -ENOSPC) {
 			if (unlikely(busyloop_intr)) {
 				vhost_poll_queue(&vq->poll);
 			} else if (unlikely(vhost_enable_notify(vq))) {
@@ -871,6 +873,9 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
 			}
 			break;
 		}
+		/* On error, stop handling until the next kick. */
+		if (unlikely(err < 0))
+			break;
 
 		zcopy_used = len >= VHOST_GOODCOPY_LEN
 			     && !vhost_exceeds_maxpend(net)
@@ -895,7 +900,7 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
 			ubufs = NULL;
 		}
 		vhost_set_zc_used(vq, nvq->upend_idx,
-				  cpu_to_vhost32(vq, head),
+				  &used,
 				  zcopy_used ? VHOST_DMA_IN_PROGRESS :
 				  VHOST_DMA_DONE_LEN);
 		nvq->upend_idx = (nvq->upend_idx + 1) % UIO_MAXIOV;
@@ -921,7 +926,6 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
 		if (err != len)
 			pr_debug("Truncated TX packet: "
 				 " len %d != %zd\n", err, len);
-
 		vhost_zerocopy_signal_used(net, vq);
 		vhost_net_tx_packet(net);
 	} while (likely(!vhost_exceeds_weight(vq, ++sent_pkts, total_len)));
@@ -1012,34 +1016,30 @@ static int get_rx_bufs(struct vhost_virtqueue *vq,
 		       unsigned *iovcount,
 		       struct vhost_log *log,
 		       unsigned *log_num,
-		       unsigned int quota)
+		       unsigned int quota,
+		       s16 *count)
 {
 	unsigned int out, in;
 	int seg = 0;
 	int headcount = 0;
-	unsigned d;
-	int r, nlogs = 0;
+	int r = 0, nlogs = 0;
 	/* len is always initialized before use since we are always called with
 	 * datalen > 0.
 	 */
 	u32 uninitialized_var(len);
+	struct vring_used_elem uninitialized_var(used);
 
 	while (datalen > 0 && headcount < quota) {
 		if (unlikely(seg >= UIO_MAXIOV)) {
 			r = -ENOBUFS;
 			goto err;
 		}
-		r = vhost_get_vq_desc(vq, vq->iov + seg,
+		r = vhost_get_vq_desc(vq, &used, vq->iov + seg,
 				      ARRAY_SIZE(vq->iov) - seg, &out,
 				      &in, log, log_num);
 		if (unlikely(r < 0))
 			goto err;
 
-		d = r;
-		if (d == vq->num) {
-			r = 0;
-			goto err;
-		}
 		if (unlikely(out || in <= 0)) {
 			vq_err(vq, "unexpected descriptor format for RX: "
 				"out %d, in %d\n", out, in);
@@ -1052,7 +1052,7 @@ static int get_rx_bufs(struct vhost_virtqueue *vq,
 		}
 		len = iov_length(vq->iov + seg, in);
 		datalen -= len;
-		vhost_add_shadow_used(vq, cpu_to_vhost32(vq, d),
+		vhost_add_shadow_used(vq, &used,
 				      cpu_to_vhost32(vq, datalen >= 0 ? len
 						     : len + datalen));
 		++headcount;
@@ -1064,12 +1064,15 @@ static int get_rx_bufs(struct vhost_virtqueue *vq,
 
 	/* Detect overrun */
 	if (unlikely(datalen > 0)) {
-		r = UIO_MAXIOV + 1;
+		headcount = UIO_MAXIOV + 1;
 		goto err;
 	}
-	return headcount;
+
+	*count = headcount;
+	return 0;
 err:
 	vhost_discard_shadow_used(vq, headcount);
+	*count = 0;
 	return r;
 }
 
@@ -1128,13 +1131,11 @@ static void handle_rx(struct vhost_net *net)
 			break;
 		sock_len += sock_hlen;
 		vhost_len = sock_len + vhost_hlen;
-		headcount = get_rx_bufs(vq, vhost_len, &in, vq_log, &log,
-					likely(mergeable) ? UIO_MAXIOV : 1);
-		/* On error, stop handling until the next kick. */
-		if (unlikely(headcount < 0))
-			goto out;
+		err = get_rx_bufs(vq, vhost_len, &in, vq_log, &log,
+				  likely(mergeable) ? UIO_MAXIOV : 1,
+				  &headcount);
 		/* OK, now we need to know about added descriptors. */
-		if (!headcount) {
+		if (err == -ENOSPC) {
 			if (unlikely(busyloop_intr)) {
 				vhost_poll_queue(&vq->poll);
 			} else if (unlikely(vhost_enable_notify(vq))) {
@@ -1148,6 +1149,9 @@ static void handle_rx(struct vhost_net *net)
 			goto out;
 		}
 		busyloop_intr = false;
+		/* On error, stop handling until the next kick. */
+		if (unlikely(err < 0))
+			goto out;
 		if (nvq->rx_ring)
 			msg.msg_control = vhost_net_buf_consume(&nvq->rxq);
 		/* On overrun, truncate and discard */
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 8d4e87007a8d..4a5a75ab25ad 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -72,7 +72,7 @@ struct vhost_scsi_inflight {
 
 struct vhost_scsi_cmd {
 	/* Descriptor from vhost_get_vq_desc() for virt_queue segment */
-	int tvc_vq_desc;
+	struct vring_used_elem tvc_vq_used;
 	/* virtio-scsi initiator task attribute */
 	int tvc_task_attr;
 	/* virtio-scsi response incoming iovecs */
@@ -213,7 +213,7 @@ struct vhost_scsi {
  * Context for processing request and control queue operations.
  */
 struct vhost_scsi_ctx {
-	int head;
+	struct vring_used_elem head;
 	unsigned int out, in;
 	size_t req_size, rsp_size;
 	size_t out_size, in_size;
@@ -449,8 +449,9 @@ vhost_scsi_do_evt_work(struct vhost_scsi *vs, struct vhost_scsi_evt *evt)
 	struct vhost_virtqueue *vq = &vs->vqs[VHOST_SCSI_VQ_EVT].vq;
 	struct virtio_scsi_event *event = &evt->event;
 	struct virtio_scsi_event __user *eventp;
+	struct vring_used_elem used;
 	unsigned out, in;
-	int head, ret;
+	int ret;
 
 	if (!vq->private_data) {
 		vs->vs_events_missed = true;
@@ -459,16 +460,16 @@ vhost_scsi_do_evt_work(struct vhost_scsi *vs, struct vhost_scsi_evt *evt)
 
 again:
 	vhost_disable_notify(vq);
-	head = vhost_get_vq_desc(vq, vq->iov,
+	ret = vhost_get_vq_desc(vq, &used, vq->iov,
 			ARRAY_SIZE(vq->iov), &out, &in,
 			NULL, NULL);
-	if (head < 0) {
+	if (ret == -ENOSPC) {
+		if (vhost_enable_notify(&vs->dev, vq))
+			goto again;
 		vs->vs_events_missed = true;
 		return;
 	}
-	if (head == vq->num) {
-		if (vhost_enable_notify(vq))
-			goto again;
+	if (ret < 0) {
 		vs->vs_events_missed = true;
 		return;
 	}
@@ -488,7 +489,7 @@ vhost_scsi_do_evt_work(struct vhost_scsi *vs, struct vhost_scsi_evt *evt)
 	eventp = vq->iov[out].iov_base;
 	ret = __copy_to_user(eventp, event, sizeof(*event));
 	if (!ret)
-		vhost_add_used_and_signal(&vs->dev, vq, head, 0);
+		vhost_add_used_and_signal(&vs->dev, vq, &used, 0);
 	else
 		vq_err(vq, "Faulted on vhost_scsi_send_event\n");
 }
@@ -549,7 +550,7 @@ static void vhost_scsi_complete_cmd_work(struct vhost_work *work)
 		ret = copy_to_iter(&v_rsp, sizeof(v_rsp), &iov_iter);
 		if (likely(ret == sizeof(v_rsp))) {
 			struct vhost_scsi_virtqueue *q;
-			vhost_add_used(cmd->tvc_vq, cmd->tvc_vq_desc, 0);
+			vhost_add_used(cmd->tvc_vq, &cmd->tvc_vq_used, 0);
 			q = container_of(cmd->tvc_vq, struct vhost_scsi_virtqueue, vq);
 			vq = q - vs->vqs;
 			__set_bit(vq, signal);
@@ -793,7 +794,7 @@ static void vhost_scsi_submission_work(struct work_struct *work)
 static void
 vhost_scsi_send_bad_target(struct vhost_scsi *vs,
 			   struct vhost_virtqueue *vq,
-			   int head, unsigned out)
+			   struct vhost_scsi_ctx *vc)
 {
 	struct virtio_scsi_cmd_resp __user *resp;
 	struct virtio_scsi_cmd_resp rsp;
@@ -801,10 +802,10 @@ vhost_scsi_send_bad_target(struct vhost_scsi *vs,
 
 	memset(&rsp, 0, sizeof(rsp));
 	rsp.response = VIRTIO_SCSI_S_BAD_TARGET;
-	resp = vq->iov[out].iov_base;
+	resp = vq->iov[vc->out].iov_base;
 	ret = __copy_to_user(resp, &rsp, sizeof(rsp));
 	if (!ret)
-		vhost_add_used_and_signal(&vs->dev, vq, head, 0);
+		vhost_add_used_and_signal(&vs->dev, vq, &vc->head, 0);
 	else
 		pr_err("Faulted on virtio_scsi_cmd_resp\n");
 }
@@ -813,21 +814,17 @@ static int
 vhost_scsi_get_desc(struct vhost_scsi *vs, struct vhost_virtqueue *vq,
 		    struct vhost_scsi_ctx *vc)
 {
-	int ret = -ENXIO;
+	int ret;
 
-	vc->head = vhost_get_vq_desc(vq, vq->iov,
-				     ARRAY_SIZE(vq->iov), &vc->out, &vc->in,
-				     NULL, NULL);
+	ret = vhost_get_vq_desc(vq, &vc->head, vq->iov,
+				ARRAY_SIZE(vq->iov), &vc->out, &vc->in,
+				NULL, NULL);
 
 	pr_debug("vhost_get_vq_desc: head: %d, out: %u in: %u\n",
-		 vc->head, vc->out, vc->in);
-
-	/* On error, stop handling until the next kick. */
-	if (unlikely(vc->head < 0))
-		goto done;
+		 vc->head.id, vc->out, vc->in);
 
 	/* Nothing new?  Wait for eventfd to tell us they refilled. */
-	if (vc->head == vq->num) {
+	if (ret == -ENOSPC) {
 		if (unlikely(vhost_enable_notify(vq))) {
 			vhost_disable_notify(vq);
 			ret = -EAGAIN;
@@ -835,6 +832,10 @@ vhost_scsi_get_desc(struct vhost_scsi *vs, struct vhost_virtqueue *vq,
 		goto done;
 	}
 
+	/* On error, stop handling until the next kick. */
+	if (unlikely(ret < 0))
+		goto done;
+
 	/*
 	 * Get the size of request and response buffers.
 	 * FIXME: Not correct for BIDI operation
@@ -1025,6 +1026,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 					vq_err(vq, "Received non zero pi_bytesin,"
 						" but wrong data_direction\n");
 					goto err;
+
 				}
 				prot_bytes = vhost32_to_cpu(vq, v_req_pi.pi_bytesin);
 			}
@@ -1097,7 +1099,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 		 * complete the virtio-scsi request in TCM callback context via
 		 * vhost_scsi_queue_data_in() and vhost_scsi_queue_status()
 		 */
-		cmd->tvc_vq_desc = vc.head;
+		cmd->tvc_vq_used = vc.head;
 		/*
 		 * Dispatch cmd descriptor for cmwq execution in process
 		 * context provided by vhost_scsi_workqueue.  This also ensures
@@ -1117,8 +1119,10 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 		if (ret == -ENXIO)
 			break;
 		else if (ret == -EIO)
-			vhost_scsi_send_bad_target(vs, vq, vc.head, vc.out);
+			vhost_scsi_send_bad_target(vs, vq, &vc);
+
 	} while (likely(!vhost_exceeds_weight(vq, ++c, 0)));
+
 out:
 	mutex_unlock(&vq->mutex);
 }
@@ -1140,7 +1144,7 @@ vhost_scsi_send_tmf_reject(struct vhost_scsi *vs,
 
 	ret = copy_to_iter(&rsp, sizeof(rsp), &iov_iter);
 	if (likely(ret == sizeof(rsp)))
-		vhost_add_used_and_signal(&vs->dev, vq, vc->head, 0);
+		vhost_add_used_and_signal(&vs->dev, vq, &vc->head, 0);
 	else
 		pr_err("Faulted on virtio_scsi_ctrl_tmf_resp\n");
 }
@@ -1162,7 +1166,7 @@ vhost_scsi_send_an_resp(struct vhost_scsi *vs,
 
 	ret = copy_to_iter(&rsp, sizeof(rsp), &iov_iter);
 	if (likely(ret == sizeof(rsp)))
-		vhost_add_used_and_signal(&vs->dev, vq, vc->head, 0);
+		vhost_add_used_and_signal(&vs->dev, vq, &vc->head, 0);
 	else
 		pr_err("Faulted on virtio_scsi_ctrl_an_resp\n");
 }
@@ -1269,8 +1273,10 @@ vhost_scsi_ctl_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 		if (ret == -ENXIO)
 			break;
 		else if (ret == -EIO)
-			vhost_scsi_send_bad_target(vs, vq, vc.head, vc.out);
+			vhost_scsi_send_bad_target(vs, vq, &vc);
+
 	} while (likely(!vhost_exceeds_weight(vq, ++c, 0)));
+
 out:
 	mutex_unlock(&vq->mutex);
 }
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 50ba382f0981..dbe4db0179a5 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2651,6 +2651,7 @@ static int get_indirect(struct vhost_virtqueue *vq,
  * never a valid descriptor number) if none was found.  A negative code is
  * returned on error. */
 int vhost_get_vq_desc(struct vhost_virtqueue *vq,
+		      struct vring_used_elem *used,
 		      struct iovec iov[], unsigned int iov_size,
 		      unsigned int *out_num, unsigned int *in_num,
 		      struct vhost_log *log, unsigned int *log_num)
@@ -2683,7 +2684,7 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
 		 * invalid.
 		 */
 		if (vq->avail_idx == last_avail_idx)
-			return vq->num;
+			return -ENOSPC;
 
 		/* Only get avail ring entries after they have been
 		 * exposed by guest.
@@ -2700,6 +2701,7 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
 		return -EFAULT;
 	}
 
+	used->id = ring_head;
 	head = vhost16_to_cpu(vq, ring_head);
 
 	/* If their number is silly, that's an error. */
@@ -2787,10 +2789,17 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
 	/* Assume notifications from guest are disabled at this point,
 	 * if they aren't we would need to update avail_event index. */
 	BUG_ON(!(vq->used_flags & VRING_USED_F_NO_NOTIFY));
-	return head;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(vhost_get_vq_desc);
 
+static void vhost_set_used_len(struct vhost_virtqueue *vq,
+			       struct vring_used_elem *used, int len)
+{
+	used->len = cpu_to_vhost32(vq, len);
+}
+EXPORT_SYMBOL_GPL(vhost_set_used_len);
+
 static void vhost_withdraw_shadow_used(struct vhost_virtqueue *vq, int count)
 {
 	BUG_ON(count > vq->nheads);
@@ -2860,17 +2869,17 @@ int vhost_get_zc_used_len(struct vhost_virtqueue *vq, int idx)
 EXPORT_SYMBOL_GPL(vhost_get_zc_used_len);
 
 void vhost_set_zc_used(struct vhost_virtqueue *vq,
-			   int idx, unsigned int head, int len)
+		       int idx, struct vring_used_elem *elem, int len)
 {
-	vq->heads[idx].id = head;
-	vq->heads[idx].len = len;
+	vq->heads[idx] = *elem;
+	vhost_set_zc_used_len(vq, idx, len);
 }
 EXPORT_SYMBOL_GPL(vhost_set_zc_used);
 
 void vhost_add_shadow_used(struct vhost_virtqueue *vq,
-			   unsigned int head, int len)
+			   struct vring_used_elem *elem, int len)
 {
-	vhost_set_zc_used(vq, vq->nheads, head, len);
+	vhost_set_zc_used(vq, vq->nheads, elem, len);
 	++vq->nheads;
 }
 EXPORT_SYMBOL_GPL(vhost_add_shadow_used);
@@ -2921,14 +2930,11 @@ EXPORT_SYMBOL_GPL(vhost_add_used_n);
 
 /* After we've used one of their buffers, we tell them about it.  We'll then
  * want to notify the guest, using eventfd. */
-int vhost_add_used(struct vhost_virtqueue *vq, unsigned int head, int len)
+int vhost_add_used(struct vhost_virtqueue *vq, struct vring_used_elem *used,
+		   int len)
 {
-	struct vring_used_elem heads = {
-		cpu_to_vhost32(vq, head),
-		cpu_to_vhost32(vq, len)
-	};
-
-	return vhost_add_used_n(vq, &heads, 1);
+	vhost_set_used_len(vq, used, len);
+	return vhost_add_used_n(vq, used, 1);
 }
 EXPORT_SYMBOL_GPL(vhost_add_used);
 
@@ -2981,9 +2987,9 @@ EXPORT_SYMBOL_GPL(vhost_signal);
 /* And here's the combo meal deal.  Supersize me! */
 void vhost_add_used_and_signal(struct vhost_dev *dev,
 			       struct vhost_virtqueue *vq,
-			       unsigned int head, int len)
+			       struct vring_used_elem *used, int len)
 {
-	vhost_add_used(vq, head, len);
+	vhost_add_used(vq, used, len);
 	vhost_signal(dev, vq);
 }
 EXPORT_SYMBOL_GPL(vhost_add_used_and_signal);
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 481baba20c3d..f835eefa240c 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -233,16 +233,17 @@ bool vhost_vq_access_ok(struct vhost_virtqueue *vq);
 bool vhost_log_access_ok(struct vhost_dev *);
 
 int vhost_get_vq_desc(struct vhost_virtqueue *,
+		      struct vring_used_elem *used_elem,
 		      struct iovec iov[], unsigned int iov_count,
 		      unsigned int *out_num, unsigned int *in_num,
 		      struct vhost_log *log, unsigned int *log_num);
 void vhost_discard_vq_desc(struct vhost_virtqueue *, int n);
 
 int vhost_vq_init_access(struct vhost_virtqueue *);
-int vhost_add_used(struct vhost_virtqueue *, unsigned int head, int len);
+int vhost_add_used(struct vhost_virtqueue *, struct vring_used_elem *, int);
 
 void vhost_add_used_and_signal(struct vhost_dev *, struct vhost_virtqueue *,
-			       unsigned int id, int len);
+			       struct vring_used_elem *, int);
 
 /* Zerocopy shadow used ring API */
 void vhost_set_zc_used_len(struct vhost_virtqueue *vq,
@@ -250,11 +251,11 @@ void vhost_set_zc_used_len(struct vhost_virtqueue *vq,
 int vhost_get_zc_used_len(struct vhost_virtqueue *vq, int idx);
 void vhost_flush_zc_used_and_signal(struct vhost_virtqueue *vq, int idx, int n);
 void vhost_set_zc_used(struct vhost_virtqueue *vq, int idx,
-		       unsigned int head, int len);
+		       struct vring_used_elem *elem, int len);
 
 /* Non zerocopy shadow used ring API */
-void vhost_add_shadow_used(struct vhost_virtqueue *vq, unsigned int head,
-			   int len);
+void vhost_add_shadow_used(struct vhost_virtqueue *vq,
+			   struct vring_used_elem *elem, int len);
 void vhost_flush_shadow_used_and_signal(struct vhost_virtqueue *vq);
 void vhost_discard_shadow_used(struct vhost_virtqueue *vq, int n);
 int vhost_get_shadow_used_count(struct vhost_virtqueue *vq);
diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index f94021b450f0..1c962bfdc3a1 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -100,11 +100,12 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 
 	do {
 		struct virtio_vsock_pkt *pkt;
+		struct vring_used_elem used;
 		struct iov_iter iov_iter;
 		unsigned out, in;
 		size_t nbytes;
 		size_t len;
-		int head;
+		int ret;
 
 		spin_lock_bh(&vsock->send_pkt_list_lock);
 		if (list_empty(&vsock->send_pkt_list)) {
@@ -118,16 +119,9 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 		list_del_init(&pkt->list);
 		spin_unlock_bh(&vsock->send_pkt_list_lock);
 
-		head = vhost_get_vq_desc(vq, vq->iov, ARRAY_SIZE(vq->iov),
-					 &out, &in, NULL, NULL);
-		if (head < 0) {
-			spin_lock_bh(&vsock->send_pkt_list_lock);
-			list_add(&pkt->list, &vsock->send_pkt_list);
-			spin_unlock_bh(&vsock->send_pkt_list_lock);
-			break;
-		}
-
-		if (head == vq->num) {
+		ret = vhost_get_vq_desc(vq, &used, vq->iov, ARRAY_SIZE(vq->iov),
+					&out, &in, NULL, NULL);
+		if (ret == -ENOSPC) {
 			spin_lock_bh(&vsock->send_pkt_list_lock);
 			list_add(&pkt->list, &vsock->send_pkt_list);
 			spin_unlock_bh(&vsock->send_pkt_list_lock);
@@ -141,6 +135,12 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 			}
 			break;
 		}
+		if (ret < 0) {
+			spin_lock_bh(&vsock->send_pkt_list_lock);
+			list_add(&pkt->list, &vsock->send_pkt_list);
+			spin_unlock_bh(&vsock->send_pkt_list_lock);
+			break;
+		}
 
 		if (out) {
 			virtio_transport_free_pkt(pkt);
@@ -148,7 +148,7 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 			break;
 		}
 
-		len = iov_length(&vq->iov[out], in);
+		len = vhost32_to_cpu(vq, used.len);
 		iov_iter_init(&iov_iter, READ, &vq->iov[out], in, len);
 
 		nbytes = copy_to_iter(&pkt->hdr, sizeof(pkt->hdr), &iov_iter);
@@ -165,7 +165,7 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 			break;
 		}
 
-		vhost_add_used(vq, head, sizeof(pkt->hdr) + pkt->len);
+		vhost_add_used(vq, &used, sizeof(pkt->hdr) + pkt->len);
 		added = true;
 
 		if (pkt->reply) {
@@ -360,7 +360,8 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
 	struct vhost_vsock *vsock = container_of(vq->dev, struct vhost_vsock,
 						 dev);
 	struct virtio_vsock_pkt *pkt;
-	int head, pkts = 0, total_len = 0;
+	struct vring_used_elem used;
+	int ret, pkts = 0, total_len = 0;
 	unsigned int out, in;
 	bool added = false;
 
@@ -381,18 +382,17 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
 			goto no_more_replies;
 		}
 
-		head = vhost_get_vq_desc(vq, vq->iov, ARRAY_SIZE(vq->iov),
-					 &out, &in, NULL, NULL);
-		if (head < 0)
-			break;
-
-		if (head == vq->num) {
+		ret = vhost_get_vq_desc(vq, &used, vq->iov, ARRAY_SIZE(vq->iov),
+					&out, &in, NULL, NULL);
+		if (ret == -ENOSPC) {
 			if (unlikely(vhost_enable_notify(vq))) {
 				vhost_disable_notify(vq);
 				continue;
 			}
 			break;
 		}
+		if (ret < 0)
+			break;
 
 		pkt = vhost_vsock_alloc_pkt(vq, out, in);
 		if (!pkt) {
@@ -411,8 +411,7 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
 		else
 			virtio_transport_free_pkt(pkt);
 
-		len += sizeof(pkt->hdr);
-		vhost_add_used(vq, head, len);
+		vhost_add_used(vq, &used, sizeof(pkt->hdr) + len);
 		total_len += len;
 		added = true;
 	} while(likely(!vhost_exceeds_weight(vq, ++pkts, total_len)));
-- 
2.18.1

