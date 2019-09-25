Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 585CABE6BF
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 22:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393442AbfIYU7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 16:59:07 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43981 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732933AbfIYU7G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 16:59:06 -0400
Received: by mail-wr1-f67.google.com with SMTP id q17so8488217wrx.10;
        Wed, 25 Sep 2019 13:59:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AlpX+GklYLeJDktTcAcS6q6xJ342MbTbjj7YR3smxYs=;
        b=F/96nDbSxxbCepPz0WxxIyMsWMat7MpXoh77zGRLAWbSCurXwFZySz6Mep+RrK/hHE
         0hPeWXBd6VPWDCTaIC4zOS4BjR2JF1oy4dDLYEBmzKy9Ct56trS0mcisE926ZzT+0LbC
         yVz2PwEjyfnK27kvjXRyGBlbV7CI/M8wPaGxTTAlfFC30hgVXHal91rgmewecKQ/xpHN
         sUco3KGrB2LOik5KniA8hVSqO1tdUIu1AREAuHdQQTuZ+OCVx8I4yFKC1yLJj+4YN16m
         N07lANEdx293c98xuqC9mufS7MQZo26aoR68caJYcAotWJn8vw2NSgi4X/L7t378I8qL
         7sEQ==
X-Gm-Message-State: APjAAAVdC5pixZT/Jm3aTR4E3V35u4Webxle6Q1BK4ROOxxS1HIAzSC5
        gXNNb3c03Fau73X8zDJKwthGzl5eXEI=
X-Google-Smtp-Source: APXvYqyT25Or17WdA/xJ8gkPS28rwPxqnrrVEnC9eJjoW+03sI68lCyn1aHbRFpd+OZd8bQJepDTvQ==
X-Received: by 2002:a5d:4f86:: with SMTP id d6mr211290wru.384.1569445144474;
        Wed, 25 Sep 2019 13:59:04 -0700 (PDT)
Received: from localhost.localdomain (99-48-196-88.sta.estpak.ee. [88.196.48.99])
        by smtp.googlemail.com with ESMTPSA id q124sm414076wma.5.2019.09.25.13.59.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2019 13:59:03 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Denis Efremov <efremov@linux.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] rtlwifi: Remove excessive check in _rtl_ps_inactive_ps()
Date:   Wed, 25 Sep 2019 23:58:58 +0300
Message-Id: <20190925205858.30216-1-efremov@linux.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no need to check "rtlhal->interface == INTF_PCI" twice in
_rtl_ps_inactive_ps(). The nested check is always true. Thus, the
expression can be simplified.

Signed-off-by: Denis Efremov <efremov@linux.com>
---
 drivers/net/wireless/realtek/rtlwifi/ps.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/ps.c b/drivers/net/wireless/realtek/rtlwifi/ps.c
index 70f04c2f5b17..6a8127539ea7 100644
--- a/drivers/net/wireless/realtek/rtlwifi/ps.c
+++ b/drivers/net/wireless/realtek/rtlwifi/ps.c
@@ -161,8 +161,7 @@ static void _rtl_ps_inactive_ps(struct ieee80211_hw *hw)
 	if (ppsc->inactive_pwrstate == ERFON &&
 	    rtlhal->interface == INTF_PCI) {
 		if ((ppsc->reg_rfps_level & RT_RF_OFF_LEVL_ASPM) &&
-		    RT_IN_PS_LEVEL(ppsc, RT_PS_LEVEL_ASPM) &&
-		    rtlhal->interface == INTF_PCI) {
+		    RT_IN_PS_LEVEL(ppsc, RT_PS_LEVEL_ASPM)) {
 			rtlpriv->intf_ops->disable_aspm(hw);
 			RT_CLEAR_PS_LEVEL(ppsc, RT_PS_LEVEL_ASPM);
 		}
-- 
2.21.0

