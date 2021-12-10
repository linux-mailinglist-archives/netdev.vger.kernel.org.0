Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4574470A2D
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 20:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343591AbhLJTUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 14:20:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343583AbhLJTUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 14:20:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 654ECC061746;
        Fri, 10 Dec 2021 11:16:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB33BB829B7;
        Fri, 10 Dec 2021 19:16:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CF88C00446;
        Fri, 10 Dec 2021 19:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639163802;
        bh=+tRcmOQqReto20O77Kj1pFS9ny3i+s/KIaJ1NcCzPzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EY6NPY3GVKSg7qPHECTpOR+P5VDdGrRGlnJ0Fjo9bmqZ662VPry2mHQlLQSzLxK+H
         LHWpCX7k/Uwv1smizOPOZgFAtzsbXghVGRISlZYcCsGLLY8BJnZyrUknNMHMFm1ARR
         Rgz2iwRY2EQcXx3XtxpVGVUpRlXYWPRcaVpUbib4vQmiIQVB/Xol/DjzUcFPyXEQWX
         MAD6X7xV1u/6yHFL8+EEuNqJm3ZRqLbdZby4mN0MfXzAwr/pQCc/7Q0xqZrgdSpLmI
         Qq5nIlahEC6RYvbnRZPJ1QD3jjs9xqDipTFDhFK5/cPicaVava9oL19A8dQeWRWD0G
         yg0jpVHAv8Ifg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v20 bpf-next 20/23] net: xdp: introduce bpf_xdp_pointer utility routine
Date:   Fri, 10 Dec 2021 20:14:27 +0100
Message-Id: <b324d6037054dde457e82846ef4c4b6d9e3d264a.1639162845.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1639162845.git.lorenzo@kernel.org>
References: <cover.1639162845.git.lorenzo@kernel.org>
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

