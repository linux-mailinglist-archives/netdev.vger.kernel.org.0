Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34EEF401E03
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 18:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243830AbhIFQEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 12:04:55 -0400
Received: from smtp13.smtpout.orange.fr ([80.12.242.135]:42825 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S243806AbhIFQEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Sep 2021 12:04:54 -0400
Received: from localhost.localdomain ([114.149.34.46])
        by mwinf5d79 with ME
        id qg3U2500Z0zjR6y03g3m5h; Mon, 06 Sep 2021 18:03:48 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Mon, 06 Sep 2021 18:03:48 +0200
X-ME-IP: 114.149.34.46
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v3 1/2] can: netlink: prevent incoherent can configuration in case of early return
Date:   Tue,  7 Sep 2021 01:03:09 +0900
Message-Id: <20210906160310.54831-2-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210906160310.54831-1-mailhol.vincent@wanadoo.fr>
References: <20210906160310.54831-1-mailhol.vincent@wanadoo.fr>
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


N.B. The temporary can_priv is too big to be allocated on the stack
because, on x86_64 sizeof(struct can_priv) is 448 and:

| $ objdump -d drivers/net/can/dev/netlink.o | ./scripts/checkstack.pl
| 0x00000000000002100 can_changelink []:            1200


Fixes: 9859ccd2c8be ("can: introduce the data bitrate configuration for CAN FD")
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/can/dev/netlink.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/net/can/dev/netlink.c b/drivers/net/can/dev/netlink.c
index 80425636049d..21b76ca8cb22 100644
--- a/drivers/net/can/dev/netlink.c
+++ b/drivers/net/can/dev/netlink.c
@@ -58,14 +58,19 @@ static int can_changelink(struct net_device *dev, struct nlattr *tb[],
 			  struct nlattr *data[],
 			  struct netlink_ext_ack *extack)
 {
-	struct can_priv *priv = netdev_priv(dev);
+	/* Work on a local copy of priv to prevent inconsistent value
+	 * in case of early return.
+	 */
+	static struct can_priv *priv;
 	int err;
 
 	/* We need synchronization with dev->stop() */
 	ASSERT_RTNL();
 
+	priv = kmemdup(netdev_priv(dev), sizeof(*priv), GFP_KERNEL);
+
 	if (data[IFLA_CAN_BITTIMING]) {
-		struct can_bittiming bt;
+		struct can_bittiming *bt = &priv->bittiming;
 
 		/* Do not allow changing bittiming while running */
 		if (dev->flags & IFF_UP)
@@ -79,22 +84,20 @@ static int can_changelink(struct net_device *dev, struct nlattr *tb[],
 		if (!priv->bittiming_const && !priv->do_set_bittiming)
 			return -EOPNOTSUPP;
 
-		memcpy(&bt, nla_data(data[IFLA_CAN_BITTIMING]), sizeof(bt));
-		err = can_get_bittiming(dev, &bt,
+		memcpy(bt, nla_data(data[IFLA_CAN_BITTIMING]), sizeof(*bt));
+		err = can_get_bittiming(dev, bt,
 					priv->bittiming_const,
 					priv->bitrate_const,
 					priv->bitrate_const_cnt);
 		if (err)
 			return err;
 
-		if (priv->bitrate_max && bt.bitrate > priv->bitrate_max) {
+		if (priv->bitrate_max && bt->bitrate > priv->bitrate_max) {
 			netdev_err(dev, "arbitration bitrate surpasses transceiver capabilities of %d bps\n",
 				   priv->bitrate_max);
 			return -EINVAL;
 		}
 
-		memcpy(&priv->bittiming, &bt, sizeof(bt));
-
 		if (priv->do_set_bittiming) {
 			/* Finally, set the bit-timing registers */
 			err = priv->do_set_bittiming(dev);
@@ -158,7 +161,7 @@ static int can_changelink(struct net_device *dev, struct nlattr *tb[],
 	}
 
 	if (data[IFLA_CAN_DATA_BITTIMING]) {
-		struct can_bittiming dbt;
+		struct can_bittiming *dbt = &priv->data_bittiming;
 
 		/* Do not allow changing bittiming while running */
 		if (dev->flags & IFF_UP)
@@ -172,23 +175,21 @@ static int can_changelink(struct net_device *dev, struct nlattr *tb[],
 		if (!priv->data_bittiming_const && !priv->do_set_data_bittiming)
 			return -EOPNOTSUPP;
 
-		memcpy(&dbt, nla_data(data[IFLA_CAN_DATA_BITTIMING]),
-		       sizeof(dbt));
-		err = can_get_bittiming(dev, &dbt,
+		memcpy(dbt, nla_data(data[IFLA_CAN_DATA_BITTIMING]),
+		       sizeof(*dbt));
+		err = can_get_bittiming(dev, dbt,
 					priv->data_bittiming_const,
 					priv->data_bitrate_const,
 					priv->data_bitrate_const_cnt);
 		if (err)
 			return err;
 
-		if (priv->bitrate_max && dbt.bitrate > priv->bitrate_max) {
+		if (priv->bitrate_max && dbt->bitrate > priv->bitrate_max) {
 			netdev_err(dev, "canfd data bitrate surpasses transceiver capabilities of %d bps\n",
 				   priv->bitrate_max);
 			return -EINVAL;
 		}
 
-		memcpy(&priv->data_bittiming, &dbt, sizeof(dbt));
-
 		can_calc_tdco(dev);
 
 		if (priv->do_set_data_bittiming) {
@@ -223,6 +224,9 @@ static int can_changelink(struct net_device *dev, struct nlattr *tb[],
 		priv->termination = termval;
 	}
 
+	memcpy(netdev_priv(dev), priv, sizeof(*priv));
+	kfree(priv);
+
 	return 0;
 }
 
-- 
2.32.0

