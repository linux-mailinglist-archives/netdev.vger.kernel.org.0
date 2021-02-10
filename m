Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C918315D37
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 03:26:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233848AbhBJC0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 21:26:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235328AbhBJCWp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 21:22:45 -0500
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D66C061756;
        Tue,  9 Feb 2021 18:21:59 -0800 (PST)
Received: by mail-oi1-x233.google.com with SMTP id u66so395761oig.9;
        Tue, 09 Feb 2021 18:21:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eHzF9nf+54Y2o3p5909cXp2ZamsqstuvA/03O3dQ8zA=;
        b=pQ+c6BEQJI+hjovDpAZNcvhseS/Rs3qXRvXkLtpSrpueT1XkGCTUzo8Hx60tL07j/P
         9XrS2CLELKLwyc2QDa0GeVkRA59h+llKX3ZoAbWVTjnxZbmPLCfd20jKUeJS4Q3p0DsJ
         Nxrsh04BIo3vR1z0Yz/lmxi6uOcqbrYJ3UzGWrSXoHJhA2A5118E98/pI7+Xc1uadyKI
         IVetoCHdr7+AzeOH8ErqPPsFnY51Judg+ZFzS5Owem5NFnTx6GGM0ZHotgdrryGuw/E+
         vIRFKKPr4ReGuPhB9ohgYRoUCb6Y6TD5l/DNZ7Z/L28D3jxbxjoMKzmz2qrVzIt8iWzl
         akAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eHzF9nf+54Y2o3p5909cXp2ZamsqstuvA/03O3dQ8zA=;
        b=FEkz97m5khz2IJNr+2m6jEuFu/UcLDHH4JB39pZTpKoFDDjHFE/NMnJe8wbOAQjtAp
         I3NVS1KAiO3sALvMYlsqqNn5aNBJD6yVd78SBV6AsRzvQGmxnwEtCi2HsqtVQ0hEsTfG
         kQz1HpV7iqLMmh4Fy+AvLbhlCU9ofmAAn1DB28zCpK/TWMkM9AJlHV7MWQf5MWkoaOgx
         Xslhr+xjfHbuuxo7HRYWbHSa4uMc5tt0hnRrKj5BjCI0amaAl7HBO0yVvqh3MoMQxtzI
         Izu2Otb5UWqdZxMOujnLlCvj8voaC5eLjLxHK/Ikfqy8SuWPcSwNZ5tgql0amJ5RA41y
         qeaw==
X-Gm-Message-State: AOAM5326DKFzVNtzE3K8eskNhgbtP3I8oqrpkvablPQY0Pyd3o3Wv5Yk
        /3Sj7JyxSPRU+TMYgKm8FtvVQ8Zl9t0Uvg==
X-Google-Smtp-Source: ABdhPJyorksRq4hzytNByOF74vPH/tZir9LPIteqZ3yO49zSnMyiCYL2FMEDtjf0w/UEvFCNguYs2g==
X-Received: by 2002:aca:5a57:: with SMTP id o84mr594004oib.0.1612923718348;
        Tue, 09 Feb 2021 18:21:58 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:58b0:eb39:33aa:5355])
        by smtp.gmail.com with ESMTPSA id z20sm101051oth.55.2021.02.09.18.21.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 18:21:58 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v2 2/5] skmsg: get rid of struct sk_psock_parser
Date:   Tue,  9 Feb 2021 18:21:33 -0800
Message-Id: <20210210022136.146528-3-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210210022136.146528-1-xiyou.wangcong@gmail.com>
References: <20210210022136.146528-1-xiyou.wangcong@gmail.com>
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

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/skmsg.h | 15 ++++--------
 net/core/skmsg.c      | 53 +++++++++++++------------------------------
 net/core/sock_map.c   |  8 +++----
 3 files changed, 25 insertions(+), 51 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index f0e72dca9bfd..76eba574ce56 100644
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
@@ -90,7 +84,7 @@ struct sk_psock {
 	u32				eval;
 	struct sk_msg			*cork;
 	struct sk_psock_progs		progs;
-	struct sk_psock_parser		parser;
+	struct strparser		strp;
 	struct sk_buff_head		ingress_skb;
 	struct list_head		ingress_msg;
 	unsigned long			state;
@@ -100,6 +94,7 @@ struct sk_psock {
 	void (*saved_unhash)(struct sock *sk);
 	void (*saved_close)(struct sock *sk, long timeout);
 	void (*saved_write_space)(struct sock *sk);
+	void (*saved_data_ready)(struct sock *sk);
 	struct proto			*sk_proto;
 	struct sk_psock_work_state	work_state;
 	struct work_struct		work;
@@ -415,8 +410,8 @@ static inline void sk_psock_put(struct sock *sk, struct sk_psock *psock)
 
 static inline void sk_psock_data_ready(struct sock *sk, struct sk_psock *psock)
 {
-	if (psock->parser.enabled)
-		psock->parser.saved_data_ready(sk);
+	if (psock->saved_data_ready)
+		psock->saved_data_ready(sk);
 	else
 		sk->sk_data_ready(sk);
 }
@@ -455,6 +450,6 @@ static inline bool sk_psock_strp_enabled(struct sk_psock *psock)
 {
 	if (!psock)
 		return false;
-	return psock->parser.enabled;
+	return !!psock->saved_data_ready;
 }
 #endif /* _LINUX_SKMSG_H */
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 47c8891bb5b4..9d673179e886 100644
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
@@ -917,7 +909,7 @@ static int sk_psock_strp_read_done(struct strparser *strp, int err)
 
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
@@ -959,34 +951,27 @@ int sk_psock_init_strp(struct sock *sk, struct sk_psock *psock)
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
 #endif
 
@@ -1043,25 +1028,19 @@ static void sk_psock_verdict_data_ready(struct sock *sk)
 
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

