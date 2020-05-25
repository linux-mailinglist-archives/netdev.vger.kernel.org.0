Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC59D1E181A
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 01:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389063AbgEYXGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 19:06:41 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:34033 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388969AbgEYXGe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 19:06:34 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 4E91F5C016A;
        Mon, 25 May 2020 19:06:33 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 25 May 2020 19:06:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=jaq/XqW+Lrbnwatd0qyc8/VqNTbUQi/GIjnWvbEAIAw=; b=dGaQIy8O
        US1u4SCjXMhXXPGX49ZORqJI2OgInqOvLAChMLhLCzvNtJltVFRRhOpXeFMhCCSN
        uCEnjgP8bhgfhCmEGvlWFV5U/PDH5M5JrB0+aPunNfGnWsmXqg9qu9Gd1Q9RADj8
        kpRm08XtcDq3OZ9Scs94k3Ni5IF5jRgp1dOaCPoTT5eg+TJ5WL/MOTFACJ2NQRBn
        bC00ipMfEtXxfTTE0i96BjdQ77UuY+tqlOyp+p7MLaZT5CnMjoTSt+JcmY2OEcu5
        1rueCqaID4EVgB+iS7DbLnbQbYSwZY0wGrafQOYbAjcIni/O1OwoRm0a2IJJfkp/
        sJB87pdHRXbPEQ==
X-ME-Sender: <xms:eU_MXluBPuwu6RK6b23IjG5vcwziU04Zn2KqRzRPo3D32HTfX7sD3g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddvuddgudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudejiedrvdegrddutdej
    necuvehluhhsthgvrhfuihiivgepleenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:eU_MXufxrjByH4LUrfHXM3WKYF_9Wzjed5_s3KKwt2Lf8xzdxCyzIQ>
    <xmx:eU_MXozhJjJbcLZQw-CpCg41RrbSZ_GKDF5qQED7XV5aUA8u9yT33Q>
    <xmx:eU_MXsM8JePLxa1hP2469MeH9EMXYzeEG8hmINY32UbAhutgwpdqbQ>
    <xmx:eU_MXnn9D2lF6PQ0VDuqVBzd0B-IgMBC9Y9Tll071mLDlq-jb0sIuQ>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 09F1C3280059;
        Mon, 25 May 2020 19:06:31 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 13/14] mlxsw: spectrum: Add packet traps for BFD packets
Date:   Tue, 26 May 2020 02:05:55 +0300
Message-Id: <20200525230556.1455927-14-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200525230556.1455927-1-idosch@idosch.org>
References: <20200525230556.1455927-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Bidirectional Forwarding Detection (BFD) provides "low-overhead,
short-duration detection of failures in the path between adjacent
forwarding engines" (RFC 5880).

This is accomplished by exchanging BFD packets between the two
forwarding engines. Up until now these packets were trapped via the
general local delivery (i.e., IP2ME) trap which also traps a lot of
other packets that are not as time-sensitive as BFD packets.

Expose dedicated traps for BFD packets so that user space could
configure a dedicated policer for them.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h      | 1 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 7 +++++++
 drivers/net/ethernet/mellanox/mlxsw/trap.h     | 2 ++
 3 files changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 586a2f37fd12..38fa7304af0c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5548,6 +5548,7 @@ enum mlxsw_reg_htgt_trap_group {
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_PKT_SAMPLE,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_FLOW_LOGGING,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_FID_MISS,
+	MLXSW_REG_HTGT_TRAP_GROUP_SP_BFD,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_DUMMY,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_L2_DISCARDS,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_L3_DISCARDS,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 5cb7fd650156..c598ae9ed106 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4093,6 +4093,8 @@ static const struct mlxsw_listener mlxsw_sp_listener[] = {
 	MLXSW_SP_RXL_MARK(ROUTER_ALERT_IPV6, TRAP_TO_CPU, IP2ME, false),
 	MLXSW_SP_RXL_MARK(IPV4_VRRP, TRAP_TO_CPU, VRRP, false),
 	MLXSW_SP_RXL_MARK(IPV6_VRRP, TRAP_TO_CPU, VRRP, false),
+	MLXSW_SP_RXL_MARK(IPV4_BFD, TRAP_TO_CPU, BFD, false),
+	MLXSW_SP_RXL_MARK(IPV6_BFD, TRAP_TO_CPU, BFD, false),
 	MLXSW_SP_RXL_NO_MARK(DISCARD_ING_ROUTER_SIP_CLASS_E, FORWARD,
 			     ROUTER_EXP, false),
 	MLXSW_SP_RXL_NO_MARK(DISCARD_ING_ROUTER_MC_DMAC, FORWARD,
@@ -4185,6 +4187,10 @@ static int mlxsw_sp_cpu_policers_set(struct mlxsw_core *mlxsw_core)
 			rate = 360;
 			burst_size = 7;
 			break;
+		case MLXSW_REG_HTGT_TRAP_GROUP_SP_BFD:
+			rate = 20 * 1024;
+			burst_size = 10;
+			break;
 		default:
 			continue;
 		}
@@ -4226,6 +4232,7 @@ static int mlxsw_sp_trap_groups_set(struct mlxsw_core *mlxsw_core)
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_PIM:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_PTP0:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_VRRP:
+		case MLXSW_REG_HTGT_TRAP_GROUP_SP_BFD:
 			priority = 5;
 			tc = 5;
 			break;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/trap.h b/drivers/net/ethernet/mellanox/mlxsw/trap.h
index 1b89472a0908..28e60697d14e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/trap.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/trap.h
@@ -66,6 +66,8 @@ enum {
 	MLXSW_TRAP_ID_IPIP_DECAP_ERROR = 0xB1,
 	MLXSW_TRAP_ID_NVE_DECAP_ARP = 0xB8,
 	MLXSW_TRAP_ID_NVE_ENCAP_ARP = 0xBD,
+	MLXSW_TRAP_ID_IPV4_BFD = 0xD0,
+	MLXSW_TRAP_ID_IPV6_BFD = 0xD1,
 	MLXSW_TRAP_ID_ROUTER_ALERT_IPV4 = 0xD6,
 	MLXSW_TRAP_ID_ROUTER_ALERT_IPV6 = 0xD7,
 	MLXSW_TRAP_ID_DISCARD_NON_ROUTABLE = 0x11A,
-- 
2.26.2

