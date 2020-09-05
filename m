Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4609F25E71E
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 12:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728459AbgIEKqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 06:46:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726597AbgIEKqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 06:46:07 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8A58C061244
        for <netdev@vger.kernel.org>; Sat,  5 Sep 2020 03:46:05 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id a22so4396929ljp.13
        for <netdev@vger.kernel.org>; Sat, 05 Sep 2020 03:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pcgPe8IEjyZ+taBJRqfgG/JXoAHcnjAaA3oAYOfzK2A=;
        b=a93uHeckTPF1H/uHZsCnHwTEIZivaYPLTq3TPAXq5maa/mirVqcliFY9cOgyZQB8G5
         YbMVjs4kk1roBOBuKaLeSsb4rA8qhlu+j1gNS0PPfn9RkUJ/LyOriiKjDemiSbG5WOqx
         zd7CokBnwAPiyIb98LThWkBgw8WGmdv3oocw4pAQpRPA4X5vwruyrSBOvq2x/HKAmJvk
         OVWzzr3ZXH8nQH6iijTlcKla2mMNNAayiSLEHpuUqfDfaE0tE39MQd6Z7peHBeQL6rS5
         lxcx7PoJ/kzi701gxEwlt1prYWVGBygSrjak50nM/U2UJroHGTTc2eMvY32V/ExS/r8W
         UqCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pcgPe8IEjyZ+taBJRqfgG/JXoAHcnjAaA3oAYOfzK2A=;
        b=im9ubo9w2OlPSjJ53p1p3k/HUeGIA7ukAr5P8HfkoNPWx/6Z65hWo3EC4c9ep94/m4
         OAAq/TGBwDwNDLOi4TDrk3Ee/DyUbSQwK5vcEctZuob3+bxOgiuJxrQeu/i5E+reWIH6
         lfMniAryUCYec7pXToxOjV6Ikd2HawXLD/L1v6FXxw56JebY0LWA9/DCMMxHeNqEGKdH
         oMvyfD2IAreccVzPIaa/MHwNaUWFLdu0PVD0NFHTCHfhO61Z+rD+S/1t9Xs8p8rm0W55
         CItq9RrgQy3s4zfs7QmH1KT762lwk3Q0+KMVBakDIv/K3da5/Vu09+2kBAz4HdFNnutB
         JTzA==
X-Gm-Message-State: AOAM531+5HxQmUuWgudt8FiPB/UGR9zBb0+pv77cTsl2jt+0tmFn1q7H
        lRHY5hvGzrMbBabsdX7VHSXhn/N/8K/yMg==
X-Google-Smtp-Source: ABdhPJwXPPU0Ww3z+8tU7wZvK+0nvrdxGIOSzivrdNDKtcfHy+s71WR30PKZJQonWqjFgTtfJ+hh6A==
X-Received: by 2002:a2e:b0f8:: with SMTP id h24mr5768083ljl.165.1599302758573;
        Sat, 05 Sep 2020 03:45:58 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-92d7225c.014-348-6c756e10.bbcust.telenor.se. [92.34.215.146])
        by smtp.gmail.com with ESMTPSA id i22sm1325108ljb.53.2020.09.05.03.45.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2020 03:45:58 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [net-next PATCH] net: gemini: Try to register phy before netdev
Date:   Sat,  5 Sep 2020 12:45:30 +0200
Message-Id: <20200905104530.29998-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's nice if the phy is online before we register the netdev
so try to do that first.

Reported-by: David Miller <davem@davemloft.net>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/net/ethernet/cortina/gemini.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index ffec0f3dd957..cf4dc6345f0d 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -2505,6 +2505,11 @@ static int gemini_ethernet_port_probe(struct platform_device *pdev)
 	if (ret)
 		goto unprepare;
 
+	ret = gmac_setup_phy(netdev);
+	if (ret)
+		netdev_info(netdev,
+			    "PHY init failed, deferring to ifup time\n");
+
 	ret = register_netdev(netdev);
 	if (ret)
 		goto unprepare;
@@ -2513,10 +2518,6 @@ static int gemini_ethernet_port_probe(struct platform_device *pdev)
 		    "irq %d, DMA @ 0x%pap, GMAC @ 0x%pap\n",
 		    port->irq, &dmares->start,
 		    &gmacres->start);
-	ret = gmac_setup_phy(netdev);
-	if (ret)
-		netdev_info(netdev,
-			    "PHY init failed, deferring to ifup time\n");
 	return 0;
 
 unprepare:
-- 
2.26.2

