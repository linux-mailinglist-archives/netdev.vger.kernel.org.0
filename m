Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBEF13F7EC
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733130AbgAPQz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 11:55:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:41746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729058AbgAPQz5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 11:55:57 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 672E424683;
        Thu, 16 Jan 2020 16:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193756;
        bh=o6ZUlheOHo+lvW9SfN6gTcRCJG4x8eLLXD3Zr83n1Xo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1KpLGb0UT+/N+qiqEFrjFXbkgWCBmY4tCAIAj7Su25MaBEWDLaAlRSyAevygnNTIX
         rTvbHP0dJeF1hA2Etysj7SJoYD6oaC7sEXfogCpX5cMchSsqIS2YgRles/wsDKq5cS
         3OmCE2/r5Dvdlu6I2MD832ihWm/21B3ne8gmRT20=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 044/671] mlxsw: spectrum: Set minimum shaper on MC TCs
Date:   Thu, 16 Jan 2020 11:44:35 -0500
Message-Id: <20200116165502.8838-44-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165502.8838-1-sashal@kernel.org>
References: <20200116165502.8838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

[ Upstream commit 0fe64023162aef123de2f1993ba13a35a786e1de ]

An MC-aware mode was introduced in commit 7b8195306694 ("mlxsw:
spectrum: Configure MC-aware mode on mlxsw ports"). In MC-aware mode,
BUM traffic gets a special treatment by being assigned to a separate set
of traffic classes 8..15. Pairs of TCs 0 and 8, 1 and 9, etc., are then
configured to strictly prioritize the lower-numbered ones. The intention
is to prevent BUM traffic from flooding the switch and push out all UC
traffic, which would otherwise happen, and instead give UC traffic
precedence.

However strictly prioritizing UC traffic has the effect that UC overload
pushes out all BUM traffic, such as legitimate ARP queries. These
packets are kept in queues for a while, but under sustained UC overload,
their lifetime eventually expires and these packets are dropped. That is
detrimental to network performance as well.

Therefore configure the MC TCs (8..15) with minimum shaper of 200Mbps (a
minimum permitted value) to allow a trickle of necessary control traffic
to get through.

Fixes: 7b8195306694 ("mlxsw: spectrum: Configure MC-aware mode on mlxsw ports")
Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 25 +++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index e498ee95baca..4ce45f4c35aa 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -2750,6 +2750,21 @@ int mlxsw_sp_port_ets_maxrate_set(struct mlxsw_sp_port *mlxsw_sp_port,
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(qeec), qeec_pl);
 }
 
+static int mlxsw_sp_port_min_bw_set(struct mlxsw_sp_port *mlxsw_sp_port,
+				    enum mlxsw_reg_qeec_hr hr, u8 index,
+				    u8 next_index, u32 minrate)
+{
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	char qeec_pl[MLXSW_REG_QEEC_LEN];
+
+	mlxsw_reg_qeec_pack(qeec_pl, mlxsw_sp_port->local_port, hr, index,
+			    next_index);
+	mlxsw_reg_qeec_mise_set(qeec_pl, true);
+	mlxsw_reg_qeec_min_shaper_rate_set(qeec_pl, minrate);
+
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(qeec), qeec_pl);
+}
+
 int mlxsw_sp_port_prio_tc_set(struct mlxsw_sp_port *mlxsw_sp_port,
 			      u8 switch_prio, u8 tclass)
 {
@@ -2827,6 +2842,16 @@ static int mlxsw_sp_port_ets_init(struct mlxsw_sp_port *mlxsw_sp_port)
 			return err;
 	}
 
+	/* Configure the min shaper for multicast TCs. */
+	for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
+		err = mlxsw_sp_port_min_bw_set(mlxsw_sp_port,
+					       MLXSW_REG_QEEC_HIERARCY_TC,
+					       i + 8, i,
+					       MLXSW_REG_QEEC_MIS_MIN);
+		if (err)
+			return err;
+	}
+
 	/* Map all priorities to traffic class 0. */
 	for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
 		err = mlxsw_sp_port_prio_tc_set(mlxsw_sp_port, i, 0);
-- 
2.20.1

