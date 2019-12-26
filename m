Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2DD312AB35
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 10:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbfLZJXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 04:23:43 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38535 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbfLZJXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 04:23:43 -0500
Received: by mail-wr1-f67.google.com with SMTP id y17so23226867wrh.5
        for <netdev@vger.kernel.org>; Thu, 26 Dec 2019 01:23:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nurk82iIc6Uf6HLv+/kPOhKpFPTwWrEFlF6AYIZHVqQ=;
        b=yaL76tM97lic3wdIDVCfNrWmp9mP3+VXnpugn3RPs9cJU6TgGpTXrk2k169775DirQ
         lPs8k2lXxh20ln+uuLA/EHoWolzciSKLjB595cEBfTYj1ZbwQODqy37Mc/jE76VXOkLt
         SMOrl5nKOUJD52cuyYnJenoti4KCrOI6zlpFaUMTP28sgHZ+Tl2e8U39zjurT32GR2uI
         hN4gwERSVxbTLw/M3JbNesQdjT4OhIu0The4KQCgYJ8K6p6wbZm8l44UXVAqaaT1WHqB
         AldN+Gy4/6uka86en1+TPE0Abp0iA5njxagyYatdSjmik382b9o3kMVAGEQqIJ4rO4Qc
         67dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nurk82iIc6Uf6HLv+/kPOhKpFPTwWrEFlF6AYIZHVqQ=;
        b=oXmuKfP613HM2g3BsSj+j9naE+MVkulfP+t3kUw1KgsGfxJvqBXeXMuV//qyN74Ss0
         8/BG3BZjc/2B4GvR4AKp5UnKEMjvca61sv5Ry/PYKjgR4LyGhPCzU6Dbl0tKtcDRbLZA
         ace0enaEkBJdh7R4oUSCo5U+ifwLR9f4GkIof07INlqGPZRYF2iHPhxioUKGxiG2T1Al
         lojVa9CZ13LJAvJolDaM69RPiTTvX3ttais4p5XQUqrKxi2PubD7572+uT9IX3Ji3XTG
         4xFO59Q7wGrk+qyM961OPoKxSHVuJbBHAqdhDWVbGwL9T5S1GFvHDJY8xupoDWyxRUbY
         dFig==
X-Gm-Message-State: APjAAAX+hBjSfRnIGg1AnTiWHG9HZPHBysjY0Ht4YKBZWOkuNwgGY4bG
        ZYtA/OKo3SGfBvwF79Mohjuz7Q==
X-Google-Smtp-Source: APXvYqyAR696D3kS1dX3WXY/2Dbme3j68rsrY1Bgy00HGi1MyXsAHGrtrNLIZELbGoJU3MSXs8Yjjg==
X-Received: by 2002:adf:fe0e:: with SMTP id n14mr43938820wrr.116.1577352221254;
        Thu, 26 Dec 2019 01:23:41 -0800 (PST)
Received: from lophozonia.localdomain (68.120.91.91.rev.sfr.net. [91.91.120.68])
        by smtp.gmail.com with ESMTPSA id d14sm31930037wru.9.2019.12.26.01.23.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Dec 2019 01:23:40 -0800 (PST)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        arend.vanspriel@broadcom.com, hdegoede@redhat.com
Cc:     franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        chi-hsien.lin@cypress.com, wright.feng@cypress.com,
        kvalo@codeaurora.org, davem@davemloft.net
Subject: [PATCH] brcmfmac: sdio: Fix OOB interrupt initialization on brcm43362
Date:   Thu, 26 Dec 2019 10:20:33 +0100
Message-Id: <20191226092033.12600-1-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 262f2b53f679 ("brcmfmac: call brcmf_attach() just before calling
brcmf_bus_started()") changed the initialization order of the brcmfmac
SDIO driver. Unfortunately since brcmf_sdiod_intr_register() is now
called before the sdiodev->bus_if initialization, it reads the wrong
chip ID and fails to initialize the GPIO on brcm43362. Thus the chip
cannot send interrupts and fails to probe:

[   12.517023] brcmfmac: brcmf_sdio_bus_rxctl: resumed on timeout
[   12.531214] ieee80211 phy0: brcmf_bus_started: failed: -110
[   12.536976] ieee80211 phy0: brcmf_attach: dongle is not responding: err=-110
[   12.566467] brcmfmac: brcmf_sdio_firmware_callback: brcmf_attach failed

Initialize the bus interface earlier to ensure that
brcmf_sdiod_intr_register() properly sets up the OOB interrupt.

BugLink: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=908438
Fixes: 262f2b53f679 ("brcmfmac: call brcmf_attach() just before calling brcmf_bus_started()")
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
A workaround [1] disabling the OOB interrupt is being discussed. It
works for me, but this patch fixes the wifi problem on my cubietruck.

[1] https://lore.kernel.org/linux-arm-kernel/20180930150927.12076-1-hdegoede@redhat.com/
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/sdio.c  | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 264ad63232f8..058069a03693 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -4220,38 +4220,38 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 		brcmf_sdio_sr_init(bus);
 	} else {
 		/* Restore previous clock setting */
 		brcmf_sdiod_writeb(sdiod, SBSDIO_FUNC1_CHIPCLKCSR,
 				   saveclk, &err);
 	}
 
 	if (err == 0) {
+		/* Assign bus interface call back */
+		sdiod->bus_if->dev = sdiod->dev;
+		sdiod->bus_if->ops = &brcmf_sdio_bus_ops;
+		sdiod->bus_if->chip = bus->ci->chip;
+		sdiod->bus_if->chiprev = bus->ci->chiprev;
+
 		/* Allow full data communication using DPC from now on. */
 		brcmf_sdiod_change_state(bus->sdiodev, BRCMF_SDIOD_DATA);
 
 		err = brcmf_sdiod_intr_register(sdiod);
 		if (err != 0)
 			brcmf_err("intr register failed:%d\n", err);
 	}
 
 	/* If we didn't come up, turn off backplane clock */
 	if (err != 0) {
 		brcmf_sdio_clkctl(bus, CLK_NONE, false);
 		goto checkdied;
 	}
 
 	sdio_release_host(sdiod->func1);
 
-	/* Assign bus interface call back */
-	sdiod->bus_if->dev = sdiod->dev;
-	sdiod->bus_if->ops = &brcmf_sdio_bus_ops;
-	sdiod->bus_if->chip = bus->ci->chip;
-	sdiod->bus_if->chiprev = bus->ci->chiprev;
-
 	err = brcmf_alloc(sdiod->dev, sdiod->settings);
 	if (err) {
 		brcmf_err("brcmf_alloc failed\n");
 		goto claim;
 	}
 
 	/* Attach to the common layer, reserve hdr space */
 	err = brcmf_attach(sdiod->dev);
-- 
2.24.0

