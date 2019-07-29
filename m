Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A114379073
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 18:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728898AbfG2QMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 12:12:21 -0400
Received: from inva020.nxp.com ([92.121.34.13]:37792 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728871AbfG2QMU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 12:12:20 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 10EAB1A0375;
        Mon, 29 Jul 2019 18:12:18 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 01DE91A0374;
        Mon, 29 Jul 2019 18:12:18 +0200 (CEST)
Received: from fsr-ub1464-137.ea.freescale.net (fsr-ub1464-137.ea.freescale.net [10.171.82.114])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 9A1F2205F3;
        Mon, 29 Jul 2019 18:12:17 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        f.fainelli@gmail.com, jiri@mellanox.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH 2/5] staging: fsl-dpaa2/ethsw: notify switchdev of offloaded entry
Date:   Mon, 29 Jul 2019 19:11:49 +0300
Message-Id: <1564416712-16946-3-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1564416712-16946-1-git-send-email-ioana.ciornei@nxp.com>
References: <1564416712-16946-1-git-send-email-ioana.ciornei@nxp.com>
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Notify switchdev in case the FDB entry was successfully offloaded.
This will help users to make the distinction between entries known to
the HW switch and those that are held only on the software bridge.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
index 341c36b3a76d..d6953ac427b1 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
@@ -1039,6 +1039,7 @@ static void ethsw_switchdev_event_work(struct work_struct *work)
 		container_of(work, struct ethsw_switchdev_event_work, work);
 	struct net_device *dev = switchdev_work->dev;
 	struct switchdev_notifier_fdb_info *fdb_info;
+	int err;
 
 	rtnl_lock();
 	fdb_info = &switchdev_work->fdb_info;
@@ -1046,9 +1047,16 @@ static void ethsw_switchdev_event_work(struct work_struct *work)
 	switch (switchdev_work->event) {
 	case SWITCHDEV_FDB_ADD_TO_DEVICE:
 		if (is_unicast_ether_addr(fdb_info->addr))
-			ethsw_port_fdb_add_uc(netdev_priv(dev), fdb_info->addr);
+			err = ethsw_port_fdb_add_uc(netdev_priv(dev),
+						    fdb_info->addr);
 		else
-			ethsw_port_fdb_add_mc(netdev_priv(dev), fdb_info->addr);
+			err = ethsw_port_fdb_add_mc(netdev_priv(dev),
+						    fdb_info->addr);
+		if (err)
+			break;
+		fdb_info->offloaded = true;
+		call_switchdev_notifiers(SWITCHDEV_FDB_OFFLOADED, dev,
+					 &fdb_info->info, NULL);
 		break;
 	case SWITCHDEV_FDB_DEL_TO_DEVICE:
 		if (is_unicast_ether_addr(fdb_info->addr))
-- 
1.9.1

