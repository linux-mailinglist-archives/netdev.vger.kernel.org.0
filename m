Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C01152C6EAB
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 04:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730816AbgK1Dk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 22:40:26 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:52439 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731841AbgK1Dhm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 22:37:42 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606534646; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=Omie6gbCO815h6shKPjIa8pk/OZaWlUZMSm4VMwLvVM=; b=pjxzw171yKn2ygXqFut43hy120iQ7bo1oIIJQmPZr4XiTTEvGo9OLgiEzVzMRiO6Xqnh3pxA
 EEo23lWGNLiuCnFVUSgNG9d886AdBFLoMoHypPXoNwsDDHvL5iBDrFuhk5RCX5oE0kqz+mAc
 ix2vEk9DpDO7v0otDK0j4qWyvGo=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n09.prod.us-east-1.postgun.com with SMTP id
 5fc1c357ba50d14f88303d1e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 28 Nov 2020 03:26:15
 GMT
Sender: hemantk=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 9CD36C43465; Sat, 28 Nov 2020 03:26:14 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from codeaurora.org (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: hemantk)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A97DAC433C6;
        Sat, 28 Nov 2020 03:26:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A97DAC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=hemantk@codeaurora.org
From:   Hemant Kumar <hemantk@codeaurora.org>
To:     manivannan.sadhasivam@linaro.org, gregkh@linuxfoundation.org
Cc:     linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jhugo@codeaurora.org, bbhatt@codeaurora.org,
        loic.poulain@linaro.org, netdev@vger.kernel.org,
        Hemant Kumar <hemantk@codeaurora.org>
Subject: [PATCH v13 1/4] bus: mhi: core: Add helper API to return number of free TREs
Date:   Fri, 27 Nov 2020 19:26:03 -0800
Message-Id: <1606533966-22821-2-git-send-email-hemantk@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1606533966-22821-1-git-send-email-hemantk@codeaurora.org>
References: <1606533966-22821-1-git-send-email-hemantk@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce mhi_get_free_desc_count() API to return number
of TREs available to queue buffer. MHI clients can use this
API to know before hand if ring is full without calling queue
API.

Signed-off-by: Hemant Kumar <hemantk@codeaurora.org>
Reviewed-by: Jeffrey Hugo <jhugo@codeaurora.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/bus/mhi/core/main.c | 12 ++++++++++++
 include/linux/mhi.h         |  9 +++++++++
 2 files changed, 21 insertions(+)

diff --git a/drivers/bus/mhi/core/main.c b/drivers/bus/mhi/core/main.c
index 4eb93d8..defd579a 100644
--- a/drivers/bus/mhi/core/main.c
+++ b/drivers/bus/mhi/core/main.c
@@ -260,6 +260,18 @@ int mhi_destroy_device(struct device *dev, void *data)
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
index d31efcf..b3bc966 100644
--- a/include/linux/mhi.h
+++ b/include/linux/mhi.h
@@ -597,6 +597,15 @@ void mhi_set_mhi_state(struct mhi_controller *mhi_cntrl,
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
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

