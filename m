Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60F0B1E605B
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 14:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388674AbgE1L4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 07:56:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:48130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388652AbgE1L4Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 07:56:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 363892089D;
        Thu, 28 May 2020 11:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590666975;
        bh=EUyRpb3EQAr3VgeyKmxe4l/6m82tQ6ZFBOGR+llSCE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k+QGi3dl2A0bZwOowjTimc1ZQRmi5TT3xEaXiUM3fUVghQ8S1UCPw4CY1x4ZkvlAW
         GF3qoLSiW5r9St/F96ma6FivHRdfrcTheCI5Pv22ssJkR+7IRSXqhDSYH3rNfaftpZ
         M55FKLAcVWEnnQQdG1noNIgcp8u766bMYb+BFLlY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 13/47] net: phy: propagate an error back to the callers of phy_sfp_probe
Date:   Thu, 28 May 2020 07:55:26 -0400
Message-Id: <20200528115600.1405808-13-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200528115600.1405808-1-sashal@kernel.org>
References: <20200528115600.1405808-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

[ Upstream commit e3f2d5579c0b8ad9d1fb6a5813cee38a86386e05 ]

The compilation warning below reveals that the errors returned from
the sfp_bus_add_upstream() call are not propagated to the callers.
Fix it by returning "ret".

14:37:51 drivers/net/phy/phy_device.c: In function 'phy_sfp_probe':
14:37:51 drivers/net/phy/phy_device.c:1236:6: warning: variable 'ret'
   set but not used [-Wunused-but-set-variable]
14:37:51  1236 |  int ret;
14:37:51       |      ^~~

Fixes: 298e54fa810e ("net: phy: add core phylib sfp support")
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy_device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 28e3c5c0e3c3..faca0d84f5af 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1239,7 +1239,7 @@ int phy_sfp_probe(struct phy_device *phydev,
 		  const struct sfp_upstream_ops *ops)
 {
 	struct sfp_bus *bus;
-	int ret;
+	int ret = 0;
 
 	if (phydev->mdio.dev.fwnode) {
 		bus = sfp_bus_find_fwnode(phydev->mdio.dev.fwnode);
@@ -1251,7 +1251,7 @@ int phy_sfp_probe(struct phy_device *phydev,
 		ret = sfp_bus_add_upstream(bus, phydev, ops);
 		sfp_bus_put(bus);
 	}
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(phy_sfp_probe);
 
-- 
2.25.1

