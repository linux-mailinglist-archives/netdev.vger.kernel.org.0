Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 116DE57B30F
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 10:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237340AbiGTIga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 04:36:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiGTIg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 04:36:28 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E089B50045
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 01:36:27 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oE5By-0005nV-DA
        for netdev@vger.kernel.org; Wed, 20 Jul 2022 10:36:26 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 6DA27B5B8F
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 08:36:25 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id BEDFDB5B86;
        Wed, 20 Jul 2022 08:36:24 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 4e2314fe;
        Wed, 20 Jul 2022 08:36:23 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Liang He <windhl@126.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 2/2] can: rcar_canfd: Add missing of_node_put() in rcar_canfd_probe()
Date:   Wed, 20 Jul 2022 10:36:21 +0200
Message-Id: <20220720083621.3294548-3-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720083621.3294548-1-mkl@pengutronix.de>
References: <20220720083621.3294548-1-mkl@pengutronix.de>
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

From: Liang He <windhl@126.com>

We should use of_node_put() for the reference returned by
of_get_child_by_name() which has increased the refcount.

Fixes: 45721c406dcf ("can: rcar_canfd: Add support for r8a779a0 SoC")
Link: https://lore.kernel.org/all/20220712095623.364287-1-windhl@126.com
Signed-off-by: Liang He <windhl@126.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/rcar/rcar_canfd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index ba42cef10a53..cb0321ea853c 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1843,6 +1843,7 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 		of_child = of_get_child_by_name(pdev->dev.of_node, name);
 		if (of_child && of_device_is_available(of_child))
 			channels_mask |= BIT(i);
+		of_node_put(of_child);
 	}
 
 	if (chip_id != RENESAS_RZG2L) {
-- 
2.35.1


