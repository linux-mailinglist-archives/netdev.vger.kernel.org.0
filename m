Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F08531AE34
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 22:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbhBMVpX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 16:45:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbhBMVpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 16:45:11 -0500
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 852E7C061786;
        Sat, 13 Feb 2021 13:44:31 -0800 (PST)
Received: by mail-oi1-x233.google.com with SMTP id r75so3735370oie.11;
        Sat, 13 Feb 2021 13:44:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fX7VdRHuzd45EoRblcFI1fktyzch3UBY7GS8n5OGNiM=;
        b=tOQmQUrhUMkfi8lb4/mtA0Ghd2/bkrYzrya2r1QyEKGw8GMWlEz0pMDFcVtTRasu1e
         Oc/PGeew8BE56vdzHQ7o0ZFym329b32CZmwOLnjHXwhkuL+7Mk6vhP26pyA7JWX+zcg5
         Ub01/qpT0R5KsixUoHtDauswmHe0yGjQbWNmaczBM50k29u7cWEzs5lxJ583djq9OqiF
         BLQXokNMfdPwCNEHKXYDf5g243ZxWsFdNIQOWTOoHqmS3fU0fZOegTfTQHPtR/MEl6UC
         3M9TFtXKMq8CP2HPwBxadNCR3hzsERVmefF1GaY8Vei0OXKJgAlDgU8+HYLtie7OJKch
         mFKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fX7VdRHuzd45EoRblcFI1fktyzch3UBY7GS8n5OGNiM=;
        b=Ns8QJnKvOFE2c+Was7qvEvQbUIjsZwRVbo3MfQMpis6+kWQNGNHU5xtvmc57DBcIlu
         iV8CjGJ33h0XXA6LCCOiY3n2cUlcWLZP5OLv9KXuS9GVLLPbpxgJNhorPVnI3b4dTUrV
         Gqf/8Vf7fzLKeAuJq4PLNMndfzf1zzyeBMPFw2mkRXpvNUik7Gwhq2zKTYWd6hUjLvWJ
         5aEe2Vr2xML6g+1Qi91DOofbPUunNZp4nuNbJY+b+8xh5e9fwWBVnZ/3FBUFSYNZV8hJ
         qS+fEII0dBly8k6kuBNMBAxehzzvmxITFR7xdEFlD+sNQBjU7+a3T4OQle0ihUltfsZZ
         qSUg==
X-Gm-Message-State: AOAM530EqO7JgvUFJwydxqH4COXFhPWNTgdP+kT5crz99qdiyXQFRsVp
        vFkZO6O1JnJzgi6LN9TvKfzfi3djAdTjpw==
X-Google-Smtp-Source: ABdhPJwcW0eceGhsVLjR09ZW8I2Noxmd31OhiQPoaMAB4HEhg0wVol3sCBxmLl0woTVJ040shZNRjA==
X-Received: by 2002:aca:1003:: with SMTP id 3mr3743184oiq.22.1613252670831;
        Sat, 13 Feb 2021 13:44:30 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:108:c15a:7f7a:df71])
        by smtp.gmail.com with ESMTPSA id c17sm2509674otp.58.2021.02.13.13.44.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Feb 2021 13:44:30 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v3 3/5] bpf: compute data_end dynamically with JIT code
Date:   Sat, 13 Feb 2021 13:44:19 -0800
Message-Id: <20210213214421.226357-4-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210213214421.226357-1-xiyou.wangcong@gmail.com>
References: <20210213214421.226357-1-xiyou.wangcong@gmail.com>
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
 net/core/filter.c | 48 +++++++++++++++++++++++++++--------------------
 net/core/skmsg.c  |  1 -
 3 files changed, 28 insertions(+), 27 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 99fdbf03aeee..697712178eff 100644
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
index 7059cf604d94..38c4996e48bf 100644
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
@@ -3577,7 +3574,6 @@ BPF_CALL_4(sk_skb_adjust_room, struct sk_buff *, skb, s32, len_diff,
 			return -ENOMEM;
 		__skb_pull(skb, len_diff_abs);
 	}
-	bpf_compute_data_end_sk_skb(skb);
 	if (tls_sw_has_ctx_rx(skb->sk)) {
 		struct strp_msg *rxm = strp_msg(skb);
 
@@ -3742,10 +3738,7 @@ static const struct bpf_func_proto bpf_skb_change_tail_proto = {
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
@@ -3808,10 +3801,7 @@ static const struct bpf_func_proto bpf_skb_change_head_proto = {
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
@@ -9657,22 +9647,40 @@ static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
 	return insn - insn_buf;
 }
 
+/* data_end = skb->data + skb_headlen() */
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
 				     struct bpf_prog *prog, u32 *target_size)
 {
 	struct bpf_insn *insn = insn_buf;
-	int off;
 
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
index 7f400d044cda..2d8bbb3fd87c 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -744,7 +744,6 @@ EXPORT_SYMBOL_GPL(sk_psock_msg_verdict);
 static int sk_psock_bpf_run(struct sk_psock *psock, struct bpf_prog *prog,
 			    struct sk_buff *skb)
 {
-	bpf_compute_data_end_sk_skb(skb);
 	return bpf_prog_run_pin_on_cpu(prog, skb);
 }
 
-- 
2.25.1

