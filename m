Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3E28696FD
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 17:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732835AbfGON73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 09:59:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:39922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730874AbfGON72 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 09:59:28 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C2422083D;
        Mon, 15 Jul 2019 13:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199167;
        bh=8hsRm8PaqPB2cnIfseBR58ZhY8tl+ZCHhu1vRzIadaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aKHmm3AF7CR3J2sMFQZ3u5azLEHYmpi6ppTKErWsBkcUCpBWsxllawOWQqVh2jEFI
         fkfZ9S+da8GtFRmWG3bl8W7GcYocXxo8WbuwLv15eebYYVkxpeGdCcrbs65bZQxS05
         KZCyWjqKOE7DTljnveWy9QhPmEcs9LWRwCMzD8kk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 206/249] net: ethernet: ti: cpsw: Assign OF node to slave devices
Date:   Mon, 15 Jul 2019 09:46:11 -0400
Message-Id: <20190715134655.4076-206-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 337d1727a3895775b5e5ef67d3ca0fea2e2ae768 ]

Assign OF node to CPSW slave devices, otherwise it is not possible to
bind e.g. DSA switch to them. Without this patch, the DSA code tries
to find the ethernet device by OF match, but fails to do so because
the slave device has NULL OF node.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/cpsw.c      | 3 +++
 drivers/net/ethernet/ti/cpsw_priv.h | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 634fc484a0b3..4e3026f9abed 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -2179,6 +2179,7 @@ static int cpsw_probe_dt(struct cpsw_platform_data *data,
 			return ret;
 		}
 
+		slave_data->slave_node = slave_node;
 		slave_data->phy_node = of_parse_phandle(slave_node,
 							"phy-handle", 0);
 		parp = of_get_property(slave_node, "phy_id", &lenp);
@@ -2330,6 +2331,7 @@ static int cpsw_probe_dual_emac(struct cpsw_priv *priv)
 
 	/* register the network device */
 	SET_NETDEV_DEV(ndev, cpsw->dev);
+	ndev->dev.of_node = cpsw->slaves[1].data->slave_node;
 	ret = register_netdev(ndev);
 	if (ret)
 		dev_err(cpsw->dev, "cpsw: error registering net device\n");
@@ -2507,6 +2509,7 @@ static int cpsw_probe(struct platform_device *pdev)
 
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

