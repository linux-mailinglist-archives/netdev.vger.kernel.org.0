Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 879CE398F5
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 00:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731394AbfFGWiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 18:38:13 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38585 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731500AbfFGWhn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 18:37:43 -0400
Received: by mail-pl1-f194.google.com with SMTP id f97so1342045plb.5
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 15:37:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=U1Ebpn5sqJxVeDjM8NV6sp+M7Ulx/T6T1ihRForNiZk=;
        b=Fi4fr1iKul90yPOJYhRoZAs0JfmWDCdK83HoFAtKwI0sa5Hmq71Np5w+DUGRnvlKSA
         b2NFI2LFjgVQ90kWVGfFESnSRwT8+RuSbO0c7JI9vT7zJDfnv5W98nxlOQtdT3otquGX
         P6fGnDg2wLxeP+LllQUHw0fUUVAlmkG5hWQSI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U1Ebpn5sqJxVeDjM8NV6sp+M7Ulx/T6T1ihRForNiZk=;
        b=tK1HtBAQrMbnIOQTqg/q2P976lfMCVsr1yN+LGo9ROWq+WF9JQ/+LNeXiBISV7ytyJ
         GWpaP17SOAoF/mikF1YeOOBAJ3iE0b76sVXD8VI0pjfJwZyl8DkM5GaqO8w3wbPbgFVL
         5nFKhf/+MCtMgvv/rAxD+PaSebtLV48vHn/4e4v+DLloiN7Ywo+rVHGAIq3w6CWn4hSw
         IVM7GrjxgLI+SpPLPsswIM/vt7NeFJ/6/KXzqE+xStTuXLqmCZUdzOfek1LA+lLPCTN0
         1qHoauxNyVlL00N52G3uNgDpvfY6SHxEW8Wp9OXFSz5PVEXHzxxmWmJVW9Avc2DTnCqi
         p0Gw==
X-Gm-Message-State: APjAAAUYOEWWXHuXOEzgBluOpYV+K+7cbjCDu+KpJIzTotbwmdYFSSle
        /Q7QAvMfRVfOe1rQc8BNccnyqw==
X-Google-Smtp-Source: APXvYqx6fo8W+foYQLpakl+ecnh//DcmwJfox7qyAVeK0zqYD9gJhLmGN07/cvV+AvtMzg3L3jRNdA==
X-Received: by 2002:a17:902:42e2:: with SMTP id h89mr58422930pld.332.1559947062929;
        Fri, 07 Jun 2019 15:37:42 -0700 (PDT)
Received: from tictac2.mtv.corp.google.com ([2620:15c:202:1:24fa:e766:52c9:e3b2])
        by smtp.gmail.com with ESMTPSA id j23sm4185193pgb.63.2019.06.07.15.37.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 07 Jun 2019 15:37:42 -0700 (PDT)
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
        Jiong Wu <lohengrin1024@gmail.com>,
        Ritesh Harjani <riteshh@codeaurora.org>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v3 2/5] mmc: core: API for temporarily disabling auto-retuning due to errors
Date:   Fri,  7 Jun 2019 15:37:13 -0700
Message-Id: <20190607223716.119277-3-dianders@chromium.org>
X-Mailer: git-send-email 2.22.0.rc2.383.gf4fbbf30c2-goog
In-Reply-To: <20190607223716.119277-1-dianders@chromium.org>
References: <20190607223716.119277-1-dianders@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Normally when the MMC core sees an "-EILSEQ" error returned by a host
controller then it will trigger a retuning of the card.  This is
generally a good idea.

However, if a command is expected to sometimes cause transfer errors
then these transfer errors shouldn't cause a re-tuning.  This
re-tuning will be a needless waste of time.  One example case where a
transfer is expected to cause errors is when transitioning between
idle (sometimes referred to as "sleep" in Broadcom code) and active
state on certain Broadcom WiFi cards.  Specifically if the card was
already transitioning between states when the command was sent it
could cause an error on the SDIO bus.

Let's add an API that the SDIO card drivers can call that will
temporarily disable the auto-tuning functionality.  Then we can add a
call to this in the Broadcom WiFi driver and any other driver that
might have similar needs.

NOTE: this makes the assumption that the card is already tuned well
enough that it's OK to disable the auto-retuning during one of these
error-prone situations.  Presumably the driver code performing the
error-prone transfer knows how to recover / retry from errors.  ...and
after we can get back to a state where transfers are no longer
error-prone then we can enable the auto-retuning again.  If we truly
find ourselves in a case where the card needs to be retuned sometimes
to handle one of these error-prone transfers then we can always try a
few transfers first without auto-retuning and then re-try with
auto-retuning if the first few fail.

