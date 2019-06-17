Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5953748B07
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 19:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728711AbfFQR7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 13:59:10 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:45268 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728680AbfFQR7J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 13:59:09 -0400
Received: by mail-pl1-f195.google.com with SMTP id bi6so4381115plb.12
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 10:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O3PB3xTklEmW3AoAowBmJggSurvgbCg3QOQ9X2qUJD4=;
        b=RboDbIDvgfV7dMa9VFb+74vgJFX6x47CzOGrFGwjfZWx5qTQzJLKX7DFLbYN926L3+
         5TghUkIKYttbsX6x/9xsWht/HRlB7c1tJJklBRT45jHnPf2Qw1JviIvXt2wDSNJQvJIa
         9bxI4a9kWmsXHtMmE2XQ/j2f2fC8WP9mba6mw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O3PB3xTklEmW3AoAowBmJggSurvgbCg3QOQ9X2qUJD4=;
        b=WL8kFM0Gv3A1j3DyHFpcKWREYXraG0of3nsDktav0Die7XbpL3Kz573RXOwCS95KLV
         /JAqNfYMl19LJxLict4OKKu4kPFmsBjC1LCsaVScAOyuhmfkJ1eHVtTax1kpBicWvHD/
         RIZ36HUSaYaeoezVSP9LkJyJEqve3vyrgA0MmuRa8JyZkgoIBI1EAL5IRuRveaZmEjX9
         i03WN4aFtYqqR6oiDKIZ6jOJgqnu0RDR21zCIMXrDPIUPP27baSaYq8FoWX36AOEf74x
         sU10hW+6IBXUG4Ly1yEVQQZIefczVzuZ2BZrE8ris9xl2583Ju+ts3zi7+TGTdxTA9J1
         JTSQ==
X-Gm-Message-State: APjAAAX3uCBDtY6u0TOwclqe+az3hooCmqwj1xMs/H/rFGyceJcjwZWF
        H3CftSZxjnQB+ILraEXFzKVKGg==
X-Google-Smtp-Source: APXvYqwYSPmzyzQ5e2M8XtYApTa8vYDOCWFfkZGGCKzwG2cujAwMW6h8gJ+jE8rwNjGGmVTtaAqMcA==
X-Received: by 2002:a17:902:24c:: with SMTP id 70mr108322563plc.2.1560794349089;
        Mon, 17 Jun 2019 10:59:09 -0700 (PDT)
Received: from tictac2.mtv.corp.google.com ([2620:15c:202:1:24fa:e766:52c9:e3b2])
        by smtp.gmail.com with ESMTPSA id q1sm15145809pfn.178.2019.06.17.10.59.02
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 17 Jun 2019 10:59:06 -0700 (PDT)
From:   Douglas Anderson <dianders@chromium.org>
To:     Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Cc:     brcm80211-dev-list.pdl@broadcom.com,
        linux-rockchip@lists.infradead.org,
        Double Lo <double.lo@cypress.com>, briannorris@chromium.org,
        linux-wireless@vger.kernel.org,
        Naveen Gupta <naveen.gupta@cypress.com>,
        Madhan Mohan R <madhanmohan.r@cypress.com>, mka@chromium.org,
        Wright Feng <wright.feng@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        netdev@vger.kernel.org, brcm80211-dev-list@cypress.com,
        Douglas Anderson <dianders@chromium.org>,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Franky Lin <franky.lin@broadcom.com>,
        linux-kernel@vger.kernel.org,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Michael Trimarchi <michael@amarulasolutions.com>
Subject: [PATCH v5 3/5] brcmfmac: sdio: Disable auto-tuning around commands expected to fail
Date:   Mon, 17 Jun 2019 10:56:51 -0700
Message-Id: <20190617175653.21756-4-dianders@chromium.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190617175653.21756-1-dianders@chromium.org>
References: <20190617175653.21756-1-dianders@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are certain cases, notably when transitioning between sleep and
active state, when Broadcom SDIO WiFi cards will produce errors on the
SDIO bus.  This is evident from the source code where you can see that
we try commands in a loop until we either get success or we've tried
too many times.  The comment in the code reinforces this by saying
"just one write attempt may fail"

Unfortunately these failures sometimes end up causing an "-EILSEQ"
back to the core which triggers a retuning of the SDIO card and that
blocks all traffic to the card until it's done.

Let's disable retuning around the commands we expect might fail.

Commit notes:
Patches #2 - #5 will go through Ulf's tree.

This patch is still lacking Kalle Valo's Ack, which should probably be
received before landing in Ulf's tree.
END

Fixes: bd11e8bd03ca ("mmc: core: Flag re-tuning is needed on CRC errors")
Cc: stable@vger.kernel.org
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---

Changes in v5: None
Changes in v4:
- Adjust to API rename (Adrian, Ulf).

Changes in v3:
- Expect errors for all of brcmf_sdio_kso_control() (Adrian).

Changes in v2: None

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 4a750838d8cd..ee76593259a7 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -667,6 +667,8 @@ brcmf_sdio_kso_control(struct brcmf_sdio *bus, bool on)
 
 	brcmf_dbg(TRACE, "Enter: on=%d\n", on);
 
+	sdio_retune_crc_disable(bus->sdiodev->func1);
+
 	wr_val = (on << SBSDIO_FUNC1_SLEEPCSR_KSO_SHIFT);
 	/* 1st KSO write goes to AOS wake up core if device is asleep  */
 	brcmf_sdiod_writeb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR, wr_val, &err);
@@ -727,6 +729,8 @@ brcmf_sdio_kso_control(struct brcmf_sdio *bus, bool on)
 	if (try_cnt > MAX_KSO_ATTEMPTS)
 		brcmf_err("max tries: rd_val=0x%x err=%d\n", rd_val, err);
 
+	sdio_retune_crc_enable(bus->sdiodev->func1);
+
 	return err;
 }
 
-- 
2.22.0.410.gd8fdbe21b5-goog

