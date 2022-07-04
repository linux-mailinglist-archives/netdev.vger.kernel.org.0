Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83B7D565613
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 14:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234627AbiGDMw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 08:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234667AbiGDMwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 08:52:41 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0227211178
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 05:52:34 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o8LYx-00014i-0J
        for netdev@vger.kernel.org; Mon, 04 Jul 2022 14:52:27 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 5DA73A798B
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 12:26:15 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id BAA4EA7926;
        Mon,  4 Jul 2022 12:26:14 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 6131d265;
        Mon, 4 Jul 2022 12:26:14 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Duy Nguyen <duy.nguyen.rh@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 03/15] can: rcar_canfd: Fix data transmission failed on R-Car V3U
Date:   Mon,  4 Jul 2022 14:26:01 +0200
Message-Id: <20220704122613.1551119-4-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220704122613.1551119-1-mkl@pengutronix.de>
References: <20220704122613.1551119-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Duy Nguyen <duy.nguyen.rh@renesas.com>

On R-Car V3U, this driver should use suitable register offset instead of
other SoCs' one. Otherwise, data transmission failed on R-Car V3U.

Fixes: 45721c406dcf ("can: rcar_canfd: Add support for r8a779a0 SoC")
Link: https://lore.kernel.org/all/20220704074611.957191-1-yoshihiro.shimoda.uh@renesas.com
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Duy Nguyen <duy.nguyen.rh@renesas.com>
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/rcar/rcar_canfd.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index 40a11445d021..ba42cef10a53 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1332,7 +1332,10 @@ static void rcar_canfd_set_bittiming(struct net_device *dev)
 		cfg = (RCANFD_DCFG_DTSEG1(gpriv, tseg1) | RCANFD_DCFG_DBRP(brp) |
 		       RCANFD_DCFG_DSJW(sjw) | RCANFD_DCFG_DTSEG2(gpriv, tseg2));
 
-		rcar_canfd_write(priv->base, RCANFD_F_DCFG(ch), cfg);
+		if (is_v3u(gpriv))
+			rcar_canfd_write(priv->base, RCANFD_V3U_DCFG(ch), cfg);
+		else
+			rcar_canfd_write(priv->base, RCANFD_F_DCFG(ch), cfg);
 		netdev_dbg(priv->ndev, "drate: brp %u, sjw %u, tseg1 %u, tseg2 %u\n",
 			   brp, sjw, tseg1, tseg2);
 	} else {
-- 
2.35.1


