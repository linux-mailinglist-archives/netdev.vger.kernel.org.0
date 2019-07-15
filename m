Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8607369D09
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 22:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731988AbfGOUtS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 16:49:18 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:37932 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729505AbfGOUtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 16:49:18 -0400
Received: by mail-ot1-f65.google.com with SMTP id d17so18560046oth.5;
        Mon, 15 Jul 2019 13:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=B2ogZ6mjovzkCR5HJmoGraNTud1gYT/+smTPhr8188g=;
        b=gZV8Tu17SHlNYM/fQS8Qttmu66ly4GyykrFHxK3/HViOrYp/5uIFGwKcI7vcrqVyUm
         IsoIoX9q/WbYvWAlRORz5g4F0sAKjVZKij7INGet3e+GL0MnFfIGiIVBrU/DHCKE5MfU
         fbNCuLVNbaAktiJVgqiNfIpCnRO/rCmOXUNeS0WBf8XIMPGqCn1uzx/siNN7r7eRepsr
         TQEKwf1LWiH2yawrPjG2I51udj9+lVznir0zzV9+jhO5zp8UCas8Xq+Gx3pdznh7WYTj
         y6vayC4pImFcbz0nEj3Hc/fysNFJ4IdurCkJYS68QajXOUcDEdcT2rOBesPILdwOMCpi
         yi0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=B2ogZ6mjovzkCR5HJmoGraNTud1gYT/+smTPhr8188g=;
        b=UizqqdI2dMA64TJnTxXhhSPUzJsmrqyV3QEkXKPT0H+HQg2ex7zuj5qaZu0JtyegxL
         RTwS7pTpv9C8DYyJkpRGfo7rLyVkrpftha8od0aOqRkDKzF39BcQPt9XK1VcYGvLbZoZ
         xNGuhjaTM3olYe4+tDB0es3r37zo98CLAcSaulXHrNpLuGaJbl6X9SdEJCfKJW5oCLGw
         OrDaOA9Wr1dSUa4/gu0ySW37q0ttLZnC7WSPWlfDRHtS2sx/U/lGamVbDB+fb3RTI8Pb
         0Eg46mZjzXortIX/4SGo1GyOQC77xe7jLzT4ZG3N888OkW/Wc0vOTBXeRlkAxR4gGbMq
         BW6Q==
X-Gm-Message-State: APjAAAU1FPz0+VEjhI1jvHrNP5AERQe1GoVaJHvJ1NWJPPK29rADbMOu
        tNYFQHwtzfrmhXsGx9lkTCM=
X-Google-Smtp-Source: APXvYqw1PS6SbWzw9iSPEYeNXt0KdiZdhA+n6zitIL/4QyzAouOcX0uBfmn4kmOu5Ba96N/hZM57GA==
X-Received: by 2002:a9d:470f:: with SMTP id a15mr20072874otf.235.1563223757350;
        Mon, 15 Jul 2019 13:49:17 -0700 (PDT)
Received: from [127.0.1.1] ([99.0.85.34])
        by smtp.gmail.com with ESMTPSA id 132sm6414818oid.47.2019.07.15.13.49.16
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 13:49:16 -0700 (PDT)
Subject: [bpf PATCH v3 2/8] tls: remove close callback sock unlock/lock
 around TX work flush
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub.kicinski@netronome.com, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, edumazet@google.com,
        john.fastabend@gmail.com, bpf@vger.kernel.org
Date:   Mon, 15 Jul 2019 13:49:15 -0700
Message-ID: <156322375571.18678.11939499603669901288.stgit@john-XPS-13-9370>
In-Reply-To: <156322373173.18678.6003379631139659856.stgit@john-XPS-13-9370>
References: <156322373173.18678.6003379631139659856.stgit@john-XPS-13-9370>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The tls close() callback currently drops the sock lock, makes a
cancel_delayed_work_sync() call, and then relocks the sock.

