Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 022B5197D8
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 06:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbfEJE6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 00:58:04 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:34585 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbfEJE6E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 00:58:04 -0400
Received: by mail-io1-f68.google.com with SMTP id g84so3524246ioa.1;
        Thu, 09 May 2019 21:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=QYg3O7B5j9G/wSXFMEqOrz07+vdo9sxrbnMwwPXf7H4=;
        b=jxtt02WGHPRWXTHxhwyB0VeKrlxMVU5sOiEY/p3qNX35SD8UDg7dY08aOPxkqYU5XW
         pHGop7dmY3zfRYxs7IJ1ivZvCVOcsEBOq0LCDzoN6ItGS0FOAyFNJEsO5wRLnsB/fzpO
         IcIGOCmB98t8ve6shYMN/3Ou1osjl5Vp/+uEuQsBp3f8vzq0Tq1urx2lnc5EKy5WRrDS
         rZjHpB4m2Hh53SMxmONqX3cn/fS15U3tlj7hiq4gqLk/oLEwfMHV8Xu0tdfMACYUcbcZ
         QMSmobpOuF2P9AEkpgnH694af5B+wdEJp6aZU0not4i4C15Ej8MeJKDE0mk8qlTpZapn
         /3bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=QYg3O7B5j9G/wSXFMEqOrz07+vdo9sxrbnMwwPXf7H4=;
        b=FGkZBc4JwogqLpnxoKa6/B6dkmGemQ8zCYR7niGDgMTWB4CrhlLXzET0WloWzHNIf8
         rBjLLMOLoCrOcP95ki35uYKv+6A0bOSups+pQ2wnEams2tUNI4DRphUlL9eOhiJsgBie
         w9uKhp+eHEKhwlkQlZioL3YpYiPPSAiLtaqk+5EvUpOIi2RB+VSiYlVz1KQ1Afi0NiXy
         j+/AoOCp5p9v01XJOZXMkxDFCuKrt2wrl3ilJNJ37ZnVfn9vvU29cbsvjB9oCQW5WgKa
         AGl4ivB/ohU+UZFEtsAekv7VXZ5AMe/KwpVOFcqyQW+WTtcr2SPNW0fTAzj9/AYVC7xN
         8iww==
X-Gm-Message-State: APjAAAVIb/uPGImR3ub+OBYHTbwORtZr69Z8xws0X/YA1lV23jvTZg0+
        F8kde+wBObiROEpSfE2bF98=
X-Google-Smtp-Source: APXvYqxLRjKZdxymf7WJoXvL8gVjX7fcIZHT/kQ8P1e7xFJ1g0vvSU8hvmYhpDTZgoXDzgMGEmgDYQ==
X-Received: by 2002:a6b:7714:: with SMTP id n20mr5008079iom.89.1557464282144;
        Thu, 09 May 2019 21:58:02 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id w132sm2051364itb.30.2019.05.09.21.57.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 21:58:01 -0700 (PDT)
Subject: [bpf PATCH v4 1/4] bpf: tls,
 implement unhash to avoid transition out of ESTABLISHED
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub.kicinski@netronome.com, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Thu, 09 May 2019 21:57:49 -0700
Message-ID: <155746426913.20677.2783358822817593806.stgit@john-XPS-13-9360>
In-Reply-To: <155746412544.20677.8888193135689886027.stgit@john-XPS-13-9360>
References: <155746412544.20677.8888193135689886027.stgit@john-XPS-13-9360>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is possible (via shutdown()) for TCP socks to go through TCP_CLOSE
state via tcp_disconnect() without calling into close callback. This
would allow a kTLS enabled socket to exist outside of ESTABLISHED
state which is not supported.

Solve this the same way we solved the sock{map|hash} case by adding
an unhash hook to remove tear down the TLS state.

In the process we also make the close hook more robust. We add a put
call into the close path, also in the unhash path, to remove the
reference to ulp data after free. Its no longer valid and may confuse
things later if the socket (re)enters kTLS code paths. Second we add
an 'if(ctx)' check to ensure the ctx is still valid and not released
from a previous unhash/close path.

