Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D536A4F9049
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 10:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbiDHIEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 04:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbiDHIDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 04:03:09 -0400
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 119FB10DA4E
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 01:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=k1; bh=2kVWK55tx7RXBw
        sq9Nb0RrYDtQqGFXJ4EIEhbn0Ylss=; b=AEGKiawy6GQJS1IJCP/VWH9RCjXvsK
        b4EDdQJqU+0ZTjm49JZoePYwR0PBT3lXiBFwQ40zK7scUQd2UBSGyBaH1RBj2451
        NRbxi0M4MyhJTQWIN9U+RXWK9Q0z2KVsh0zAv7lvMTgmfmJYK6Vw4O8X9ZVTDiiq
        9k92lM8kExWRw=
Received: (qmail 3517187 invoked from network); 8 Apr 2022 10:00:50 +0200
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 8 Apr 2022 10:00:50 +0200
X-UD-Smtp-Session: l3s3148p1@8L0o/h/cTqQgAQnoAEvdAHNhR6IfKwZI
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     linux-mmc@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        linux-kernel@vger.kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
Subject: [PATCH 1/3] mmc: core: improve API to make clear mmc_hw_reset is for cards
Date:   Fri,  8 Apr 2022 10:00:42 +0200
Message-Id: <20220408080045.6497-2-wsa+renesas@sang-engineering.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220408080045.6497-1-wsa+renesas@sang-engineering.com>
References: <20220408080045.6497-1-wsa+renesas@sang-engineering.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To make it unambiguous that mmc_hw_reset() is for cards and not for
controllers, we make the function argument mmc_card instead of mmc_host.
Also, all users are converted.

Suggested-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
---

Ulf prefers one cross-subsystem patch to have all users converted. So,
we are looking for ACKs from the maintainers of the wireless drivers.
Thank you!

Changes since RFC:
* don't rename the function but only change the argument type
* remove fallback and convert all users in one go
* remove comment as suggested by Ulf

 drivers/mmc/core/block.c                                | 2 +-
 drivers/mmc/core/core.c                                 | 5 +++--
 drivers/mmc/core/mmc_test.c                             | 3 +--
 drivers/net/wireless/ath/ath10k/sdio.c                  | 2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 2 +-
 drivers/net/wireless/marvell/mwifiex/sdio.c             | 2 +-
 drivers/net/wireless/ti/wlcore/sdio.c                   | 2 +-
 include/linux/mmc/core.h                                | 2 +-
 8 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
index 9c009e820de4..b35e7a95798b 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -995,7 +995,7 @@ static int mmc_blk_reset(struct mmc_blk_data *md, struct mmc_host *host,
 		return -EEXIST;
 
 	md->reset_done |= type;
-	err = mmc_hw_reset(host);
+	err = mmc_hw_reset(host->card);
 	/* Ensure we switch back to the correct partition */
 	if (err) {
 		struct mmc_blk_data *main_md =
diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 61abae221623..6f2561469a8f 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1998,7 +1998,7 @@ static void mmc_hw_reset_for_init(struct mmc_host *host)
 
 /**
  * mmc_hw_reset - reset the card in hardware
- * @host: MMC host to which the card is attached
+ * @card: card to be reset
  *
  * Hard reset the card. This function is only for upper layers, like the
  * block layer or card drivers. You cannot use it in host drivers (struct
@@ -2006,8 +2006,9 @@ static void mmc_hw_reset_for_init(struct mmc_host *host)
  *
  * Return: 0 on success, -errno on failure
  */
-int mmc_hw_reset(struct mmc_host *host)
+int mmc_hw_reset(struct mmc_card *card)
 {
+	struct mmc_host *host = card->host;
 	int ret;
 
 	ret = host->bus_ops->hw_reset(host);
diff --git a/drivers/mmc/core/mmc_test.c b/drivers/mmc/core/mmc_test.c
index e6a2fd2c6d5c..8d9bceeff986 100644
--- a/drivers/mmc/core/mmc_test.c
+++ b/drivers/mmc/core/mmc_test.c
@@ -2325,10 +2325,9 @@ static int mmc_test_profile_sglen_r_nonblock_perf(struct mmc_test_card *test)
 static int mmc_test_reset(struct mmc_test_card *test)
 {
 	struct mmc_card *card = test->card;
-	struct mmc_host *host = card->host;
 	int err;
 
-	err = mmc_hw_reset(host);
+	err = mmc_hw_reset(card);
 	if (!err) {
 		/*
 		 * Reset will re-enable the card's command queue, but tests
diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
index 63e1c2d783c5..73693c66cef1 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -1633,7 +1633,7 @@ static void ath10k_sdio_hif_power_down(struct ath10k *ar)
 		return;
 	}
 
-	ret = mmc_hw_reset(ar_sdio->func->card->host);
+	ret = mmc_hw_reset(ar_sdio->func->card);
 	if (ret)
 		ath10k_warn(ar, "unable to reset sdio: %d\n", ret);
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index ba3c159111d3..55285cad527f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -4165,7 +4165,7 @@ static int brcmf_sdio_bus_reset(struct device *dev)
 
 	/* reset the adapter */
 	sdio_claim_host(sdiodev->func1);
-	mmc_hw_reset(sdiodev->func1->card->host);
+	mmc_hw_reset(sdiodev->func1->card);
 	sdio_release_host(sdiodev->func1);
 
 	brcmf_bus_change_state(sdiodev->bus_if, BRCMF_BUS_DOWN);
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index bde9e4bbfffe..4f3238d2a171 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -2639,7 +2639,7 @@ static void mwifiex_sdio_card_reset_work(struct mwifiex_adapter *adapter)
 
 	/* Run a HW reset of the SDIO interface. */
 	sdio_claim_host(func);
-	ret = mmc_hw_reset(func->card->host);
+	ret = mmc_hw_reset(func->card);
 	sdio_release_host(func);
 
 	switch (ret) {
diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
index 72fc41ac83c0..9140b0163474 100644
--- a/drivers/net/wireless/ti/wlcore/sdio.c
+++ b/drivers/net/wireless/ti/wlcore/sdio.c
@@ -146,7 +146,7 @@ static int wl12xx_sdio_power_on(struct wl12xx_sdio_glue *glue)
 	 * To guarantee that the SDIO card is power cycled, as required to make
 	 * the FW programming to succeed, let's do a brute force HW reset.
 	 */
-	mmc_hw_reset(card->host);
+	mmc_hw_reset(card);
 
 	sdio_enable_func(func);
 	sdio_release_host(func);
diff --git a/include/linux/mmc/core.h b/include/linux/mmc/core.h
index 71101d1ec825..de5c64bbdb72 100644
--- a/include/linux/mmc/core.h
+++ b/include/linux/mmc/core.h
@@ -175,7 +175,7 @@ void mmc_wait_for_req(struct mmc_host *host, struct mmc_request *mrq);
 int mmc_wait_for_cmd(struct mmc_host *host, struct mmc_command *cmd,
 		int retries);
 
-int mmc_hw_reset(struct mmc_host *host);
+int mmc_hw_reset(struct mmc_card *card);
 int mmc_sw_reset(struct mmc_host *host);
 void mmc_set_data_timeout(struct mmc_data *data, const struct mmc_card *card);
 
-- 
2.30.2

