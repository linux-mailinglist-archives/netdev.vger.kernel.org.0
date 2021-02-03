Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72CDA30D273
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 05:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232719AbhBCESL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 23:18:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232617AbhBCERj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 23:17:39 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B421C0613D6;
        Tue,  2 Feb 2021 20:16:57 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id k25so25379504oik.13;
        Tue, 02 Feb 2021 20:16:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QuxR8jr/6XGuWWyDoFOLUavtPH9v/4WH/NrMUIXz4tg=;
        b=qAJiezNkwFImSrEXjXp0t6oE/jNVXwJpuOhP1PR+nc7jEH1F8bE0diKR3zefu2bLPg
         pqMnHn5X0fuzuPcozi5Gu4WAKn2wRb04xy+5vDrnDR0pLN3ycF4hlxl0Z4BkPXWHcvU0
         XenXvmin+EkNHkDJrIhJtzTiOeWFolEa6GJr9D/c+MaHlhQcwi8T0FHwefiLOeYEUSd/
         hiVm2Ezurbwguhh0+UrQy00+VlRuGdbAbSt04knahUAXY/r/kKcz1P8mOk9b4siWlceJ
         KUyjDmAIwjEJc8cruALC3cuYGaqnExm5ENFrnn1k8IEiGP44jw4QKhIdJgfM8LlUMhpz
         7ezg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QuxR8jr/6XGuWWyDoFOLUavtPH9v/4WH/NrMUIXz4tg=;
        b=rfMfGKGt+NZhherPPoCDYecBVn1G0OqG/JsfOs3DYoyDz3PWIrJIERDo45PNLJ3lPz
         4yZYc5yF5Yf6pziO5EiezQksT9qoxtLUD7b+bEqUXQbqEwGJlR0YT+VcsXfLFzojOac8
         Yl4bhMIeDAjU+7+Uh9fdNTVSpapPpUEMLIkLFBmXVpBKWSnv9JU01p7ecVLiGoLV1wpz
         JDqN+45fjRiTo1ChntH4ZUc/T0pq4c0/Xv0w9PJao5Xd3UIvY0Q1x358TFkL7uXdhBEL
         PqpWToQ8DvXp9rk7Dw10uXbPwVGUFOLgnq/grn1GCy0Xm10vtQ6EEXroSnEm87U5MHDv
         JD6Q==
X-Gm-Message-State: AOAM533kRWygwf63urpiBdkbHxDdIJPSRH82TZFqdsn/wuvPy6iul7rZ
        d7CTKabeucbMZTUxIbJnHkn/Lx/qkxYbLQ==
X-Google-Smtp-Source: ABdhPJxDx+LvVm517EZ0sNCGHpBIi12aiMRdUHVTukP9EfFGymF+SMcr0fsHmF9y6S95cYEQuEAkAQ==
X-Received: by 2002:aca:508f:: with SMTP id e137mr781235oib.32.1612325816659;
        Tue, 02 Feb 2021 20:16:56 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:90c4:ffea:6079:8a0c])
        by smtp.gmail.com with ESMTPSA id s10sm209978ool.35.2021.02.02.20.16.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 20:16:56 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next 02/19] skmsg: get rid of struct sk_psock_parser
Date:   Tue,  2 Feb 2021 20:16:19 -0800
Message-Id: <20210203041636.38555-3-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203041636.38555-1-xiyou.wangcong@gmail.com>
References: <20210203041636.38555-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

struct sk_psock_parser is embedded in sk_psock, it is
unnecessary as skb verdict also uses ->saved_data_ready.
We can simply fold these fields into sk_psock.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/skmsg.h | 16 +++++-------
 net/core/skmsg.c      | 58 ++++++++++++++++---------------------------
 net/core/sock_map.c   |  8 +++---
 3 files changed, 31 insertions(+), 51 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 8edbbf5f2f93..56d641df3b0c 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -70,12 +70,6 @@ struct sk_psock_link {
 	void				*link_raw;
 };
 
