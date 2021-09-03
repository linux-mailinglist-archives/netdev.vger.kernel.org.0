Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06E163FFAED
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 09:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347707AbhICHT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 03:19:26 -0400
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:50216 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347712AbhICHTZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 03:19:25 -0400
Received: from tomoyo.flets-east.jp ([114.149.34.46])
        by mwinf5d86 with ME
        id pKJC2500b0zjR6y03KJMe4; Fri, 03 Sep 2021 09:18:24 +0200
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Fri, 03 Sep 2021 09:18:24 +0200
X-ME-IP: 114.149.34.46
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [RESEND PATCH v2] can: netlink: prevent incoherent can configuration in case of early return
Date:   Fri,  3 Sep 2021 16:17:04 +0900
Message-Id: <20210903071704.455855-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct can_priv has a set of flags (can_priv::ctrlmode) which are
correlated with the other fields of the structure. In
can_changelink(), those flags are set first and copied to can_priv. If
the function has to return early, for example due to an out of range
value provided by the user, then the global configuration might become
incoherent.

Example: the user provides an out of range dbitrate (e.g. 20
Mbps). The command fails (-EINVAL), however the FD flag was already
set resulting in a configuration where FD is on but the databittiming
parameters are empty.

* Illustration of above example *

| $ ip link set can0 type can bitrate 500000 dbitrate 20000000 fd on
| RTNETLINK answers: Invalid argument
| $ ip --details link show can0
| 1: can0: <NOARP,ECHO> mtu 72 qdisc noop state DOWN mode DEFAULT group default qlen 10
|     link/can  promiscuity 0 minmtu 0 maxmtu 0
|     can <FD> state STOPPED restart-ms 0
           ^^ FD flag is set without any of the databittiming parameters...
| 	  bitrate 500000 sample-point 0.875
| 	  tq 12 prop-seg 69 phase-seg1 70 phase-seg2 20 sjw 1
| 	  ES582.1/ES584.1: tseg1 2..256 tseg2 2..128 sjw 1..128 brp 1..512 brp-inc 1
| 	  ES582.1/ES584.1: dtseg1 2..32 dtseg2 1..16 dsjw 1..8 dbrp 1..32 dbrp-inc 1
| 	  clock 80000000 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535

To prevent this from happening, we do a local copy of can_priv, work
on it, an copy it at the very end of the function (i.e. only if all
previous checks succeeded).

Once this done, there is no more need to have a temporary variable for
a specific parameter. As such, the bittiming and data bittiming (bt
and dbt) are directly written to the temporary priv variable.

Finally, function can_calc_tdco() was retrieving can_priv from the
net_device and directly modifying it. We changed the prototype so that
it instead writes its changes into our temporary priv variable.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
Resending because I got no answers on:
https://lore.kernel.org/linux-can/20210823024750.702542-1-mailhol.vincent@wanadoo.fr/T/#u
(I guess everyone bas busy with the upcoming merge window)

I am not sure whether or not this needs a "Fixes" tag. Just in case,
there it is:

Fixes: 9859ccd2c8be ("can: introduce the data bitrate configuration for CAN FD")

* Changelog *

v1 -> v2:
  - Change the prototype of can_calc_tdco() so that the changes are
    applied to the temporary priv instead of netdev_priv(dev).
---
 drivers/net/can/dev/bittiming.c |  8 +--
 drivers/net/can/dev/netlink.c   | 88 +++++++++++++++++----------------
 include/linux/can/bittiming.h   |  7 ++-
 3 files changed, 53 insertions(+), 50 deletions(-)

diff --git a/drivers/net/can/dev/bittiming.c b/drivers/net/can/dev/bittiming.c
index f49170eadd54..bddd93e2e439 100644
--- a/drivers/net/can/dev/bittiming.c
+++ b/drivers/net/can/dev/bittiming.c
@@ -175,13 +175,9 @@ int can_calc_bittiming(struct net_device *dev, struct can_bittiming *bt,
 	return 0;
 }
 
