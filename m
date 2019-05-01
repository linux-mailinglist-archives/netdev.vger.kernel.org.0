Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0666103CE
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 04:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727516AbfEACGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 22:06:52 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:36728 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfEACGw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 22:06:52 -0400
Received: by mail-yw1-f67.google.com with SMTP id g29so7442147ywk.3;
        Tue, 30 Apr 2019 19:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=zZT6VREpVNvjqSh4U4xaGhNNxa9B7EbNtNtljdue6CQ=;
        b=AqX5xn+r54TEs5XYPF5E9LvrO9JYPx6Q20UkFcoK9lA90ur7i9XlANAYRoqgaBlRMJ
         Mcd/5XyfDXCAOVPqxVhVK7WXyVFdkXKsLBEFWPv0UEEIFKzTm8idafTA6UrlKg5/+E8O
         ASyxsHMiRxf3/RqhFcJcycN+SWn+q/MSuoz8u71ibZslUNEYRhyylBDv71M2OGKk8rfI
         vijW7jNZFuwaSl7PbKbsKDzsi0VTbE0Xaln+Aaj2rGNQofrrqnUF1cS6hB8knTj+oWrP
         /lIV2ICh6tJKVtPR0f10bfOpzoFuv/XB83XRXqdYABtArOZzxCB9xprVlF9Lsl45ggJ5
         RZ5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=zZT6VREpVNvjqSh4U4xaGhNNxa9B7EbNtNtljdue6CQ=;
        b=ZAjpYuq0cTg9w7KYba+N1EDRAHDvAZRgaJNWl3CE9n8nMF1R95nc648LySM0E+6q3c
         sbmHrUZTJgoHS/2wiFQgkZAGxZyCqkTkijjVEc9mSJ1SiHT63y8xRvV3CtNsFFxUA4mU
         T6RsThUh0rb7AbO0J7XSzj6ywoBTFXw+JI8KO8AOEZSJbmrdjvxLKCd6V7LNw2iZESLf
         M7pnLt+uO8QGTNDIiv3XE7c5y/kAkCdMlTRMqpYDGvZ+xIBYpwI4PaSZfGRpx0gUyUtw
         nfCqMiMzqfILP9h807zzGJSNNKGI++YPT+lJBeAlyQZPaNJIZjkY595MqRmFUEfttx2E
         S3HA==
X-Gm-Message-State: APjAAAXTLJFc3jXtdyUd+WX/KVJ1yy5i5rAjm9k2YaqanO9GipoJ8aY4
        ggQS33KSTMLhzm82OGyvlHo=
X-Google-Smtp-Source: APXvYqwsHbGI/lhdKs+zU1b//6y6G9zApL7CHm547EPvJoPuBk75fBXLN4mxZN4l/r00oeAZtDjyGg==
X-Received: by 2002:a81:3152:: with SMTP id x79mr52168440ywx.463.1556676410837;
        Tue, 30 Apr 2019 19:06:50 -0700 (PDT)
Received: from [127.0.1.1] (adsl-173-228-226-134.prtc.net. [173.228.226.134])
        by smtp.gmail.com with ESMTPSA id i13sm5368152ywl.22.2019.04.30.19.06.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Apr 2019 19:06:50 -0700 (PDT)
Subject: [bpf-next PATCH v3 1/4] bpf: tls,
 implement unhash to avoid transition out of ESTABLISHED
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub.kicinski@netronome.com, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Tue, 30 Apr 2019 19:06:49 -0700
Message-ID: <155667640930.4128.2206402218329524687.stgit@john-XPS-13-9360>
In-Reply-To: <155667629056.4128.14102391877350907561.stgit@john-XPS-13-9360>
References: <155667629056.4128.14102391877350907561.stgit@john-XPS-13-9360>
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
 include/net/tls.h    |   24 ++++++++++++---
 net/tls/tls_device.c |    6 ++--
 net/tls/tls_main.c   |   78 +++++++++++++++++++++++++++++++++-----------------
 net/tls/tls_sw.c     |   51 ++++++++++++++++-----------------
 4 files changed, 98 insertions(+), 61 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index d9d0ac66f040..0782a92487f1 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -261,11 +261,14 @@ struct tls_context {
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
@@ -303,9 +306,10 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size);
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
@@ -321,7 +325,7 @@ void tls_device_sk_destruct(struct sock *sk);
 void tls_device_free_resources_tx(struct sock *sk);
 void tls_device_init(void);
 void tls_device_cleanup(void);
-int tls_tx_records(struct sock *sk, int flags);
+int tls_tx_records(struct sock *sk, struct tls_context *ctx, int flags);
 
 struct tls_record_info *tls_get_record(struct tls_offload_context_tx *context,
 				       u32 seq, u64 *p_record_sn);
@@ -504,6 +508,16 @@ static inline void xor_iv_with_seq(int version, char *iv, char *seq)
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
index 9f3bdbc1e593..702a024c0c7b 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -548,7 +548,7 @@ struct tls_record_info *tls_get_record(struct tls_offload_context_tx *context,
 }
 EXPORT_SYMBOL(tls_get_record);
 
