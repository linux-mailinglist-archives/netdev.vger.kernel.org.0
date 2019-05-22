Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3972701C
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 22:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730415AbfEVTWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:22:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:42970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730399AbfEVTWT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 15:22:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 903CF2186A;
        Wed, 22 May 2019 19:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558552938;
        bh=dhFMV9qvLi/ZkAM71bphlJObVyLSfI97rd7uk47wU/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EnvWDYgjSNO+zpvCBtTXgfY0nXROgWVRLZKHqiH86W7vm6w+oPS4I7LyKeqYQmUD3
         iuKVS0S01Yz29B+1j2+1YnmNP2nQnb8vDCGRIX9yUgiuX45N+zYF1KJH8oGnfSex++
         AprZR5qecyWR0FnANDYVte8XxyVzlN+5etGSA304=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bodong Wang <bodong@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Vu Pham <vuhuong@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 040/375] net/mlx5: E-Switch, Use atomic rep state to serialize state change
Date:   Wed, 22 May 2019 15:15:40 -0400
Message-Id: <20190522192115.22666-40-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192115.22666-1-sashal@kernel.org>
References: <20190522192115.22666-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bodong Wang <bodong@mellanox.com>

[ Upstream commit 6f4e02193c9a9ea54dd3151cf97489fa787cd0e6 ]

When the state of rep was introduced, it was also designed to prevent
duplicate unloading of the same rep. Considering the following two
flows when an eswitch manager is at switchdev mode with n VF reps loaded.

+--------------------------------------+--------------------------------+
| cpu-0                                | cpu-1                          |
| --------                             | --------                       |
| mlx5_ib_remove                       | mlx5_eswitch_disable_sriov     |
|  mlx5_ib_unregister_vport_reps       |  esw_offloads_cleanup          |
|   mlx5_eswitch_unregister_vport_reps |   esw_offloads_unload_all_reps |
|    __unload_reps_all_vport           |    __unload_reps_all_vport     |
+--------------------------------------+--------------------------------+

These two flows will try to unload the same rep. Per original design,
once one flow unloads the rep, the state moves to REGISTERED. The 2nd
flow will no longer needs to do the unload and bails out. However, as
read and write of the state is not atomic, when 1st flow is doing the
unload, the state is still LOADED, 2nd flow is able to do the same
unload action. Kernel crash will happen.

To solve this, driver should do atomic test-and-set for the state. So
that only one flow can change the rep state from LOADED to REGISTERED,
and proceed to do the actual unloading.

Since the state is changing to atomic type, all other read/write should
be atomic action as well.

Fixes: f121e0ea9586 (net/mlx5: E-Switch, Add state to eswitch vport representors)
Signed-off-by: Bodong Wang <bodong@mellanox.com>
Reviewed-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Vu Pham <vuhuong@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/eswitch_offloads.c     | 36 +++++++++----------
 include/linux/mlx5/eswitch.h                  |  2 +-
 2 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 9b2d78ee22b88..d2d8da133082c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -363,7 +363,7 @@ static int esw_set_global_vlan_pop(struct mlx5_eswitch *esw, u8 val)
 	esw_debug(esw->dev, "%s applying global %s policy\n", __func__, val ? "pop" : "none");
 	for (vf_vport = 1; vf_vport < esw->enabled_vports; vf_vport++) {
 		rep = &esw->offloads.vport_reps[vf_vport];
-		if (rep->rep_if[REP_ETH].state != REP_LOADED)
+		if (atomic_read(&rep->rep_if[REP_ETH].state) != REP_LOADED)
 			continue;
 
 		err = __mlx5_eswitch_set_vport_vlan(esw, rep->vport, 0, 0, val);
@@ -1306,7 +1306,8 @@ int esw_offloads_init_reps(struct mlx5_eswitch *esw)
 		ether_addr_copy(rep->hw_id, hw_id);
 
 		for (rep_type = 0; rep_type < NUM_REP_TYPES; rep_type++)
-			rep->rep_if[rep_type].state = REP_UNREGISTERED;
+			atomic_set(&rep->rep_if[rep_type].state,
+				   REP_UNREGISTERED);
 	}
 
 	return 0;
