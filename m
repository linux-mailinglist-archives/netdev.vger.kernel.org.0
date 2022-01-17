Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F300B490F82
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 18:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238456AbiAQRaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 12:30:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45588 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238941AbiAQRaA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 12:30:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D46AE60AF9;
        Mon, 17 Jan 2022 17:29:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D15AC36AED;
        Mon, 17 Jan 2022 17:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642440599;
        bh=eTLxbk/wGOdTZl2khSgj1mU8CdFjRwMl68mRgZj9Zto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F+shNDz4jE3VqT+CZtadhNKg4c4l5PT8ivjptdVuGR/TVkMWrQUVdXRVnx4EJJmnf
         LIQu6B4N+D/JoD2DwRQhsdK1dG9v0dAmw2IuW4s8T88HSwxma2I4fmP8cWX8dr1bX1
         Q9Zu58tY+SwwIqRU+2kOb9bVb/mDcQh3EPSl3TVdZv6goWz44awdtP80m8YluNsYcv
         We35cmiLYdUx1UKcYyE2l74b1Ny+gahCBowWZ+ARX5mU148ggk8S2/655V6gYKFLZK
         Y+uB10USktzBmX1PCrTOSqg88yfcdWpJLqdew/kb9vO4oBssMtqKluMGa8xGAhQAIm
         FMGFPFH2DR4TQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v22 bpf-next 11/23] bpf: introduce bpf_xdp_get_buff_len helper
Date:   Mon, 17 Jan 2022 18:28:23 +0100
Message-Id: <e178cc8f5e09510995edc14890b7cb8e2318b2a4.1642439548.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1642439548.git.lorenzo@kernel.org>
References: <cover.1642439548.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce bpf_xdp_get_buff_len helper in order to return the xdp buffer
total size (linear and paged area)

Acked-by: Toke Hoiland-Jorgensen <toke@redhat.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/net/xdp.h              | 14 ++++++++++++++
 include/uapi/linux/bpf.h       |  7 +++++++
 net/core/filter.c              | 15 +++++++++++++++
 tools/include/uapi/linux/bpf.h |  7 +++++++
 4 files changed, 43 insertions(+)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index 2fc76cd6e09d..6caea9b633e4 100644
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
+	if (likely(!xdp_buff_has_frags(xdp)))
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
index 35e95d56f858..26c6c2bc6b43 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5023,6 +5023,12 @@ union bpf_attr {
  *
  *	Return
  *		The number of arguments of the traced function.
+ *
+ * u64 bpf_xdp_get_buff_len(struct xdp_buff *xdp_md)
+ *	Description
+ *		Get the total size of a given xdp buff (linear and paged area)
+ *	Return
+ *		The total size of a given xdp buffer.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5211,6 +5217,7 @@ union bpf_attr {
 	FN(get_func_arg),		\
 	FN(get_func_ret),		\
 	FN(get_func_arg_cnt),		\
+	FN(xdp_get_buff_len),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/net/core/filter.c b/net/core/filter.c
index 4603b7cd3cd1..332f8e7802bc 100644
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
@@ -7533,6 +7546,8 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_xdp_redirect_map_proto;
 	case BPF_FUNC_xdp_adjust_tail:
 		return &bpf_xdp_adjust_tail_proto;
+	case BPF_FUNC_xdp_get_buff_len:
+		return &bpf_xdp_get_buff_len_proto;
 	case BPF_FUNC_fib_lookup:
 		return &bpf_xdp_fib_lookup_proto;
 	case BPF_FUNC_check_mtu:
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 35e95d56f858..26c6c2bc6b43 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5023,6 +5023,12 @@ union bpf_attr {
  *
  *	Return
  *		The number of arguments of the traced function.
+ *
+ * u64 bpf_xdp_get_buff_len(struct xdp_buff *xdp_md)
+ *	Description
+ *		Get the total size of a given xdp buff (linear and paged area)
+ *	Return
+ *		The total size of a given xdp buffer.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5211,6 +5217,7 @@ union bpf_attr {
 	FN(get_func_arg),		\
 	FN(get_func_ret),		\
 	FN(get_func_arg_cnt),		\
+	FN(xdp_get_buff_len),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.34.1

