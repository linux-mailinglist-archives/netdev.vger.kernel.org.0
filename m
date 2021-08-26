Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1221B3F8AFB
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 17:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242963AbhHZP0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 11:26:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242958AbhHZP0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 11:26:01 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AB2EC0613CF
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 08:25:14 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id n5so5634098wro.12
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 08:25:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=U0QqVHJil6l5G4MYVgLkmExnYXL2IJoOnCLaNmNVQZ4=;
        b=YrLaZGkZomL/VSUIB7k1uAoRcfuyNKijVQMEVfIkyLwLKsJ7OoEgXUUwhmAdOsGocG
         mGmJx3NbIIXqCrQGRljw64436tbdrUm4rvu0CoFFen5jpgl7EpofhsO63PJ/wlPptUwN
         +mp8oWVWvtOD69snQtOHyVJVqWQk0v2M9GklYJXZ4Rhbkj97WCDNEPNhOHBNdbrfc1IQ
         LYOroLdqo+nwZlDg9axMJuehHk7g2604sMuvagEjPp23LyQwAmBjKQ4sisW36t7B1stI
         Qm4npQuOBOptI1rXsPhWCW0QLJzDgFnRSrXKsf32dqgzcz+BPFq5Bzr0acXB/TMjr/Ad
         LCIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=U0QqVHJil6l5G4MYVgLkmExnYXL2IJoOnCLaNmNVQZ4=;
        b=h3nJj51TccGXiD5XHxcjfoRoa2TGALf3brCcgTTV+7De26rB3ENbT+rICos17/ggty
         PGHxOwHcosmehIgISS6CC7r3j5dqh8wMwj91cJ5w05FfsRHxpFCAv8hkP3v7pieLXvmJ
         bZeFwJDRGl3cn0FQzvr3/97+hjvHc/Qr9UpEIrG2/U6jqA22ZVBNUIok0mtBXHmCf7K5
         FDdW2/TfzhXd6Aw6iDU2oq+b4stCRddDc17dTGE7kHOe/naWicinpiQ5opag/3ox+/UE
         6t/3Ax6Ji2uXuCC0Ez47a0NJy7dQFs/ZoXMX1mBi07MNX9OdM8DKynYCxK3z7j1TaO1K
         tzwQ==
X-Gm-Message-State: AOAM532DafREtSCWKRzD/AIf6bscZPfczq78UhnQD8SH+Byg5cwsKZfG
        7BlXiMw/Y4Je9cfBflrYmxIERw==
X-Google-Smtp-Source: ABdhPJxbcNVgTFbEH3zqK0G/4/3/NvKSyvGjZ8B8oCpY+KSha7d1SV7BGFVW/u/w2JGU8AjtzDZMFA==
X-Received: by 2002:adf:dc0b:: with SMTP id t11mr4550735wri.259.1629991512717;
        Thu, 26 Aug 2021 08:25:12 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:82c:5f0:edf4:979b:2385:1df8])
        by smtp.gmail.com with ESMTPSA id t11sm3263949wmi.23.2021.08.26.08.25.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Aug 2021 08:25:12 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, kvalo@codeaurora.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, ath11k@lists.infradead.org,
        regressions@lists.linux.dev, hemantk@codeaurora.org,
        nschichan@freebox.fr, manivannan.sadhasivam@linaro.org,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH] qrtr: mhi: Fix duplicate channel start
Date:   Thu, 26 Aug 2021 17:36:03 +0200
Message-Id: <1629992163-6252-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit ce78ffa3ef16 ("net: really fix the build...") handling a merge
conflict causes the mhi_prepare_for_transfer() function to be called
twice (with different flags), leading to QRTR probing issues.

Fixes: ce78ffa3ef16 ("net: really fix the build...")
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 net/qrtr/mhi.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/qrtr/mhi.c b/net/qrtr/mhi.c
index 1dc955c..deb8b03 100644
--- a/net/qrtr/mhi.c
+++ b/net/qrtr/mhi.c
@@ -83,11 +83,6 @@ static int qcom_mhi_qrtr_probe(struct mhi_device *mhi_dev,
 	struct qrtr_mhi_dev *qdev;
 	int rc;
 
-	/* start channels */
-	rc = mhi_prepare_for_transfer(mhi_dev, 0);
-	if (rc)
-		return rc;
-
 	qdev = devm_kzalloc(&mhi_dev->dev, sizeof(*qdev), GFP_KERNEL);
 	if (!qdev)
 		return -ENOMEM;
-- 
2.7.4

