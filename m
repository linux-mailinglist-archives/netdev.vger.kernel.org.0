Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA5D439D7F
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 19:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233778AbhJYR0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 13:26:05 -0400
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:56554 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233989AbhJYRZy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 13:25:54 -0400
Received: from tomoyo.flets-east.jp ([114.149.34.46])
        by smtp.orange.fr with ESMTPA
        id f3gYmY0E4niuxf3h3mufGm; Mon, 25 Oct 2021 19:23:31 +0200
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: MDU0YmViZGZmMDIzYiBlMiM2NTczNTRjNWZkZTMwOGRiOGQ4ODf3NWI1ZTMyMzdiODlhOQ==
X-ME-Date: Mon, 25 Oct 2021 19:23:31 +0200
X-ME-IP: 114.149.34.46
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v3 2/4] can: dev: add sanity check in can_set_static_ctrlmode()
Date:   Tue, 26 Oct 2021 02:22:45 +0900
Message-Id: <20211025172247.1774451-3-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211025172247.1774451-1-mailhol.vincent@wanadoo.fr>
References: <20211025172247.1774451-1-mailhol.vincent@wanadoo.fr>
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
---
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
index 2470c47b2e31..ab4371aa4ff1 100644
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
@@ -1493,13 +1493,17 @@ static int m_can_dev_setup(struct m_can_classdev *cdev)
 	switch (cdev->version) {
 	case 30:
 		/* CAN_CTRLMODE_FD_NON_ISO is fixed with M_CAN IP v3.0.x */
-		can_set_static_ctrlmode(dev, CAN_CTRLMODE_FD_NON_ISO);
+		err = can_set_static_ctrlmode(dev, CAN_CTRLMODE_FD_NON_ISO);
+		if (err)
+			return err;
 		cdev->can.bittiming_const = &m_can_bittiming_const_30X;
 		cdev->can.data_bittiming_const = &m_can_data_bittiming_const_30X;
 		break;
 	case 31:
 		/* CAN_CTRLMODE_FD_NON_ISO is fixed with M_CAN IP v3.1.x */
-		can_set_static_ctrlmode(dev, CAN_CTRLMODE_FD_NON_ISO);
+		err = can_set_static_ctrlmode(dev, CAN_CTRLMODE_FD_NON_ISO);
+		if (err)
+			return err;
 		cdev->can.bittiming_const = &m_can_bittiming_const_31X;
 		cdev->can.data_bittiming_const = &m_can_data_bittiming_const_31X;
 		break;
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

