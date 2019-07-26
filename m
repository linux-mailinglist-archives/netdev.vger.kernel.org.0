Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 737DA76A1F
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 15:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387763AbfGZNlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 09:41:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387747AbfGZNlp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jul 2019 09:41:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4333C22CD3;
        Fri, 26 Jul 2019 13:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148504;
        bh=kw1tzX8WE1U2hMV6bQjq4IdrRzIQAtYREyRufUjKTWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gQ0faUZOwhrtv7YcgbZgENqWnQw7+9Cnl6nTCdqzj/bu8DnFfPoZvDRF/v7A/U13t
         NJ645CpoHHip7qaN/2rDeIZBgIHkDCHsRBM3lSHASqaUjWN1UOmTwtRG7ZHUevSZHq
         jX/EhdiugBNfQ+9Fcr0FranNfUuQQl85UeRrV3SM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>,
        Alex Veber <alexve@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 71/85] mlxsw: spectrum_dcb: Configure DSCP map as the last rule is removed
Date:   Fri, 26 Jul 2019 09:39:21 -0400
Message-Id: <20190726133936.11177-71-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726133936.11177-1-sashal@kernel.org>
References: <20190726133936.11177-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

[ Upstream commit dedfde2fe1c4ccf27179fcb234e2112d065c39bb ]

Spectrum systems use DSCP rewrite map to update DSCP field in egressing
packets to correspond to priority that the packet has. Whether rewriting
will take place is determined at the point when the packet ingresses the
switch: if the port is in Trust L3 mode, packet priority is determined from
the DSCP map at the port, and DSCP rewrite will happen. If the port is in
Trust L2 mode, 802.1p is used for packet prioritization, and no DSCP
rewrite will happen.

The driver determines the port trust mode based on whether any DSCP
prioritization rules are in effect at given port. If there are any, trust
level is L3, otherwise it's L2. When the last DSCP rule is removed, the
port is switched to trust L2. Under that scenario, if DSCP of a packet
should be rewritten, it should be rewritten to 0.

However, when switching to Trust L2, the driver neglects to also update the
DSCP rewrite map. The last DSCP rule thus remains in effect, and packets
egressing through this port, if they have the right priority, will have
their DSCP set according to this rule.

Fix by first configuring the rewrite map, and only then switching to trust
L2 and bailing out.

Fixes: b2b1dab6884e ("mlxsw: spectrum: Support ieee_setapp, ieee_delapp")
Signed-off-by: Petr Machata <petrm@mellanox.com>
Reported-by: Alex Veber <alexve@mellanox.com>
Tested-by: Alex Veber <alexve@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_dcb.c   | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
index b25048c6c761..21296fa7f7fb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
@@ -408,14 +408,6 @@ static int mlxsw_sp_port_dcb_app_update(struct mlxsw_sp_port *mlxsw_sp_port)
 	have_dscp = mlxsw_sp_port_dcb_app_prio_dscp_map(mlxsw_sp_port,
 							&prio_map);
 
-	if (!have_dscp) {
-		err = mlxsw_sp_port_dcb_toggle_trust(mlxsw_sp_port,
-					MLXSW_REG_QPTS_TRUST_STATE_PCP);
-		if (err)
-			netdev_err(mlxsw_sp_port->dev, "Couldn't switch to trust L2\n");
-		return err;
-	}
-
 	mlxsw_sp_port_dcb_app_dscp_prio_map(mlxsw_sp_port, default_prio,
 					    &dscp_map);
 	err = mlxsw_sp_port_dcb_app_update_qpdpm(mlxsw_sp_port,
@@ -432,6 +424,14 @@ static int mlxsw_sp_port_dcb_app_update(struct mlxsw_sp_port *mlxsw_sp_port)
 		return err;
 	}
 
+	if (!have_dscp) {
+		err = mlxsw_sp_port_dcb_toggle_trust(mlxsw_sp_port,
+					MLXSW_REG_QPTS_TRUST_STATE_PCP);
+		if (err)
+			netdev_err(mlxsw_sp_port->dev, "Couldn't switch to trust L2\n");
+		return err;
+	}
+
 	err = mlxsw_sp_port_dcb_toggle_trust(mlxsw_sp_port,
 					     MLXSW_REG_QPTS_TRUST_STATE_DSCP);
 	if (err) {
-- 
2.20.1

