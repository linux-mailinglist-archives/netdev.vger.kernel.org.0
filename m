Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1E74458BD
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 18:37:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233978AbhKDRkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 13:40:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:49350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233976AbhKDRkP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Nov 2021 13:40:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7301F60EFE;
        Thu,  4 Nov 2021 17:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636047457;
        bh=/IFqaPgL6PnwnttujhbogBxwr3lKfTj1U/DLqTGzF/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AUCQ5I7u2sVjAAT1gKVJwnano82IpxnXr4BhPTRW+MWi4IEMzUo/AQU/S/V0bOk5f
         ePsoVZZ4YeIPZf70AL3d2jTb49nPVAIXawx4Y6qM4MMAG9VcJSjfs6tBEpw5CB8y3B
         9rC9Gu6VEPWFWAmAumP/HRlZ275Oy5/KKrs7Ob8qwJc0iKHD/066k1g1nB/QLoS3qC
         kOn0i34n+a+hSp7GhyhDERIf8CdLW1Kb2VQx9W1VIKv3ZB7lnZ239oNk/QEwuSSpr8
         gMME+78yegRuTovpbhm6p2Ovc5C10UhpEZazDxBHW7ObAgwHyZLbpcLXtb/Jy5e6fD
         r0PmWUNRriFTQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v17 bpf-next 20/23] net: xdp: introduce bpf_xdp_pointer utility routine
