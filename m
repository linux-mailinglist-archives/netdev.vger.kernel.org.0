Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9924E2EBEC5
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 14:37:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbhAFNhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 08:37:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726500AbhAFNhD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 08:37:03 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E556C06135C
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 05:36:11 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id n16so3155232wmc.0
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 05:36:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=OK96pus8qdQrBS5M0oL3AvAxP5CiljhlnQLMNRvrKmw=;
        b=ME2v7jsF54uVq1epB2enC1dNOwAROFfIoEXp3fHa9h9z87VUluLEh9TLIZEJD7zkCz
         r1zyeo3teckysoQ5Gz4vWE5Fmw17nZQYJC1Rw0kijr0D25IWtL1+JqBWNocbkn8o+I0z
         XmXHN0HUVASCJ7qXgEwDQh9Hmb5ZO8HXpGzobB8ly0FL1hN3y+mIzmTrcx8lQa9AgJ0D
         EjsnYSxe5EBnjYX7ltM4pA42B0VP6Lnp7H6b/CbyF+9wAqx/YkRkF0tq28zFze5VLS0G
         I69DJWXu/SX2Mv4hvnxPXFDh8hMdiMVFXTiFOGD4vXXQC/K23Tw0Ty3+EyQeNNqZVj7J
         JE1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=OK96pus8qdQrBS5M0oL3AvAxP5CiljhlnQLMNRvrKmw=;
        b=P4JAL5bylEl2/SZ0xNqjuPB6cOtyAJMmA4flgHybuxthEAnS1CJHE9xmAayOaFTaBu
         2LfgR4o8KMyL9L0C/q1xZZ5PNjwXBcwQPF+51lhNmQPMiZZpf8adgKOELGRCgC2nhOkY
         62An5buucYxupoMxUaHB/K5Br9qwatDjb4WuZuu3AFk/zhoGJwk2yw4RXb6dt/si5yTx
         hL5IFBa5RF3TdIBBV9WZRbV9vMWDkbKit2E9d7npXjjXLcjIwogRmyOwEH3+D7wd3iOb
         x7TttosUbbKITBrKDfF3Wh9zrpC//l9+BYnitfNRZBDSbtE9AlOGnPwdVlOCvE7+k3ac
         AibA==
X-Gm-Message-State: AOAM5301d+12fDlOD88uwAtvtuONT6oq/I/RDLDonL0QErQjzHFO+Zh2
        qqvFTQ5IXdkk+sL18ExWtQyOgw==
X-Google-Smtp-Source: ABdhPJySeYJ9qFzqYlDz9hQ/oh6EiKZDfOpBYHZQ8TNC37LfHRCxPSg1KyOfaLHpEpPJbtJQYaIVCw==
X-Received: by 2002:a1c:1c1:: with SMTP id 184mr3724909wmb.112.1609940170132;
        Wed, 06 Jan 2021 05:36:10 -0800 (PST)
Received: from localhost.localdomain ([2a01:e0a:490:8730:32c9:a713:9d05:bd74])
        by smtp.gmail.com with ESMTPSA id r82sm3183618wma.18.2021.01.06.05.36.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Jan 2021 05:36:09 -0800 (PST)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     manivannan.sadhasivam@linaro.org, hemantk@codeaurora.org
Cc:     linux-arm-msm@vger.kernel.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH] bus: mhi: Add inbound buffers allocation flag
Date:   Wed,  6 Jan 2021 14:43:43 +0100
Message-Id: <1609940623-8864-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the MHI controller driver defines which channels should
have their inbound buffers allocated and queued. But ideally, this is
something that should be decided by the MHI device driver instead,
which actually deals with that buffers.

Add a flag parameter to mhi_prepare_for_transfer allowing to specify
if buffers have to be allocated and queued by the MHI stack.

Keep auto_queue flag for now, but should be removed at some point.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/bus/mhi/core/internal.h |  2 +-
 drivers/bus/mhi/core/main.c     | 11 ++++++++---
 drivers/net/mhi_net.c           |  2 +-
 include/linux/mhi.h             | 12 +++++++++++-
 net/qrtr/mhi.c                  |  2 +-
 5 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/bus/mhi/core/internal.h b/drivers/bus/mhi/core/internal.h
