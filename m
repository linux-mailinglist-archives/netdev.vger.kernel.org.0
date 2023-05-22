Return-Path: <netdev+bounces-4158-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 30E8A70B6E6
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 09:46:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA076280F10
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 07:46:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C8B69445;
	Mon, 22 May 2023 07:44:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387178F76
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 07:44:52 +0000 (UTC)
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B0B4B0;
	Mon, 22 May 2023 00:44:50 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
	by mx.sberdevices.ru (Postfix) with ESMTP id BF0CA5FD4F;
	Mon, 22 May 2023 10:44:47 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
	s=mail; t=1684741487;
	bh=5aUaXZ94rUf7TollZJk+zDPVN7R5OXrmAGV4mInvqVc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=lLauUXi9KCLiFDUwYiyrySOSyef7kcxKUwWftkv7R4JlI9YWZq0A5LA8Ql4dQyVRK
	 vHnk/hUg7uxqU5C6ufV54qyYeqqojGdxe/B0aiDMNAkINk1JgkevZEg+XMLAmczjFc
	 CSHY+OAAQ8sP2XgACKaLQz5wEfV6h63qus7SBcpG38Qu+onyfyFjvlM5Y+keF00RPt
	 tSOo/zmajGGlSuKZyDFy3VFwa/VOK2y7YASlEYrbrG5dVKAVRStmGyij0mZVixEDx0
	 N7YUJyoG8fsns8+0/skNKbsrP7HTzrkUoq4Fa6QxsmAW+2cUwAFAn/XofUrdakQu3v
	 FFiDQHC8Vf8ew==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
	by mx.sberdevices.ru (Postfix) with ESMTP;
	Mon, 22 May 2023 10:44:47 +0300 (MSK)
From: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To: Stefan Hajnoczi <stefanha@redhat.com>, Stefano Garzarella
	<sgarzare@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang
	<jasowang@redhat.com>, Bobby Eshleman <bobby.eshleman@bytedance.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kernel@sberdevices.ru>, <oxffffaa@gmail.com>, <avkrasnov@sberdevices.ru>,
	Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Subject: [RFC PATCH v3 05/17] vsock/virtio: MSG_ZEROCOPY flag support
Date: Mon, 22 May 2023 10:39:38 +0300
Message-ID: <20230522073950.3574171-6-AVKrasnov@sberdevices.ru>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20230522073950.3574171-1-AVKrasnov@sberdevices.ru>
References: <20230522073950.3574171-1-AVKrasnov@sberdevices.ru>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH02.sberdevices.ru (172.16.1.5) To
 S-MS-EXCH01.sberdevices.ru (172.16.1.4)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/05/22 04:49:00 #21364689
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This adds handling of MSG_ZEROCOPY flag on transmission path: if this
flag is set and zerocopy transmission is possible, then non-linear skb
will be created and filled with the pages of user's buffer. Pages of
user's buffer are locked in memory by 'get_user_pages()'.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 net/vmw_vsock/virtio_transport_common.c | 305 +++++++++++++++++++-----
 1 file changed, 243 insertions(+), 62 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 9854f48a0544..5acf824afe41 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -37,73 +37,161 @@ virtio_transport_get_ops(struct vsock_sock *vsk)
 	return container_of(t, struct virtio_transport, transport);
 }
 