Date:   Thu,  4 Nov 2021 18:35:40 +0100
Message-Id: <273cc085c8cbe5913defe302800fc69da650e7b1.1636044387.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1636044387.git.lorenzo@kernel.org>
References: <cover.1636044387.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to skb_header_pointer, introduce bpf_xdp_pointer utility routine
to return a pointer to a given position in the xdp_buff if the requested
area (offset + len) is contained in a contiguous memory area otherwise it
will be copied in a bounce buffer provided by the caller.
Similar to the tc counterpart, introduce the two following xdp helpers:
- bpf_xdp_load_bytes
- bpf_xdp_store_bytes

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/uapi/linux/bpf.h       |  18 +++++
 net/core/filter.c              | 133 +++++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h |  18 +++++
 3 files changed, 169 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index c643be066700..a63c7080b74d 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4949,6 +4949,22 @@ union bpf_attr {
  *		Get the total size of a given xdp buff (linear and paged area)
  *	Return
  *		The total size of a given xdp buffer.
+ *
+ * long bpf_xdp_load_bytes(struct xdp_buff *xdp_md, u32 offset, void *buf, u32 len)
+ *	Description
+ *		This helper is provided as an easy way to load data from a
+ *		xdp buffer. It can be used to load *len* bytes from *offset* from
+ *		the frame associated to *xdp_md*, into the buffer pointed by
+ *		*buf*.
+ *	Return
+ *		0 on success, or a negative error in case of failure.
+ *
+ * long bpf_xdp_store_bytes(struct xdp_buff *xdp_md, u32 offset, void *buf, u32 len)
+ *	Description
+ *		Store *len* bytes from buffer *buf* into the frame
+ *		associated to *xdp_md*, at *offset*.
+ *	Return
+ *		0 on success, or a negative error in case of failure.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5132,6 +5148,8 @@ union bpf_attr {
 	FN(skc_to_unix_sock),		\
 	FN(kallsyms_lookup_name),	\
 	FN(xdp_get_buff_len),		\
+	FN(xdp_load_bytes),		\
+	FN(xdp_store_bytes),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/net/core/filter.c b/net/core/filter.c
index 386dd2fffded..534305037ad7 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3840,6 +3840,135 @@ static const struct bpf_func_proto bpf_xdp_adjust_head_proto = {
 	.arg2_type	= ARG_ANYTHING,
 };
 
+static void bpf_xdp_copy_buf(struct xdp_buff *xdp, u32 offset,
+			     u32 len, void *buf, bool flush)
+{
+	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
+	u32 headsize = xdp->data_end - xdp->data;
+	u32 count = 0, frame_offset = headsize;
+	int i = 0;
+
+	if (offset < headsize) {
+		int size = min_t(int, headsize - offset, len);
+		void *src = flush ? buf : xdp->data + offset;
+		void *dst = flush ? xdp->data + offset : buf;
+
+		memcpy(dst, src, size);
+		count = size;
+		offset = 0;
+	}
+
+	while (count < len && i < sinfo->nr_frags) {
+		skb_frag_t *frag = &sinfo->frags[i++];
+		u32 frag_size = skb_frag_size(frag);
+
+		if  (offset < frame_offset + frag_size) {
+			int size = min_t(int, frag_size - offset, len - count);
+			void *addr = skb_frag_address(frag);
+			void *src = flush ? buf + count : addr + offset;
+			void *dst = flush ? addr + offset : buf + count;
+
+			memcpy(dst, src, size);
+			count += size;
+			offset = 0;
+		}
+		frame_offset += frag_size;
+	}
+}
+
+static void *bpf_xdp_pointer(struct xdp_buff *xdp, u32 offset,
+			     u32 len, void *buf)
+{
+	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
+	u32 size = xdp->data_end - xdp->data;
+	void *addr = xdp->data;
+	int i;
+
+	if (unlikely(offset > 0xffff))
+		return ERR_PTR(-EFAULT);
+
+	if (offset + len > xdp_get_buff_len(xdp))
+		return ERR_PTR(-EINVAL);
+
+	if (offset < size) /* linear area */
+		goto out;
+
+	offset -= size;
+	for (i = 0; i < sinfo->nr_frags; i++) { /* paged area */
+		u32 frag_size = skb_frag_size(&sinfo->frags[i]);
+
+		if  (offset < frag_size) {
+			addr = skb_frag_address(&sinfo->frags[i]);
+			size = frag_size;
+			break;
+		}
+		offset -= frag_size;
+	}
+
+out:
+	if (offset + len < size)
+		return addr + offset; /* fast path - no need to copy */
+
+	if (!buf) /* no copy to the bounce buffer */
+		return NULL;
+
+	/* slow path - we need to copy data into the bounce buffer */
+	bpf_xdp_copy_buf(xdp, offset, len, buf, false);
+	return buf;
+}
+
+BPF_CALL_4(bpf_xdp_load_bytes, struct xdp_buff *, xdp, u32, offset,
+	   void *, buf, u32, len)
+{
+	void *ptr;
+
+	ptr = bpf_xdp_pointer(xdp, offset, len, buf);
+	if (IS_ERR(ptr))
+		return PTR_ERR(ptr);
+
+	if (ptr != buf)
+		memcpy(buf, ptr, len);
+
+	return 0;
+}
+
+static const struct bpf_func_proto bpf_xdp_load_bytes_proto = {
+	.func		= bpf_xdp_load_bytes,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX,
+	.arg2_type	= ARG_ANYTHING,
+	.arg3_type	= ARG_PTR_TO_UNINIT_MEM,
+	.arg4_type	= ARG_CONST_SIZE,
+};
+
+BPF_CALL_4(bpf_xdp_store_bytes, struct xdp_buff *, xdp, u32, offset,
+	   void *, buf, u32, len)
+{
+	void *ptr;
+
+	ptr = bpf_xdp_pointer(xdp, offset, len, NULL);
+	if (IS_ERR(ptr))
+		return PTR_ERR(ptr);
+
+	if (!ptr)
+		bpf_xdp_copy_buf(xdp, offset, len, buf, true);
+	else
+		memcpy(ptr, buf, len);
+
+	return 0;
+}
+
+static const struct bpf_func_proto bpf_xdp_store_bytes_proto = {
+	.func		= bpf_xdp_store_bytes,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX,
+	.arg2_type	= ARG_ANYTHING,
+	.arg3_type	= ARG_PTR_TO_UNINIT_MEM,
+	.arg4_type	= ARG_CONST_SIZE,
+};
+
 static int bpf_xdp_mb_increase_tail(struct xdp_buff *xdp, int offset)
 {
 	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
@@ -7601,6 +7730,10 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_xdp_adjust_tail_proto;
 	case BPF_FUNC_xdp_get_buff_len:
 		return &bpf_xdp_get_buff_len_proto;
+	case BPF_FUNC_xdp_load_bytes:
+		return &bpf_xdp_load_bytes_proto;
+	case BPF_FUNC_xdp_store_bytes:
+		return &bpf_xdp_store_bytes_proto;
 	case BPF_FUNC_fib_lookup:
 		return &bpf_xdp_fib_lookup_proto;
 	case BPF_FUNC_check_mtu:
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index c643be066700..a63c7080b74d 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4949,6 +4949,22 @@ union bpf_attr {
  *		Get the total size of a given xdp buff (linear and paged area)
  *	Return
  *		The total size of a given xdp buffer.
+ *
+ * long bpf_xdp_load_bytes(struct xdp_buff *xdp_md, u32 offset, void *buf, u32 len)
+ *	Description
+ *		This helper is provided as an easy way to load data from a
+ *		xdp buffer. It can be used to load *len* bytes from *offset* from
+ *		the frame associated to *xdp_md*, into the buffer pointed by
+ *		*buf*.
+ *	Return
+ *		0 on success, or a negative error in case of failure.
+ *
+ * long bpf_xdp_store_bytes(struct xdp_buff *xdp_md, u32 offset, void *buf, u32 len)
+ *	Description
+ *		Store *len* bytes from buffer *buf* into the frame
+ *		associated to *xdp_md*, at *offset*.
+ *	Return
+ *		0 on success, or a negative error in case of failure.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5132,6 +5148,8 @@ union bpf_attr {
 	FN(skc_to_unix_sock),		\
 	FN(kallsyms_lookup_name),	\
 	FN(xdp_get_buff_len),		\
+	FN(xdp_load_bytes),		\
+	FN(xdp_store_bytes),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.31.1

