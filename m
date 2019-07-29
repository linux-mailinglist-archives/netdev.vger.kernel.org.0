Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54B1A7906E
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 18:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728931AbfG2QMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 12:12:25 -0400
Received: from inva021.nxp.com ([92.121.34.21]:40818 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728912AbfG2QMY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 12:12:24 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 4106720035B;
        Mon, 29 Jul 2019 18:12:22 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 33A41200344;
        Mon, 29 Jul 2019 18:12:22 +0200 (CEST)
Received: from fsr-ub1464-137.ea.freescale.net (fsr-ub1464-137.ea.freescale.net [10.171.82.114])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id C0DB0205F3;
        Mon, 29 Jul 2019 18:12:21 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        f.fainelli@gmail.com, jiri@mellanox.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH 5/5] staging: fsl-dpaa2/ethsw: add .ndo_fdb[add|del] callbacks
Date:   Mon, 29 Jul 2019 19:11:52 +0300
Message-Id: <1564416712-16946-6-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1564416712-16946-1-git-send-email-ioana.ciornei@nxp.com>
References: <1564416712-16946-1-git-send-email-ioana.ciornei@nxp.com>
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the .ndo_fdb_[add|del] callbacks so that FDB entries not associated
with a master device still end up offloaded.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
index 2d3179c6bad8..4b94a01513a7 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
@@ -316,6 +316,31 @@ static int ethsw_port_fdb_del_mc(struct ethsw_port_priv *port_priv,
 	return err;
 }
 
+static int port_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
+			struct net_device *dev, const unsigned char *addr,
+			u16 vid, u16 flags,
+			struct netlink_ext_ack *extack)
+{
+	if (is_unicast_ether_addr(addr))
+		return ethsw_port_fdb_add_uc(netdev_priv(dev),
+					     addr);
+	else
+		return ethsw_port_fdb_add_mc(netdev_priv(dev),
+					     addr);
+}
+
+static int port_fdb_del(struct ndmsg *ndm, struct nlattr *tb[],
+			struct net_device *dev,
+			const unsigned char *addr, u16 vid)
+{
+	if (is_unicast_ether_addr(addr))
+		return ethsw_port_fdb_del_uc(netdev_priv(dev),
+					     addr);
+	else
+		return ethsw_port_fdb_del_mc(netdev_priv(dev),
+					     addr);
+}
+
 static void port_get_stats(struct net_device *netdev,
 			   struct rtnl_link_stats64 *stats)
 {
@@ -670,6 +695,8 @@ static int port_fdb_dump(struct sk_buff *skb, struct netlink_callback *cb,
 	.ndo_change_mtu		= port_change_mtu,
 	.ndo_has_offload_stats	= port_has_offload_stats,
 	.ndo_get_offload_stats	= port_get_offload_stats,
+	.ndo_fdb_add		= port_fdb_add,
+	.ndo_fdb_del		= port_fdb_del,
 	.ndo_fdb_dump		= port_fdb_dump,
 
 	.ndo_start_xmit		= port_dropframe,
-- 
1.9.1

