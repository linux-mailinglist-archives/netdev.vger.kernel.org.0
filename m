Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 164FC3D99CF
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 01:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232888AbhG1X4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 19:56:38 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:12628 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232721AbhG1X4f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 19:56:35 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1627516593; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=rG5MyP/cD6Lu3423Hm61sSZ+MdCpGFjzTE2RP88KNMY=; b=TTkHcQwGXTmN04ktcwyKS1gxhRh4kZUOw+LTtTntUpqzAzi/ah+bS2civ+mfrr5geUntSzEr
 82we/HkeF4RDQp7vvktomoZ3fiTFqn1tvLxLQRK8/mybJubnPPehAnFCNK0fItmnKcuaTnX4
 7bPc4sPuyR9Vu9nRiB6IaWUpds0=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 6101eeabe81205dd0aa0be15 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 28 Jul 2021 23:56:27
 GMT
Sender: bbhatt=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 28546C433F1; Wed, 28 Jul 2021 23:56:27 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from malabar-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: bbhatt)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2F643C433D3;
        Wed, 28 Jul 2021 23:56:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2F643C433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=bbhatt@codeaurora.org
From:   Bhaumik Bhatt <bbhatt@codeaurora.org>
To:     manivannan.sadhasivam@linaro.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     bqiang@codeaurora.org, linux-arm-msm@vger.kernel.org,
        hemantk@codeaurora.org, clew@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Bhaumik Bhatt <bbhatt@codeaurora.org>
Subject: [RESEND PATCH] net: qrtr: mhi: synchronize qrtr and mhi preparation
Date:   Wed, 28 Jul 2021 16:56:19 -0700
Message-Id: <1627516579-35603-1-git-send-email-bbhatt@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A dl callback can be received anytime after mhi_prepare_for_transfer
has been called. There is a window where the callback may happen
before the probe initializes the qrtr_mhi_dev state. Move the
mhi_prepare_for_transfer call after the registering the endpoint.

Once moved, the reverse can happen where qrtr will try to send a packet
before the channels are prepared. Add a wait in the sending path to
ensure the channels are prepared before trying to do a ul transfer.

Fixes: a2e2cc0dbb11 ("net: qrtr: Start MHI channels during init")
Signed-off-by: Bhaumik Bhatt <bbhatt@codeaurora.org>
Reviewed-by: Hemant Kumar <hemantk@codeaurora.org>
---
Tested-on: X86_64 architecture

 net/qrtr/mhi.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/net/qrtr/mhi.c b/net/qrtr/mhi.c
index 29b4fa3..88f046b 100644
--- a/net/qrtr/mhi.c
+++ b/net/qrtr/mhi.c
@@ -15,6 +15,7 @@ struct qrtr_mhi_dev {
 	struct qrtr_endpoint ep;
 	struct mhi_device *mhi_dev;
 	struct device *dev;
+	struct completion ready;
 };
 
 /* From MHI to QRTR */
@@ -50,6 +51,10 @@ static int qcom_mhi_qrtr_send(struct qrtr_endpoint *ep, struct sk_buff *skb)
 	struct qrtr_mhi_dev *qdev = container_of(ep, struct qrtr_mhi_dev, ep);
 	int rc;
 
+	rc = wait_for_completion_interruptible(&qdev->ready);
+	if (rc)
+		goto free_skb;
+
 	if (skb->sk)
 		sock_hold(skb->sk);
 
@@ -78,17 +83,13 @@ static int qcom_mhi_qrtr_probe(struct mhi_device *mhi_dev,
 	struct qrtr_mhi_dev *qdev;
 	int rc;
 
-	/* start channels */
-	rc = mhi_prepare_for_transfer(mhi_dev, MHI_CH_INBOUND_ALLOC_BUFS);
-	if (rc)
-		return rc;
-
 	qdev = devm_kzalloc(&mhi_dev->dev, sizeof(*qdev), GFP_KERNEL);
 	if (!qdev)
 		return -ENOMEM;
 
 	qdev->mhi_dev = mhi_dev;
 	qdev->dev = &mhi_dev->dev;
+	init_completion(&qdev->ready);
 	qdev->ep.xmit = qcom_mhi_qrtr_send;
 
 	dev_set_drvdata(&mhi_dev->dev, qdev);
@@ -96,6 +97,15 @@ static int qcom_mhi_qrtr_probe(struct mhi_device *mhi_dev,
 	if (rc)
 		return rc;
 
+	/* start channels */
+	rc = mhi_prepare_for_transfer(mhi_dev, MHI_CH_INBOUND_ALLOC_BUFS);
+	if (rc) {
+		qrtr_endpoint_unregister(&qdev->ep);
+		dev_set_drvdata(&mhi_dev->dev, NULL);
+		return rc;
+	}
+
+	complete_all(&qdev->ready);
 	dev_dbg(qdev->dev, "Qualcomm MHI QRTR driver probed\n");
 
 	return 0;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

