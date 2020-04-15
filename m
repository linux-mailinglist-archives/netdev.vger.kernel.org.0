Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12B781AA050
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 14:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393985AbgDOMZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 08:25:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:39280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409184AbgDOLpg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 07:45:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7435B20732;
        Wed, 15 Apr 2020 11:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586951136;
        bh=jtJh8SAtBOvjmOn8IDT09xYjRFdtekcKA8zyrGlixuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zjtgm5N4sxC1luNIkZbEXSqxFCCuxFwCaMnLY03Go7+kivIfFrpM6RSF34qMQzJtJ
         /CqTv8tqnsVr5NOMRdq6R1Q4WwB83OSWMW0b0XbyUes8VG7dsejDJcXu8v4JPyhVSd
         RpTTVXg/ECAS/r+VTNLRMuAz7vbdb8Nlj+rn0Brw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>, Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 46/84] mlxsw: spectrum_flower: Do not stop at FLOW_ACTION_VLAN_MANGLE
Date:   Wed, 15 Apr 2020 07:44:03 -0400
Message-Id: <20200415114442.14166-46-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114442.14166-1-sashal@kernel.org>
References: <20200415114442.14166-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

[ Upstream commit ccfc569347f870830e7c7cf854679a06cf9c45b5 ]

The handler for FLOW_ACTION_VLAN_MANGLE ends by returning whatever the
lower-level function that it calls returns. If there are more actions lined
up after this action, those are never offloaded. Fix by only bailing out
when the called function returns an error.

Fixes: a150201a70da ("mlxsw: spectrum: Add support for vlan modify TC action")
Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index b607919c8ad02..498de6ef68705 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -123,9 +123,12 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 			u8 prio = act->vlan.prio;
 			u16 vid = act->vlan.vid;
 
-			return mlxsw_sp_acl_rulei_act_vlan(mlxsw_sp, rulei,
-							   act->id, vid,
-							   proto, prio, extack);
+			err = mlxsw_sp_acl_rulei_act_vlan(mlxsw_sp, rulei,
+							  act->id, vid,
+							  proto, prio, extack);
+			if (err)
+				return err;
+			break;
 			}
 		default:
 			NL_SET_ERR_MSG_MOD(extack, "Unsupported action");
-- 
2.20.1

