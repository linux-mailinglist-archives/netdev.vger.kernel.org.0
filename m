Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5E2D3230FA
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 19:50:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233952AbhBWSuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 13:50:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233405AbhBWSu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 13:50:29 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84D94C06178A;
        Tue, 23 Feb 2021 10:49:49 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id l64so5903109oig.9;
        Tue, 23 Feb 2021 10:49:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yXSdJhcfJca2aHrUW7nbcpmkhzySeq2lXG5UhhU0x4M=;
        b=JuQrYzjXHfxebJ4kXT7IIUdB6vJxv95Dp/DpcF+VszqeBvzPS7OXrhfIyWGWkkhuUt
         Y66m8b89OxkYKSNqZCEGbQfSlFuHmXT6ErDtNIoHx56yMQepi4k2bauHCfJZwJh1u/hs
         RvH/k0GkaQ3y7gBu3r25yB7xzDbGQM3KiuIbn20T7pTz+C99FHMGWkrshAOqvdgd8b4I
         ACkc0XHP6CWNhnXxd6+3tTRIymGmbeCoNHlhCysCaG89YfdFbqZvl9AOcrkuBT5yPXaW
         AaN77MSjOsDPVdWcAokXyeL+OEH058qyPcQV9QkepW1CTKj3HnJ2a8NE76Mg8VRKOoR+
         1uxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yXSdJhcfJca2aHrUW7nbcpmkhzySeq2lXG5UhhU0x4M=;
        b=BWzKWghNRpojNvgH0+hb4WinZb5Ksv+cEYdPn6HYeZIXAdEWv570DxKONXl/1Hf38R
         97eNwYe2Gok0L6oUHvmtGHYGNx1t8pec3pg5ugZwkYtXEjx0eZe73lXdE44SqUtE1Ql8
         VrJJRgebUweg//h5zORISsmEGyBfKm2XoAms+qVUqeGI3XPNVBds9trfpNM6gc32rGmB
         fUZ2yJIIK6oI1c7aZzHRoXVUAuhzH77jW54yXAtKUMleTB/gj399i15uQi9nc+4lv78E
         8Fq9CjzDPPSmbQAUC8Q3NyhNo8zUyV5pd/OorzTkc207PBeHiJSiXcooGIBzgJek6bm2
         upyA==
X-Gm-Message-State: AOAM532WXTQjXoH70ezMEGbSXzVA1s30yqnxslTyFVdT7/99nBPjvio+
        0WDuz2i7oj/LN+zD6t4Xuc5wrxR1e7Ylww==
X-Google-Smtp-Source: ABdhPJzgbytzVAgH9C609DMa40QsBJbsNjT8dgXIop/AqSChWLr9X7/e6AHin0IUK0ua8INQksqbcw==
X-Received: by 2002:aca:5882:: with SMTP id m124mr99976oib.137.1614106188769;
        Tue, 23 Feb 2021 10:49:48 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:4543:ab2:3bf6:ce41])
        by smtp.gmail.com with ESMTPSA id p12sm4387094oon.12.2021.02.23.10.49.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 10:49:48 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [Patch bpf-next v7 3/9] bpf: compute data_end dynamically with JIT code
Date:   Tue, 23 Feb 2021 10:49:28 -0800
Message-Id: <20210223184934.6054-4-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210223184934.6054-1-xiyou.wangcong@gmail.com>
References: <20210223184934.6054-1-xiyou.wangcong@gmail.com>
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
index d00c9a4b47e7..8822001ab3dc 100644
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

