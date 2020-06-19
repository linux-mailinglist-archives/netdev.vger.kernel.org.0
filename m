Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0D1201A4A
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 20:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405917AbgFSSXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 14:23:46 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:30083 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2395450AbgFSSXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 14:23:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592591017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uGimxgKdRit5mM9dp7pC7kGdcK+1P4ilMJIurFqDHW8=;
        b=GsEYI00A+WW8/KzLL0DMz26vFDPmrTaFFT8G/6tzFjRSzwE2prLASTOmNAZvObdR5c4GrA
        2D7HFylNWsppFWoMJwRbPS8vpSSF81zFx0FgzUs1kv7xN6CTv2M6W+pxkURbOY5eDHe175
        TMJCTHbUEg9yXI+sTuF6zdOhZMNXPr0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-C0y84hweOYutNhI3hV5Grw-1; Fri, 19 Jun 2020 14:23:33 -0400
X-MC-Unique: C0y84hweOYutNhI3hV5Grw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 881678015CE;
        Fri, 19 Jun 2020 18:23:32 +0000 (UTC)
Received: from eperezma.remote.csb (ovpn-113-14.ams2.redhat.com [10.36.113.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D04F71C8;
        Fri, 19 Jun 2020 18:23:24 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     mst@redhat.com
Cc:     kvm list <kvm@vger.kernel.org>,
        Stefano Garzarella <sgarzare@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [RFC v9 06/11] vhost/net: convert to new API: heads->bufs
Date:   Fri, 19 Jun 2020 20:22:57 +0200
Message-Id: <20200619182302.850-7-eperezma@redhat.com>
In-Reply-To: <20200619182302.850-1-eperezma@redhat.com>
References: <20200619182302.850-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>

Convert vhost net to use the new format-agnostic API.
In particular, don't poke at vq internals such as the
heads array.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
---
 drivers/vhost/net.c | 154 +++++++++++++++++++++++---------------------
 1 file changed, 82 insertions(+), 72 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 81900ce673b4..871214d8c64d 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -59,13 +59,13 @@ MODULE_PARM_DESC(experimental_zcopytx, "Enable Zero Copy TX;"
  * status internally; used for zerocopy tx only.
  */
 /* Lower device DMA failed */
-#define VHOST_DMA_FAILED_LEN	((__force __virtio32)3)
+#define VHOST_DMA_FAILED_LEN	(3)
 /* Lower device DMA done */
-#define VHOST_DMA_DONE_LEN	((__force __virtio32)2)
+#define VHOST_DMA_DONE_LEN	(2)
 /* Lower device DMA in progress */
-#define VHOST_DMA_IN_PROGRESS	((__force __virtio32)1)
+#define VHOST_DMA_IN_PROGRESS	(1)
 /* Buffer unused */
-#define VHOST_DMA_CLEAR_LEN	((__force __virtio32)0)
+#define VHOST_DMA_CLEAR_LEN	(0)
 
 #define VHOST_DMA_IS_DONE(len) ((__force u32)(len) >= (__force u32)VHOST_DMA_DONE_LEN)
 
@@ -112,9 +112,12 @@ struct vhost_net_virtqueue {
 	/* last used idx for outstanding DMA zerocopy buffers */
 	int upend_idx;
 	/* For TX, first used idx for DMA done zerocopy buffers
-	 * For RX, number of batched heads
+	 * For RX, number of batched bufs
 	 */
 	int done_idx;
+	/* Outstanding user bufs. UIO_MAXIOV in length. */
+	/* TODO: we can make this smaller for sure. */
+	struct vhost_buf *bufs;
 	/* Number of XDP frames batched */
 	int batched_xdp;
 	/* an array of userspace buffers info */
@@ -271,6 +274,8 @@ static void vhost_net_clear_ubuf_info(struct vhost_net *n)
 	int i;
 
 	for (i = 0; i < VHOST_NET_VQ_MAX; ++i) {
+		kfree(n->vqs[i].bufs);
+		n->vqs[i].bufs = NULL;
 		kfree(n->vqs[i].ubuf_info);
 		n->vqs[i].ubuf_info = NULL;
 	}
@@ -282,6 +287,12 @@ static int vhost_net_set_ubuf_info(struct vhost_net *n)
 	int i;
 
 	for (i = 0; i < VHOST_NET_VQ_MAX; ++i) {
+		n->vqs[i].bufs = kmalloc_array(UIO_MAXIOV,
+					       sizeof(*n->vqs[i].bufs),
+					       GFP_KERNEL);
+		if (!n->vqs[i].bufs)
+			goto err;
+
 		zcopy = vhost_net_zcopy_mask & (0x1 << i);
 		if (!zcopy)
 			continue;
@@ -364,18 +375,18 @@ static void vhost_zerocopy_signal_used(struct vhost_net *net,
 	int j = 0;
 
 	for (i = nvq->done_idx; i != nvq->upend_idx; i = (i + 1) % UIO_MAXIOV) {
-		if (vq->heads[i].len == VHOST_DMA_FAILED_LEN)
+		if (nvq->bufs[i].in_len == VHOST_DMA_FAILED_LEN)
 			vhost_net_tx_err(net);
-		if (VHOST_DMA_IS_DONE(vq->heads[i].len)) {
-			vq->heads[i].len = VHOST_DMA_CLEAR_LEN;
+		if (VHOST_DMA_IS_DONE(nvq->bufs[i].in_len)) {
+			nvq->bufs[i].in_len = VHOST_DMA_CLEAR_LEN;
 			++j;
 		} else
 			break;
 	}
 	while (j) {
 		add = min(UIO_MAXIOV - nvq->done_idx, j);
-		vhost_add_used_and_signal_n(vq->dev, vq,
-					    &vq->heads[nvq->done_idx], add);
+		vhost_put_used_n_bufs(vq, &nvq->bufs[nvq->done_idx], add);
+		vhost_signal(vq->dev, vq);
 		nvq->done_idx = (nvq->done_idx + add) % UIO_MAXIOV;
 		j -= add;
 	}
@@ -390,7 +401,7 @@ static void vhost_zerocopy_callback(struct ubuf_info *ubuf, bool success)
 	rcu_read_lock_bh();
 
 	/* set len to mark this desc buffers done DMA */
-	nvq->vq.heads[ubuf->desc].len = success ?
+	nvq->bufs[ubuf->desc].in_len = success ?
 		VHOST_DMA_DONE_LEN : VHOST_DMA_FAILED_LEN;
 	cnt = vhost_net_ubuf_put(ubufs);
 
@@ -452,7 +463,8 @@ static void vhost_net_signal_used(struct vhost_net_virtqueue *nvq)
 	if (!nvq->done_idx)
 		return;
 
-	vhost_add_used_and_signal_n(dev, vq, vq->heads, nvq->done_idx);
+	vhost_put_used_n_bufs(vq, nvq->bufs, nvq->done_idx);
+	vhost_signal(dev, vq);
 	nvq->done_idx = 0;
 }
 
@@ -558,6 +570,7 @@ static void vhost_net_busy_poll(struct vhost_net *net,
 
 static int vhost_net_tx_get_vq_desc(struct vhost_net *net,
 				    struct vhost_net_virtqueue *tnvq,
+				    struct vhost_buf *buf,
 				    unsigned int *out_num, unsigned int *in_num,
 				    struct msghdr *msghdr, bool *busyloop_intr)
 {
@@ -565,10 +578,10 @@ static int vhost_net_tx_get_vq_desc(struct vhost_net *net,
 	struct vhost_virtqueue *rvq = &rnvq->vq;
 	struct vhost_virtqueue *tvq = &tnvq->vq;
 
-	int r = vhost_get_vq_desc(tvq, tvq->iov, ARRAY_SIZE(tvq->iov),
-				  out_num, in_num, NULL, NULL);
+	int r = vhost_get_avail_buf(tvq, buf, tvq->iov, ARRAY_SIZE(tvq->iov),
+				    out_num, in_num, NULL, NULL);
 
-	if (r == tvq->num && tvq->busyloop_timeout) {
+	if (!r && tvq->busyloop_timeout) {
 		/* Flush batched packets first */
 		if (!vhost_sock_zcopy(vhost_vq_get_backend(tvq)))
 			vhost_tx_batch(net, tnvq,
@@ -577,8 +590,8 @@ static int vhost_net_tx_get_vq_desc(struct vhost_net *net,
 
 		vhost_net_busy_poll(net, rvq, tvq, busyloop_intr, false);
 
-		r = vhost_get_vq_desc(tvq, tvq->iov, ARRAY_SIZE(tvq->iov),
-				      out_num, in_num, NULL, NULL);
+		r = vhost_get_avail_buf(tvq, buf, tvq->iov, ARRAY_SIZE(tvq->iov),
+					out_num, in_num, NULL, NULL);
 	}
 
 	return r;
@@ -607,6 +620,7 @@ static size_t init_iov_iter(struct vhost_virtqueue *vq, struct iov_iter *iter,
 
 static int get_tx_bufs(struct vhost_net *net,
 		       struct vhost_net_virtqueue *nvq,
+		       struct vhost_buf *buf,
 		       struct msghdr *msg,
 		       unsigned int *out, unsigned int *in,
 		       size_t *len, bool *busyloop_intr)
@@ -614,9 +628,9 @@ static int get_tx_bufs(struct vhost_net *net,
 	struct vhost_virtqueue *vq = &nvq->vq;
 	int ret;
 
-	ret = vhost_net_tx_get_vq_desc(net, nvq, out, in, msg, busyloop_intr);
+	ret = vhost_net_tx_get_vq_desc(net, nvq, buf, out, in, msg, busyloop_intr);
 
-	if (ret < 0 || ret == vq->num)
+	if (ret <= 0)
 		return ret;
 
 	if (*in) {
@@ -762,7 +776,7 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
 	struct vhost_net_virtqueue *nvq = &net->vqs[VHOST_NET_VQ_TX];
 	struct vhost_virtqueue *vq = &nvq->vq;
 	unsigned out, in;
-	int head;
+	int ret;
 	struct msghdr msg = {
 		.msg_name = NULL,
 		.msg_namelen = 0,
@@ -774,6 +788,7 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
 	int err;
 	int sent_pkts = 0;
 	bool sock_can_batch = (sock->sk->sk_sndbuf == INT_MAX);
+	struct vhost_buf buf;
 
 	do {
 		bool busyloop_intr = false;
@@ -781,13 +796,13 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
 		if (nvq->done_idx == VHOST_NET_BATCH)
 			vhost_tx_batch(net, nvq, sock, &msg);
 
-		head = get_tx_bufs(net, nvq, &msg, &out, &in, &len,
-				   &busyloop_intr);
+		ret = get_tx_bufs(net, nvq, &buf, &msg, &out, &in, &len,
+				  &busyloop_intr);
 		/* On error, stop handling until the next kick. */
-		if (unlikely(head < 0))
+		if (unlikely(ret < 0))
 			break;
 		/* Nothing new?  Wait for eventfd to tell us they refilled. */
-		if (head == vq->num) {
+		if (!ret) {
 			if (unlikely(busyloop_intr)) {
 				vhost_poll_queue(&vq->poll);
 			} else if (unlikely(vhost_enable_notify(&net->dev,
@@ -809,7 +824,7 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
 				goto done;
 			} else if (unlikely(err != -ENOSPC)) {
 				vhost_tx_batch(net, nvq, sock, &msg);
-				vhost_discard_vq_desc(vq, 1);
+				vhost_discard_avail_bufs(vq, &buf, 1);
 				vhost_net_enable_vq(net, vq);
 				break;
 			}
@@ -830,7 +845,7 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
 		/* TODO: Check specific error and bomb out unless ENOBUFS? */
 		err = sock->ops->sendmsg(sock, &msg, len);
 		if (unlikely(err < 0)) {
-			vhost_discard_vq_desc(vq, 1);
+			vhost_discard_avail_bufs(vq, &buf, 1);
 			vhost_net_enable_vq(net, vq);
 			break;
 		}
@@ -838,8 +853,7 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
 			pr_debug("Truncated TX packet: len %d != %zd\n",
 				 err, len);
 done:
-		vq->heads[nvq->done_idx].id = cpu_to_vhost32(vq, head);
-		vq->heads[nvq->done_idx].len = 0;
+		nvq->bufs[nvq->done_idx] = buf;
 		++nvq->done_idx;
 	} while (likely(!vhost_exceeds_weight(vq, ++sent_pkts, total_len)));
 
@@ -851,7 +865,7 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
 	struct vhost_net_virtqueue *nvq = &net->vqs[VHOST_NET_VQ_TX];
 	struct vhost_virtqueue *vq = &nvq->vq;
 	unsigned out, in;
-	int head;
+	int ret;
 	struct msghdr msg = {
 		.msg_name = NULL,
 		.msg_namelen = 0,
@@ -865,6 +879,7 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
 	struct vhost_net_ubuf_ref *uninitialized_var(ubufs);
 	bool zcopy_used;
 	int sent_pkts = 0;
+	struct vhost_buf buf;
 
 	do {
 		bool busyloop_intr;
@@ -873,13 +888,13 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
 		vhost_zerocopy_signal_used(net, vq);
 
 		busyloop_intr = false;
-		head = get_tx_bufs(net, nvq, &msg, &out, &in, &len,
-				   &busyloop_intr);
+		ret = get_tx_bufs(net, nvq, &buf, &msg, &out, &in, &len,
+				  &busyloop_intr);
 		/* On error, stop handling until the next kick. */
-		if (unlikely(head < 0))
+		if (unlikely(ret < 0))
 			break;
 		/* Nothing new?  Wait for eventfd to tell us they refilled. */
-		if (head == vq->num) {
+		if (!ret) {
 			if (unlikely(busyloop_intr)) {
 				vhost_poll_queue(&vq->poll);
 			} else if (unlikely(vhost_enable_notify(&net->dev, vq))) {
@@ -898,8 +913,8 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
 			struct ubuf_info *ubuf;
 			ubuf = nvq->ubuf_info + nvq->upend_idx;
 
-			vq->heads[nvq->upend_idx].id = cpu_to_vhost32(vq, head);
-			vq->heads[nvq->upend_idx].len = VHOST_DMA_IN_PROGRESS;
+			nvq->bufs[nvq->upend_idx] = buf;
+			nvq->bufs[nvq->upend_idx].in_len = VHOST_DMA_IN_PROGRESS;
 			ubuf->callback = vhost_zerocopy_callback;
 			ubuf->ctx = nvq->ubufs;
 			ubuf->desc = nvq->upend_idx;
@@ -931,17 +946,19 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
 				nvq->upend_idx = ((unsigned)nvq->upend_idx - 1)
 					% UIO_MAXIOV;
 			}
-			vhost_discard_vq_desc(vq, 1);
+			vhost_discard_avail_bufs(vq, &buf, 1);
 			vhost_net_enable_vq(net, vq);
 			break;
 		}
 		if (err != len)
 			pr_debug("Truncated TX packet: "
 				 " len %d != %zd\n", err, len);
-		if (!zcopy_used)
-			vhost_add_used_and_signal(&net->dev, vq, head, 0);
-		else
+		if (!zcopy_used) {
+			vhost_put_used_buf(vq, &buf);
+			vhost_signal(&net->dev, vq);
+		} else {
 			vhost_zerocopy_signal_used(net, vq);
+		}
 		vhost_net_tx_packet(net);
 	} while (likely(!vhost_exceeds_weight(vq, ++sent_pkts, total_len)));
 }
@@ -1005,7 +1022,7 @@ static int vhost_net_rx_peek_head_len(struct vhost_net *net, struct sock *sk,
 	int len = peek_head_len(rnvq, sk);
 
 	if (!len && rvq->busyloop_timeout) {
-		/* Flush batched heads first */
+		/* Flush batched bufs first */
 		vhost_net_signal_used(rnvq);
 		/* Both tx vq and rx socket were polled here */
 		vhost_net_busy_poll(net, rvq, tvq, busyloop_intr, true);
@@ -1023,11 +1040,11 @@ static int vhost_net_rx_peek_head_len(struct vhost_net *net, struct sock *sk,
  * @iovcount	- returned count of io vectors we fill
  * @log		- vhost log
  * @log_num	- log offset
- * @quota       - headcount quota, 1 for big buffer
- *	returns number of buffer heads allocated, negative on error
+ * @quota       - bufcount quota, 1 for big buffer
+ *	returns number of buffers allocated, negative on error
  */
 static int get_rx_bufs(struct vhost_virtqueue *vq,
-		       struct vring_used_elem *heads,
+		       struct vhost_buf *bufs,
 		       int datalen,
 		       unsigned *iovcount,
 		       struct vhost_log *log,
@@ -1036,30 +1053,24 @@ static int get_rx_bufs(struct vhost_virtqueue *vq,
 {
 	unsigned int out, in;
 	int seg = 0;
-	int headcount = 0;
-	unsigned d;
+	int bufcount = 0;
 	int r, nlogs = 0;
 	/* len is always initialized before use since we are always called with
 	 * datalen > 0.
 	 */
 	u32 uninitialized_var(len);
 
-	while (datalen > 0 && headcount < quota) {
+	while (datalen > 0 && bufcount < quota) {
 		if (unlikely(seg >= UIO_MAXIOV)) {
 			r = -ENOBUFS;
 			goto err;
 		}
-		r = vhost_get_vq_desc(vq, vq->iov + seg,
-				      ARRAY_SIZE(vq->iov) - seg, &out,
-				      &in, log, log_num);
-		if (unlikely(r < 0))
+		r = vhost_get_avail_buf(vq, bufs + bufcount, vq->iov + seg,
+					ARRAY_SIZE(vq->iov) - seg, &out,
+					&in, log, log_num);
+		if (unlikely(r <= 0))
 			goto err;
 
-		d = r;
-		if (d == vq->num) {
-			r = 0;
-			goto err;
-		}
 		if (unlikely(out || in <= 0)) {
 			vq_err(vq, "unexpected descriptor format for RX: "
 				"out %d, in %d\n", out, in);
@@ -1070,14 +1081,12 @@ static int get_rx_bufs(struct vhost_virtqueue *vq,
 			nlogs += *log_num;
 			log += *log_num;
 		}
-		heads[headcount].id = cpu_to_vhost32(vq, d);
 		len = iov_length(vq->iov + seg, in);
-		heads[headcount].len = cpu_to_vhost32(vq, len);
 		datalen -= len;
-		++headcount;
+		++bufcount;
 		seg += in;
 	}
-	heads[headcount - 1].len = cpu_to_vhost32(vq, len + datalen);
+	bufs[bufcount - 1].in_len = len + datalen;
 	*iovcount = seg;
 	if (unlikely(log))
 		*log_num = nlogs;
@@ -1087,9 +1096,9 @@ static int get_rx_bufs(struct vhost_virtqueue *vq,
 		r = UIO_MAXIOV + 1;
 		goto err;
 	}
-	return headcount;
+	return bufcount;
 err:
-	vhost_discard_vq_desc(vq, headcount);
+	vhost_discard_avail_bufs(vq, bufs, bufcount);
 	return r;
 }
 
@@ -1114,7 +1123,7 @@ static void handle_rx(struct vhost_net *net)
 	};
 	size_t total_len = 0;
 	int err, mergeable;
-	s16 headcount;
+	int bufcount;
 	size_t vhost_hlen, sock_hlen;
 	size_t vhost_len, sock_len;
 	bool busyloop_intr = false;
@@ -1148,14 +1157,14 @@ static void handle_rx(struct vhost_net *net)
 			break;
 		sock_len += sock_hlen;
 		vhost_len = sock_len + vhost_hlen;
-		headcount = get_rx_bufs(vq, vq->heads + nvq->done_idx,
-					vhost_len, &in, vq_log, &log,
-					likely(mergeable) ? UIO_MAXIOV : 1);
+		bufcount = get_rx_bufs(vq, nvq->bufs + nvq->done_idx,
+				       vhost_len, &in, vq_log, &log,
+				       likely(mergeable) ? UIO_MAXIOV : 1);
 		/* On error, stop handling until the next kick. */
-		if (unlikely(headcount < 0))
+		if (unlikely(bufcount < 0))
 			goto out;
 		/* OK, now we need to know about added descriptors. */
-		if (!headcount) {
+		if (!bufcount) {
 			if (unlikely(busyloop_intr)) {
 				vhost_poll_queue(&vq->poll);
 			} else if (unlikely(vhost_enable_notify(&net->dev, vq))) {
@@ -1172,7 +1181,7 @@ static void handle_rx(struct vhost_net *net)
 		if (nvq->rx_ring)
 			msg.msg_control = vhost_net_buf_consume(&nvq->rxq);
 		/* On overrun, truncate and discard */
-		if (unlikely(headcount > UIO_MAXIOV)) {
+		if (unlikely(bufcount > UIO_MAXIOV)) {
 			iov_iter_init(&msg.msg_iter, READ, vq->iov, 1, 1);
 			err = sock->ops->recvmsg(sock, &msg,
 						 1, MSG_DONTWAIT | MSG_TRUNC);
@@ -1196,7 +1205,7 @@ static void handle_rx(struct vhost_net *net)
 		if (unlikely(err != sock_len)) {
 			pr_debug("Discarded rx packet: "
 				 " len %d, expected %zd\n", err, sock_len);
-			vhost_discard_vq_desc(vq, headcount);
+			vhost_discard_avail_bufs(vq, nvq->bufs + nvq->done_idx, bufcount);
 			continue;
 		}
 		/* Supply virtio_net_hdr if VHOST_NET_F_VIRTIO_NET_HDR */
@@ -1215,15 +1224,15 @@ static void handle_rx(struct vhost_net *net)
 		}
 		/* TODO: Should check and handle checksum. */
 
-		num_buffers = cpu_to_vhost16(vq, headcount);
+		num_buffers = cpu_to_vhost16(vq, bufcount);
 		if (likely(mergeable) &&
 		    copy_to_iter(&num_buffers, sizeof num_buffers,
 				 &fixup) != sizeof num_buffers) {
 			vq_err(vq, "Failed num_buffers write");
-			vhost_discard_vq_desc(vq, headcount);
+			vhost_discard_avail_bufs(vq, nvq->bufs + nvq->done_idx, bufcount);
 			goto out;
 		}
-		nvq->done_idx += headcount;
+		nvq->done_idx += bufcount;
 		if (nvq->done_idx > VHOST_NET_BATCH)
 			vhost_net_signal_used(nvq);
 		if (unlikely(vq_log))
@@ -1315,6 +1324,7 @@ static int vhost_net_open(struct inode *inode, struct file *f)
 	n->vqs[VHOST_NET_VQ_TX].vq.handle_kick = handle_tx_kick;
 	n->vqs[VHOST_NET_VQ_RX].vq.handle_kick = handle_rx_kick;
 	for (i = 0; i < VHOST_NET_VQ_MAX; i++) {
+		n->vqs[i].bufs = NULL;
 		n->vqs[i].ubufs = NULL;
 		n->vqs[i].ubuf_info = NULL;
 		n->vqs[i].upend_idx = 0;
-- 
2.18.1

