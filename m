Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A009D4328CE
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 23:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232545AbhJRVMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 17:12:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:59440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232536AbhJRVMc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 17:12:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B516A61207;
        Mon, 18 Oct 2021 21:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634591420;
        bh=ZTLG4VXrxg5XwJkK731dP1NSXynP67Bvb3mkmEEzu+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ii4Td9DYiwoDz/Vym71Wa5a6T6BCJUrM0/RuLdbsYzeI/+Lw9PtIqqH9gVXxfUKhz
         M2HZUUZklF3f+7r3jYpeeo7mUuKWUdfmPrB2B5Id1JQfd3PjqukIpVerC4WmDFQGP8
         VYtWt+jIPPoJRTcnhxa7UjoxdEV2puWELYnT6sKN3r0AAJwA2D56NqGd1D4CghBPp/
         P/4W6XM1MZTZKAne3qyK6c17kcQehohkxJhjT9s6oUoHorgUMQEsAmDsJUL9PIX9um
         lPmwRuyPNW31qPeiuEy53iJZYvnVuYECJdyNBpHRj/AZjK5KRRzd/OHlaZ210FeCkV
         ocGNtZQKc+iRw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, olteanv@gmail.com, andrew@lunn.ch,
        idosch@idosch.org, f.fainelli@gmail.com, snelson@pensando.io,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 5/6] ethernet: mlxsw: use eth_hw_addr_gen()
Date:   Mon, 18 Oct 2021 14:10:06 -0700
Message-Id: <20211018211007.1185777-6-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211018211007.1185777-1-kuba@kernel.org>
References: <20211018211007.1185777-1-kuba@kernel.org>
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
 - remove the dev temp variable as well
---
 drivers/net/ethernet/mellanox/mlxsw/minimal.c  | 10 +++-------
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c |  8 ++++----
 2 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/minimal.c b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
index e0892f259adf..5d4dfa5ddbb5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/minimal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
@@ -200,20 +200,16 @@ static int
 mlxsw_m_port_dev_addr_get(struct mlxsw_m_port *mlxsw_m_port)
 {
 	struct mlxsw_m *mlxsw_m = mlxsw_m_port->mlxsw_m;
-	struct net_device *dev = mlxsw_m_port->dev;
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
+	eth_hw_addr_gen(mlxsw_m_port->dev, addr, mlxsw_m_port->module + 1);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index d05850ff3a77..66c346a86ec5 100644
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
+	eth_hw_addr_gen(mlxsw_sp_port->dev, mlxsw_sp->base_mac,
+			mlxsw_sp_port->local_port);
+	return mlxsw_sp_port_dev_addr_set(mlxsw_sp_port,
+					  mlxsw_sp_port->dev->dev_addr);
 }
 
 static int mlxsw_sp_port_max_mtu_get(struct mlxsw_sp_port *mlxsw_sp_port, int *p_max_mtu)
-- 
2.31.1

