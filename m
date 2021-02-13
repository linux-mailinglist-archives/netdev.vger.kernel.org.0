Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A353431AE32
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 22:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbhBMVpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 16:45:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbhBMVpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 16:45:11 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AE95C0613D6;
        Sat, 13 Feb 2021 13:44:30 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id l3so3798697oii.2;
        Sat, 13 Feb 2021 13:44:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cjC+l+AJQHUWW/EAS364A1dTQ0qpBiKc+8ozpv4zl6U=;
        b=YjpZzfR3gv6uGQVO3bfigorGpVAxpiKL+EYbmvEO1WorCSGEC5f0GOnRIcXllpVmKl
         26XocbX1joo7loGVfI60TULXLDBpGdZW/te85TLd+y4lKdxI+PzAFezefLwZvOOWy1vN
         3PPn9lGFngcAVP6rINLDPo0EXVNWBEx20GQw7+BjobyyfWuVAKJSr52ZuggnX+63tlON
         Jo7To6rKJIJiDcrJhja/KrMz3L/tsVm7P2aSMQbaz24ZcLSxJ/zHAeMM2LWeE3mzhl0t
         hxvGpo41cXcYG2F+fVGCo74hYjtH+daG0cZeCI9F2WUaMNl9CShjUqTUVSnaGL2XfD2O
         8q4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cjC+l+AJQHUWW/EAS364A1dTQ0qpBiKc+8ozpv4zl6U=;
        b=SWUIUtlWpmJyzzeUNei94jRW2JOCmrqUCqvBIh8e6Cpkg2PWVmM6jpgEPReP+j55br
         JPtA9cUOfDFR8TEv9VbaHfmaiP/ut7sBX9YpwSSGfi4+JtUnquK1PTWayaWPTmtX4War
         h9U2Re3gvTN5wvxoRk7xz1S4R8yT5Uw561l0tc8M9vH9+jYS0HJofewBKzxbzO1dM8MP
         uclpddKFXCiEeZIEvp2vpK3RwpEC0JESXvn20WYGQmj9Cewlvc0pnwR3DlDHjOe34Cjs
         aUx9/JRkoFPOCO7Y+dfYeAzKCH79nabBbxgAOVwXP4yqe/B7XtH3g63vS00oeIvruWfC
         utlw==
X-Gm-Message-State: AOAM533tnSypFKTa+sQPz4KDLGaTFysVngxI9+8tgF72hRgPcGaB5q0x
        9PwMx574Mi46Nel30LzXdKFN9WR35oYayw==
X-Google-Smtp-Source: ABdhPJxSWBkHhAiQ4aiIvIw+f+TOtjsf6nlY9UTMytO8i1W1tnFLROr1m255yIe4tqWPnzUV4LpVNA==
X-Received: by 2002:aca:6509:: with SMTP id m9mr3797749oim.35.1613252669679;
        Sat, 13 Feb 2021 13:44:29 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:108:c15a:7f7a:df71])
        by smtp.gmail.com with ESMTPSA id c17sm2509674otp.58.2021.02.13.13.44.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Feb 2021 13:44:29 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v3 2/5] skmsg: get rid of struct sk_psock_parser
Date:   Sat, 13 Feb 2021 13:44:18 -0800
Message-Id: <20210213214421.226357-3-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210213214421.226357-1-xiyou.wangcong@gmail.com>
References: <20210213214421.226357-1-xiyou.wangcong@gmail.com>
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