-struct sk_psock_parser {
-	struct strparser		strp;
-	bool				enabled;
-	void (*saved_data_ready)(struct sock *sk);
-};
-
 struct sk_psock_work_state {
 	struct sk_buff			*skb;
 	u32				len;
@@ -90,7 +84,8 @@ struct sk_psock {
 	u32				eval;
 	struct sk_msg			*cork;
 	struct sk_psock_progs		progs;
-	struct sk_psock_parser		parser;
+	struct strparser		strp;
+	bool				bpf_running;
 	struct sk_buff_head		ingress_skb;
 	struct list_head		ingress_msg;
 	unsigned long			state;
@@ -100,6 +95,7 @@ struct sk_psock {
 	void (*saved_unhash)(struct sock *sk);
 	void (*saved_close)(struct sock *sk, long timeout);
 	void (*saved_write_space)(struct sock *sk);
+	void (*saved_data_ready)(struct sock *sk);
 	struct proto			*sk_proto;
 	struct sk_psock_work_state	work_state;
 	struct work_struct		work;
@@ -400,8 +396,8 @@ static inline void sk_psock_put(struct sock *sk, struct sk_psock *psock)
 
 static inline void sk_psock_data_ready(struct sock *sk, struct sk_psock *psock)
 {
-	if (psock->parser.enabled)
-		psock->parser.saved_data_ready(sk);
+	if (psock->bpf_running)
+		psock->saved_data_ready(sk);
 	else
 		sk->sk_data_ready(sk);
 }
@@ -440,6 +436,6 @@ static inline bool sk_psock_strp_enabled(struct sk_psock *psock)
 {
 	if (!psock)
 		return false;
-	return psock->parser.enabled;
+	return psock->bpf_running;
 }
 #endif /* _LINUX_SKMSG_H */
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 1261512d6807..f72fcb03d25c 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -653,7 +653,7 @@ static void sk_psock_destroy_deferred(struct work_struct *gc)
 
 	/* Parser has been stopped */
 	if (psock->progs.skb_parser)
-		strp_done(&psock->parser.strp);
+		strp_done(&psock->strp);
 
 	cancel_work_sync(&psock->work);
 
@@ -750,14 +750,6 @@ static int sk_psock_bpf_run(struct sk_psock *psock, struct bpf_prog *prog,
 	return bpf_prog_run_pin_on_cpu(prog, skb);
 }
 
-static struct sk_psock *sk_psock_from_strp(struct strparser *strp)
-{
-	struct sk_psock_parser *parser;
-
-	parser = container_of(strp, struct sk_psock_parser, strp);
-	return container_of(parser, struct sk_psock, parser);
-}
-
 static void sk_psock_skb_redirect(struct sk_buff *skb)
 {
 	struct sk_psock *psock_other;
@@ -899,7 +891,7 @@ static int sk_psock_strp_read_done(struct strparser *strp, int err)
 
 static int sk_psock_strp_parse(struct strparser *strp, struct sk_buff *skb)
 {
-	struct sk_psock *psock = sk_psock_from_strp(strp);
+	struct sk_psock *psock = container_of(strp, struct sk_psock, strp);
 	struct bpf_prog *prog;
 	int ret = skb->len;
 
@@ -923,10 +915,10 @@ static void sk_psock_strp_data_ready(struct sock *sk)
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
@@ -1009,57 +1001,49 @@ int sk_psock_init_strp(struct sock *sk, struct sk_psock *psock)
 		.parse_msg	= sk_psock_strp_parse,
 	};
 
-	psock->parser.enabled = false;
-	return strp_init(&psock->parser.strp, sk, &cb);
+	psock->bpf_running = false;
+	return strp_init(&psock->strp, sk, &cb);
 }
 
 void sk_psock_start_verdict(struct sock *sk, struct sk_psock *psock)
 {
-	struct sk_psock_parser *parser = &psock->parser;
-
-	if (parser->enabled)
+	if (psock->bpf_running)
 		return;
 
-	parser->saved_data_ready = sk->sk_data_ready;
+	psock->saved_data_ready = sk->sk_data_ready;
 	sk->sk_data_ready = sk_psock_verdict_data_ready;
 	sk->sk_write_space = sk_psock_write_space;
-	parser->enabled = true;
+	psock->bpf_running = true;
 }
 
 void sk_psock_start_strp(struct sock *sk, struct sk_psock *psock)
 {
-	struct sk_psock_parser *parser = &psock->parser;
-
-	if (parser->enabled)
+	if (psock->bpf_running)
 		return;
 
-	parser->saved_data_ready = sk->sk_data_ready;
+	psock->saved_data_ready = sk->sk_data_ready;
 	sk->sk_data_ready = sk_psock_strp_data_ready;
 	sk->sk_write_space = sk_psock_write_space;
-	parser->enabled = true;
+	psock->bpf_running = true;
 }
 
 void sk_psock_stop_strp(struct sock *sk, struct sk_psock *psock)
 {
-	struct sk_psock_parser *parser = &psock->parser;
-
-	if (!parser->enabled)
+	if (!psock->bpf_running)
 		return;
 
-	sk->sk_data_ready = parser->saved_data_ready;
-	parser->saved_data_ready = NULL;
-	strp_stop(&parser->strp);
-	parser->enabled = false;
+	sk->sk_data_ready = psock->saved_data_ready;
+	psock->saved_data_ready = NULL;
+	strp_stop(&psock->strp);
+	psock->bpf_running = false;
 }
 
 void sk_psock_stop_verdict(struct sock *sk, struct sk_psock *psock)
 {
-	struct sk_psock_parser *parser = &psock->parser;
-
-	if (!parser->enabled)
+	if (!psock->bpf_running)
 		return;
 
-	sk->sk_data_ready = parser->saved_data_ready;
-	parser->saved_data_ready = NULL;
-	parser->enabled = false;
+	sk->sk_data_ready = psock->saved_data_ready;
+	psock->saved_data_ready = NULL;
+	psock->bpf_running = false;
 }
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index d758fb83c884..37ff8e13e4cc 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -148,9 +148,9 @@ static void sock_map_del_link(struct sock *sk,
 			struct bpf_map *map = link->map;
 			struct bpf_stab *stab = container_of(map, struct bpf_stab,
 							     map);
-			if (psock->parser.enabled && stab->progs.skb_parser)
+			if (psock->bpf_running && stab->progs.skb_parser)
 				strp_stop = true;
-			if (psock->parser.enabled && stab->progs.skb_verdict)
+			if (psock->bpf_running && stab->progs.skb_verdict)
 				verdict_stop = true;
 			list_del(&link->list);
 			sk_psock_free_link(link);
@@ -283,14 +283,14 @@ static int sock_map_link(struct bpf_map *map, struct sk_psock_progs *progs,
 		goto out_drop;
 
 	write_lock_bh(&sk->sk_callback_lock);
-	if (skb_parser && skb_verdict && !psock->parser.enabled) {
+	if (skb_parser && skb_verdict && !psock->bpf_running) {
 		ret = sk_psock_init_strp(sk, psock);
 		if (ret)
 			goto out_unlock_drop;
 		psock_set_prog(&psock->progs.skb_verdict, skb_verdict);
 		psock_set_prog(&psock->progs.skb_parser, skb_parser);
 		sk_psock_start_strp(sk, psock);
-	} else if (!skb_parser && skb_verdict && !psock->parser.enabled) {
+	} else if (!skb_parser && skb_verdict && !psock->bpf_running) {
 		psock_set_prog(&psock->progs.skb_verdict, skb_verdict);
 		sk_psock_start_verdict(sk,psock);
 	}
-- 
2.25.1

