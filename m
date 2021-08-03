Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBD683DEF93
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 16:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236588AbhHCOBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 10:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236479AbhHCOB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 10:01:26 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FE6FC061799
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 07:01:14 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id h1so24360434iol.9
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 07:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9xgFJ2O3o+xh8TRsR9/dwHZ0i0/DPfaZ/VOsIjzUQQc=;
        b=pJQoaQvVUn3JNlOc3qa2UNUQeOtRG3JUgNv/NUMugpxH7VOCBRVsXw2QXW8JFkRbep
         gW0cSP5UpfReiKlli569aEtyPVKy9j5i8/plWbXFvUvrUiXjtHaX9gHZi9rGCsVLHUjT
         acSJqMXURRPcsfTw/oPUtjZ+7mgPMun8ikMCEdVkKqx2Wne9jgZ3pIZwDGmEEnucwed5
         FHHbK+kcZv5FyrEx8XmXUA8bnt9ERQHwN6IanyDdgwWo0tP3vVwPjk1BwbdL5e7ge4MR
         wSeKaUpJHTZ98PhIHORLybGkqDkWKC59jzXcX/rFTg6jApLk5AZdzpxajye0bk9lV1ip
         i22A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9xgFJ2O3o+xh8TRsR9/dwHZ0i0/DPfaZ/VOsIjzUQQc=;
        b=Chuz1+dTmn3wP28El54HhrSHWl9BRu0r26WJo9u8RjUSNxSZ8RMBquD8qy1fZRHyoQ
         ahBfMWihkNIGk/13+E7t2WATaCiLcl8jWepvYnWec0ozENe2M7dGoIS24dtFSuSLCApH
         YLzZzoK16WL4F0LLgjincfTREbyslgE9E7GEePJNwvsuY7Jes5/7U4gnxqUGt79aw7di
         ZkGnw8Dx3rv2cXYVbr5ykq2Y6hHOLHKSqdFP5nyJWT/MxHNXx6XM6NHBiNr45R4AOrbP
         Y/WLVrVs6vdorZH8WzrU+MQm0QGZ88YsNe3ImM9ZDOhnE3oYR+zN49mPtMVG7WrXfa0A
         b1+Q==
X-Gm-Message-State: AOAM533vJzH9txq+SnnbQJDOFHXErE+e11rp9EBeKImWhSSXBllhFVfd
        q790fCb65/KAcJyxKaUo6AukPA==
X-Google-Smtp-Source: ABdhPJwmEYbp7iZS3289pqyDtLfQtun6wK72L87ApIcQzS42M+TFhFgXsXQVBdeGIZndqoWrJG/JOQ==
X-Received: by 2002:a05:6602:1790:: with SMTP id y16mr2071136iox.12.1627999273887;
        Tue, 03 Aug 2021 07:01:13 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id w7sm9456798iox.1.2021.08.03.07.01.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 07:01:13 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 6/6] net: ipa: disable GSI interrupts while suspended
Date:   Tue,  3 Aug 2021 09:01:03 -0500
Message-Id: <20210803140103.1012697-7-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210803140103.1012697-1-elder@linaro.org>
References: <20210803140103.1012697-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce new functions gsi_suspend() and gsi_resume(), which will
disable the GSI interrupt handler after all endpoints are suspended
and re-enable it before endpoints are resumed.  This will ensure no
GSI interrupt handler will fire when the hardware is suspended.

Here's a little further explanation.  There are seven GSI interrupt
types, and most are disabled except when needed.
  - These two are not used (never enabled):
      GSI_INTER_EE_CH_CTRL
      GSI_INTER_EE_EV_CTRL
  - These two are only used to implement channel and event ring
    commands, and are only enabled while a command is underway:
      GSI_CH_CTRL
      GSI_EV_CTRL
  - The IEOB interrupt signals I/O completion.  It will not fire
    when a channel is stopped (or "suspended").
      GSI_IEOB
  - This interrupt is used to allocate or halt modem channels,
    and is only enabled while such a command is underway.
      GSI_GLOB_EE
    However it also is used to signal certain errors, and this could
    occur at any time.
  - The general interrupt signals general errors, and could occur at
    any time.
      GSI_GENERAL

The purpose for this change is to ensure no global or general
interrupts fire due to errors while the hardware is suspended.
We enable the clock on resume, and at that time we can "handle"
(at least report) these error conditions.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c      | 12 ++++++++++++
 drivers/net/ipa/gsi.h      | 12 ++++++++++++
 drivers/net/ipa/ipa_main.c |  5 ++++-
 3 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index c555ccd778bb8..a2fcdb1abdb96 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -981,6 +981,18 @@ int gsi_channel_resume(struct gsi *gsi, u32 channel_id)
 	return __gsi_channel_start(channel, true);
 }
 
+/* Prevent all GSI interrupts while suspended */
+void gsi_suspend(struct gsi *gsi)
+{
+	disable_irq(gsi->irq);
+}
+
+/* Allow all GSI interrupts again when resuming */
+void gsi_resume(struct gsi *gsi)
+{
+	enable_irq(gsi->irq);
+}
+
 /**
  * gsi_channel_tx_queued() - Report queued TX transfers for a channel
  * @channel:	Channel for which to report
diff --git a/drivers/net/ipa/gsi.h b/drivers/net/ipa/gsi.h
index 97163b58b4ebc..88b80dc3db79f 100644
--- a/drivers/net/ipa/gsi.h
+++ b/drivers/net/ipa/gsi.h
@@ -232,6 +232,18 @@ int gsi_channel_stop(struct gsi *gsi, u32 channel_id);
  */
 void gsi_channel_reset(struct gsi *gsi, u32 channel_id, bool doorbell);
 
+/**
+ * gsi_suspend() - Prepare the GSI subsystem for suspend
+ * @gsi:	GSI pointer
+ */
+void gsi_suspend(struct gsi *gsi);
+
+/**
+ * gsi_resume() - Resume the GSI subsystem following suspend
+ * @gsi:	GSI pointer
+ */
+void gsi_resume(struct gsi *gsi);
+
 /**
  * gsi_channel_suspend() - Suspend a GSI channel
  * @gsi:	GSI pointer
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 2e728d4914c82..ae51109dea01b 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -892,6 +892,7 @@ static int ipa_suspend(struct device *dev)
 	if (ipa->setup_complete) {
 		__clear_bit(IPA_FLAG_RESUMED, ipa->flags);
 		ipa_endpoint_suspend(ipa);
+		gsi_suspend(&ipa->gsi);
 	}
 
 	ipa_clock_put(ipa);
@@ -919,8 +920,10 @@ static int ipa_resume(struct device *dev)
 	ipa_clock_get(ipa);
 
 	/* Endpoints aren't usable until setup is complete */
-	if (ipa->setup_complete)
+	if (ipa->setup_complete) {
+		gsi_resume(&ipa->gsi);
 		ipa_endpoint_resume(ipa);
+	}
 
 	return 0;
 }
-- 
2.27.0

