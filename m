Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 716186C21A
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 22:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbfGQU37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 16:29:59 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:50733 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727147AbfGQU36 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 16:29:58 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 44F3A222C6;
        Wed, 17 Jul 2019 16:29:57 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 17 Jul 2019 16:29:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=sJkod6AZZOKqBtGXdviO2krAsce0Ai1mNBxQ0/tC07c=; b=E20P+0gh
        Lh+zIzknIRhPf3EM2JaLM+MJ5Sl+DzojzpxJ9csKLKcI8z2w1S34urCvoLJQ+Dkp
        noIopnzuv1lGWd5j25POD0ZnD+24ZyFHOfDAgQSxaC4hrKEO2P9HtJqm8uD7ELhU
        iDey2s7BiEeWkqsMpQLyjtsgpVzqNy03jkEI2W4gEn4kSQ6oexXuWKyCKUm1nQ1k
        y95OOknA+plGpcdZu7tD/2T3DNfR2+z0sfiHC1uhCY8eWv7NGKQLk3sXIJwzbkMP
        KPdAoLOWrFFDjLLtnTj02EoZyfJTfe/c35CQJoZ9toilEdN8aS+SUhl9fhsC1+3J
        hv+VjiHA46Rmew==
X-ME-Sender: <xms:RYUvXYivkOkpSnCwtF9h6r3wMR84JoAwkscgMnXaW2hG9FNLZac55A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrieefgdduvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejjedrudefkedrvdegledrvddtleenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedu
X-ME-Proxy: <xmx:RYUvXeb9KJdNYIMrClPzkBpq-KSPMw9R8gMzneuz_BIo_J8nMmTB-w>
    <xmx:RYUvXe8K2zkWGmniHUJr1MHEif2NS9D59taTkrbXebXoZ8BHuDyJlA>
    <xmx:RYUvXSdz_1v7KOpj046IRkoUQ4PCl02a7YHKmaniSYMN8nPr2M8tLg>
    <xmx:RYUvXSa8zGzJJuCkeK2Ghvu5yuloCH5hsAfX4bZedCx1QKKS46YgGQ>
Received: from localhost.localdomain (unknown [77.138.249.209])
        by mail.messagingengine.com (Postfix) with ESMTPA id BA1C8380074;
        Wed, 17 Jul 2019 16:29:55 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 2/2] mlxsw: spectrum: Do not process learned records with a dummy FID
Date:   Wed, 17 Jul 2019 23:29:08 +0300
Message-Id: <20190717202908.1547-3-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190717202908.1547-1-idosch@idosch.org>
References: <20190717202908.1547-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The switch periodically sends notifications about learned FDB entries.
Among other things, the notification includes the FID (Filtering
Identifier) and the port on which the MAC was learned.

In case the driver does not have the FID defined on the relevant port,
the following error will be periodically generated:

mlxsw_spectrum2 0000:06:00.0 swp32: Failed to find a matching {Port, VID} following FDB notification

This is not supposed to happen under normal conditions, but can happen
if an ingress tc filter with a redirect action is installed on a bridged
port. The redirect action will cause the packet's FID to be changed to
the dummy FID and a learning notification will be emitted with this FID
- which is not defined on the bridged port.

Fix this by having the driver ignore learning notifications generated
with the dummy FID and delete them from the device.

Another option is to chain an ignore action after the redirect action
which will cause the device to disable learning, but this means that we
need to consume another action whenever a redirect action is used. In
addition, the scenario described above is merely a corner case.

Fixes: cedbb8b25948 ("mlxsw: spectrum_flower: Set dummy FID before forward action")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reported-by: Alex Kushnarov <alexanderk@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Tested-by: Alex Kushnarov <alexanderk@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h         |  1 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c     | 10 ++++++++++
 .../net/ethernet/mellanox/mlxsw/spectrum_switchdev.c   |  6 ++++++
 3 files changed, 17 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index a252b080dda9..131f62ce9297 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -830,6 +830,7 @@ int mlxsw_sp_setup_tc_prio(struct mlxsw_sp_port *mlxsw_sp_port,
 			   struct tc_prio_qopt_offload *p);
 
 /* spectrum_fid.c */
+bool mlxsw_sp_fid_is_dummy(struct mlxsw_sp *mlxsw_sp, u16 fid_index);
 bool mlxsw_sp_fid_lag_vid_valid(const struct mlxsw_sp_fid *fid);
 struct mlxsw_sp_fid *mlxsw_sp_fid_lookup_by_index(struct mlxsw_sp *mlxsw_sp,
 						  u16 fid_index);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
index 46baf3b44309..8df3cb21baa6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
@@ -126,6 +126,16 @@ static const int *mlxsw_sp_packet_type_sfgc_types[] = {
 	[MLXSW_SP_FLOOD_TYPE_MC]	= mlxsw_sp_sfgc_mc_packet_types,
 };
 
+bool mlxsw_sp_fid_is_dummy(struct mlxsw_sp *mlxsw_sp, u16 fid_index)
+{
+	enum mlxsw_sp_fid_type fid_type = MLXSW_SP_FID_TYPE_DUMMY;
+	struct mlxsw_sp_fid_family *fid_family;
+
+	fid_family = mlxsw_sp->fid_core->fid_family_arr[fid_type];
+
+	return fid_family->start_index == fid_index;
+}
+
 bool mlxsw_sp_fid_lag_vid_valid(const struct mlxsw_sp_fid *fid)
 {
 	return fid->fid_family->lag_vid_valid;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 50111f228d77..5ecb45118400 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -2468,6 +2468,9 @@ static void mlxsw_sp_fdb_notify_mac_process(struct mlxsw_sp *mlxsw_sp,
 		goto just_remove;
 	}
 
+	if (mlxsw_sp_fid_is_dummy(mlxsw_sp, fid))
+		goto just_remove;
+
 	mlxsw_sp_port_vlan = mlxsw_sp_port_vlan_find_by_fid(mlxsw_sp_port, fid);
 	if (!mlxsw_sp_port_vlan) {
 		netdev_err(mlxsw_sp_port->dev, "Failed to find a matching {Port, VID} following FDB notification\n");
@@ -2527,6 +2530,9 @@ static void mlxsw_sp_fdb_notify_mac_lag_process(struct mlxsw_sp *mlxsw_sp,
 		goto just_remove;
 	}
 
+	if (mlxsw_sp_fid_is_dummy(mlxsw_sp, fid))
+		goto just_remove;
+
 	mlxsw_sp_port_vlan = mlxsw_sp_port_vlan_find_by_fid(mlxsw_sp_port, fid);
 	if (!mlxsw_sp_port_vlan) {
 		netdev_err(mlxsw_sp_port->dev, "Failed to find a matching {Port, VID} following FDB notification\n");
-- 
2.21.0

