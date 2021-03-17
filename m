Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F151E33FB37
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 23:30:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231465AbhCQWaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 18:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231322AbhCQW3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 18:29:53 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D67C9C06174A
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 15:29:52 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id k8so236069iop.12
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 15:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bzduqesNyjPNy/1mWpQa5IsmwasAg4tlgXssFjc1C9k=;
        b=s9EKsfQ+8ayTPBV8HzWfcuM18JvhhpmjfB+c7EFu/EXaJGjE8xY4z6w2IVAGuYeH/q
         ropBOGzgfJIPT3XiHAITBxlzeM1iN0EVh0Hk2fcfw6uk7NOlR5WyzveSTLxtCxNY5I6d
         z/QmzvkNehgF4Pi3gZJFve4FzGzjNtcT6++qtuVI59O2PGEV4nzaHbm7jebR3ObckH/2
         y7gVu+/Qogf9locgp8VaJrX24l6IQiL5DCz0RmcsTeUXrLB6QznNRWesBmjlcOLmnAEL
         p5m4Ybl63Bh09VYRA5TiEZ5IcOvvaykm0BFw/yaxFB1Lm4FLR3sbNHJkUQHsVTXnLaSM
         hMBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bzduqesNyjPNy/1mWpQa5IsmwasAg4tlgXssFjc1C9k=;
        b=VEHuv3TH1uNTYTQikb1BzNt7e4Vs6xpxWJGJj22me+7Y+O2vjUYMAA5g5NM1K4gs7V
         BMlaUh1oXbHVjrAZblwMfU7wy9mfuzYJWxwmYmppikMwHhwiugyLv59WQvSnjb6J9ep6
         zyDoCl7Em3tnqSpOZxL715lOZT1flZ/dM991ZQvixXqIoVZAOoCQCTmcruR7VRr8bPe2
         PJJCIDwU9DKcCV+uWHB1xMKpj1/QApT/yM8a7a8C+BZaqqfdxGq+7KPLKnHt4oajmsLY
         s6+NZeYNYhQWjUflOEFAqJTIvsRGqmdytMleRy0w0vkY2dCFqoaj/eLQ+dqgTfG8BS/Z
         bkIg==
X-Gm-Message-State: AOAM532Qk0wgtnqfZS/oxSwo/V85QGSGOB1EWZpONbABKXHoZXHYNItS
        srpfNb2r9OO5S1yB2WSFf+am5Q==
X-Google-Smtp-Source: ABdhPJzQ8p9tZPhWpJl2bLJuVCaAjPwrnY4gLQ0c1jNk+XIivTBb7/Q9383/enx5RFvIXka4MuwkxA==
X-Received: by 2002:a02:7410:: with SMTP id o16mr4632619jac.37.1616020192373;
        Wed, 17 Mar 2021 15:29:52 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id f3sm176405ilk.74.2021.03.17.15.29.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 15:29:52 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/4] net: ipa: introduce dma_addr_high32()
Date:   Wed, 17 Mar 2021 17:29:44 -0500
Message-Id: <20210317222946.118125-3-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317222946.118125-1-elder@linaro.org>
References: <20210317222946.118125-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a new helper function to encapsulate extracting the
high-order 32 bits of a DMA address.  It returns 0 for builds
in which a DMA address is not 64 bits.

This avoids doing a 32-position shift on a DMA address if it
happens not to be 64 bits wide.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 2119367b93ea9..53698c64cf882 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -688,6 +688,16 @@ static void gsi_evt_ring_doorbell(struct gsi *gsi, u32 evt_ring_id, u32 index)
 	iowrite32(val, gsi->virt + GSI_EV_CH_E_DOORBELL_0_OFFSET(evt_ring_id));
 }
 
+/* Encapsulate extracting high-order 32 bits of DMA address */
+static u32 dma_addr_high32(dma_addr_t addr)
+{
+#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
+	return (u32)(addr >> 32);
+#else /* !CONFIG_ARCH_DMA_ADDR_T_64BIT */
+	return 0;
+#endif /* !CONFIG_ARCH_DMA_ADDR_T_64BIT */
+}
+
 /* Program an event ring for use */
 static void gsi_evt_ring_program(struct gsi *gsi, u32 evt_ring_id)
 {
@@ -711,7 +721,7 @@ static void gsi_evt_ring_program(struct gsi *gsi, u32 evt_ring_id)
 	val = evt_ring->ring.addr & GENMASK(31, 0);
 	iowrite32(val, gsi->virt + GSI_EV_CH_E_CNTXT_2_OFFSET(evt_ring_id));
 
-	val = evt_ring->ring.addr >> 32;
+	val = dma_addr_high32(evt_ring->ring.addr);
 	iowrite32(val, gsi->virt + GSI_EV_CH_E_CNTXT_3_OFFSET(evt_ring_id));
 
 	/* Enable interrupt moderation by setting the moderation delay */
@@ -819,7 +829,7 @@ static void gsi_channel_program(struct gsi_channel *channel, bool doorbell)
 	val = channel->tre_ring.addr & GENMASK(31, 0);
 	iowrite32(val, gsi->virt + GSI_CH_C_CNTXT_2_OFFSET(channel_id));
 
-	val = channel->tre_ring.addr >> 32;
+	val = dma_addr_high32(channel->tre_ring.addr);
 	iowrite32(val, gsi->virt + GSI_CH_C_CNTXT_3_OFFSET(channel_id));
 
 	/* Command channel gets low weighted round-robin priority */
-- 
2.27.0

