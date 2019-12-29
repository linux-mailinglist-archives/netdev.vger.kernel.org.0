Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7339612C256
	for <lists+netdev@lfdr.de>; Sun, 29 Dec 2019 12:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbfL2LlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Dec 2019 06:41:24 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41305 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726388AbfL2LlY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Dec 2019 06:41:24 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id A3D0B21B5A;
        Sun, 29 Dec 2019 06:41:22 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 29 Dec 2019 06:41:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=4qo3LRQDcHo7TWdsU8XsseIV1tCgmGkEDvD8q4eMKoE=; b=A4V4mZFq
        Eclx7RnQIgk0ocrf1E4Gby1Q4eTy15DuCfw3eTx/vua391pog0wn1RJPmzY5jFJV
        9jWefCV0fK47Gor9eunulotrrKHLwkir1k/4jEEDuclzxhztdsTp8VGLOhvIw0X3
        rKYfhiZzJ/rM2NdHU/jI2f+jmNfKeEBsR0SUQ+xlAKb86Mz32hKnFl1PrmlGEAHh
        Rwsrzbvwl2dy0MASVgz/etQfq6XYdDtRp/+Zj2MNPQmRzThYMfTjEJwZgaM5AgLQ
        sE6inMX+gxt3AQeNLKxo50+7itx8W7GFuwvJYmjHi/rz5RCXIYQjpBSXt6Z8S4zu
        T0wYePbBpfcDEA==
X-ME-Sender: <xms:4pAIXlX98ouauVjmeBcDsP-UOoEUNLz_-UTuApChLvB65-7fjefggQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdeffedgfedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudekuddriedurdduudejnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgeptd
X-ME-Proxy: <xmx:4pAIXk1zIkvxBS_dvpgEYqdQ614FRwhokVC3aTHII1B7cmmvWxEJ1A>
    <xmx:4pAIXkM6nRxedZ1xuUUqAZuTK5rZJYsr4RFQ2IdcRLTZ-ecKn0tDng>
    <xmx:4pAIXv3X371yr_p1obglqU8OjFUaIagRptmVRkyFbCTcQlCiFB3Gyw>
    <xmx:4pAIXivXu1rs62dZnfwurUWog3Cw_pIu3EGqFi5E4SxL5riKYd7cTg>
Received: from splinter.mtl.com (bzq-79-181-61-117.red.bezeqint.net [79.181.61.117])
        by mail.messagingengine.com (Postfix) with ESMTPA id 51A8E3060AA8;
        Sun, 29 Dec 2019 06:41:21 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 2/2] mlxsw: spectrum: Use dedicated policer for VRRP packets
Date:   Sun, 29 Dec 2019 13:40:23 +0200
Message-Id: <20191229114023.60873-3-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229114023.60873-1-idosch@idosch.org>
References: <20191229114023.60873-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Currently, VRRP packets and packets that hit exceptions during routing
(e.g., MTU error) are policed using the same policer towards the CPU.
This means, for example, that misconfiguration of the MTU on a routed
interface can prevent VRRP packets from reaching the CPU, which in turn
can cause the VRRP daemon to assume it is the Master router.

Fix this by using a dedicated policer for VRRP packets.

Fixes: 11566d34f895 ("mlxsw: spectrum: Add VRRP traps")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reported-by: Alex Veber <alexve@mellanox.com>
Tested-by: Alex Veber <alexve@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h      | 1 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 9 +++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 5294a1622643..af30e8a76682 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5472,6 +5472,7 @@ enum mlxsw_reg_htgt_trap_group {
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_LBERROR,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_PTP0,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_PTP1,
+	MLXSW_REG_HTGT_TRAP_GROUP_SP_VRRP,
 
 	__MLXSW_REG_HTGT_TRAP_GROUP_MAX,
 	MLXSW_REG_HTGT_TRAP_GROUP_MAX = __MLXSW_REG_HTGT_TRAP_GROUP_MAX - 1
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 556dca328bb5..f7fd5e8fbf96 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4542,8 +4542,8 @@ static const struct mlxsw_listener mlxsw_sp_listener[] = {
 	MLXSW_SP_RXL_MARK(ROUTER_ALERT_IPV6, TRAP_TO_CPU, ROUTER_EXP, false),
 	MLXSW_SP_RXL_MARK(IPIP_DECAP_ERROR, TRAP_TO_CPU, ROUTER_EXP, false),
 	MLXSW_SP_RXL_MARK(DECAP_ECN0, TRAP_TO_CPU, ROUTER_EXP, false),
-	MLXSW_SP_RXL_MARK(IPV4_VRRP, TRAP_TO_CPU, ROUTER_EXP, false),
-	MLXSW_SP_RXL_MARK(IPV6_VRRP, TRAP_TO_CPU, ROUTER_EXP, false),
+	MLXSW_SP_RXL_MARK(IPV4_VRRP, TRAP_TO_CPU, VRRP, false),
+	MLXSW_SP_RXL_MARK(IPV6_VRRP, TRAP_TO_CPU, VRRP, false),
 	/* PKT Sample trap */
 	MLXSW_RXL(mlxsw_sp_rx_listener_sample_func, PKT_SAMPLE, MIRROR_TO_CPU,
 		  false, SP_IP2ME, DISCARD),
@@ -4626,6 +4626,10 @@ static int mlxsw_sp_cpu_policers_set(struct mlxsw_core *mlxsw_core)
 			rate = 19 * 1024;
 			burst_size = 12;
 			break;
+		case MLXSW_REG_HTGT_TRAP_GROUP_SP_VRRP:
+			rate = 360;
+			burst_size = 7;
+			break;
 		default:
 			continue;
 		}
@@ -4665,6 +4669,7 @@ static int mlxsw_sp_trap_groups_set(struct mlxsw_core *mlxsw_core)
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_OSPF:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_PIM:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_PTP0:
+		case MLXSW_REG_HTGT_TRAP_GROUP_SP_VRRP:
 			priority = 5;
 			tc = 5;
 			break;
-- 
2.24.1

