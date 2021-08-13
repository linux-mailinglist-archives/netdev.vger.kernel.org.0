Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD6993EB4C9
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 13:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240422AbhHMLu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 07:50:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:45054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240391AbhHMLu0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 07:50:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4C8D6109E;
        Fri, 13 Aug 2021 11:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628855399;
        bh=h6FJuMKAmkl5hI5XDJ6c0X4sxzC1THVZ8+wuScewwwU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sDTOFeDDrDufdkTQw/zhgo9n3lejL0rX1GASP9884Lk/uy4tYPOk2PGtPbJaNy87N
         oaVyF9PJF4Eo0LE3iQ7CRkk2f+Fb2tqQ0TtndPGNpu78d8Rq8ryWJTHNOboOnrHzFK
         tHdS4fR2dYdMj0i6NeQbBWAO/lE7Ei4LWRu20h/R+ixLtpi7xuYOA7vb1wrkcOxhwZ
         pWrhp1J0NWkaEQVMsIBfDNeHISjBx8It8HZvCdCFFSiJ5jgRnj9UypTziWRK2tk4tO
         Fs0CjlS8gk6JpeV1345t0y6v4CgC6057RBlbqxV7KNBgjLFuBC2WMrhrDfsu7134iG
         /+mnsXQmqtDOQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v11 bpf-next 11/18] bpf: introduce bpf_xdp_get_buff_len helper
Date:   Fri, 13 Aug 2021 13:47:52 +0200
Message-Id: <a742a962e3843b1ee85ed56ca934f15f61366a71.1628854454.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1628854454.git.lorenzo@kernel.org>
References: <cover.1628854454.git.lorenzo@kernel.org>
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
index 1b931824161c..93ce775eaadf 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3784,6 +3784,27 @@ static const struct bpf_func_proto sk_skb_change_head_proto = {
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
@@ -7501,6 +7522,8 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
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

