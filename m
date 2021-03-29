Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54E9534C9AA
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 10:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234111AbhC2Iau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 04:30:50 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36253 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233928AbhC2IaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 04:30:09 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id DB3675C0043;
        Mon, 29 Mar 2021 04:30:08 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 29 Mar 2021 04:30:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=WVKUCgxJn6b2N1+LjFMDo3QzUS48AWDItfhyJSdz1Bw=; b=N5RlFlvy
        2FIkokrm4ukO8GYhHFJ4TqLHdCy64ZpsU0V+dypvTO+1zSIBzqXR5VCRoq6Z8cH8
        oTPMxCKs64TZumC8sllr5XfMqex0d7jyPJugWonuyK+a6FoO30J3eiWyY2JBJyrt
        zYPpqgkGbYFVCy0QwDTvUGaIJ2usJdhZExBvZcAnbaOv8zwEEvpAgWpBR3KHFShR
        BSWpWsmZ41IH/RkwEj0QAQVnFNtGGKrDXbp6YTEmlkkIflgzSuuVRSSbqhQqSHng
        9lhIxhhGV3dogTnoNjGvSqorMphl++kOmxzL1yHad+sW0xp1nPSj04VrhdYwEiIJ
        GhC/hETu9AybZw==
X-ME-Sender: <xms:EJBhYFYOi50FbeaAZ2z_Q4gEKFuG199_c_9vKKv0lOSBZp842mRfNA>
    <xme:EJBhYMZ6VBZDXbJEX1uP_nuwPsxvmsYBJskKOeK734R5_E3_9hFsscLcYKAQVFcl4
    5S5JDyNaBlBq9g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudehkedgtdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:EJBhYH-CLkLGU3r1snvO05kdbSmAn2x57V08a2UtWc3aVCEfVqrUFg>
    <xmx:EJBhYDoWA6tjGG4hhJ3MrqdkUDJAVxJVd_EjWykLnNRtNr1FYqKTgQ>
    <xmx:EJBhYApXBJy7WRFYK7DhSvJGmz0ztdL8R80MALtiQA0Ihbz3L3S0ag>
    <xmx:EJBhYFDS7cOaiXuOLV1eNIgm2MTzdVwv12PpfbSxj7yKSv1JcP32Pg>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3F063240057;
        Mon, 29 Mar 2021 04:30:07 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, liuhangbin@gmail.com, toke@redhat.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net mlxsw v2 1/2] mlxsw: spectrum: Fix ECN marking in tunnel decapsulation
Date:   Mon, 29 Mar 2021 11:29:26 +0300
Message-Id: <20210329082927.347631-5-idosch@idosch.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210329082927.347631-1-idosch@idosch.org>
References: <20210329082927.347631-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Cited commit changed the behavior of the software data path with regards
to the ECN marking of decapsulated packets. However, the commit did not
change other callers of __INET_ECN_decapsulate(), namely mlxsw. The
driver is using the function in order to ensure that the hardware and
software data paths act the same with regards to the ECN marking of
decapsulated packets.

The discrepancy was uncovered by commit 5aa3c334a449 ("selftests:
forwarding: vxlan_bridge_1d: Fix vxlan ecn decapsulate value") that
aligned the selftest to the new behavior. Without this patch the
selftest passes when used with veth pairs, but fails when used with
mlxsw netdevs.

Fix this by instructing the device to propagate the ECT(1) mark from the
outer header to the inner header when the inner header is ECT(0), for
both NVE and IP-in-IP tunnels.

A helper is added in order not to duplicate the code between both tunnel
types.

Fixes: b723748750ec ("tunnel: Propagate ECT(1) when decapsulating as recommended by RFC6040")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h    | 15 +++++++++++++++
 .../net/ethernet/mellanox/mlxsw/spectrum_ipip.c   |  7 +++----
 .../net/ethernet/mellanox/mlxsw/spectrum_nve.c    |  7 +++----
 3 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 8554cf7356cb..09eeadac2352 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -22,6 +22,7 @@
 #include <net/red.h>
 #include <net/vxlan.h>
 #include <net/flow_offload.h>
+#include <net/inet_ecn.h>
 
 #include "port.h"
 #include "core.h"
@@ -367,6 +368,20 @@ struct mlxsw_sp_port_type_speed_ops {
 	u32 (*ptys_proto_cap_masked_get)(u32 eth_proto_cap);
 };
 
+static inline u8 mlxsw_sp_tunnel_ecn_decap(u8 outer_ecn, u8 inner_ecn,
+					   bool *trap_en)
+{
+	bool set_ce = false;
+
+	*trap_en = !!__INET_ECN_decapsulate(outer_ecn, inner_ecn, &set_ce);
+	if (set_ce)
+		return INET_ECN_CE;
+	else if (outer_ecn == INET_ECN_ECT_1 && inner_ecn == INET_ECN_ECT_0)
+		return INET_ECN_ECT_1;
+	else
+		return inner_ecn;
+}
+
 static inline struct net_device *
 mlxsw_sp_bridge_vxlan_dev_find(struct net_device *br_dev)
 {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
index b8b08a6a1d10..5facabd86882 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
@@ -337,12 +337,11 @@ static int mlxsw_sp_ipip_ecn_decap_init_one(struct mlxsw_sp *mlxsw_sp,
 					    u8 inner_ecn, u8 outer_ecn)
 {
 	char tidem_pl[MLXSW_REG_TIDEM_LEN];
-	bool trap_en, set_ce = false;
 	u8 new_inner_ecn;
+	bool trap_en;
 
-	trap_en = __INET_ECN_decapsulate(outer_ecn, inner_ecn, &set_ce);
-	new_inner_ecn = set_ce ? INET_ECN_CE : inner_ecn;
-
+	new_inner_ecn = mlxsw_sp_tunnel_ecn_decap(outer_ecn, inner_ecn,
+						  &trap_en);
 	mlxsw_reg_tidem_pack(tidem_pl, outer_ecn, inner_ecn, new_inner_ecn,
 			     trap_en, trap_en ? MLXSW_TRAP_ID_DECAP_ECN0 : 0);
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(tidem), tidem_pl);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c
index e5ec595593f4..9eba8fa684ae 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c
@@ -909,12 +909,11 @@ static int __mlxsw_sp_nve_ecn_decap_init(struct mlxsw_sp *mlxsw_sp,
 					 u8 inner_ecn, u8 outer_ecn)
 {
 	char tndem_pl[MLXSW_REG_TNDEM_LEN];
-	bool trap_en, set_ce = false;
 	u8 new_inner_ecn;
+	bool trap_en;
 
-	trap_en = !!__INET_ECN_decapsulate(outer_ecn, inner_ecn, &set_ce);
-	new_inner_ecn = set_ce ? INET_ECN_CE : inner_ecn;
-
+	new_inner_ecn = mlxsw_sp_tunnel_ecn_decap(outer_ecn, inner_ecn,
+						  &trap_en);
 	mlxsw_reg_tndem_pack(tndem_pl, outer_ecn, inner_ecn, new_inner_ecn,
 			     trap_en, trap_en ? MLXSW_TRAP_ID_DECAP_ECN0 : 0);
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(tndem), tndem_pl);
-- 
2.30.2

