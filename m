Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E409CCDAE0
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 06:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbfJGEKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 00:10:11 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:38354 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbfJGEKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 00:10:10 -0400
Received: by mail-qk1-f193.google.com with SMTP id u186so11377279qkc.5
        for <netdev@vger.kernel.org>; Sun, 06 Oct 2019 21:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xMGwTTagIDB2tCCdyjwf0ssuMN1HS/OhgUwuxSUsSdQ=;
        b=0p1joPENYDSovbk0Ibt/i01GXpl1+Vt5XAG0+zYYhMe3BUUiCFLOo8in5+VC+b1oHV
         uULYLrG08hHjSwVqdpuHDvlJ5lvTELzoWKc8pqjXYuv318fShRrS9vyy0fkc/6VVXdRZ
         mqBVndvamlNkDlYYkZ7mfD65rzeuFYqpJ2N+CzQLi9UQ7Ri9MU1JElKtwmRDgh7j9JTe
         Nu5ruTDyGT7qjcTnz6IZ7ozAMKzDBK1+RirdhqwQDiTCMr/+86T/i4t+Sb0wnX/joyGA
         FF5u1lSWTsqfb7XrCpUl/fHxM7lEbW40+NteAdnUIRs+mWge+gm1NxaPDh4Pq/JaJFja
         awhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xMGwTTagIDB2tCCdyjwf0ssuMN1HS/OhgUwuxSUsSdQ=;
        b=Pl+noMxYENZ6bHkuMR5hAYjuVEtWGHHsrfNDXartT4UZW05Di/NJCTCWjV0lJGJDQQ
         AgfOSL6JkU5j1vEdejiq8qrmyNMQxinULJI+oXk7xoHAiwI0n56o0ITh5+exQliNFNI6
         i2NAQdP1Efgl67pyLXY3oF+zm+jVSJ4VdI9aGf4ezOJVz/h+EjkdT5b8YeGacwmscSVW
         Ayz2r7Qc5mnAdqBx9ulu2JERsOeUGk48Jn4QGePV0oVdtZG6+Aq/f0QN1Y9avzTFtz7Q
         lIIBAqYhUVUDRqd8rKztT1bhkEiuQtiBj1/C1anQfgYNTfr703t4MS0acxu646CZQ3Bz
         wjSw==
X-Gm-Message-State: APjAAAU6z+1sPYrBKD+XVPovy9MIOWcCrM3KRXDddXoFfrz+31tQjx5H
        XX5iFpasWP3aH6dZoaT0Z/s0zQ==
X-Google-Smtp-Source: APXvYqyR6DImIwQG0Yls9fLp4v71s8AmOFaxQs8hVuOCzEXEhXtPYvFEpU3OQIWy6AIjyKWKOzP4hg==
X-Received: by 2002:a05:620a:250:: with SMTP id q16mr21793876qkn.376.1570421408098;
        Sun, 06 Oct 2019 21:10:08 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y22sm3796058qka.59.2019.10.06.21.10.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Oct 2019 21:10:07 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        davejwatson@fb.com, borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net-next 5/6] net/tls: store async_capable on a single bit
Date:   Sun,  6 Oct 2019 21:09:31 -0700
Message-Id: <20191007040932.26395-6-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191007040932.26395-1-jakub.kicinski@netronome.com>
References: <20191007040932.26395-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Store async_capable on a single bit instead of a full integer
to save space.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
---
 include/net/tls.h | 4 ++--
 net/tls/tls_sw.c  | 5 +++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index b809f2362049..97eae7271a67 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -136,7 +136,7 @@ struct tls_sw_context_tx {
 	struct list_head tx_list;
 	atomic_t encrypt_pending;
 	int async_notify;
-	int async_capable;
+	u8 async_capable:1;
 
 #define BIT_TX_SCHEDULED	0
 #define BIT_TX_CLOSING		1
@@ -152,7 +152,7 @@ struct tls_sw_context_rx {
 
 	struct sk_buff *recv_pkt;
 	u8 control;
-	int async_capable;
+	u8 async_capable:1;
 	bool decrypted;
 	atomic_t decrypt_pending;
 	bool async_notify;
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 954f451dcc57..c006b587a7db 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2391,10 +2391,11 @@ int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx)
 		tfm = crypto_aead_tfm(sw_ctx_rx->aead_recv);
 
 		if (crypto_info->version == TLS_1_3_VERSION)
-			sw_ctx_rx->async_capable = false;
+			sw_ctx_rx->async_capable = 0;
 		else
 			sw_ctx_rx->async_capable =
-				tfm->__crt_alg->cra_flags & CRYPTO_ALG_ASYNC;
+				!!(tfm->__crt_alg->cra_flags &
+				   CRYPTO_ALG_ASYNC);
 
 		/* Set up strparser */
 		memset(&cb, 0, sizeof(cb));
-- 
2.21.0

