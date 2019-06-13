Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9B44503C
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 01:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbfFMXmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 19:42:37 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:36085 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727438AbfFMXmM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 19:42:12 -0400
Received: by mail-pl1-f195.google.com with SMTP id d21so185087plr.3
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 16:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c7083/wRDhjfXKIPLOR/z/xGqx+N3NzGcEXMjAPkrtk=;
        b=iJ2vRTDhZeW4lVDaqVPjbVshWP4qjnkSnSGc+SrRGQ5aAPmwmUXkPpXZGJjODoGMiE
         z9Jm0f9FJ8ZQqbLU8oFkC1ru/LfZlKOFSblwIEKz0JHO/x4QY+girk7kLvPF2SnSW6iP
         u/ybRoaZsNnm7HpTBOdVgcftH21NcEWRLr7p8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c7083/wRDhjfXKIPLOR/z/xGqx+N3NzGcEXMjAPkrtk=;
        b=bKz1pSkeOVR1hY2YMtXKpnV2pjacGnM4Z+qD0gk+LroLM6A6FQ77CaB4Nb641iXBdq
         Xl6NgO307gYxcl0g3/Y1E0A4TC06099mZhsJCh5b4cWVZ5HfmN1KTH/uwSuX6gP1s3t0
         JnkeozKw4p5ObExIPtX2XFi4W7Iqzdiz7rw+ANyBQ3a2QaCzMmbKI4w/1neTMA/LU0tN
         9hREweufhnNfgkpqyzMKyJ5K6coqIqwdICerQjGhmhbt6hPFqX2Eh9KhoJSAf1R56mZf
         nMK5zTS8/65QqyOAL1t0T58j0wuSqIf7aZ2dvea2mI/lJC5sOzbn5vnUM8YCWgB3FjGB
         fBcA==
X-Gm-Message-State: APjAAAUQ+tJ2F4tS4v53nf0CKPO8U8+9dxMnYG870uollUIj9WNpn4H3
        +58xzD2snmirw8P8Bg2vqetjFQ==
X-Google-Smtp-Source: APXvYqwoIyI7QZt4blA5Q5la53DjUJQtY42TC4Gcx1xTxy4vkRuynr/kzG9FYakwMCM6kZGmAeP4XA==
X-Received: by 2002:a17:902:8d92:: with SMTP id v18mr67370527plo.211.1560469331903;
        Thu, 13 Jun 2019 16:42:11 -0700 (PDT)
Received: from tictac2.mtv.corp.google.com ([2620:15c:202:1:24fa:e766:52c9:e3b2])
        by smtp.gmail.com with ESMTPSA id p7sm781088pfp.131.2019.06.13.16.42.10
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 13 Jun 2019 16:42:11 -0700 (PDT)
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
        Hans de Goede <hdegoede@redhat.com>,
        Franky Lin <franky.lin@broadcom.com>,
        linux-kernel@vger.kernel.org,
        Madhan Mohan R <MadhanMohan.R@cypress.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        YueHaibing <yuehaibing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH v4 3/5] brcmfmac: sdio: Disable auto-tuning around commands expected to fail
Date:   Thu, 13 Jun 2019 16:41:51 -0700
Message-Id: <20190613234153.59309-4-dianders@chromium.org>
X-Mailer: git-send-email 2.22.0.rc2.383.gf4fbbf30c2-goog
In-Reply-To: <20190613234153.59309-1-dianders@chromium.org>
References: <20190613234153.59309-1-dianders@chromium.org>
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

Fixes: bd11e8bd03ca ("mmc: core: Flag re-tuning is needed on CRC errors")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
---

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
2.22.0.rc2.383.gf4fbbf30c2-goog

