Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9567A4B7B8D
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 01:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244952AbiBPADD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 19:03:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238224AbiBPADC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 19:03:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C1527FEF;
        Tue, 15 Feb 2022 16:02:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B1D5B81D24;
        Wed, 16 Feb 2022 00:02:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7AFFC340EB;
        Wed, 16 Feb 2022 00:02:43 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="f35zvtzb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1644969762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jSS481wVl8zqyIdlIbBq60q/zzn2ipkf0jzq2ad4dkI=;
        b=f35zvtzbFMMcFnKlOxThurkk8WtIjJj8M9KO6s/sXB1OU+6P/JiSHXPVOF/zaU6zSPMFaL
        0EDJg3xwhcQUwnv5ideAxirX7uCJy/+AYDDHLeVVantYs6jOb7B2XrmoAN2vKyq+Y/7JGz
        m90G+iu5MwRUIzCb5DuzNkW2JSQZOrs=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 64f85552 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 16 Feb 2022 00:02:41 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     miaoqing@codeaurora.org, rsalvaterra@gmail.com,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        "Sepehrdad, Pouyan" <pouyans@qti.qualcomm.com>,
        ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH v2] ath9k: use hw_random API instead of directly dumping into random.c
Date:   Wed, 16 Feb 2022 01:02:30 +0100
Message-Id: <20220216000230.22625-1-Jason@zx2c4.com>
In-Reply-To: <CAHmME9pZaYW-p=zU4v96TjeSijm-g03cNpvUJcNvhOqh5v+Lwg@mail.gmail.com>
References: <CAHmME9pZaYW-p=zU4v96TjeSijm-g03cNpvUJcNvhOqh5v+Lwg@mail.gmail.com>
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
v2 operates on whole words when possible.

 drivers/net/wireless/ath/ath9k/ath9k.h |  2 +-
 drivers/net/wireless/ath/ath9k/rng.c   | 72 +++++++++++---------------
 2 files changed, 30 insertions(+), 44 deletions(-)

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
index aae2bd3cac69..a0a58f8e08d3 100644
--- a/drivers/net/wireless/ath/ath9k/rng.c
+++ b/drivers/net/wireless/ath/ath9k/rng.c
@@ -22,11 +22,6 @@
 #include "hw.h"
 #include "ar9003_phy.h"
 
-#define ATH9K_RNG_BUF_SIZE	320
-#define ATH9K_RNG_ENTROPY(x)	(((x) * 8 * 10) >> 5) /* quality: 10/32 */
-
-static DECLARE_WAIT_QUEUE_HEAD(rng_queue);
-
 static int ath9k_rng_data_read(struct ath_softc *sc, u32 *buf, u32 buf_size)
 {
 	int i, j;
@@ -72,61 +67,52 @@ static u32 ath9k_rng_delay_get(u32 fail_stats)
 	return delay;
 }
 
-static int ath9k_rng_kthread(void *data)
+static int ath9k_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 {
-	int bytes_read;
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
+	struct ath_softc *sc = container_of(rng, struct ath_softc, rng_ops);
+	int bytes_read = 0;
+	u32 fail_stats = 0, word;
+
+retry:
+	if (max & ~3UL)
+		bytes_read = ath9k_rng_data_read(sc, buf, max >> 2);
+	if ((max & 3UL) && ath9k_rng_data_read(sc, &word, 1)) {
+		memcpy(buf + bytes_read, &word, max & 3);
+		bytes_read += max & 3;
+		memzero_explicit(&word, sizeof(word));
+	}
+	if (max && unlikely(!bytes_read) && wait) {
+		msleep(ath9k_rng_delay_get(++fail_stats));
+		goto retry;
 	}
 
-	kfree(rng_buf);
-out:
-	sc->rng_task = NULL;
-
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

