Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56B8027ED9C
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 17:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728724AbgI3Pms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 11:42:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:53174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728006AbgI3Pms (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 11:42:48 -0400
Received: from lore-desk.redhat.com (unknown [176.207.245.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0E1820789;
        Wed, 30 Sep 2020 15:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601480567;
        bh=XBrbju6dXd0874L2ovtgvBsMIReLnuBKM3bucBGyPs8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=inOaVfTQjodlY5xn5CjkU2hFgUOnZSV3UATaFAlnogaTFN08f+aSUVTXQOzXTnYrJ
         E8VYAarRPgHUaoni4ODch/pgJ/NUmB4tk3R580COWHh1juErJKYkf4ftppdy6Q8BIJ
         axy6XWPZbIEw7NFAVJAV6XICO8JO6pty153hhOmg=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, sameehj@amazon.com,
        kuba@kernel.org, john.fastabend@gmail.com, daniel@iogearbox.net,
        ast@kernel.org, shayagr@amazon.com, brouer@redhat.com,
        echaudro@redhat.com, lorenzo.bianconi@redhat.com,
        dsahern@kernel.org
Subject: [PATCH v3 net-next 06/12] bpf: helpers: add multibuffer support
Date:   Wed, 30 Sep 2020 17:41:57 +0200
Message-Id: <5e248485713d2470d97f36ad67c9b3ceedfc2b3f.1601478613.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1601478613.git.lorenzo@kernel.org>
References: <cover.1601478613.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/uapi/linux/bpf.h       | 14 ++++++++++++
 net/core/filter.c              | 42 ++++++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h | 14 ++++++++++++
 3 files changed, 70 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index a22812561064..6f97dce8cccf 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3586,6 +3586,18 @@ union bpf_attr {
  * 		the data in *dst*. This is a wrapper of **copy_from_user**\ ().
  * 	Return
  * 		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_xdp_get_frag_count(struct xdp_buff *xdp_md)
+ *	Description
+ *		Get the number of fragments for a given xdp multi-buffer.
+ *	Return
+ *		The number of fragments
+ *
+ * int bpf_xdp_get_frags_total_size(struct xdp_buff *xdp_md)
+ *	Description
+ *		Get the total size of fragments for a given xdp multi-buffer.
+ *	Return
+ *		The total size of fragments for a given xdp multi-buffer.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3737,6 +3749,8 @@ union bpf_attr {
 	FN(inode_storage_delete),	\
 	FN(d_path),			\
 	FN(copy_from_user),		\
+	FN(xdp_get_frag_count),		\
+	FN(xdp_get_frags_total_size),	\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/net/core/filter.c b/net/core/filter.c
index 706f8db0ccf8..7f33cfae219c 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3475,6 +3475,44 @@ static const struct bpf_func_proto bpf_xdp_adjust_head_proto = {
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
+	struct skb_shared_info *sinfo;
+	int nfrags, i, size = 0;
+
+	if (likely(!xdp->mb))
+		return 0;
+
+	sinfo = xdp_get_shared_info_from_buff(xdp);
+	nfrags = min_t(u8, sinfo->nr_frags, MAX_SKB_FRAGS);
+
+	for (i = 0; i < nfrags; i++)
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
@@ -6824,6 +6862,10 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_xdp_redirect_map_proto;
 	case BPF_FUNC_xdp_adjust_tail:
 		return &bpf_xdp_adjust_tail_proto;
+	case BPF_FUNC_xdp_get_frag_count:
+		return &bpf_xdp_get_frag_count_proto;
+	case BPF_FUNC_xdp_get_frags_total_size:
+		return &bpf_xdp_get_frags_total_size_proto;
 	case BPF_FUNC_fib_lookup:
 		return &bpf_xdp_fib_lookup_proto;
 #ifdef CONFIG_INET
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index a22812561064..6f97dce8cccf 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3586,6 +3586,18 @@ union bpf_attr {
  * 		the data in *dst*. This is a wrapper of **copy_from_user**\ ().
  * 	Return
  * 		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_xdp_get_frag_count(struct xdp_buff *xdp_md)
+ *	Description
+ *		Get the number of fragments for a given xdp multi-buffer.
+ *	Return
+ *		The number of fragments
+ *
+ * int bpf_xdp_get_frags_total_size(struct xdp_buff *xdp_md)
+ *	Description
+ *		Get the total size of fragments for a given xdp multi-buffer.
+ *	Return
+ *		The total size of fragments for a given xdp multi-buffer.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3737,6 +3749,8 @@ union bpf_attr {
 	FN(inode_storage_delete),	\
 	FN(d_path),			\
 	FN(copy_from_user),		\
+	FN(xdp_get_frag_count),		\
+	FN(xdp_get_frags_total_size),	\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.26.2

