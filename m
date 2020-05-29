Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB161E86C6
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 20:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbgE2Sh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 14:37:27 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:42139 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727013AbgE2ShZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 14:37:25 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 43AD15C00A7;
        Fri, 29 May 2020 14:37:24 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 29 May 2020 14:37:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=73wQyvnBw7WVEFNGAE3XrwQuz3JWUye2sBuPmUnzD/k=; b=xREa3FO2
        jsILEQvhUEEFr01qiNr9g+5J1EVP+cfsTLYWfXKLXBuqfPHd/paMMg2su7tdpJCo
        RkY4vkdp+yO44pPWcJ+PInhqh3J1gBRalFFIEL+HAhEpFlgVQCVlSrgcbO7gHpO+
        xGqiC6VYpavGxnI3U1m9cDVwQMrh9NQI2D+WJzdC65VCi+cPirJhftMH8CXnoRMU
        5IyH9WQFrzxcEzVNecnyrdyAXAIXnIGu3+lZ7apYVaqUegyJ6wwBVlpRhhIJNV8x
        OdxTmBmFixltiDtpcHuu5AE5mBPyiudEZD3KpIRuNPRAKENHwIRUoHcVW2njilvB
        rLIvSlZl1rIHNg==
X-ME-Sender: <xms:ZFbRXk2mIQrtPDTyHU6IfSc_4WnOf26Cd971h6oAW4Hiiy7AgKSHvQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddvkedguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepjeelrddujeeirddvgedruddt
    jeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:ZFbRXvEYr-hqxMbH29GtrtZyxlO_m9bPENOwAx5jGt6MKMADtlT0Vg>
    <xmx:ZFbRXs58glYY6WkR5uQRJqb2a0HqmYLfCK5gcCZNgiP-LcfkzR9Xkw>
    <xmx:ZFbRXt2jewhVFZXwBnxe64oEsu0BAzkhIu5c8fZ11DXa5En6u65Mew>
    <xmx:ZFbRXtNt_u_JM-AYq_iP2jEcxEI3-lf-t76-5W_DZBHmkX6BxGQ8UQ>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 068B33060F09;
        Fri, 29 May 2020 14:37:22 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 02/14] mlxsw: spectrum_trap: Move layer 3 exceptions to exceptions trap group
