Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCB92FDC51
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 23:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731476AbhATWUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 17:20:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732540AbhATWFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 17:05:52 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE8C2C061793
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 14:04:09 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id x21so35860iog.10
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 14:04:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OTJ73KV2wfSd3Og0yq4LeI7FHZJzlHvLFa16f+6zrPU=;
        b=qMmPeSXkukYNoqJkku67SA1G23I8JZCr4XuQKGicdZPP3Bpw03KreZYU7v+kEaYC1Q
         FOXTVdY80Er7i2a0NxrT2CC18D9zpSl/oCSlIZsyxtCFJ2ife/K864V4sYpvoRSafRno
         uY21kxj86WBbnum3bRih7g3pwQ2udxm3LApvt4ZzzL5GNnauK2BB3ZJN5cTdjaV9Ts1q
         Kwgfk8RIN+2ulgzBv7nHavFjq/EgRjbVi45JuUImaxNYGC7aEUtxiTm24r2RMGrLysZI
         hv6uKDCHDQTbgV2P50USutj0PdJY9j8nIp5dCptX9cEafdOgarzQCWgO8nqvCbZahZDO
         27dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OTJ73KV2wfSd3Og0yq4LeI7FHZJzlHvLFa16f+6zrPU=;
        b=ehEX4ivsyKFDvOBoOC87vZ8GYxgL/skw4TiVorhA3NLaSEQJbQdyfSsrMSO8Q8VupO
         rArzxQ9Ivsx/GLM112VToLssaojGLas6XK+W0Fw0NBiYE1wlwlDaqExqBf3U59QGUQqh
         ZHMURI/DJ70y6jCExrRQODMxi1jm5yhsMoy9FuiU2Dj9Y36S9lu2eo00XUC/1zvTFdTk
         sUI8JKj+n33jg4KdywbVagAseOuhAJ+R31ZpsjMumQe22PgbSOmprW9TxR7qJH99GODa
         lZVKVYwO0Qy3pvkpMRfsBmOtDRb04zOkPPqYAJSrT31ib/z/fm99PUF8HMxyqZ4YZH39
         0v0w==
X-Gm-Message-State: AOAM5318woNShl0V6eg/fvclZjdC7WtAU4F+JYSvDq/NBFFRu33hXhEr
        pnoLHskC98EmCqnIancv4N4zeQ==
X-Google-Smtp-Source: ABdhPJxWMM6+rUMvjETF/zPh3JymEZXVPNDBR3JbeaWGQzDyxIWQf3lh4hUsnJDsn+BxgA//ewGXvQ==
X-Received: by 2002:a92:1e08:: with SMTP id e8mr9258420ile.16.1611180249244;
        Wed, 20 Jan 2021 14:04:09 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id e5sm1651712ilu.27.2021.01.20.14.04.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 14:04:08 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/5] net: ipa: repurpose gsi_irq_ieob_disable()
Date:   Wed, 20 Jan 2021 16:04:00 -0600
Message-Id: <20210120220401.10713-5-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210120220401.10713-1-elder@linaro.org>
References: <20210120220401.10713-1-elder@linaro.org>
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
index 5b98003263710..59fc22347a257 100644
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