-static int tls_device_push_pending_record(struct sock *sk, int flags)
+static int tls_device_push_pending_record(struct sock *sk, struct tls_context *ctx, int flags)
 {
 	struct iov_iter	msg_iter;
 
@@ -904,7 +904,7 @@ int tls_set_device_offload_rx(struct sock *sk, struct tls_context *ctx)
 	goto release_netdev;
 
 free_sw_resources:
-	tls_sw_free_resources_rx(sk);
+	tls_sw_free_resources_rx(sk, ctx);
 release_ctx:
 	ctx->priv_ctx_rx = NULL;
 release_netdev:
@@ -941,7 +941,7 @@ void tls_device_offload_cleanup_rx(struct sock *sk)
 	up_read(&device_offload_lock);
 	kfree(tls_ctx->rx.rec_seq);
 	kfree(tls_ctx->rx.iv);
-	tls_sw_release_resources_rx(sk);
+	tls_sw_release_resources_rx(sk, tls_ctx);
 }
 
 static int tls_device_down(struct net_device *netdev)
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 7e546b8ec000..de2ec8349361 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -150,12 +150,10 @@ int tls_push_sg(struct sock *sk,
 	return 0;
 }
 
-static int tls_handle_open_record(struct sock *sk, int flags)
+static int tls_handle_open_record(struct sock *sk, struct tls_context *ctx, int flags)
 {
-	struct tls_context *ctx = tls_get_ctx(sk);
-
 	if (tls_is_pending_open_record(ctx))
-		return ctx->push_pending_record(sk, flags);
+		return ctx->push_pending_record(sk, ctx, flags);
 
 	return 0;
 }