Without this change on rk3288-veyron-minnie I periodically see this in
the logs of a machine just sitting there idle:
  dwmmc_rockchip ff0d0000.dwmmc: Successfully tuned phase to XYZ

Fixes: bd11e8bd03ca ("mmc: core: Flag re-tuning is needed on CRC errors")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
---
Note that are are a whole boatload of different ways that we could
provide an API for the Broadcom WiFi SDIO driver.  This patch
illustrates one way but if maintainers feel strongly that this is too
ugly and have a better idea then I can give it a shot too.  From a
purist point of view I kinda felt that the "expect errors" really
belonged as part of the mmc_request structure, but getting it into
there meant changing a whole pile of core SD/MMC APIs.  Simply adding
it to the host seemed to match the current style better and was a less
intrusive change.

Changes in v3:
- Took out the spinlock since I believe this is all in one context.

Changes in v2:
- Updated commit message to clarify based on discussion of v1.

 drivers/mmc/core/core.c  | 19 +++++++++++++++++--
 include/linux/mmc/core.h |  2 ++
 include/linux/mmc/host.h |  1 +
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 6db36dc870b5..bc109ec49406 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -144,8 +144,9 @@ void mmc_request_done(struct mmc_host *host, struct mmc_request *mrq)
 	int err = cmd->error;
 
 	/* Flag re-tuning needed on CRC errors */
-	if ((cmd->opcode != MMC_SEND_TUNING_BLOCK &&
-	    cmd->opcode != MMC_SEND_TUNING_BLOCK_HS200) &&
+	if (cmd->opcode != MMC_SEND_TUNING_BLOCK &&
+	    cmd->opcode != MMC_SEND_TUNING_BLOCK_HS200 &&
+	    !host->expect_errors &&
 	    (err == -EILSEQ || (mrq->sbc && mrq->sbc->error == -EILSEQ) ||
 	    (mrq->data && mrq->data->error == -EILSEQ) ||
 	    (mrq->stop && mrq->stop->error == -EILSEQ)))
@@ -2163,6 +2164,20 @@ int mmc_sw_reset(struct mmc_host *host)
 }
 EXPORT_SYMBOL(mmc_sw_reset);
 
+void mmc_expect_errors_begin(struct mmc_host *host)
+{
+	WARN_ON(host->expect_errors);
+	host->expect_errors = true;
+}
+EXPORT_SYMBOL_GPL(mmc_expect_errors_begin);
+
+void mmc_expect_errors_end(struct mmc_host *host)
+{
+	WARN_ON(!host->expect_errors);
+	host->expect_errors = false;
+}
+EXPORT_SYMBOL_GPL(mmc_expect_errors_end);
+
 static int mmc_rescan_try_freq(struct mmc_host *host, unsigned freq)
 {
 	host->f_init = freq;
diff --git a/include/linux/mmc/core.h b/include/linux/mmc/core.h
index 134a6483347a..02a13abf0cda 100644
--- a/include/linux/mmc/core.h
+++ b/include/linux/mmc/core.h
@@ -178,6 +178,8 @@ int mmc_wait_for_cmd(struct mmc_host *host, struct mmc_command *cmd,
 
 int mmc_hw_reset(struct mmc_host *host);
 int mmc_sw_reset(struct mmc_host *host);
+void mmc_expect_errors_begin(struct mmc_host *host);
+void mmc_expect_errors_end(struct mmc_host *host);
 void mmc_set_data_timeout(struct mmc_data *data, const struct mmc_card *card);
 
 #endif /* LINUX_MMC_CORE_H */
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 43d0f0c496f6..8d553fb8c834 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -398,6 +398,7 @@ struct mmc_host {
 	unsigned int		retune_now:1;	/* do re-tuning at next req */
 	unsigned int		retune_paused:1; /* re-tuning is temporarily disabled */
 	unsigned int		use_blk_mq:1;	/* use blk-mq */
+	unsigned int		expect_errors:1; /* don't trigger retune upon errors */
 
 	int			rescan_disable;	/* disable card detection */
 	int			rescan_entered;	/* used with nonremovable devices */
-- 
2.22.0.rc2.383.gf4fbbf30c2-goog