-void can_calc_tdco(struct net_device *dev)
+void can_calc_tdco(struct can_tdc *tdc, const struct can_tdc_const *tdc_const,
+		   const struct can_bittiming *dbt)
 {
-	struct can_priv *priv = netdev_priv(dev);
-	const struct can_bittiming *dbt = &priv->data_bittiming;
-	struct can_tdc *tdc = &priv->tdc;
-	const struct can_tdc_const *tdc_const = priv->tdc_const;
-
 	if (!tdc_const)
 		return;
 
diff --git a/drivers/net/can/dev/netlink.c b/drivers/net/can/dev/netlink.c
index 80425636049d..50dfed462711 100644
--- a/drivers/net/can/dev/netlink.c
+++ b/drivers/net/can/dev/netlink.c
@@ -58,14 +58,20 @@ static int can_changelink(struct net_device *dev, struct nlattr *tb[],
 			  struct nlattr *data[],
 			  struct netlink_ext_ack *extack)
 {
-	struct can_priv *priv = netdev_priv(dev);
+	/* Work on a local copy of priv to prevent inconsistent value
+	 * in case of early return. net/core/rtnetlink.c has a global
+	 * mutex so using a static declaration is race free
+	 */
+	static struct can_priv priv;
 	int err;
 
 	/* We need synchronization with dev->stop() */
 	ASSERT_RTNL();
 
+	memcpy(&priv, netdev_priv(dev), sizeof(priv));
+
 	if (data[IFLA_CAN_BITTIMING]) {
-		struct can_bittiming bt;
+		struct can_bittiming *bt = &priv.bittiming;
 
 		/* Do not allow changing bittiming while running */
 		if (dev->flags & IFF_UP)
@@ -76,28 +82,26 @@ static int can_changelink(struct net_device *dev, struct nlattr *tb[],
 		 * directly via do_set_bitrate(). Bail out if neither
 		 * is given.
 		 */
-		if (!priv->bittiming_const && !priv->do_set_bittiming)
+		if (!priv.bittiming_const && !priv.do_set_bittiming)
 			return -EOPNOTSUPP;
 
-		memcpy(&bt, nla_data(data[IFLA_CAN_BITTIMING]), sizeof(bt));
-		err = can_get_bittiming(dev, &bt,
-					priv->bittiming_const,
-					priv->bitrate_const,
-					priv->bitrate_const_cnt);
+		memcpy(bt, nla_data(data[IFLA_CAN_BITTIMING]), sizeof(*bt));
+		err = can_get_bittiming(dev, bt,
+					priv.bittiming_const,
+					priv.bitrate_const,
+					priv.bitrate_const_cnt);
 		if (err)
 			return err;
 
-		if (priv->bitrate_max && bt.bitrate > priv->bitrate_max) {
+		if (priv.bitrate_max && bt->bitrate > priv.bitrate_max) {
 			netdev_err(dev, "arbitration bitrate surpasses transceiver capabilities of %d bps\n",
-				   priv->bitrate_max);
+				   priv.bitrate_max);
 			return -EINVAL;
 		}
 
-		memcpy(&priv->bittiming, &bt, sizeof(bt));
-
-		if (priv->do_set_bittiming) {
+		if (priv.do_set_bittiming) {
 			/* Finally, set the bit-timing registers */
-			err = priv->do_set_bittiming(dev);
+			err = priv.do_set_bittiming(dev);
 			if (err)
 				return err;
 		}
@@ -112,11 +116,11 @@ static int can_changelink(struct net_device *dev, struct nlattr *tb[],
 		if (dev->flags & IFF_UP)
 			return -EBUSY;
 		cm = nla_data(data[IFLA_CAN_CTRLMODE]);
-		ctrlstatic = priv->ctrlmode_static;
+		ctrlstatic = priv.ctrlmode_static;
 		maskedflags = cm->flags & cm->mask;
 
 		/* check whether provided bits are allowed to be passed */
-		if (maskedflags & ~(priv->ctrlmode_supported | ctrlstatic))
+		if (maskedflags & ~(priv.ctrlmode_supported | ctrlstatic))
 			return -EOPNOTSUPP;
 
 		/* do not check for static fd-non-iso if 'fd' is disabled */
@@ -128,16 +132,16 @@ static int can_changelink(struct net_device *dev, struct nlattr *tb[],
 			return -EOPNOTSUPP;
 
 		/* clear bits to be modified and copy the flag values */
-		priv->ctrlmode &= ~cm->mask;
-		priv->ctrlmode |= maskedflags;
+		priv.ctrlmode &= ~cm->mask;
+		priv.ctrlmode |= maskedflags;
 
 		/* CAN_CTRLMODE_FD can only be set when driver supports FD */
-		if (priv->ctrlmode & CAN_CTRLMODE_FD) {
+		if (priv.ctrlmode & CAN_CTRLMODE_FD) {
 			dev->mtu = CANFD_MTU;
 		} else {
 			dev->mtu = CAN_MTU;
-			memset(&priv->data_bittiming, 0,
-			       sizeof(priv->data_bittiming));
+			memset(&priv.data_bittiming, 0,
+			       sizeof(priv.data_bittiming));
 		}
 	}
 
@@ -145,7 +149,7 @@ static int can_changelink(struct net_device *dev, struct nlattr *tb[],
 		/* Do not allow changing restart delay while running */
 		if (dev->flags & IFF_UP)
 			return -EBUSY;
-		priv->restart_ms = nla_get_u32(data[IFLA_CAN_RESTART_MS]);
+		priv.restart_ms = nla_get_u32(data[IFLA_CAN_RESTART_MS]);
 	}
 
 	if (data[IFLA_CAN_RESTART]) {
@@ -158,7 +162,7 @@ static int can_changelink(struct net_device *dev, struct nlattr *tb[],
 	}
 
 	if (data[IFLA_CAN_DATA_BITTIMING]) {
-		struct can_bittiming dbt;
+		struct can_bittiming *dbt = &priv.data_bittiming;
 
 		/* Do not allow changing bittiming while running */
 		if (dev->flags & IFF_UP)
@@ -169,31 +173,29 @@ static int can_changelink(struct net_device *dev, struct nlattr *tb[],
 		 * directly via do_set_bitrate(). Bail out if neither
 		 * is given.
 		 */
-		if (!priv->data_bittiming_const && !priv->do_set_data_bittiming)
+		if (!priv.data_bittiming_const && !priv.do_set_data_bittiming)
 			return -EOPNOTSUPP;
 
-		memcpy(&dbt, nla_data(data[IFLA_CAN_DATA_BITTIMING]),
-		       sizeof(dbt));
-		err = can_get_bittiming(dev, &dbt,
-					priv->data_bittiming_const,
-					priv->data_bitrate_const,
-					priv->data_bitrate_const_cnt);
+		memcpy(dbt, nla_data(data[IFLA_CAN_DATA_BITTIMING]),
+		       sizeof(*dbt));
+		err = can_get_bittiming(dev, dbt,
+					priv.data_bittiming_const,
+					priv.data_bitrate_const,
+					priv.data_bitrate_const_cnt);
 		if (err)
 			return err;
 
-		if (priv->bitrate_max && dbt.bitrate > priv->bitrate_max) {
+		if (priv.bitrate_max && dbt->bitrate > priv.bitrate_max) {
 			netdev_err(dev, "canfd data bitrate surpasses transceiver capabilities of %d bps\n",
-				   priv->bitrate_max);
+				   priv.bitrate_max);
 			return -EINVAL;
 		}
 
-		memcpy(&priv->data_bittiming, &dbt, sizeof(dbt));
-
-		can_calc_tdco(dev);
+		can_calc_tdco(&priv.tdc, priv.tdc_const, &priv.data_bittiming);
 
-		if (priv->do_set_data_bittiming) {
+		if (priv.do_set_data_bittiming) {
 			/* Finally, set the bit-timing registers */
-			err = priv->do_set_data_bittiming(dev);
+			err = priv.do_set_data_bittiming(dev);
 			if (err)
 				return err;
 		}
@@ -201,28 +203,30 @@ static int can_changelink(struct net_device *dev, struct nlattr *tb[],
 
 	if (data[IFLA_CAN_TERMINATION]) {
 		const u16 termval = nla_get_u16(data[IFLA_CAN_TERMINATION]);
-		const unsigned int num_term = priv->termination_const_cnt;
+		const unsigned int num_term = priv.termination_const_cnt;
 		unsigned int i;
 
-		if (!priv->do_set_termination)
+		if (!priv.do_set_termination)
 			return -EOPNOTSUPP;
 
 		/* check whether given value is supported by the interface */
 		for (i = 0; i < num_term; i++) {
-			if (termval == priv->termination_const[i])
+			if (termval == priv.termination_const[i])
 				break;
 		}
 		if (i >= num_term)
 			return -EINVAL;
 
 		/* Finally, set the termination value */
-		err = priv->do_set_termination(dev, termval);
+		err = priv.do_set_termination(dev, termval);
 		if (err)
 			return err;
 
-		priv->termination = termval;
+		priv.termination = termval;
 	}
 
+	memcpy(netdev_priv(dev), &priv, sizeof(priv));
+
 	return 0;
 }
 
diff --git a/include/linux/can/bittiming.h b/include/linux/can/bittiming.h
index 9de6e9053e34..b3c1711ee0f0 100644
--- a/include/linux/can/bittiming.h
+++ b/include/linux/can/bittiming.h
@@ -87,7 +87,8 @@ struct can_tdc_const {
 int can_calc_bittiming(struct net_device *dev, struct can_bittiming *bt,
 		       const struct can_bittiming_const *btc);
 
-void can_calc_tdco(struct net_device *dev);
+void can_calc_tdco(struct can_tdc *tdc, const struct can_tdc_const *tdc_const,
+		   const struct can_bittiming *dbt);
 #else /* !CONFIG_CAN_CALC_BITTIMING */
 static inline int
 can_calc_bittiming(struct net_device *dev, struct can_bittiming *bt,
@@ -97,7 +98,9 @@ can_calc_bittiming(struct net_device *dev, struct can_bittiming *bt,
 	return -EINVAL;
 }
 
-static inline void can_calc_tdco(struct net_device *dev)
+static inline void
+can_calc_tdco(struct can_tdc *tdc, const struct can_tdc_const *tdc_const,
+	      const struct can_bittiming *dbt)
 {
 }
 #endif /* CONFIG_CAN_CALC_BITTIMING */
-- 
2.31.1

