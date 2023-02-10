Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56DC36920F0
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 15:40:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232026AbjBJOj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 09:39:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232396AbjBJOj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 09:39:57 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 339D871647
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 06:39:55 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jzi@pengutronix.de>)
        id 1pQUZ6-0004Qk-Qt; Fri, 10 Feb 2023 15:39:52 +0100
Received: from [2a0a:edc0:0:1101:1d::39] (helo=dude03.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <jzi@pengutronix.de>)
        id 1pQUZ2-0040F9-QF; Fri, 10 Feb 2023 15:39:50 +0100
Received: from jzi by dude03.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <jzi@pengutronix.de>)
        id 1pQUZ3-00EPFb-2Q; Fri, 10 Feb 2023 15:39:49 +0100
From:   Johannes Zink <j.zink@pengutronix.de>
To:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        kernel@pengutronix.de, Johannes Zink <j.zink@pengutronix.de>
Subject: [PATCH net] net: stmmac: fix order of dwmac5 FlexPPS parametrization sequence
Date:   Fri, 10 Feb 2023 15:39:37 +0100
Message-Id: <20230210143937.3427483-1-j.zink@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: jzi@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So far changing the period by just setting new period values while
running did not work.

The order as indicated by the publicly available reference manual of the i.MX8MP [1]
indicates a sequence:

 * initiate the programming sequence
 * set the values for PPS period and start time
 * start the pulse train generation.

This is currently not used in dwmac5_flex_pps_config(), which instead does:

 * initiate the programming sequence and immediately start the pulse train generation
 * set the values for PPS period and start time

This caused the period values written not to take effect until the FlexPPS output was
disabled and re-enabled again.

This patch fix the order and allows the period to be set immediately.

[1] https://www.nxp.com/webapp/Download?colCode=IMX8MPRM

Fixes: 9a8a02c9d46d ("net: stmmac: Add Flexible PPS support")
Signed-off-by: Johannes Zink <j.zink@pengutronix.de>
---

This fix is not super critical, but if you do another cycle anyway,
feel free to take or review it.

drivers/net/ethernet/stmicro/stmmac/dwmac5.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac5.c b/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
index 413f66017219..e95d35f1e5a0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
@@ -541,9 +541,9 @@ int dwmac5_flex_pps_config(void __iomem *ioaddr, int index,
 		return 0;
 	}

-	val |= PPSCMDx(index, 0x2);
 	val |= TRGTMODSELx(index, 0x2);
 	val |= PPSEN0;
+	writel(val, ioaddr + MAC_PPS_CONTROL);

 	writel(cfg->start.tv_sec, ioaddr + MAC_PPSx_TARGET_TIME_SEC(index));

@@ -568,6 +568,7 @@ int dwmac5_flex_pps_config(void __iomem *ioaddr, int index,
 	writel(period - 1, ioaddr + MAC_PPSx_WIDTH(index));

 	/* Finally, activate it */
+	val |= PPSCMDx(index, 0x2);
 	writel(val, ioaddr + MAC_PPS_CONTROL);
 	return 0;
 }
--
2.30.2

