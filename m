Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02F34398EE
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 00:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731713AbfFGWh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 18:37:59 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38914 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731587AbfFGWhr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 18:37:47 -0400
Received: by mail-pg1-f194.google.com with SMTP id 196so1869277pgc.6
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 15:37:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z4uQcLhxDEep9Dd0+N4T4ar1lYZLNVNOCQMZpRaAcgQ=;
        b=Wu5ODvnEgN+Dz3rZXFZGppPRarqh2wkcmSq/jdU0lxIYcSNaG6l9SM/cQ7rqNOQ+cx
         zxBOamHsP0cMwIo+6syFyWFHtQZ64LbEArNImhJSma0pDWnZQVdsP77XNYh/mmK0Dm2q
         qWYduKxF+F5spTIpgm3Rypp+nRk8xG2J2D5aM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z4uQcLhxDEep9Dd0+N4T4ar1lYZLNVNOCQMZpRaAcgQ=;
        b=CVkB35xYZztLQXTf+aKdk01+epVvDSn6fMKptFhpzDm2BAb/RjZTf8t0qhDGmf8SrA
         5U4g/P4q0HNHfDnheYK5J9udPFyww2WLjQPR3KLF4YfVdIGOAG1AsyOrpXyO4Tu/nWHG
         xOMC4CBhoP9WPX9+0oQM7Zvk6WjVT/zX/fflYbz1wWplVDHBVbHnwurKWfBvtR5GldEU
         b4fR7Uaizohpm4cBXtt1UfNzsHkNH2XF1TfOciRS7j+YZ9/kO1V5K19USDoBmTKOrsW7
         mO/Yiq9KgCxAdxTdU1pnRN/T5fFpKsDdzLiwhMUDDtgNFtJBZNXtTOMdVLjfrFy/JRCR
         0pRw==
X-Gm-Message-State: APjAAAXn+86gzvUncwNbiI4NpeND1O3p/CxkFvopo76eQq84PeSmDD0R
        ZkvPe+/W96u0JF72q1VzSSmWSQ==
X-Google-Smtp-Source: APXvYqxs31BYhnz3CuDYoW0F6K1ef/NQQc4dhUPxacP60w15cFP3tld8eeafi1pEevxCtCS+7gK93A==
X-Received: by 2002:a17:90a:9504:: with SMTP id t4mr8420374pjo.100.1559947066689;
        Fri, 07 Jun 2019 15:37:46 -0700 (PDT)
Received: from tictac2.mtv.corp.google.com ([2620:15c:202:1:24fa:e766:52c9:e3b2])
        by smtp.gmail.com with ESMTPSA id j23sm4185193pgb.63.2019.06.07.15.37.45
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 07 Jun 2019 15:37:46 -0700 (PDT)
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
        Franky Lin <franky.lin@broadcom.com>,
        linux-kernel@vger.kernel.org,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Ondrej Jirman <megous@megous.com>,
        YueHaibing <yuehaibing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH v3 5/5] brcmfmac: sdio: Don't tune while the card is off
Date:   Fri,  7 Jun 2019 15:37:16 -0700
Message-Id: <20190607223716.119277-6-dianders@chromium.org>
X-Mailer: git-send-email 2.22.0.rc2.383.gf4fbbf30c2-goog
In-Reply-To: <20190607223716.119277-1-dianders@chromium.org>
References: <20190607223716.119277-1-dianders@chromium.org>
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
tuning to send it a sleep command, so presumably that "good enough"
tuning is enough to wake us up, at least with a few retries.

Signed-off-by: Douglas Anderson <dianders@chromium.org>
---

Changes in v3:
- ("brcmfmac: sdio: Don't tune while the card is off") new for v3.

Changes in v2: None

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 4040aae1f9ed..98ffb4e90e15 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -670,6 +670,10 @@ brcmf_sdio_kso_control(struct brcmf_sdio *bus, bool on)
 
 	mmc_expect_errors_begin(bus->sdiodev->func1->card->host);
 
+	/* Cannot re-tune if device is asleep; defer till we're awake */
+	if (on)
+		mmc_retune_hold_now(bus->sdiodev->func1->card->host);
+
 	wr_val = (on << SBSDIO_FUNC1_SLEEPCSR_KSO_SHIFT);
 	/* 1st KSO write goes to AOS wake up core if device is asleep  */
 	brcmf_sdiod_writeb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR, wr_val, &err);
@@ -730,6 +734,9 @@ brcmf_sdio_kso_control(struct brcmf_sdio *bus, bool on)
 	if (try_cnt > MAX_KSO_ATTEMPTS)
 		brcmf_err("max tries: rd_val=0x%x err=%d\n", rd_val, err);
 
+	if (on)
+		mmc_retune_release(bus->sdiodev->func1->card->host);
+
 	mmc_expect_errors_end(bus->sdiodev->func1->card->host);
 
 	return err;
-- 
2.22.0.rc2.383.gf4fbbf30c2-goog

