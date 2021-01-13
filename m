Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 398892F50E2
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 18:17:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728212AbhAMRRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 12:17:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728126AbhAMRQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 12:16:58 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D584DC0617A9
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 09:15:41 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id y19so5671323iov.2
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 09:15:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9HP5QJchHpYyjOaAf3lP3KAwAYZ3mwgofh4y4UljDvM=;
        b=AHdCpwhK97XEhzE6KaoVys78e8zun3noFVwcwXWVGjOD6NjAnDi1pM1OP7CEQLvKf4
         DR670E9/PS3jDvNT5NBz001lF91xZC/U0jI9R2mmddz5rUrA7zhWc5K4awqOqlqAuzGB
         Att4bp/gXCF6wa9oub1iQPUSi6Hou3FZqfoq0B5Ah5/oXs+3WILsE/jWfxngz1DKDien
         n54dI6ix40kCPgeNCzOALbwWFzOWy2smb32xUk2cYDrPfOcg3NgUNGPfyYnmKH0XOvG2
         KB73bDsM4Hi1zGxPxixGNR+MWMKBoDZ4LWlw8Fy5KgLKpt9SzW60qjD9TY49SvgePE8x
         ZMwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9HP5QJchHpYyjOaAf3lP3KAwAYZ3mwgofh4y4UljDvM=;
        b=B9Vf4iMnR5pceSzRiXE4GuiahEGnt24dqPodyfNqat9YWgCw2DLeK2ez2p0KC+3/mB
         YXB3Fr+znd236q2M2jSv7dKzxwtPUibnAhyKH5P4s4Zls5cg8YI/QqsW0o/4nsjfNQh7
         EPt48tRRxM6bg6SK/9hAGfFFsFWOXNCVeFcDHsm5INn6uo9bPuSXyzVrJx7ONnBRrrsO
         HnCd+25no+ECChUwJG7ZY5fNx+KQfiPVz7VyjnBq5cMfU534PIfnV0z9EgcyXyfBySBj
         CVTo7v9liP2XHyTgejcr8miu3zHWXDwYRNxglUGQ8kmsyHTv6+48PJTS1NKQcYS5onIy
         k4Ng==
X-Gm-Message-State: AOAM5304RF5IVfzyeqPFUdS74BWu49s5HuG9rPWKCCo+csNfcIgktzW4
        5ZWAgdtax4SzX9QiSpgLz15LDQ==
X-Google-Smtp-Source: ABdhPJz9zCzSka5zLcCuOh0/8P/Qdzmqj2EEZyCAhM9sJD5VKvN91qQR224sw2tjRW89mhZFLBOYQA==
X-Received: by 2002:a05:6638:2243:: with SMTP id m3mr3267192jas.115.1610558141221;
        Wed, 13 Jan 2021 09:15:41 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id h9sm1120579ili.43.2021.01.13.09.15.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 09:15:40 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/6] net: ipa: change GSI command timeout
Date:   Wed, 13 Jan 2021 11:15:30 -0600
Message-Id: <20210113171532.19248-5-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210113171532.19248-1-elder@linaro.org>
References: <20210113171532.19248-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The GSI command timeout is currently 5 seconds, which is much higher
than it should be.

Express the timeout in milliseconds rather than seconds, and reduce
it to 50 milliseconds.

Fixes: 650d1603825d8 ("soc: qcom: ipa: the generic software interface")
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 93b143ba92be5..4de769166978b 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -89,7 +89,7 @@
 /* Delay period for interrupt moderation (in 32KHz IPA internal timer ticks) */
 #define GSI_EVT_RING_INT_MODT		(32 * 1) /* 1ms under 32KHz clock */
 
-#define GSI_CMD_TIMEOUT			5	/* seconds */
+#define GSI_CMD_TIMEOUT			50	/* milliseconds */
 
 #define GSI_CHANNEL_STOP_RX_RETRIES	10
 #define GSI_CHANNEL_MODEM_HALT_RETRIES	10
@@ -359,11 +359,13 @@ static u32 gsi_ring_index(struct gsi_ring *ring, u32 offset)
 static bool
 gsi_command(struct gsi *gsi, u32 reg, u32 val, struct completion *completion)
 {
+	unsigned long timeout = msecs_to_jiffies(GSI_CMD_TIMEOUT);
+
 	reinit_completion(completion);
 
 	iowrite32(val, gsi->virt + reg);
 
-	return !!wait_for_completion_timeout(completion, GSI_CMD_TIMEOUT * HZ);
+	return !!wait_for_completion_timeout(completion, timeout);
 }
 
 /* Return the hardware's notion of the current state of an event ring */
-- 
2.20.1

