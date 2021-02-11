Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7037F319509
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 22:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbhBKVUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 16:20:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbhBKVUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 16:20:13 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B10E6C061786
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 13:19:32 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id u8so7191715ior.13
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 13:19:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UgxRMzw4i04XPcEpk6Pwdj0vw8YRReeHuRbWMth6T24=;
        b=sXljozMVw9karaASbIfCqpA2FFP0rM8OpWYwHcthUJbS+1NEwgjN9urvuFBpZP8bhW
         3uDAOYhdaAhZ3LOgyMFdYdONdrB1eVdgUDqROhrqbd8KUhxU8lAkPAlQHwl0J/XPxMSL
         lTcDj9C0gevHOarZASkM+KeFDMXEYS6q90Ht0EIWSP7AweDRVcn4Ji22woYJt1Ymt8Pb
         KQ5IXPcO9AR4KwWcBNiwXwa2H+KxHHNZ1sl2kKcqSEg4uPFs6yu/Om3BOHVBM1GgQyEI
         Bzjr5FiLyuLXkttAUjND+vxryHlMeaWNu05EM7JKdwOk5iTynPGww1kaLVit0Ywy+kUP
         9I5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UgxRMzw4i04XPcEpk6Pwdj0vw8YRReeHuRbWMth6T24=;
        b=szSXMKemWJGIREysmK2cewGL+s6szfDcDJl26c4C22SyNcY7L3fyd56OUmT1uum9a3
         k7efnUjsP4YSr0F5zL3uAIA1WTBaaCR3IWvc44ZzNYazOZEcoYpEkTs7F40PBtIWH17a
         lutqdSDXfrGHURT9I9x0W5CGZDIQoPOLZFh/fC/aiPTStMTOdiba48TYHcCGlZj8eCdn
         D/nSUPpFckxRTwnBAcmDQ3wdXMUJxigdBtZVnmQ55onIVK1e1mFqOEvGI88NCxZlpaDd
         j2AvgFbyzhQKBR7pfP4ilmAEmU1J09KZj/0qNxaeIX8dAIMQ9RVNl+sP3y9qopOCn0dT
         rWBQ==
X-Gm-Message-State: AOAM530FYYwr8rMDBP5EEEl3gZM9DQ3fUXrHIlo5upImMwaJaSztnwQI
        ZELuSMan5PkpXVBqQ5+LISX4HA==
X-Google-Smtp-Source: ABdhPJwlatf8V5BVDaLiYWoyeojBYmU9RgwA4RWfNKKtW7/HhU042RIbTQrVck+2xJVmNfMfsZSh5Q==
X-Received: by 2002:a6b:f30c:: with SMTP id m12mr7143435ioh.136.1613078371935;
        Thu, 11 Feb 2021 13:19:31 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id j10sm3155718ilc.50.2021.02.11.13.19.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 13:19:31 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 1/5] net: ipa: use a separate pointer for adjusted GSI memory
Date:   Thu, 11 Feb 2021 15:19:23 -0600
Message-Id: <20210211211927.28061-2-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210211211927.28061-1-elder@linaro.org>
References: <20210211211927.28061-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch actually fixes a bug, though it doesn't affect the two
platforms supported currently.  The fix implements GSI memory
pointers a bit differently.

For IPA version 4.5 and above, the address space for almost all GSI
registers is adjusted downward by a fixed amount.  This is currently
handled by adjusting the I/O virtual address pointer after it has
been mapped.  The bug is that the pointer is not "de-adjusted" as it
should be when it's unmapped.

This patch fixes that error, but it does so by maintaining one "raw"
pointer for the mapped memory range.  This is assigned when the
memory is mapped and used to unmap the memory.  This pointer is also
used to access the two registers that do *not* sit in the "adjusted"
memory space.

Rather than adjusting *that* pointer, we maintain a separate pointer
that's an adjusted copy of the "raw" pointer, and that is used for
most GSI register accesses.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c     | 28 ++++++++++++----------------
 drivers/net/ipa/gsi.h     |  5 +++--
 drivers/net/ipa/gsi_reg.h | 21 +++++++++++++--------
 3 files changed, 28 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 4402136461888..9c977f80109a9 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 /* Copyright (c) 2015-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2018-2020 Linaro Ltd.
+ * Copyright (C) 2018-2021 Linaro Ltd.
  */
 
 #include <linux/types.h>
@@ -195,8 +195,6 @@ static void gsi_irq_type_disable(struct gsi *gsi, enum gsi_irq_type_id type_id)
 /* Turn off all GSI interrupts initially */
 static void gsi_irq_setup(struct gsi *gsi)
 {
-	u32 adjust;
-
 	/* Disable all interrupt types */
 	gsi_irq_type_update(gsi, 0);
 
@@ -206,10 +204,9 @@ static void gsi_irq_setup(struct gsi *gsi)
 	iowrite32(0, gsi->virt + GSI_CNTXT_GLOB_IRQ_EN_OFFSET);
 	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_IEOB_IRQ_MSK_OFFSET);
 
-	/* Reverse the offset adjustment for inter-EE register offsets */
-	adjust = gsi->version < IPA_VERSION_4_5 ? 0 : GSI_EE_REG_ADJUST;
-	iowrite32(0, gsi->virt + adjust + GSI_INTER_EE_SRC_CH_IRQ_OFFSET);
-	iowrite32(0, gsi->virt + adjust + GSI_INTER_EE_SRC_EV_CH_IRQ_OFFSET);
+	/* The inter-EE registers are in the non-adjusted address range */
+	iowrite32(0, gsi->virt_raw + GSI_INTER_EE_SRC_CH_IRQ_OFFSET);
+	iowrite32(0, gsi->virt_raw + GSI_INTER_EE_SRC_EV_CH_IRQ_OFFSET);
 
 	iowrite32(0, gsi->virt + GSI_CNTXT_GSI_IRQ_EN_OFFSET);
 }
