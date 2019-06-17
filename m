Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D737D48B12
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 19:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728745AbfFQR7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 13:59:18 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45160 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728733AbfFQR7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 13:59:15 -0400
Received: by mail-pf1-f193.google.com with SMTP id r1so6081763pfq.12
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 10:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gukKhFSULA/cUvkTjo5/+HGI1qG1vr2u7fmWrwDOvpo=;
        b=jiiND4P5qU8Y/H5AW6gpozQxINq32kXq8a21pgnFiksPAlWxBnSNxyM41KYPgXEEHj
         nLrxpTPdz2JzWt2ss/bpp6VnqYbvLLIJVhRGH93B1cSXrKDQcKXeZGQNwTimVYjHGMBz
         YXVD6+ew99DZjtBQIpRsSM23r2Y/O1G7MoO+c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gukKhFSULA/cUvkTjo5/+HGI1qG1vr2u7fmWrwDOvpo=;
        b=skjvjrPMO9E/B7zp95P9LMirSNyKmP4yI7hZ3KvG4NyP+mpSrKmBq+lRyfdtXmMct+
         U74N6rnYCB5Do7ABBKE38eotqihiXgTdzGEjmD2Cd/6sQ9YEVoz2nChAGRqzu+66STi2
         akKIHJvi++d51j3LUhhWQ6mVKgXM5UX0+oeAShFoOr1LHQNpluqaTxzVn1kpVGLWQllp
         CIvDUSbXS+Guhi1WTTAtxkk7ZSD6OsmYU1rSFHUKlOdqtfzTPt4vswiItzFwrTC7ZFlw
         a63uOBE2TOCuqo7Xh/pT7srmWshEML342Q7m/HSoNG4qgIDiUqcrG726zAUuUpeNM2Pe
         dx/Q==
X-Gm-Message-State: APjAAAUH8Ye9mWXYXog+iJmvtm+vSAwEYi4Fxpel77HM1HLKk9iRmC5O
        fRaOZSUprpils5DQv9DXBGc53Q==
X-Google-Smtp-Source: APXvYqzdCSj0uI6G5zQQeqkog1Napf/2heNE90tChRbx7D/xUVbfnn1JUIW8D1+k8m93FMtgdBP5aw==
X-Received: by 2002:a62:1b85:: with SMTP id b127mr115821200pfb.165.1560794353481;
        Mon, 17 Jun 2019 10:59:13 -0700 (PDT)
Received: from tictac2.mtv.corp.google.com ([2620:15c:202:1:24fa:e766:52c9:e3b2])
        by smtp.gmail.com with ESMTPSA id q1sm15145809pfn.178.2019.06.17.10.59.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 17 Jun 2019 10:59:11 -0700 (PDT)
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
        stable@vger.kernel.org, Allison Randal <allison@lohutok.net>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v5 4/5] mmc: core: Add sdio_retune_hold_now() and sdio_retune_release()
Date:   Mon, 17 Jun 2019 10:56:52 -0700
Message-Id: <20190617175653.21756-5-dianders@chromium.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190617175653.21756-1-dianders@chromium.org>
References: <20190617175653.21756-1-dianders@chromium.org>
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

Cc: stable@vger.kernel.org
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
---
Patches #2 - #5 will go through Ulf's tree.

I've CCed stable@ here without a version tag.  As per Adrian Hunter
this patch applies cleanly to 4.18+ so that would be an easy first
target.  However, if someone were so inclined they could provide
further backports.  As per Adrian [1] the root problem has existed for
~4 years.

[1] https://lkml.kernel.org/r/4f39e152-04ba-a64e-985a-df93e6d15ff8@intel.com

Changes in v5: None
Changes in v4:
- Moved retune hold/release to SDIO API (Adrian).

Changes in v3:
- ("mmc: core: Export mmc_retune_hold_now() mmc_retune_release()") new for v3.

Changes in v2: None

 drivers/mmc/core/sdio_io.c    | 40 +++++++++++++++++++++++++++++++++++
 include/linux/mmc/sdio_func.h |  3 +++
 2 files changed, 43 insertions(+)

diff --git a/drivers/mmc/core/sdio_io.c b/drivers/mmc/core/sdio_io.c
index 0acb1a29c968..2ba00acf64e6 100644
--- a/drivers/mmc/core/sdio_io.c
+++ b/drivers/mmc/core/sdio_io.c
@@ -15,6 +15,7 @@
 #include "sdio_ops.h"
 #include "core.h"
 #include "card.h"
+#include "host.h"
 
 /**
  *	sdio_claim_host - exclusively claim a bus for a certain SDIO function
@@ -771,3 +772,42 @@ void sdio_retune_crc_enable(struct sdio_func *func)
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
2.22.0.410.gd8fdbe21b5-goog

