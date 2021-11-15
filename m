Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41EFA4517E1
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 23:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348792AbhKOWtF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 17:49:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:46932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353534AbhKOWjQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 17:39:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E19A63248;
        Mon, 15 Nov 2021 22:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637015673;
        bh=qM/W89BG+VlSYhVtnLQ3ihSIEFga4cV/skrgkwcP4Ak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ezrBkk765VVE7Wv7K2UNffqnhmFQLd926VuMNKGqYndwlwNyqdBVX42tL929Z5eXL
         K1Cd2Pd2nhy5ZEeQC1o55K2+do/FcEGsCJZaQ4POXAXwMGCl2Bjjt1WoYoPD+F/rxL
         EHHV/ajPATYxPqkvxL3XAsN+9LKWNdoWWeuP5lxiKVaIfenX90chNKrHbilDYVnXfl
         3nTiSMzindEtVpO/13sTmvY1zqssehEjozactvgpcq3OpMylbRsrAz5X1FMsIKY8PJ
         lyXUUxzGR1cYBJJVGkRzsY6wpN1wwQSa+yGZQjvvSuNi2EymKLXqMAWRd/VwQkEzdA
         BE1uMNJcBqPHg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v18 bpf-next 11/23] bpf: introduce bpf_xdp_get_buff_len helper
Date:   Mon, 15 Nov 2021 23:33:05 +0100
Message-Id: <2ecd2d1abf41a14fbb7c9b7994feaa652caa2f1f.1637013639.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1637013639.git.lorenzo@kernel.org>
References: <cover.1637013639.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce bpf_xdp_get_buff_len helper in order to return the xdp buffer
total size (linear and paged area)

Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/net/xdp.h              | 14 ++++++++++++++
 include/uapi/linux/bpf.h       |  7 +++++++
 net/core/filter.c              | 15 +++++++++++++++
 tools/include/uapi/linux/bpf.h |  7 +++++++
 4 files changed, 43 insertions(+)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index 798b84d86d97..067716d38ebc 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -145,6 +145,20 @@ xdp_get_shared_info_from_buff(struct xdp_buff *xdp)
 	return (struct skb_shared_info *)xdp_data_hard_end(xdp);
 }
 
+static __always_inline unsigned int xdp_get_buff_len(struct xdp_buff *xdp)
+{
+	unsigned int len = xdp->data_end - xdp->data;
+	struct skb_shared_info *sinfo;
+
+	if (likely(!xdp_buff_is_mb(xdp)))
+		goto out;
+
+	sinfo = xdp_get_shared_info_from_buff(xdp);
+	len += sinfo->xdp_frags_size;
+out:
+	return len;
+}
+
 struct xdp_frame {
 	void *data;
 	u16 len;
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 875ae723eb6b..556621a3f7b4 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4962,6 +4962,12 @@ union bpf_attr {
  *		**-ENOENT** if *task->mm* is NULL, or no vma contains *addr*.
  *		**-EBUSY** if failed to try lock mmap_lock.
  *		**-EINVAL** for invalid **flags**.
+ *
+ * u64 bpf_xdp_get_buff_len(struct xdp_buff *xdp_md)
+ *	Description
+ *		Get the total size of a given xdp buff (linear and paged area)
+ *	Return
+ *		The total size of a given xdp buffer.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5145,6 +5151,7 @@ union bpf_attr {
 	FN(skc_to_unix_sock),		\
 	FN(kallsyms_lookup_name),	\
 	FN(find_vma),			\
+	FN(xdp_get_buff_len),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/net/core/filter.c b/net/core/filter.c
index 46f09a8fba20..06364d652bad 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3784,6 +3784,19 @@ static const struct bpf_func_proto sk_skb_change_head_proto = {
 	.arg2_type	= ARG_ANYTHING,
 	.arg3_type	= ARG_ANYTHING,
 };
+
+BPF_CALL_1(bpf_xdp_get_buff_len, struct  xdp_buff*, xdp)
+{
+	return xdp_get_buff_len(xdp);
+}
+
+static const struct bpf_func_proto bpf_xdp_get_buff_len_proto = {
+	.func		= bpf_xdp_get_buff_len,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX,
+};
+
 static unsigned long xdp_get_metalen(const struct xdp_buff *xdp)
 {
 	return xdp_data_meta_unsupported(xdp) ? 0 :
@@ -7471,6 +7484,8 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_xdp_redirect_map_proto;
 	case BPF_FUNC_xdp_adjust_tail:
 		return &bpf_xdp_adjust_tail_proto;
+	case BPF_FUNC_xdp_get_buff_len:
+		return &bpf_xdp_get_buff_len_proto;
 	case BPF_FUNC_fib_lookup:
 		return &bpf_xdp_fib_lookup_proto;
 	case BPF_FUNC_check_mtu:
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 875ae723eb6b..556621a3f7b4 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4962,6 +4962,12 @@ union bpf_attr {
  *		**-ENOENT** if *task->mm* is NULL, or no vma contains *addr*.
  *		**-EBUSY** if failed to try lock mmap_lock.
  *		**-EINVAL** for invalid **flags**.
+ *
+ * u64 bpf_xdp_get_buff_len(struct xdp_buff *xdp_md)
+ *	Description
+ *		Get the total size of a given xdp buff (linear and paged area)
+ *	Return
+ *		The total size of a given xdp buffer.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5145,6 +5151,7 @@ union bpf_attr {
 	FN(skc_to_unix_sock),		\
 	FN(kallsyms_lookup_name),	\
 	FN(find_vma),			\
+	FN(xdp_get_buff_len),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.31.1

