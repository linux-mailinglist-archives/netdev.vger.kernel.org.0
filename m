Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBA82D58F9
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 12:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732994AbgLJLJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 06:09:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731319AbgLJLJa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 06:09:30 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C87C061793
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 03:08:50 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id g185so4862351wmf.3
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 03:08:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=VapKC0F7lyscSctbK97hEtuP5mXbtCFlx94A7dqei/c=;
        b=thzzgsdXnMcBCx4HmSmaa1ZwCbajIM4XmNOg9MwjyjmioAJYcIbAJW1meuJwoFDkM3
         xW41EHEvBr+b1eGkrtXEamJqtafB91ERnpZ2vfbSHzrAVOOpl6yZKjtGhOvbXU3VDvKI
         oD5aRb0r7DhYgGnGIQXSNcTDhXuWiv/X5QmfdOT1zTYRrXS1mVhGrdOsWBhJdvrKeQbX
         0r7GXEcT4keLDBliAJ8NRpjy/OdW9LOGfR1D77L3M9nbj5bf1Of8QFnd1nUSjSx6cE44
         lEtz6iDphnhvFrJb4vSCqRwexayYrCegDf44XZnWB01L1KQlZmxFG1VNBo0gmhtkDmxI
         T2JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=VapKC0F7lyscSctbK97hEtuP5mXbtCFlx94A7dqei/c=;
        b=MH3Sku9ZbQTaToWvymyC1Rqq/earG9Lb51wzgs6TTHXZN44h+aurp4zwGQDFbiKD8j
         t6y/wa/v5d/HyLfjeBLd6t4x4XPPLiq+6Bxz2geTOHHJFoyREvPgo8bSqMijwSS9hpVR
         TNXyhqWwwGn97a0jJYaFB8D6P1uivntRyEyVGKkROPvp6pl1r/Hrkw4pdfW1K1awLEet
         vv+uq1kfr1f3d2x5UH1ETad/putWznqHwYcN7+JMCdfyuajOelBPy+NrcG7CkQ6dTbAj
         qvpEhLrV14q4fCA08pxmie5rUi3xrCzp8D1GNS0WIfmyL1Qk74MmTpQEMojWn1JHGK9G
         Lkiw==
X-Gm-Message-State: AOAM533l6w84yhoDP8SIx42UNuB19Sf5dKacYRz00xsLj6YhUuCTJLU5
        D7bg+58Sg8ZOM5NPs/r7pp0IFA==
X-Google-Smtp-Source: ABdhPJyOWS+5uAXDH8mhqvSCmbXlXNt+9gVCBrc6da4fN5Lm4DZ9VLwEellB0qolj6aDFhFCOMoyPQ==
X-Received: by 2002:a1c:6a13:: with SMTP id f19mr7405352wmc.10.1607598528905;
        Thu, 10 Dec 2020 03:08:48 -0800 (PST)
Received: from localhost.localdomain ([2a01:e0a:490:8730:4468:1cc2:be0c:233f])
        by smtp.gmail.com with ESMTPSA id n123sm8961809wmn.7.2020.12.10.03.08.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Dec 2020 03:08:48 -0800 (PST)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     manivannan.sadhasivam@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, jhugo@codeaurora.org,
        Hemant Kumar <hemantk@codeaurora.org>
Subject: [PATCH v2 1/3] bus: mhi: core: Add helper API to return number of free TREs
Date:   Thu, 10 Dec 2020 12:15:49 +0100
Message-Id: <1607598951-2340-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hemant Kumar <hemantk@codeaurora.org>

Introduce mhi_get_free_desc_count() API to return number
of TREs available to queue buffer. MHI clients can use this
API to know before hand if ring is full without calling queue
API.

Signed-off-by: Hemant Kumar <hemantk@codeaurora.org>
Reviewed-by: Jeffrey Hugo <jhugo@codeaurora.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 v2: no change

 drivers/bus/mhi/core/main.c | 12 ++++++++++++
 include/linux/mhi.h         |  9 +++++++++
 2 files changed, 21 insertions(+)

diff --git a/drivers/bus/mhi/core/main.c b/drivers/bus/mhi/core/main.c
index 54d9c80..a24ba4f 100644
--- a/drivers/bus/mhi/core/main.c
+++ b/drivers/bus/mhi/core/main.c
@@ -303,6 +303,18 @@ int mhi_destroy_device(struct device *dev, void *data)
 	return 0;
 }
 
+int mhi_get_free_desc_count(struct mhi_device *mhi_dev,
+				enum dma_data_direction dir)
+{
+	struct mhi_controller *mhi_cntrl = mhi_dev->mhi_cntrl;
+	struct mhi_chan *mhi_chan = (dir == DMA_TO_DEVICE) ?
+		mhi_dev->ul_chan : mhi_dev->dl_chan;
+	struct mhi_ring *tre_ring = &mhi_chan->tre_ring;
+
+	return get_nr_avail_ring_elements(mhi_cntrl, tre_ring);
+}
+EXPORT_SYMBOL_GPL(mhi_get_free_desc_count);
+
 void mhi_notify(struct mhi_device *mhi_dev, enum mhi_callback cb_reason)
 {
 	struct mhi_driver *mhi_drv;
diff --git a/include/linux/mhi.h b/include/linux/mhi.h
index 09f786e..25c69a0 100644
--- a/include/linux/mhi.h
+++ b/include/linux/mhi.h
@@ -616,6 +616,15 @@ void mhi_set_mhi_state(struct mhi_controller *mhi_cntrl,
 void mhi_notify(struct mhi_device *mhi_dev, enum mhi_callback cb_reason);
 
 /**
+ * mhi_get_free_desc_count - Get transfer ring length
+ * Get # of TD available to queue buffers
+ * @mhi_dev: Device associated with the channels
+ * @dir: Direction of the channel
+ */
+int mhi_get_free_desc_count(struct mhi_device *mhi_dev,
+				enum dma_data_direction dir);
+
+/**
  * mhi_prepare_for_power_up - Do pre-initialization before power up.
  *                            This is optional, call this before power up if
  *                            the controller does not want bus framework to
-- 
2.7.4

