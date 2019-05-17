Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5280D2207F
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 00:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729684AbfEQWys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 18:54:48 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44395 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729674AbfEQWyr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 18:54:47 -0400
Received: by mail-pf1-f193.google.com with SMTP id g9so4346185pfo.11
        for <netdev@vger.kernel.org>; Fri, 17 May 2019 15:54:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jmrinjUmvX+AQ+lipzMHtBZaQD2gwKEewfCw3RvxUZk=;
        b=YBy/i07qpQlrvxx+6Ohii/hGKkEYRmpgmxzUqTc6t6e7jWY6J0RFRRoni7Yc9uR55E
         dOjuS+sxiF3k24jBmU7V/xt3JzhbBVbS1Jb28lbbMPZ8uBUX67zRh9M3rxqKH17xRDfC
         1JyFzVqKbemtnksZtgFzqdiY3uYO5HgqwLLb0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jmrinjUmvX+AQ+lipzMHtBZaQD2gwKEewfCw3RvxUZk=;
        b=rmOO3v60D00Whtup13VAzMkgjKd0tDIognA/E1xlNpicTRQ9Pex52+R+UQgeNvLIPF
         kHQ446gui8Ue1SUUHAgO7jRYdfnEpUToFGK/5tqY8Nj3Zipo9iJmRk1UGGdnFxwYjRp2
         aiPT7tv+bIp64S5LgvNwqzXZvycCHtZb9FtdQWIeAkMF8JEQU8dMVdMwYwZz0e7f1NVW
         LONAVTVo8vdFpMegNqMEU9x0+s8Ogm6jLmzdrLuD5SbeqXT7b8sGd9i/zeqygqvXoqKJ
         OFvn/WWOBrfcNLybe5djnTJJyySijQc1LywYeyOOUb7gFHiPQaIcrNJkYpEz0ATQiiM5
         Kr4A==
X-Gm-Message-State: APjAAAUnj1UsMC1YR3+UOngbTwKyS7gHIGI1NguiIaTmzECV4Oxc+2E9
        zMgA29TvuP70ryUaBVyRcNbdhg==
X-Google-Smtp-Source: APXvYqzxf9q2pzvCOer/zrm6/W4Z5BkzeAcb6pguC267JTog7JQqRYkt2ViDmHMU+7mEiD3cc9ESaA==
X-Received: by 2002:a65:628b:: with SMTP id f11mr57246101pgv.95.1558133686865;
        Fri, 17 May 2019 15:54:46 -0700 (PDT)
Received: from tictac2.mtv.corp.google.com ([2620:15c:202:1:24fa:e766:52c9:e3b2])
        by smtp.gmail.com with ESMTPSA id u11sm11174450pfh.130.2019.05.17.15.54.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 May 2019 15:54:46 -0700 (PDT)
From:   Douglas Anderson <dianders@chromium.org>
To:     Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Cc:     linux-rockchip@lists.infradead.org,
        Double Lo <double.lo@cypress.com>, briannorris@chromium.org,
        Madhan Mohan R <madhanmohan.r@cypress.com>, mka@chromium.org,
        Wright Feng <wright.feng@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Douglas Anderson <dianders@chromium.org>,
        brcm80211-dev-list.pdl@broadcom.com,
        "David S. Miller" <davem@davemloft.net>,
        Franky Lin <franky.lin@broadcom.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Naveen Gupta <naveen.gupta@cypress.com>,
        brcm80211-dev-list@cypress.com, YueHaibing <yuehaibing@huawei.com>,
        Michael Trimarchi <michael@amarulasolutions.com>
Subject: [PATCH 3/3] brcmfmac: sdio: Disable auto-tuning around commands expected to fail
Date:   Fri, 17 May 2019 15:54:20 -0700
Message-Id: <20190517225420.176893-4-dianders@chromium.org>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
In-Reply-To: <20190517225420.176893-1-dianders@chromium.org>
References: <20190517225420.176893-1-dianders@chromium.org>
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

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 3fd2d58a3c88..c09bb8965487 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -27,6 +27,7 @@
 #include <linux/mmc/sdio_ids.h>
 #include <linux/mmc/sdio_func.h>
 #include <linux/mmc/card.h>
+#include <linux/mmc/core.h>
 #include <linux/semaphore.h>
 #include <linux/firmware.h>
 #include <linux/module.h>
@@ -708,6 +709,7 @@ brcmf_sdio_kso_control(struct brcmf_sdio *bus, bool on)
 		bmask = SBSDIO_FUNC1_SLEEPCSR_KSO_MASK;
 	}
 
+	mmc_expect_errors_begin(bus->sdiodev->func1->card->host);
 	do {
 		/* reliable KSO bit set/clr:
 		 * the sdiod sleep write access is synced to PMU 32khz clk
@@ -730,6 +732,7 @@ brcmf_sdio_kso_control(struct brcmf_sdio *bus, bool on)
 				   &err);
 
 	} while (try_cnt++ < MAX_KSO_ATTEMPTS);
+	mmc_expect_errors_end(bus->sdiodev->func1->card->host);
 
 	if (try_cnt > 2)
 		brcmf_dbg(SDIO, "try_cnt=%d rd_val=0x%x err=%d\n", try_cnt,
-- 
2.21.0.1020.gf2820cf01a-goog

