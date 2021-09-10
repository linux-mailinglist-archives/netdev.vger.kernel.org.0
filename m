Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 749E9406F75
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 18:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233941AbhIJQRJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 12:17:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:41700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233936AbhIJQQm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Sep 2021 12:16:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADE3E61262;
        Fri, 10 Sep 2021 16:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631290530;
        bh=TtT9lfm2SQG+xo6m+8GUVzq9pbrd5KPuXQdmBrg35Aw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vNp8RXByJgiHjBIeHwgeoQZRr33KVeANbqN3Km8jQ/dT7+B36c545AwCSHp9EJEKK
         VMgkrT8Ro8+367AAjpa9h8MzjvLTNT+3LJMbwChkszHuuym6H9HqayujP/aulI37E1
         g8hiFsYAjtiaTWOmhRW2PR+F74jDHi34oaMbMjr7vZeGH4iLgF9/jq+NSPlRVAvaMq
         7D7oCXOy16EQJ0We+U1gGpogwpsVeTzHiarRY9PhERW1AVZSCRprM3jWFt1FYiT7bf
         ZfPhrJFk6fsqyuzNS0n+8fnjAFTy6Upnjvp8e3ayTjBpG0or0MF1gR214wOTV2nv0J
         fLNBSJJ+ElYIQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v14 bpf-next 11/18] bpf: introduce bpf_xdp_get_buff_len helper
Date:   Fri, 10 Sep 2021 18:14:17 +0200
Message-Id: <5dd10bffff5db6808c51ba971c618ea4c4631ac3.1631289870.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1631289870.git.lorenzo@kernel.org>
References: <cover.1631289870.git.lorenzo@kernel.org>
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
index 791f31dd0abe..1fd87bd5848b 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4877,6 +4877,12 @@ union bpf_attr {
  *		Get the struct pt_regs associated with **task**.
  *	Return
  *		A pointer to struct pt_regs.
+ *
+ * u64 bpf_xdp_get_buff_len(struct xdp_buff *xdp_md)
+ *	Description
+ *		Get the total size of a given xdp buff (linear and paged area)
+ *	Return
+ *		The total size of a given xdp buffer.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5055,6 +5061,7 @@ union bpf_attr {
 	FN(get_func_ip),		\
 	FN(get_attach_cookie),		\
 	FN(task_pt_regs),		\
+	FN(xdp_get_buff_len),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/net/core/filter.c b/net/core/filter.c
index 49feba8f8966..d4982a20c8bd 100644
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
@@ -7531,6 +7552,8 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_xdp_redirect_map_proto;
 	case BPF_FUNC_xdp_adjust_tail:
 		return &bpf_xdp_adjust_tail_proto;
+	case BPF_FUNC_xdp_get_buff_len:
+		return &bpf_xdp_get_buff_len_proto;
 	case BPF_FUNC_fib_lookup:
 		return &bpf_xdp_fib_lookup_proto;
 	case BPF_FUNC_check_mtu:
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 791f31dd0abe..1fd87bd5848b 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4877,6 +4877,12 @@ union bpf_attr {
  *		Get the struct pt_regs associated with **task**.
  *	Return
  *		A pointer to struct pt_regs.
+ *
+ * u64 bpf_xdp_get_buff_len(struct xdp_buff *xdp_md)
+ *	Description
+ *		Get the total size of a given xdp buff (linear and paged area)
+ *	Return
+ *		The total size of a given xdp buffer.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5055,6 +5061,7 @@ union bpf_attr {
 	FN(get_func_ip),		\
 	FN(get_attach_cookie),		\
 	FN(task_pt_regs),		\
+	FN(xdp_get_buff_len),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.31.1

