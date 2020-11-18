Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3012B83BA
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 19:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbgKRSUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 13:20:46 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:11957 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbgKRSUq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 13:20:46 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1605723645; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=V5QH/vQSVKr3HElpyNLc6yOQyNNozrNzG76HGXqu0AA=; b=h5kp+gnpFo1Qzb+fLkSWYKE0BZrts1AyMiLHkDvoW7R1NWMVi/Ct0lBuy+/NzUEywA5fXjiN
 GeMKHmXF/PUNeqoetsaHZZVDhs4cjGi+7/cWQ8Z9EOfrEEihuhk0PdRlj/HCcokiNtZCGtXL
 nrqY3S1o9UHcgG76hZVTyACd8FM=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 5fb565f922377520ee4df07b (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 18 Nov 2020 18:20:41
 GMT
Sender: bbhatt=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 86648C43463; Wed, 18 Nov 2020 18:20:41 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from malabar-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: bbhatt)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4A73BC433ED;
        Wed, 18 Nov 2020 18:20:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4A73BC433ED
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=bbhatt@codeaurora.org
From:   Bhaumik Bhatt <bbhatt@codeaurora.org>
To:     manivannan.sadhasivam@linaro.org
Cc:     kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        cjhuang@codeaurora.org, linux-arm-msm@vger.kernel.org,
        hemantk@codeaurora.org, linux-kernel@vger.kernel.org,
        ath11k@lists.infradead.org, clew@codeaurora.org,
        loic.poulain@linaro.org, netdev@vger.kernel.org,
        Bhaumik Bhatt <bbhatt@codeaurora.org>
Subject: [PATCH] net: qrtr: Unprepare MHI channels during remove
Date:   Wed, 18 Nov 2020 10:20:25 -0800
Message-Id: <1605723625-11206-1-git-send-email-bbhatt@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reset MHI device channels when driver remove is called due to
module unload or any crash scenario. This will make sure that
MHI channels no longer remain enabled for transfers since the
MHI stack does not take care of this anymore after the auto-start
channels feature was removed.

Signed-off-by: Bhaumik Bhatt <bbhatt@codeaurora.org>
---
 net/qrtr/mhi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/qrtr/mhi.c b/net/qrtr/mhi.c
index 7100f0b..2bf2b19 100644
--- a/net/qrtr/mhi.c
+++ b/net/qrtr/mhi.c
@@ -104,6 +104,7 @@ static void qcom_mhi_qrtr_remove(struct mhi_device *mhi_dev)
 	struct qrtr_mhi_dev *qdev = dev_get_drvdata(&mhi_dev->dev);
 
 	qrtr_endpoint_unregister(&qdev->ep);
+	mhi_unprepare_from_transfer(mhi_dev);
 	dev_set_drvdata(&mhi_dev->dev, NULL);
 }
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

