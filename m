Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3330B3D8ADE
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 11:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235421AbhG1Jjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 05:39:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:51910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235623AbhG1Jjs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 05:39:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A264560F9E;
        Wed, 28 Jul 2021 09:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627465186;
        bh=DhvoQqjSRtxY44nyEAALguzb/zsS+CEFu4K/lTc/jOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CQELd9AVTsOFAESvtVpEVslxb0sPxrp/GmpCE5a2cLfeKIGnb4KMXFWKqZYWj05FK
         eti0oKddX3V4vOF0bnGDofJwvmv6JeB0Nks5D1JHmyAsKuGqHkgtGcgVdOtkVktwZI
         2DdlCvq5NecNxZrjpnXnh1a42WMQfA1SBl+oYW3aHTFwv5P2X+gJLCR9lqAvdzLLEV
         ZKdHBxO0EKWevs/7f6d+rSO0cM8puOwMmdREnE07/2BQHwF7l4ZoFMVSx6dHZ0MH+W
         zY0csafGUZaokd61K88l3GHKl2BieOP/CKj8q5JPPC3og/hlqGMyestitS0g2WKEpa
         Yf+c7PuRRklWg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v10 bpf-next 11/18] bpf: introduce bpf_xdp_get_buff_len helper
Date:   Wed, 28 Jul 2021 11:38:16 +0200
Message-Id: <24653990e17e80c430632526d53916a23d92085c.1627463617.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1627463617.git.lorenzo@kernel.org>
References: <cover.1627463617.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce bpf_xdp_get_buff_len helper in order to return the xdp buffer
total size (linear and paged area)

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/uapi/linux/bpf.h       |  7 +++++++
 net/core/filter.c              | 23 +++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h |  7 +++++++
 3 files changed, 37 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 2db6925e04f4..ddbf9ccc2f74 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4847,6 +4847,12 @@ union bpf_attr {
  * 		Get address of the traced function (for tracing and kprobe programs).
  * 	Return
  * 		Address of the traced function.
+ *
+ * u64 bpf_xdp_get_buff_len(struct xdp_buff *xdp_md)
+ *	Description
+ *		Get the total size of a given xdp buff (linear and paged area)
+ *	Return
+ *		The total size of a given xdp buffer.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5023,6 +5029,7 @@ union bpf_attr {
 	FN(timer_start),		\
 	FN(timer_cancel),		\
 	FN(get_func_ip),		\
+	FN(xdp_get_buff_len),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/net/core/filter.c b/net/core/filter.c
index e60e300b10cd..e3d34da19ef2 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3801,6 +3801,27 @@ static const struct bpf_func_proto sk_skb_change_head_proto = {
 	.arg2_type	= ARG_ANYTHING,
 	.arg3_type	= ARG_ANYTHING,
 };
+
+BPF_CALL_1(bpf_xdp_get_buff_len, struct  xdp_buff*, xdp)
+{
+	u64 len = xdp->data_end - xdp->data;
+
+	if (unlikely(xdp_buff_is_mb(xdp))) {
+		struct skb_shared_info *sinfo;
+
+		sinfo = xdp_get_shared_info_from_buff(xdp);
+		len += sinfo->xdp_frags_size;
+	}
+	return len;
+}
+
+const struct bpf_func_proto bpf_xdp_get_buff_len_proto = {
+	.func		= bpf_xdp_get_buff_len,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX,
+};
+
 static unsigned long xdp_get_metalen(const struct xdp_buff *xdp)
 {
 	return xdp_data_meta_unsupported(xdp) ? 0 :
@@ -7493,6 +7514,8 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_xdp_redirect_map_proto;
 	case BPF_FUNC_xdp_adjust_tail:
 		return &bpf_xdp_adjust_tail_proto;
+	case BPF_FUNC_xdp_get_buff_len:
+		return &bpf_xdp_get_buff_len_proto;
 	case BPF_FUNC_fib_lookup:
 		return &bpf_xdp_fib_lookup_proto;
 	case BPF_FUNC_check_mtu:
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 2db6925e04f4..ddbf9ccc2f74 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4847,6 +4847,12 @@ union bpf_attr {
  * 		Get address of the traced function (for tracing and kprobe programs).
  * 	Return
  * 		Address of the traced function.
+ *
+ * u64 bpf_xdp_get_buff_len(struct xdp_buff *xdp_md)
+ *	Description
+ *		Get the total size of a given xdp buff (linear and paged area)
+ *	Return
+ *		The total size of a given xdp buffer.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5023,6 +5029,7 @@ union bpf_attr {
 	FN(timer_start),		\
 	FN(timer_cancel),		\
 	FN(get_func_ip),		\
+	FN(xdp_get_buff_len),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.31.1

