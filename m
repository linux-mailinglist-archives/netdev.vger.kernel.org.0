Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0105531934
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 05:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbfFADMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 23:12:25 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:46527 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726547AbfFADMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 23:12:24 -0400
Received: by mail-qk1-f195.google.com with SMTP id a132so7590826qkb.13
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 20:12:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ibLhAGS11wNI6Ucgk/hwmf5LyhCFXZ4AAXTO9FJKPlA=;
        b=BDhzGOLBH9UJ5DPx/U84WhlfCJEcOaKWaI9vXG84hsGkEJsXIZ58p0vXPnKwoINikA
         JIXefN7hK48R2E8M95t/Be+IohxtyEOEl7aMjypHwK/7g8nW8k+fo4C7Tz3LDyBOFVwG
         AsgJ/CqaW4QnoZWFQJDawYJbFe4GNhfmGiXJaJFHYWejlsDFqvC+be6ogjH3tFsBLjBS
         S04xkXq8/SmfrGfipbxU8cOjyYJgbDevJa/XGaJKFggPmII/j26HYrp/3pSc8hKD3YOJ
         sDtLTkfUFxvBQPxiSH/oOpq4UyNYFfBgczQAU5QNr9+IruPeSn0+jW0+tcK9gOnEDhja
         1Tcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ibLhAGS11wNI6Ucgk/hwmf5LyhCFXZ4AAXTO9FJKPlA=;
        b=nRFg0OZgOe2600y9cEQK0mk8qxVslYTUpOO3jFuTCPfpJ/0nsJ0/gaBBWasUM0MPxo
         cUlGYLv0PoUhHY8xjOQos5C84iUv4u6OIUtSqaHnLb8Kb+o6/s702SAjBzqzVl6aeEcN
         lqCnkLCvj3I88P7YJe2DV4r5D4lAKsVCTTipxWyBEGrk98O8UCZLPkRgi7L0TUeGtyQH
         8kdMD/j/juVyxnC15/YBmzXyW81fHaSKLgeU/XkCfWjrfI27fWIpbRaOa4hjo6yDD9pr
         2whfQP0sybZM4mpuaKultd5eSCErVhD7S7WjCInOF2OXaaHxs10U2kD3F5UvXn+D1XRG
         mX8A==
X-Gm-Message-State: APjAAAWgeXyCu8BE4BJXsU1Yf/EdB3C/ZKngcEx0fbNUkWIVOG7lyPgs
        r05JJmCyX/GFe3EVHFg+zhctIg==
X-Google-Smtp-Source: APXvYqxaEy8QL9EHuFuCPQ1las/kCepr9kcjqmpDKu3oDHZd8bL82fMDaB8lMeDMd90nSDXf0wZRFg==
X-Received: by 2002:a05:620a:102d:: with SMTP id a13mr11368279qkk.268.1559358743206;
        Fri, 31 May 2019 20:12:23 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id j26sm5354267qtj.70.2019.05.31.20.12.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 20:12:22 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net 2/2] net/tls: replace the sleeping lock around RX resync with a bit lock
Date:   Fri, 31 May 2019 20:12:01 -0700
Message-Id: <20190601031201.32027-3-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190601031201.32027-1-jakub.kicinski@netronome.com>
References: <20190601031201.32027-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 38030d7cb779 ("net/tls: avoid NULL-deref on resync during device removal")
tried to fix a potential NULL-dereference by taking the
context rwsem.  Unfortunately the RX resync may get called
from soft IRQ, so we can't use the rwsem to protect from
the device disappearing.  Because we are guaranteed there
can be only one resync at a time (it's called from strparser)
use a bit to indicate resync is busy and make device
removal wait for the bit to get cleared.

Note that there is a leftover "flags" field in struct
tls_context already.

Fixes: 4799ac81e52a ("tls: Add rx inline crypto offload")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 include/net/tls.h    |  4 ++++
 net/tls/tls_device.c | 26 +++++++++++++++++++++-----
 2 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index 39ea62f0c1f6..4a55ce6a303f 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -209,6 +209,10 @@ struct tls_offload_context_tx {
 	(ALIGN(sizeof(struct tls_offload_context_tx), sizeof(void *)) +        \
 	 TLS_DRIVER_STATE_SIZE)
 
+enum tls_context_flags {
+	TLS_RX_SYNC_RUNNING = 0,
+};
+
 struct cipher_context {
 	char *iv;
 	char *rec_seq;
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 49b3a2ff8ef3..ed1c5db88eb0 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -550,6 +550,19 @@ void tls_device_write_space(struct sock *sk, struct tls_context *ctx)
 	}
 }
 
+static void tls_device_resync_rx(struct tls_context *tls_ctx,
+				 struct sock *sk, u32 seq, u64 rcd_sn)
+{
+	struct net_device *netdev;
+
+	if (WARN_ON(test_and_set_bit(TLS_RX_SYNC_RUNNING, &tls_ctx->flags)))
+		return;
+	netdev = READ_ONCE(tls_ctx->netdev);
+	if (netdev)
+		netdev->tlsdev_ops->tls_dev_resync_rx(netdev, sk, seq, rcd_sn);
+	clear_bit_unlock(TLS_RX_SYNC_RUNNING, &tls_ctx->flags);
+}
+
 void handle_device_resync(struct sock *sk, u32 seq, u64 rcd_sn)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
@@ -568,10 +581,10 @@ void handle_device_resync(struct sock *sk, u32 seq, u64 rcd_sn)
 	is_req_pending = resync_req;
 
 	if (unlikely(is_req_pending) && req_seq == seq &&
-	    atomic64_try_cmpxchg(&rx_ctx->resync_req, &resync_req, 0))
-		netdev->tlsdev_ops->tls_dev_resync_rx(netdev, sk,
-						      seq + TLS_HEADER_SIZE - 1,
-						      rcd_sn);
+	    atomic64_try_cmpxchg(&rx_ctx->resync_req, &resync_req, 0)) {
+		seq += TLS_HEADER_SIZE - 1;
+		tls_device_resync_rx(tls_ctx, sk, seq, rcd_sn);
+	}
 }
 
 static int tls_device_reencrypt(struct sock *sk, struct sk_buff *skb)
@@ -972,7 +985,10 @@ static int tls_device_down(struct net_device *netdev)
 		if (ctx->rx_conf == TLS_HW)
 			netdev->tlsdev_ops->tls_dev_del(netdev, ctx,
 							TLS_OFFLOAD_CTX_DIR_RX);
-		ctx->netdev = NULL;
+		WRITE_ONCE(ctx->netdev, NULL);
+		smp_mb__before_atomic(); /* pairs with test_and_set_bit() */
+		while (test_bit(TLS_RX_SYNC_RUNNING, &ctx->flags))
+			usleep_range(10, 200);
 		dev_put(netdev);
 		list_del_init(&ctx->list);
 
-- 
2.21.0