@@ -163,6 +161,7 @@ static int tls_handle_open_record(struct sock *sk, int flags)
 int tls_proccess_cmsg(struct sock *sk, struct msghdr *msg,
 		      unsigned char *record_type)
 {
+	struct tls_context *ctx;
 	struct cmsghdr *cmsg;
 	int rc = -EINVAL;
 
@@ -180,7 +179,8 @@ int tls_proccess_cmsg(struct sock *sk, struct msghdr *msg,
 			if (msg->msg_flags & MSG_MORE)
 				return -EINVAL;
 
-			rc = tls_handle_open_record(sk, msg->msg_flags);
+			ctx = tls_get_ctx(sk);
+			rc = tls_handle_open_record(sk, ctx, msg->msg_flags);
 			if (rc)
 				return rc;
 
@@ -261,32 +261,28 @@ static void tls_ctx_free(struct tls_context *ctx)
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
+	if (ctx->tx_conf != TLS_HW && ctx->rx_conf != TLS_HW)
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
@@ -296,22 +292,47 @@ static void tls_sk_proto_close(struct sock *sk, long timeout)
 	if (ctx->rx_conf == TLS_SW) {
 		kfree(ctx->rx.rec_seq);
 		kfree(ctx->rx.iv);
-		tls_sw_free_resources_rx(sk);
+		tls_sw_free_resources_rx(sk, ctx);
 	}
 
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
+
+static void tls_sk_proto_close(struct sock *sk, long timeout)
+{
+	void (*sk_proto_close)(struct sock *sk, long timeout);
+	struct tls_context *ctx = tls_get_ctx(sk);
+	bool free_ctx;
 
-skip_tx_cleanup:
+	if (!ctx)
+		return sk->sk_prot->destroy(sk);
+
+	lock_sock(sk);
+	sk_proto_close = ctx->sk_proto_close;
+	free_ctx = tls_sk_proto_destroy(sk, ctx, true);
 	release_sock(sk);
 	sk_proto_close(sk, timeout);
 	/* free ctx for TLS_HW_RECORD, used by tcp_set_state
@@ -609,6 +630,8 @@ static struct tls_context *create_ctx(struct sock *sk)
 	ctx->setsockopt = sk->sk_prot->setsockopt;
 	ctx->getsockopt = sk->sk_prot->getsockopt;
 	ctx->sk_proto_close = sk->sk_prot->close;
+	ctx->sk_proto_unhash = sk->sk_prot->unhash;
+	ctx->sk_proto = sk->sk_prot;
 	return ctx;
 }
 
@@ -732,6 +755,7 @@ static void build_protos(struct proto prot[TLS_NUM_CONFIG][TLS_NUM_CONFIG],
 	prot[TLS_BASE][TLS_BASE].setsockopt	= tls_setsockopt;
 	prot[TLS_BASE][TLS_BASE].getsockopt	= tls_getsockopt;
 	prot[TLS_BASE][TLS_BASE].close		= tls_sk_proto_close;
+	prot[TLS_BASE][TLS_BASE].unhash		= tls_sk_proto_unhash;
 
 	prot[TLS_SW][TLS_BASE] = prot[TLS_BASE][TLS_BASE];
 	prot[TLS_SW][TLS_BASE].sendmsg		= tls_sw_sendmsg;
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index f780b473827b..f145ab879552 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -337,9 +337,8 @@ static void tls_free_rec(struct sock *sk, struct tls_rec *rec)
 	kfree(rec);
 }
 
-static void tls_free_open_rec(struct sock *sk)
+static void tls_free_open_rec(struct sock *sk, struct tls_context *tls_ctx)
 {
-	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_sw_context_tx *ctx = tls_sw_ctx_tx(tls_ctx);
 	struct tls_rec *rec = ctx->open_rec;
 
@@ -349,9 +348,8 @@ static void tls_free_open_rec(struct sock *sk)
 	}
 }
 
-int tls_tx_records(struct sock *sk, int flags)
+int tls_tx_records(struct sock *sk, struct tls_context *tls_ctx, int flags)
 {
-	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_sw_context_tx *ctx = tls_sw_ctx_tx(tls_ctx);
 	struct tls_rec *rec, *tmp;
 	struct sk_msg *msg_en;
@@ -737,7 +735,7 @@ static int tls_push_record(struct sock *sk, int flags,
 		ctx->open_rec = tmp;
 	}
 
-	return tls_tx_records(sk, flags);
+	return tls_tx_records(sk, tls_ctx, flags);
 }
 
 static int bpf_exec_tx_verdict(struct sk_msg *msg, struct sock *sk,
@@ -783,7 +781,7 @@ static int bpf_exec_tx_verdict(struct sk_msg *msg, struct sock *sk,
 		err = tls_push_record(sk, flags, record_type);
 		if (err < 0) {
 			*copied -= sk_msg_free(sk, msg);
-			tls_free_open_rec(sk);
+			tls_free_open_rec(sk, tls_ctx);
 			goto out_err;
 		}
 		break;
@@ -804,7 +802,7 @@ static int bpf_exec_tx_verdict(struct sk_msg *msg, struct sock *sk,
 			msg->sg.size = 0;
 		}
 		if (msg->sg.size == 0)
-			tls_free_open_rec(sk);
+			tls_free_open_rec(sk, tls_ctx);
 		break;
 	case __SK_DROP:
 	default:
@@ -814,7 +812,7 @@ static int bpf_exec_tx_verdict(struct sk_msg *msg, struct sock *sk,
 		else
 			msg->apply_bytes -= send;
 		if (msg->sg.size == 0)
-			tls_free_open_rec(sk);
+			tls_free_open_rec(sk, tls_ctx);
 		*copied -= (send + delta);
 		err = -EACCES;
 	}
@@ -843,9 +841,9 @@ static int bpf_exec_tx_verdict(struct sk_msg *msg, struct sock *sk,
 	return err;
 }
 
-static int tls_sw_push_pending_record(struct sock *sk, int flags)
+static int tls_sw_push_pending_record(struct sock *sk,
+				      struct tls_context *tls_ctx, int flags)
 {
-	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_sw_context_tx *ctx = tls_sw_ctx_tx(tls_ctx);
 	struct tls_rec *rec = ctx->open_rec;
 	struct sk_msg *msg_pl;
@@ -1074,7 +1072,7 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 	/* Transmit if any encryptions have completed */
 	if (test_and_clear_bit(BIT_TX_SCHEDULED, &ctx->tx_bitmask)) {
 		cancel_delayed_work(&ctx->tx_work.work);
-		tls_tx_records(sk, msg->msg_flags);
+		tls_tx_records(sk, tls_ctx, msg->msg_flags);
 	}
 
 send_end:
@@ -1199,7 +1197,7 @@ static int tls_sw_do_sendpage(struct sock *sk, struct page *page,
 		/* Transmit if any encryptions have completed */
 		if (test_and_clear_bit(BIT_TX_SCHEDULED, &ctx->tx_bitmask)) {
 			cancel_delayed_work(&ctx->tx_work.work);
-			tls_tx_records(sk, flags);
+			tls_tx_records(sk, tls_ctx, flags);
 		}
 	}
 sendpage_end:
@@ -2044,9 +2042,8 @@ static void tls_data_ready(struct sock *sk)
 	}
 }
 
-void tls_sw_free_resources_tx(struct sock *sk)
+void tls_sw_free_resources_tx(struct sock *sk, struct tls_context *tls_ctx, bool locked)
 {
-	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_sw_context_tx *ctx = tls_sw_ctx_tx(tls_ctx);
 	struct tls_rec *rec, *tmp;
 
@@ -2055,12 +2052,14 @@ void tls_sw_free_resources_tx(struct sock *sk)
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
@@ -2080,15 +2079,17 @@ void tls_sw_free_resources_tx(struct sock *sk)
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
 
 	if (ctx->aead_recv) {
@@ -2106,13 +2107,11 @@ void tls_sw_release_resources_rx(struct sock *sk)
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
 
@@ -2130,7 +2129,7 @@ static void tx_work_handler(struct work_struct *work)
 		return;
 
 	lock_sock(sk);
-	tls_tx_records(sk, -1);
+	tls_tx_records(sk, tls_ctx, -1);
 	release_sock(sk);
 }
 

