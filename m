Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C86654F1BA
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 09:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380586AbiFQHQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 03:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231145AbiFQHQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 03:16:24 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7950E13DEC
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 00:16:23 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1o26DD-0004qG-Cq; Fri, 17 Jun 2022 09:16:11 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1o26DA-00112Z-1T; Fri, 17 Jun 2022 09:16:09 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1o26DA-00Fs5X-P4; Fri, 17 Jun 2022 09:16:08 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v2 1/1] net: macb: fix negative max_mtu size for sama5d3
Date:   Fri, 17 Jun 2022 09:16:07 +0200
Message-Id: <20220617071607.3782772-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

JML register on probe will return zero . This register is configured
later on macb_init_hw() which is called on open.
Since we have zero, after header and FCS length subtraction we will get
negative max_mtu size. This issue was affecting DSA drivers with MTU support
(for example KSZ9477).

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
changes v2:
- properly describe fail reason
- simplify max_mtu logic

 drivers/net/ethernet/cadence/macb_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index d89098f4ede8..d0ea8dbfa213 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4913,8 +4913,8 @@ static int macb_probe(struct platform_device *pdev)
 
 	/* MTU range: 68 - 1500 or 10240 */
 	dev->min_mtu = GEM_MTU_MIN_SIZE;
-	if (bp->caps & MACB_CAPS_JUMBO)
-		dev->max_mtu = gem_readl(bp, JML) - ETH_HLEN - ETH_FCS_LEN;
+	if ((bp->caps & MACB_CAPS_JUMBO) && bp->jumbo_max_len)
+		dev->max_mtu = bp->jumbo_max_len - ETH_HLEN - ETH_FCS_LEN;
 	else
 		dev->max_mtu = ETH_DATA_LEN;
 
-- 
2.30.2

