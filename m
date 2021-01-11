Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E08E72F1D4E
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 19:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390098AbhAKSAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 13:00:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389777AbhAKSAz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 13:00:55 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DACA7C06179F
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 10:00:08 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id d13so651567wrc.13
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 10:00:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Hzqb7q+hCD/lNO+yAqM3iVZkO0rtWj2v+FJjuf+pTrs=;
        b=hZIh7sgU6+OWulN4iAr/CSGMYEVlRNUWfrhwvHqyX+9uB5/UXXgHZCYIrq/R1wdrnL
         dx5Mw80y2Lmog+E7nU93dYmdS7Bt7aXshIvtzR1/CpFPqMAlq8s5NQFSLETZhnAe+Nw/
         AfM5Cz6ivbeUIXYotBm4aaVIWA1CAQmA547mi7wwRdFFA3FZECyttjIrzMUHapD6vMu6
         GVNaHXxShKIrTUTL5wJd36oiI+ehGbqafCSs03J0IK4GxGH+nMWfSBCVlqiQXnqg9SMO
         a6L7pequbilhvqR8JCRoSo34i3MhVBDiG/77knTbDjL2340l00lNSJQujGz6gsYtuvcc
         A9OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Hzqb7q+hCD/lNO+yAqM3iVZkO0rtWj2v+FJjuf+pTrs=;
        b=pVSucXlzNGTQ37+HbgoGnd+tbmSR94/6Lwpy1B9hHaB14OCG/Cv0o3KCfaF4D9DAhW
         oOvdMzPj67sMRUIwefSLQjqA3CnFvZLPTyoQnB6784OR62AS9g21ZJyyJLu8pwAAQ/Y/
         KT5U4y30/MDjJyD19a+giD957F4UmxEs9cTyZxcydWejfeKN+ZzkrsTKS/Cly/Y4Vdsy
         DGjKKlq/dfki7EcTvpYLh6OUHkt/WCwnHzZbDet+l0BDhuWCNedKwN4tef3jDz8PvVUV
         F77EC5IdL4OK3Zo8ggrJIJ95EAIWMEIKyjWONOXie5WcDYjS0nT/8IxYgPmZsktto3jk
         RTCQ==
X-Gm-Message-State: AOAM532RUFfS70CVgey/XB+bxGnR4vtZsxh2Qc3dNE4dzOWTfANt2wS2
        kCEgOR4+u0aktMFoGT3OkH+/Kg==
X-Google-Smtp-Source: ABdhPJzBnCL1cadHeT+qcud0r1WtPCyJdKFEtr18jPtmmL6y3tlUv8AiYQmcEaa1eTDWmEBYVevA7Q==
X-Received: by 2002:adf:c6c4:: with SMTP id c4mr324727wrh.348.1610388007564;
        Mon, 11 Jan 2021 10:00:07 -0800 (PST)
Received: from localhost.localdomain ([88.122.66.28])
        by smtp.gmail.com with ESMTPSA id s12sm77662wmh.29.2021.01.11.10.00.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Jan 2021 10:00:07 -0800 (PST)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        manivannan.sadhasivam@linaro.org,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next 2/3] net: mhi: Get RX queue size from MHI core
Date:   Mon, 11 Jan 2021 19:07:41 +0100
Message-Id: <1610388462-16322-2-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1610388462-16322-1-git-send-email-loic.poulain@linaro.org>
References: <1610388462-16322-1-git-send-email-loic.poulain@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The RX queue size can be determined at runtime by retrieving the
number of available transfer descriptors.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/net/mhi_net.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/mhi_net.c b/drivers/net/mhi_net.c
index b7f7f2e..3da820b 100644
--- a/drivers/net/mhi_net.c
+++ b/drivers/net/mhi_net.c
@@ -257,9 +257,6 @@ static int mhi_net_probe(struct mhi_device *mhi_dev,
 	mhi_netdev->mdev = mhi_dev;
 	SET_NETDEV_DEV(ndev, &mhi_dev->dev);
 
-	/* All MHI net channels have 128 ring elements (at least for now) */
-	mhi_netdev->rx_queue_sz = 128;
-
 	INIT_DELAYED_WORK(&mhi_netdev->rx_refill, mhi_net_rx_refill_work);
 	u64_stats_init(&mhi_netdev->stats.rx_syncp);
 	u64_stats_init(&mhi_netdev->stats.tx_syncp);
@@ -269,6 +266,9 @@ static int mhi_net_probe(struct mhi_device *mhi_dev,
 	if (err)
 		goto out_err;
 
+	/* Number of transfer descriptors determines size of the queue */
+	mhi_netdev->rx_queue_sz = mhi_get_free_desc_count(mhi_dev, DMA_FROM_DEVICE);
+
 	err = register_netdev(ndev);
 	if (err)
 		goto out_err;
-- 
2.7.4

