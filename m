Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 123A245039
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 01:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727859AbfFMXm3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 19:42:29 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41460 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727563AbfFMXmN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 19:42:13 -0400
Received: by mail-pg1-f193.google.com with SMTP id 83so389143pgg.8
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 16:42:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=00LaqICpwM9YOieDteVKl28OeJvNxsjKf3w+38t5DQM=;
        b=MvLy9Z5wXSd9OviDwGx/a9f6GyaM1INYAiT0IsoEyf4KpOIaHa3eRMwuu5IO/O0HlA
         TnzMGBOrhOLake233PtHLia0lHm7DQz/GTZzDlnZYZJBJieXnzpvxpYc05eDbq1aR4A4
         uv4Ma5UYC9SOgb0nuN11vIzWnPCFi0ZY9ey8I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=00LaqICpwM9YOieDteVKl28OeJvNxsjKf3w+38t5DQM=;
        b=gU53DTKPyLe3Wg+Bl6ub2EYPH6imhLDV6sS3LNj6GU5IQ67D2Z5PjcQCibZ9C4iSrz
         MHGtB8M6dYcunzs3aiyRPto6Sbepe4lBtNq73jhobKmRfVce5soEayiFMzSFn1O5Aaek
         nI64gT5PUBLvFNKXMJ2NwvcakMEwGK/UGdtr8l+vzBwMohes+y2L/UjWqY4gn5rKhPnD
         WD5QCbONqIW36cp8dngQ4ZyIjyUS1+AJYPzwmiCNxNFA0hB0htQJOmgXMg5T+ev6jZmN
         S5LYB8m4VyxNUfLz/MQ1xMAKLWJBHOhLxuwjCPL7pPdMoVYd1DqncgshXUFsgsFECKqf
         SsNw==
X-Gm-Message-State: APjAAAXD4Lq4KjAXxWgToBRNBNfe8RoO63HRosD43OrCOox/tlOJrsJx
        EWZOJ/pOaE3TZTL3o1okKEjXhw==
X-Google-Smtp-Source: APXvYqz3Xqez9uoGK3fVk6+p5Ke5NypkmIbmDEcShWic6SM+R4pi58ILoJD0wSRRnhH8nE17iF/u1w==
X-Received: by 2002:a17:90a:db42:: with SMTP id u2mr8109422pjx.48.1560469333161;
        Thu, 13 Jun 2019 16:42:13 -0700 (PDT)
Received: from tictac2.mtv.corp.google.com ([2620:15c:202:1:24fa:e766:52c9:e3b2])
        by smtp.gmail.com with ESMTPSA id p7sm781088pfp.131.2019.06.13.16.42.11
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 13 Jun 2019 16:42:12 -0700 (PDT)
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
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v4 4/5] mmc: core: Add sdio_retune_hold_now() and sdio_retune_release()
Date:   Thu, 13 Jun 2019 16:41:52 -0700
Message-Id: <20190613234153.59309-5-dianders@chromium.org>
X-Mailer: git-send-email 2.22.0.rc2.383.gf4fbbf30c2-goog
In-Reply-To: <20190613234153.59309-1-dianders@chromium.org>
References: <20190613234153.59309-1-dianders@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We want SDIO drivers to be able to temporarily stop retuning when the
driver knows that the SDIO card is not in a state where retuning will
work (maybe because the card is asleep).  We'll move the relevant
functions to a place where drivers can call them.

Signed-off-by: Douglas Anderson <dianders@chromium.org>
---

Changes in v4:
- Moved retune hold/release to SDIO API (Adrian).

Changes in v3:
- ("mmc: core: Export mmc_retune_hold_now() mmc_retune_release()") new for v3.

Changes in v2: None

 drivers/mmc/core/sdio_io.c    | 40 +++++++++++++++++++++++++++++++++++
 include/linux/mmc/sdio_func.h |  3 +++
 2 files changed, 43 insertions(+)

diff --git a/drivers/mmc/core/sdio_io.c b/drivers/mmc/core/sdio_io.c
index f822a9630b0e..1b6fe737bd72 100644
--- a/drivers/mmc/core/sdio_io.c
+++ b/drivers/mmc/core/sdio_io.c
@@ -15,6 +15,7 @@
 #include "sdio_ops.h"
 #include "core.h"
 #include "card.h"
+#include "host.h"
 
 /**
  *	sdio_claim_host - exclusively claim a bus for a certain SDIO function
@@ -770,3 +771,42 @@ void sdio_retune_crc_enable(struct sdio_func *func)
 	func->card->host->retune_crc_disable = false;
 }
 EXPORT_SYMBOL_GPL(sdio_retune_crc_enable);
+
+/**
+ *	sdio_retune_hold_now - start deferring retuning requests till release
+ *	@func: SDIO function attached to host
+ *
+ *	This function can be called if it's currently a bad time to do
+ *	a retune of the SDIO card.  Retune requests made during this time
+ *	will be held and we'll actually do the retune sometime after the
+ *	release.
+ *
+ *	This function could be useful if an SDIO card is in a power state
+ *	where it can respond to a small subset of commands that doesn't
+ *	include the retuning command.  Care should be taken when using
+ *	this function since (presumably) the retuning request we might be
+ *	deferring was made for a good reason.
+ *
+ *	This function should be called while the host is claimed.
+ */
+void sdio_retune_hold_now(struct sdio_func *func)
+{
+	mmc_retune_hold_now(func->card->host);
+}
+EXPORT_SYMBOL_GPL(sdio_retune_hold_now);
+
+/**
+ *	sdio_retune_release - signal that it's OK to retune now
+ *	@func: SDIO function attached to host
+ *
+ *	This is the complement to sdio_retune_hold_now().  Calling this
+ *	function won't make a retune happen right away but will allow
+ *	them to be scheduled normally.
+ *
+ *	This function should be called while the host is claimed.
+ */
+void sdio_retune_release(struct sdio_func *func)
+{
+	mmc_retune_release(func->card->host);
+}
+EXPORT_SYMBOL_GPL(sdio_retune_release);
diff --git a/include/linux/mmc/sdio_func.h b/include/linux/mmc/sdio_func.h
index 4820e6d09dac..5a177f7a83c3 100644
--- a/include/linux/mmc/sdio_func.h
+++ b/include/linux/mmc/sdio_func.h
@@ -170,4 +170,7 @@ extern int sdio_set_host_pm_flags(struct sdio_func *func, mmc_pm_flag_t flags);
 extern void sdio_retune_crc_disable(struct sdio_func *func);
 extern void sdio_retune_crc_enable(struct sdio_func *func);
 
+extern void sdio_retune_hold_now(struct sdio_func *func);
+extern void sdio_retune_release(struct sdio_func *func);
+
 #endif /* LINUX_MMC_SDIO_FUNC_H */
-- 
2.22.0.rc2.383.gf4fbbf30c2-goog

