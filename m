Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD1D315D35
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 03:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235131AbhBJCZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 21:25:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235260AbhBJCWp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 21:22:45 -0500
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4651EC061786;
        Tue,  9 Feb 2021 18:22:00 -0800 (PST)
Received: by mail-oo1-xc2a.google.com with SMTP id t196so183650oot.2;
        Tue, 09 Feb 2021 18:22:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zS7mIkk0dXqTDW1+AEKDgpXLzBn50aKAef0N3oNxsSQ=;
        b=M0/HRrpKkFrl300kmYzhTnPsFbVsBDKJi+6BT//Y/9bh1fvj/tGDMwQQZOLkv47CC0
         JWjAfv6TFkyRdOZ2qTVJBf8ostiQycvsXGWwGjkQygo2dK1DHP87VQgOhxV8VBvMJ116
         h5VNjyD97oh2iVgnPURp1iyhb77qVSlGqhhv/7YxFVc5xBW5FZ1lSdpvbL1nxbE2R99z
         0U6op5FG5MDyA018CGPOIxJch5NptuZkBdwqCoVdODUgYOWLogVRBVhnN5A8ZotxXc3x
         ZiHkyBB+36q+8U+0Rf36GKeaCQ2EEJZPnOBzOIfRZ+0DSBp44IWtHj/wcE2Re79CMG0b
         dSDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zS7mIkk0dXqTDW1+AEKDgpXLzBn50aKAef0N3oNxsSQ=;
        b=I7peysebwSDRKnxlMh00Hk4psF2Ui77u1pAxqOaqVtqGFYIhIs7/dZEuNMOG0zoSHT
         lotDsAQW1/yBF4uALGKtDV+YdfxyiDnytahh63QQwyt0cM309UGNF8VqEw1boPsK//K3
         RBqPpcDzsoWzWor89m37A0AfYRzoCFEz0i7PKILtVrqjiLuwCobuAQEv8PzR4uIO21wY
         vp2Zfj5tUrofeWZ8vXcJI+/FIB8Vt7uc0DKxCIyvn8N3AC10DiwKSzit6WlB9JqfN8ID
         iPZNXejk2mCoXd4pgBZIA/q4EEFmF3xXUXSu/nYKq2UeRD9xLvWDmn9WE/3xDuewr2j0
         4Rvw==
X-Gm-Message-State: AOAM5331hCh58k+/g+1G+RNIUCDca/YJCzSbtFfMY1NWLHZrcC7YNBsM
        2hYk6CyLyGhpaHgE+U4si6mWvND99AvSLA==
X-Google-Smtp-Source: ABdhPJwAfYG6drbL3Br0tRnJKnjFPDXRLjfhJB3iSTjpsHJXGriBB/4n4dNpX4GGKKUVNUolVSng0Q==
X-Received: by 2002:a4a:dc51:: with SMTP id q17mr654913oov.76.1612923719561;
        Tue, 09 Feb 2021 18:21:59 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:58b0:eb39:33aa:5355])
        by smtp.gmail.com with ESMTPSA id z20sm101051oth.55.2021.02.09.18.21.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 18:21:59 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v2 3/5] bpf: compute data_end dynamically with JIT code
Date:   Tue,  9 Feb 2021 18:21:34 -0800
Message-Id: <20210210022136.146528-4-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210210022136.146528-1-xiyou.wangcong@gmail.com>
References: <20210210022136.146528-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Currently, we compute ->data_end with a compile-time constant
offset of skb. But as Jakub pointed out, we can actually compute
it in eBPF JIT code at run-time, so that we can competely get
rid of ->data_end. This is similar to skb_shinfo(skb) computation
in bpf_convert_shinfo_access().

Suggested-by: Jakub Sitnicki <jakub@cloudflare.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/net/tcp.h |  6 ------
 net/core/filter.c | 46 +++++++++++++++++++++++++++-------------------
 net/core/skmsg.c  |  1 -
 3 files changed, 27 insertions(+), 26 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index dfb20d51bf3d..808d5292cf13 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -885,18 +885,12 @@ struct tcp_skb_cb {
 		struct {
 			__u32 flags;
 			struct sock *sk_redir;
-			void *data_end;
 		} bpf;
 	};
 };
 
 #define TCP_SKB_CB(__skb)	((struct tcp_skb_cb *)&((__skb)->cb[0]))
 
