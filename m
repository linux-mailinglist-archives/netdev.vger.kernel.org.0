Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBB0365545
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 11:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbhDTJ1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 05:27:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbhDTJ1y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 05:27:54 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 063F3C06174A
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 02:27:22 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id j5so35886628wrn.4
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 02:27:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=HciLJTdZ58FQCd986nDV7UgNcAgcgeXfksxSVxZUtmk=;
        b=OsGHGwobBSNU8O7z3Xv44+IPwHVlKnk4zWKsgdZNEvWnxB6AVMWJeElXNkZ3FoipX/
         yC+nw0v5d+J3jM3UXZ5GSoZOtPQa6/QJx7H29LOnf/gDE6IsVc1ZsDtxA+SoJkKyhdy5
         a0FhJlPbnilARcng/INXISL+B3GUXMJ48oBFy2nXIzFXa975k4+j0gEIZdKa3Iy8iCBF
         KFGm652BXYFTj9xstdCOPh7FQvYp9e3HzZLcSaFSZUS2vHy9edkHprQTAqDbL9wSnD2X
         O2/oQ4Y10e9wBtPmxPUs8dIeexoNPF6RHs342LiGFyQfzYcZaORX654vRnBDHR1Oodlk
         g9rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=HciLJTdZ58FQCd986nDV7UgNcAgcgeXfksxSVxZUtmk=;
        b=nULMvpO0WAFwNhPszG7Wvez1tmKN0/BmB18VjYXJFsQjJffJpB+fuee3cLchmDe3Os
         wgI1xQB1vua7654cOb6fVu2y2DJubYmpyMpdF5sBuTxFrc32up57NzXH5SF3DqB8Y0Xo
         RJlFJfq0T8kBuCNWKKMKwYYKE2MpxoX0izzeCgnlLTpWbaMeTo2x+cc5Jr1xlAfTR85t
         2GkA4qhQ3goO3nmoKK0y4hDb6G4LdlaXxDlqUb2svmWqjh8XB9Z+Qq8Z/yifJhtjKCI7
         rc7bDmOQTQB0hHFPczZBO48lWZhr8PwcBH4qLwi4kt+yGV6Bk0u4qUNXO79SGmWUy9DT
         bTBQ==
X-Gm-Message-State: AOAM530N3bz51K1VPqI28DnzrTiGd4gucG2u6oeFzQQTcbUBuCm5VMGo
        WL9FZdHb1SV1m1fvZaJB+4RX/w==
X-Google-Smtp-Source: ABdhPJy7Gb7YT6UuR5Gx7CnvsQFp8Bs79uL5HR4ydI0batdSAHOLses6BSz7k67TARzH7ZFS2r0Wpg==
X-Received: by 2002:adf:f80c:: with SMTP id s12mr19980976wrp.115.1618910840453;
        Tue, 20 Apr 2021 02:27:20 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:82c:5f0:ca41:4d56:7a9c:f18f])
        by smtp.gmail.com with ESMTPSA id m14sm26185073wrh.28.2021.04.20.02.27.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Apr 2021 02:27:19 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next] net: wwan: mhi_wwan_ctrl: Fix RX buffer starvation
Date:   Tue, 20 Apr 2021 11:36:22 +0200
Message-Id: <1618911382-14256-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mhi_wwan_rx_budget_dec function is supposed to return true if
RX buffer budget has been successfully decremented, allowing to queue
a new RX buffer for transfer. However the current implementation is
broken when RX budget is '1', in which case budget is decremented but
false is returned, preventing to requeue one buffer, and leading to
RX buffer starvation.

Fixes: fa588eba632d ("net: Add Qcom WWAN control driver")
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/net/wwan/mhi_wwan_ctrl.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wwan/mhi_wwan_ctrl.c b/drivers/net/wwan/mhi_wwan_ctrl.c
index 11475ad..1fc2376 100644
--- a/drivers/net/wwan/mhi_wwan_ctrl.c
+++ b/drivers/net/wwan/mhi_wwan_ctrl.c
@@ -56,11 +56,11 @@ static bool mhi_wwan_rx_budget_dec(struct mhi_wwan_dev *mhiwwan)
 
 	spin_lock(&mhiwwan->rx_lock);
 
-	if (mhiwwan->rx_budget)
+	if (mhiwwan->rx_budget) {
 		mhiwwan->rx_budget--;
-
-	if (mhiwwan->rx_budget && test_bit(MHI_WWAN_RX_REFILL, &mhiwwan->flags))
-		ret = true;
+		if (test_bit(MHI_WWAN_RX_REFILL, &mhiwwan->flags))
+			ret = true;
+	}
 
 	spin_unlock(&mhiwwan->rx_lock);
 
-- 
2.7.4