Reviewed-by: Eelco Chaudron <echaudro@redhat.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/uapi/linux/bpf.h       |  18 ++++
 net/core/filter.c              | 176 ++++++++++++++++++++++++++-------
 tools/include/uapi/linux/bpf.h |  18 ++++
 3 files changed, 174 insertions(+), 38 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index d5921a0202f4..94e43088971d 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4994,6 +4994,22 @@ union bpf_attr {
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
@@ -5179,6 +5195,8 @@ union bpf_attr {
 	FN(find_vma),			\
 	FN(loop),			\
 	FN(xdp_get_buff_len),		\
+	FN(xdp_load_bytes),		\
+	FN(xdp_store_bytes),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/net/core/filter.c b/net/core/filter.c
index a5ca054023d0..14860931733d 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3839,6 +3839,138 @@ static const struct bpf_func_proto bpf_xdp_adjust_head_proto = {
 	.arg2_type	= ARG_ANYTHING,
 };
 
+static void bpf_xdp_copy_buf(struct xdp_buff *xdp, unsigned long off,
+			     void *buf, unsigned long len, bool flush)
+{
+	unsigned long ptr_len, ptr_off = 0;
+	skb_frag_t *next_frag, *end_frag;
+	struct skb_shared_info *sinfo;
+	void *src, *dst;
+	u8 *ptr_buf;
+
+	if (likely(xdp->data_end - xdp->data >= off + len)) {
+		src = flush ? buf : xdp->data + off;
+		dst = flush ? xdp->data + off : buf;
+		memcpy(dst, src, len);
+		return;
+	}
+
+	sinfo = xdp_get_shared_info_from_buff(xdp);
+	end_frag = &sinfo->frags[sinfo->nr_frags];
+	next_frag = &sinfo->frags[0];
+
+	ptr_len = xdp->data_end - xdp->data;
+	ptr_buf = xdp->data;
+
+	while (true) {
+		if (off < ptr_off + ptr_len) {
+			unsigned long copy_off = off - ptr_off;
+			unsigned long copy_len = min(len, ptr_len - copy_off);
+
+			src = flush ? buf : ptr_buf + copy_off;
+			dst = flush ? ptr_buf + copy_off : buf;
+			memcpy(dst, src, copy_len);
+
+			off += copy_len;
+			len -= copy_len;
+			buf += copy_len;
+		}
+
+		if (!len || next_frag == end_frag)
+			break;
+
+		ptr_off += ptr_len;
+		ptr_buf = skb_frag_address(next_frag);
+		ptr_len = skb_frag_size(next_frag);
+		next_frag++;
+	}
+}
+
+static void *bpf_xdp_pointer(struct xdp_buff *xdp, u32 offset, u32 len)
+{
+	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
+	u32 size = xdp->data_end - xdp->data;
+	void *addr = xdp->data;
+	int i;
+
+	if (unlikely(offset > 0xffff || len > 0xffff))
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
+out:
+	return offset + len < size ? addr + offset : NULL;
+}
+
+BPF_CALL_4(bpf_xdp_load_bytes, struct xdp_buff *, xdp, u32, offset,
+	   void *, buf, u32, len)
+{
+	void *ptr;
+
+	ptr = bpf_xdp_pointer(xdp, offset, len);
+	if (IS_ERR(ptr))
+		return PTR_ERR(ptr);
+
+	if (!ptr)
+		bpf_xdp_copy_buf(xdp, offset, buf, len, false);
+	else
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
+	ptr = bpf_xdp_pointer(xdp, offset, len);
+	if (IS_ERR(ptr))
+		return PTR_ERR(ptr);
+
+	if (!ptr)
+		bpf_xdp_copy_buf(xdp, offset, buf, len, true);
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
@@ -4624,48 +4756,12 @@ static const struct bpf_func_proto bpf_sk_ancestor_cgroup_id_proto = {
 };
 #endif
 
-static unsigned long bpf_xdp_copy(void *dst_buff, const void *ctx,
+static unsigned long bpf_xdp_copy(void *dst, const void *ctx,
 				  unsigned long off, unsigned long len)
 {
 	struct xdp_buff *xdp = (struct xdp_buff *)ctx;
-	unsigned long ptr_len, ptr_off = 0;
-	skb_frag_t *next_frag, *end_frag;
-	struct skb_shared_info *sinfo;
-	u8 *ptr_buf;
-
-	if (likely(xdp->data_end - xdp->data >= off + len)) {
-		memcpy(dst_buff, xdp->data + off, len);
-		return 0;
-	}
-
-	sinfo = xdp_get_shared_info_from_buff(xdp);
-	end_frag = &sinfo->frags[sinfo->nr_frags];
-	next_frag = &sinfo->frags[0];
-
-	ptr_len = xdp->data_end - xdp->data;
-	ptr_buf = xdp->data;
-
-	while (true) {
-		if (off < ptr_off + ptr_len) {
-			unsigned long copy_off = off - ptr_off;
-			unsigned long copy_len = min(len, ptr_len - copy_off);
-
-			memcpy(dst_buff, ptr_buf + copy_off, copy_len);
-
-			off += copy_len;
-			len -= copy_len;
-			dst_buff += copy_len;
-		}
-
-		if (!len || next_frag == end_frag)
-			break;
-
-		ptr_off += ptr_len;
-		ptr_buf = skb_frag_address(next_frag);
-		ptr_len = skb_frag_size(next_frag);
-		next_frag++;
-	}
 
+	bpf_xdp_copy_buf(xdp, off, dst, len, false);
 	return 0;
 }
 
@@ -7597,6 +7693,10 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
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
index d5921a0202f4..94e43088971d 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4994,6 +4994,22 @@ union bpf_attr {
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
@@ -5179,6 +5195,8 @@ union bpf_attr {
 	FN(find_vma),			\
 	FN(loop),			\
 	FN(xdp_get_buff_len),		\
+	FN(xdp_load_bytes),		\
+	FN(xdp_store_bytes),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.33.1

