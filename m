Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08777F6255
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 03:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbfKJCmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 21:42:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:37948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727817AbfKJCmT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 21:42:19 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D4C0214E0;
        Sun, 10 Nov 2019 02:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353738;
        bh=c8KsAEiMdXpU+ct8AoP47mQ6yVted/wuYpqdIaHF2vo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AVLDOoxsba7wiX3JtfjGwpu677bkq75X0dup6/NYfOuiS6XIUtrSeoDrXOx0+Xikp
         IYea8kN9gRfBKwtzmG6E0yCarVjFMyQHHnHBg1KfdCmkswJAESni8rbZcOaavhtohP
         APVk3UCoBcN3ZVQiO4Ngy+NMJe6em81GBQEO0eY0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>, Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 060/191] mlxsw: spectrum: Init shaper for TCs 8..15
Date:   Sat,  9 Nov 2019 21:38:02 -0500
Message-Id: <20191110024013.29782-60-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

[ Upstream commit a9f36656b519a9a21309793c306941a3cd0eeb8f ]

With introduction of MC-aware mode to mlxsw, it became necessary to
configure TCs above 7 as well. There is now code in mlxsw to disable ETS
for these higher classes, but disablement of max shaper was neglected.

By default, max shaper is currently disabled to begin with, so the
problem is just cosmetic. However, for symmetry, do like we do for ETS
configuration, and call mlxsw_sp_port_ets_maxrate_set() for both TC i
and i + 8.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index ccd9aca281b37..1c170a0fd2cc9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -2815,6 +2815,13 @@ static int mlxsw_sp_port_ets_init(struct mlxsw_sp_port *mlxsw_sp_port)
 						    MLXSW_REG_QEEC_MAS_DIS);
 		if (err)
 			return err;
+
+		err = mlxsw_sp_port_ets_maxrate_set(mlxsw_sp_port,
+						    MLXSW_REG_QEEC_HIERARCY_TC,
+						    i + 8, i,
+						    MLXSW_REG_QEEC_MAS_DIS);
+		if (err)
+			return err;
 	}
 
 	/* Map all priorities to traffic class 0. */
-- 
2.20.1

