Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2B0D3D5B24
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 16:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234757AbhGZNcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 09:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234637AbhGZNby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 09:31:54 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB4EC06179F
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 07:12:11 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m81Kz-0001CQ-Kb
        for netdev@vger.kernel.org; Mon, 26 Jul 2021 16:12:09 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id AB24A6581D9
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 14:11:58 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 1D223658173;
        Mon, 26 Jul 2021 14:11:48 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id e08b5e1f;
        Mon, 26 Jul 2021 14:11:45 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 11/46] can: netlink: clear data_bittiming if FD is turned off
Date:   Mon, 26 Jul 2021 16:11:09 +0200
Message-Id: <20210726141144.862529-12-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210726141144.862529-1-mkl@pengutronix.de>
References: <20210726141144.862529-1-mkl@pengutronix.de>
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

When the FD is turned off through the netlink interface, the data bit
timing values still remain in data_bittiming and are displayed despite
of the feature being disabled.

Example:

| $ ip link set can0 type can bitrate 500000 dbitrate 2000000 fd on
| $ ip --details link show can0
| 1:  can0: <NOARP,ECHO> mtu 72 qdisc pfifo_fast state DOWN mode DEFAULT group default qlen 10
|     link/can  promiscuity 0 minmtu 0 maxmtu 0
|     can <FD> state STOPPED restart-ms 0
| 	  bitrate 500000 sample-point 0.875
| 	  tq 12 prop-seg 69 phase-seg1 70 phase-seg2 20 sjw 1
| 	  ES582.1/ES584.1: tseg1 2..256 tseg2 2..128 sjw 1..128 brp 1..512 brp-inc 1
| 	  dbitrate 2000000 dsample-point 0.750
| 	  dtq 12 dprop-seg 14 dphase-seg1 15 dphase-seg2 10 dsjw 1
| 	  ES582.1/ES584.1: dtseg1 2..32 dtseg2 1..16 dsjw 1..8 dbrp 1..32 dbrp-inc 1
| 	  clock 80000000 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
|
| $ ip link set can0 type can bitrate 500000 fd off
| $ ip --details link show can0
| 1:  can0: <NOARP,ECHO> mtu 16 qdisc pfifo_fast state DOWN mode DEFAULT group default qlen 10
|     link/can  promiscuity 0 minmtu 0 maxmtu 0
|     can state STOPPED restart-ms 0
| 	  bitrate 500000 sample-point 0.875
| 	  tq 12 prop-seg 69 phase-seg1 70 phase-seg2 20 sjw 1
| 	  ES582.1/ES584.1: tseg1 2..256 tseg2 2..128 sjw 1..128 brp 1..512 brp-inc 1
| 	  dbitrate 2000000 dsample-point 0.750
| 	  dtq 12 dprop-seg 14 dphase-seg1 15 dphase-seg2 10 dsjw 1
| 	  ES582.1/ES584.1: dtseg1 2..32 dtseg2 1..16 dsjw 1..8 dbrp 1..32 dbrp-inc 1
| 	  clock 80000000 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535

Remark: once FD is turned off, it is not possible to turn fd back on
and reuse the previously input data bit timing values:

| $ ip link set can0 type can bitrate 500000 fd on
| RTNETLINK answers: Operation not supported

This means that the user will need to re-configure the data bit timing
in order to turn fd on again.

Because old data bit timing values cannot be reused, this patch clears
priv->data_bit timing whenever FD is turned off. This way, the data
bit timing variables are not displayed anymore.

Link: https://lore.kernel.org/r/20210618081904.141114-2-mailhol.vincent@wanadoo.fr
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/dev/netlink.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/dev/netlink.c b/drivers/net/can/dev/netlink.c
index e38c2566aff4..b567fd628c17 100644
--- a/drivers/net/can/dev/netlink.c
+++ b/drivers/net/can/dev/netlink.c
@@ -132,10 +132,13 @@ static int can_changelink(struct net_device *dev, struct nlattr *tb[],
 		priv->ctrlmode |= maskedflags;
 
 		/* CAN_CTRLMODE_FD can only be set when driver supports FD */
-		if (priv->ctrlmode & CAN_CTRLMODE_FD)
+		if (priv->ctrlmode & CAN_CTRLMODE_FD) {
 			dev->mtu = CANFD_MTU;
-		else
+		} else {
 			dev->mtu = CAN_MTU;
+			memset(&priv->data_bittiming, 0,
+			       sizeof(priv->data_bittiming));
+		}
 	}
 
 	if (data[IFLA_CAN_RESTART_MS]) {
-- 
2.30.2


