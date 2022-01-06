Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 398F24863E9
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 12:48:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238642AbiAFLsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 06:48:13 -0500
Received: from relmlor2.renesas.com ([210.160.252.172]:16187 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S238456AbiAFLsM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 06:48:12 -0500
X-IronPort-AV: E=Sophos;i="5.88,266,1635174000"; 
   d="scan'208";a="106230362"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 06 Jan 2022 20:48:11 +0900
Received: from localhost.localdomain (unknown [10.226.36.204])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 9A3BF425C76E;
        Thu,  6 Jan 2022 20:48:08 +0900 (JST)
From:   Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Pavel Machek <pavel@denx.de>, linux-renesas-soc@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] can: rcar_canfd: Make sure we free CAN network device
Date:   Thu,  6 Jan 2022 11:48:00 +0000
Message-Id: <20220106114801.20563-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure we free CAN network device in the error path. There are several
jumps to fail label after allocating the CAN network device successfully.
This patch places the free_candev() under fail label so that in failure
path a jump to fail label frees the CAN network device.

Fixes: 76e9353a80e9 ("can: rcar_canfd: Add support for RZ/G2L family")
Reported-by: Pavel Machek <pavel@denx.de>
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
 drivers/net/can/rcar/rcar_canfd.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index ff9d0f5ae0dd..388521e70837 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1640,8 +1640,7 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
 	ndev = alloc_candev(sizeof(*priv), RCANFD_FIFO_DEPTH);
 	if (!ndev) {
 		dev_err(&pdev->dev, "alloc_candev() failed\n");
-		err = -ENOMEM;
-		goto fail;
+		return -ENOMEM;
 	}
 	priv = netdev_priv(ndev);
 
@@ -1735,8 +1734,8 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
 
 fail_candev:
 	netif_napi_del(&priv->napi);
-	free_candev(ndev);
 fail:
+	free_candev(ndev);
 	return err;
 }
 
-- 
2.17.1

