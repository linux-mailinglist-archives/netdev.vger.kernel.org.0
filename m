Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE38C709E4
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 21:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732292AbfGVTlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 15:41:39 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34083 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732259AbfGVTlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 15:41:32 -0400
Received: by mail-pg1-f195.google.com with SMTP id n9so11928592pgc.1
        for <netdev@vger.kernel.org>; Mon, 22 Jul 2019 12:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ATbFy1aIdbWHFM03S3oai17NaO/neBJFfQYViTxrNMs=;
        b=fLXr6gDQl11kx/gfLPu/pKAYQ3oWpeGmz6q8QFeSzDdvzyBV3Jixq5ya13oHO5dqfo
         Nt5xcerqY4a9O3JWvuPb94Tyrayne1SI5T6+UGeut3CsFAKBfhZw9yU7Q5/RHukXvoYY
         cqcqRPZNeTl+YDf2PzrHdCfdrC3TgIUq6fJSI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ATbFy1aIdbWHFM03S3oai17NaO/neBJFfQYViTxrNMs=;
        b=h35VejA6+5qFs1q3J09i/C4/o46aAsumvVcrjX3ZXHKvmdKlfyPI9Dhy6dC8z6mjG7
         /bubxasxQRWMMY2V4QArJZCCqD1WHa2RMjjvInjeGJglATWPljj2f1v0i8K/jF68zzrE
         nPfXeN94EhWp3o9/ui6jiugeXKNERjWSQPjII+N4dzR8xRTG1RyZu1vRLtt8ngoVPOI0
         JIroGZT6XTd1SNGR4WPMnMucYRWOxP3wB6WRJfGd1jb836dSBDHNuDiIVcatGyaXpAS0
         +DMKMYtRi2vaMQniR/NJMkbERS7WbIGfRDT7G+r+U8saApjSXmks0J4qgYKsui85Vxg+
         JrQg==
X-Gm-Message-State: APjAAAVq3JBjCZzpCft5jDzJ8DRJoiNMEMPxm1QUorB+rKwpCCVzRndU
        RbnAM6nIhXhdhiRGMj/pPnaE0A==
X-Google-Smtp-Source: APXvYqxe3jk2Td0NZ3MiOAVs4zOozU2NCyEe4BhAwMABU222PrrTzeC4C4T+vjjW5dwEp508Pc+S0A==
X-Received: by 2002:a17:90a:ba93:: with SMTP id t19mr77532204pjr.139.1563824491627;
        Mon, 22 Jul 2019 12:41:31 -0700 (PDT)
Received: from tictac2.mtv.corp.google.com ([2620:15c:202:1:24fa:e766:52c9:e3b2])
        by smtp.gmail.com with ESMTPSA id z4sm29838803pgp.80.2019.07.22.12.41.30
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 22 Jul 2019 12:41:31 -0700 (PDT)
From:   Douglas Anderson <dianders@chromium.org>
To:     Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Cc:     Ganapathi Bhat <gbhat@marvell.com>, linux-wireless@vger.kernel.org,
        Andreas Fenkart <afenkart@gmail.com>,
        Brian Norris <briannorris@chromium.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        linux-rockchip@lists.infradead.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        netdev@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        linux-mmc@vger.kernel.org, davem@davemloft.net,
        Xinming Hu <huxinming820@gmail.com>,
        Douglas Anderson <dianders@chromium.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] mwifiex: Make use of the new sdio_trigger_replug() API to reset
Date:   Mon, 22 Jul 2019 12:39:39 -0700
Message-Id: <20190722193939.125578-3-dianders@chromium.org>
X-Mailer: git-send-email 2.22.0.657.g960e92d24f-goog
In-Reply-To: <20190722193939.125578-1-dianders@chromium.org>
References: <20190722193939.125578-1-dianders@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As described in the patch ("mmc: core: Add sdio_trigger_replug()
API"), the current mwifiex_sdio_card_reset() is broken in the cases
where we're running Bluetooth on a second SDIO func on the same card
as WiFi.  The problem goes away if we just use the
sdio_trigger_replug() API call.

NOTE: Even though with this new solution there is less of a reason to
do our work from a workqueue (the unplug / plug mechanism we're using
is possible for a human to perform at any time so the stack is
supposed to handle it without it needing to be called from a special
context), we still need a workqueue because the Marvell reset function
could called from a context where sleeping is invalid and thus we
can't claim the host.  One example is Marvell's wakeup_timer_fn().

Cc: Andreas Fenkart <afenkart@gmail.com>
Cc: Brian Norris <briannorris@chromium.org>
Fixes: b4336a282db8 ("mwifiex: sdio: reset adapter using mmc_hw_reset")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Brian Norris <briannorris@chromium.org>
---

Changes in v2:
- Removed clear_bit() calls and old comment (Brian Norris).
- Explicit CC of Andreas Fenkart.
- Explicit CC of Brian Norris.
- Add "Fixes" pointing at the commit Brian talked about.
- Add Brian's Reviewed-by tag.

 drivers/net/wireless/marvell/mwifiex/sdio.c | 16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index 24c041dad9f6..7ec5068f6ffd 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -2218,24 +2218,10 @@ static void mwifiex_sdio_card_reset_work(struct mwifiex_adapter *adapter)
 {
 	struct sdio_mmc_card *card = adapter->card;
 	struct sdio_func *func = card->func;
-	int ret;
-
-	mwifiex_shutdown_sw(adapter);
 
-	/* power cycle the adapter */
 	sdio_claim_host(func);
-	mmc_hw_reset(func->card->host);
+	sdio_trigger_replug(func);
 	sdio_release_host(func);
-
-	/* Previous save_adapter won't be valid after this. We will cancel
-	 * pending work requests.
-	 */
-	clear_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP, &card->work_flags);
-	clear_bit(MWIFIEX_IFACE_WORK_CARD_RESET, &card->work_flags);
-
-	ret = mwifiex_reinit_sw(adapter);
-	if (ret)
-		dev_err(&func->dev, "reinit failed: %d\n", ret);
 }
 
 /* This function read/write firmware */
-- 
2.22.0.657.g960e92d24f-goog

