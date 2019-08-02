Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45E987EF99
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 10:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404458AbfHBIsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 04:48:25 -0400
Received: from lechat.rtp-net.org ([51.15.165.164]:42678 "EHLO
        lechat.rtp-net.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404364AbfHBIsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 04:48:25 -0400
X-Greylist: delayed 492 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Aug 2019 04:48:24 EDT
Received: by lechat.rtp-net.org (Postfix, from userid 115)
        id 1BD571808B6; Fri,  2 Aug 2019 10:40:05 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on lechat.rtp-net.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.2
Received: from lapoire.rtp-net.org (lapoire.rtp-net.org [IPv6:2a01:e0a:7:98c0:14:7ff:fec3:5d0])
        by lechat.rtp-net.org (Postfix) with ESMTPSA id B813218003C;
        Fri,  2 Aug 2019 10:39:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=rtp-net.org; s=email;
        t=1564735199; bh=pXXHhVxgL2bLhvlqT76d+ABFCLiqzHn5jvnPPzAbBE8=;
        h=Date:From:To:Cc:Subject:From;
        b=Db60miHaQmgCVXlMw+HX22FWc93vZB/do3WhUEIpFON0APJmp2nadT0bmCDpCeyaN
         abzTmioFbRFjHXnKnweAq+WIP6COF5m9S5f6IcltAVxQsidGDYpevD4nLHrSmANYWg
         mGecMCEQzMn8GzZkT3MHB8PKB3jCD2tVaiVvnylO5Qp62u6wDCOY7HYPKkXzeTElwF
         r1i3+NrtUQxuDAzVnfNoRDdS1qRaDP4UQCgX4rONf92MHlJhkpVt7spNhfnEr15RbP
         Z9A0McavtNZoJrAz+rTcuvrnM4UHy7oE0oTq8c/Y6bbbG7LckxIFy7V5mExCD85/We
         Pgmsq7+cXf9wX/n1pLYJoLiRH48YfqOzD+laqGNxpX/tFt6qdB9vm82TkEMrSd8eQq
         ylBO4g1Co58N2pcJR/iJSllwpuoGnME6yILcNPUaGNZAclougxdtchbkrSRUoYynT0
         IhATY7wDoCF1csRr7w5Yx0ZZkUaghHCbYzugQ0og1OBNn2NkUecjaVWT0cHZ4YhP7b
         Sfrt82YRlqN7dPvdOcb9zBj7X17I8zUJtUytrf6neB4qCAylCciXDfNRaMqUv4pd9K
         RyS1s/LMwFuEMiDsZ3dBjLYARnKFgXyZBCHZOxilZKO1i3RljqQTu/h2aeXuIBCJwQ
         Q4JoeOFrCd2dzW2eFpQ3AtfU=
Received: from jules.rtp-net.org (jules.rtp-net.org [192.168.2.4])
        by lapoire.rtp-net.org (Postfix) with ESMTP id 621B740229;
        Fri,  2 Aug 2019 08:39:59 +0000 (UTC)
Received: by jules.rtp-net.org (Postfix, from userid 10001)
        id CB7FE6FF; Fri,  2 Aug 2019 10:39:58 +0200 (CEST)
Message-ID: <20190802083310.772136040@rtp-net.org>
User-Agent: quilt/0.66
Date:   Fri, 02 Aug 2019 10:32:40 +0200
From:   Arnaud Patard (Rtp) <arnaud.patard@rtp-net.org>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Arnaud Patard <arnaud.patard@rtp-net.org>
Subject: [patch 1/1] drivers/net/ethernet/marvell/mvmdio.c: Fix non OF case
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Orion5.x systems are still using machine files and not device-tree.
Commit 96cb4342382290c9 ("net: mvmdio: allow up to three clocks to be
specified for orion-mdio") has replaced devm_clk_get() with of_clk_get(),
leading to a oops at boot and not working network, as reported in 
https://lists.debian.org/debian-arm/2019/07/msg00088.html and possibly in
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=908712.

Link: https://lists.debian.org/debian-arm/2019/07/msg00088.html
Fixes: 96cb4342382290c9 ("net: mvmdio: allow up to three clocks to be specified for orion-mdio")
Signed-off-by: Arnaud Patard <arnaud.patard@rtp-net.org>
Index: linux-next/drivers/net/ethernet/marvell/mvmdio.c
===================================================================
--- linux-next.orig/drivers/net/ethernet/marvell/mvmdio.c
+++ linux-next/drivers/net/ethernet/marvell/mvmdio.c
@@ -319,20 +319,33 @@ static int orion_mdio_probe(struct platf
 
 	init_waitqueue_head(&dev->smi_busy_wait);
 
-	for (i = 0; i < ARRAY_SIZE(dev->clk); i++) {
-		dev->clk[i] = of_clk_get(pdev->dev.of_node, i);
-		if (PTR_ERR(dev->clk[i]) == -EPROBE_DEFER) {
+	if (pdev->dev.of_node) {
+		for (i = 0; i < ARRAY_SIZE(dev->clk); i++) {
+			dev->clk[i] = of_clk_get(pdev->dev.of_node, i);
+			if (PTR_ERR(dev->clk[i]) == -EPROBE_DEFER) {
+				ret = -EPROBE_DEFER;
+				goto out_clk;
+			}
+			if (IS_ERR(dev->clk[i]))
+				break;
+			clk_prepare_enable(dev->clk[i]);
+		}
+
+		if (!IS_ERR(of_clk_get(pdev->dev.of_node,
+				       ARRAY_SIZE(dev->clk))))
+			dev_warn(&pdev->dev,
+				 "unsupported number of clocks, limiting to the first "
+				 __stringify(ARRAY_SIZE(dev->clk)) "\n");
+	} else {
+		dev->clk[0] = clk_get(&pdev->dev, NULL);
+		if (PTR_ERR(dev->clk[0]) == -EPROBE_DEFER) {
 			ret = -EPROBE_DEFER;
 			goto out_clk;
 		}
-		if (IS_ERR(dev->clk[i]))
-			break;
-		clk_prepare_enable(dev->clk[i]);
+		if (!IS_ERR(dev->clk[0]))
+			clk_prepare_enable(dev->clk[0]);
 	}
 
-	if (!IS_ERR(of_clk_get(pdev->dev.of_node, ARRAY_SIZE(dev->clk))))
-		dev_warn(&pdev->dev, "unsupported number of clocks, limiting to the first "
-			 __stringify(ARRAY_SIZE(dev->clk)) "\n");
 
 	dev->err_interrupt = platform_get_irq(pdev, 0);
 	if (dev->err_interrupt > 0 &&


