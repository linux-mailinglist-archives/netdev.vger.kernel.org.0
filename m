Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C44AC426B3F
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 14:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242263AbhJHMxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 08:53:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:50352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242155AbhJHMxk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 08:53:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86A3C61037;
        Fri,  8 Oct 2021 12:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633697504;
        bh=xrLgmj7H1KaMLgDfiwwj8AtxMVxiwz9rsEkykXo/wkw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oOu2rOxkTHl8L7vJwCHflfb++aWa9pR9rHgYDdtfEAea9l6GIVOd291rQtJ2yCoo1
         Rqb4MAqYxxl9uI6LK6KXbOTOsSHOaD4z5lvBg6m8d5UgF6/x1Bjs/CCnFoBclI/laM
         JolLQSD19alQKzh6x1RvE7pEFIWbhHVVgGZO0Uqa29B+Vyp4dihJMijzMQD0pQ1/bf
         +RT5+UrC6x5vJ4IMdgDov9MsYb09al4Ik4Cf/9LuHz7F6zXAzT2LEZOa/tt3y1IbDI
         Kb7vuLgx8dA1fGfBGo04AEI08VRAMCqP+5RUXBVsiIx5H2PxxA1fBGMqOW/RSUUHcB
         s19EXXgTwuvRA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v15 bpf-next 11/18] bpf: introduce bpf_xdp_get_buff_len helper
Date:   Fri,  8 Oct 2021 14:49:49 +0200
Message-Id: <6537553aa125a3d40b5ace41683109295a226ff2.1633697183.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1633697183.git.lorenzo@kernel.org>
References: <cover.1633697183.git.lorenzo@kernel.org>
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
 include/uapi/linux/bpf.h       |  7 +++++++
 net/core/filter.c              | 23 +++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h |  7 +++++++
 3 files changed, 37 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 6fc59d61937a..a9946d860740 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4909,6 +4909,12 @@ union bpf_attr {
  *	Return
  *		The number of bytes written to the buffer, or a negative error
  *		in case of failure.
+ *
+ * u64 bpf_xdp_get_buff_len(struct xdp_buff *xdp_md)
+ *	Description
+ *		Get the total size of a given xdp buff (linear and paged area)
+ *	Return
+ *		The total size of a given xdp buffer.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5089,6 +5095,7 @@ union bpf_attr {
 	FN(task_pt_regs),		\
 	FN(get_branch_snapshot),	\
 	FN(trace_vprintk),		\
+	FN(xdp_get_buff_len),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/net/core/filter.c b/net/core/filter.c
index 02fc6aa8a7b6..1749374a3d04 100644
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
@@ -7536,6 +7557,8 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_xdp_redirect_map_proto;
 	case BPF_FUNC_xdp_adjust_tail:
 		return &bpf_xdp_adjust_tail_proto;
+	case BPF_FUNC_xdp_get_buff_len:
+		return &bpf_xdp_get_buff_len_proto;
 	case BPF_FUNC_fib_lookup:
 		return &bpf_xdp_fib_lookup_proto;
 	case BPF_FUNC_check_mtu:
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 6fc59d61937a..a9946d860740 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4909,6 +4909,12 @@ union bpf_attr {
  *	Return
  *		The number of bytes written to the buffer, or a negative error
  *		in case of failure.
+ *
+ * u64 bpf_xdp_get_buff_len(struct xdp_buff *xdp_md)
+ *	Description
+ *		Get the total size of a given xdp buff (linear and paged area)
+ *	Return
+ *		The total size of a given xdp buffer.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5089,6 +5095,7 @@ union bpf_attr {
 	FN(task_pt_regs),		\
 	FN(get_branch_snapshot),	\
 	FN(trace_vprintk),		\
+	FN(xdp_get_buff_len),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.31.1

