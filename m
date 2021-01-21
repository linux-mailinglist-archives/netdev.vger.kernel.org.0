Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9272FE954
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 12:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730602AbhAULvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 06:51:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730787AbhAULt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 06:49:56 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F3DDC061793
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 03:48:29 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id p72so3278421iod.12
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 03:48:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=za0GhtZfftGjQIdCUc6UBpGtSoxmgmTkf3cBAKgV72E=;
        b=FeACznIVgzKKWzoON26G1ss3btkUAs3Rz2YF5t+/ESI9h24h6SJbOT8CVVcFbyOFag
         nH4YeSUG/hI8spQlAJL8vBea6eaqArrG8HW8T2vOXIlOB0mC+xlAZ+1STmi7IFN0ba29
         obpBbb7pX80S2cziWFrRyplE+5nQc9MI2Fu+w1WWZwvFeLqkN4UxTWbXZgZKhMAP836z
         X0VwY8bcOo5SlKu/LMgrGdgGG1T/XP/1YAYeBrKtc+qc1cnw4ZK61P3h6RG9IZZ4qERz
         n6si1iuvvOEy/zo6pJYGPFXkA5snEjZrk+PMPbReTFSDuInf56BrynrHm8G93SxP7aLv
         LVmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=za0GhtZfftGjQIdCUc6UBpGtSoxmgmTkf3cBAKgV72E=;
        b=awn+u1MT9xhk0Ar1+iq/HhAInFNCX+hvsQ69h+PKn44UiCQv7jwC5HlK7yAxa7zgvZ
         bPUJReA5BvG7WoAG4V7fHkrxWN3e5kFP/FHhDWanZrHlGWdr+ujH6OtmnkWDLFB1fcwh
         4AyTW8THZlBa69ytAWW/2TZbSvnm8l4iBiLKoB2TWa3Cn/xZmCqy9LJlZf8Er4yPFfjP
         n/MBdcDqpnFx216J3thLNjprBFLuHAUT983IOvljjQdedZ0OyB9LdFrZ22aRCxgl8LBv
         iT4Fwav9AJulWaFS4/WRD8q4FcEmZyggmY0YTAvAXHmEwQEWno1d7iP1HshNXsZH2S0m
         epxg==
X-Gm-Message-State: AOAM533vKE2ly1DK5HQfTmyFsFv4s19tbe9PH8TAWwHOw1KpjNQsMnwE
        murZvaOmnZtl43LFkBZsy8ohpA==
X-Google-Smtp-Source: ABdhPJyxCYrBAoHqD+uZuruaw7nvcoO5TPFgN8Jz/eG20P4zF4S+u6jNIOfxk0KV+0A1mGp9H9osRg==
X-Received: by 2002:a92:7b07:: with SMTP id w7mr11084031ilc.78.1611229709015;
        Thu, 21 Jan 2021 03:48:29 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id p5sm2762766ilm.80.2021.01.21.03.48.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 03:48:28 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 4/5] net: ipa: repurpose gsi_irq_ieob_disable()
Date:   Thu, 21 Jan 2021 05:48:20 -0600
Message-Id: <20210121114821.26495-5-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210121114821.26495-1-elder@linaro.org>
References: <20210121114821.26495-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename gsi_irq_ieob_disable() to be gsi_irq_ieob_disable_one().

Introduce a new function gsi_irq_ieob_disable() that takes a mask of
events to disable rather than a single event id.  This will be used
in the next patch.

Rename gsi_irq_ieob_enable() to be gsi_irq_ieob_enable_one() to be
consistent.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 6e5817e16c0f6..0391f5a207c9f 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -272,7 +272,7 @@ static void gsi_irq_ch_ctrl_disable(struct gsi *gsi)
 	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_CH_IRQ_MSK_OFFSET);
 }
 
-static void gsi_irq_ieob_enable(struct gsi *gsi, u32 evt_ring_id)
+static void gsi_irq_ieob_enable_one(struct gsi *gsi, u32 evt_ring_id)
 {
 	bool enable_ieob = !gsi->ieob_enabled_bitmap;
 	u32 val;
@@ -286,11 +286,11 @@ static void gsi_irq_ieob_enable(struct gsi *gsi, u32 evt_ring_id)
 		gsi_irq_type_enable(gsi, GSI_IEOB);
 }
 
-static void gsi_irq_ieob_disable(struct gsi *gsi, u32 evt_ring_id)
+static void gsi_irq_ieob_disable(struct gsi *gsi, u32 event_mask)
 {
 	u32 val;
 
-	gsi->ieob_enabled_bitmap &= ~BIT(evt_ring_id);
+	gsi->ieob_enabled_bitmap &= ~event_mask;
 
 	/* Disable the interrupt type if this was the last enabled channel */
 	if (!gsi->ieob_enabled_bitmap)
@@ -300,6 +300,11 @@ static void gsi_irq_ieob_disable(struct gsi *gsi, u32 evt_ring_id)
 	iowrite32(val, gsi->virt + GSI_CNTXT_SRC_IEOB_IRQ_MSK_OFFSET);
 }
 
+static void gsi_irq_ieob_disable_one(struct gsi *gsi, u32 evt_ring_id)
+{
+	gsi_irq_ieob_disable(gsi, BIT(evt_ring_id));
+}
+
 /* Enable all GSI_interrupt types */
 static void gsi_irq_enable(struct gsi *gsi)
 {
@@ -766,13 +771,13 @@ static void gsi_channel_freeze(struct gsi_channel *channel)
 
 	napi_disable(&channel->napi);
 
-	gsi_irq_ieob_disable(channel->gsi, channel->evt_ring_id);
+	gsi_irq_ieob_disable_one(channel->gsi, channel->evt_ring_id);
 }
 
 /* Allow transactions to be used on the channel again. */
 static void gsi_channel_thaw(struct gsi_channel *channel)
 {
-	gsi_irq_ieob_enable(channel->gsi, channel->evt_ring_id);
+	gsi_irq_ieob_enable_one(channel->gsi, channel->evt_ring_id);
 
 	napi_enable(&channel->napi);
 }
@@ -1207,7 +1212,7 @@ static void gsi_isr_ieob(struct gsi *gsi)
 
 		event_mask ^= BIT(evt_ring_id);
 
-		gsi_irq_ieob_disable(gsi, evt_ring_id);
+		gsi_irq_ieob_disable_one(gsi, evt_ring_id);
 		napi_schedule(&gsi->evt_ring[evt_ring_id].channel->napi);
 	}
 }
@@ -1555,7 +1560,7 @@ static int gsi_channel_poll(struct napi_struct *napi, int budget)
 	}
 
 	if (count < budget && napi_complete(napi))
-		gsi_irq_ieob_enable(channel->gsi, channel->evt_ring_id);
+		gsi_irq_ieob_enable_one(channel->gsi, channel->evt_ring_id);
 
 	return count;
 }
-- 
2.20.1

