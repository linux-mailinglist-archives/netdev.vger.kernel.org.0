Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02F5742FC49
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 21:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242760AbhJOTlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 15:41:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:45232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242746AbhJOTlF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 15:41:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E97E361151;
        Fri, 15 Oct 2021 19:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634326738;
        bh=63zjXCwNhZokUOOwqKvlLRd3h4VTDFNeTbMHQDndews=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o8PXrz9Ga5NmB/eLOpWYr2Di1UwESnnKXH+MhElRXLVCTDKk99IR4bkjI/wIdUxqJ
         B7X7GZuC1LGsUCYi/FUJqYrqCyRMWoTWW4yMb9wZOaf3ZH2u4KV+13dEY8b8a9jZ6y
         7/Na0kWanW3lZGBgrc7SmsisU2FWFc13+QW/3jYS24MEVzyQWNNWBRETc3BlRMX7tI
         L/1/Xt1ojcta849z3llC9p4OjGhgY5hWi50wcSVsMZdcCgwQznAbaRPjRR1BcYqcp5
         4q1ekjpZUq1fhW3Yohtt+7aZrbK9zXpJ5h3Nj5l76NDfZPK7ZXKodXmkLZ7RqUb+hF
         0P1YuLR4aqLxg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Cc:     olteanv@gmail.com, andrew@lunn.ch, idosch@idosch.org,
        f.fainelli@gmail.com, Jakub Kicinski <kuba@kernel.org>,
        jiri@nvidia.com, idosch@nvidia.com
Subject: [RFC net-next 5/6] ethernet: mlxsw: use eth_hw_addr_set_port()
Date:   Fri, 15 Oct 2021 12:38:47 -0700
Message-Id: <20211015193848.779420-6-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211015193848.779420-1-kuba@kernel.org>
References: <20211015193848.779420-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it got through appropriate helpers.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: jiri@nvidia.com
CC: idosch@nvidia.com
---
 drivers/net/ethernet/mellanox/mlxsw/minimal.c  | 9 +++------
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 8 ++++----
 2 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/minimal.c b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
index e0892f259adf..8137606df615 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/minimal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
@@ -202,18 +202,15 @@ mlxsw_m_port_dev_addr_get(struct mlxsw_m_port *mlxsw_m_port)
 	struct mlxsw_m *mlxsw_m = mlxsw_m_port->mlxsw_m;
 	struct net_device *dev = mlxsw_m_port->dev;
 	char ppad_pl[MLXSW_REG_PPAD_LEN];
+	u8 addr[ETH_ALEN];
 	int err;
 
 	mlxsw_reg_ppad_pack(ppad_pl, false, 0);
 	err = mlxsw_reg_query(mlxsw_m->core, MLXSW_REG(ppad), ppad_pl);
 	if (err)
 		return err;
-	mlxsw_reg_ppad_mac_memcpy_from(ppad_pl, dev->dev_addr);
-	/* The last byte value in base mac address is guaranteed
-	 * to be such it does not overflow when adding local_port
-	 * value.
-	 */
-	dev->dev_addr[ETH_ALEN - 1] += mlxsw_m_port->module + 1;
+	mlxsw_reg_ppad_mac_memcpy_from(ppad_pl, addr);
+	eth_hw_addr_set_port(dev, addr, mlxsw_m_port->module + 1);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index d05850ff3a77..38521d9402b2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -316,11 +316,11 @@ static int mlxsw_sp_port_dev_addr_set(struct mlxsw_sp_port *mlxsw_sp_port,
 static int mlxsw_sp_port_dev_addr_init(struct mlxsw_sp_port *mlxsw_sp_port)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
-	unsigned char *addr = mlxsw_sp_port->dev->dev_addr;
 
-	ether_addr_copy(addr, mlxsw_sp->base_mac);
-	addr[ETH_ALEN - 1] += mlxsw_sp_port->local_port;
-	return mlxsw_sp_port_dev_addr_set(mlxsw_sp_port, addr);
+	eth_hw_addr_set_port(mlxsw_sp_port->dev, mlxsw_sp->base_mac,
+			     mlxsw_sp_port->local_port);
+	return mlxsw_sp_port_dev_addr_set(mlxsw_sp_port,
+					  mlxsw_sp_port->dev->dev_addr);
 }
 
 static int mlxsw_sp_port_max_mtu_get(struct mlxsw_sp_port *mlxsw_sp_port, int *p_max_mtu)
-- 
2.31.1

