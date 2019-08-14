Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C14E58C918
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 04:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729654AbfHNCgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 22:36:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:45306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728230AbfHNCNT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 22:13:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20A2A208C2;
        Wed, 14 Aug 2019 02:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748797;
        bh=x3MKwYkqOuixu1DlbFFVMJcToYiacJ4OpivV0h20SVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JUfdIel41xBZmL1l/RERwpo6DKZ8bDukTNw8RvnZZ0qkfjm7g8WequFb5kPYiub+v
         mIPYLZ9mdpWkItP7N/Wjr+VXEKg0nWRSksjQ2lceJmtwL9gU0LtavoQ1KeILj/q/gn
         dL72u8avgy46EwoKvzIcdXlT4hmCQTFZ2A7hYjt8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 068/123] enetc: Fix build error without PHYLIB
Date:   Tue, 13 Aug 2019 22:09:52 -0400
Message-Id: <20190814021047.14828-68-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021047.14828-1-sashal@kernel.org>
References: <20190814021047.14828-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 5f4e4203add2b860d2345312509a160f8292063b ]

If PHYLIB is not set, build enetc will fails:

drivers/net/ethernet/freescale/enetc/enetc.o: In function `enetc_open':
enetc.c: undefined reference to `phy_disconnect'
enetc.c: undefined reference to `phy_start'
drivers/net/ethernet/freescale/enetc/enetc.o: In function `enetc_close':
enetc.c: undefined reference to `phy_stop'
enetc.c: undefined reference to `phy_disconnect'
drivers/net/ethernet/freescale/enetc/enetc_ethtool.o: undefined reference to `phy_ethtool_get_link_ksettings'
drivers/net/ethernet/freescale/enetc/enetc_ethtool.o: undefined reference to `phy_ethtool_set_link_ksettings'
drivers/net/ethernet/freescale/enetc/enetc_mdio.o: In function `enetc_mdio_probe':
enetc_mdio.c: undefined reference to `mdiobus_alloc_size'
enetc_mdio.c: undefined reference to `mdiobus_free'

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: d4fd0404c1c9 ("enetc: Introduce basic PF and VF ENETC ethernet drivers")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Acked-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/freescale/enetc/Kconfig b/drivers/net/ethernet/freescale/enetc/Kconfig
index 8429f5c1d8106..8ac109e73a7bb 100644
--- a/drivers/net/ethernet/freescale/enetc/Kconfig
+++ b/drivers/net/ethernet/freescale/enetc/Kconfig
@@ -2,6 +2,7 @@
 config FSL_ENETC
 	tristate "ENETC PF driver"
 	depends on PCI && PCI_MSI && (ARCH_LAYERSCAPE || COMPILE_TEST)
+	select PHYLIB
 	help
 	  This driver supports NXP ENETC gigabit ethernet controller PCIe
 	  physical function (PF) devices, managing ENETC Ports at a privileged
-- 
2.20.1

