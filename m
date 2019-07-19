Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB9D6EA20
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 19:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729812AbfGSRbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 13:31:03 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:36923 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728578AbfGSRbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 13:31:03 -0400
Received: by mail-qk1-f193.google.com with SMTP id d15so23794254qkl.4
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 10:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PxpD30bpPCGGJ4F7YV8cDsC+X9IUdttLkhSct6iN3GE=;
        b=WLVMRXhw4bFFS5WOaJgEQ+OYwCP+1ouX5JjhRqiTGoW8i5cYkGT7j+QkTRfQT0HUBZ
         9pQrIvZnThYc4EpcvS53JFuIaC1dtZV56O/BSKd9Lc6nakKbmWQRG/O3eAkkgyBI0jP9
         FKxbILueNX9+nGDlAcgy+FmraRpLeoB8OOkpCUPTCxIIAUiGjm+jLllzWD/1tvLoRUAS
         dQgMIndbLlWcLoMQ3ZdKTy+gESLRMI/2CQDd/ZMEUn7/1KYnJqFcpbkSYLs0hb5mplAe
         kZi9Vh5aB5bgU6DPraWqtWtB65jiGLhz/JV8n9z1yCyNtDTi6UTpWeTncf0RosZVj5q5
         B7FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PxpD30bpPCGGJ4F7YV8cDsC+X9IUdttLkhSct6iN3GE=;
        b=CT3EJVDXdTYCQocy6YuTinaPcsNl3qCvibVKTm/LrHFRN8gikIDL4ejIrK0ldBaAek
         9pfL4hoDA46ZY44YGI9xnciL3XCiNq1KtWyDAv73HgXUQFoqbrodWLc3go/Oldt/oyVx
         fC9rY4LfzVw5vvoWQQmk0sMo40kur0Nx5FBpDNQRTPQJ91zF6Hk7TAKyJXcH6t1jyi8s
         R8sWJ1/6vUaE1Voul2TPw7COD88Z7C3X9fdeXxVMU0oC7xTLkJ0cDJcw8cuw6LU7khIF
         9JZkbkU8XD3FFgFvF0G/6zwyajf8Vg6XB6BbA5ahkQHRaxU5vt+6j2gq8x/UtjJwM2BQ
         LRJg==
X-Gm-Message-State: APjAAAXRVwpJtijdTU+RdmkKN0nBZvZyp2nfKdoQ0Ddiuhqg4TIGa5Et
        LebXNtK9raLLdFe/XJbYO0batA==
X-Google-Smtp-Source: APXvYqxulbRocYK9owq5U4idheIXNAMD7hqm01jKk/Uda1bP35Njt1tpPDu0lKN0KNeTbvB7QufVpA==
X-Received: by 2002:a37:f50f:: with SMTP id l15mr37721298qkk.326.1563557462184;
        Fri, 19 Jul 2019 10:31:02 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y3sm15568509qtj.46.2019.07.19.10.31.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Jul 2019 10:31:01 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     john.fastabend@gmail.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     edumazet@google.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH bpf v4 01/14] net/tls: don't arm strparser immediately in tls_set_sw_offload()
Date:   Fri, 19 Jul 2019 10:29:14 -0700
Message-Id: <20190719172927.18181-2-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190719172927.18181-1-jakub.kicinski@netronome.com>
References: <20190719172927.18181-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In tls_set_device_offload_rx() we prepare the software context
for RX fallback and proceed to add the connection to the device.
Unfortunately, software context prep includes arming strparser
so in case of a later error we have to release the socket lock
to call strp_done().

In preparation for not releasing the socket lock half way through
callbacks move arming strparser into a separate function.
Following patches will make use of that.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 include/net/tls.h    |  1 +
 net/tls/tls_device.c |  1 +
 net/tls/tls_main.c   |  8 +++++---
 net/tls/tls_sw.c     | 19 ++++++++++++-------
 4 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index 584609174fe0..43f551cd508b 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -355,6 +355,7 @@ int tls_sk_attach(struct sock *sk, int optname, char __user *optval,
 		  unsigned int optlen);
 
 int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx);
+void tls_sw_strparser_arm(struct sock *sk, struct tls_context *ctx);
 int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size);
 int tls_sw_sendpage(struct sock *sk, struct page *page,
 		    int offset, size_t size, int flags);
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 7c0b2b778703..4d67d72f007c 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -1045,6 +1045,7 @@ int tls_set_device_offload_rx(struct sock *sk, struct tls_context *ctx)
 	rc = tls_set_sw_offload(sk, ctx, 0);
 	if (rc)
 		goto release_ctx;
+	tls_sw_strparser_arm(sk, ctx);
 
 	rc = netdev->tlsdev_ops->tls_dev_add(netdev, sk, TLS_OFFLOAD_CTX_DIR_RX,
 					     &ctx->crypto_recv.info,
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 4674e57e66b0..85a9d7d57b32 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -526,6 +526,8 @@ static int do_tls_setsockopt_conf(struct sock *sk, char __user *optval,
 		{
 #endif
 			rc = tls_set_sw_offload(sk, ctx, 1);
+			if (rc)
+				goto err_crypto_info;
 			conf = TLS_SW;
 		}
 	} else {
@@ -537,13 +539,13 @@ static int do_tls_setsockopt_conf(struct sock *sk, char __user *optval,
 		{
 #endif
 			rc = tls_set_sw_offload(sk, ctx, 0);
+			if (rc)
+				goto err_crypto_info;
+			tls_sw_strparser_arm(sk, ctx);
 			conf = TLS_SW;
 		}
 	}
 
-	if (rc)
-		goto err_crypto_info;
-
 	if (tx)
 		ctx->tx_conf = conf;
 	else
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 53b4ad94e74a..f58a8ffc2a9c 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2160,6 +2160,18 @@ void tls_sw_write_space(struct sock *sk, struct tls_context *ctx)
 	}
 }
 
+void tls_sw_strparser_arm(struct sock *sk, struct tls_context *tls_ctx)
+{
+	struct tls_sw_context_rx *rx_ctx = tls_sw_ctx_rx(tls_ctx);
+
+	write_lock_bh(&sk->sk_callback_lock);
+	rx_ctx->saved_data_ready = sk->sk_data_ready;
+	sk->sk_data_ready = tls_data_ready;
+	write_unlock_bh(&sk->sk_callback_lock);
+
+	strp_check_rcv(&rx_ctx->strp);
+}
+
 int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
@@ -2357,13 +2369,6 @@ int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx)
 		cb.parse_msg = tls_read_size;
 
 		strp_init(&sw_ctx_rx->strp, sk, &cb);
-
-		write_lock_bh(&sk->sk_callback_lock);
-		sw_ctx_rx->saved_data_ready = sk->sk_data_ready;
-		sk->sk_data_ready = tls_data_ready;
-		write_unlock_bh(&sk->sk_callback_lock);
-
-		strp_check_rcv(&sw_ctx_rx->strp);
 	}
 
 	goto out;
-- 
2.21.0

