Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9517336687
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 23:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbfFEVMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 17:12:17 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:34051 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbfFEVMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 17:12:16 -0400
Received: by mail-qt1-f194.google.com with SMTP id m29so276596qtu.1
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 14:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7Duh1yTQlft3V3BU7ZiPmeLdAPdvQ22o7I+d26Xnth4=;
        b=TWZfANphhcgt9jUDwkjC5pC6IDmG7UntcY5/fe5koK6fjA+R8Pl+Hk0xMbnAHo3Qdl
         Cn64ejma7ojLIxSSTwlogCg9h6r09xF4AxACyvjb/9kS7kwmZTHQRhvVYabEzBKHCD+k
         EDU6vfOQsu6+9+QcYRAKZCTJuXcmDMhTIGJdzeRxIzyDrUFmBtJD//r6celXiBRQD4VF
         7XTP8pvtQEBAPs8KB77LCfqyNfFQuzOyWLORopLYC8D87SSGNMAWkmdFREkdDzZIFdsh
         +H5AUzHnzchAqBJOdobFpKNOVKjB1wYQpITdCJ1sWk79DGlnjUdeckQH0c5GNnuL5uNN
         OxpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7Duh1yTQlft3V3BU7ZiPmeLdAPdvQ22o7I+d26Xnth4=;
        b=NHs7yWsOPNdbCJurDdOqeRitzPne1PGl80QQcrLBuylrTb3sCxxfz09au0lXMABoP/
         5mUfDmJdRlbx9Zch8zfVLP6QKfdYToNkSJOTnOted0DomzGMNJ4E1FzpQq74JZ4kdEVF
         GL4QVfHE9y3aTVDEQmPyErkJ7PrX+S+3USAk7dEUErLP4wKztxc6/6R4HTSH+edf6HQB
         zb0Ys4QN9UST03ZZXkGjXO1z2OsaazwQf/QMAMn4LdcKN/YIxgLarW/4TTAStfKCUkiD
         HUrRSL2HnecTVU6L4y/S8bKegWINNJmF0btJeNhmqAKEk3zqt14vJK1Ha5ylybONZBS5
         aP0w==
X-Gm-Message-State: APjAAAW/sTYsWWk+IFJVDZ9joeByqWB4yVxGk9KLBppwYWxTCWPrMI0l
        ABDrkqURt/0TSZ76lGEMfOwNYg==
X-Google-Smtp-Source: APXvYqw/0wq9WxEq52WqgLj2y9uoaFJnAGBoQFZSwIFp9n9uTZi4MH6GzHYBWatJfo8BCG0JtfeAYA==
X-Received: by 2002:a0c:96c4:: with SMTP id b4mr33815557qvd.2.1559769135518;
        Wed, 05 Jun 2019 14:12:15 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t20sm2933807qtr.7.2019.06.05.14.12.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Jun 2019 14:12:15 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net-next 09/13] net/tls: simplify driver context retrieval
Date:   Wed,  5 Jun 2019 14:11:39 -0700
Message-Id: <20190605211143.29689-10-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190605211143.29689-1-jakub.kicinski@netronome.com>
References: <20190605211143.29689-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently drivers have to ensure the alignment of their tls state
structure, which leads to unnecessary layers of getters and
encapsulated structures in each driver.

Simplify all this by marking the driver state as aligned (driver_state
members are currently aligned, so no hole is added, besides ALIGN in
TLS_OFFLOAD_CONTEXT_SIZE_RX/TX would reserve this extra space, anyway.)
With that we can add a common accessor to the core.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 include/net/tls.h | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index 3094db5398a9..3da0d941e729 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -40,6 +40,7 @@
 #include <linux/socket.h>
 #include <linux/tcp.h>
 #include <linux/skmsg.h>
+#include <linux/netdevice.h>
 
 #include <net/tcp.h>
 #include <net/strparser.h>
@@ -197,7 +198,7 @@ struct tls_offload_context_tx {
 
 	struct scatterlist sg_tx_data[MAX_SKB_FRAGS];
 	void (*sk_destruct)(struct sock *sk);
-	u8 driver_state[];
+	u8 driver_state[] __aligned(8);
 	/* The TLS layer reserves room for driver specific state
 	 * Currently the belief is that there is not enough
 	 * driver specific state to justify another layer of indirection
@@ -206,8 +207,7 @@ struct tls_offload_context_tx {
 };
 
 #define TLS_OFFLOAD_CONTEXT_SIZE_TX                                            \
-	(ALIGN(sizeof(struct tls_offload_context_tx), sizeof(void *)) +        \
-	 TLS_DRIVER_STATE_SIZE_TX)
+	(sizeof(struct tls_offload_context_tx) + TLS_DRIVER_STATE_SIZE_TX)
 
 struct cipher_context {
 	char *iv;
@@ -302,7 +302,7 @@ struct tls_offload_context_rx {
 	/* sw must be the first member of tls_offload_context_rx */
 	struct tls_sw_context_rx sw;
 	atomic64_t resync_req;
-	u8 driver_state[];
+	u8 driver_state[] __aligned(8);
 	/* The TLS layer reserves room for driver specific state
 	 * Currently the belief is that there is not enough
 	 * driver specific state to justify another layer of indirection
@@ -311,8 +311,7 @@ struct tls_offload_context_rx {
 };
 
 #define TLS_OFFLOAD_CONTEXT_SIZE_RX					\
-	(ALIGN(sizeof(struct tls_offload_context_rx), sizeof(void *)) + \
-	 TLS_DRIVER_STATE_SIZE_RX)
+	(sizeof(struct tls_offload_context_rx) + TLS_DRIVER_STATE_SIZE_RX)
 
 int wait_on_pending_writer(struct sock *sk, long *timeo);
 int tls_sk_query(struct sock *sk, int optname, char __user *optval,
@@ -557,6 +556,23 @@ tls_offload_ctx_rx(const struct tls_context *tls_ctx)
 	return (struct tls_offload_context_rx *)tls_ctx->priv_ctx_rx;
 }
 
+#if IS_ENABLED(CONFIG_TLS_DEVICE)
+static inline void *__tls_driver_ctx(struct tls_context *tls_ctx,
+				     enum tls_offload_ctx_dir direction)
+{
+	if (direction == TLS_OFFLOAD_CTX_DIR_TX)
+		return tls_offload_ctx_tx(tls_ctx)->driver_state;
+	else
+		return tls_offload_ctx_rx(tls_ctx)->driver_state;
+}
+
+static inline void *
+tls_driver_ctx(const struct sock *sk, enum tls_offload_ctx_dir direction)
+{
+	return __tls_driver_ctx(tls_get_ctx(sk), direction);
+}
+#endif
+
 /* The TLS context is valid until sk_destruct is called */
 static inline void tls_offload_rx_resync_request(struct sock *sk, __be32 seq)
 {
-- 
2.21.0

