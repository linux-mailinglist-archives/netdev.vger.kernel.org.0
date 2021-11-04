Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 718354458A6
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 18:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233943AbhKDRjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 13:39:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:48642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233940AbhKDRjV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Nov 2021 13:39:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67F2E61186;
        Thu,  4 Nov 2021 17:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636047403;
        bh=ekAKuoV1T3VTORC15bLjMXak7dASGPtoeB4CW2ZRYb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lL0nTOL6ABpSvFnlbVk+o2AiQaEfubvBKZiFI48an5f3MdephAoPgFvf0MadtBLi7
         o2uUdpPHQjpkuo2SnuWk7+Gwl9dHAbShXcSYPINIEfsJ7lWViRfCltb4LCcxqZmuCX
         tR5vnmXoWz/d2BjPT28c9VxpClv1GbcGnQK0HX8dXDZYOpRPdPW0aKbSJizlhPo8IW
         PHhs9BDEwDGSEsP4/ZOPkTLtw46CsGfi8XRhWEV3OGTN9F4MMQkMJ/QNZu4ke78W0E
         3z5XEc5q9H/WbaQKU51L7ZJ9uRx74/WUS2VGqCG3shI4k7aWuNxHchCr9RPOvpDHcP
         9yne0PPCnicJw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v17 bpf-next 11/23] bpf: introduce bpf_xdp_get_buff_len helper
Date:   Thu,  4 Nov 2021 18:35:31 +0100
Message-Id: <fb1e355c0bdebb3320971ca2b178b98ec37cee36.1636044387.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1636044387.git.lorenzo@kernel.org>
References: <cover.1636044387.git.lorenzo@kernel.org>
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
index d2abb7cff9b5..c643be066700 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4943,6 +4943,12 @@ union bpf_attr {
  *		**-ENOENT** if symbol is not found.
  *
  *		**-EPERM** if caller does not have permission to obtain kernel address.
+ *
+ * u64 bpf_xdp_get_buff_len(struct xdp_buff *xdp_md)
+ *	Description
+ *		Get the total size of a given xdp buff (linear and paged area)
+ *	Return
+ *		The total size of a given xdp buffer.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5125,6 +5131,7 @@ union bpf_attr {
 	FN(trace_vprintk),		\
 	FN(skc_to_unix_sock),		\
 	FN(kallsyms_lookup_name),	\
+	FN(xdp_get_buff_len),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/net/core/filter.c b/net/core/filter.c
index 8e8d3b49c297..1b8bb44ef03f 100644
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
index d2abb7cff9b5..c643be066700 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4943,6 +4943,12 @@ union bpf_attr {
  *		**-ENOENT** if symbol is not found.
  *
  *		**-EPERM** if caller does not have permission to obtain kernel address.
+ *
+ * u64 bpf_xdp_get_buff_len(struct xdp_buff *xdp_md)
+ *	Description
+ *		Get the total size of a given xdp buff (linear and paged area)
+ *	Return
+ *		The total size of a given xdp buffer.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5125,6 +5131,7 @@ union bpf_attr {
 	FN(trace_vprintk),		\
 	FN(skc_to_unix_sock),		\
 	FN(kallsyms_lookup_name),	\
+	FN(xdp_get_buff_len),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.31.1

