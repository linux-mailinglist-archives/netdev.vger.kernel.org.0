Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A71A25CBAE
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 22:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729366AbgICU7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 16:59:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:56306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729311AbgICU7i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Sep 2020 16:59:38 -0400
Received: from lore-desk.redhat.com (unknown [151.66.86.87])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94583206CA;
        Thu,  3 Sep 2020 20:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599166777;
        bh=WjAJcozqYUApukYBbu27u+BBeSfDcbmdQWNonq247W8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c3nAjvG10T6GSK34bZ18wVNmZGoCwFZ56ueaXnam5HajhW65foHRwOFRKFsfPBi4t
         GpDp+gTBjWCHVBnvQagHCiikFiytqOqP8Rt1osBQIFePvrkEqtgPG0o6g2HRXlTUz5
         EubrieyQBgt1zvPJy1RNSIn4fBY2p9sM4fC4XmqM=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, brouer@redhat.com,
        echaudro@redhat.com, sameehj@amazon.com, kuba@kernel.org,
        john.fastabend@gmail.com, daniel@iogearbox.net, ast@kernel.org,
        shayagr@amazon.com
Subject: [PATCH v2 net-next 7/9] bpf: helpers: add multibuffer support
Date:   Thu,  3 Sep 2020 22:58:51 +0200
Message-Id: <e7da15edf4c152e1803b76638373527c292ee04b.1599165031.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1599165031.git.lorenzo@kernel.org>
References: <cover.1599165031.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

The implementation is based on this [0] draft by Jesper D. Brouer.

Provided two new helpers:

* bpf_xdp_get_frag_count()
* bpf_xdp_get_frags_total_size()

[0] xdp mb design - https://github.com/xdp-project/xdp-project/blob/master/areas/core/xdp-multi-buffer01-design.org
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/uapi/linux/bpf.h       | 14 ++++++++++++
 net/core/filter.c              | 39 ++++++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h | 14 ++++++++++++
 3 files changed, 67 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index c4a6d245619c..53db75095306 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3590,6 +3590,18 @@ union bpf_attr {
  *
  *	Return
  *		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_xdp_get_frag_count(struct xdp_buff *xdp_md)
+ *	Description
+ *		Get the total number of frags for a given packet.
+ *	Return
+ *		The number of frags
+ *
+ * int bpf_xdp_get_frags_total_size(struct xdp_buff *xdp_md)
+ *	Description
+ *		Get the total size of frags for a given packet.
+ *	Return
+ *		The total size of frags for a given packet.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3742,6 +3754,8 @@ union bpf_attr {
 	FN(d_path),			\
 	FN(copy_from_user),		\
 	FN(xdp_adjust_mb_header),	\
+	FN(xdp_get_frag_count),		\
+	FN(xdp_get_frags_total_size),	\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/net/core/filter.c b/net/core/filter.c
index ae6b10cf062d..ba058fc16440 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3526,6 +3526,41 @@ static const struct bpf_func_proto bpf_xdp_adjust_mb_header_proto = {
 	.arg2_type	= ARG_ANYTHING,
 };
 
+BPF_CALL_1(bpf_xdp_get_frag_count, struct  xdp_buff*, xdp)
+{
+	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
+
+	return xdp->mb ? sinfo->nr_frags : 0;
+}
+
+const struct bpf_func_proto bpf_xdp_get_frag_count_proto = {
+	.func		= bpf_xdp_get_frag_count,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX,
+};
+
+BPF_CALL_1(bpf_xdp_get_frags_total_size, struct  xdp_buff*, xdp)
+{
+	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
+	int nfrags, i;
+	int size = 0;
+
+	nfrags = xdp->mb ? sinfo->nr_frags : 0;
+
+	for (i = 0; i < nfrags && i < MAX_SKB_FRAGS; i++)
+		size += skb_frag_size(&sinfo->frags[i]);
+
+	return size;
+}
+
+const struct bpf_func_proto bpf_xdp_get_frags_total_size_proto = {
+	.func		= bpf_xdp_get_frags_total_size,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX,
+};
+
 BPF_CALL_2(bpf_xdp_adjust_tail, struct xdp_buff *, xdp, int, offset)
 {
 	void *data_hard_end = xdp_data_hard_end(xdp); /* use xdp->frame_sz */
@@ -6889,6 +6924,10 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_xdp_adjust_tail_proto;
 	case BPF_FUNC_xdp_adjust_mb_header:
 		return &bpf_xdp_adjust_mb_header_proto;
+	case BPF_FUNC_xdp_get_frag_count:
+		return &bpf_xdp_get_frag_count_proto;
+	case BPF_FUNC_xdp_get_frags_total_size:
+		return &bpf_xdp_get_frags_total_size_proto;
 	case BPF_FUNC_fib_lookup:
 		return &bpf_xdp_fib_lookup_proto;
 #ifdef CONFIG_INET
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 392d52a2ecef..dd4669096cbb 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3591,6 +3591,18 @@ union bpf_attr {
  *
  *	Return
  *		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_xdp_get_frag_count(struct xdp_buff *xdp_md)
+ *	Description
+ *		Get the total number of frags for a given packet.
+ *	Return
+ *		The number of frags
+ *
+ * int bpf_xdp_get_frags_total_size(struct xdp_buff *xdp_md)
+ *	Description
+ *		Get the total size of frags for a given packet.
+ *	Return
+ *		The total size of frags for a given packet.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3743,6 +3755,8 @@ union bpf_attr {
 	FN(d_path),			\
 	FN(copy_from_user),		\
 	FN(xdp_adjust_mb_header),	\
+	FN(xdp_get_frag_count),		\
+	FN(xdp_get_frags_total_size),	\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.26.2

