Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEB6A470A1B
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 20:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343579AbhLJTTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 14:19:38 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36926 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343559AbhLJTTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 14:19:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 788F6B829CD;
        Fri, 10 Dec 2021 19:15:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BBAFC341C5;
        Fri, 10 Dec 2021 19:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639163755;
        bh=FKALSMi2VJQGz04JazmUVPsyh+Xc1eBZyHCYjmxrNyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jRsHT8gJ90B3ZKwDBqWuanZJ7UmGuZfFRGSybqC1dKuZQ5M2oHmrq3mxxpMdhTzXm
         6TuQkWtyrVtLvhYKswLRRexsa1M6qPITngOcJcX+C+9xbdK7VxG8w5HIUaGgm/BRFR
         Wf6ALt4GxRcghLrAPEY7GGUjT4SiSloeBsCTI4bo/O8rg1GVWRbGgSr4XTLjRlFhoK
         zFRDVnrg/11v7/e4kGh0nv//y/BMxEL7iwL+7Xf8dEIQS5lSReGfKDkYtGtceLayr/
         bRwy1MXqdKCmP+goFbxbNVM0fMnZLyeNO+jAsnCbsJdCssDVGPUuWnmZXw6hVGa/HJ
         4un6iDn0WYSog==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v20 bpf-next 11/23] bpf: introduce bpf_xdp_get_buff_len helper
Date:   Fri, 10 Dec 2021 20:14:18 +0100
Message-Id: <b653bef9ba0481addfd8328ec132de9f26f45f4c.1639162845.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1639162845.git.lorenzo@kernel.org>
References: <cover.1639162845.git.lorenzo@kernel.org>
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
index d5d3e7d9ec49..d5921a0202f4 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4988,6 +4988,12 @@ union bpf_attr {
  *	Return
  *		The number of loops performed, **-EINVAL** for invalid **flags**,
  *		**-E2BIG** if **nr_loops** exceeds the maximum number of loops.
+ *
+ * u64 bpf_xdp_get_buff_len(struct xdp_buff *xdp_md)
+ *	Description
+ *		Get the total size of a given xdp buff (linear and paged area)
+ *	Return
+ *		The total size of a given xdp buffer.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5172,6 +5178,7 @@ union bpf_attr {
 	FN(kallsyms_lookup_name),	\
 	FN(find_vma),			\
 	FN(loop),			\
+	FN(xdp_get_buff_len),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/net/core/filter.c b/net/core/filter.c
index fe27c91e3758..122d3a6afe9d 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3783,6 +3783,19 @@ static const struct bpf_func_proto sk_skb_change_head_proto = {
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
@@ -7470,6 +7483,8 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_xdp_redirect_map_proto;
 	case BPF_FUNC_xdp_adjust_tail:
 		return &bpf_xdp_adjust_tail_proto;
+	case BPF_FUNC_xdp_get_buff_len:
+		return &bpf_xdp_get_buff_len_proto;
 	case BPF_FUNC_fib_lookup:
 		return &bpf_xdp_fib_lookup_proto;
 	case BPF_FUNC_check_mtu:
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index d5d3e7d9ec49..d5921a0202f4 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4988,6 +4988,12 @@ union bpf_attr {
  *	Return
  *		The number of loops performed, **-EINVAL** for invalid **flags**,
  *		**-E2BIG** if **nr_loops** exceeds the maximum number of loops.
+ *
+ * u64 bpf_xdp_get_buff_len(struct xdp_buff *xdp_md)
+ *	Description
+ *		Get the total size of a given xdp buff (linear and paged area)
+ *	Return
+ *		The total size of a given xdp buffer.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5172,6 +5178,7 @@ union bpf_attr {
 	FN(kallsyms_lookup_name),	\
 	FN(find_vma),			\
 	FN(loop),			\
+	FN(xdp_get_buff_len),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.33.1

