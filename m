Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6849541C7F2
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345180AbhI2PNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 11:13:13 -0400
Received: from smtp2.axis.com ([195.60.68.18]:4224 "EHLO smtp2.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345075AbhI2PNF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 11:13:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1632928284;
  x=1664464284;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rFsuG5yulChU1RiHnkTswRVXWfw8Xi3XkNlyr5Zr+o0=;
  b=Sd8rxFQrnjJwSZE60Wd1AfRUEX3mF0XIdi4ONNwFGW2GNdgreiOj4ACL
   5lGFBmuNOrJbyZrnU+ro2usXimiv+tcN+iMioIOiF3ERLuS3bvpEMFchI
   w5UXzhAq5b/LqAAAnDmGwQULcLtNxwuGvZSi9cYTIAQf7kRXQ7uNHWSkF
   a64+6L9ECKk1wtVBXEi8TZ9T+XO3ix5dNm8sTKJ1j2XvUNARcAcfzsN9Z
   T+ygVmKcJIymM/i8qV4eaLl8ohMuyaJ1obt6YlROyc81NeGvgz+hzKUEM
   ivTQAhhVgoqWMdxFFXhtqRz3biP8p8Y/LwD0ugYlAHlncxuGtjN62+p6g
   g==;
From:   Vincent Whitchurch <vincent.whitchurch@axis.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>
CC:     <kernel@axis.com>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>, <stefanha@redhat.com>,
        <sgarzare@redhat.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>
Subject: [RFC PATCH 03/10] vhost: add iov wrapper
Date:   Wed, 29 Sep 2021 17:11:12 +0200
Message-ID: <20210929151119.14778-4-vincent.whitchurch@axis.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210929151119.14778-1-vincent.whitchurch@axis.com>
References: <20210929151119.14778-1-vincent.whitchurch@axis.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to prepare for supporting buffers in kernel space, add a
vhost_iov struct to wrap the userspace iovec, add helper functions for
accessing this struct, and use these helpers from all vhost drivers.

Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
---
 drivers/vhost/net.c   | 13 ++++++------
 drivers/vhost/scsi.c  | 30 +++++++++++++--------------
 drivers/vhost/test.c  |  2 +-
 drivers/vhost/vhost.c | 25 +++++++++++-----------
 drivers/vhost/vhost.h | 48 +++++++++++++++++++++++++++++++++++++------
 drivers/vhost/vsock.c |  8 ++++----
 6 files changed, 81 insertions(+), 45 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 28ef323882fb..8f82b646d4af 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -607,9 +607,9 @@ static size_t init_iov_iter(struct vhost_virtqueue *vq, struct iov_iter *iter,
 			    size_t hdr_size, int out)
 {
 	/* Skip header. TODO: support TSO. */
-	size_t len = iov_length(vq->iov, out);
+	size_t len = vhost_iov_length(vq, vq->iov, out);
 
-	iov_iter_init(iter, WRITE, vq->iov, out, len);
+	vhost_iov_iter_init(vq, iter, WRITE, vq->iov, out, len);
 	iov_iter_advance(iter, hdr_size);
 
 	return iov_iter_count(iter);
@@ -1080,7 +1080,7 @@ static int get_rx_bufs(struct vhost_virtqueue *vq,
 			log += *log_num;
 		}
 		heads[headcount].id = cpu_to_vhost32(vq, d);
-		len = iov_length(vq->iov + seg, in);
+		len = vhost_iov_length(vq, vq->iov + seg, in);
 		heads[headcount].len = cpu_to_vhost32(vq, len);
 		datalen -= len;
 		++headcount;
@@ -1182,14 +1182,14 @@ static void handle_rx(struct vhost_net *net)
 			msg.msg_control = vhost_net_buf_consume(&nvq->rxq);
 		/* On overrun, truncate and discard */
 		if (unlikely(headcount > UIO_MAXIOV)) {
-			iov_iter_init(&msg.msg_iter, READ, vq->iov, 1, 1);
+			vhost_iov_iter_init(vq, &msg.msg_iter, READ, vq->iov, 1, 1);
 			err = sock->ops->recvmsg(sock, &msg,
 						 1, MSG_DONTWAIT | MSG_TRUNC);
 			pr_debug("Discarded rx packet: len %zd\n", sock_len);
 			continue;
 		}
 		/* We don't need to be notified again. */
-		iov_iter_init(&msg.msg_iter, READ, vq->iov, in, vhost_len);
+		vhost_iov_iter_init(vq, &msg.msg_iter, READ, vq->iov, in, vhost_len);
 		fixup = msg.msg_iter;
 		if (unlikely((vhost_hlen))) {
 			/* We will supply the header ourselves
@@ -1212,8 +1212,7 @@ static void handle_rx(struct vhost_net *net)
 		if (unlikely(vhost_hlen)) {
 			if (copy_to_iter(&hdr, sizeof(hdr),
 					 &fixup) != sizeof(hdr)) {
-				vq_err(vq, "Unable to write vnet_hdr "
-				       "at addr %p\n", vq->iov->iov_base);
+				vq_err(vq, "Unable to write vnet_hdr");
 				goto out;
 			}
 		} else {
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index bcf53685439d..22a372b52165 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -80,7 +80,7 @@ struct vhost_scsi_cmd {
 	struct scatterlist *tvc_prot_sgl;
 	struct page **tvc_upages;
 	/* Pointer to response header iovec */
-	struct iovec tvc_resp_iov;
+	struct vhost_iov tvc_resp_iov;
 	/* Pointer to vhost_scsi for our device */
 	struct vhost_scsi *tvc_vhost;
 	/* Pointer to vhost_virtqueue for the cmd */
@@ -208,7 +208,7 @@ struct vhost_scsi_tmf {
 	struct se_cmd se_cmd;
 	u8 scsi_resp;
 	struct vhost_scsi_inflight *inflight;
-	struct iovec resp_iov;
+	struct vhost_iov resp_iov;
 	int in_iovs;
 	int vq_desc;
 };
@@ -487,9 +487,9 @@ vhost_scsi_do_evt_work(struct vhost_scsi *vs, struct vhost_scsi_evt *evt)
 		return;
 	}
 
-	if ((vq->iov[out].iov_len != sizeof(struct virtio_scsi_event))) {
+	if (vhost_iov_len(vq, &vq->iov[out]) != sizeof(struct virtio_scsi_event)) {
 		vq_err(vq, "Expecting virtio_scsi_event, got %zu bytes\n",
-				vq->iov[out].iov_len);
+				vhost_iov_len(vq, &vq->iov[out]));
 		vs->vs_events_missed = true;
 		return;
 	}
@@ -499,7 +499,7 @@ vhost_scsi_do_evt_work(struct vhost_scsi *vs, struct vhost_scsi_evt *evt)
 		vs->vs_events_missed = false;
 	}
 
-	iov_iter_init(&iov_iter, READ, &vq->iov[out], in, sizeof(*event));
+	vhost_iov_iter_init(vq, &iov_iter, READ, &vq->iov[out], in, sizeof(*event));
 
 	ret = copy_to_iter(event, sizeof(*event), &iov_iter);
 	if (ret == sizeof(*event))
@@ -559,8 +559,8 @@ static void vhost_scsi_complete_cmd_work(struct vhost_work *work)
 		memcpy(v_rsp.sense, cmd->tvc_sense_buf,
 		       se_cmd->scsi_sense_length);
 
-		iov_iter_init(&iov_iter, READ, &cmd->tvc_resp_iov,
-			      cmd->tvc_in_iovs, sizeof(v_rsp));
+		vhost_iov_iter_init(&vs->vqs[0].vq, &iov_iter, READ, &cmd->tvc_resp_iov,
+				    cmd->tvc_in_iovs, sizeof(v_rsp));
 		ret = copy_to_iter(&v_rsp, sizeof(v_rsp), &iov_iter);
 		if (likely(ret == sizeof(v_rsp))) {
 			struct vhost_scsi_virtqueue *q;
@@ -809,7 +809,7 @@ vhost_scsi_send_bad_target(struct vhost_scsi *vs,
 	struct iov_iter iov_iter;
 	int ret;
 
-	iov_iter_init(&iov_iter, READ, &vq->iov[out], in, sizeof(rsp));
+	vhost_iov_iter_init(vq, &iov_iter, READ, &vq->iov[out], in, sizeof(rsp));
 
 	memset(&rsp, 0, sizeof(rsp));
 	rsp.response = VIRTIO_SCSI_S_BAD_TARGET;
@@ -850,8 +850,8 @@ vhost_scsi_get_desc(struct vhost_scsi *vs, struct vhost_virtqueue *vq,
 	 * Get the size of request and response buffers.
 	 * FIXME: Not correct for BIDI operation
 	 */
-	vc->out_size = iov_length(vq->iov, vc->out);
-	vc->in_size = iov_length(&vq->iov[vc->out], vc->in);
+	vc->out_size = vhost_iov_length(vq, vq->iov, vc->out);
+	vc->in_size = vhost_iov_length(vq, &vq->iov[vc->out], vc->in);
 
 	/*
 	 * Copy over the virtio-scsi request header, which for a
@@ -863,7 +863,7 @@ vhost_scsi_get_desc(struct vhost_scsi *vs, struct vhost_virtqueue *vq,
 	 * point at the start of the outgoing WRITE payload, if
 	 * DMA_TO_DEVICE is set.
 	 */
-	iov_iter_init(&vc->out_iter, WRITE, vq->iov, vc->out, vc->out_size);
+	vhost_iov_iter_init(vq, &vc->out_iter, WRITE, vq->iov, vc->out, vc->out_size);
 	ret = 0;
 
 done:
@@ -1015,7 +1015,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 			data_direction = DMA_FROM_DEVICE;
 			exp_data_len = vc.in_size - vc.rsp_size;
 
-			iov_iter_init(&in_iter, READ, &vq->iov[vc.out], vc.in,
+			vhost_iov_iter_init(vq, &in_iter, READ, &vq->iov[vc.out], vc.in,
 				      vc.rsp_size + exp_data_len);
 			iov_iter_advance(&in_iter, vc.rsp_size);
 			data_iter = in_iter;
@@ -1134,7 +1134,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 
 static void
 vhost_scsi_send_tmf_resp(struct vhost_scsi *vs, struct vhost_virtqueue *vq,
-			 int in_iovs, int vq_desc, struct iovec *resp_iov,
+			 int in_iovs, int vq_desc, struct vhost_iov *resp_iov,
 			 int tmf_resp_code)
 {
 	struct virtio_scsi_ctrl_tmf_resp rsp;
@@ -1145,7 +1145,7 @@ vhost_scsi_send_tmf_resp(struct vhost_scsi *vs, struct vhost_virtqueue *vq,
 	memset(&rsp, 0, sizeof(rsp));
 	rsp.response = tmf_resp_code;
 
-	iov_iter_init(&iov_iter, READ, resp_iov, in_iovs, sizeof(rsp));
+	vhost_iov_iter_init(vq, &iov_iter, READ, resp_iov, in_iovs, sizeof(rsp));
 
 	ret = copy_to_iter(&rsp, sizeof(rsp), &iov_iter);
 	if (likely(ret == sizeof(rsp)))
@@ -1237,7 +1237,7 @@ vhost_scsi_send_an_resp(struct vhost_scsi *vs,
 	memset(&rsp, 0, sizeof(rsp));	/* event_actual = 0 */
 	rsp.response = VIRTIO_SCSI_S_OK;
 
-	iov_iter_init(&iov_iter, READ, &vq->iov[vc->out], vc->in, sizeof(rsp));
+	vhost_iov_iter_init(vq, &iov_iter, READ, &vq->iov[vc->out], vc->in, sizeof(rsp));
 
 	ret = copy_to_iter(&rsp, sizeof(rsp), &iov_iter);
 	if (likely(ret == sizeof(rsp)))
diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
index a09dedc79f68..95794b0ea4ad 100644
--- a/drivers/vhost/test.c
+++ b/drivers/vhost/test.c
@@ -78,7 +78,7 @@ static void handle_vq(struct vhost_test *n)
 			       "out %d, int %d\n", out, in);
 			break;
 		}
-		len = iov_length(vq->iov, out);
+		len = vhost_iov_length(vq, vq->iov, out);
 		/* Sanity check */
 		if (!len) {
 			vq_err(vq, "Unexpected 0 len for TX\n");
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 108994f386f7..ce81eee2a3fa 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -812,7 +812,7 @@ static bool memory_access_ok(struct vhost_dev *d, struct vhost_iotlb *umem,
 }
 
 static int translate_desc(struct vhost_virtqueue *vq, u64 addr, u32 len,
-			  struct iovec iov[], int iov_size, int access);
+			  struct vhost_iov iov[], int iov_size, int access);
 
 static int vhost_copy_to_user(struct vhost_virtqueue *vq, void __user *to,
 			      const void *from, unsigned size)
@@ -840,7 +840,7 @@ static int vhost_copy_to_user(struct vhost_virtqueue *vq, void __user *to,
 				     VHOST_ACCESS_WO);
 		if (ret < 0)
 			goto out;
-		iov_iter_init(&t, WRITE, vq->iotlb_iov, ret, size);
+		iov_iter_init(&t, WRITE, &vq->iotlb_iov->iovec, ret, size);
 		ret = copy_to_iter(from, size, &t);
 		if (ret == size)
 			ret = 0;
@@ -879,7 +879,7 @@ static int vhost_copy_from_user(struct vhost_virtqueue *vq, void *to,
 			       (unsigned long long) size);
 			goto out;
 		}
-		iov_iter_init(&f, READ, vq->iotlb_iov, ret, size);
+		iov_iter_init(&f, READ, &vq->iotlb_iov->iovec, ret, size);
 		ret = copy_from_iter(to, size, &f);
 		if (ret == size)
 			ret = 0;
@@ -905,14 +905,14 @@ static void __user *__vhost_get_user_slow(struct vhost_virtqueue *vq,
 		return NULL;
 	}
 
-	if (ret != 1 || vq->iotlb_iov[0].iov_len != size) {
+	if (ret != 1 || vq->iotlb_iov->iovec.iov_len != size) {
 		vq_err(vq, "Non atomic userspace memory access: uaddr "
 			"%p size 0x%llx\n", addr,
 			(unsigned long long) size);
 		return NULL;
 	}
 
-	return vq->iotlb_iov[0].iov_base;
+	return vq->iotlb_iov->iovec.iov_base;
 }
 
 /* This function should be called after iotlb
@@ -1906,7 +1906,7 @@ static int log_write_hva(struct vhost_virtqueue *vq, u64 hva, u64 len)
 
 static int log_used(struct vhost_virtqueue *vq, u64 used_offset, u64 len)
 {
-	struct iovec *iov = vq->log_iov;
+	struct iovec *iov = &vq->log_iov->iovec;
 	int i, ret;
 
 	if (!vq->iotlb)
@@ -1928,8 +1928,9 @@ static int log_used(struct vhost_virtqueue *vq, u64 used_offset, u64 len)
 }
 
 int vhost_log_write(struct vhost_virtqueue *vq, struct vhost_log *log,
-		    unsigned int log_num, u64 len, struct iovec *iov, int count)
+		    unsigned int log_num, u64 len, struct vhost_iov *viov, int count)
 {
+	struct iovec *iov = &viov->iovec;
 	int i, r;
 
 	/* Make sure data written is seen before log. */
@@ -2035,7 +2036,7 @@ int vhost_vq_init_access(struct vhost_virtqueue *vq)
 EXPORT_SYMBOL_GPL(vhost_vq_init_access);
 
 static int translate_desc(struct vhost_virtqueue *vq, u64 addr, u32 len,
-			  struct iovec iov[], int iov_size, int access)
+			  struct vhost_iov iov[], int iov_size, int access)
 {
 	const struct vhost_iotlb_map *map;
 	struct vhost_dev *dev = vq->dev;
@@ -2064,7 +2065,7 @@ static int translate_desc(struct vhost_virtqueue *vq, u64 addr, u32 len,
 			break;
 		}
 
-		_iov = iov + ret;
+		_iov = &iov->iovec + ret;
 		size = map->size - addr + map->start;
 		_iov->iov_len = min((u64)len - s, size);
 		_iov->iov_base = (void __user *)(unsigned long)
@@ -2096,7 +2097,7 @@ static unsigned next_desc(struct vhost_virtqueue *vq, struct vring_desc *desc)
 }
 
 static int get_indirect(struct vhost_virtqueue *vq,
-			struct iovec iov[], unsigned int iov_size,
+			struct vhost_iov iov[], unsigned int iov_size,
 			unsigned int *out_num, unsigned int *in_num,
 			struct vhost_log *log, unsigned int *log_num,
 			struct vring_desc *indirect)
@@ -2123,7 +2124,7 @@ static int get_indirect(struct vhost_virtqueue *vq,
 			vq_err(vq, "Translation failure %d in indirect.\n", ret);
 		return ret;
 	}
-	iov_iter_init(&from, READ, vq->indirect, ret, len);
+	vhost_iov_iter_init(vq, &from, READ, vq->indirect, ret, len);
 	count = len / sizeof desc;
 	/* Buffers are chained via a 16 bit next field, so
 	 * we can have at most 2^16 of these. */
@@ -2197,7 +2198,7 @@ static int get_indirect(struct vhost_virtqueue *vq,
  * never a valid descriptor number) if none was found.  A negative code is
  * returned on error. */
 int vhost_get_vq_desc(struct vhost_virtqueue *vq,
-		      struct iovec iov[], unsigned int iov_size,
+		      struct vhost_iov iov[], unsigned int iov_size,
 		      unsigned int *out_num, unsigned int *in_num,
 		      struct vhost_log *log, unsigned int *log_num)
 {
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index b1db4ffe75f0..69aec724ef7f 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -65,6 +65,12 @@ struct vhost_vring_call {
 	struct irq_bypass_producer producer;
 };
 
+struct vhost_iov {
+	union {
+		struct iovec iovec;
+	};
+};
+
 /* The virtqueue structure describes a queue attached to a device. */
 struct vhost_virtqueue {
 	struct vhost_dev *dev;
@@ -110,9 +116,9 @@ struct vhost_virtqueue {
 	bool log_used;
 	u64 log_addr;
 
-	struct iovec iov[UIO_MAXIOV];
-	struct iovec iotlb_iov[64];
-	struct iovec *indirect;
+	struct vhost_iov iov[UIO_MAXIOV];
+	struct vhost_iov iotlb_iov[64];
+	struct vhost_iov *indirect;
 	struct vring_used_elem *heads;
 	/* Protected by virtqueue mutex. */
 	struct vhost_iotlb *umem;
@@ -123,7 +129,7 @@ struct vhost_virtqueue {
 	/* Log write descriptors */
 	void __user *log_base;
 	struct vhost_log *log;
-	struct iovec log_iov[64];
+	struct vhost_iov log_iov[64];
 
 	/* Ring endianness. Defaults to legacy native endianness.
 	 * Set to true when starting a modern virtio device. */
@@ -167,6 +173,26 @@ struct vhost_dev {
 			   struct vhost_iotlb_msg *msg);
 };
 
+static inline size_t vhost_iov_length(const struct vhost_virtqueue *vq, struct vhost_iov *iov,
+				      unsigned long nr_segs)
+{
+	return iov_length(&iov->iovec, nr_segs);
+}
+
+static inline size_t vhost_iov_len(const struct vhost_virtqueue *vq, struct vhost_iov *iov)
+{
+	return iov->iovec.iov_len;
+}
+
+static inline void vhost_iov_iter_init(const struct vhost_virtqueue *vq,
+				       struct iov_iter *i, unsigned int direction,
+				       struct vhost_iov *iov,
+				       unsigned long nr_segs,
+				       size_t count)
+{
+	iov_iter_init(i, direction, &iov->iovec, nr_segs, count);
+}
+
 bool vhost_exceeds_weight(struct vhost_virtqueue *vq, int pkts, int total_len);
 void vhost_dev_init(struct vhost_dev *, struct vhost_virtqueue **vqs,
 		    int nvqs, int iov_limit, int weight, int byte_weight,
@@ -186,9 +212,19 @@ bool vhost_vq_access_ok(struct vhost_virtqueue *vq);
 bool vhost_log_access_ok(struct vhost_dev *);
 
 int vhost_get_vq_desc(struct vhost_virtqueue *,
-		      struct iovec iov[], unsigned int iov_count,
+		      struct vhost_iov iov[], unsigned int iov_count,
 		      unsigned int *out_num, unsigned int *in_num,
 		      struct vhost_log *log, unsigned int *log_num);
+
+int vhost_get_vq_desc_viov(struct vhost_virtqueue *vq,
+			   struct vhost_iov *viov,
+			   unsigned int *out_num, unsigned int *in_num,
+			   struct vhost_log *log, unsigned int *log_num);
+int vhost_get_vq_desc_viov_offset(struct vhost_virtqueue *vq,
+			   struct vhost_iov *viov,
+			   int offset,
+			   unsigned int *out_num, unsigned int *in_num,
+			   struct vhost_log *log, unsigned int *log_num);
 void vhost_discard_vq_desc(struct vhost_virtqueue *, int n);
 
 bool vhost_vq_is_setup(struct vhost_virtqueue *vq);
@@ -207,7 +243,7 @@ bool vhost_enable_notify(struct vhost_dev *, struct vhost_virtqueue *);
 
 int vhost_log_write(struct vhost_virtqueue *vq, struct vhost_log *log,
 		    unsigned int log_num, u64 len,
-		    struct iovec *iov, int count);
+		    struct vhost_iov *viov, int count);
 int vq_meta_prefetch(struct vhost_virtqueue *vq);
 
 struct vhost_msg_node *vhost_new_msg(struct vhost_virtqueue *vq, int type);
diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 938aefbc75ec..190e5a6ea045 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -158,14 +158,14 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 			break;
 		}
 
-		iov_len = iov_length(&vq->iov[out], in);
+		iov_len = vhost_iov_length(vq, &vq->iov[out], in);
 		if (iov_len < sizeof(pkt->hdr)) {
 			virtio_transport_free_pkt(pkt);
 			vq_err(vq, "Buffer len [%zu] too small\n", iov_len);
 			break;
 		}
 
-		iov_iter_init(&iov_iter, READ, &vq->iov[out], in, iov_len);
+		vhost_iov_iter_init(vq, &iov_iter, READ, &vq->iov[out], in, iov_len);
 		payload_len = pkt->len - pkt->off;
 
 		/* If the packet is greater than the space available in the
@@ -370,8 +370,8 @@ vhost_vsock_alloc_pkt(struct vhost_virtqueue *vq,
 	if (!pkt)
 		return NULL;
 
-	len = iov_length(vq->iov, out);
-	iov_iter_init(&iov_iter, WRITE, vq->iov, out, len);
+	len = vhost_iov_length(vq, vq->iov, out);
+	vhost_iov_iter_init(vq, &iov_iter, WRITE, vq->iov, out, len);
 
 	nbytes = copy_from_iter(&pkt->hdr, sizeof(pkt->hdr), &iov_iter);
 	if (nbytes != sizeof(pkt->hdr)) {
-- 
2.28.0

