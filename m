Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAECB32020B
	for <lists+netdev@lfdr.de>; Sat, 20 Feb 2021 01:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbhBSX7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 18:59:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbhBSX70 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 18:59:26 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF38DC06178B;
        Fri, 19 Feb 2021 15:58:45 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id s107so6684553otb.8;
        Fri, 19 Feb 2021 15:58:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Cn214jZGzgjFbft7eNgUOtSG+SxXEwz3c8kvQYZqNKs=;
        b=AuGqKE0jfE9wj48kupEajlfnSeqYyQtq11DssZg8pvGWHtw0v/vL86vwSJpZ7vBYwK
         WO66jy8yN+alDJxNXLQCYd6XaYqXMpqw1LDW7zqVO+8Akyf9fWT6lOk0YSFl/+1yBsbV
         igMVowixAToxRpcv2Sh6rCDGtZ/Ga75/sIptYm1YYq2aaDSplBx7E4EItDJM91lstdvy
         KvUv1FVpwPq/cxuEn4EXmTi3oCEhq1KvW+q3lXD1dw9NQIDeENwxWGmMII9nWyJR7yH4
         ykBiJ6+9J9qUCdH+xpUXZisOfrus15klIZ0ITc10YkZdLvrkbFU6w91W5G/o4PMURI98
         /raw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Cn214jZGzgjFbft7eNgUOtSG+SxXEwz3c8kvQYZqNKs=;
        b=Sg21elZqzXxpTzUQx7+aEz9Xk9i/0tfbVZtuTKOboYy4laXQoUN7An4PgDcmpYuDNe
         QP6LoDdW4/XY8R0nqkH/A+4mqM7W/axmoug6B/7Z3r+ZXT/hRi5ApC9aDqkz4lbsiHoh
         FXee5Unh3+MZnkgndh7YfdU1puyHjDzchrXY6IkFQx7GpMJkwvnqDXMy8q4NwzWuvcUh
         NqrFislOdxzKqk6cEZa3ylnj1H8qUb3cUeJ+7z/pqRSVCGiz85aGEJskpRFs/FCcdO0m
         PM20ejgq1RCU8BQ7q0ZepZAbw9qZhu2fvvSb851Ru+B0f3Furv1JetCyUDXhHYJbwO69
         t8/A==
X-Gm-Message-State: AOAM530HFBOt1dwVAWpwK05Rn4OTXlbbxnDxwIG/NQZ6XQTVX2ju7FHP
        jzTu07GqWLHqpcgymg+pe0oSNWleISQ/Pw==
X-Google-Smtp-Source: ABdhPJyFGXOesZUPKVW24/UgaTAY2kArOrIsSXv3cCel1b6RKeMZvRtoIkGV+4Uxlrqob6C5rB2bYQ==
X-Received: by 2002:a9d:4595:: with SMTP id x21mr8865986ote.32.1613779125064;
        Fri, 19 Feb 2021 15:58:45 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:1d72:18:7c76:92e4])
        by smtp.gmail.com with ESMTPSA id h11sm2064186ooj.36.2021.02.19.15.58.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 15:58:44 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [Patch bpf-next v5 3/8] bpf: compute data_end dynamically with JIT code
Date:   Fri, 19 Feb 2021 15:58:31 -0800
Message-Id: <20210219235836.100416-4-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210219235836.100416-1-xiyou.wangcong@gmail.com>
References: <20210219235836.100416-1-xiyou.wangcong@gmail.com>
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
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/net/tcp.h |  6 ------
 net/core/filter.c | 48 +++++++++++++++++++++++++++--------------------
 net/core/skmsg.c  |  1 -
 3 files changed, 28 insertions(+), 27 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index c00e125dcfb9..947ef5da6867 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -886,18 +886,12 @@ struct tcp_skb_cb {
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
index adfdad234674..13bcf248ee7b 100644
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
@@ -9655,22 +9645,40 @@ static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
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

