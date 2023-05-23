Return-Path: <netdev+bounces-4536-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BC1570D341
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 07:43:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0AC201C20C9C
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 05:43:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A35C1B915;
	Tue, 23 May 2023 05:42:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5BE1B8FC
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 05:42:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D6C6C4339B;
	Tue, 23 May 2023 05:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684820574;
	bh=Amc3E9LFW1g+5ioLPtm4R8IaljkRedxm2g7kBPLHa3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HBIBfZ/4RG9A7VwifJv5g1+YFrGyT+jN/HMRYXxGy842oyNb3Yv46z8H2OnW4XrR8
	 986nRR1ldGbJAchahv2PMtpv1L5f6ydJ9GdAq4yLgQOeERuCIyEilnCIZ2O4d+fsLC
	 f57FM/s6wEcUE7gPym+FX3DRXLeojbcviQffaPFwHF3iyOZUs7PxFK+hJ3SLl46CJp
	 rF1dNCVOYwF4uw1bG+r6Ni3AjHXaG4ZH0N3LEgRPBJEGk9MGe+RTPHEt6OdFXMH5Y4
	 igGhz9v3ki2dkTgKb426B2TDqQ2M5psKPmBzX+UWJA8Cavh5FZbXSkhTVNyB5NgIGy
	 KTYt+qKwF7ovQ==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Shay Drory <shayd@nvidia.com>,
	Roi Dayan <roid@nvidia.com>
Subject: [net 02/15] net/mlx5: Handle pairing of E-switch via uplink un/load APIs
Date: Mon, 22 May 2023 22:42:29 -0700
Message-Id: <20230523054242.21596-3-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230523054242.21596-1-saeed@kernel.org>
References: <20230523054242.21596-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shay Drory <shayd@nvidia.com>

In case user switch a device from switchdev mode to legacy mode, mlx5
first unpair the E-switch and afterwards unload the uplink vport.
From the other hand, in case user remove or reload a device, mlx5
first unload the uplink vport and afterwards unpair the E-switch.

The latter is causing a bug[1], hence, handle pairing of E-switch as
part of uplink un/load APIs.

[1]
In case VF_LAG is used, every tc fdb flow is duplicated to the peer
esw. However, the original esw keeps a pointer to this duplicated
flow, not the peer esw.
e.g.: if user create tc fdb flow over esw0, the flow is duplicated
over esw1, in FW/HW, but in SW, esw0 keeps a pointer to the duplicated
flow.
During module unload while a peer tc fdb flow is still offloaded, in
case the first device to be removed is the peer device (esw1 in the
example above), the peer net-dev is destroyed, and so the mlx5e_priv
is memset to 0.
Afterwards, the peer device is trying to unpair himself from the
original device (esw0 in the example above). Unpair API invoke the
original device to clear peer flow from its eswitch (esw0), but the
peer flow, which is stored over the original eswitch (esw0), is
trying to use the peer mlx5e_priv, which is memset to 0 and result in
bellow kernel-oops.

[  157.964081 ] BUG: unable to handle page fault for address: 000000000002ce60
[  157.964662 ] #PF: supervisor read access in kernel mode
[  157.965123 ] #PF: error_code(0x0000) - not-present page
[  157.965582 ] PGD 0 P4D 0
[  157.965866 ] Oops: 0000 [#1] SMP
[  157.967670 ] RIP: 0010:mlx5e_tc_del_fdb_flow+0x48/0x460 [mlx5_core]
[  157.976164 ] Call Trace:
[  157.976437 ]  <TASK>
[  157.976690 ]  __mlx5e_tc_del_fdb_peer_flow+0xe6/0x100 [mlx5_core]
[  157.977230 ]  mlx5e_tc_clean_fdb_peer_flows+0x67/0x90 [mlx5_core]
[  157.977767 ]  mlx5_esw_offloads_unpair+0x2d/0x1e0 [mlx5_core]
[  157.984653 ]  mlx5_esw_offloads_devcom_event+0xbf/0x130 [mlx5_core]
[  157.985212 ]  mlx5_devcom_send_event+0xa3/0xb0 [mlx5_core]
[  157.985714 ]  esw_offloads_disable+0x5a/0x110 [mlx5_core]
[  157.986209 ]  mlx5_eswitch_disable_locked+0x152/0x170 [mlx5_core]
[  157.986757 ]  mlx5_eswitch_disable+0x51/0x80 [mlx5_core]
[  157.987248 ]  mlx5_unload+0x2a/0xb0 [mlx5_core]
[  157.987678 ]  mlx5_uninit_one+0x5f/0xd0 [mlx5_core]
[  157.988127 ]  remove_one+0x64/0xe0 [mlx5_core]
[  157.988549 ]  pci_device_remove+0x31/0xa0
[  157.988933 ]  device_release_driver_internal+0x18f/0x1f0
[  157.989402 ]  driver_detach+0x3f/0x80
[  157.989754 ]  bus_remove_driver+0x70/0xf0
[  157.990129 ]  pci_unregister_driver+0x34/0x90
[  157.990537 ]  mlx5_cleanup+0xc/0x1c [mlx5_core]
[  157.990972 ]  __x64_sys_delete_module+0x15a/0x250
[  157.991398 ]  ? exit_to_user_mode_prepare+0xea/0x110
[  157.991840 ]  do_syscall_64+0x3d/0x90
[  157.992198 ]  entry_SYSCALL_64_after_hwframe+0x46/0xb0

Fixes: 04de7dda7394 ("net/mlx5e: Infrastructure for duplicated offloading of TC flows")
Fixes: 1418ddd96afd ("net/mlx5e: Duplicate offloaded TC eswitch rules under uplink LAG")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c            | 4 +++-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h          | 4 ++++
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 7 ++-----
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 728b82ce4031..65fe40f55d84 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -5301,6 +5301,8 @@ int mlx5e_tc_esw_init(struct mlx5_rep_uplink_priv *uplink_priv)
 		goto err_action_counter;
 	}
 
