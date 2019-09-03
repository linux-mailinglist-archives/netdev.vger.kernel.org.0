Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04742A603D
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 06:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbfICEbe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 00:31:34 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39789 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbfICEbd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 00:31:33 -0400
Received: by mail-wm1-f67.google.com with SMTP id n2so15073771wmk.4
        for <netdev@vger.kernel.org>; Mon, 02 Sep 2019 21:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nUK4apPGc2+uDg3ukHbT2qck5VI6YUi/oWJ8+jehbE0=;
        b=chzFDgawlyDoFtKPBB5NxgFntFPM0cxCQ36DdlzkZ66TxXN9L8XVyd5+9/pC8Eaw7J
         Bz3qhTp5ZmOdoK2Iiub2TTsh0p2fEBnJs9aLV+TD2VEX4kQFuWMKZ9whHEjW822Ncy5I
         vY75bFeryKLwl+QvU2pQzXKDGfujJ9h+TThoQgM0U+vD20qDl8tCtoqjqeO5NlBrf5oD
         jegwFK4UkeXr2L16pbBusaciuBzajhnvl3u6/vHANlKt5mLHMZYD+IZL+xP806gJOl/E
         shqFoKMuFU5ewv3LN8VDfr4bKPHmNNSmXJHQ26iDR89jLZXQJ+iobz+TC9C+2sE1Q4JN
         FHEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nUK4apPGc2+uDg3ukHbT2qck5VI6YUi/oWJ8+jehbE0=;
        b=bnii683CJsqqKL7ofb/7jHvesGa4Q82ow1bsVz0kXvcybunFDilhaGL8SaKp9jqJRW
         IT9hwUssThtljZKhs1+O8AlGyuaBGTKdbzUHNonRcQ41aN498Npusd/poQ54AyKSXoz7
         5WG8Uh/yg5aayn/oHN8wD/wmapIerdKsfTyoNcISwn31nIWyw9vkyvJhVq5sNkj756wN
         Egum2eBxQ8hBQgzpef1BOnnWb3UKf8H48+ANlIqZruPZtasEU7rhS88seC4a39oRrahT
         W3B+Fwu7CyTlPYj35AMRtZwMvtm1TXE2lkOdfaivpuLZUCRwRXAvHSSQtYP3h95bV4ni
         oY3Q==
X-Gm-Message-State: APjAAAWoFmh/Af5096eb2LEnI1VpyKHJFBkFQQiY/d7depI8xThw0HvB
        2CyN6JKtTvtqNCgJa0edLBsxsw==
X-Google-Smtp-Source: APXvYqyyJc+8vWA+3EiDglfC2VB4jSJ4iV2N/zrIVodTIti3oSZZeKpQ5sACSS0XteozVqkUFqYlig==
X-Received: by 2002:a7b:c013:: with SMTP id c19mr31546850wmb.118.1567485092108;
        Mon, 02 Sep 2019 21:31:32 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id e13sm21024465wmh.44.2019.09.02.21.31.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Sep 2019 21:31:31 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        davejwatson@fb.com, borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Hurley <john.hurley@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net-next 1/5] net/tls: use the full sk_proto pointer
