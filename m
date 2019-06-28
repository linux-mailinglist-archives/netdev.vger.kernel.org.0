Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBF2E5A76F
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 01:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbfF1XLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 19:11:55 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:35703 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbfF1XLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 19:11:55 -0400
Received: by mail-qt1-f195.google.com with SMTP id d23so8218111qto.2
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 16:11:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2GGeIMPVbIvAEOn4Fj1As0EgJBVo10thY3sM2u6TeiA=;
        b=tqO8+RaRUfBoEuk4eBrxOMpnmsr6Olh0qo2ZXmYm5tKzuSXYGtF7CmuPn3lrsf5WiD
         VAwhmED5EtQNGbqcXebZNLQbp/21iV14ti4+MmF2dJ47XlYtrky8XcAhdPkgp9+Pj8B7
         yEWCm87FxXayp5AQRW5YgKVUPPxjpn0hOb+6qI/d/hcNxuNEW+r7OhOvNHU21XNx3cpn
         YGpvlmbTUIKMRFg5EL/1GP/CoSnA+DJPuxafo8Jn/ejLgg8g8rgmQxg2xQhsQuWZBhM9
         Dnq8b+2XX6r289NNpJhbpR36hxGD2kanWIbnQE3h6JEEdIL3mDpoUywAU2PfNQLK5jvM
         moPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2GGeIMPVbIvAEOn4Fj1As0EgJBVo10thY3sM2u6TeiA=;
        b=PgCcmKN7u1crsrZKwP5e5VeUv4aRBwOnjFO7BT9Iq2V7IiuSTHggGhmBzZ4UshVyDk
         IuNbobB4bfZZHoNDqQGgnzBaG0CBpa81H6FZlcYkZfkQX4Hml2OnD6cKnlq4tDSzNa3I
         ZUXfhfrgExwYUY8u3k/Jj7ibwTVvPOYdsKJjqQjMoKmdAVDSYqsbUBfxbsUpKv+TXm64
         FEx0sRWyEIKZJ/1F2Fkkt70RGR0q6udRikQ1MnHPVXdbT7oRp3g0FzU7jxvPp9LHWyw7
         6oDMF79ZZGUn9S9YlF4DHxDvNkrvcwtlvodPNm0Zo+JoSJdOkpJjb1rDKTse/7cBdlrY
         3/+A==
X-Gm-Message-State: APjAAAXN+N8wqfW71JHslJFAiJdJ5dHBb5d6klUhDraa4C71ShvY5l89
        z/5puHhL1AXclX1i5rEWA1itrA==
X-Google-Smtp-Source: APXvYqzNspNxSqnxLyvsq72j9Sj8ohCQo3s9jNCC6VXVuYTKjZF82OQoUV825a5F1zoS4TxMjsAL0w==
X-Received: by 2002:a0c:ae5a:: with SMTP id z26mr10378549qvc.65.1561763514449;
        Fri, 28 Jun 2019 16:11:54 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id s8sm1617730qkg.64.2019.06.28.16.11.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Jun 2019 16:11:53 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net, john.fastabend@gmail.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com, sd@queasysnail.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net] net/tls: make sure offload also gets the keys wiped
Date:   Fri, 28 Jun 2019 16:11:39 -0700
Message-Id: <20190628231139.16842-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 86029d10af18 ("tls: zero the crypto information from tls_context
before freeing") added memzero_explicit() calls to clear the key material
before freeing struct tls_context, but it missed tls_device.c has its
own way of freeing this structure. Replace the missing free.

Fixes: 86029d10af18 ("tls: zero the crypto information from tls_context before freeing")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
John, this will definitely conflict with your fix, but I'm not sure
how close we are to closure, so perhaps it's not the worst idea to
do this small fix and at least have all the contexts freed by a
common helper? I'm happy to drop this if you prefer.
---
 include/net/tls.h    | 1 +
 net/tls/tls_device.c | 2 +-
 net/tls/tls_main.c   | 4 ++--
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index 53d96bca220d..889df0312cd1 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -313,6 +313,7 @@ struct tls_offload_context_rx {
 	(ALIGN(sizeof(struct tls_offload_context_rx), sizeof(void *)) + \
 	 TLS_DRIVER_STATE_SIZE)
 
+void tls_ctx_free(struct tls_context *ctx);
 int wait_on_pending_writer(struct sock *sk, long *timeo);
 int tls_sk_query(struct sock *sk, int optname, char __user *optval,
 		int __user *optlen);
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 397990407ed6..eb8f24f420f0 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -61,7 +61,7 @@ static void tls_device_free_ctx(struct tls_context *ctx)
 	if (ctx->rx_conf == TLS_HW)
 		kfree(tls_offload_ctx_rx(ctx));
 
-	kfree(ctx);
+	tls_ctx_free(ctx);
 }
 
 static void tls_device_gc_task(struct work_struct *work)
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index e2b69e805d46..4674e57e66b0 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -251,7 +251,7 @@ static void tls_write_space(struct sock *sk)
 	ctx->sk_write_space(sk);
 }
 
-static void tls_ctx_free(struct tls_context *ctx)
+void tls_ctx_free(struct tls_context *ctx)
 {
 	if (!ctx)
 		return;
@@ -643,7 +643,7 @@ static void tls_hw_sk_destruct(struct sock *sk)
 
 	ctx->sk_destruct(sk);
 	/* Free ctx */
-	kfree(ctx);
+	tls_ctx_free(ctx);
 	icsk->icsk_ulp_data = NULL;
 }
 
-- 
2.21.0

