Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADCCA4D796A
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 03:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232500AbiCNCnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 22:43:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235923AbiCNCm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 22:42:59 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D55B205E2;
        Sun, 13 Mar 2022 19:41:50 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id r12so12349886pla.1;
        Sun, 13 Mar 2022 19:41:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xMR3gdW7BLrew3/OAPNy28mUhLn0EbRf6Sq9j+wj9Fw=;
        b=P7wFRUrDfFkCmt8FoW2Dewmyt2jkHRvZcCqB+ziLG+MUNvZ/HDu7Im6tTo9WgQtwyH
         9Fu1CqctAi+raak0lF/M6yuPt3YzhHekqZwMivR2Mr/X6UHRRpDhqzxa2tQyjSyPTn7I
         NVKShBZMhv7pUBubSXT1V9B4/QK+7p6v+THXg3um3JXgKbBek/dqM7tA6vlFypviMLij
         Sp7GThydf5VHYYg78Pr0mOIr2gw/0ZuCb6dSOlte12SP7jU+pklsQ9VZFQ8PWUIdej2M
         YVXrAqt15hSXbX/Z6XtuKFi9KU61y+6nAx01YvJ3kAniubPNAjxpqzQGRLtyJ3Aj4c2z
         FV/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xMR3gdW7BLrew3/OAPNy28mUhLn0EbRf6Sq9j+wj9Fw=;
        b=5Oryze7ygYGz87SCet455CQyoVuHqsDDW0c9v9PIcmRTETVWl3rWRId3ScPhmmmasb
         /oJPaKV3RhlXmwaXiVyBwGmtzzqzOsT/UkV8vK723hYcVBFO6cb6QmnvE0N0B2VcbA5W
         FoEI06wfyQBCnHUCznzEKIAiiqxBrjq1jNEmDOd3bjwN7FkesFUrEulhu2eaWBpIhzdL
         Lk25CpiVumBLjc/4ZDqCYyiwaxTzLoJf6Ic6GHAdwp3e6V2OkC2BfpYkg991cDhWZJsp
         q/Yv/xeecXQZJXnM5sOasyL7R+3aKUPR0ll4Juw0tx9Gs/eKsOaJKjsBlpRMoiOurloo
         dshw==
X-Gm-Message-State: AOAM5300A+a8uxvOOOyXiLDFYMmyqEei05OoiCxMOyW35eeLRco+o8A2
        6uvX7Kflh7WpK7aVC0TTJzy85Mlalg0=
X-Google-Smtp-Source: ABdhPJzF1ibfmKhO0gwm/jTPkr3fjZadUySO8H9OHB/KxL5rlkFfeBw48zSfDTRQHpU+H2vuOvrHcQ==
X-Received: by 2002:a17:90b:3a91:b0:1bf:261e:7773 with SMTP id om17-20020a17090b3a9100b001bf261e7773mr33798841pjb.155.1647225709702;
        Sun, 13 Mar 2022 19:41:49 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id g12-20020a056a001a0c00b004e1307b249csm18055684pfv.69.2022.03.13.19.41.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Mar 2022 19:41:48 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     kuba@kernel.org
Cc:     cgel.zte@gmail.com, chi.minghao@zte.com.cn, davem@davemloft.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        sebastian.hesselbarth@gmail.com, zealci@zte.com.cn
Subject: [PATCH V3] net: mv643xx_eth: use platform_get_irq() instead of platform_get_resource()
Date:   Mon, 14 Mar 2022 02:41:44 +0000
Message-Id: <20220314024144.2112308-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220311082051.783b7c0b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20220311082051.783b7c0b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Minghao Chi <chi.minghao@zte.com.cn>

It is not recommened to use platform_get_resource(pdev, IORESOURCE_IRQ)
for requesting IRQ's resources any more, as they can be not ready yet in
case of DT-booting.

platform_get_irq() instead is a recommended way for getting IRQ even if
it was not retrieved earlier.

It also makes code simpler because we're getting "int" value right away
and no conversion from resource to int is required.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
---
v1->v2:
  - Add a space after "net:".
  - Use WARN_ON instead of BUG_ON.
v2->v3:
  - Release some operations.

 drivers/net/ethernet/marvell/mv643xx_eth.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index c31cbbae0eca..d75cf9097c7a 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -3092,8 +3092,7 @@ static int mv643xx_eth_probe(struct platform_device *pdev)
 	struct mv643xx_eth_private *mp;
 	struct net_device *dev;
 	struct phy_device *phydev = NULL;
-	struct resource *res;
-	int err;
+	int err, irq;
 
 	pd = dev_get_platdata(&pdev->dev);
 	if (pd == NULL) {
@@ -3189,9 +3188,14 @@ static int mv643xx_eth_probe(struct platform_device *pdev)
 	timer_setup(&mp->rx_oom, oom_timer_wrapper, 0);
 
 
-	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
-	BUG_ON(!res);
-	dev->irq = res->start;
+	irq = platform_get_irq(pdev, 0);
+	if (WARN_ON(irq < 0)) {
+		if (!IS_ERR(mp->clk))
+			clk_disable_unprepare(mp->clk);
+		free_netdev(dev);
+		return irq;
+	}
+	dev->irq = irq;
 
 	dev->netdev_ops = &mv643xx_eth_netdev_ops;
 
-- 
2.25.1

