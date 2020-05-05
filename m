Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E792D1C4BB2
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 04:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgEECDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 22:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726449AbgEECDn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 22:03:43 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9797C061A0F;
        Mon,  4 May 2020 19:03:41 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id x15so139627pfa.1;
        Mon, 04 May 2020 19:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pe3jyn/UjqDKwafRVinnOYh9MKrSxi51+30s2pccLlE=;
        b=K4p8qrSwmI/1zupjIN0ITVdbZJhfLFx4bfU3tFXZGHuJcuZ3EGWhx1T0GWTk1N1CW9
         AkhfB3DLV2suzGAgFskJv9kSCDPTnDGBiCsms6qzmG4d64Vg+dShQP+dtyi2bguAF1dT
         R+KVDAACRz6Ul3stYQ4IIrhE8SUMV60ezeIq4Q4LebcYMg1fHYsHb3okEXkmSyPEmm1f
         BiT/LC38MMKaNO0Wetr06fC946gv21zO3CLnqIN1+8I7FT03nONU1VDHBRrMRHBQLPjN
         dp4UbjpkWXfL/ThHImDfm9hMSH24+jHBwRTMDj3JvyFAAVBcJF5EXZJRyqvgeiJyFMhJ
         HZgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pe3jyn/UjqDKwafRVinnOYh9MKrSxi51+30s2pccLlE=;
        b=AzMg4z8JC1hMqe9vXW2gqLrpQ4rpu7qFxSfG8E1xGH6FO0R0ZGPWWM7tckzlq0Y6Nc
         dN7iyjDBsg8QHgkNCN/+ehOygVrWccxjvtyRfa4E02XSzVgxIZz0ZevapRLbavuvDUUz
         iZn8unoMCAGMbjSOGORXRgwStY4cNP5Z4mri/L84U2Xwxr8rWDQBtuU+MhP0St9l72yo
         KNERvY4on7MjYhsAbxNILNWmkYEc4qwneJ1BQal3jYgYVzHLhIku8eGmYWh+hb2Yyx61
         OyrNBNxbojqOkXuXX/UH1b0iaMQ6XyStUaIj/lpt2Og5Ntalmtisyp4wiV60nXdbXLCF
         Uqyw==
X-Gm-Message-State: AGi0PuYFzz6rE9ojCHomhVstyfK2g1C/O/F2dJh0uXBu4kN4kN3z/pPh
        NXKMxu18d1ALsnZrHnM10CI=
X-Google-Smtp-Source: APiQypIvim676iHFDZjXvK/Nb2PRLUij6USWl42OlXlhfv0KplixlMr0clPiP+b76D9WeUh5LK2iFA==
X-Received: by 2002:aa7:9690:: with SMTP id f16mr967927pfk.20.1588644217084;
        Mon, 04 May 2020 19:03:37 -0700 (PDT)
Received: from localhost ([162.211.220.152])
        by smtp.gmail.com with ESMTPSA id x132sm379112pfc.57.2020.05.04.19.03.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 04 May 2020 19:03:36 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     davem@davemloft.net, swboyd@chromium.org, ynezz@true.cz,
        netdev@vger.kernel.org, jonathan.richardson@broadcom.com
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>,
        Scott Branden <scott.branden@broadcom.com>,
        Ray Jui <ray.jui@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH net v1] net: broadcom: fix a mistake about ioremap resource
Date:   Tue,  5 May 2020 10:03:29 +0800
Message-Id: <20200505020329.31638-1-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit d7a5502b0bb8b ("net: broadcom: convert to
devm_platform_ioremap_resource_byname()") will broke this driver.
idm_base and nicpm_base were optional, after this change, they are
mandatory. it will probe fails with -22 when the dtb doesn't have them
defined. so revert part of this commit and make idm_base and nicpm_base
as optional.

Fixes: d7a5502b0bb8bde ("net: broadcom: convert to devm_platform_ioremap_resource_byname()")
Reported-by: Jonathan Richardson <jonathan.richardson@broadcom.com>
Cc: Scott Branden <scott.branden@broadcom.com>
Cc: Ray Jui <ray.jui@broadcom.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
 .../net/ethernet/broadcom/bgmac-platform.c    | 24 ++++++++++++-------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bgmac-platform.c b/drivers/net/ethernet/broadcom/bgmac-platform.c
index a5d1a6cb9ce3..6795b6d95f54 100644
--- a/drivers/net/ethernet/broadcom/bgmac-platform.c
+++ b/drivers/net/ethernet/broadcom/bgmac-platform.c
@@ -172,6 +172,7 @@ static int bgmac_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
 	struct bgmac *bgmac;
+	struct resource *regs;
 	const u8 *mac_addr;
 
 	bgmac = bgmac_alloc(&pdev->dev);
@@ -206,16 +207,21 @@ static int bgmac_probe(struct platform_device *pdev)
 	if (IS_ERR(bgmac->plat.base))
 		return PTR_ERR(bgmac->plat.base);
 
-	bgmac->plat.idm_base =
-		devm_platform_ioremap_resource_byname(pdev, "idm_base");
-	if (IS_ERR(bgmac->plat.idm_base))
-		return PTR_ERR(bgmac->plat.idm_base);
-	bgmac->feature_flags &= ~BGMAC_FEAT_IDM_MASK;
+	regs = platform_get_resource_byname(pdev, IORESOURCE_MEM, "idm_base");
+	if (regs) {
+		bgmac->plat.idm_base = devm_ioremap_resource(&pdev->dev, regs);
+		if (IS_ERR(bgmac->plat.idm_base))
+			return PTR_ERR(bgmac->plat.idm_base);
+		bgmac->feature_flags &= ~BGMAC_FEAT_IDM_MASK;
+	}
 
-	bgmac->plat.nicpm_base =
-		devm_platform_ioremap_resource_byname(pdev, "nicpm_base");
-	if (IS_ERR(bgmac->plat.nicpm_base))
-		return PTR_ERR(bgmac->plat.nicpm_base);
+	regs = platform_get_resource_byname(pdev, IORESOURCE_MEM, "nicpm_base");
+	if (regs) {
+		bgmac->plat.nicpm_base = devm_ioremap_resource(&pdev->dev,
+							       regs);
+		if (IS_ERR(bgmac->plat.nicpm_base))
+			return PTR_ERR(bgmac->plat.nicpm_base);
+	}
 
 	bgmac->read = platform_bgmac_read;
 	bgmac->write = platform_bgmac_write;
-- 
2.25.0