-/* Returns a new packet on success, otherwise returns NULL.
- *
- * If NULL is returned, errp is set to a negative errno.
- */
-static struct sk_buff *
-virtio_transport_alloc_skb(struct virtio_vsock_pkt_info *info,
-			   size_t len,
-			   u32 src_cid,
-			   u32 src_port,
-			   u32 dst_cid,
-			   u32 dst_port)
-{
-	const size_t skb_len = VIRTIO_VSOCK_SKB_HEADROOM + len;
-	struct virtio_vsock_hdr *hdr;
-	struct sk_buff *skb;
-	void *payload;
-	int err;
+static bool virtio_transport_can_zcopy(struct virtio_vsock_pkt_info *info,
+				       size_t max_to_send)
+{
+	struct iov_iter *iov_iter;
+	size_t max_skb_cap;
+	size_t bytes;
+	int i;
 
-	skb = virtio_vsock_alloc_skb(skb_len, GFP_KERNEL);
-	if (!skb)
-		return NULL;
+	if (!info->msg)
+		return false;
 
-	hdr = virtio_vsock_hdr(skb);
-	hdr->type	= cpu_to_le16(info->type);
-	hdr->op		= cpu_to_le16(info->op);
-	hdr->src_cid	= cpu_to_le64(src_cid);
-	hdr->dst_cid	= cpu_to_le64(dst_cid);
-	hdr->src_port	= cpu_to_le32(src_port);
-	hdr->dst_port	= cpu_to_le32(dst_port);
-	hdr->flags	= cpu_to_le32(info->flags);
-	hdr->len	= cpu_to_le32(len);
+	if (!(info->flags & MSG_ZEROCOPY) && !info->msg->msg_ubuf)
+		return false;
 
-	if (info->msg && len > 0) {
-		payload = skb_put(skb, len);
-		err = memcpy_from_msg(payload, info->msg, len);
-		if (err)
-			goto out;
+	iov_iter = &info->msg->msg_iter;
+
+	if (iter_is_ubuf(iov_iter)) {
+		if (offset_in_page(iov_iter->ubuf))
+			return false;
+
+		return true;
+	}
+
+	if (!iter_is_iovec(iov_iter))
+		return false;
+
+	if (iov_iter->iov_offset)
+		return false;
+
+	/* We can't send whole iov. */
+	if (iov_iter->count > max_to_send)
+		return false;
+
+	for (bytes = 0, i = 0; i < iov_iter->nr_segs; i++) {
+		const struct iovec *iovec;
+		int pages_in_elem;
+
+		iovec = &iov_iter->__iov[i];
+
+		/* Base must be page aligned. */
+		if (offset_in_page(iovec->iov_base))
+			return false;
 
-		if (msg_data_left(info->msg) == 0 &&
-		    info->type == VIRTIO_VSOCK_TYPE_SEQPACKET) {
-			hdr->flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
+		/* Only last element could have non page aligned size. */
+		if (i != (iov_iter->nr_segs - 1)) {
+			if (offset_in_page(iovec->iov_len))
+				return false;
 
-			if (info->msg->msg_flags & MSG_EOR)
-				hdr->flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
+			pages_in_elem = iovec->iov_len >> PAGE_SHIFT;
+		} else {
+			pages_in_elem = round_up(iovec->iov_len, PAGE_SIZE);
+			pages_in_elem >>= PAGE_SHIFT;
 		}
+
+		bytes += (pages_in_elem * PAGE_SIZE);
 	}
 
-	if (info->reply)
-		virtio_vsock_skb_set_reply(skb);
+	/* How many bytes we can pack to single skb. Maximum packet
+	 * buffer size is needed to allow vhost handle such packets,
+	 * otherwise they will be dropped.
+	 */
+	max_skb_cap = min((unsigned int)(MAX_SKB_FRAGS * PAGE_SIZE),
+			  (unsigned int)VIRTIO_VSOCK_MAX_PKT_BUF_SIZE);
 
-	trace_virtio_transport_alloc_pkt(src_cid, src_port,
-					 dst_cid, dst_port,
-					 len,
-					 info->type,
-					 info->op,
-					 info->flags);
+	return true;
+}
 
-	if (info->vsk && !skb_set_owner_sk_safe(skb, sk_vsock(info->vsk))) {
-		WARN_ONCE(1, "failed to allocate skb on vsock socket with sk_refcnt == 0\n");
-		goto out;
+static int virtio_transport_init_zcopy_skb(struct vsock_sock *vsk,
+					   struct sk_buff *skb,
+					   struct msghdr *msg,
+					   bool zerocopy)
+{
+	struct ubuf_info *uarg;
+
+	if (msg->msg_ubuf) {
+		uarg = msg->msg_ubuf;
+		net_zcopy_get(uarg);
+	} else {
+		struct iov_iter *iter = &msg->msg_iter;
+		struct ubuf_info_msgzc *uarg_zc;
+		int len;
+
+		/* Only ITER_IOVEC or ITER_UBUF are allowed and
+		 * checked before.
+		 */
+		if (iter_is_iovec(iter))
+			len = iov_length(iter->__iov, iter->nr_segs);
+		else
+			len = iter->count;
+
+		uarg = msg_zerocopy_realloc(sk_vsock(vsk),
+					    len,
+					    NULL);
+
+		if (!uarg)
+			return -1;
+
+		uarg_zc = uarg_to_msgzc(uarg);
+		uarg_zc->zerocopy = zerocopy ? 1 : 0;
 	}
 
-	return skb;
+	skb_zcopy_init(skb, uarg);
 
-out:
-	kfree_skb(skb);
-	return NULL;
+	return 0;
+}
+
+static int virtio_transport_fill_linear_skb(struct sk_buff *skb,
+					    struct vsock_sock *vsk,
+					    struct virtio_vsock_pkt_info *info,
+					    size_t len)
+{
+	void *payload;
+	int err;
+
+	payload = skb_put(skb, len);
+	err = memcpy_from_msg(payload, info->msg, len);
+	if (err)
+		return -1;
+
+	if (msg_data_left(info->msg))
+		return 0;
+
+	if (info->type == VIRTIO_VSOCK_TYPE_SEQPACKET) {
+		struct virtio_vsock_hdr *hdr;
+
+		hdr = virtio_vsock_hdr(skb);
+
+		hdr->flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
+
+		if (info->msg->msg_flags & MSG_EOR)
+			hdr->flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
+	}
+
+	return 0;
+}
+
+static void virtio_transport_init_hdr(struct sk_buff *skb,
+				      struct virtio_vsock_pkt_info *info,
+				      u32 src_cid,
+				      u32 src_port,
+				      u32 dst_cid,
+				      u32 dst_port,
+				      size_t len)
+{
+	struct virtio_vsock_hdr *hdr;
+
+	hdr = virtio_vsock_hdr(skb);
+	hdr->type	= cpu_to_le16(info->type);
+	hdr->op		= cpu_to_le16(info->op);
+	hdr->src_cid	= cpu_to_le64(src_cid);
+	hdr->dst_cid	= cpu_to_le64(dst_cid);
+	hdr->src_port	= cpu_to_le32(src_port);
+	hdr->dst_port	= cpu_to_le32(dst_port);
+	hdr->flags	= cpu_to_le32(info->flags);
+	hdr->len	= cpu_to_le32(len);
 }
 
 static void virtio_transport_copy_nonlinear_skb(struct sk_buff *skb,
@@ -214,6 +302,75 @@ static u16 virtio_transport_get_type(struct sock *sk)
 		return VIRTIO_VSOCK_TYPE_SEQPACKET;
 }
 
+/* Returns a new packet on success, otherwise returns NULL.
+ *
+ * If NULL is returned, errp is set to a negative errno.
+ */
+static struct sk_buff *virtio_transport_alloc_skb(struct vsock_sock *vsk,
+						  struct virtio_vsock_pkt_info *info,
+						  size_t payload_len,
+						  bool zcopy,
+						  u32 dst_cid,
+						  u32 dst_port,
+						  u32 src_cid,
+						  u32 src_port)
+{
+	struct sk_buff *skb;
+	size_t skb_len;
+
+	skb_len = VIRTIO_VSOCK_SKB_HEADROOM;
+
+	if (!zcopy)
+		skb_len += payload_len;
+
+	skb = virtio_vsock_alloc_skb(skb_len, GFP_KERNEL);
+	if (!skb)
+		return NULL;
+
+	virtio_transport_init_hdr(skb, info, src_cid, src_port,
+				  dst_cid, dst_port,
+				  payload_len);
+
+	if (info->msg && payload_len > 0) {
+		int err;
+
+		if (zcopy) {
+			struct sock *sk = sk_vsock(vsk);
+
+			err = __zerocopy_sg_from_iter(info->msg, sk, skb,
+						      &info->msg->msg_iter,
+						      payload_len);
+		} else {
+			err = virtio_transport_fill_linear_skb(skb, vsk, info, payload_len);
+		}
+
+		if (err)
+			goto out;
+
+		VIRTIO_VSOCK_SKB_CB(skb)->frag_off = 0;
+	}
+
+	if (info->reply)
+		virtio_vsock_skb_set_reply(skb);
+
+	trace_virtio_transport_alloc_pkt(src_cid, src_port,
+					 dst_cid, dst_port,
+					 payload_len,
+					 info->type,
+					 info->op,
+					 info->flags);
+
+	if (info->vsk && !skb_set_owner_sk_safe(skb, sk_vsock(info->vsk))) {
+		WARN_ONCE(1, "failed to allocate skb on vsock socket with sk_refcnt == 0\n");
+		goto out;
+	}
+
+	return skb;
+out:
+	kfree_skb(skb);
+	return NULL;
+}
+
 /* This function can only be used on connecting/connected sockets,
  * since a socket assigned to a transport is required.
  *
@@ -226,6 +383,8 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
 	const struct virtio_transport *t_ops;
 	struct virtio_vsock_sock *vvs;
 	u32 pkt_len = info->pkt_len;
+	bool can_zcopy = false;
+	u32 max_skb_cap;
 	u32 rest_len;
 	int ret;
 
@@ -235,6 +394,9 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
 	if (unlikely(!t_ops))
 		return -EFAULT;
 
+	if (!sock_flag(sk_vsock(vsk), SOCK_ZEROCOPY))
+		info->flags &= ~MSG_ZEROCOPY;
+
 	src_cid = t_ops->transport.get_local_cid();
 	src_port = vsk->local_addr.svm_port;
 	if (!info->remote_cid) {
@@ -254,22 +416,40 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
 	if (pkt_len == 0 && info->op == VIRTIO_VSOCK_OP_RW)
 		return pkt_len;
 
+	can_zcopy = virtio_transport_can_zcopy(info, pkt_len);
+	if (can_zcopy)
+		max_skb_cap = min_t(u32, VIRTIO_VSOCK_MAX_PKT_BUF_SIZE,
+				    (MAX_SKB_FRAGS * PAGE_SIZE));
+	else
+		max_skb_cap = VIRTIO_VSOCK_MAX_PKT_BUF_SIZE;
+
 	rest_len = pkt_len;
 
 	do {
 		struct sk_buff *skb;
 		size_t skb_len;
 
-		skb_len = min_t(u32, VIRTIO_VSOCK_MAX_PKT_BUF_SIZE, rest_len);
+		skb_len = min(max_skb_cap, rest_len);
 
-		skb = virtio_transport_alloc_skb(info, skb_len,
-						 src_cid, src_port,
-						 dst_cid, dst_port);
+		skb = virtio_transport_alloc_skb(vsk, info, skb_len, can_zcopy,
+						 dst_cid, dst_port,
+						 src_cid, src_port);
 		if (!skb) {
 			ret = -ENOMEM;
 			break;
 		}
 
+		if (skb_len == rest_len &&
+		    info->flags & MSG_ZEROCOPY &&
+		    info->op == VIRTIO_VSOCK_OP_RW) {
+			if (virtio_transport_init_zcopy_skb(vsk, skb,
+							    info->msg,
+							    can_zcopy)) {
+				ret = -ENOMEM;
+				break;
+			}
+		}
+
 		virtio_transport_inc_tx_pkt(vvs, skb);
 
 		ret = t_ops->send_pkt(skb);
@@ -884,6 +1064,7 @@ virtio_transport_stream_enqueue(struct vsock_sock *vsk,
 		.msg = msg,
 		.pkt_len = len,
 		.vsk = vsk,
+		.flags = msg->msg_flags,
 	};
 
 	return virtio_transport_send_pkt_info(vsk, &info);
@@ -935,11 +1116,11 @@ static int virtio_transport_reset_no_sock(const struct virtio_transport *t,
 	if (!t)
 		return -ENOTCONN;
 
-	reply = virtio_transport_alloc_skb(&info, 0,
-					   le64_to_cpu(hdr->dst_cid),
-					   le32_to_cpu(hdr->dst_port),
+	reply = virtio_transport_alloc_skb(NULL, &info, 0, false,
 					   le64_to_cpu(hdr->src_cid),
-					   le32_to_cpu(hdr->src_port));
+					   le32_to_cpu(hdr->src_port),
+					   le64_to_cpu(hdr->dst_cid),
+					   le32_to_cpu(hdr->dst_port));
 	if (!reply)
 		return -ENOMEM;
 
-- 
2.25.1


