Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 051A720B7F9
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 20:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbgFZSR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 14:17:26 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:48542 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbgFZSRZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 14:17:25 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 05QIHD2b002410;
        Fri, 26 Jun 2020 13:17:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1593195433;
        bh=ObJy3OzFPVwRVlL2NFhYDlEcbRHlojhYSa7S3qkOSMA=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=j8TuFR/J7tzCEu0fsyPp2wq/HN0wHLQnNXXmVz4Z4rzEmd8FmPpH09snDjiWzdMmB
         2VrqdaM3xLl22uds7bq9W0vdW8mRc5JVEN0k4/UT0aMhjNybpty7fBvJpdcYzlyjRO
         567AcqvOyKb1pg1z33X7iWeFrVr03rEHDE+ynf+c=
Received: from DLEE108.ent.ti.com (dlee108.ent.ti.com [157.170.170.38])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 05QIHDL0058613
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 26 Jun 2020 13:17:13 -0500
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 26
 Jun 2020 13:17:12 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 26 Jun 2020 13:17:12 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 05QIHBAA081457;
        Fri, 26 Jun 2020 13:17:12 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next 1/6] net: ethernet: ti: am65-cpsw-nuss: restore vlan configuration while down/up
Date:   Fri, 26 Jun 2020 21:17:04 +0300
Message-ID: <20200626181709.22635-2-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200626181709.22635-1-grygorii.strashko@ti.com>
References: <20200626181709.22635-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The vlan configuration is not restored after interface down/up sequence.

Steps to check:
 # ip link add link eth0 name eth0.100 type vlan id 100
 # ifconfig eth0 down
 # ifconfig eth0 up

This patch fixes it, restoring vlan ALE entries on .ndo_open().

Fixes: 93a76530316a ("net: ethernet: ti: introduce am65x/j721e gigabit eth subsystem driver")
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 1492648247d9..82d3b1f20890 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -223,6 +223,9 @@ static int am65_cpsw_nuss_ndo_slave_add_vid(struct net_device *ndev,
 	u32 port_mask, unreg_mcast = 0;
 	int ret;
 
+	if (!netif_running(ndev) || !vid)
+		return 0;
+
 	ret = pm_runtime_get_sync(common->dev);
 	if (ret < 0) {
 		pm_runtime_put_noidle(common->dev);
@@ -246,6 +249,9 @@ static int am65_cpsw_nuss_ndo_slave_kill_vid(struct net_device *ndev,
 	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
 	int ret;
 
+	if (!netif_running(ndev) || !vid)
+		return 0;
+
 	ret = pm_runtime_get_sync(common->dev);
 	if (ret < 0) {
 		pm_runtime_put_noidle(common->dev);
@@ -571,6 +577,16 @@ static int am65_cpsw_nuss_ndo_slave_stop(struct net_device *ndev)
 	return 0;
 }
 
+static int cpsw_restore_vlans(struct net_device *vdev, int vid, void *arg)
+{
+	struct am65_cpsw_port *port = arg;
+
+	if (!vdev)
+		return 0;
+
+	return am65_cpsw_nuss_ndo_slave_add_vid(port->ndev, 0, vid);
+}
+
 static int am65_cpsw_nuss_ndo_slave_open(struct net_device *ndev)
 {
 	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
@@ -644,6 +660,9 @@ static int am65_cpsw_nuss_ndo_slave_open(struct net_device *ndev)
 		}
 	}
 
+	/* restore vlan configurations */
+	vlan_for_each(ndev, cpsw_restore_vlans, port);
+
 	phy_attached_info(port->slave.phy);
 	phy_start(port->slave.phy);
 
-- 
2.17.1