Fixes: d91c3e17f75f2 ("net/tls: Only attach to sockets in ESTABLISHED state")
Reported-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 include/net/tls.h    |   28 +++++++---
 net/tls/tls_device.c |   10 ++--
 net/tls/tls_main.c   |   82 ++++++++++++++++++++---------
 net/tls/tls_sw.c     |  140 +++++++++++++++++++++++++++++---------------------
 4 files changed, 161 insertions(+), 99 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index 5934246b2c6f..05d8cd5a3297 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -250,11 +250,14 @@ struct tls_context {
 	bool in_tcp_sendpages;
 	bool pending_open_record_frags;
 
-	int (*push_pending_record)(struct sock *sk, int flags);
+	int (*push_pending_record)(struct sock *sk,
+				   struct tls_context *ctx, int flags);
 
 	void (*sk_write_space)(struct sock *sk);
 	void (*sk_destruct)(struct sock *sk);
 	void (*sk_proto_close)(struct sock *sk, long timeout);
+	void (*sk_proto_unhash)(struct sock *sk);
+	struct proto *sk_proto;
 
 	int  (*setsockopt)(struct sock *sk, int level,
 			   int optname, char __user *optval,
@@ -292,9 +295,10 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size);
 int tls_sw_sendpage(struct sock *sk, struct page *page,
 		    int offset, size_t size, int flags);
 void tls_sw_close(struct sock *sk, long timeout);
-void tls_sw_free_resources_tx(struct sock *sk);
-void tls_sw_free_resources_rx(struct sock *sk);
-void tls_sw_release_resources_rx(struct sock *sk);
+void tls_sw_free_resources_tx(struct sock *sk,
+			      struct tls_context *ctx, bool locked);
+void tls_sw_free_resources_rx(struct sock *sk, struct tls_context *ctx);
+void tls_sw_release_resources_rx(struct sock *sk, struct tls_context *ctx);
 int tls_sw_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		   int nonblock, int flags, int *addr_len);
 bool tls_sw_stream_read(const struct sock *sk);
@@ -310,7 +314,7 @@ void tls_device_sk_destruct(struct sock *sk);
 void tls_device_free_resources_tx(struct sock *sk);
 void tls_device_init(void);
 void tls_device_cleanup(void);
-int tls_tx_records(struct sock *sk, int flags);
+int tls_tx_records(struct sock *sk, struct tls_context *ctx, int flags);
 
 struct tls_record_info *tls_get_record(struct tls_offload_context_tx *context,
 				       u32 seq, u64 *p_record_sn);
@@ -416,12 +420,10 @@ static inline struct tls_context *tls_get_ctx(const struct sock *sk)
 }
 
 static inline void tls_advance_record_sn(struct sock *sk,
+					 struct tls_prot_info *prot,
 					 struct cipher_context *ctx,
 					 int version)
 {
-	struct tls_context *tls_ctx = tls_get_ctx(sk);
-	struct tls_prot_info *prot = &tls_ctx->prot_info;
-
 	if (tls_bigint_increment(ctx->rec_seq, prot->rec_seq_size))
 		tls_err_abort(sk, EBADMSG);
 
@@ -493,6 +495,16 @@ static inline void xor_iv_with_seq(int version, char *iv, char *seq)
 	}
 }
 