By restructuring the code we can avoid droping lock and then
reclaiming it. To simplify this we do the following,

 tls_sk_proto_close
 set_bit(CLOSING)
 set_bit(SCHEDULE)
 cancel_delay_work_sync() <- cancel workqueue
 lock_sock(sk)
 ...
 release_sock(sk)
 strp_done()

Setting the CLOSING bit prevents the SCHEDULE bit from being
cleared by any workqueue items e.g. if one happens to be
scheduled and run between when we set SCHEDULE bit and cancel
work. Then because SCHEDULE bit is set now no new work will
be scheduled.

Tested with net selftests and bpf selftests.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 include/net/tls.h  |    2 ++
 net/tls/tls_main.c |    3 +++
 net/tls/tls_sw.c   |   24 +++++++++++++++++-------
 3 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index 43f551cd508b..d4276cb6de53 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -162,6 +162,7 @@ struct tls_sw_context_tx {
 	int async_capable;
 
 #define BIT_TX_SCHEDULED	0
+#define BIT_TX_CLOSING		1
 	unsigned long tx_bitmask;
 };
 
@@ -360,6 +361,7 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size);
 int tls_sw_sendpage(struct sock *sk, struct page *page,
 		    int offset, size_t size, int flags);
 void tls_sw_close(struct sock *sk, long timeout);
+void tls_sw_cancel_work_tx(struct tls_context *tls_ctx);
 void tls_sw_free_resources_tx(struct sock *sk);
 void tls_sw_free_resources_rx(struct sock *sk);
 void tls_sw_release_resources_rx(struct sock *sk);
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 85a9d7d57b32..ddda422498aa 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -268,6 +268,9 @@ static void tls_sk_proto_close(struct sock *sk, long timeout)
 	void (*sk_proto_close)(struct sock *sk, long timeout);
 	bool free_ctx = false;
 
+	if (ctx->tx_conf == TLS_SW)
+		tls_sw_cancel_work_tx(ctx);
+
 	lock_sock(sk);
 	sk_proto_close = ctx->sk_proto_close;
 
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index f58a8ffc2a9c..38c0e53c727d 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2054,6 +2054,15 @@ static void tls_data_ready(struct sock *sk)
 	}
 }
 
+void tls_sw_cancel_work_tx(struct tls_context *tls_ctx)
+{
+	struct tls_sw_context_tx *ctx = tls_sw_ctx_tx(tls_ctx);
+
+	set_bit(BIT_TX_CLOSING, &ctx->tx_bitmask);
+	set_bit(BIT_TX_SCHEDULED, &ctx->tx_bitmask);
+	cancel_delayed_work_sync(&ctx->tx_work.work);
+}
+
 void tls_sw_free_resources_tx(struct sock *sk)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
@@ -2065,11 +2074,6 @@ void tls_sw_free_resources_tx(struct sock *sk)
 	if (atomic_read(&ctx->encrypt_pending))
 		crypto_wait_req(-EINPROGRESS, &ctx->async_wait);
 
-	release_sock(sk);
-	cancel_delayed_work_sync(&ctx->tx_work.work);
-	lock_sock(sk);
-
-	/* Tx whatever records we can transmit and abandon the rest */
 	tls_tx_records(sk, -1);
 
 	/* Free up un-sent records in tx_list. First, free
@@ -2137,11 +2141,17 @@ static void tx_work_handler(struct work_struct *work)
 					       struct tx_work, work);
 	struct sock *sk = tx_work->sk;
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
-	struct tls_sw_context_tx *ctx = tls_sw_ctx_tx(tls_ctx);
+	struct tls_sw_context_tx *ctx;
 
-	if (!test_and_clear_bit(BIT_TX_SCHEDULED, &ctx->tx_bitmask))
+	if (unlikely(!tls_ctx))
 		return;
 
+	ctx = tls_sw_ctx_tx(tls_ctx);
+	if (test_bit(BIT_TX_CLOSING, &ctx->tx_bitmask))
+		return;
+
+	if (!test_and_clear_bit(BIT_TX_SCHEDULED, &ctx->tx_bitmask))
+		return;
 	lock_sock(sk);
 	tls_tx_records(sk, -1);
 	release_sock(sk);

