Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA2228157E
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 16:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388207AbgJBOmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 10:42:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:60902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbgJBOmv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 10:42:51 -0400
Received: from lore-desk.redhat.com (unknown [176.207.245.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CCE6206FA;
        Fri,  2 Oct 2020 14:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601649770;
        bh=MeoOo4bg3O/0X0i354wiVWGpLoopVwV3Irb8n4wowas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ObQmjaDmcbhtZX+9SYFt1aWtGUSr5nUostE1DcAL0hD4TkguOd31v4pKQAfw1vRBw
         Sq+9fZtxdWFFHhV5TFEHEU5qES+RsAgiFrHk1ORA8xFPTPoseiOeKlI2EHNoRql207
         85JGkzBi1esE6qR1aTit5WMw7KxEFaLX8UJMgYfI=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, sameehj@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        lorenzo.bianconi@redhat.com, echaudro@redhat.com
Subject: [PATCH v4 bpf-next 06/13] bpf: introduce bpf_xdp_get_frags_{count, total_size} helpers
Date:   Fri,  2 Oct 2020 16:42:04 +0200
Message-Id: <deb81e4cf02db9a1da2b4088a49afd7acf8b82b6.1601648734.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1601648734.git.lorenzo@kernel.org>
References: <cover.1601648734.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

Introduce the two following bpf helpers in order to provide some
metadata about a xdp multi-buff fame to bpf layer:

- bpf_xdp_get_frags_count()
  get the number of fragments for a given xdp multi-buffer.

* bpf_xdp_get_frags_total_size()
  get the total size of fragments for a given xdp multi-buffer.

Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/uapi/linux/bpf.h       | 14 ++++++++++++
 net/core/filter.c              | 42 ++++++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h | 14 ++++++++++++
 3 files changed, 70 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 4f556cfcbfbe..0715995eb18c 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3668,6 +3668,18 @@ union bpf_attr {
  * 	Return
  * 		The helper returns **TC_ACT_REDIRECT** on success or
  * 		**TC_ACT_SHOT** on error.
+ *
+ * int bpf_xdp_get_frags_count(struct xdp_buff *xdp_md)
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
@@ -3823,6 +3835,8 @@ union bpf_attr {
 	FN(seq_printf_btf),		\
 	FN(skb_cgroup_classid),		\
 	FN(redirect_neigh),		\
+	FN(xdp_get_frags_count),	\
+	FN(xdp_get_frags_total_size),	\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/net/core/filter.c b/net/core/filter.c
index 3fb6adad1957..4c55b788c4c5 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3739,6 +3739,44 @@ static const struct bpf_func_proto bpf_xdp_adjust_head_proto = {
 	.arg2_type	= ARG_ANYTHING,
 };
 
+BPF_CALL_1(bpf_xdp_get_frags_count, struct  xdp_buff*, xdp)
+{
+	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
+
+	return xdp->mb ? sinfo->nr_frags : 0;
+}
+
+const struct bpf_func_proto bpf_xdp_get_frags_count_proto = {
+	.func		= bpf_xdp_get_frags_count,
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
@@ -7092,6 +7130,10 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_xdp_redirect_map_proto;
 	case BPF_FUNC_xdp_adjust_tail:
 		return &bpf_xdp_adjust_tail_proto;
+	case BPF_FUNC_xdp_get_frags_count:
+		return &bpf_xdp_get_frags_count_proto;
+	case BPF_FUNC_xdp_get_frags_total_size:
+		return &bpf_xdp_get_frags_total_size_proto;
 	case BPF_FUNC_fib_lookup:
 		return &bpf_xdp_fib_lookup_proto;
 #ifdef CONFIG_INET
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 4f556cfcbfbe..0715995eb18c 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3668,6 +3668,18 @@ union bpf_attr {
  * 	Return
  * 		The helper returns **TC_ACT_REDIRECT** on success or
  * 		**TC_ACT_SHOT** on error.
+ *
+ * int bpf_xdp_get_frags_count(struct xdp_buff *xdp_md)
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
@@ -3823,6 +3835,8 @@ union bpf_attr {
 	FN(seq_printf_btf),		\
 	FN(skb_cgroup_classid),		\
 	FN(redirect_neigh),		\
+	FN(xdp_get_frags_count),	\
+	FN(xdp_get_frags_total_size),	\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.26.2

