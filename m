Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B81169BD1F
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 22:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbjBRVlE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Feb 2023 16:41:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbjBRVlD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Feb 2023 16:41:03 -0500
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA1F13527;
        Sat, 18 Feb 2023 13:40:59 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 2ECB7642ECBC;
        Sat, 18 Feb 2023 22:40:57 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id ZvwjiXo10fMe; Sat, 18 Feb 2023 22:40:56 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id AA05B642ECD2;
        Sat, 18 Feb 2023 22:40:56 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id qQfG2d5tGiuW; Sat, 18 Feb 2023 22:40:56 +0100 (CET)
Received: from blindfold.corp.sigma-star.at (213-47-184-186.cable.dynamic.surfer.at [213.47.184.186])
        by lithops.sigma-star.at (Postfix) with ESMTPSA id 2F584642ECBC;
        Sat, 18 Feb 2023 22:40:56 +0100 (CET)
From:   Richard Weinberger <richard@nod.at>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, pabeni@redhat.com, kuba@kernel.org,
        edumazet@google.com, davem@davemloft.net, linux-imx@nxp.com,
        xiaoning.wang@nxp.com, shenwei.wang@nxp.com, wei.fang@nxp.com,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH] [RFC] net: fec: Allow turning off IRQ coalescing
Date:   Sat, 18 Feb 2023 22:40:37 +0100
Message-Id: <20230218214037.16977-1-richard@nod.at>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Setting tx/rx-frames or tx/rx-usecs to zero is currently possible but
has no effect.
Also IRQ coalescing is always enabled on supported hardware.

This is confusing and causes users to believe that they have successfully
disabled IRQ coalescing by setting tx/rx-frames and tx/rx-usecs to zero.

With this change applied it is possible to disable IRQ coalescing by
configuring both tx/rx-frames and tx/rx-usecs to zero.

Setting only one value to zero is still not possible as the hardware
does not support it.
In this case ethtool will face -EINVAL.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/net/ethernet/freescale/fec_main.c | 73 ++++++++++++++++-------
 1 file changed, 50 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethe=
rnet/freescale/fec_main.c
index 2341597408d1..cc3c5e09e02f 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -74,7 +74,7 @@
 #include "fec.h"
=20
 static void set_multicast_list(struct net_device *ndev);
-static void fec_enet_itr_coal_set(struct net_device *ndev);
+static int fec_enet_itr_coal_set(struct net_device *ndev);
=20
 #define DRIVER_NAME	"fec"
=20
@@ -1217,7 +1217,7 @@ fec_restart(struct net_device *ndev)
=20
 	/* Init the interrupt coalescing */
 	if (fep->quirks & FEC_QUIRK_HAS_COALESCE)
-		fec_enet_itr_coal_set(ndev);
+		WARN_ON_ONCE(fec_enet_itr_coal_set(ndev));
 }
=20
 static int fec_enet_ipc_handle_init(struct fec_enet_private *fep)
@@ -2867,30 +2867,57 @@ static int fec_enet_us_to_itr_clock(struct net_de=
vice *ndev, int us)
 }
=20
 /* Set threshold for interrupt coalescing */
-static void fec_enet_itr_coal_set(struct net_device *ndev)
+static int fec_enet_itr_coal_set(struct net_device *ndev)
 {
+	bool disable_rx_itr =3D false, disable_tx_itr =3D false;
 	struct fec_enet_private *fep =3D netdev_priv(ndev);
-	int rx_itr, tx_itr;
+	struct device *dev =3D &fep->pdev->dev;
+	int rx_itr =3D 0, tx_itr =3D 0;
=20
-	/* Must be greater than zero to avoid unpredictable behavior */
-	if (!fep->rx_time_itr || !fep->rx_pkts_itr ||
-	    !fep->tx_time_itr || !fep->tx_pkts_itr)
-		return;
+	if (!fep->rx_time_itr || !fep->rx_pkts_itr) {
+		if (fep->rx_time_itr || fep->rx_pkts_itr) {
+			dev_warn(dev, "Rx coalesced frames and usec have to be "
+				      "both positive or both zero to disable Rx "
+				      "coalescence completely\n");
+			return -EINVAL;
+		}
=20
-	/* Select enet system clock as Interrupt Coalescing
-	 * timer Clock Source
-	 */
-	rx_itr =3D FEC_ITR_CLK_SEL;
-	tx_itr =3D FEC_ITR_CLK_SEL;
+		disable_rx_itr =3D true;
+	}
=20
-	/* set ICFT and ICTT */
-	rx_itr |=3D FEC_ITR_ICFT(fep->rx_pkts_itr);
-	rx_itr |=3D FEC_ITR_ICTT(fec_enet_us_to_itr_clock(ndev, fep->rx_time_it=
r));
-	tx_itr |=3D FEC_ITR_ICFT(fep->tx_pkts_itr);
-	tx_itr |=3D FEC_ITR_ICTT(fec_enet_us_to_itr_clock(ndev, fep->tx_time_it=
r));
+	if (!fep->tx_time_itr || !fep->tx_pkts_itr) {
+		if (fep->tx_time_itr || fep->tx_pkts_itr) {
+			dev_warn(dev, "Tx coalesced frames and usec have to be "
+				      "both positive or both zero to disable Tx "
+				      "coalescence completely\n");
+			return -EINVAL;
+		}
+
+		disable_tx_itr =3D true;
+	}
+
+	if (!disable_rx_itr) {
+		/* Select enet system clock as Interrupt Coalescing
+		 * timer Clock Source
+		 */
+		rx_itr =3D FEC_ITR_CLK_SEL;
+
+		/* set ICFT and ICTT */
+		rx_itr |=3D FEC_ITR_ICFT(fep->rx_pkts_itr);
+		rx_itr |=3D FEC_ITR_ICTT(fec_enet_us_to_itr_clock(ndev, fep->rx_time_i=
tr));
+
+		rx_itr |=3D FEC_ITR_EN;
+	}
+
+	if (!disable_tx_itr) {
+		tx_itr =3D FEC_ITR_CLK_SEL;
+
+		tx_itr |=3D FEC_ITR_ICFT(fep->tx_pkts_itr);
+		tx_itr |=3D FEC_ITR_ICTT(fec_enet_us_to_itr_clock(ndev, fep->tx_time_i=
tr));
+
+		tx_itr |=3D FEC_ITR_EN;
+	}
=20
-	rx_itr |=3D FEC_ITR_EN;
-	tx_itr |=3D FEC_ITR_EN;
=20
 	writel(tx_itr, fep->hwp + FEC_TXIC0);
 	writel(rx_itr, fep->hwp + FEC_RXIC0);
@@ -2900,6 +2927,8 @@ static void fec_enet_itr_coal_set(struct net_device=
 *ndev)
 		writel(tx_itr, fep->hwp + FEC_TXIC2);
 		writel(rx_itr, fep->hwp + FEC_RXIC2);
 	}
+
+	return 0;
 }
=20
 static int fec_enet_get_coalesce(struct net_device *ndev,
@@ -2961,9 +2990,7 @@ static int fec_enet_set_coalesce(struct net_device =
*ndev,
 	fep->tx_time_itr =3D ec->tx_coalesce_usecs;
 	fep->tx_pkts_itr =3D ec->tx_max_coalesced_frames;
=20
-	fec_enet_itr_coal_set(ndev);
-
-	return 0;
+	return fec_enet_itr_coal_set(ndev);
 }
=20
 static int fec_enet_get_tunable(struct net_device *netdev,
--=20
2.26.2

