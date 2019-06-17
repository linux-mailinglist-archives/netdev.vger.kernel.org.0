Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB1DA48B14
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 19:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728776AbfFQR71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 13:59:27 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36657 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728750AbfFQR7T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 13:59:19 -0400
Received: by mail-pf1-f193.google.com with SMTP id r7so6099398pfl.3
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 10:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FlnZzdiFf1S0YMLoCTFEyV12ust5Dpo7bSpHKMU0s0k=;
        b=VIWj2CuRQEFDLQTpFrEiwh7JmnmIdikL7iboXsKITUDu17jDFvklPt+TErOhzcT4hL
         M45V1hxQGm9U+GrK+lQYDYIj2Ak6M6/DRUgQHo+Eh2Be+W6dF0MnnCpH29uTjmn+fKMv
         tP1d85wAvCnpc6uw+HsZKe4wc8XeCeeqZFD8c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FlnZzdiFf1S0YMLoCTFEyV12ust5Dpo7bSpHKMU0s0k=;
        b=nClANRumORbmymtpvp8BKi7+TRgF5Z3SzE0+X7Z+hEWFVWMZR98fuBCDTaQM8BGMP/
         IHw/zIpL7BMy7uOGCaTQQNEykPD6oLt/kI7BN0KHZRJSkaYEMABwl485s3n9E6sYvBtd
         G09fGi6lbdV8u+4ZhhxHTxvZOANDkNX5YQNdFnb1Yv/RlQdkkC4MfxIhSa3BOfkbqB7+
         Y61josS7BgfO/xdwdZfvsYnAA7sjl+XTwQeA0uVewUOVRXCIoxcJZt4mm2ICYz3OaP/P
         L5n5QUUTwpC69d9YAkY/QJN0Cp1iVUW7HbPoEIM7M/dT6oyy8FFs3d4BEgpaoaJ4GxLe
         AvOw==
X-Gm-Message-State: APjAAAWlDLYCM3LEnaK9sN2iBb1/eS4qbyLuj2+GX9OOJMH4nGp1d6Oa
        Akel7Rf5onVibqj2jMNXkLDInA==
X-Google-Smtp-Source: APXvYqyaVs3fvyMpOLZjM3c8dSSZ0GNGbc2/XbFy4Qlb/yNERuegnQR6T/3bb+Lh0yT+fdVq5jr3Gw==
X-Received: by 2002:a62:b40f:: with SMTP id h15mr107121375pfn.57.1560794358391;
        Mon, 17 Jun 2019 10:59:18 -0700 (PDT)
Received: from tictac2.mtv.corp.google.com ([2620:15c:202:1:24fa:e766:52c9:e3b2])
        by smtp.gmail.com with ESMTPSA id q1sm15145809pfn.178.2019.06.17.10.59.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 17 Jun 2019 10:59:16 -0700 (PDT)
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
        stable@vger.kernel.org, Franky Lin <franky.lin@broadcom.com>,
        linux-kernel@vger.kernel.org,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Ondrej Jirman <megous@megous.com>,
        YueHaibing <yuehaibing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH v5 5/5] brcmfmac: sdio: Don't tune while the card is off
Date:   Mon, 17 Jun 2019 10:56:53 -0700
Message-Id: <20190617175653.21756-6-dianders@chromium.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190617175653.21756-1-dianders@chromium.org>
References: <20190617175653.21756-1-dianders@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When Broadcom SDIO cards are idled they go to sleep and a whole
separate subsystem takes over their SDIO communication.  This is the
Always-On-Subsystem (AOS) and it can't handle tuning requests.

Specifically, as tested on rk3288-veyron-minnie (which reports having
BCM4354/1 in dmesg), if I force a retune in brcmf_sdio_kso_control()
when "on = 1" (aka we're transition from sleep to wake) by whacking:
  bus->sdiodev->func1->card->host->need_retune = 1
...then I can often see tuning fail.  In this case dw_mmc reports "All
phases bad!").  Note that I don't get 100% failure, presumably because
sometimes the card itself has already transitioned away from the AOS
itself by the time we try to wake it up.  If I force retuning when "on
= 0" (AKA force retuning right before sending the command to go to
sleep) then retuning is always OK.

NOTE: we need _both_ this patch and the patch to avoid triggering
tuning due to CRC errors in the sleep/wake transition, AKA ("brcmfmac:
sdio: Disable auto-tuning around commands expected to fail").  Though
both patches handle issues with Broadcom's AOS, the problems are
distinct:
1. We want to defer (but not ignore) asynchronous (like
   timer-requested) tuning requests till the card is awake.  However,
   we want to ignore CRC errors during the transition, we don't want
   to queue deferred tuning request.
2. You could imagine that the AOS could implement retuning but we
   could still get errors while transitioning in and out of the AOS.
   Similarly you could imagine a seamless transition into and out of
   the AOS (with no CRC errors) even if the AOS couldn't handle
   tuning.

ALSO NOTE: presumably there is never a desperate need to retune in
order to wake up the card, since doing so is impossible.  Luckily the
only way the card can get into sleep state is if we had a good enough
tuning to send it the command to put it into sleep, so presumably that
"good enough" tuning is enough to wake us up, at least with a few
retries.

Cc: stable@vger.kernel.org
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
Patches #2 - #5 will go through Ulf's tree.

This patch is still lacking Kalle Valo's Ack, which should probably be
received before landing in Ulf's tree.

I've CCed stable@ here without a version tag.  As per Adrian Hunter
this patch applies cleanly to 4.18+ so that would be an easy first
target.  However, if someone were so inclined they could provide
further backports.  As per Adrian [1] the root problem has existed for
~4 years.

[1] https://lkml.kernel.org/r/4f39e152-04ba-a64e-985a-df93e6d15ff8@intel.com

Changes in v5:
- Rewording of "sleep command" in commit message (Arend).

Changes in v4:
- Adjust to API rename (Adrian).

Changes in v3:
- ("brcmfmac: sdio: Don't tune while the card is off") new for v3.

Changes in v2: None

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index ee76593259a7..629140b6d7e2 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -669,6 +669,10 @@ brcmf_sdio_kso_control(struct brcmf_sdio *bus, bool on)
 
 	sdio_retune_crc_disable(bus->sdiodev->func1);
 
+	/* Cannot re-tune if device is asleep; defer till we're awake */
+	if (on)
+		sdio_retune_hold_now(bus->sdiodev->func1);
+
 	wr_val = (on << SBSDIO_FUNC1_SLEEPCSR_KSO_SHIFT);
 	/* 1st KSO write goes to AOS wake up core if device is asleep  */
 	brcmf_sdiod_writeb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR, wr_val, &err);
@@ -729,6 +733,9 @@ brcmf_sdio_kso_control(struct brcmf_sdio *bus, bool on)
 	if (try_cnt > MAX_KSO_ATTEMPTS)
 		brcmf_err("max tries: rd_val=0x%x err=%d\n", rd_val, err);
 
+	if (on)
+		sdio_retune_release(bus->sdiodev->func1);
+
 	sdio_retune_crc_enable(bus->sdiodev->func1);
 
 	return err;
-- 
2.22.0.410.gd8fdbe21b5-goog