index 6f80ec3..7512602 100644
--- a/drivers/bus/mhi/core/internal.h
+++ b/drivers/bus/mhi/core/internal.h
@@ -664,7 +664,7 @@ void mhi_rddm_prepare(struct mhi_controller *mhi_cntrl,
 		      struct image_info *img_info);
 void mhi_fw_load_handler(struct mhi_controller *mhi_cntrl);
 int mhi_prepare_channel(struct mhi_controller *mhi_cntrl,
-			struct mhi_chan *mhi_chan);
+			struct mhi_chan *mhi_chan, enum mhi_chan_flags flags);
 int mhi_init_chan_ctxt(struct mhi_controller *mhi_cntrl,
 		       struct mhi_chan *mhi_chan);
 void mhi_deinit_chan_ctxt(struct mhi_controller *mhi_cntrl,
diff --git a/drivers/bus/mhi/core/main.c b/drivers/bus/mhi/core/main.c
index 9b42540..6b6ad6b 100644
--- a/drivers/bus/mhi/core/main.c
+++ b/drivers/bus/mhi/core/main.c
@@ -1292,7 +1292,8 @@ static void __mhi_unprepare_channel(struct mhi_controller *mhi_cntrl,
 }
 
 int mhi_prepare_channel(struct mhi_controller *mhi_cntrl,
-			struct mhi_chan *mhi_chan)
+			struct mhi_chan *mhi_chan,
+			enum mhi_chan_flags flags)
 {
 	int ret = 0;
 	struct device *dev = &mhi_cntrl->mhi_dev->dev;
@@ -1352,6 +1353,9 @@ int mhi_prepare_channel(struct mhi_controller *mhi_cntrl,
 	mhi_chan->ch_state = MHI_CH_STATE_ENABLED;
 	write_unlock_irq(&mhi_chan->lock);
 
+	if (mhi_chan->dir == DMA_FROM_DEVICE)
+		mhi_chan->pre_alloc = !!(flags & MHI_CH_INBOUND_ALLOC_BUFS);
+
 	/* Pre-allocate buffer for xfer ring */
 	if (mhi_chan->pre_alloc) {
 		int nr_el = get_nr_avail_ring_elements(mhi_cntrl,
@@ -1498,7 +1502,8 @@ void mhi_reset_chan(struct mhi_controller *mhi_cntrl, struct mhi_chan *mhi_chan)
 }
 
 /* Move channel to start state */
-int mhi_prepare_for_transfer(struct mhi_device *mhi_dev)
+int mhi_prepare_for_transfer(struct mhi_device *mhi_dev,
+			     enum mhi_chan_flags flags)
 {
 	int ret, dir;
 	struct mhi_controller *mhi_cntrl = mhi_dev->mhi_cntrl;
@@ -1509,7 +1514,7 @@ int mhi_prepare_for_transfer(struct mhi_device *mhi_dev)
 		if (!mhi_chan)
 			continue;
 
-		ret = mhi_prepare_channel(mhi_cntrl, mhi_chan);
+		ret = mhi_prepare_channel(mhi_cntrl, mhi_chan, flags);
 		if (ret)
 			goto error_open_chan;
 	}
diff --git a/drivers/net/mhi_net.c b/drivers/net/mhi_net.c
index fa41d8c..b7f7f2e 100644
--- a/drivers/net/mhi_net.c
+++ b/drivers/net/mhi_net.c
@@ -265,7 +265,7 @@ static int mhi_net_probe(struct mhi_device *mhi_dev,
 	u64_stats_init(&mhi_netdev->stats.tx_syncp);
 
 	/* Start MHI channels */
-	err = mhi_prepare_for_transfer(mhi_dev);
+	err = mhi_prepare_for_transfer(mhi_dev, 0);
 	if (err)
 		goto out_err;
 
diff --git a/include/linux/mhi.h b/include/linux/mhi.h
index 209b335..6723339 100644
--- a/include/linux/mhi.h
+++ b/include/linux/mhi.h
@@ -60,6 +60,14 @@ enum mhi_flags {
 };
 
 /**
+ * enum mhi_chan_flags - MHI channel flags
+ * @MHI_CH_INBOUND_ALLOC_BUFS: Automatically allocate and queue inbound buffers
+ */
+enum mhi_chan_flags {
+	MHI_CH_INBOUND_ALLOC_BUFS = BIT(0),
+};
+
+/**
  * enum mhi_device_type - Device types
  * @MHI_DEVICE_XFER: Handles data transfer
  * @MHI_DEVICE_CONTROLLER: Control device
@@ -705,8 +713,10 @@ void mhi_device_put(struct mhi_device *mhi_dev);
 /**
  * mhi_prepare_for_transfer - Setup channel for data transfer
  * @mhi_dev: Device associated with the channels
+ * @flags: MHI channel flags
  */
-int mhi_prepare_for_transfer(struct mhi_device *mhi_dev);
+int mhi_prepare_for_transfer(struct mhi_device *mhi_dev,
+			     enum mhi_chan_flags flags);
 
 /**
  * mhi_unprepare_from_transfer - Unprepare the channels
diff --git a/net/qrtr/mhi.c b/net/qrtr/mhi.c
index 2bf2b19..47afded 100644
--- a/net/qrtr/mhi.c
+++ b/net/qrtr/mhi.c
@@ -77,7 +77,7 @@ static int qcom_mhi_qrtr_probe(struct mhi_device *mhi_dev,
 	int rc;
 
 	/* start channels */
-	rc = mhi_prepare_for_transfer(mhi_dev);
+	rc = mhi_prepare_for_transfer(mhi_dev, MHI_CH_INBOUND_ALLOC_BUFS);
 	if (rc)
 		return rc;
 
-- 
2.7.4

