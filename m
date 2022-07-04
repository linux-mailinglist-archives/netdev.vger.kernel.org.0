Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C979F564EF6
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 09:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232994AbiGDHqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 03:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232531AbiGDHqi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 03:46:38 -0400
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F3CDA958D;
        Mon,  4 Jul 2022 00:46:36 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.92,243,1650898800"; 
   d="scan'208";a="126596921"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 04 Jul 2022 16:46:36 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id F3BE1421E05D;
        Mon,  4 Jul 2022 16:46:35 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     wg@grandegger.com, mkl@pengutronix.de
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Duy Nguyen <duy.nguyen.rh@renesas.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH] can: rcar_canfd: Fix data transmission failed on R-Car V3U
Date:   Mon,  4 Jul 2022 16:46:11 +0900
Message-Id: <20220704074611.957191-1-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.1 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        KHOP_HELO_FCRDNS,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Duy Nguyen <duy.nguyen.rh@renesas.com>

On R-Car V3U, this driver should use suitable register offset instead of
other SoCs' one. Otherwise, data transmission failed on R-Car V3U.

Fixes: 45721c406dcf ("can: rcar_canfd: Add support for r8a779a0 SoC")
Signed-off-by: Duy Nguyen <duy.nguyen.rh@renesas.com>
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
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
2.25.1

