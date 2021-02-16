Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6CD31C695
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 07:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbhBPGoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 01:44:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbhBPGnh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 01:43:37 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C17C0613D6;
        Mon, 15 Feb 2021 22:42:57 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id l19so10210873oih.6;
        Mon, 15 Feb 2021 22:42:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+Z88gI7HqU6DoIwoeYnykAbwInRUkwr1vEWjVMbGfxA=;
        b=bFOdPyuvmGrfyeS0RYRkRYa0eALMwAy8NLDHPr5zTNwvwUFKS/uuJ3A5lIGpuBWGvp
         2JDiF9gFuslFnyOZVgzhGvNFbHTqH6vcsidpEcVo2zSRmk99TCjPKuEyxvBfUBmfLWMf
         9r53OwNyYM4+rWtFH4pZagAgFvN5bbPpzLBmiexol+w9qrx5tTI2LFqkCImlpsoIkwuL
         frkP0co8juADqeYSee68VyFisVdi1UllnS1kz3J+eABtn7FQtI2/nDDt6+ukhMmjSUzE
         hbhYZx1Cb59Aq8Zpt634TJkRimGvvxQkxPpooehcwPsK4yByX8+KH861JN6G9bdVWB4d
         Bi7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+Z88gI7HqU6DoIwoeYnykAbwInRUkwr1vEWjVMbGfxA=;
        b=Nyd2XD9siSF057sCQ9O9nkJwwI3N+VI9uJaFWg5zk1GRFupEQXUK7JPLqhVAd17b7U
         QvIhA4I5QGuZ9FuX8oA5ycqWB93E3rSqJPpx1TQKl1qnvxW0bog0NtXzWbFOvecgzPqK
         PIGQVdTP8yhN0pxVj8XA6q0O4KwQfMeZkJ931mLpmGWk5eQuDf1jL2rljMR44YQaHTir
         Q0WZFMSSrWEGU6MpmE4TFXzXl7j1OnSeY2NBkFDUbhWg3ZzSaZOhuZZHZkXMwZK67pe3
         tEgSKHyzNyL7rAazhAWglwp9iEutWBZccaJxdAQ+ZwfXhV+P4+EKmOVyQa/Sq9RQXESd
         DVng==
X-Gm-Message-State: AOAM530YDCchJGCmKjGAK8/zkofH7LFjfsQrTtp9+hevlTydvTCGIVZ8
        K4utriSpulujZjwDkJApEMOBUKap/s4b3w==
X-Google-Smtp-Source: ABdhPJxFPPkObZ2q98bAVDEedlGusbB7y+f8QJlBIzFsNh3i24We3gwW40Geb+rk+a+9jSwEP5QunQ==
X-Received: by 2002:aca:2211:: with SMTP id b17mr1651677oic.56.1613457776882;
        Mon, 15 Feb 2021 22:42:56 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:1d72:18:7c76:92e4])
        by smtp.gmail.com with ESMTPSA id i23sm4274467oik.10.2021.02.15.22.42.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 22:42:56 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: [Patch bpf-next v4 2/5] skmsg: get rid of struct sk_psock_parser
Date:   Mon, 15 Feb 2021 22:42:47 -0800
Message-Id: <20210216064250.38331-3-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210216064250.38331-1-xiyou.wangcong@gmail.com>
References: <20210216064250.38331-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

struct sk_psock_parser is embedded in sk_psock, it is
unnecessary as skb verdict also uses ->saved_data_ready.
We can simply fold these fields into sk_psock, and get rid
of ->enabled.

Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/skmsg.h | 19 ++++++----------
 net/core/skmsg.c      | 53 +++++++++++++------------------------------
 net/core/sock_map.c   |  8 +++----
 3 files changed, 27 insertions(+), 53 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 041faef00937..e3bb712af257 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -70,14 +70,6 @@ struct sk_psock_link {
 	void				*link_raw;
 };
 
