Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA7A24B7187
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 17:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239102AbiBOQ26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 11:28:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231887AbiBOQ26 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 11:28:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F677090D;
        Tue, 15 Feb 2022 08:28:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC3776181D;
        Tue, 15 Feb 2022 16:28:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B90BC340EB;
        Tue, 15 Feb 2022 16:28:45 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Jbh1/sC3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1644942523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o3Ex2y2ELI7nEV0J59rjOlWmWPabW9O5Loaxgl/Yv3E=;
        b=Jbh1/sC3FCtx0yDMtWLi5jsXL/5ERvlGM1sDJ1QrgCv+1RqkqedRZ7ySMvfJZ8JbKS5xFk
        BUxirU90d/HSwivk+QPU2dcYF240boXb9SZwBzjGhid0uSRf0WeHcKvDY5qCGEQ4uIpL/X
        FpxxfEEnUaJvO2QcB1dsgvYPHjRK37M=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id fd01509d (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 15 Feb 2022 16:28:42 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     miaoqing@codeaurora.org, "Jason Cooper" <jason@lakedaemon.net>,
        "Sepehrdad, Pouyan" <pouyans@qti.qualcomm.com>,
        ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Kalle Valo" <kvalo@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH] ath9k: use hw_random API instead of directly dumping into random.c
Date:   Tue, 15 Feb 2022 17:28:12 +0100
Message-Id: <20220215162812.195716-1-Jason@zx2c4.com>
In-Reply-To: <CAHmME9r4+ENUhZ6u26rAbq0iCWoKqTPYA7=_LWbGG98KvaCE6g@mail.gmail.com>
References: <CAHmME9r4+ENUhZ6u26rAbq0iCWoKqTPYA7=_LWbGG98KvaCE6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hardware random number generators are supposed to use the hw_random
framework. This commit turns ath9k's kthread-based design into a proper
hw_random driver.

This compiles, but I have no hardware or other ability to determine
whether it works. I'll leave further development up to the ath9k
and hw_random maintainers.

Cc: Toke Høiland-Jørgensen <toke@redhat.com>
Cc: Kalle Valo <kvalo@kernel.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  2 +-
 drivers/net/wireless/ath/ath9k/rng.c   | 62 +++++++++-----------------
 2 files changed, 23 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index ef6f5ea06c1f..142f472903dc 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -1072,7 +1072,7 @@ struct ath_softc {
 
 #ifdef CONFIG_ATH9K_HWRNG
 	u32 rng_last;
-	struct task_struct *rng_task;
+	struct hwrng rng_ops;
 #endif
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/rng.c b/drivers/net/wireless/ath/ath9k/rng.c
index aae2bd3cac69..369b222908ba 100644
--- a/drivers/net/wireless/ath/ath9k/rng.c
+++ b/drivers/net/wireless/ath/ath9k/rng.c
@@ -22,9 +22,6 @@
 #include "hw.h"
 #include "ar9003_phy.h"
 
-#define ATH9K_RNG_BUF_SIZE	320
-#define ATH9K_RNG_ENTROPY(x)	(((x) * 8 * 10) >> 5) /* quality: 10/32 */
-
 static DECLARE_WAIT_QUEUE_HEAD(rng_queue);
 
 static int ath9k_rng_data_read(struct ath_softc *sc, u32 *buf, u32 buf_size)
@@ -72,61 +69,46 @@ static u32 ath9k_rng_delay_get(u32 fail_stats)
 	return delay;
 }
 
-static int ath9k_rng_kthread(void *data)
+static int ath9k_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 {
+	struct ath_softc *sc = container_of(rng, struct ath_softc, rng_ops);
 	int bytes_read;
-	struct ath_softc *sc = data;
-	u32 *rng_buf;
-	u32 delay, fail_stats = 0;
-
-	rng_buf = kmalloc_array(ATH9K_RNG_BUF_SIZE, sizeof(u32), GFP_KERNEL);
-	if (!rng_buf)
-		goto out;
-
-	while (!kthread_should_stop()) {
-		bytes_read = ath9k_rng_data_read(sc, rng_buf,
-						 ATH9K_RNG_BUF_SIZE);
-		if (unlikely(!bytes_read)) {
-			delay = ath9k_rng_delay_get(++fail_stats);
-			wait_event_interruptible_timeout(rng_queue,
-							 kthread_should_stop(),
-							 msecs_to_jiffies(delay));
-			continue;
-		}
-
-		fail_stats = 0;
-
-		/* sleep until entropy bits under write_wakeup_threshold */
-		add_hwgenerator_randomness((void *)rng_buf, bytes_read,
-					   ATH9K_RNG_ENTROPY(bytes_read));
-	}
+	u32 fail_stats = 0;
 
-	kfree(rng_buf);
-out:
-	sc->rng_task = NULL;
+retry:
+	bytes_read = ath9k_rng_data_read(sc, buf, max);
+	if (unlikely(!bytes_read) && wait) {
+		msleep(ath9k_rng_delay_get(++fail_stats));
+		goto retry;
+	}
 
-	return 0;
+	return bytes_read;
 }
 
 void ath9k_rng_start(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
+	int ret;
 
-	if (sc->rng_task)
+	if (sc->rng_ops.read)
 		return;
 
 	if (!AR_SREV_9300_20_OR_LATER(ah))
 		return;
 
-	sc->rng_task = kthread_run(ath9k_rng_kthread, sc, "ath9k-hwrng");
-	if (IS_ERR(sc->rng_task))
-		sc->rng_task = NULL;
+	sc->rng_ops.name = "ath9k";
+	sc->rng_ops.read = ath9k_rng_read;
+	sc->rng_ops.quality = 320;
+
+	ret = devm_hwrng_register(sc->dev, &sc->rng_ops);
+	if (ret)
+		sc->rng_ops.read = NULL;
 }
 
 void ath9k_rng_stop(struct ath_softc *sc)
 {
-	if (sc->rng_task) {
-		kthread_stop(sc->rng_task);
-		sc->rng_task = NULL;
+	if (sc->rng_ops.read) {
+		devm_hwrng_unregister(sc->dev, &sc->rng_ops);
+		sc->rng_ops.read = NULL;
 	}
 }
-- 
2.35.0

