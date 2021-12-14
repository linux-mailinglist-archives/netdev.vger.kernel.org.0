Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF15474DFD
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 23:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234060AbhLNWlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 17:41:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234138AbhLNWlY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 17:41:24 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEFEDC06173F
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 14:41:23 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id 133so18449123pgc.12
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 14:41:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eDsV3k9UGAVfHIwefuiXTCNNU/bOVVB2dV1ONTQPwYs=;
        b=YrT6Ax+RE1E9xOKx1/vSZs/CcExWra/gZCqKhlAVfclLv9T0FocQjL7NYCSEq+BTp9
         OUt+/qXIW7v58IGs1LUkhOQ5/AmciYchCTpv68onhApcLvu1jzc4qCrWgaZ0n0AJ4HVg
         MuGEEkGA7Wf2Mb+80scI4AkSBKWHENsY0LXbs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eDsV3k9UGAVfHIwefuiXTCNNU/bOVVB2dV1ONTQPwYs=;
        b=Rq+cEoolBE75+F09G0pGUMRCU6B/uqcPGy0fjl2BX//35cmLq1Iqb754Vrgz14WLkE
         vVVSXQehuUH06xBzl/WEBhosX53VXuj4vwG4ylVLVE1a1mgwcf9hdvTSHfWBKOf2+le0
         wbIfiEMoE0yAvy++Hl3O+WXq9FY0tuHVwg2E9u0emxx+6xIXrQmZ1uwIHy85t/da42NR
         44HAXlKzUGvuhUno1rGxdg0J8hBOz7lTvhGRNp4OHgfJdQtymWLU8YVl7MU3qbnw62Bn
         1Zkn0+nZ+I3ePkVkzv3OimBid/xwbISm8WeHmg2FVP4WxydgU9XAQhZM8RR7deCZPDAC
         maKA==
X-Gm-Message-State: AOAM530J4181PtBUqwOtlMg89FKJ1be/Tvmt/sB6Ial6ZvI1PbzA1gTd
        zNNKgq2erjoh5xSE+PKIGRpsaw==
X-Google-Smtp-Source: ABdhPJz3uI/F6ZLy7YDpsYuhsITDzYb4JFBnxud7ZTVkuR/XKrsKVpLM26sB1yYVYIQSqCV82fsBGQ==
X-Received: by 2002:a65:6819:: with SMTP id l25mr5622069pgt.506.1639521683205;
        Tue, 14 Dec 2021 14:41:23 -0800 (PST)
Received: from kuabhs-cdev.c.googlers.com.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id g1sm122576pfv.19.2021.12.14.14.41.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 14:41:22 -0800 (PST)
From:   Abhishek Kumar <kuabhs@chromium.org>
To:     kvalo@codeaurora.org, briannorris@chromium.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        dianders@chromium.org, kuabhs@chromium.org, pillair@codeaurora.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ath10k@lists.infradead.org,
        netdev@vger.kernel.org
Subject: [PATCH] ath10k: enable threaded napi on ath10k driver
Date:   Tue, 14 Dec 2021 22:39:36 +0000
Message-Id: <20211214223901.1.I777939e0ef1e89872d4ab65340f3fd756615a047@changeid>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NAPI poll can be done in threaded context along with soft irq
context. Threaded context can be scheduled efficiently, thus
creating less of bottleneck during Rx processing. This patch is
to enable threaded NAPI on ath10k driver.

Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.2.2-00696-QCAHLSWMTPL-1
Signed-off-by: Abhishek Kumar <kuabhs@chromium.org>
---

 drivers/net/wireless/ath/ath10k/pci.c  | 1 +
 drivers/net/wireless/ath/ath10k/sdio.c | 1 +
 drivers/net/wireless/ath/ath10k/snoc.c | 2 +-
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 4d4e2f91e15c..584307574d99 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1958,6 +1958,7 @@ static int ath10k_pci_hif_start(struct ath10k *ar)
 
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot hif start\n");
 
+	dev_set_threaded(&ar->napi_dev, true);
 	ath10k_core_napi_enable(ar);
 
 	ath10k_pci_irq_enable(ar);
diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
index 63e1c2d783c5..52ef74d9811a 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -1862,6 +1862,7 @@ static int ath10k_sdio_hif_start(struct ath10k *ar)
 	struct ath10k_sdio *ar_sdio = ath10k_sdio_priv(ar);
 	int ret;
 
+	dev_set_threaded(&ar->napi_dev, true);
 	ath10k_core_napi_enable(ar);
 
 	/* Sleep 20 ms before HIF interrupts are disabled.
diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index 9513ab696fff..e7d12dbb3fa5 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -926,7 +926,7 @@ static int ath10k_snoc_hif_start(struct ath10k *ar)
 	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
 
 	bitmap_clear(ar_snoc->pending_ce_irqs, 0, CE_COUNT_MAX);
-
+	dev_set_threaded(&ar->napi_dev, true);
 	ath10k_core_napi_enable(ar);
 	ath10k_snoc_irq_enable(ar);
 	ath10k_snoc_rx_post(ar);
-- 
2.34.1.173.g76aa8bc2d0-goog