-struct sk_psock_parser {
-#if IS_ENABLED(CONFIG_BPF_STREAM_PARSER)
-	struct strparser		strp;
-#endif
-	bool				enabled;
-	void (*saved_data_ready)(struct sock *sk);
-};
-
 struct sk_psock_work_state {
 	struct sk_buff			*skb;
 	u32				len;
@@ -92,7 +84,9 @@ struct sk_psock {
 	u32				eval;
 	struct sk_msg			*cork;
 	struct sk_psock_progs		progs;
-	struct sk_psock_parser		parser;
+#if IS_ENABLED(CONFIG_BPF_STREAM_PARSER)
+	struct strparser		strp;
+#endif
 	struct sk_buff_head		ingress_skb;
 	struct list_head		ingress_msg;
 	unsigned long			state;
@@ -102,6 +96,7 @@ struct sk_psock {
 	void (*saved_unhash)(struct sock *sk);
 	void (*saved_close)(struct sock *sk, long timeout);
 	void (*saved_write_space)(struct sock *sk);
+	void (*saved_data_ready)(struct sock *sk);
 	struct proto			*sk_proto;
 	struct sk_psock_work_state	work_state;
 	struct work_struct		work;
@@ -422,8 +417,8 @@ static inline void sk_psock_put(struct sock *sk, struct sk_psock *psock)
 
 static inline void sk_psock_data_ready(struct sock *sk, struct sk_psock *psock)
 {
-	if (psock->parser.enabled)
-		psock->parser.saved_data_ready(sk);
+	if (psock->saved_data_ready)
+		psock->saved_data_ready(sk);
 	else
 		sk->sk_data_ready(sk);
 }
@@ -462,6 +457,6 @@ static inline bool sk_psock_strp_enabled(struct sk_psock *psock)
 {
 	if (!psock)
 		return false;
-	return psock->parser.enabled;
+	return !!psock->saved_data_ready;
 }
 #endif /* _LINUX_SKMSG_H */
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 6cb5ff6f8f9c..7f400d044cda 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -905,17 +905,9 @@ static int sk_psock_strp_read_done(struct strparser *strp, int err)
 	return err;
 }
 
-static struct sk_psock *sk_psock_from_strp(struct strparser *strp)
-{
-	struct sk_psock_parser *parser;
-
-	parser = container_of(strp, struct sk_psock_parser, strp);
-	return container_of(parser, struct sk_psock, parser);
-}
-
 static int sk_psock_strp_parse(struct strparser *strp, struct sk_buff *skb)
 {
-	struct sk_psock *psock = sk_psock_from_strp(strp);
+	struct sk_psock *psock = container_of(strp, struct sk_psock, strp);
 	struct bpf_prog *prog;
 	int ret = skb->len;
 
@@ -939,10 +931,10 @@ static void sk_psock_strp_data_ready(struct sock *sk)
 	psock = sk_psock(sk);
 	if (likely(psock)) {
 		if (tls_sw_has_ctx_rx(sk)) {
-			psock->parser.saved_data_ready(sk);
+			psock->saved_data_ready(sk);
 		} else {
 			write_lock_bh(&sk->sk_callback_lock);
-			strp_data_ready(&psock->parser.strp);
+			strp_data_ready(&psock->strp);
 			write_unlock_bh(&sk->sk_callback_lock);
 		}
 	}
@@ -957,41 +949,34 @@ int sk_psock_init_strp(struct sock *sk, struct sk_psock *psock)
 		.parse_msg	= sk_psock_strp_parse,
 	};
 
-	psock->parser.enabled = false;
-	return strp_init(&psock->parser.strp, sk, &cb);
+	return strp_init(&psock->strp, sk, &cb);
 }
 
 void sk_psock_start_strp(struct sock *sk, struct sk_psock *psock)
 {
-	struct sk_psock_parser *parser = &psock->parser;
-
-	if (parser->enabled)
+	if (psock->saved_data_ready)
 		return;
 
-	parser->saved_data_ready = sk->sk_data_ready;
+	psock->saved_data_ready = sk->sk_data_ready;
 	sk->sk_data_ready = sk_psock_strp_data_ready;
 	sk->sk_write_space = sk_psock_write_space;
-	parser->enabled = true;
 }
 
 void sk_psock_stop_strp(struct sock *sk, struct sk_psock *psock)
 {
-	struct sk_psock_parser *parser = &psock->parser;
-
-	if (!parser->enabled)
+	if (!psock->saved_data_ready)
 		return;
 
-	sk->sk_data_ready = parser->saved_data_ready;
-	parser->saved_data_ready = NULL;
-	strp_stop(&parser->strp);
-	parser->enabled = false;
+	sk->sk_data_ready = psock->saved_data_ready;
+	psock->saved_data_ready = NULL;
+	strp_stop(&psock->strp);
 }
 
 void sk_psock_done_strp(struct sk_psock *psock)
 {
 	/* Parser has been stopped */
 	if (psock->progs.skb_parser)
-		strp_done(&psock->parser.strp);
+		strp_done(&psock->strp);
 }
 #endif
 
@@ -1048,25 +1033,19 @@ static void sk_psock_verdict_data_ready(struct sock *sk)
 
 void sk_psock_start_verdict(struct sock *sk, struct sk_psock *psock)
 {
-	struct sk_psock_parser *parser = &psock->parser;
-
-	if (parser->enabled)
+	if (psock->saved_data_ready)
 		return;
 
-	parser->saved_data_ready = sk->sk_data_ready;
+	psock->saved_data_ready = sk->sk_data_ready;
 	sk->sk_data_ready = sk_psock_verdict_data_ready;
 	sk->sk_write_space = sk_psock_write_space;
-	parser->enabled = true;
 }
 
 void sk_psock_stop_verdict(struct sock *sk, struct sk_psock *psock)
 {
-	struct sk_psock_parser *parser = &psock->parser;
-
-	if (!parser->enabled)
+	if (!psock->saved_data_ready)
 		return;
 
-	sk->sk_data_ready = parser->saved_data_ready;
-	parser->saved_data_ready = NULL;
-	parser->enabled = false;
+	sk->sk_data_ready = psock->saved_data_ready;
+	psock->saved_data_ready = NULL;
 }
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index ee3334dd3a38..1a28a5c2c61e 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -148,9 +148,9 @@ static void sock_map_del_link(struct sock *sk,
 			struct bpf_map *map = link->map;
 			struct bpf_stab *stab = container_of(map, struct bpf_stab,
 							     map);
-			if (psock->parser.enabled && stab->progs.skb_parser)
+			if (psock->saved_data_ready && stab->progs.skb_parser)
 				strp_stop = true;
-			if (psock->parser.enabled && stab->progs.skb_verdict)
+			if (psock->saved_data_ready && stab->progs.skb_verdict)
 				verdict_stop = true;
 			list_del(&link->list);
 			sk_psock_free_link(link);
@@ -283,14 +283,14 @@ static int sock_map_link(struct bpf_map *map, struct sk_psock_progs *progs,
 		goto out_drop;
 
 	write_lock_bh(&sk->sk_callback_lock);
-	if (skb_parser && skb_verdict && !psock->parser.enabled) {
+	if (skb_parser && skb_verdict && !psock->saved_data_ready) {
 		ret = sk_psock_init_strp(sk, psock);
 		if (ret)
 			goto out_unlock_drop;
 		psock_set_prog(&psock->progs.skb_verdict, skb_verdict);
 		psock_set_prog(&psock->progs.skb_parser, skb_parser);
 		sk_psock_start_strp(sk, psock);
-	} else if (!skb_parser && skb_verdict && !psock->parser.enabled) {
+	} else if (!skb_parser && skb_verdict && !psock->saved_data_ready) {
 		psock_set_prog(&psock->progs.skb_verdict, skb_verdict);
 		sk_psock_start_verdict(sk,psock);
 	}
-- 
2.25.1

