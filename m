Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ABB769D07
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 22:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731381AbfGOUtL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 16:49:11 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:46021 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729505AbfGOUtL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 16:49:11 -0400
Received: by mail-oi1-f195.google.com with SMTP id m206so13766540oib.12;
        Mon, 15 Jul 2019 13:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=nSxP56LyPb7uTkprbb9AoFVApYUjT+yRCfgItnmRVaY=;
        b=EDVZnwufWLPKvZS0rBXbtuOw9zeeVp9qakaGl3i7eLow21u290qrYQyOiut8GjnCNa
         aFRacGR35cQ5UCZQprR5G6qt/za0fnt0we7Pu1OYJ6bwgPj6c09c5BRtXfmo+jsB/dXj
         J/Ma7KOATRGzcvRRg3J8QukvVGDP2J29FI5Iav8Oqqb0fCHv9Yyf4Hsyy2AoGNsDrQ65
         m4iOyrWNe3H+c3C0SeyXumOVhjcvvBH1a9mnbU6ER++AqxIwM+uAFi9+DHQ/JCMoJMi4
         e6lDasv0vHJYDIs04mic1Ci01qHI2IV0De+VHl9vs9wLza9ujCdMLoOh3vtsqi4GjCDN
         ioeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=nSxP56LyPb7uTkprbb9AoFVApYUjT+yRCfgItnmRVaY=;
        b=WSFCUeaEkHunJdEIeZgajzdom9VrtHYYPWp7eA9J6s39E4Z+VdsJMaKjy0f4VBrtT5
         IMgJtJd+cR6wrBg8hRKLeAQeLmsbABfnusdBtWLJxlY3gqE10wj1qi0Zk96cwmuUpDug
         vo4d9DxzaVU0dHko18SjLGz1tZfkOOUu+Qc7B4WMKSWmz/q6eo8tWRLxarFFuMUnpk56
         pP3bdYXk/iycetEjKAHT2Cs/Ul2OSLELFaLsQz5PpSnma2idvNK4IIem56lDp+UO5GbN
         2RLkVMCrUohpL5nAv+kjfOBAKvzVKfLcCQnOFpLSda01MdFHgIDS5BYtAMKnIVxdP73I
         xhbQ==
X-Gm-Message-State: APjAAAUEzw6Npv9den9bsSBlD3Tz/I8uB2NbJtKpmgEY6TqkpyqV1Wsh
        wv7oHQCxpxiJGcD89+K/uA8=
X-Google-Smtp-Source: APXvYqwaxu1O0DA8Sdd85cZC/Qwryb6pCpgNVymtAKSzzSF9Av+aUUq0KOZVaI2mV8K3gpYI0zTcRA==
X-Received: by 2002:aca:2119:: with SMTP id 25mr12776336oiz.48.1563223750585;
        Mon, 15 Jul 2019 13:49:10 -0700 (PDT)
Received: from [127.0.1.1] ([99.0.85.34])
        by smtp.gmail.com with ESMTPSA id g93sm7261088otb.39.2019.07.15.13.49.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 13:49:10 -0700 (PDT)
Subject: [bpf PATCH v3 1/8] net/tls: don't arm strparser immediately in
 tls_set_sw_offload()
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub.kicinski@netronome.com, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, edumazet@google.com,
        john.fastabend@gmail.com, bpf@vger.kernel.org
Date:   Mon, 15 Jul 2019 13:49:09 -0700
Message-ID: <156322374898.18678.12650354854448590855.stgit@john-XPS-13-9370>
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

From: Jakub Kicinski <jakub.kicinski@netronome.com>

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
 include/net/tls.h    |    1 +
 net/tls/tls_device.c |    1 +
 net/tls/tls_main.c   |    8 +++++---
 net/tls/tls_sw.c     |   19 ++++++++++++-------
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

