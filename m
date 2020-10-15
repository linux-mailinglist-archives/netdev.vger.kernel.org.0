Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6A928EF7E
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 11:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388865AbgJOJmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 05:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388793AbgJOJmS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 05:42:18 -0400
X-Greylist: delayed 382 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 15 Oct 2020 02:42:18 PDT
Received: from lechat.rtp-net.org (lechat.rtp-net.org [IPv6:2001:bc8:3430:1000::c0f:fee])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51DA3C061755;
        Thu, 15 Oct 2020 02:42:18 -0700 (PDT)
Received: by lechat.rtp-net.org (Postfix, from userid 1000)
        id DFD9D18084F; Thu, 15 Oct 2020 11:35:51 +0200 (CEST)
Message-ID: <20201015093221.720980174@rtp-net.org>
User-Agent: quilt/0.66
Date:   Thu, 15 Oct 2020 11:32:15 +0200
From:   Arnaud Patard (Rtp) <arnaud.patard@rtp-net.org>
To:     stable@vger.kernel.org
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [patch 1/1] drivers/net/ethernet/marvell/mvmdio.c: Fix non OF case
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit d934423ac26ed373dfe089734d505dca5ff679b6 upstream.

Orion5.x systems are still using machine files and not device-tree.
Commit 96cb4342382290c9 ("net: mvmdio: allow up to three clocks to be
specified for orion-mdio") has replaced devm_clk_get() with of_clk_get(),
leading to a oops at boot and not working network, as reported in
https://lists.debian.org/debian-arm/2019/07/msg00088.html and possibly in
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=908712.
    
Link: https://lists.debian.org/debian-arm/2019/07/msg00088.html
Fixes: 96cb4342382290c9 ("net: mvmdio: allow up to three clocks to be specified for orion-mdio")
Signed-off-by: Arnaud Patard <arnaud.patard@rtp-net.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>

Index: linux/drivers/net/ethernet/marvell/mvmdio.c
===================================================================
--- linux.orig/drivers/net/ethernet/marvell/mvmdio.c
+++ linux/drivers/net/ethernet/marvell/mvmdio.c
@@ -319,15 +319,25 @@ static int orion_mdio_probe(struct platf
 
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
 
 	dev->err_interrupt = platform_get_irq(pdev, 0);




