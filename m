Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD5C637FE2
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 20:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiKXT5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 14:57:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiKXT5S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 14:57:18 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A641891C19
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 11:57:15 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oyILR-0004d5-V4
        for netdev@vger.kernel.org; Thu, 24 Nov 2022 20:57:14 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id DD907128972
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 19:57:11 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 073AD128943;
        Thu, 24 Nov 2022 19:57:10 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 25ca0acd;
        Thu, 24 Nov 2022 19:57:09 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Ziyang Xuan <william.xuanziyang@huawei.com>,
        Max Staudt <max@enpas.org>, stable@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 1/8] can: can327: can327_feed_frame_to_netdev(): fix potential skb leak when netdev is down
Date:   Thu, 24 Nov 2022 20:57:01 +0100
Message-Id: <20221124195708.1473369-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221124195708.1473369-1-mkl@pengutronix.de>
References: <20221124195708.1473369-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ziyang Xuan <william.xuanziyang@huawei.com>

In can327_feed_frame_to_netdev(), it did not free the skb when netdev
is down, and all callers of can327_feed_frame_to_netdev() did not free
allocated skb too. That would trigger skb leak.

Fix it by adding kfree_skb() in can327_feed_frame_to_netdev() when netdev
is down. Not tested, just compiled.

Fixes: 43da2f07622f ("can: can327: CAN/ldisc driver for ELM327 based OBD-II adapters")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Link: https://lore.kernel.org/all/20221110061437.411525-1-william.xuanziyang@huawei.com
Reviewed-by: Max Staudt <max@enpas.org>
Cc: stable@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/can327.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/can327.c b/drivers/net/can/can327.c
index 094197780776..ed3d0b8989a0 100644
--- a/drivers/net/can/can327.c
+++ b/drivers/net/can/can327.c
@@ -263,8 +263,10 @@ static void can327_feed_frame_to_netdev(struct can327 *elm, struct sk_buff *skb)
 {
 	lockdep_assert_held(&elm->lock);
 
-	if (!netif_running(elm->dev))
+	if (!netif_running(elm->dev)) {
+		kfree_skb(skb);
 		return;
+	}
 
 	/* Queue for NAPI pickup.
 	 * rx-offload will update stats and LEDs for us.

base-commit: ad17c2a3f11b0f6b122e7842d8f7d9a5fcc7ac63
-- 
2.35.1


