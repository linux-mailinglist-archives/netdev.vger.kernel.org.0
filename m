Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAD40473120
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 17:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240415AbhLMQDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 11:03:02 -0500
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:61122 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240389AbhLMQC5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 11:02:57 -0500
Received: from localhost.localdomain ([106.133.22.31])
        by smtp.orange.fr with ESMTPA
        id wnmbm1mzFk3HQwnmvmkNcu; Mon, 13 Dec 2021 17:02:56 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: MDU0YmViZGZmMDIzYiBlMiM2NTczNTRjNWZkZTMwOGRiOGQ4ODf3NWI1ZTMyMzdiODlhOQ==
X-ME-Date: Mon, 13 Dec 2021 17:02:56 +0100
X-ME-IP: 106.133.22.31
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v6 2/4] can: dev: add sanity check in can_set_static_ctrlmode()
Date:   Tue, 14 Dec 2021 01:02:24 +0900
Message-Id: <20211213160226.56219-3-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211213160226.56219-1-mailhol.vincent@wanadoo.fr>
References: <20211213160226.56219-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
--

Some few comments on how the rcar_canfd and m_can drivers free their
allocated resources when an error occurs during probing.

The function rcar_canfd_channel_probe() is quite inconsistent with the
way it handles errors. After the call to alloc_candev, there are
several "goto fail" statements that would directly exit without
calling free_candev()!

Nonetheless, later on the driver will check the return value of
rcar_canfd_channel_probe() and call rcar_canfd_channel_remove() which
will correctly call free_candev(). Even if this is inconsistent, there
is no sign of a memory leak. So I just applied the change the
can_set_static_ctrlmode() without bothering more (N.B. I do not own
that device so I am not willing to take the risk of making bigger
changes because I can not test).

On the other hand, m_can_dev_setup() is fine: the return value is
checked by the caller and necessary actions are taken.

As such, for both driver, we did a minimal change.
---
 drivers/net/can/m_can/m_can.c     | 10 +++++++---
 drivers/net/can/rcar/rcar_canfd.c |  4 +++-
 include/linux/can/dev.h           | 11 +++++++++--
 3 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index c2a8421e7845..56af9ea4694f 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1463,7 +1463,7 @@ static bool m_can_niso_supported(struct m_can_classdev *cdev)
 static int m_can_dev_setup(struct m_can_classdev *cdev)
 {
 	struct net_device *dev = cdev->net;
-	int m_can_version;
+	int m_can_version, err;
 
 	m_can_version = m_can_check_core_release(cdev);
 	/* return if unsupported version */
@@ -1493,7 +1493,9 @@ static int m_can_dev_setup(struct m_can_classdev *cdev)
 	switch (cdev->version) {
 	case 30:
 		/* CAN_CTRLMODE_FD_NON_ISO is fixed with M_CAN IP v3.0.x */
-		can_set_static_ctrlmode(dev, CAN_CTRLMODE_FD_NON_ISO);
+		err = can_set_static_ctrlmode(dev, CAN_CTRLMODE_FD_NON_ISO);
+		if (err)
+			return err;
 		cdev->can.bittiming_const = cdev->bit_timing ?
 			cdev->bit_timing : &m_can_bittiming_const_30X;
 
@@ -1503,7 +1505,9 @@ static int m_can_dev_setup(struct m_can_classdev *cdev)
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
index ff9d0f5ae0dd..e225c1c03812 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1706,7 +1706,9 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
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
2.32.0

