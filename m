Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAFF635018
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 21:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbfFDTA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 15:00:28 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:42307 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbfFDTA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 15:00:28 -0400
Received: by mail-qt1-f193.google.com with SMTP id s15so15044605qtk.9
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 12:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vbJ7SCqGGSjXYt9QQ9j/Hd7Qvup/mYxJM3COaIdNFaM=;
        b=qP4MnIarN1ha2u92usi/Z5FWaQ2S25EERi5/8o7yJ20kdfjkEDqrwq7uhx9kBzPNqV
         XdbA5QGlvOYGWIlhZXgVXDDf5n7cvjY970Fz83pcD1f+a7RF6z89wki4C8uv8VzA4jCJ
         NNtDqqZW/886LqDSTeK2tF6HkKWjDLfoiUVY2goBsdrMgWY9Z1ec1FJJQWsKuPhMvrnl
         9KByUxqBOczXOMkkdXPlL/fuoO60HMmE3zov5iKvn8jXZxBI0qr4SZrTSwKmISNUBLB5
         RTvxVvbY3v81179QsNlYelriYhGbBB3VVtWGsLWfr6+Gmr5IgmMQJBz/ZtPQ4mBQeA20
         T3Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vbJ7SCqGGSjXYt9QQ9j/Hd7Qvup/mYxJM3COaIdNFaM=;
        b=JN/ItQdGG1IY+hs4I9+7oR1ZR6bi2fEm+6DYSYP2zX6t8psEmXlrPygLv/GDQwPnGl
         ONsl3qa8vojtBHSJszgYJOZmt8cRfye2Q4I3MTf6917qE91zM0v+XUYOVUzdTr+aPYh4
         Z8grnmYpCAw/jm3eiaEafid9knfdnhrGdhAT1QgimnN8PZE8fVOENEj2Kv0jQ2dzXoX0
         xDOndK6xFrLIhkuM9eovukYzFbypSawaFx4KKHe8zKhBhg0dzn5KFnIU+c58bxYwHaAm
         NHxyFLKkM56BNOdE65qtp4v/pI+ew7AwSeQHqPZsHB8vRtRsUHg+RV0ng8el8ZoXPSAG
         ytDg==
X-Gm-Message-State: APjAAAUeZQgFYheac9H5iAwWLBGEfx+JAqIPaG9OjmTKpnuID3D80QzH
        cpn5oBYfoT+C0vsSqdvLcr4hqQ==
X-Google-Smtp-Source: APXvYqzKdOWwaQrW6ZOvQJ8JtcLr29mFi1HIRYONJJiVhnjEDhXtzta4MG0NlXpXcD8Q0ii/9KIOEw==
X-Received: by 2002:ac8:68e:: with SMTP id f14mr16761055qth.366.1559674826952;
        Tue, 04 Jun 2019 12:00:26 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id e66sm11011893qtb.55.2019.06.04.12.00.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 12:00:26 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net v2 2/2] net/tls: replace the sleeping lock around RX resync with a bit lock
Date:   Tue,  4 Jun 2019 12:00:12 -0700
Message-Id: <20190604190012.6327-3-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190604190012.6327-1-jakub.kicinski@netronome.com>
References: <20190604190012.6327-1-jakub.kicinski@netronome.com>
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
 net/tls/tls_device.c | 27 +++++++++++++++++++++------
 2 files changed, 25 insertions(+), 6 deletions(-)

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
index 49b3a2ff8ef3..1f9cf57d9754 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -550,10 +550,22 @@ void tls_device_write_space(struct sock *sk, struct tls_context *ctx)
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
-	struct net_device *netdev = tls_ctx->netdev;
 	struct tls_offload_context_rx *rx_ctx;
 	u32 is_req_pending;
 	s64 resync_req;
@@ -568,10 +580,10 @@ void handle_device_resync(struct sock *sk, u32 seq, u64 rcd_sn)
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
@@ -972,7 +984,10 @@ static int tls_device_down(struct net_device *netdev)
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

