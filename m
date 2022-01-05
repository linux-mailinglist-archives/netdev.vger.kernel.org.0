Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA034854E8
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 15:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241046AbiAEOo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 09:44:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241004AbiAEOoX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 09:44:23 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8DC7C061792
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 06:44:23 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1n57WX-0004LH-TD
        for netdev@vger.kernel.org; Wed, 05 Jan 2022 15:44:21 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id B71D76D1B30
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 14:44:11 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 07EFB6D1ADD;
        Wed,  5 Jan 2022 14:44:07 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id e2a3b710;
        Wed, 5 Jan 2022 14:44:04 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 13/15] can: dev: add sanity check in can_set_static_ctrlmode()
Date:   Wed,  5 Jan 2022 15:44:00 +0100
Message-Id: <20220105144402.1174191-14-mkl@pengutronix.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220105144402.1174191-1-mkl@pengutronix.de>
References: <20220105144402.1174191-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

Previous patch removed can_priv::ctrlmode_static to replace it with
can_get_static_ctrlmode().

A condition sine qua non for this to work is that the controller
static modes should never be set in can_priv::ctrlmode_supported
(c.f. the comment on can_priv::ctrlmode_supported which states that it
is for "options that can be *modified* by netlink"). Also, this
condition is already correctly fulfilled by all existing drivers
which rely on the ctrlmode_static feature.

Nonetheless, we added an extra safeguard in can_set_static_ctrlmode()
to return an error value and to warn the developer who would be
adventurous enough to set to static a given feature that is already
set to supported.

The drivers which rely on the static controller mode are then updated
to check the return value of can_set_static_ctrlmode().

Link: https://lore.kernel.org/all/20211213160226.56219-3-mailhol.vincent@wanadoo.fr
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can.c     | 10 +++++++---
 drivers/net/can/rcar/rcar_canfd.c |  4 +++-
 include/linux/can/dev.h           | 11 +++++++++--
 3 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index ae2349420983..5b47cd867783 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1456,7 +1456,7 @@ static bool m_can_niso_supported(struct m_can_classdev *cdev)
 static int m_can_dev_setup(struct m_can_classdev *cdev)
 {
 	struct net_device *dev = cdev->net;
-	int m_can_version;
+	int m_can_version, err;
 
 	m_can_version = m_can_check_core_release(cdev);
 	/* return if unsupported version */
@@ -1486,7 +1486,9 @@ static int m_can_dev_setup(struct m_can_classdev *cdev)
 	switch (cdev->version) {
 	case 30:
 		/* CAN_CTRLMODE_FD_NON_ISO is fixed with M_CAN IP v3.0.x */
-		can_set_static_ctrlmode(dev, CAN_CTRLMODE_FD_NON_ISO);
+		err = can_set_static_ctrlmode(dev, CAN_CTRLMODE_FD_NON_ISO);
+		if (err)
+			return err;
 		cdev->can.bittiming_const = cdev->bit_timing ?
 			cdev->bit_timing : &m_can_bittiming_const_30X;
 
@@ -1496,7 +1498,9 @@ static int m_can_dev_setup(struct m_can_classdev *cdev)
 		break;
 	case 31:
 		/* CAN_CTRLMODE_FD_NON_ISO is fixed with M_CAN IP v3.1.x */
-		can_set_static_ctrlmode(dev, CAN_CTRLMODE_FD_NON_ISO);
+		err = can_set_static_ctrlmode(dev, CAN_CTRLMODE_FD_NON_ISO);
+		if (err)
+			return err;
 		cdev->can.bittiming_const = cdev->bit_timing ?
 			cdev->bit_timing : &m_can_bittiming_const_31X;
 
diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index d0e795f60338..82cc71d5ee10 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1699,7 +1699,9 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
 			&rcar_canfd_data_bittiming_const;
 
 		/* Controller starts in CAN FD only mode */
-		can_set_static_ctrlmode(ndev, CAN_CTRLMODE_FD);
+		err = can_set_static_ctrlmode(ndev, CAN_CTRLMODE_FD);
+		if (err)
+			goto fail;
 		priv->can.ctrlmode_supported = CAN_CTRLMODE_BERR_REPORTING;
 	} else {
 		/* Controller starts in Classical CAN only mode */
diff --git a/include/linux/can/dev.h b/include/linux/can/dev.h
index 92e2d69462f0..fff3f70df697 100644
--- a/include/linux/can/dev.h
+++ b/include/linux/can/dev.h
@@ -131,17 +131,24 @@ static inline s32 can_get_relative_tdco(const struct can_priv *priv)
 }
 
 /* helper to define static CAN controller features at device creation time */
-static inline void can_set_static_ctrlmode(struct net_device *dev,
-					   u32 static_mode)
+static inline int __must_check can_set_static_ctrlmode(struct net_device *dev,
+						       u32 static_mode)
 {
 	struct can_priv *priv = netdev_priv(dev);
 
 	/* alloc_candev() succeeded => netdev_priv() is valid at this point */
+	if (priv->ctrlmode_supported & static_mode) {
+		netdev_warn(dev,
+			    "Controller features can not be supported and static at the same time\n");
+		return -EINVAL;
+	}
 	priv->ctrlmode = static_mode;
 
 	/* override MTU which was set by default in can_setup()? */
 	if (static_mode & CAN_CTRLMODE_FD)
 		dev->mtu = CANFD_MTU;
+
+	return 0;
 }
 
 static inline u32 can_get_static_ctrlmode(struct can_priv *priv)
-- 
2.34.1