@@ -1315,11 +1316,9 @@ int esw_offloads_init_reps(struct mlx5_eswitch *esw)
 static void __esw_offloads_unload_rep(struct mlx5_eswitch *esw,
 				      struct mlx5_eswitch_rep *rep, u8 rep_type)
 {
-	if (rep->rep_if[rep_type].state != REP_LOADED)
-		return;
-
-	rep->rep_if[rep_type].unload(rep);
-	rep->rep_if[rep_type].state = REP_REGISTERED;
+	if (atomic_cmpxchg(&rep->rep_if[rep_type].state,
+			   REP_LOADED, REP_REGISTERED) == REP_LOADED)
+		rep->rep_if[rep_type].unload(rep);
 }
 
 static void __unload_reps_special_vport(struct mlx5_eswitch *esw, u8 rep_type)
@@ -1380,16 +1379,15 @@ static int __esw_offloads_load_rep(struct mlx5_eswitch *esw,
 {
 	int err = 0;
 
-	if (rep->rep_if[rep_type].state != REP_REGISTERED)
-		return 0;
-
-	err = rep->rep_if[rep_type].load(esw->dev, rep);
-	if (err)
-		return err;
-
-	rep->rep_if[rep_type].state = REP_LOADED;
+	if (atomic_cmpxchg(&rep->rep_if[rep_type].state,
+			   REP_REGISTERED, REP_LOADED) == REP_REGISTERED) {
+		err = rep->rep_if[rep_type].load(esw->dev, rep);
+		if (err)
+			atomic_set(&rep->rep_if[rep_type].state,
+				   REP_REGISTERED);
+	}
 
-	return 0;
+	return err;
 }
 
 static int __load_reps_special_vport(struct mlx5_eswitch *esw, u8 rep_type)
@@ -2076,7 +2074,7 @@ void mlx5_eswitch_register_vport_reps(struct mlx5_eswitch *esw,
 		rep_if->get_proto_dev = __rep_if->get_proto_dev;
 		rep_if->priv = __rep_if->priv;
 
-		rep_if->state = REP_REGISTERED;
+		atomic_set(&rep_if->state, REP_REGISTERED);
 	}
 }
 EXPORT_SYMBOL(mlx5_eswitch_register_vport_reps);
@@ -2091,7 +2089,7 @@ void mlx5_eswitch_unregister_vport_reps(struct mlx5_eswitch *esw, u8 rep_type)
 		__unload_reps_all_vport(esw, max_vf, rep_type);
 
 	mlx5_esw_for_all_reps(esw, i, rep)
-		rep->rep_if[rep_type].state = REP_UNREGISTERED;
+		atomic_set(&rep->rep_if[rep_type].state, REP_UNREGISTERED);
 }
 EXPORT_SYMBOL(mlx5_eswitch_unregister_vport_reps);
 
@@ -2111,7 +2109,7 @@ void *mlx5_eswitch_get_proto_dev(struct mlx5_eswitch *esw,
 
 	rep = mlx5_eswitch_get_rep(esw, vport);
 
-	if (rep->rep_if[rep_type].state == REP_LOADED &&
+	if (atomic_read(&rep->rep_if[rep_type].state) == REP_LOADED &&
 	    rep->rep_if[rep_type].get_proto_dev)
 		return rep->rep_if[rep_type].get_proto_dev(rep);
 	return NULL;
diff --git a/include/linux/mlx5/eswitch.h b/include/linux/mlx5/eswitch.h
index 96d8435421de8..0ca77dd1429c0 100644
--- a/include/linux/mlx5/eswitch.h
+++ b/include/linux/mlx5/eswitch.h
@@ -35,7 +35,7 @@ struct mlx5_eswitch_rep_if {
 	void		       (*unload)(struct mlx5_eswitch_rep *rep);
 	void		       *(*get_proto_dev)(struct mlx5_eswitch_rep *rep);
 	void			*priv;
-	u8			state;
+	atomic_t		state;
 };
 
 struct mlx5_eswitch_rep {
-- 
2.20.1

