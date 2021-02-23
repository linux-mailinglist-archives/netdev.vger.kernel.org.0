Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA313230F6
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 19:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233916AbhBWSui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 13:50:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232878AbhBWSu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 13:50:28 -0500
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A671C061786;
        Tue, 23 Feb 2021 10:49:48 -0800 (PST)
Received: by mail-oi1-x233.google.com with SMTP id d20so18664152oiw.10;
        Tue, 23 Feb 2021 10:49:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8xG4MgsWTvMwJ4RIPplsvHskmOfodtsub4T53KxSjlw=;
        b=GnTkppO4VLlD0lrAsfB3LB66rajadw0K+b9MXpyBEgLdPgHqtgU2zp4fX9TPWi9Si3
         1DI/4TKN+vtcVwEkfIZf11pUws1x26ic4T1KQmsPjWHIR8yTYD/1HC3bBr4qcFHSj9IP
         Lem5mHUrRZpD7PGAc1I6WK8uzwJLKbh51BZ2RFfQrlOUbNojRktHu2ByaOZpLYt5Tq18
         aKuOlALEB6Tve0+DbJF/Wdc12BstXBUm8xCV1GPjWGWwmAIazOEOeQfAViTFWvn0wci1
         Xd+21U2KCCHsFebxUW23RB4DmR2+oz21kaWZnMmSMxFn0R+B/3Mqam+GIKmQTi6xCGUQ
         i8yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8xG4MgsWTvMwJ4RIPplsvHskmOfodtsub4T53KxSjlw=;
        b=KBOWNsLWYHdzwN+9gFCn0wpv2UU0+tHtzwzk/hsIJ7c2SNX0s6FCdRFXEcK8wQujse
         DOItfqeY7Si76jXn1O124Y6A8GjxxEmEP/gM70v1A178oeqLNU0Nas88c9AGcqIwDNFW
         ortMLGJZr281w8gC+q5+VH3N9vK1IMCeYmRH3bY17XmdU+64a2jTpFVA3guhNoScMdtI
         xV8/GEIs6Rk1kBr2pl9rYFyhBu2sC9wXM7sWTSlJ1+mBjqGpihuhjNH+xVUXPf2JwDJK
         5MMxwbP9qBRHAdDgDyRlnOdaxFdnxrEFNbptVkExD8OPm7qQ5uri6qfjmdAy+TPmHgCk
         OAHA==
X-Gm-Message-State: AOAM530O/hnJfZJflZ+RICb9+woGszy8wsB+4uQF443J9WzARofPG5hT
        /IQh5pqr/pCDQ+jKaFLaxbFXU8OaMgqqHg==
X-Google-Smtp-Source: ABdhPJzbH9ZJN6RlgVuf0ZKT95Fbge9qkVgSnM6subVE/wOqz01Lh7MvGHIFQtuIguGKaAQzXicacg==
X-Received: by 2002:aca:b506:: with SMTP id e6mr152862oif.6.1614106187537;
        Tue, 23 Feb 2021 10:49:47 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:4543:ab2:3bf6:ce41])
        by smtp.gmail.com with ESMTPSA id p12sm4387094oon.12.2021.02.23.10.49.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 10:49:47 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: [Patch bpf-next v7 2/9] skmsg: get rid of struct sk_psock_parser
Date:   Tue, 23 Feb 2021 10:49:27 -0800
Message-Id: <20210223184934.6054-3-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210223184934.6054-1-xiyou.wangcong@gmail.com>
References: <20210223184934.6054-1-xiyou.wangcong@gmail.com>
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
index db7a08be4725..22e26f82de33 100644
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
@@ -418,8 +413,8 @@ static inline void sk_psock_put(struct sock *sk, struct sk_psock *psock)
 
 static inline void sk_psock_data_ready(struct sock *sk, struct sk_psock *psock)
 {
-	if (psock->parser.enabled)
-		psock->parser.saved_data_ready(sk);
+	if (psock->saved_data_ready)
+		psock->saved_data_ready(sk);
 	else
 		sk->sk_data_ready(sk);
 }
@@ -458,6 +453,6 @@ static inline bool sk_psock_strp_enabled(struct sk_psock *psock)
 {
 	if (!psock)
 		return false;
-	return psock->parser.enabled;
+	return !!psock->saved_data_ready;
 }
 #endif /* _LINUX_SKMSG_H */
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index e017744111e1..d00c9a4b47e7 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -907,17 +907,9 @@ static int sk_psock_strp_read_done(struct strparser *strp, int err)
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
 
@@ -941,10 +933,10 @@ static void sk_psock_strp_data_ready(struct sock *sk)
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
@@ -959,41 +951,34 @@ int sk_psock_init_strp(struct sock *sk, struct sk_psock *psock)
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
 
 static void sk_psock_done_strp(struct sk_psock *psock)
 {
 	/* Parser has been stopped */
 	if (psock->progs.skb_parser)
-		strp_done(&psock->parser.strp);
+		strp_done(&psock->strp);
 }
 #else
 static void sk_psock_done_strp(struct sk_psock *psock)
@@ -1054,25 +1039,19 @@ static void sk_psock_verdict_data_ready(struct sock *sk)
 
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

