Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2753C43CF5B
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 19:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243141AbhJ0RFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 13:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238026AbhJ0RFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 13:05:46 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4CA4C061570
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 10:03:20 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id 3so3687093ilq.7
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 10:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=squareup.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JuGG34v4wgn5uK/AGdP3ngp2XG8YXyzgGRS2/CIbReg=;
        b=BoQ/Bq8kjvC5v1X/L1jXugkqidhMQBCw3IlN+1Ok0an9vh/ZZKqNSvklIvUrm5uBDS
         qqzyx0BxOzRjEBuuO+7mvs9j5B9MEHzdlLChsfDXFFfxsdZDQkWDJEnxYIHxfKnfe2/m
         e4bFn1uxT/m3Q25ul3x9TQpgtT9/6ZAGCHNYU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JuGG34v4wgn5uK/AGdP3ngp2XG8YXyzgGRS2/CIbReg=;
        b=vf1vIpPqK+oGmUaQkRA1p5XpJPnUk7kh8vyJuAIIo9Rpb2voWUtnSNbu5ryaS3SXQ3
         ZjV1LIcOhi7bzhQKczaQj6G4NI5mZL55LHcvtkJyg2X5DN1Pyf4RPlrH7fuYZKi60bl5
         U8Vz0ZknncGdignJb2BuGMjWjGPl2d5bwhkEbcsB0W1aQ+TPhH09Y1cdfHf1+Z9Vgnrq
         y4klYoCTP9GfkImI/+i9Abw3gK/HldqJieHb5IlvdHdyafXLmMhGyAsUUECIwVlmQcHf
         BjzTcVtYOukB/rloMKyMgqdm+YvLguwNYrdGxVre0HGpI/hkhIzvDU03UXR6eAB2sKF4
         kjEw==
X-Gm-Message-State: AOAM5330SbctfDLhLXkCbCkx5xU6l8O9NFiegsQN3HUlsrdERRz3wkTE
        yx4TUdZlU6PsiEvH4m+jeORO+g==
X-Google-Smtp-Source: ABdhPJww5sVqks1R0FGEmOv3cOGjGzn9Ge3YvmhO+w9HOYt9Q9UMCAk1vJ1sY5cG4Fxy47GCDjM3zg==
X-Received: by 2002:a05:6e02:1b81:: with SMTP id h1mr16184375ili.290.1635354200111;
        Wed, 27 Oct 2021 10:03:20 -0700 (PDT)
Received: from localhost ([2600:6c50:4d00:cd01::382])
        by smtp.gmail.com with ESMTPSA id g6sm223225ilq.68.2021.10.27.10.03.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 10:03:19 -0700 (PDT)
From:   Benjamin Li <benl@squareup.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Joseph Gates <jgates@squareup.com>,
        Bryan O'Donoghue <bryan.odonoghue@linaro.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        linux-arm-msm@vger.kernel.org, Benjamin Li <benl@squareup.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Eugene Krasnikov <k.eugene.e@gmail.com>,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] wcn36xx: add debug prints for sw_scan start/complete
Date:   Wed, 27 Oct 2021 10:03:03 -0700
Message-Id: <20211027170306.555535-2-benl@squareup.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211027170306.555535-1-benl@squareup.com>
References: <20211027170306.555535-1-benl@squareup.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add some MAC debug prints for more easily demarcating a software scan
when parsing logs.

Signed-off-by: Benjamin Li <benl@squareup.com>
---
 drivers/net/wireless/ath/wcn36xx/main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index 42153305f6d84..0b0f8ce729dd1 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -704,6 +704,8 @@ static void wcn36xx_sw_scan_start(struct ieee80211_hw *hw,
 	struct wcn36xx *wcn = hw->priv;
 	struct wcn36xx_vif *vif_priv = wcn36xx_vif_to_priv(vif);
 
+	wcn36xx_dbg(WCN36XX_DBG_MAC, "sw_scan_start");
+
 	wcn->sw_scan = true;
 	wcn->sw_scan_vif = vif;
 	wcn->sw_scan_channel = 0;
@@ -718,6 +720,8 @@ static void wcn36xx_sw_scan_complete(struct ieee80211_hw *hw,
 {
 	struct wcn36xx *wcn = hw->priv;
 
+	wcn36xx_dbg(WCN36XX_DBG_MAC, "sw_scan_complete");
+
 	/* ensure that any scan session is finished */
 	wcn36xx_smd_finish_scan(wcn, HAL_SYS_MODE_SCAN, wcn->sw_scan_vif);
 	wcn->sw_scan = false;
-- 
2.25.1

