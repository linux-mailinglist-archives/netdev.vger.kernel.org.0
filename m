Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 278F8F2953
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 09:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733251AbfKGIkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 03:40:10 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:44143 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727563AbfKGIkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 03:40:10 -0500
Received: from mwalle01.sab.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 6D0CA23E3F;
        Thu,  7 Nov 2019 09:40:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc;
        s=mail2016061301; t=1573116008;
        bh=5cph/SLyE8KvobjPOBoizhynJ/npZwYxmZXosnmxrNc=;
        h=From:To:Cc:Subject:Date:From;
        b=lDt/eDrOH97tcR+0hC0TlrlnE/tje9eZrtyTZEQ/welHB4FZtUxy7FQnKs+NB72hG
         YbCGMj/WC6OEMWsC7we0VzyjSmVNqVGEA/3be5sqqvjMuSmIz3mh+QH6qoLWchyeG1
         9h9vKTd14qKKr7kDkiU7Bj9+U4Av+vuFvJ2WMrX0=
From:   Michael Walle <michael@walle.cc>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH] enetc: ethtool: add wake-on-lan callbacks
Date:   Thu,  7 Nov 2019 09:40:00 +0100
Message-Id: <20191107084000.18375-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.101.4 at web
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If there is an external PHY, pass the wake-on-lan request to the PHY.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 .../ethernet/freescale/enetc/enetc_ethtool.c  | 27 +++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index fcb52efec075..880a8ed8bb47 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -584,6 +584,31 @@ static int enetc_get_ts_info(struct net_device *ndev,
 	return 0;
 }
 
+static void enetc_get_wol(struct net_device *dev,
+			  struct ethtool_wolinfo *wol)
+{
+	wol->supported = 0;
+	wol->wolopts = 0;
+
+	if (dev->phydev)
+		phy_ethtool_get_wol(dev->phydev, wol);
+}
+
+static int enetc_set_wol(struct net_device *dev,
+			 struct ethtool_wolinfo *wol)
+{
+	int ret;
+
+	if (!dev->phydev)
+		return -EOPNOTSUPP;
+
+	ret = phy_ethtool_set_wol(dev->phydev, wol);
+	if (!ret)
+		device_set_wakeup_enable(&dev->dev, wol->wolopts);
+
+	return ret;
+}
+
 static const struct ethtool_ops enetc_pf_ethtool_ops = {
 	.get_regs_len = enetc_get_reglen,
 	.get_regs = enetc_get_regs,
@@ -601,6 +626,8 @@ static const struct ethtool_ops enetc_pf_ethtool_ops = {
 	.set_link_ksettings = phy_ethtool_set_link_ksettings,
 	.get_link = ethtool_op_get_link,
 	.get_ts_info = enetc_get_ts_info,
+	.get_wol = enetc_get_wol,
+	.set_wol = enetc_set_wol,
 };
 
 static const struct ethtool_ops enetc_vf_ethtool_ops = {
-- 
2.20.1

