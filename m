Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E476612392E
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 23:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbfLQWMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 17:12:42 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:40091 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726512AbfLQWMl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 17:12:41 -0500
Received: by mail-lf1-f68.google.com with SMTP id i23so144840lfo.7
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 14:12:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8aJo+Pqt93YpauF0t70ymnZLX9h+nAd22h2MN3t34OQ=;
        b=JBeHpRXoGu/DT/Cu71XEFK2Z4GaUTuJnx44VhnKw504MJzzKxJ5aXuY9d95JZzY7s7
         cZmXMws7+5sfRpZzpAUgwgg2mVjBbkVkEcZlAvc2OSp1HzmG4iNsLX0cTkbngz3QqkAC
         Hkxa3G7PeMcgfiqulJVg6gloawKtPPrpcRyaNApUGuexD81AmpXshejoAiGxC69mGkzi
         641Mb88j6JwoKXfQrIjD+wS5AkQUT0ss6ehWW8iYvCDxfJBdInKKp5uIEmfuxh1UWkwQ
         Ty8Pjqi76fber6W++sSIau2+w+A8+H4by+X75ZsdsWI+EO6QbT00C7RNpOwvJR/fuo32
         c9YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8aJo+Pqt93YpauF0t70ymnZLX9h+nAd22h2MN3t34OQ=;
        b=YpZBUA6OcDeHg6+uJj9qQzbfjmMiR4Kb94lDxLMyzENaKEWhUEr1nhvtxG2KW8+uWV
         ZUDua7ezvh0+mqJbmQTMDWJsIbAWqFK4s5hJl+7CSNP+gPbVnbk/i9MWoQKGepDFgr+b
         r6LXcfRG0OPzcWiVibuf8JeID2Kc6yLblWwr/bRMPTl/jC1XGopbLlPA7kn09Pk+cuc8
         jTLxaq3x6pisWI1R2H8P8te+nS7aCLwCJ4EeWYognc+Vrlim3tC6a/qvPvX98CG/yD4j
         2tR4oBv75Su/m14Da25EckmJNuwKmquIrpnh4b49Z0NaosUz/HG9qLp2nWhvwtMwou/z
         Mvig==
X-Gm-Message-State: APjAAAWNsU3uqQUrUhqlwK+DBrGccOQRz/GlAIHAZCepQOxG44+WGP/V
        BsIQXDr1dBA0PEwFAIDy9V9tjCyjr+w=
X-Google-Smtp-Source: APXvYqy0z4lkESRFOEW1dobs69AOd/DMi488dW0MfF3KYPnpD0gSJ0snNgOXqrQo4l3D3GUw500jVg==
X-Received: by 2002:ac2:5983:: with SMTP id w3mr4258957lfn.137.1576620759867;
        Tue, 17 Dec 2019 14:12:39 -0800 (PST)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id u9sm13333440lju.95.2019.12.17.14.12.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 14:12:39 -0800 (PST)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 2/3] net/tls: add helper for testing if socket is RX offloaded
Date:   Tue, 17 Dec 2019 14:12:01 -0800
Message-Id: <20191217221202.12611-3-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191217221202.12611-1-jakub.kicinski@netronome.com>
References: <20191217221202.12611-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is currently no way for driver to reliably check that
the socket it has looked up is in fact RX offloaded. Add
a helper. This allows drivers to catch misbehaving firmware.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 include/net/tls.h    | 9 +++++++++
 net/tls/tls_device.c | 5 +++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index df630f5fc723..bf9eb4823933 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -641,6 +641,7 @@ int tls_sw_fallback_init(struct sock *sk,
 #ifdef CONFIG_TLS_DEVICE
 void tls_device_init(void);
 void tls_device_cleanup(void);
+void tls_device_sk_destruct(struct sock *sk);
 int tls_set_device_offload(struct sock *sk, struct tls_context *ctx);
 void tls_device_free_resources_tx(struct sock *sk);
 int tls_set_device_offload_rx(struct sock *sk, struct tls_context *ctx);
@@ -649,6 +650,14 @@ void tls_device_rx_resync_new_rec(struct sock *sk, u32 rcd_len, u32 seq);
 void tls_offload_tx_resync_request(struct sock *sk, u32 got_seq, u32 exp_seq);
 int tls_device_decrypted(struct sock *sk, struct tls_context *tls_ctx,
 			 struct sk_buff *skb, struct strp_msg *rxm);
+
+static inline bool tls_is_sk_rx_device_offloaded(struct sock *sk)
+{
+	if (!sk_fullsock(sk) ||
+	    smp_load_acquire(&sk->sk_destruct) != tls_device_sk_destruct)
+		return false;
+	return tls_get_ctx(sk)->rx_conf == TLS_HW;
+}
 #else
 static inline void tls_device_init(void) {}
 static inline void tls_device_cleanup(void) {}
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index cd91ad812291..1ba5a92832bb 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -178,7 +178,7 @@ static void tls_icsk_clean_acked(struct sock *sk, u32 acked_seq)
  * socket and no in-flight SKBs associated with this
  * socket, so it is safe to free all the resources.
  */
-static void tls_device_sk_destruct(struct sock *sk)
+void tls_device_sk_destruct(struct sock *sk)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_offload_context_tx *ctx = tls_offload_ctx_tx(tls_ctx);
@@ -196,6 +196,7 @@ static void tls_device_sk_destruct(struct sock *sk)
 	if (refcount_dec_and_test(&tls_ctx->refcount))
 		tls_device_queue_ctx_destruction(tls_ctx);
 }
+EXPORT_SYMBOL_GPL(tls_device_sk_destruct);
 
 void tls_device_free_resources_tx(struct sock *sk)
 {
@@ -903,7 +904,7 @@ static void tls_device_attach(struct tls_context *ctx, struct sock *sk,
 		spin_unlock_irq(&tls_device_lock);
 
 		ctx->sk_destruct = sk->sk_destruct;
-		sk->sk_destruct = tls_device_sk_destruct;
+		smp_store_release(&sk->sk_destruct, tls_device_sk_destruct);
 	}
 }
 
-- 
2.23.0

