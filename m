Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F40D146338E
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 12:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232370AbhK3L6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 06:58:35 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43168 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232856AbhK3L6A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 06:58:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D5ECB81864;
        Tue, 30 Nov 2021 11:54:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E345C53FC1;
        Tue, 30 Nov 2021 11:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638273279;
        bh=Cch2afeDGkOMTJd/JBBgIVjyqKXHmdB8nRcMtOFGLy8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M55+yLVrqn+tCn/yJTbA6WLhK5bRKZj9WL1LcsiDlzcJC/Hpc7OTE90ntAPSwQ3Lb
         1BobYkaqS6bb1lgyoELf73SY6ln049oLvK0AP4QOkbw1MmccUPt3wGborUtudVa/v/
         hF/kw46wVj+91DBM5WrtohsECCvH0P78oX44k1ed+yQtwydkRnYedINwD4ZXS9CJg1
         Kp8n8Ra3fC/TD9oJgNg6pwKTmLsKMinFoEStxg9Q3N65LRRvcA+EiWKa+AuWfOyQ+w
         uHsgEdMVxMuJ47DUI3mRKs//xfpIUgZmjpuSQoJL7Mhfd/cEPNbLpg0CShPHfZWZt7
         C4TAyeKlC61xw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v19 bpf-next 11/23] bpf: introduce bpf_xdp_get_buff_len helper
Date:   Tue, 30 Nov 2021 12:52:55 +0100
Message-Id: <71cc0a9ad18204652729c4ec73efa30ef6b3db6d.1638272238.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1638272238.git.lorenzo@kernel.org>
References: <cover.1638272238.git.lorenzo@kernel.org>
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
index be07a2f65e3f..efc999a8b3e3 100644
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
index 26e0276aa00d..b9bfe6fac6df 100644
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
index be07a2f65e3f..efc999a8b3e3 100644
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