-static inline void bpf_compute_data_end_sk_skb(struct sk_buff *skb)
-{
-	TCP_SKB_CB(skb)->bpf.data_end = skb->data + skb_headlen(skb);
-}
-
 static inline bool tcp_skb_bpf_ingress(const struct sk_buff *skb)
 {
 	return TCP_SKB_CB(skb)->bpf.flags & BPF_F_INGRESS;
diff --git a/net/core/filter.c b/net/core/filter.c
index e15d4741719a..b2b18426d280 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -1863,10 +1863,7 @@ static const struct bpf_func_proto bpf_sk_fullsock_proto = {
 static inline int sk_skb_try_make_writable(struct sk_buff *skb,
 					   unsigned int write_len)
 {
-	int err = __bpf_try_make_writable(skb, write_len);
-
-	bpf_compute_data_end_sk_skb(skb);
-	return err;
+	return __bpf_try_make_writable(skb, write_len);
 }
 
 BPF_CALL_2(sk_skb_pull_data, struct sk_buff *, skb, u32, len)
@@ -3581,7 +3578,6 @@ BPF_CALL_4(sk_skb_adjust_room, struct sk_buff *, skb, s32, len_diff,
 			return -ENOMEM;
 		__skb_pull(skb, len_diff_abs);
 	}
-	bpf_compute_data_end_sk_skb(skb);
 	if (tls_sw_has_ctx_rx(skb->sk)) {
 		struct strp_msg *rxm = strp_msg(skb);
 
@@ -3746,10 +3742,7 @@ static const struct bpf_func_proto bpf_skb_change_tail_proto = {
 BPF_CALL_3(sk_skb_change_tail, struct sk_buff *, skb, u32, new_len,
 	   u64, flags)
 {
-	int ret = __bpf_skb_change_tail(skb, new_len, flags);
-
-	bpf_compute_data_end_sk_skb(skb);
-	return ret;
+	return __bpf_skb_change_tail(skb, new_len, flags);
 }
 
 static const struct bpf_func_proto sk_skb_change_tail_proto = {
@@ -3812,10 +3805,7 @@ static const struct bpf_func_proto bpf_skb_change_head_proto = {
 BPF_CALL_3(sk_skb_change_head, struct sk_buff *, skb, u32, head_room,
 	   u64, flags)
 {
-	int ret = __bpf_skb_change_head(skb, head_room, flags);
-
-	bpf_compute_data_end_sk_skb(skb);
-	return ret;
+	return __bpf_skb_change_head(skb, head_room, flags);
 }
 
 static const struct bpf_func_proto sk_skb_change_head_proto = {
@@ -9520,6 +9510,29 @@ static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
 	return insn - insn_buf;
 }
 
+static struct bpf_insn *bpf_convert_data_end_access(const struct bpf_insn *si,
+						    struct bpf_insn *insn)
+{
+	/* si->dst_reg = skb->data */
+	*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct sk_buff, data),
+			      si->dst_reg, si->src_reg,
+			      offsetof(struct sk_buff, data));
+	/* AX = skb->len */
+	*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct sk_buff, len),
+			      BPF_REG_AX, si->src_reg,
+			      offsetof(struct sk_buff, len));
+	/* si->dst_reg = skb->data + skb->len */
+	*insn++ = BPF_ALU64_REG(BPF_ADD, si->dst_reg, BPF_REG_AX);
+	/* AX = skb->data_len */
+	*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct sk_buff, data_len),
+			      BPF_REG_AX, si->src_reg,
+			      offsetof(struct sk_buff, data_len));
+	/* si->dst_reg = skb->data + skb->len - skb->data_len */
+	*insn++ = BPF_ALU64_REG(BPF_SUB, si->dst_reg, BPF_REG_AX);
+
+	return insn;
+}
+
 static u32 sk_skb_convert_ctx_access(enum bpf_access_type type,
 				     const struct bpf_insn *si,
 				     struct bpf_insn *insn_buf,
@@ -9530,12 +9543,7 @@ static u32 sk_skb_convert_ctx_access(enum bpf_access_type type,
 
 	switch (si->off) {
 	case offsetof(struct __sk_buff, data_end):
-		off  = si->off;
-		off -= offsetof(struct __sk_buff, data_end);
-		off += offsetof(struct sk_buff, cb);
-		off += offsetof(struct tcp_skb_cb, bpf.data_end);
-		*insn++ = BPF_LDX_MEM(BPF_SIZEOF(void *), si->dst_reg,
-				      si->src_reg, off);
+		insn = bpf_convert_data_end_access(si, insn);
 		break;
 	default:
 		return bpf_convert_ctx_access(type, si, insn_buf, prog,
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 9d673179e886..64166e48999c 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -746,7 +746,6 @@ EXPORT_SYMBOL_GPL(sk_psock_msg_verdict);
 static int sk_psock_bpf_run(struct sk_psock *psock, struct bpf_prog *prog,
 			    struct sk_buff *skb)
 {
-	bpf_compute_data_end_sk_skb(skb);
 	return bpf_prog_run_pin_on_cpu(prog, skb);
 }
 
-- 
2.25.1

