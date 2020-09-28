Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFE1927B7B2
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 01:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbgI1XOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 19:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727035AbgI1XNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 19:13:42 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8327C05BD13
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 16:04:55 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id s88so3004426ilb.6
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 16:04:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AXEpWEjYq3xYWFeLhdW5zwNJ04L4pgPCHJ/yRPl+/W8=;
        b=gAYeKowTjPCv9pyzlkfWn1LD0GFTzo7Yk8z6Jh7ek/OfX2ec8EYa47jzCGrGOQ6Nsa
         3ctPAoP0YfmPNsAIbSa6PAEIZm61FS/bFqLo9wxkLqSnbyS3j4pNmkzO91GD3ho9mSQs
         jR6oG4fO9265OIi4QDCQ17l/oRUTKFfAKVrL8VyZ4KIHiyacZpXH2XiiZOMlrwe+VVb5
         QIYkALGECjaM8o1TdxZ6Jxu/Rw5Fk5cDzzfavXZgUn9x0drd7PSkvBAHe3WhoC+pI4GQ
         9wMhaVlKQXoDXLh5ZmXvVcBiHFxdhvibwpvVBKvGEa5NYs9HazLpzYhy3l+dbVlLZt5O
         TRiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AXEpWEjYq3xYWFeLhdW5zwNJ04L4pgPCHJ/yRPl+/W8=;
        b=FFtm6jCng8FvRzvMxBwRR7lgng0RxeQstiSkfthwkwXl0wGZMZEYmvADSHLwXseDVK
         bUr4oDj+SQsE/bXnWAna3U/jFyh5llWmLqnNf/MCRYS8LqhUSvOqIruIjq/jIY42MMix
         Cgjif8QX5K3mkXJkPzVVBsBbLNkiWytEzuuEMcjRbPNL0CXeawioZVP59J81+XZ5Y2yi
         ZhJtZcDsLW6vPW0MbhEuHAS80I/GWEoFCCx0avDdTrrF6b8Fh+dXmeGfbs+G4CatXYGc
         iJ2aF4yJkq47g5JxXy/7W+/ioV2bUuJ5ACww2rOqoo2beZauuYmjW5DxXyOhd/gYHKKS
         KsuQ==
X-Gm-Message-State: AOAM531knKC8B9olxiUqM2wyzliDelSGry5NNi3UFt7OKlobj5YGK5UV
        8dZbmCCoKHxnTROt18H05ugIbA==
X-Google-Smtp-Source: ABdhPJwvFpPVTBt4LP+fEruF9IcFV9gAAZMtMuNBjF/N3RuhvkIyW8eQDjNduIwTanSO21Mr01/FVA==
X-Received: by 2002:a92:243:: with SMTP id 64mr254026ilc.298.1601334295238;
        Mon, 28 Sep 2020 16:04:55 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id 137sm1009039ioc.20.2020.09.28.16.04.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2020 16:04:54 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 05/10] net: ipa: share field mask values for GSI interrupt type
Date:   Mon, 28 Sep 2020 18:04:41 -0500
Message-Id: <20200928230446.20561-6-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200928230446.20561-1-elder@linaro.org>
References: <20200928230446.20561-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The GSI interrupt type register and interrupt type mask register
have the same field bits at the same locations.  Use a common set of
field masks for both registers rather than essentially duplicating
them.  The only place the interrupt mask register uses any of these
is in gsi_irq_enable().

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c     |  4 ++--
 drivers/net/ipa/gsi_reg.h | 17 +++++------------
 2 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index cb75f7d540571..745717477cad3 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -254,8 +254,8 @@ static void gsi_irq_enable(struct gsi *gsi)
 
 	/* We don't use inter-EE channel or event interrupts */
 	val = GSI_CNTXT_TYPE_IRQ_MSK_ALL;
-	val &= ~MSK_INTER_EE_CH_CTRL_FMASK;
-	val &= ~MSK_INTER_EE_EV_CTRL_FMASK;
+	val &= ~INTER_EE_CH_CTRL_FMASK;
+	val &= ~INTER_EE_EV_CTRL_FMASK;
 	iowrite32(val, gsi->virt + GSI_CNTXT_TYPE_IRQ_MSK_OFFSET);
 
 	val = GENMASK(gsi->channel_count - 1, 0);
diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
index acc9e744c67d1..598db57a68dfb 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
@@ -258,6 +258,11 @@
 			GSI_EE_N_CNTXT_TYPE_IRQ_OFFSET(GSI_EE_AP)
 #define GSI_EE_N_CNTXT_TYPE_IRQ_OFFSET(ee) \
 			(0x0001f080 + 0x4000 * (ee))
+#define GSI_CNTXT_TYPE_IRQ_MSK_OFFSET \
+			GSI_EE_N_CNTXT_TYPE_IRQ_MSK_OFFSET(GSI_EE_AP)
+#define GSI_EE_N_CNTXT_TYPE_IRQ_MSK_OFFSET(ee) \
+			(0x0001f088 + 0x4000 * (ee))
+/* The masks below are used for the TYPE_IRQ and TYPE_IRQ_MASK registers */
 #define CH_CTRL_FMASK			GENMASK(0, 0)
 #define EV_CTRL_FMASK			GENMASK(1, 1)
 #define GLOB_EE_FMASK			GENMASK(2, 2)
@@ -265,18 +270,6 @@
 #define INTER_EE_CH_CTRL_FMASK		GENMASK(4, 4)
 #define INTER_EE_EV_CTRL_FMASK		GENMASK(5, 5)
 #define GENERAL_FMASK			GENMASK(6, 6)
-
-#define GSI_CNTXT_TYPE_IRQ_MSK_OFFSET \
-			GSI_EE_N_CNTXT_TYPE_IRQ_MSK_OFFSET(GSI_EE_AP)
-#define GSI_EE_N_CNTXT_TYPE_IRQ_MSK_OFFSET(ee) \
-			(0x0001f088 + 0x4000 * (ee))
-#define MSK_CH_CTRL_FMASK		GENMASK(0, 0)
-#define MSK_EV_CTRL_FMASK		GENMASK(1, 1)
-#define MSK_GLOB_EE_FMASK		GENMASK(2, 2)
-#define MSK_IEOB_FMASK			GENMASK(3, 3)
-#define MSK_INTER_EE_CH_CTRL_FMASK	GENMASK(4, 4)
-#define MSK_INTER_EE_EV_CTRL_FMASK	GENMASK(5, 5)
-#define MSK_GENERAL_FMASK		GENMASK(6, 6)
 #define GSI_CNTXT_TYPE_IRQ_MSK_ALL	GENMASK(6, 0)
 
 #define GSI_CNTXT_SRC_CH_IRQ_OFFSET \
-- 
2.20.1

