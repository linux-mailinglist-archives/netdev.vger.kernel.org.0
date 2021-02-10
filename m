Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CEAD317371
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 23:36:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233662AbhBJWfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 17:35:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233150AbhBJWe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 17:34:28 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE042C06178A
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 14:33:24 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id q7so3716728iob.0
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 14:33:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hi0HEin9Uxftu2MJREiOctfWyx+cFi4e6PLNxuIWIFU=;
        b=DpGK9y7OVTWdy7erqx2SCyDNX3Enz4Agc4HMH3DV5iS1YYPYVe8t0LBkoy4I17LbC2
         qFv+UIm9IjgXJHyedHoioOjBpPvYHTIIRTix06EfszlEB9sZDCqA7VXLll/y8vw758p2
         VhlVZtZH765pu7IofIWcxri2ZXAgDCIU6o4dpoOs42KNC7rUXgAfY7bpVS7EPll7Dt0l
         breofdDgMKYw/di2idTJmVaOqx6LsZDatfFKs53nLECI3F3ZzjkhOaBK8tiDspiQCCHf
         EOfQi2cUHHIyaOdFSO+UnsvULde8SuAVK9KYXgh0PAe3qfg4oB30x/5xyBxNe2l4UpkI
         edCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hi0HEin9Uxftu2MJREiOctfWyx+cFi4e6PLNxuIWIFU=;
        b=m4DOrmDrIz95ud5cBKAHMjdXT7+yvJwOUSU9bNK0rf63crmnP6vvsqse/ZEP6rSD7T
         N+sThXJeQH+Ld/LRuwiWkJFtS3pBUkxaHkSXeAt7UGIAMzuVanVGYuslONL3unTFeVic
         1Uu5x6Z8NGfsCCNX06UwsVX8R+CzKEzVo6tNF/fBFT2NivsP3To8+amHe0TeLkZU7VBV
         IUg4PNpoPvj1iT07ZwFPq8MGzgCBh3SIs4WhJ9mEU9bI9XlNtCKTT63VY7MPVHBJPPKu
         cgPVausTd0ZDO/UqbFzMWaxXlh7BA3w+mJ8wDCFP1LHmM56dNJJi0T+naxSpJX8gJehS
         BZpw==
X-Gm-Message-State: AOAM533dKewgjTvwi1fsy40+e7A1Yx5Z66kcSUcicCw3lTcPHcK93ZGi
        isQxm9/4ic1fU9YYbejeR/aCHA==
X-Google-Smtp-Source: ABdhPJwj6xQrNZFmmtdABqyIFdRBU84BPVPJ4y7Ixk3DnbAfOU1A+icoSSbj2DqI4otSoQmkNKFS8w==
X-Received: by 2002:a6b:b808:: with SMTP id i8mr2854608iof.56.1612996404431;
        Wed, 10 Feb 2021 14:33:24 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id e23sm1484525ioc.34.2021.02.10.14.33.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 14:33:24 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/5] net: ipa: use a separate pointer for adjusted GSI memory
Date:   Wed, 10 Feb 2021 16:33:16 -0600
Message-Id: <20210210223320.11269-2-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210210223320.11269-1-elder@linaro.org>
References: <20210210223320.11269-1-elder@linaro.org>
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
 drivers/net/ipa/gsi.c     | 26 +++++++++++---------------
 drivers/net/ipa/gsi.h     |  3 ++-
 drivers/net/ipa/gsi_reg.h | 19 ++++++++++++-------
 3 files changed, 25 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 511c94f66036c..d33686da15420 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
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
@@ -2180,9 +2177,8 @@ int gsi_init(struct gsi *gsi, struct platform_device *pdev,
 	gsi->dev = dev;
 	gsi->version = version;
 
-	/* The GSI layer performs NAPI on all endpoints.  NAPI requires a
-	 * network device structure, but the GSI layer does not have one,
-	 * so we must create a dummy network device for this purpose.
+	/* GSI uses NAPI on all channels.  Create a dummy network device
+	 * for the channel NAPI contexts to be associated with.
 	 */
 	init_dummy_netdev(&gsi->dummy_dev);
 
@@ -2207,13 +2203,13 @@ int gsi_init(struct gsi *gsi, struct platform_device *pdev,
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
 
@@ -2232,7 +2228,7 @@ int gsi_init(struct gsi *gsi, struct platform_device *pdev,
 err_irq_exit:
 	gsi_irq_exit(gsi);
 err_iounmap:
-	iounmap(gsi->virt);
+	iounmap(gsi->virt_raw);
 
 	return ret;
 }
@@ -2243,7 +2239,7 @@ void gsi_exit(struct gsi *gsi)
 	mutex_destroy(&gsi->mutex);
 	gsi_channel_exit(gsi);
 	gsi_irq_exit(gsi);
-	iounmap(gsi->virt);
+	iounmap(gsi->virt_raw);
 }
 
 /* The maximum number of outstanding TREs on a channel.  This limits
diff --git a/drivers/net/ipa/gsi.h b/drivers/net/ipa/gsi.h
index d674db0ba4eb0..088860d5c3104 100644
--- a/drivers/net/ipa/gsi.h
+++ b/drivers/net/ipa/gsi.h
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
index 299456e70f286..00100afa8ec35 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
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