@@ -2181,9 +2178,8 @@ int gsi_init(struct gsi *gsi, struct platform_device *pdev,
 	gsi->dev = dev;
 	gsi->version = version;
 
-	/* The GSI layer performs NAPI on all endpoints.  NAPI requires a
-	 * network device structure, but the GSI layer does not have one,
-	 * so we must create a dummy network device for this purpose.
+	/* GSI uses NAPI on all channels.  Create a dummy network device
+	 * for the channel NAPI contexts to be associated with.
 	 */
 	init_dummy_netdev(&gsi->dummy_dev);
 
@@ -2208,13 +2204,13 @@ int gsi_init(struct gsi *gsi, struct platform_device *pdev,
 		return -EINVAL;
 	}
 
-	gsi->virt = ioremap(res->start, size);
-	if (!gsi->virt) {
+	gsi->virt_raw = ioremap(res->start, size);
+	if (!gsi->virt_raw) {
 		dev_err(dev, "unable to remap \"gsi\" memory\n");
 		return -ENOMEM;
 	}
-	/* Adjust register range pointer downward for newer IPA versions */
-	gsi->virt -= adjust;
+	/* Most registers are accessed using an adjusted register range */
+	gsi->virt = gsi->virt_raw - adjust;
 
 	init_completion(&gsi->completion);
 
@@ -2233,7 +2229,7 @@ int gsi_init(struct gsi *gsi, struct platform_device *pdev,
 err_irq_exit:
 	gsi_irq_exit(gsi);
 err_iounmap:
-	iounmap(gsi->virt);
+	iounmap(gsi->virt_raw);
 
 	return ret;
 }
@@ -2244,7 +2240,7 @@ void gsi_exit(struct gsi *gsi)
 	mutex_destroy(&gsi->mutex);
 	gsi_channel_exit(gsi);
 	gsi_irq_exit(gsi);
-	iounmap(gsi->virt);
+	iounmap(gsi->virt_raw);
 }
 
 /* The maximum number of outstanding TREs on a channel.  This limits
diff --git a/drivers/net/ipa/gsi.h b/drivers/net/ipa/gsi.h
index d674db0ba4eb0..efc980f96109e 100644
--- a/drivers/net/ipa/gsi.h
+++ b/drivers/net/ipa/gsi.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
 /* Copyright (c) 2015-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2018-2020 Linaro Ltd.
+ * Copyright (C) 2018-2021 Linaro Ltd.
  */
 #ifndef _GSI_H_
 #define _GSI_H_
@@ -149,7 +149,8 @@ struct gsi {
 	struct device *dev;		/* Same as IPA device */
 	enum ipa_version version;
 	struct net_device dummy_dev;	/* needed for NAPI */
-	void __iomem *virt;
+	void __iomem *virt_raw;		/* I/O mapped address range */
+	void __iomem *virt;		/* Adjusted for most registers */
 	u32 irq;
 	u32 channel_count;
 	u32 evt_ring_count;
diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
index 299456e70f286..1622d8cf8dea4 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
 /* Copyright (c) 2015-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2018-2020 Linaro Ltd.
+ * Copyright (C) 2018-2021 Linaro Ltd.
  */
 #ifndef _GSI_REG_H_
 #define _GSI_REG_H_
@@ -38,17 +38,21 @@
  * (though the actual limit is hardware-dependent).
  */
 
-/* GSI EE registers as a group are shifted downward by a fixed
- * constant amount for IPA versions 4.5 and beyond.  This applies
- * to all GSI registers we use *except* the ones that disable
- * inter-EE interrupts for channels and event channels.
+/* GSI EE registers as a group are shifted downward by a fixed constant amount
+ * for IPA versions 4.5 and beyond.  This applies to all GSI registers we use
+ * *except* the ones that disable inter-EE interrupts for channels and event
+ * channels.
  *
- * We handle this by adjusting the pointer to the mapped GSI memory
- * region downward.  Then in the one place we use them (gsi_irq_setup())
- * we undo that adjustment for the inter-EE interrupt registers.
+ * The "raw" (not adjusted) GSI register range is mapped, and a pointer to
+ * the mapped range is held in gsi->virt_raw.  The inter-EE interrupt
+ * registers are accessed using that pointer.
+ *
+ * Most registers are accessed using gsi->virt, which is a copy of the "raw"
+ * pointer, adjusted downward by the fixed amount.
  */
 #define GSI_EE_REG_ADJUST			0x0000d000	/* IPA v4.5+ */
 
+/* The two inter-EE IRQ register offsets are relative to gsi->virt_raw */
 #define GSI_INTER_EE_SRC_CH_IRQ_OFFSET \
 			GSI_INTER_EE_N_SRC_CH_IRQ_OFFSET(GSI_EE_AP)
 #define GSI_INTER_EE_N_SRC_CH_IRQ_OFFSET(ee) \
@@ -59,6 +63,7 @@
 #define GSI_INTER_EE_N_SRC_EV_CH_IRQ_OFFSET(ee) \
 			(0x0000c01c + 0x1000 * (ee))
 
+/* All other register offsets are relative to gsi->virt */
 #define GSI_CH_C_CNTXT_0_OFFSET(ch) \
 		GSI_EE_N_CH_C_CNTXT_0_OFFSET((ch), GSI_EE_AP)
 #define GSI_EE_N_CH_C_CNTXT_0_OFFSET(ch, ee) \
-- 
2.20.1

