Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33E22F0945
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 23:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730317AbfKEWYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 17:24:55 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:41867 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729895AbfKEWYy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 17:24:54 -0500
Received: by mail-lf1-f66.google.com with SMTP id j14so16364791lfb.8
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 14:24:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DcRIGXlmkyZeouo80or8D7aekQYJgQ8oz4v6jGWLVH8=;
        b=C1YiaHJ2qKCqoyH8fcAkWVbIsi6mDmlA7OCTyM9qKgLN5qnx/Q9bnRzdkX7fH0ahgb
         aEkUqUfWty+x312bZj+gnIiTyFjBtQghnzOu4d7svk1um8QAhKcRAfTCMmKJ9ROiggEq
         j5dkTgFELKX0ZETFMODFrfltGbFV6qm3SNHWcXRVBL8T8OoYWkLipK1bjKiz/en1b6Gx
         0cCr6c0QvJkyFPlR/AMBQ3wgYvrGrh1UpRE+pP5xVt/QgyqG2PrDfiwo3m1DOJ0Kx6XS
         Vkal1a/hwv8hT2audR6Uy8GZglkbzn2QzzxkL0VU79IGio843bYvA158Xzssr/DEEft4
         ULDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DcRIGXlmkyZeouo80or8D7aekQYJgQ8oz4v6jGWLVH8=;
        b=lAU0YHIGcjYqyoIFy+N2+txFLUVml85g2SLBIrR+iP3scs1JaUTc69c6bsFhjiHx7T
         r33z4PJUKknhh5b4BMmE+QrNKfDWiR2A0YWb+4bdrk4J9+0AfEEW/zgzMrVsc4KzymJ/
         FQMZD9zEnhtrjRIgId7DOMmhC5A+xCs+XVRRFijLP3uBPo+C3XcAfHje315sCMSWvWXz
         UB1SBElzWIO5fmosHeQyK85KhyDk1DM6Pp5H6HzQvliwt+n2doAICy0d/e1WIYGCV9Gf
         nwS/vEJUuMf270bZ6opJEjK+NaEcYV3HJmCf+ho6A6VApPRqoYXdnoRTd2mmz21RI+Ri
         kmtA==
X-Gm-Message-State: APjAAAXAZRr6NUIlqpOAbqoRIR7iXARbcFVU1F12qv25MPiaJFvtkBvt
        MeNZDg25IRx4G52qck+TVkwVUQ==
X-Google-Smtp-Source: APXvYqyuMiKBIZF7pQpTm/B98jruXPZjQgN6/Ztt37uO8AMLHLG4A4s2fgeY2N/cdPePBauH1UUqaQ==
X-Received: by 2002:ac2:5deb:: with SMTP id z11mr23149726lfq.35.1572992692842;
        Tue, 05 Nov 2019 14:24:52 -0800 (PST)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id s25sm4020139lji.81.2019.11.05.14.24.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Nov 2019 14:24:52 -0800 (PST)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net 1/3] net/tls: don't pay attention to sk_write_pending when pushing partial records
Date:   Tue,  5 Nov 2019 14:24:34 -0800
Message-Id: <20191105222436.27359-2-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191105222436.27359-1-jakub.kicinski@netronome.com>
References: <20191105222436.27359-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sk_write_pending being not zero does not guarantee that partial
record will be pushed. If the thread waiting for memory times out
the pending record may get stuck.

In case of tls_device there is no path where parial record is
set and writer present in the first place. Partial record is
set only in tls_push_sg() and tls_push_sg() will return an
error immediately. All tls_device callers of tls_push_sg()
will return (and not wait for memory) if it failed.

Fixes: a42055e8d2c3 ("net/tls: Add support for async encryption of records for performance")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
---
 net/tls/tls_device.c | 4 +++-
 net/tls/tls_sw.c     | 9 +++------
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index f959487c5cd1..5a3715ddc592 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -623,9 +623,11 @@ static int tls_device_push_pending_record(struct sock *sk, int flags)
 
 void tls_device_write_space(struct sock *sk, struct tls_context *ctx)
 {
-	if (!sk->sk_write_pending && tls_is_partially_sent_record(ctx)) {
+	if (tls_is_partially_sent_record(ctx)) {
 		gfp_t sk_allocation = sk->sk_allocation;
 
+		WARN_ON_ONCE(sk->sk_write_pending);
+
 		sk->sk_allocation = GFP_ATOMIC;
 		tls_push_partial_record(sk, ctx,
 					MSG_DONTWAIT | MSG_NOSIGNAL |
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index c2b5e0d2ba1a..e155b792df0b 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2180,12 +2180,9 @@ void tls_sw_write_space(struct sock *sk, struct tls_context *ctx)
 	struct tls_sw_context_tx *tx_ctx = tls_sw_ctx_tx(ctx);
 
 	/* Schedule the transmission if tx list is ready */
-	if (is_tx_ready(tx_ctx) && !sk->sk_write_pending) {
-		/* Schedule the transmission */
-		if (!test_and_set_bit(BIT_TX_SCHEDULED,
-				      &tx_ctx->tx_bitmask))
-			schedule_delayed_work(&tx_ctx->tx_work.work, 0);
-	}
+	if (is_tx_ready(tx_ctx) &&
+	    !test_and_set_bit(BIT_TX_SCHEDULED, &tx_ctx->tx_bitmask))
+		schedule_delayed_work(&tx_ctx->tx_work.work, 0);
 }
 
 void tls_sw_strparser_arm(struct sock *sk, struct tls_context *tls_ctx)
-- 
2.23.0

