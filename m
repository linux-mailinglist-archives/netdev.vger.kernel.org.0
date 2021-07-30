Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 720EE3DB768
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 12:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238562AbhG3Kvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 06:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238525AbhG3Kvc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 06:51:32 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11632C0613D3
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 03:51:27 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id c16so10590843plh.7
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 03:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=workware-net-au.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eUV5nhL5QABYzSLeXK88oyatwPt6Dns+LgdiyB39L3A=;
        b=JZz7/1b+6xO0d2CXQG2M+4cqJ/Df/EaCm1OGhxdaEj18vuefNVknh1SNs0uM9IIQ1i
         FCOSX6qfWJlq4ulzWt1KYJD9WrX0NBhfOPddV2jVOeen+CzqF9fOT89JZnrENmZZVHTw
         nuv2iSXmoj9DLQYSXfdE88l/mYcUtJaUMes6yMge2xwaO42UO+IUAcwmg/YYaAemMLE4
         1AFCSGVNGiavdbaR/olnHFCaQ0QgZzBduEubTJ/Qly8CGKPI7DKHFyZE0uT4gpR1Rlzy
         o3/FDtU45gek7w5gwopj2fpYRPlN4Sa7pzzdxPCTguiNfcOMUhMcMt8r173SiJqa9eZt
         UmrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eUV5nhL5QABYzSLeXK88oyatwPt6Dns+LgdiyB39L3A=;
        b=rkwGPgtWla1WbukTw90AMsP8N0ksjHFtyRSKEeL1toG7g9yiKKyPGe0sNK6OViYCDM
         oS7l1CEdW/G5D3yXJ88d5pWv7psUVBIA+PrXRagWfGvEBbbp64mWYpt1hhPiX5AZUE4q
         klCSo6FYXLQA1BAzpYka+UwR+tDx50iIIaZ+2rHh2rSoXYMMyY7FTLEX87PB41U0CrOh
         0AXaXPx4pXNFP5W3xFJL3CzSWDdr93MRWIcviVS8sKtUJ3LVuWW+WZ1M5bHPy7+rRkjp
         yecVwa8rIoDskfoNZsn5VukVjYdZF/cdYK8/E3m0U+Y3lahBVRqUvi5KAUSIJN0hjQ1F
         B88w==
X-Gm-Message-State: AOAM533jclMJSAY/ICygE/VhXs0yXe6tN5MJjs3fD35KS/c4wVI4kql+
        Tp/RMQOJWKC8aLIwS3/lFPvOh1qHwFG5p7X/
X-Google-Smtp-Source: ABdhPJzwNCu1Uf2wgff23wJkV6LR2TaRS0u1Vu6IM9EMm8XredlJFm4xRDD2CB3QXTUjlKr7yVUv4w==
X-Received: by 2002:a17:902:c202:b029:12c:9970:bdf9 with SMTP id 2-20020a170902c202b029012c9970bdf9mr94247pll.30.1627642286219;
        Fri, 30 Jul 2021 03:51:26 -0700 (PDT)
Received: from workware.net.au (117-20-69-228.751445.bne.nbn.aussiebb.net. [117.20.69.228])
        by smtp.gmail.com with ESMTPSA id h14sm1922347pfo.47.2021.07.30.03.51.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 03:51:25 -0700 (PDT)
From:   Steve Bennett <steveb@workware.net.au>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Steve Bennett <steveb@workware.net.au>
Subject: [PATCH] net: phy: micrel: Fix detection of ksz87xx switch
Date:   Fri, 30 Jul 2021 20:51:20 +1000
Message-Id: <20210730105120.93743-1-steveb@workware.net.au>
X-Mailer: git-send-email 2.24.2 (Apple Git-127)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The previous logic was wrong such that the ksz87xx
switch was not identified correctly.

Signed-off-by: Steve Bennett <steveb@workware.net.au>
---
 drivers/net/phy/micrel.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 4d53886f7d51..a4acec02c8cb 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -401,11 +401,11 @@ static int ksz8041_config_aneg(struct phy_device *phydev)
 }
 
 static int ksz8051_ksz8795_match_phy_device(struct phy_device *phydev,
-					    const u32 ksz_phy_id)
+					    const u32 ksz_8051)
 {
 	int ret;
 
-	if ((phydev->phy_id & MICREL_PHY_ID_MASK) != ksz_phy_id)
+	if ((phydev->phy_id & MICREL_PHY_ID_MASK) != PHY_ID_KSZ8051)
 		return 0;
 
 	ret = phy_read(phydev, MII_BMSR);
@@ -418,7 +418,7 @@ static int ksz8051_ksz8795_match_phy_device(struct phy_device *phydev,
 	 * the switch does not.
 	 */
 	ret &= BMSR_ERCAP;
-	if (ksz_phy_id == PHY_ID_KSZ8051)
+	if (ksz_8051)
 		return ret;
 	else
 		return !ret;
@@ -426,7 +426,7 @@ static int ksz8051_ksz8795_match_phy_device(struct phy_device *phydev,
 
 static int ksz8051_match_phy_device(struct phy_device *phydev)
 {
-	return ksz8051_ksz8795_match_phy_device(phydev, PHY_ID_KSZ8051);
+	return ksz8051_ksz8795_match_phy_device(phydev, 1);
 }
 
 static int ksz8081_config_init(struct phy_device *phydev)
@@ -535,7 +535,7 @@ static int ksz8061_config_init(struct phy_device *phydev)
 
 static int ksz8795_match_phy_device(struct phy_device *phydev)
 {
-	return ksz8051_ksz8795_match_phy_device(phydev, PHY_ID_KSZ87XX);
+	return ksz8051_ksz8795_match_phy_device(phydev, 0);
 }
 
 static int ksz9021_load_values_from_of(struct phy_device *phydev,
-- 
2.24.2 (Apple Git-127)

