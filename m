Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9166EC1FE
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 21:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbjDWTbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 15:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbjDWTba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 15:31:30 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 685DFE5D;
        Sun, 23 Apr 2023 12:31:27 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id A87C85FD10;
        Sun, 23 Apr 2023 22:31:19 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1682278279;
        bh=soNB+BivCyZDwOU52K+dmSsvfGU1rviaXB5JmG9YPLE=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=sVFBzGusith+KND7O+E/ZALbE8y2S5UsYJCSUt3FwEp9tLCITYSg91C1iRpmvoHq+
         GW0gZ5zxE+dkp3+Uu3j8ip8K+T3FVw3Idm+4BCJgq2Wb+uh/HgHnA6mxNfxuGJ/hw2
         xqMfEd79puhH4s3s7GeTI8u/LvxtctsGHi+93BJOuFTCy4D2HERq8uFCBYPWs/Azi4
         a9LmjBEsKdwZVtk+R3ey6hlwbfX8rxYCaUnWIYWgpezs8XGTqXsX9cRFlcHq/Ksgai
         vJKKS/VVICtX8LEGA2iwm+HNNJwCAK1oLFDfii6ch1yNzQMzzCZM/HvR7HnOti5V/G
         bcAQpDkkYJimA==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sun, 23 Apr 2023 22:31:19 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@sberdevices.ru>, <oxffffaa@gmail.com>,
        <avkrasnov@sberdevices.ru>,
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Subject: [RFC PATCH v2 05/15] vsock/virtio: MSG_ZEROCOPY flag support
Date:   Sun, 23 Apr 2023 22:26:33 +0300
Message-ID: <20230423192643.1537470-6-AVKrasnov@sberdevices.ru>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20230423192643.1537470-1-AVKrasnov@sberdevices.ru>
References: <20230423192643.1537470-1-AVKrasnov@sberdevices.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH01.sberdevices.ru (172.16.1.4) To
 S-MS-EXCH01.sberdevices.ru (172.16.1.4)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/04/23 16:01:00 #21150277
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds handling of MSG_ZEROCOPY flag on transmission path, by alloc
non-linear skbuffs and filling it with user's pages.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 net/vmw_vsock/virtio_transport_common.c | 390 ++++++++++++++++++++----
 1 file changed, 332 insertions(+), 58 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 280497d97076..3c024d0d795c 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -37,27 +37,227 @@ virtio_transport_get_ops(struct vsock_sock *vsk)
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
+static bool virtio_transport_can_zcopy(struct virtio_vsock_pkt_info *info,
+				       size_t max_to_send)
+{
+	struct iov_iter *iov_iter;
+	size_t max_skb_cap;
+	size_t bytes;
+	int i;
+
+	if (!(info->flags & MSG_ZEROCOPY))
+		return false;
+
+	if (!info->msg)
+		return false;
+
+	iov_iter = &info->msg->msg_iter;
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
+		iovec = &iov_iter->iov[i];
+
+		/* Base must be page aligned. */
+		if (offset_in_page(iovec->iov_base))
+			return false;
+
+		/* Only last element could have non page aligned size. */
+		if (i != (iov_iter->nr_segs - 1)) {
+			if (offset_in_page(iovec->iov_len))
+				return false;
+
+			pages_in_elem = iovec->iov_len >> PAGE_SHIFT;
+		} else {
+			pages_in_elem = round_up(iovec->iov_len, PAGE_SIZE);
+			pages_in_elem >>= PAGE_SHIFT;
+		}
+
+		bytes += (pages_in_elem * PAGE_SIZE);
+	}
+
+	/* How many bytes we can pack to single skb. Maximum packet
+	 * buffer size is needed to allow vhost handle such packets,
+	 * otherwise they will be dropped.
+	 */
+	max_skb_cap = min((unsigned int)(MAX_SKB_FRAGS * PAGE_SIZE),
+			  (unsigned int)VIRTIO_VSOCK_MAX_PKT_BUF_SIZE);
+
+	return true;
+}
+
+static int virtio_transport_init_zcopy_skb(struct vsock_sock *vsk,
+					   struct sk_buff *skb,
+					   struct iov_iter *iter,
+					   bool zerocopy)
+{
+	struct ubuf_info_msgzc *uarg_zc;
+	struct ubuf_info *uarg;
+
+	uarg = msg_zerocopy_realloc(sk_vsock(vsk),
+				    iov_length(iter->iov, iter->nr_segs),
+				    NULL);
+
+	if (!uarg)
+		return -1;
+
+	uarg_zc = uarg_to_msgzc(uarg);
+	uarg_zc->zerocopy = zerocopy ? 1 : 0;
+
+	skb_zcopy_init(skb, uarg);
+
+	return 0;
+}
+
+static int get_iov_elem(struct iov_iter *iter, ssize_t *offset)
+{
+	int i;
+
+	*offset = iter->iov_offset;
+
+	for (i = 0; i < iter->nr_segs; i++) {
+		if (*offset - (ssize_t)iter->iov[i].iov_len < 0)
+			return i;
+
+		*offset -= iter->iov[i].iov_len;
+	}
+
+	return -1;
+}
+
+static int virtio_transport_fill_nonlinear_skb(struct sk_buff *skb,
+					       struct vsock_sock *vsk,
+					       struct virtio_vsock_pkt_info *info,
+					       size_t payload_len)
+{
+	size_t payload_rest_len;
+	int frag_idx;
+	int err = 0;
+
+	if (!info->msg)
+		return 0;
+
+	frag_idx = 0;
+	VIRTIO_VSOCK_SKB_CB(skb)->curr_frag = 0;
+	VIRTIO_VSOCK_SKB_CB(skb)->frag_off = 0;
+	payload_rest_len = payload_len;
+
+	while (payload_rest_len) {
+		struct page *user_pages[MAX_SKB_FRAGS];
+		const struct iovec *iovec;
+		struct iov_iter *iter;
+		size_t last_frag_len;
+		ssize_t offs_in_iov;
+		size_t curr_iov_len;
+		size_t pages_in_seg;
+		long pinned_pages;
+		int page_idx;
+		int seg_idx;
+
+		iter = &info->msg->msg_iter;
+		seg_idx = get_iov_elem(iter, &offs_in_iov);
+		if (seg_idx < 0) {
+			err = -1;
+			break;
+		}
+
+		iovec = &iter->iov[seg_idx];
+		curr_iov_len = min(iovec->iov_len - offs_in_iov,
+				   payload_rest_len);
+		pages_in_seg = curr_iov_len >> PAGE_SHIFT;
+
+		if (curr_iov_len % PAGE_SIZE) {
+			last_frag_len = curr_iov_len % PAGE_SIZE;
+			pages_in_seg++;
+		} else {
+			last_frag_len = PAGE_SIZE;
+		}
+
+		pinned_pages = pin_user_pages((unsigned long)iovec->iov_base +
+						offs_in_iov, pages_in_seg,
+						FOLL_ANON, user_pages, NULL);
+
+		if (pinned_pages != pages_in_seg) {
+			/* Unpin partially pinned pages. */
+			unpin_user_pages(user_pages, pinned_pages);
+			err = -1;
+			break;
+		}
+
+		for (page_idx = 0; page_idx < pages_in_seg; page_idx++) {
+			int frag_len = PAGE_SIZE;
+
+			if (page_idx == (pages_in_seg - 1))
+				frag_len = last_frag_len;
+
+			/* 'get_page()' as pair to 'put_page()' during
+			 * this non-linear skbuff deallocation.
+			 */
+			get_page(user_pages[page_idx]);
+			skb_fill_page_desc(skb, frag_idx,
+					   user_pages[page_idx], 0,
+					   frag_len);
+			skb_len_add(skb, frag_len);
+			frag_idx++;
+		}
+
+		iter->iov_offset += curr_iov_len;
+		payload_rest_len -= curr_iov_len;
+	}
+
+	return err;
+}
+
+static int virtio_transport_fill_linear_skb(struct sk_buff *skb,
+					    struct vsock_sock *vsk,
+					    struct virtio_vsock_pkt_info *info,
+					    size_t len)
+{
 	void *payload;
 	int err;
 
-	skb = virtio_vsock_alloc_skb(skb_len, GFP_KERNEL);
-	if (!skb)
-		return NULL;
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
 
 	hdr = virtio_vsock_hdr(skb);
 	hdr->type	= cpu_to_le16(info->type);
@@ -68,37 +268,6 @@ virtio_transport_alloc_skb(struct virtio_vsock_pkt_info *info,
 	hdr->dst_port	= cpu_to_le32(dst_port);
 	hdr->flags	= cpu_to_le32(info->flags);
 	hdr->len	= cpu_to_le32(len);
-
-	if (info->msg && len > 0) {
-		payload = skb_put(skb, len);
-		err = memcpy_from_msg(payload, info->msg, len);
-		if (err)
-			goto out;
-
-		if (msg_data_left(info->msg) == 0 &&
-		    info->type == VIRTIO_VSOCK_TYPE_SEQPACKET) {
-			hdr->flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
-
-			if (info->msg->msg_flags & MSG_EOR)
-				hdr->flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
-		}
-	}
-
-	if (info->reply)
-		virtio_vsock_skb_set_reply(skb);
-
-	trace_virtio_transport_alloc_pkt(src_cid, src_port,
-					 dst_cid, dst_port,
-					 len,
-					 info->type,
-					 info->op,
-					 info->flags);
-
-	return skb;
-
-out:
-	kfree_skb(skb);
-	return NULL;
 }
 
 int virtio_transport_nl_skb_to_iov(struct sk_buff *skb,
@@ -209,6 +378,88 @@ static u16 virtio_transport_get_type(struct sock *sk)
 		return VIRTIO_VSOCK_TYPE_SEQPACKET;
 }
 
+static void virtio_transport_unpin_skb(struct sk_buff *skb)
+{
+	int i;
+
+	if (!skb_is_nonlinear(skb))
+		return;
+
+	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+		struct bio_vec *frag;
+		int nr_pages;
+		int page;
+
+		frag = &skb_shinfo(skb)->frags[i];
+		nr_pages = frag->bv_len / PAGE_SIZE;
+
+		if (frag->bv_len % PAGE_SIZE)
+			nr_pages++;
+
+		for (page = 0; page < nr_pages; page++)
+			unpin_user_page(&frag->bv_page[page]);
+	}
+}
+
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
+			skb->destructor = virtio_transport_unpin_skb;
+			err = virtio_transport_fill_nonlinear_skb(skb, vsk, info, payload_len);
+		} else {
+			err = virtio_transport_fill_linear_skb(skb, vsk, info, payload_len);
+		}
+
+		if (err)
+			goto out;
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
+	return skb;
+out:
+	kfree_skb(skb);
+	return NULL;
+}
+
 /* This function can only be used on connecting/connected sockets,
  * since a socket assigned to a transport is required.
  *
@@ -221,6 +472,8 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
 	const struct virtio_transport *t_ops;
 	struct virtio_vsock_sock *vvs;
 	u32 pkt_len = info->pkt_len;
+	bool can_zcopy = false;
+	u32 max_skb_cap;
 	u32 rest_len;
 	int ret;
 
@@ -230,6 +483,9 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
 	if (unlikely(!t_ops))
 		return -EFAULT;
 
+	if (!sock_flag(sk_vsock(vsk), SOCK_ZEROCOPY))
+		info->flags &= ~MSG_ZEROCOPY;
+
 	src_cid = t_ops->transport.get_local_cid();
 	src_port = vsk->local_addr.svm_port;
 	if (!info->remote_cid) {
@@ -249,22 +505,36 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
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
+		    info->op == VIRTIO_VSOCK_OP_RW)
+			virtio_transport_init_zcopy_skb(vsk, skb,
+							&info->msg->msg_iter,
+							can_zcopy);
+
 		virtio_transport_inc_tx_pkt(vvs, skb);
 
 		ret = t_ops->send_pkt(skb);
@@ -945,6 +1215,7 @@ virtio_transport_stream_enqueue(struct vsock_sock *vsk,
 		.msg = msg,
 		.pkt_len = len,
 		.vsk = vsk,
+		.flags = msg->msg_flags,
 	};
 
 	return virtio_transport_send_pkt_info(vsk, &info);
@@ -988,6 +1259,7 @@ static int virtio_transport_reset_no_sock(const struct virtio_transport *t,
 		.reply = true,
 	};
 	struct sk_buff *reply;
+	int res;
 
 	/* Send RST only if the original pkt is not a RST pkt */
 	if (le16_to_cpu(hdr->op) == VIRTIO_VSOCK_OP_RST)
@@ -996,15 +1268,17 @@ static int virtio_transport_reset_no_sock(const struct virtio_transport *t,
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
 
-	return t->send_pkt(reply);
+	res = t->send_pkt(reply);
+
+	return res;
 }
 
 /* This function should be called with sk_lock held and SOCK_DONE set */
-- 
2.25.1

