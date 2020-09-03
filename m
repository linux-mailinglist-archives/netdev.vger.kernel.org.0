Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BBB825CBAC
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 22:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729315AbgICU7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 16:59:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:56266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729189AbgICU7f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Sep 2020 16:59:35 -0400
Received: from lore-desk.redhat.com (unknown [151.66.86.87])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05E49208C7;
        Thu,  3 Sep 2020 20:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599166775;
        bh=RyTHppDVc1/MbiUCKxS7Z7Ipe9/MsvZz3zz6+YsRmLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0fkmXdQJ48VEscfqmLUaBly6Wpb3bhVBgnxQn43WBCAM8XC6pbk9CnwFq8EzoQwPj
         RmPoRb2x6yA14IHeYAMIz4xop11uSnYKetHAQ8UkFhq8dTE8v2BZbhFrBfHI1M/6W5
         D/3JXhT3g2qa9mZQG490D/dYhH8NoXBVdknPBzuM=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, brouer@redhat.com,
        echaudro@redhat.com, sameehj@amazon.com, kuba@kernel.org,
        john.fastabend@gmail.com, daniel@iogearbox.net, ast@kernel.org,
        shayagr@amazon.com
Subject: [PATCH v2 net-next 6/9] bpf: helpers: add bpf_xdp_adjust_mb_header helper
Date:   Thu,  3 Sep 2020 22:58:50 +0200
Message-Id: <b7475687bb09aac6ec051596a8ccbb311a54cb8a.1599165031.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1599165031.git.lorenzo@kernel.org>
References: <cover.1599165031.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce bpf_xdp_adjust_mb_header helper in order to adjust frame
headers moving *offset* bytes from/to the second buffer to/from the
first one.
This helper can be used to move headers when the hw DMA SG is not able
to copy all the headers in the first fragment and split header and data
pages.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/uapi/linux/bpf.h       | 25 ++++++++++++----
 net/core/filter.c              | 54 ++++++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h | 26 ++++++++++++----
 3 files changed, 95 insertions(+), 10 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 8dda13880957..c4a6d245619c 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3571,11 +3571,25 @@ union bpf_attr {
  *		value.
  *
  * long bpf_copy_from_user(void *dst, u32 size, const void *user_ptr)
- * 	Description
- * 		Read *size* bytes from user space address *user_ptr* and store
- * 		the data in *dst*. This is a wrapper of copy_from_user().
- * 	Return
- * 		0 on success, or a negative error in case of failure.
+ *	Description
+ *		Read *size* bytes from user space address *user_ptr* and store
+ *		the data in *dst*. This is a wrapper of copy_from_user().
+ *
+ * long bpf_xdp_adjust_mb_header(struct xdp_buff *xdp_md, int offset)
+ *	Description
+ *		Adjust frame headers moving *offset* bytes from/to the second
+ *		buffer to/from the first one. This helper can be used to move
+ *		headers when the hw DMA SG does not copy all the headers in
+ *		the first fragment.
+ *
+ *		A call to this helper is susceptible to change the underlying
+ *		packet buffer. Therefore, at load time, all checks on pointers
+ *		previously done by the verifier are invalidated and must be
+ *		performed again, if the helper is used in combination with
+ *		direct packet access.
+ *
+ *	Return
+ *		0 on success, or a negative error in case of failure.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3727,6 +3741,7 @@ union bpf_attr {
 	FN(inode_storage_delete),	\
 	FN(d_path),			\
 	FN(copy_from_user),		\
+	FN(xdp_adjust_mb_header),	\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/net/core/filter.c b/net/core/filter.c
index 47eef9a0be6a..ae6b10cf062d 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3475,6 +3475,57 @@ static const struct bpf_func_proto bpf_xdp_adjust_head_proto = {
 	.arg2_type	= ARG_ANYTHING,
 };
 
+BPF_CALL_2(bpf_xdp_adjust_mb_header, struct  xdp_buff *, xdp,
+	   int, offset)
+{
+	void *data_hard_end, *data_end;
+	struct skb_shared_info *sinfo;
+	int frag_offset, frag_len;
+	u8 *addr;
+
+	if (!xdp->mb)
+		return -EOPNOTSUPP;
+
+	sinfo = xdp_get_shared_info_from_buff(xdp);
+
+	frag_len = skb_frag_size(&sinfo->frags[0]);
+	if (offset > frag_len)
+		return -EINVAL;
+
+	frag_offset = skb_frag_off(&sinfo->frags[0]);
+	data_end = xdp->data_end + offset;
+
+	if (offset < 0 && (-offset > frag_offset ||
+			   data_end < xdp->data + ETH_HLEN))
+		return -EINVAL;
+
+	data_hard_end = xdp_data_hard_end(xdp); /* use xdp->frame_sz */
+	if (data_end > data_hard_end)
+		return -EINVAL;
+
+	addr = page_address(skb_frag_page(&sinfo->frags[0])) + frag_offset;
+	if (offset > 0) {
+		memcpy(xdp->data_end, addr, offset);
+	} else {
+		memcpy(addr + offset, xdp->data_end + offset, -offset);
+		memset(xdp->data_end + offset, 0, -offset);
+	}
+
+	skb_frag_size_sub(&sinfo->frags[0], offset);
+	skb_frag_off_add(&sinfo->frags[0], offset);
+	xdp->data_end = data_end;
+
+	return 0;
+}
+
+static const struct bpf_func_proto bpf_xdp_adjust_mb_header_proto = {
+	.func		= bpf_xdp_adjust_mb_header,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX,
+	.arg2_type	= ARG_ANYTHING,
+};
+
 BPF_CALL_2(bpf_xdp_adjust_tail, struct xdp_buff *, xdp, int, offset)
 {
 	void *data_hard_end = xdp_data_hard_end(xdp); /* use xdp->frame_sz */
@@ -6505,6 +6556,7 @@ bool bpf_helper_changes_pkt_data(void *func)
 	    func == bpf_msg_push_data ||
 	    func == bpf_msg_pop_data ||
 	    func == bpf_xdp_adjust_tail ||
+	    func == bpf_xdp_adjust_mb_header ||
 #if IS_ENABLED(CONFIG_IPV6_SEG6_BPF)
 	    func == bpf_lwt_seg6_store_bytes ||
 	    func == bpf_lwt_seg6_adjust_srh ||
@@ -6835,6 +6887,8 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_xdp_redirect_map_proto;
 	case BPF_FUNC_xdp_adjust_tail:
 		return &bpf_xdp_adjust_tail_proto;
+	case BPF_FUNC_xdp_adjust_mb_header:
+		return &bpf_xdp_adjust_mb_header_proto;
 	case BPF_FUNC_fib_lookup:
 		return &bpf_xdp_fib_lookup_proto;
 #ifdef CONFIG_INET
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 8dda13880957..392d52a2ecef 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3407,6 +3407,7 @@ union bpf_attr {
  *		A non-negative value equal to or less than *size* on success,
  *		or a negative error in case of failure.
  *
+ *
  * long bpf_load_hdr_opt(struct bpf_sock_ops *skops, void *searchby_res, u32 len, u64 flags)
  *	Description
  *		Load header option.  Support reading a particular TCP header
@@ -3571,11 +3572,25 @@ union bpf_attr {
  *		value.
  *
  * long bpf_copy_from_user(void *dst, u32 size, const void *user_ptr)
- * 	Description
- * 		Read *size* bytes from user space address *user_ptr* and store
- * 		the data in *dst*. This is a wrapper of copy_from_user().
- * 	Return
- * 		0 on success, or a negative error in case of failure.
+ *	Description
+ *		Read *size* bytes from user space address *user_ptr* and store
+ *		the data in *dst*. This is a wrapper of copy_from_user().
+ *
+ * long bpf_xdp_adjust_mb_header(struct xdp_buff *xdp_md, int offset)
+ *	Description
+ *		Adjust frame headers moving *offset* bytes from/to the second
+ *		buffer to/from the first one. This helper can be used to move
+ *		headers when the hw DMA SG does not copy all the headers in
+ *		the first fragment.
+ *
+ *		A call to this helper is susceptible to change the underlying
+ *		packet buffer. Therefore, at load time, all checks on pointers
+ *		previously done by the verifier are invalidated and must be
+ *		performed again, if the helper is used in combination with
+ *		direct packet access.
+ *
+ *	Return
+ *		0 on success, or a negative error in case of failure.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3727,6 +3742,7 @@ union bpf_attr {
 	FN(inode_storage_delete),	\
 	FN(d_path),			\
 	FN(copy_from_user),		\
+	FN(xdp_adjust_mb_header),	\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.26.2

