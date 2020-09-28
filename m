Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A789727B7A9
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 01:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727219AbgI1XO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 19:14:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727074AbgI1XNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 19:13:43 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCD64C05BD16
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 16:04:56 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id z13so2900163iom.8
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 16:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MAvpS98+eTt3PNnsDgqV3HXwzJnvHmKZpA/Fx0C9NeU=;
        b=nmnjKn7hIGhxVVl52AdTSSW+PI97BHwwxFLL2ocGbe0HTNrmxzsMxpY6dAOv4fQkAq
         UcHLKgGsyPuvbeGxZ8gvSGJZxI7Fo8/98dgj2SOxBfsy4NBFu/gZkj3zjFzBBA7gyMD5
         2QDzwVeVSk5s8N8qa4WmzcVQGox735h5qUG9N7CzO3RqAjJzH0IXARGi6ralYiEuCeCI
         mlAbiPnPgMi9+ACgNyKv64bKfRy9FKtu4bllUGmJFm+2ddM/VRfs0DwhyVkBQzn48Kzd
         G+oTNaim6lnx3YXOX37WqkWseCH51JY9N2LC4iWk9xTIj7/JHgmVg0cTtYHj+0luW2lw
         OR8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MAvpS98+eTt3PNnsDgqV3HXwzJnvHmKZpA/Fx0C9NeU=;
        b=iLBT03EsVF2OLkHLB3MQmj6kNC7CQjd2zWKX7+3EqvIDK1i1UNriANeYf0570LJ8wA
         Q7z7b0NrOBTjfVMOw2GEYDrHW13m+r6dPHydyyjClH2qcejgIN7q9ItBp4gajhDozW1t
         2dLFnz55fYvBlbgXXMhqcJlY8cKh0QVXMU2/ar258Y+s3pRK4xfuxu9vdFLHNPV8H366
         B5+TaYjuvHpvIzR2FlJ8Qt+08Fy3saxF+1HVIBbveEKct7QXhiJdq9uvFyyaqbdt/Cn4
         ps37rTbFilYZSgESuRaelmKjT9VQVpjc1QL9iU6LdF5dmgUXCWTq4iKbH079RPPuuTOK
         dJ6A==
X-Gm-Message-State: AOAM530IOt7ODPpJwKDq72z0TVtLlLUMdbwJZ5WE35/DR9jsTkwhT+e7
        BbD3Vpy/34z+VImHcmqP0KiLQw==
X-Google-Smtp-Source: ABdhPJyrhDF3QGHpPaZFLORNgTVk5P72ii6EsQAOByIv1qYBXFA3o5zQyW1/oZutWri77YsA2DMMLQ==
X-Received: by 2002:a05:6638:22ba:: with SMTP id z26mr735160jas.55.1601334296154;
        Mon, 28 Sep 2020 16:04:56 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id 137sm1009039ioc.20.2020.09.28.16.04.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2020 16:04:55 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 06/10] net: ipa: share field mask values for GSI global interrupt
Date:   Mon, 28 Sep 2020 18:04:42 -0500
Message-Id: <20200928230446.20561-7-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200928230446.20561-1-elder@linaro.org>
References: <20200928230446.20561-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The GSI global interrupt is managed by three registers: enable;
status; and clear.  The three registers have same set of field bits
at the same locations.  Use a common set of field masks for all
three registers to avoid duplication.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c     |  4 ++--
 drivers/net/ipa/gsi_reg.h | 21 ++++++---------------
 2 files changed, 8 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 745717477cad3..203d079c481c4 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1074,8 +1074,8 @@ static void gsi_isr_glob_ee(struct gsi *gsi)
 
 	val &= ~ERROR_INT_FMASK;
 
-	if (val & EN_GP_INT1_FMASK) {
-		val ^= EN_GP_INT1_FMASK;
+	if (val & GP_INT1_FMASK) {
+		val ^= GP_INT1_FMASK;
 		gsi_isr_gp_int1(gsi);
 	}
 
diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
index 598db57a68dfb..b789e0f866fa0 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
@@ -321,29 +321,20 @@
 			GSI_EE_N_CNTXT_GLOB_IRQ_STTS_OFFSET(GSI_EE_AP)
 #define GSI_EE_N_CNTXT_GLOB_IRQ_STTS_OFFSET(ee) \
 			(0x0001f100 + 0x4000 * (ee))
-#define ERROR_INT_FMASK			GENMASK(0, 0)
-#define GP_INT1_FMASK			GENMASK(1, 1)
-#define GP_INT2_FMASK			GENMASK(2, 2)
-#define GP_INT3_FMASK			GENMASK(3, 3)
-
 #define GSI_CNTXT_GLOB_IRQ_EN_OFFSET \
 			GSI_EE_N_CNTXT_GLOB_IRQ_EN_OFFSET(GSI_EE_AP)
 #define GSI_EE_N_CNTXT_GLOB_IRQ_EN_OFFSET(ee) \
 			(0x0001f108 + 0x4000 * (ee))
-#define EN_ERROR_INT_FMASK		GENMASK(0, 0)
-#define EN_GP_INT1_FMASK		GENMASK(1, 1)
-#define EN_GP_INT2_FMASK		GENMASK(2, 2)
-#define EN_GP_INT3_FMASK		GENMASK(3, 3)
-#define GSI_CNTXT_GLOB_IRQ_ALL		GENMASK(3, 0)
-
 #define GSI_CNTXT_GLOB_IRQ_CLR_OFFSET \
 			GSI_EE_N_CNTXT_GLOB_IRQ_CLR_OFFSET(GSI_EE_AP)
 #define GSI_EE_N_CNTXT_GLOB_IRQ_CLR_OFFSET(ee) \
 			(0x0001f110 + 0x4000 * (ee))
-#define CLR_ERROR_INT_FMASK		GENMASK(0, 0)
-#define CLR_GP_INT1_FMASK		GENMASK(1, 1)
-#define CLR_GP_INT2_FMASK		GENMASK(2, 2)
-#define CLR_GP_INT3_FMASK		GENMASK(3, 3)
+/* The masks below are used for the general IRQ STTS, EN, and CLR registers */
+#define ERROR_INT_FMASK			GENMASK(0, 0)
+#define GP_INT1_FMASK			GENMASK(1, 1)
+#define GP_INT2_FMASK			GENMASK(2, 2)
+#define GP_INT3_FMASK			GENMASK(3, 3)
+#define GSI_CNTXT_GLOB_IRQ_ALL		GENMASK(3, 0)
 
 #define GSI_CNTXT_GSI_IRQ_STTS_OFFSET \
 			GSI_EE_N_CNTXT_GSI_IRQ_STTS_OFFSET(GSI_EE_AP)
-- 
2.20.1