Date:   Mon,  2 Sep 2019 21:31:02 -0700
Message-Id: <20190903043106.27570-2-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190903043106.27570-1-jakub.kicinski@netronome.com>
References: <20190903043106.27570-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since we already have the pointer to the full original sk_proto
stored use that instead of storing all individual callback
pointers as well.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 drivers/crypto/chelsio/chtls/chtls_main.c |  6 +++--
 include/net/tls.h                         | 10 ---------
 net/tls/tls_main.c                        | 27 +++++++++--------------
 3 files changed, 14 insertions(+), 29 deletions(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls_main.c b/drivers/crypto/chelsio/chtls/chtls_main.c
index 635bb4b447fb..e6df5b95ed47 100644
--- a/drivers/crypto/chelsio/chtls/chtls_main.c
+++ b/drivers/crypto/chelsio/chtls/chtls_main.c
@@ -474,7 +474,8 @@ static int chtls_getsockopt(struct sock *sk, int level, int optname,
 	struct tls_context *ctx = tls_get_ctx(sk);
 
 	if (level != SOL_TLS)
-		return ctx->getsockopt(sk, level, optname, optval, optlen);
+		return ctx->sk_proto->getsockopt(sk, level,
+						 optname, optval, optlen);
 
 	return do_chtls_getsockopt(sk, optval, optlen);
 }
@@ -541,7 +542,8 @@ static int chtls_setsockopt(struct sock *sk, int level, int optname,
 	struct tls_context *ctx = tls_get_ctx(sk);
 
 	if (level != SOL_TLS)
-		return ctx->setsockopt(sk, level, optname, optval, optlen);
+		return ctx->sk_proto->setsockopt(sk, level,
+						 optname, optval, optlen);
 
 	return do_chtls_setsockopt(sk, optname, optval, optlen);
 }
diff --git a/include/net/tls.h b/include/net/tls.h
index ec3c3ed2c6c3..6dab6683e42f 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -275,16 +275,6 @@ struct tls_context {
 	struct proto *sk_proto;
 
 	void (*sk_destruct)(struct sock *sk);
-	void (*sk_proto_close)(struct sock *sk, long timeout);
-
-	int  (*setsockopt)(struct sock *sk, int level,
-			   int optname, char __user *optval,
-			   unsigned int optlen);
-	int  (*getsockopt)(struct sock *sk, int level,
-			   int optname, char __user *optval,
-			   int __user *optlen);
-	int  (*hash)(struct sock *sk);
-	void (*unhash)(struct sock *sk);
 
 	union tls_crypto_context crypto_send;
 	union tls_crypto_context crypto_recv;
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 277f7c209fed..2df1ae8b77fa 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -331,7 +331,7 @@ static void tls_sk_proto_close(struct sock *sk, long timeout)
 		tls_sw_strparser_done(ctx);
 	if (ctx->rx_conf == TLS_SW)
 		tls_sw_free_ctx_rx(ctx);
-	ctx->sk_proto_close(sk, timeout);
+	ctx->sk_proto->close(sk, timeout);
 
 	if (free_ctx)
 		tls_ctx_free(sk, ctx);
@@ -451,7 +451,8 @@ static int tls_getsockopt(struct sock *sk, int level, int optname,
 	struct tls_context *ctx = tls_get_ctx(sk);
 
 	if (level != SOL_TLS)
-		return ctx->getsockopt(sk, level, optname, optval, optlen);
+		return ctx->sk_proto->getsockopt(sk, level,
+						 optname, optval, optlen);
 
 	return do_tls_getsockopt(sk, optname, optval, optlen);
 }
@@ -609,7 +610,8 @@ static int tls_setsockopt(struct sock *sk, int level, int optname,
 	struct tls_context *ctx = tls_get_ctx(sk);
 
 	if (level != SOL_TLS)
-		return ctx->setsockopt(sk, level, optname, optval, optlen);
+		return ctx->sk_proto->setsockopt(sk, level, optname, optval,
+						 optlen);
 
 	return do_tls_setsockopt(sk, optname, optval, optlen);
 }
@@ -624,10 +626,7 @@ static struct tls_context *create_ctx(struct sock *sk)
 		return NULL;
 
 	rcu_assign_pointer(icsk->icsk_ulp_data, ctx);
-	ctx->setsockopt = sk->sk_prot->setsockopt;
-	ctx->getsockopt = sk->sk_prot->getsockopt;
-	ctx->sk_proto_close = sk->sk_prot->close;
-	ctx->unhash = sk->sk_prot->unhash;
+	ctx->sk_proto = sk->sk_prot;
 	return ctx;
 }
 
@@ -683,9 +682,6 @@ static int tls_hw_prot(struct sock *sk)
 
 			spin_unlock_bh(&device_spinlock);
 			tls_build_proto(sk);
-			ctx->hash = sk->sk_prot->hash;
-			ctx->unhash = sk->sk_prot->unhash;
-			ctx->sk_proto_close = sk->sk_prot->close;
 			ctx->sk_destruct = sk->sk_destruct;
 			sk->sk_destruct = tls_hw_sk_destruct;
 			ctx->rx_conf = TLS_HW_RECORD;
@@ -717,7 +713,7 @@ static void tls_hw_unhash(struct sock *sk)
 		}
 	}
 	spin_unlock_bh(&device_spinlock);
-	ctx->unhash(sk);
+	ctx->sk_proto->unhash(sk);
 }
 
 static int tls_hw_hash(struct sock *sk)
@@ -726,7 +722,7 @@ static int tls_hw_hash(struct sock *sk)
 	struct tls_device *dev;
 	int err;
 
-	err = ctx->hash(sk);
+	err = ctx->sk_proto->hash(sk);
 	spin_lock_bh(&device_spinlock);
 	list_for_each_entry(dev, &device_list, dev_list) {
 		if (dev->hash) {
@@ -816,7 +812,6 @@ static int tls_init(struct sock *sk)
 
 	ctx->tx_conf = TLS_BASE;
 	ctx->rx_conf = TLS_BASE;
-	ctx->sk_proto = sk->sk_prot;
 	update_sk_prot(sk, ctx);
 out:
 	write_unlock_bh(&sk->sk_callback_lock);
@@ -828,12 +823,10 @@ static void tls_update(struct sock *sk, struct proto *p)
 	struct tls_context *ctx;
 
 	ctx = tls_get_ctx(sk);
-	if (likely(ctx)) {
-		ctx->sk_proto_close = p->close;
+	if (likely(ctx))
 		ctx->sk_proto = p;
-	} else {
+	else
 		sk->sk_prot = p;
-	}
 }
 
 static int tls_get_info(const struct sock *sk, struct sk_buff *skb)
-- 
2.21.0