+	mlx5_esw_offloads_devcom_init(esw);
+
 	return 0;
 
 err_action_counter:
@@ -5329,7 +5331,7 @@ void mlx5e_tc_esw_cleanup(struct mlx5_rep_uplink_priv *uplink_priv)
 	priv = netdev_priv(rpriv->netdev);
 	esw = priv->mdev->priv.eswitch;
 
-	mlx5e_tc_clean_fdb_peer_flows(esw);
+	mlx5_esw_offloads_devcom_cleanup(esw);
 
 	mlx5e_tc_tun_cleanup(uplink_priv->encap);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 1a042c981713..9f007c5438ee 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -369,6 +369,8 @@ int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int num_vfs);
 void mlx5_eswitch_disable_sriov(struct mlx5_eswitch *esw, bool clear_vf);
 void mlx5_eswitch_disable_locked(struct mlx5_eswitch *esw);
 void mlx5_eswitch_disable(struct mlx5_eswitch *esw);
+void mlx5_esw_offloads_devcom_init(struct mlx5_eswitch *esw);
+void mlx5_esw_offloads_devcom_cleanup(struct mlx5_eswitch *esw);
 int mlx5_eswitch_set_vport_mac(struct mlx5_eswitch *esw,
 			       u16 vport, const u8 *mac);
 int mlx5_eswitch_set_vport_state(struct mlx5_eswitch *esw,
@@ -767,6 +769,8 @@ static inline void mlx5_eswitch_cleanup(struct mlx5_eswitch *esw) {}
 static inline int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int num_vfs) { return 0; }
 static inline void mlx5_eswitch_disable_sriov(struct mlx5_eswitch *esw, bool clear_vf) {}
 static inline void mlx5_eswitch_disable(struct mlx5_eswitch *esw) {}
+static inline void mlx5_esw_offloads_devcom_init(struct mlx5_eswitch *esw) {}
+static inline void mlx5_esw_offloads_devcom_cleanup(struct mlx5_eswitch *esw) {}
 static inline bool mlx5_eswitch_is_funcs_handler(struct mlx5_core_dev *dev) { return false; }
 static inline
 int mlx5_eswitch_set_vport_state(struct mlx5_eswitch *esw, u16 vport, int link_state) { return 0; }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 69215ffb9999..7c34c7cf506f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2779,7 +2779,7 @@ static int mlx5_esw_offloads_devcom_event(int event,
 	return err;
 }
 
-static void esw_offloads_devcom_init(struct mlx5_eswitch *esw)
+void mlx5_esw_offloads_devcom_init(struct mlx5_eswitch *esw)
 {
 	struct mlx5_devcom *devcom = esw->dev->priv.devcom;
 
@@ -2802,7 +2802,7 @@ static void esw_offloads_devcom_init(struct mlx5_eswitch *esw)
 			       ESW_OFFLOADS_DEVCOM_PAIR, esw);
 }
 
-static void esw_offloads_devcom_cleanup(struct mlx5_eswitch *esw)
+void mlx5_esw_offloads_devcom_cleanup(struct mlx5_eswitch *esw)
 {
 	struct mlx5_devcom *devcom = esw->dev->priv.devcom;
 
@@ -3250,8 +3250,6 @@ int esw_offloads_enable(struct mlx5_eswitch *esw)
 	if (err)
 		goto err_vports;
 
-	esw_offloads_devcom_init(esw);
-
 	return 0;
 
 err_vports:
@@ -3292,7 +3290,6 @@ static int esw_offloads_stop(struct mlx5_eswitch *esw,
 
 void esw_offloads_disable(struct mlx5_eswitch *esw)
 {
-	esw_offloads_devcom_cleanup(esw);
 	mlx5_eswitch_disable_pf_vf_vports(esw);
 	esw_offloads_unload_rep(esw, MLX5_VPORT_UPLINK);
 	esw_set_passing_vport_metadata(esw, false);
-- 
2.40.1