+static inline void tls_put_ctx(struct sock *sk)
+{
+	struct inet_connection_sock *icsk = inet_csk(sk);
+	struct tls_context *ctx = icsk->icsk_ulp_data;
+
+	if (!ctx)
+		return;
+	sk->sk_prot = ctx->sk_proto;
+	icsk->icsk_ulp_data = NULL;
+}
 
 static inline struct tls_sw_context_rx *tls_sw_ctx_rx(
 		const struct tls_context *tls_ctx)
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 14dedb24fa7b..d3cd887f0488 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -281,7 +281,8 @@ static int tls_push_record(struct sock *sk,
 	list_add_tail(&record->list, &offload_ctx->records_list);
 	spin_unlock_irq(&offload_ctx->lock);
 	offload_ctx->open_record = NULL;
-	tls_advance_record_sn(sk, &ctx->tx, ctx->crypto_send.info.version);
+	tls_advance_record_sn(sk, prot, &ctx->tx,
+			      ctx->crypto_send.info.version);
 
 	for (i = 0; i < record->num_frags; i++) {
 		frag = &record->frags[i];
@@ -548,7 +549,8 @@ struct tls_record_info *tls_get_record(struct tls_offload_context_tx *context,
 }
 EXPORT_SYMBOL(tls_get_record);
 
-static int tls_device_push_pending_record(struct sock *sk, int flags)
+static int tls_device_push_pending_record(struct sock *sk,
+					  struct tls_context *ctx, int flags)
 {
 	struct iov_iter	msg_iter;
 
@@ -922,7 +924,7 @@ int tls_set_device_offload_rx(struct sock *sk, struct tls_context *ctx)
 
 free_sw_resources:
 	up_read(&device_offload_lock);
-	tls_sw_free_resources_rx(sk);
+	tls_sw_free_resources_rx(sk, ctx);
 	down_read(&device_offload_lock);
 release_ctx:
 	ctx->priv_ctx_rx = NULL;
@@ -958,7 +960,7 @@ void tls_device_offload_cleanup_rx(struct sock *sk)
 	}
 out:
 	up_read(&device_offload_lock);
-	tls_sw_release_resources_rx(sk);
+	tls_sw_release_resources_rx(sk, tls_ctx);
 }
 
 static int tls_device_down(struct net_device *netdev)
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 478603f43964..7f7982361128 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -150,12 +150,11 @@ int tls_push_sg(struct sock *sk,
 	return 0;
 }
 
-static int tls_handle_open_record(struct sock *sk, int flags)
+static int tls_handle_open_record(struct sock *sk,
+				  struct tls_context *ctx, int flags)
 {
-	struct tls_context *ctx = tls_get_ctx(sk);
-
 	if (tls_is_pending_open_record(ctx))
-		return ctx->push_pending_record(sk, flags);
+		return ctx->push_pending_record(sk, ctx, flags);
 
 	return 0;
 }
@@ -163,6 +162,7 @@ static int tls_handle_open_record(struct sock *sk, int flags)
 int tls_proccess_cmsg(struct sock *sk, struct msghdr *msg,
 		      unsigned char *record_type)
 {
+	struct tls_context *ctx;
 	struct cmsghdr *cmsg;
 	int rc = -EINVAL;
 
@@ -180,7 +180,11 @@ int tls_proccess_cmsg(struct sock *sk, struct msghdr *msg,
 			if (msg->msg_flags & MSG_MORE)
 				return -EINVAL;
 
-			rc = tls_handle_open_record(sk, msg->msg_flags);
+			ctx = tls_get_ctx(sk);
+			if (unlikely(!ctx))
+				return -EBUSY;
+
+			rc = tls_handle_open_record(sk, ctx, msg->msg_flags);
 			if (rc)
 				return rc;
 
@@ -261,32 +265,28 @@ static void tls_ctx_free(struct tls_context *ctx)
 	kfree(ctx);
 }
 
-static void tls_sk_proto_close(struct sock *sk, long timeout)
+static bool tls_sk_proto_destroy(struct sock *sk,
+				 struct tls_context *ctx, bool locked)
 {
-	struct tls_context *ctx = tls_get_ctx(sk);
 	long timeo = sock_sndtimeo(sk, 0);
-	void (*sk_proto_close)(struct sock *sk, long timeout);
-	bool free_ctx = false;
-
-	lock_sock(sk);
-	sk_proto_close = ctx->sk_proto_close;
 
 	if (ctx->tx_conf == TLS_HW_RECORD && ctx->rx_conf == TLS_HW_RECORD)
-		goto skip_tx_cleanup;
+		return false;
 
-	if (ctx->tx_conf == TLS_BASE && ctx->rx_conf == TLS_BASE) {
-		free_ctx = true;
-		goto skip_tx_cleanup;
-	}
+	if (ctx->tx_conf == TLS_SW && ctx->rx_conf == TLS_SW)
+		tls_put_ctx(sk);
+
+	if (ctx->tx_conf == TLS_BASE && ctx->rx_conf == TLS_BASE)
+		return true;
 
 	if (!tls_complete_pending_work(sk, ctx, 0, &timeo))
-		tls_handle_open_record(sk, 0);
+		tls_handle_open_record(sk, ctx, 0);
 
 	/* We need these for tls_sw_fallback handling of other packets */
 	if (ctx->tx_conf == TLS_SW) {
 		kfree(ctx->tx.rec_seq);
 		kfree(ctx->tx.iv);
-		tls_sw_free_resources_tx(sk);
+		tls_sw_free_resources_tx(sk, ctx, locked);
 #ifdef CONFIG_TLS_DEVICE
 	} else if (ctx->tx_conf == TLS_HW) {
 		tls_device_free_resources_tx(sk);
@@ -294,21 +294,46 @@ static void tls_sk_proto_close(struct sock *sk, long timeout)
 	}
 
 	if (ctx->rx_conf == TLS_SW)
-		tls_sw_free_resources_rx(sk);
+		tls_sw_free_resources_rx(sk, ctx);
 
 #ifdef CONFIG_TLS_DEVICE
 	if (ctx->rx_conf == TLS_HW)
 		tls_device_offload_cleanup_rx(sk);
-
-	if (ctx->tx_conf != TLS_HW && ctx->rx_conf != TLS_HW) {
-#else
-	{
 #endif
+
+	if (ctx->tx_conf != TLS_HW && ctx->rx_conf != TLS_HW)
+		return true;
+	return false;
+}
+
+static void tls_sk_proto_unhash(struct sock *sk)
+{
+	struct tls_context *ctx = tls_get_ctx(sk);
+	void (*sk_proto_unhash)(struct sock *sk);
+	bool free_ctx;
+
+	if (!ctx)
+		return sk->sk_prot->unhash(sk);
+	sk_proto_unhash = ctx->sk_proto_unhash;
+	free_ctx = tls_sk_proto_destroy(sk, ctx, false);
+	if (sk_proto_unhash)
+		sk_proto_unhash(sk);
+	if (free_ctx)
 		tls_ctx_free(ctx);
-		ctx = NULL;
-	}
+}
 
-skip_tx_cleanup:
+static void tls_sk_proto_close(struct sock *sk, long timeout)
+{
+	void (*sk_proto_close)(struct sock *sk, long timeout);
+	struct tls_context *ctx = tls_get_ctx(sk);
+	bool free_ctx;
+
+	if (!ctx)
+		return sk->sk_prot->destroy(sk);
+
+	lock_sock(sk);
+	sk_proto_close = ctx->sk_proto_close;
+	free_ctx = tls_sk_proto_destroy(sk, ctx, true);
 	release_sock(sk);
 	sk_proto_close(sk, timeout);
 	/* free ctx for TLS_HW_RECORD, used by tcp_set_state
@@ -601,6 +626,8 @@ static struct tls_context *create_ctx(struct sock *sk)
 	ctx->setsockopt = sk->sk_prot->setsockopt;
 	ctx->getsockopt = sk->sk_prot->getsockopt;
 	ctx->sk_proto_close = sk->sk_prot->close;
+	ctx->sk_proto_unhash = sk->sk_prot->unhash;
+	ctx->sk_proto = sk->sk_prot;
 	return ctx;
 }
 
@@ -738,6 +765,7 @@ static void build_protos(struct proto prot[TLS_NUM_CONFIG][TLS_NUM_CONFIG],
 	prot[TLS_SW][TLS_SW].recvmsg		= tls_sw_recvmsg;
 	prot[TLS_SW][TLS_SW].stream_memory_read	= tls_sw_stream_read;
 	prot[TLS_SW][TLS_SW].close		= tls_sk_proto_close;
+	prot[TLS_SW][TLS_SW].unhash		= tls_sk_proto_unhash;
 
 #ifdef CONFIG_TLS_DEVICE
 	prot[TLS_HW][TLS_BASE] = prot[TLS_BASE][TLS_BASE];
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 29d6af43dd24..2de433232b99 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -266,9 +266,9 @@ static void tls_trim_both_msgs(struct sock *sk, int target_size)
 	sk_msg_trim(sk, &rec->msg_encrypted, target_size);
 }
 
-static int tls_alloc_encrypted_msg(struct sock *sk, int len)
+static int tls_alloc_encrypted_msg(struct sock *sk,
+				   struct tls_context *tls_ctx,  int len)
 {
-	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_sw_context_tx *ctx = tls_sw_ctx_tx(tls_ctx);
 	struct tls_rec *rec = ctx->open_rec;
 	struct sk_msg *msg_en = &rec->msg_encrypted;
@@ -300,9 +300,8 @@ static int tls_clone_plaintext_msg(struct sock *sk, int required)
 	return sk_msg_clone(sk, msg_pl, msg_en, skip, len);
 }
 
-static struct tls_rec *tls_get_rec(struct sock *sk)
+static struct tls_rec *tls_get_rec(struct sock *sk, struct tls_context *tls_ctx)
 {
-	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_prot_info *prot = &tls_ctx->prot_info;
 	struct tls_sw_context_tx *ctx = tls_sw_ctx_tx(tls_ctx);
 	struct sk_msg *msg_pl, *msg_en;
@@ -339,9 +338,8 @@ static void tls_free_rec(struct sock *sk, struct tls_rec *rec)
 	kfree(rec);
 }
 
-static void tls_free_open_rec(struct sock *sk)
+static void tls_free_open_rec(struct sock *sk, struct tls_context *tls_ctx)
 {
-	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_sw_context_tx *ctx = tls_sw_ctx_tx(tls_ctx);
 	struct tls_rec *rec = ctx->open_rec;
 
@@ -351,9 +349,8 @@ static void tls_free_open_rec(struct sock *sk)
 	}
 }
 
-int tls_tx_records(struct sock *sk, int flags)
+int tls_tx_records(struct sock *sk, struct tls_context *tls_ctx, int flags)
 {
-	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_sw_context_tx *ctx = tls_sw_ctx_tx(tls_ctx);
 	struct tls_rec *rec, *tmp;
 	struct sk_msg *msg_en;
@@ -519,12 +516,13 @@ static int tls_do_encryption(struct sock *sk,
 
 	/* Unhook the record from context if encryption is not failure */
 	ctx->open_rec = NULL;
-	tls_advance_record_sn(sk, &tls_ctx->tx, prot->version);
+	tls_advance_record_sn(sk, prot, &tls_ctx->tx, prot->version);
 	return rc;
 }
 
-static int tls_split_open_record(struct sock *sk, struct tls_rec *from,
-				 struct tls_rec **to, struct sk_msg *msg_opl,
+static int tls_split_open_record(struct sock *sk, struct tls_context *tls_ctx,
+				 struct tls_rec *from, struct tls_rec **to,
+				 struct sk_msg *msg_opl,
 				 struct sk_msg *msg_oen, u32 split_point,
 				 u32 tx_overhead_size, u32 *orig_end)
 {
@@ -536,7 +534,7 @@ static int tls_split_open_record(struct sock *sk, struct tls_rec *from,
 	struct tls_rec *new;
 	int ret;
 
-	new = tls_get_rec(sk);
+	new = tls_get_rec(sk, tls_ctx);
 	if (!new)
 		return -ENOMEM;
 	ret = sk_msg_alloc(sk, &new->msg_encrypted, msg_opl->sg.size +
@@ -641,10 +639,9 @@ static void tls_merge_open_record(struct sock *sk, struct tls_rec *to,
 	kfree(from);
 }
 
-static int tls_push_record(struct sock *sk, int flags,
-			   unsigned char record_type)
+static int tls_push_record(struct sock *sk, struct tls_context *tls_ctx,
+			   int flags, unsigned char record_type)
 {
-	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_prot_info *prot = &tls_ctx->prot_info;
 	struct tls_sw_context_tx *ctx = tls_sw_ctx_tx(tls_ctx);
 	struct tls_rec *rec = ctx->open_rec, *tmp = NULL;
@@ -663,7 +660,8 @@ static int tls_push_record(struct sock *sk, int flags,
 	split_point = msg_pl->apply_bytes;
 	split = split_point && split_point < msg_pl->sg.size;
 	if (split) {
-		rc = tls_split_open_record(sk, rec, &tmp, msg_pl, msg_en,
+		rc = tls_split_open_record(sk, tls_ctx, rec, &tmp,
+					   msg_pl, msg_en,
 					   split_point, prot->overhead_size,
 					   &orig_end);
 		if (rc < 0)
@@ -732,14 +730,14 @@ static int tls_push_record(struct sock *sk, int flags,
 		ctx->open_rec = tmp;
 	}
 
-	return tls_tx_records(sk, flags);
+	return tls_tx_records(sk, tls_ctx, flags);
 }
 
 static int bpf_exec_tx_verdict(struct sk_msg *msg, struct sock *sk,
+			       struct tls_context *tls_ctx,
 			       bool full_record, u8 record_type,
 			       size_t *copied, int flags)
 {
-	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_sw_context_tx *ctx = tls_sw_ctx_tx(tls_ctx);
 	struct sk_msg msg_redir = { };
 	struct sk_psock *psock;
@@ -752,7 +750,7 @@ static int bpf_exec_tx_verdict(struct sk_msg *msg, struct sock *sk,
 	policy = !(flags & MSG_SENDPAGE_NOPOLICY);
 	psock = sk_psock_get(sk);
 	if (!psock || !policy)
-		return tls_push_record(sk, flags, record_type);
+		return tls_push_record(sk, tls_ctx, flags, record_type);
 more_data:
 	enospc = sk_msg_full(msg);
 	if (psock->eval == __SK_NONE) {
@@ -775,10 +773,10 @@ static int bpf_exec_tx_verdict(struct sk_msg *msg, struct sock *sk,
 
 	switch (psock->eval) {
 	case __SK_PASS:
-		err = tls_push_record(sk, flags, record_type);
+		err = tls_push_record(sk, tls_ctx, flags, record_type);
 		if (err < 0) {
 			*copied -= sk_msg_free(sk, msg);
-			tls_free_open_rec(sk);
+			tls_free_open_rec(sk, tls_ctx);
 			goto out_err;
 		}
 		break;
@@ -799,7 +797,7 @@ static int bpf_exec_tx_verdict(struct sk_msg *msg, struct sock *sk,
 			msg->sg.size = 0;
 		}
 		if (msg->sg.size == 0)
-			tls_free_open_rec(sk);
+			tls_free_open_rec(sk, tls_ctx);
 		break;
 	case __SK_DROP:
 	default:
@@ -809,7 +807,7 @@ static int bpf_exec_tx_verdict(struct sk_msg *msg, struct sock *sk,
 		else
 			msg->apply_bytes -= send;
 		if (msg->sg.size == 0)
-			tls_free_open_rec(sk);
+			tls_free_open_rec(sk, tls_ctx);
 		*copied -= (send + delta);
 		err = -EACCES;
 	}
@@ -838,14 +836,15 @@ static int bpf_exec_tx_verdict(struct sk_msg *msg, struct sock *sk,
 	return err;
 }
 
-static int tls_sw_push_pending_record(struct sock *sk, int flags)
+static int tls_sw_push_pending_record(struct sock *sk,
+				      struct tls_context *tls_ctx, int flags)
 {
-	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_sw_context_tx *ctx = tls_sw_ctx_tx(tls_ctx);
-	struct tls_rec *rec = ctx->open_rec;
 	struct sk_msg *msg_pl;
+	struct tls_rec *rec;
 	size_t copied;
 
+	rec = ctx->open_rec;
 	if (!rec)
 		return 0;
 
@@ -854,31 +853,39 @@ static int tls_sw_push_pending_record(struct sock *sk, int flags)
 	if (!copied)
 		return 0;
 
-	return bpf_exec_tx_verdict(msg_pl, sk, true, TLS_RECORD_TYPE_DATA,
+	return bpf_exec_tx_verdict(msg_pl, sk, tls_ctx, true,
+				   TLS_RECORD_TYPE_DATA,
 				   &copied, flags);
 }
 
 int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 {
 	long timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
-	struct tls_context *tls_ctx = tls_get_ctx(sk);
-	struct tls_prot_info *prot = &tls_ctx->prot_info;
-	struct tls_sw_context_tx *ctx = tls_sw_ctx_tx(tls_ctx);
-	bool async_capable = ctx->async_capable;
 	unsigned char record_type = TLS_RECORD_TYPE_DATA;
 	bool is_kvec = iov_iter_is_kvec(&msg->msg_iter);
 	bool eor = !(msg->msg_flags & MSG_MORE);
+	bool full_record, async_capable;
 	size_t try_to_copy, copied = 0;
 	struct sk_msg *msg_pl, *msg_en;
+	struct tls_sw_context_tx *ctx;
+	struct tls_context *tls_ctx;
+	struct tls_prot_info *prot;
 	struct tls_rec *rec;
 	int required_size;
 	int num_async = 0;
-	bool full_record;
 	int record_room;
 	int num_zc = 0;
 	int orig_size;
 	int ret = 0;
 
+	tls_ctx = tls_get_ctx(sk);
+	if (unlikely(!tls_ctx))
+		return -EBUSY;
+
+	prot = &tls_ctx->prot_info;
+	ctx = tls_sw_ctx_tx(tls_ctx);
+	async_capable = ctx->async_capable;
+
 	if (msg->msg_flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL))
 		return -ENOTSUPP;
 
@@ -910,7 +917,7 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 		if (ctx->open_rec)
 			rec = ctx->open_rec;
 		else
-			rec = ctx->open_rec = tls_get_rec(sk);
+			rec = ctx->open_rec = tls_get_rec(sk, tls_ctx);
 		if (!rec) {
 			ret = -ENOMEM;
 			goto send_end;
@@ -935,7 +942,7 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 			goto wait_for_sndbuf;
 
 alloc_encrypted:
-		ret = tls_alloc_encrypted_msg(sk, required_size);
+		ret = tls_alloc_encrypted_msg(sk, tls_ctx, required_size);
 		if (ret) {
 			if (ret != -ENOSPC)
 				goto wait_for_memory;
@@ -962,7 +969,8 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 			copied += try_to_copy;
 
 			sk_msg_sg_copy_set(msg_pl, first);
-			ret = bpf_exec_tx_verdict(msg_pl, sk, full_record,
+			ret = bpf_exec_tx_verdict(msg_pl, sk, tls_ctx,
+						  full_record,
 						  record_type, &copied,
 						  msg->msg_flags);
 			if (ret) {
@@ -1015,7 +1023,8 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 		tls_ctx->pending_open_record_frags = true;
 		copied += try_to_copy;
 		if (full_record || eor) {
-			ret = bpf_exec_tx_verdict(msg_pl, sk, full_record,
+			ret = bpf_exec_tx_verdict(msg_pl, sk, tls_ctx,
+						  full_record,
 						  record_type, &copied,
 						  msg->msg_flags);
 			if (ret) {
@@ -1069,7 +1078,7 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 	/* Transmit if any encryptions have completed */
 	if (test_and_clear_bit(BIT_TX_SCHEDULED, &ctx->tx_bitmask)) {
 		cancel_delayed_work(&ctx->tx_work.work);
-		tls_tx_records(sk, msg->msg_flags);
+		tls_tx_records(sk, tls_ctx, msg->msg_flags);
 	}
 
 send_end:
@@ -1083,10 +1092,10 @@ static int tls_sw_do_sendpage(struct sock *sk, struct page *page,
 			      int offset, size_t size, int flags)
 {
 	long timeo = sock_sndtimeo(sk, flags & MSG_DONTWAIT);
-	struct tls_context *tls_ctx = tls_get_ctx(sk);
-	struct tls_sw_context_tx *ctx = tls_sw_ctx_tx(tls_ctx);
-	struct tls_prot_info *prot = &tls_ctx->prot_info;
 	unsigned char record_type = TLS_RECORD_TYPE_DATA;
+	struct tls_sw_context_tx *ctx;
+	struct tls_context *tls_ctx;
+	struct tls_prot_info *prot;
 	struct sk_msg *msg_pl;
 	struct tls_rec *rec;
 	int num_async = 0;
@@ -1096,6 +1105,13 @@ static int tls_sw_do_sendpage(struct sock *sk, struct page *page,
 	int ret = 0;
 	bool eor;
 
+	tls_ctx = tls_get_ctx(sk);
+	if (unlikely(!tls_ctx))
+		return -EBUSY;
+
+	ctx = tls_sw_ctx_tx(tls_ctx);
+	prot = &tls_ctx->prot_info;
+
 	eor = !(flags & (MSG_MORE | MSG_SENDPAGE_NOTLAST));
 	sk_clear_bit(SOCKWQ_ASYNC_NOSPACE, sk);
 
@@ -1118,7 +1134,7 @@ static int tls_sw_do_sendpage(struct sock *sk, struct page *page,
 		if (ctx->open_rec)
 			rec = ctx->open_rec;
 		else
-			rec = ctx->open_rec = tls_get_rec(sk);
+			rec = ctx->open_rec = tls_get_rec(sk, tls_ctx);
 		if (!rec) {
 			ret = -ENOMEM;
 			goto sendpage_end;
@@ -1140,7 +1156,7 @@ static int tls_sw_do_sendpage(struct sock *sk, struct page *page,
 		if (!sk_stream_memory_free(sk))
 			goto wait_for_sndbuf;
 alloc_payload:
-		ret = tls_alloc_encrypted_msg(sk, required_size);
+		ret = tls_alloc_encrypted_msg(sk, tls_ctx, required_size);
 		if (ret) {
 			if (ret != -ENOSPC)
 				goto wait_for_memory;
@@ -1163,7 +1179,8 @@ static int tls_sw_do_sendpage(struct sock *sk, struct page *page,
 		tls_ctx->pending_open_record_frags = true;
 		if (full_record || eor || sk_msg_full(msg_pl)) {
 			rec->inplace_crypto = 0;
-			ret = bpf_exec_tx_verdict(msg_pl, sk, full_record,
+			ret = bpf_exec_tx_verdict(msg_pl, sk, tls_ctx,
+						  full_record,
 						  record_type, &copied, flags);
 			if (ret) {
 				if (ret == -EINPROGRESS)
@@ -1194,7 +1211,7 @@ static int tls_sw_do_sendpage(struct sock *sk, struct page *page,
 		/* Transmit if any encryptions have completed */
 		if (test_and_clear_bit(BIT_TX_SCHEDULED, &ctx->tx_bitmask)) {
 			cancel_delayed_work(&ctx->tx_work.work);
-			tls_tx_records(sk, flags);
+			tls_tx_records(sk, tls_ctx, flags);
 		}
 	}
 sendpage_end:
@@ -1479,7 +1496,8 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 					       async);
 			if (err < 0) {
 				if (err == -EINPROGRESS)
-					tls_advance_record_sn(sk, &tls_ctx->rx,
+					tls_advance_record_sn(sk, prot,
+							      &tls_ctx->rx,
 							      version);
 
 				return err;
@@ -1491,7 +1509,7 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 		rxm->full_len -= padding_length(ctx, tls_ctx, skb);
 		rxm->offset += prot->prepend_size;
 		rxm->full_len -= prot->overhead_size;
-		tls_advance_record_sn(sk, &tls_ctx->rx, version);
+		tls_advance_record_sn(sk, prot, &tls_ctx->rx, version);
 		ctx->decrypted = true;
 		ctx->saved_data_ready(sk);
 	} else {
@@ -2031,9 +2049,9 @@ static void tls_data_ready(struct sock *sk)
 	}
 }
 
-void tls_sw_free_resources_tx(struct sock *sk)
+void tls_sw_free_resources_tx(struct sock *sk,
+			      struct tls_context *tls_ctx, bool locked)
 {
-	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_sw_context_tx *ctx = tls_sw_ctx_tx(tls_ctx);
 	struct tls_rec *rec, *tmp;
 
@@ -2042,12 +2060,14 @@ void tls_sw_free_resources_tx(struct sock *sk)
 	if (atomic_read(&ctx->encrypt_pending))
 		crypto_wait_req(-EINPROGRESS, &ctx->async_wait);
 
-	release_sock(sk);
+	if (locked)
+		release_sock(sk);
 	cancel_delayed_work_sync(&ctx->tx_work.work);
-	lock_sock(sk);
+	if (locked)
+		lock_sock(sk);
 
 	/* Tx whatever records we can transmit and abandon the rest */
-	tls_tx_records(sk, -1);
+	tls_tx_records(sk, tls_ctx, -1);
 
 	/* Free up un-sent records in tx_list. First, free
 	 * the partially sent record if any at head of tx_list.
@@ -2067,15 +2087,17 @@ void tls_sw_free_resources_tx(struct sock *sk)
 		kfree(rec);
 	}
 
-	crypto_free_aead(ctx->aead_send);
-	tls_free_open_rec(sk);
+	if (ctx->aead_send) {
+		crypto_free_aead(ctx->aead_send);
+		ctx->aead_send = NULL;
+	}
+	tls_free_open_rec(sk, tls_ctx);
 
 	kfree(ctx);
 }
 
-void tls_sw_release_resources_rx(struct sock *sk)
+void tls_sw_release_resources_rx(struct sock *sk, struct tls_context *tls_ctx)
 {
-	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
 
 	kfree(tls_ctx->rx.rec_seq);
@@ -2096,13 +2118,11 @@ void tls_sw_release_resources_rx(struct sock *sk)
 	}
 }
 
-void tls_sw_free_resources_rx(struct sock *sk)
+void tls_sw_free_resources_rx(struct sock *sk, struct tls_context *tls_ctx)
 {
-	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
 
-	tls_sw_release_resources_rx(sk);
-
+	tls_sw_release_resources_rx(sk, tls_ctx);
 	kfree(ctx);
 }
 
@@ -2120,7 +2140,7 @@ static void tx_work_handler(struct work_struct *work)
 		return;
 
 	lock_sock(sk);
-	tls_tx_records(sk, -1);
+	tls_tx_records(sk, tls_ctx, -1);
 	release_sock(sk);
 }
 

