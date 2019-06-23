Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C86F4FB7F
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 14:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbfFWMNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 08:13:42 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:45509 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726429AbfFWMNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 08:13:42 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 45WrtX2Z6Sz1rBnV;
        Sun, 23 Jun 2019 14:13:39 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 45WrtW4sF1z1qrQJ;
        Sun, 23 Jun 2019 14:13:39 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id 8z0YSPObSAJ5; Sun, 23 Jun 2019 14:13:38 +0200 (CEST)
X-Auth-Info: EA9wDjsQOFuzV5l0sdEOr7tWyDgkkwru5hfQTVAApSw=
Received: from kurokawa.lan (ip-86-49-110-70.net.upcbroadband.cz [86.49.110.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Sun, 23 Jun 2019 14:13:38 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH] net: ethernet: ti: cpsw: Assign OF node to slave devices
Date:   Sun, 23 Jun 2019 14:11:43 +0200
Message-Id: <20190623121143.3492-1-marex@denx.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Assign OF node to CPSW slave devices, otherwise it is not possible to
bind e.g. DSA switch to them. Without this patch, the DSA code tries
to find the ethernet device by OF match, but fails to do so because
the slave device has NULL OF node.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 drivers/net/ethernet/ti/cpsw.c      | 3 +++
 drivers/net/ethernet/ti/cpsw_priv.h | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 7bdd287074fc..c39790e21276 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -2179,6 +2179,7 @@ static int cpsw_probe_dt(struct cpsw_platform_data *data,
 			return ret;
 		}
 
+		slave_data->slave_node = slave_node;
 		slave_data->phy_node = of_parse_phandle(slave_node,
 							"phy-handle", 0);
 		parp = of_get_property(slave_node, "phy_id", &lenp);
@@ -2329,6 +2330,7 @@ static int cpsw_probe_dual_emac(struct cpsw_priv *priv)
 
 	/* register the network device */
 	SET_NETDEV_DEV(ndev, cpsw->dev);
+	ndev->dev.of_node = cpsw->slaves[1].data->slave_node;
 	ret = register_netdev(ndev);
 	if (ret)
 		dev_err(cpsw->dev, "cpsw: error registering net device\n");
@@ -2506,6 +2508,7 @@ static int cpsw_probe(struct platform_device *pdev)
 
 	/* register the network device */
 	SET_NETDEV_DEV(ndev, dev);
+	ndev->dev.of_node = cpsw->slaves[0].data->slave_node;
 	ret = register_netdev(ndev);
 	if (ret) {
 		dev_err(dev, "error registering net device\n");
diff --git a/drivers/net/ethernet/ti/cpsw_priv.h b/drivers/net/ethernet/ti/cpsw_priv.h
index 04795b97ee71..e32f11da2dce 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.h
+++ b/drivers/net/ethernet/ti/cpsw_priv.h
@@ -272,6 +272,7 @@ struct cpsw_host_regs {
 };
 
 struct cpsw_slave_data {
+	struct device_node *slave_node;
 	struct device_node *phy_node;
 	char		phy_id[MII_BUS_ID_SIZE];
 	int		phy_if;
-- 
2.20.1