Date:   Fri, 29 May 2020 21:36:37 +0300
Message-Id: <20200529183649.1602091-3-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529183649.1602091-1-idosch@idosch.org>
References: <20200529183649.1602091-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The layer 3 exceptions are still subject to the same trap policer, so
nothing changes, but user space can choose to assign a different one.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  1 +
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   | 40 +++++++++++--------
 2 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 38fa7304af0c..030d6f9766d2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5552,6 +5552,7 @@ enum mlxsw_reg_htgt_trap_group {
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_DUMMY,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_L2_DISCARDS,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_L3_DISCARDS,
+	MLXSW_REG_HTGT_TRAP_GROUP_SP_L3_EXCEPTIONS,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_TUNNEL_DISCARDS,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_ACL_DISCARDS,
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index f4b812276a5a..dc2217f1a07f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -212,6 +212,11 @@ static const struct mlxsw_sp_trap_group_item mlxsw_sp_trap_group_items_arr[] = {
 		.hw_group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_L3_DISCARDS,
 		.priority = 0,
 	},
+	{
+		.group = DEVLINK_TRAP_GROUP_GENERIC(L3_EXCEPTIONS, 1),
+		.hw_group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_L3_EXCEPTIONS,
+		.priority = 2,
+	},
 	{
 		.group = DEVLINK_TRAP_GROUP_GENERIC(TUNNEL_DROPS, 1),
 		.hw_group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_TUNNEL_DISCARDS,
@@ -332,56 +337,59 @@ static const struct mlxsw_sp_trap_item mlxsw_sp_trap_items_arr[] = {
 		},
 	},
 	{
-		.trap = MLXSW_SP_TRAP_EXCEPTION(MTU_ERROR, L3_DROPS),
+		.trap = MLXSW_SP_TRAP_EXCEPTION(MTU_ERROR, L3_EXCEPTIONS),
 		.listeners_arr = {
-			MLXSW_SP_RXL_EXCEPTION(MTUERROR, L3_DISCARDS,
+			MLXSW_SP_RXL_EXCEPTION(MTUERROR, L3_EXCEPTIONS,
 					       TRAP_TO_CPU),
 		},
 	},
 	{
-		.trap = MLXSW_SP_TRAP_EXCEPTION(TTL_ERROR, L3_DROPS),
+		.trap = MLXSW_SP_TRAP_EXCEPTION(TTL_ERROR, L3_EXCEPTIONS),
 		.listeners_arr = {
-			MLXSW_SP_RXL_EXCEPTION(TTLERROR, L3_DISCARDS,
+			MLXSW_SP_RXL_EXCEPTION(TTLERROR, L3_EXCEPTIONS,
 					       TRAP_TO_CPU),
 		},
 	},
 	{
-		.trap = MLXSW_SP_TRAP_EXCEPTION(RPF, L3_DROPS),
+		.trap = MLXSW_SP_TRAP_EXCEPTION(RPF, L3_EXCEPTIONS),
 		.listeners_arr = {
-			MLXSW_SP_RXL_EXCEPTION(RPF, L3_DISCARDS, TRAP_TO_CPU),
+			MLXSW_SP_RXL_EXCEPTION(RPF, L3_EXCEPTIONS, TRAP_TO_CPU),
 		},
 	},
 	{
-		.trap = MLXSW_SP_TRAP_EXCEPTION(REJECT_ROUTE, L3_DROPS),
+		.trap = MLXSW_SP_TRAP_EXCEPTION(REJECT_ROUTE, L3_EXCEPTIONS),
 		.listeners_arr = {
-			MLXSW_SP_RXL_EXCEPTION(RTR_INGRESS1, L3_DISCARDS,
+			MLXSW_SP_RXL_EXCEPTION(RTR_INGRESS1, L3_EXCEPTIONS,
 					       TRAP_TO_CPU),
 		},
 	},
 	{
-		.trap = MLXSW_SP_TRAP_EXCEPTION(UNRESOLVED_NEIGH, L3_DROPS),
+		.trap = MLXSW_SP_TRAP_EXCEPTION(UNRESOLVED_NEIGH,
+						L3_EXCEPTIONS),
 		.listeners_arr = {
-			MLXSW_SP_RXL_EXCEPTION(HOST_MISS_IPV4, L3_DISCARDS,
+			MLXSW_SP_RXL_EXCEPTION(HOST_MISS_IPV4, L3_EXCEPTIONS,
 					       TRAP_TO_CPU),
-			MLXSW_SP_RXL_EXCEPTION(HOST_MISS_IPV6, L3_DISCARDS,
+			MLXSW_SP_RXL_EXCEPTION(HOST_MISS_IPV6, L3_EXCEPTIONS,
 					       TRAP_TO_CPU),
-			MLXSW_SP_RXL_EXCEPTION(DISCARD_ROUTER3, L3_DISCARDS,
+			MLXSW_SP_RXL_EXCEPTION(DISCARD_ROUTER3, L3_EXCEPTIONS,
 					       TRAP_EXCEPTION_TO_CPU),
 		},
 	},
 	{
 		.trap = MLXSW_SP_TRAP_EXCEPTION(IPV4_LPM_UNICAST_MISS,
-						L3_DROPS),
+						L3_EXCEPTIONS),
 		.listeners_arr = {
-			MLXSW_SP_RXL_EXCEPTION(DISCARD_ROUTER_LPM4, L3_DISCARDS,
+			MLXSW_SP_RXL_EXCEPTION(DISCARD_ROUTER_LPM4,
+					       L3_EXCEPTIONS,
 					       TRAP_EXCEPTION_TO_CPU),
 		},
 	},
 	{
 		.trap = MLXSW_SP_TRAP_EXCEPTION(IPV6_LPM_UNICAST_MISS,
-						L3_DROPS),
+						L3_EXCEPTIONS),
 		.listeners_arr = {
-			MLXSW_SP_RXL_EXCEPTION(DISCARD_ROUTER_LPM6, L3_DISCARDS,
+			MLXSW_SP_RXL_EXCEPTION(DISCARD_ROUTER_LPM6,
+					       L3_EXCEPTIONS,
 					       TRAP_EXCEPTION_TO_CPU),
 		},
 	},
-- 
2.26.2

