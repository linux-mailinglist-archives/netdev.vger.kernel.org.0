Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6EA2C9B09
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 11:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729330AbfJCJt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 05:49:56 -0400
Received: from mail-wm1-f45.google.com ([209.85.128.45]:33534 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729299AbfJCJty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 05:49:54 -0400
Received: by mail-wm1-f45.google.com with SMTP id r17so6870555wme.0
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 02:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=J4u4bSlPc8DSXSOGofoupAdXFaD4t05KQi8uYC22nDY=;
        b=ImGRnRmlcTS2bxm5xeL+fCr07Y2yTXXLdVsdDX5KBjuNRFc1i3wPcg6FWerAhwukkD
         ulvMelXSRV7eH1H/qz0WdIBUf9MlJKWEc521JvzPZ1wUj3RhxN7uO0Bh0/a+Rw1vwxE8
         YIPDxDzbReuQlMcwteV1rFy5GIzX9tCqZwSnK409Gwprec+SvsL7xHGM6jmKSPJcjgp9
         7qEu4HYSdR8Iz6LVhaOrD5uBiOPIgDr0C79LqmXSZui/uonrjQSyXuhByWDCrTKurxhi
         hdQFr3c/AujfblOneghSxpPwyCn2vIiZMM68egzpomLNieqxWhe/Ymkmlg146spgIQh/
         il3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J4u4bSlPc8DSXSOGofoupAdXFaD4t05KQi8uYC22nDY=;
        b=QT4jVxvhtzddHTkjbI7Z6hm03ihCBHevHkaJJztMOLJJF2y6QSLVDd+bmlyfFTPkuU
         yQSjbxSDRaYH7f1/ugVskdw3aO/OG6zNDdnFbB24ui17fVMj4nt+KJYC2NPxS5pona9i
         guraWFtEqPstsLKYcelXb0rvbstPEvZ1Z19Rqs9+KY8ZCU7VlwAGVtaHqcKmL8vRj54Z
         aL+ZW5vRKH2s1f08lJFDwYsYvIQ74a4b4GQ4lfJ6nqj1CNwJCYTR7yltAXkP2qzAxBVn
         40SCNOrROT7TjP+BPue/dXG6icux6ZAd+qdOAmXZyacY9sRbdXO+Pt/IU04KH3Dmi32A
         j/dA==
X-Gm-Message-State: APjAAAVrtjAs0DS2aHq/29g4GLssGMY1HzjwkTmaWhS9bK7XPwV8mLN5
        eFMBjrzHbs1SLU2J/cBOMEd5AAfW474=
X-Google-Smtp-Source: APXvYqwryw7XtlL7d5XEMCtmffWCuy0QXDYFJont+XFC3rtbA2C8kJV0OaGtAcEXg6FdGOMdobfXJw==
X-Received: by 2002:a1c:3182:: with SMTP id x124mr6693972wmx.168.1570096190329;
        Thu, 03 Oct 2019 02:49:50 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id b186sm3807413wmd.16.2019.10.03.02.49.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 02:49:50 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        saeedm@mellanox.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, mlxsw@mellanox.com
Subject: [patch net-next v3 07/15] mlxsw: spectrum: Take devlink net instead of init_net
Date:   Thu,  3 Oct 2019 11:49:32 +0200
Message-Id: <20191003094940.9797-8-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191003094940.9797-1-jiri@resnulli.us>
References: <20191003094940.9797-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Follow-up patch is going to allow to reload devlink instance into
different network namespace, so use devlink_net() helper instead
of init_net.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v1->v2:
- change forgotten init_net usage in mlxsw_sp_router_fib_rule_event()
- rebased on top of per-netns netdevice notifier patch
---
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  6 ++++
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  6 ++--
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  6 ++++
 .../ethernet/mellanox/mlxsw/spectrum_nve.c    |  2 +-
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 29 +++++++++++--------
 .../mellanox/mlxsw/spectrum_switchdev.c       |  2 +-
 6 files changed, 34 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index 5d7d2ab6d155..e1ef4d255b93 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -11,6 +11,7 @@
 #include <linux/types.h>
 #include <linux/skbuff.h>
 #include <linux/workqueue.h>
+#include <linux/net_namespace.h>
 #include <net/devlink.h>
 
 #include "trap.h"
@@ -350,6 +351,11 @@ u64 mlxsw_core_res_get(struct mlxsw_core *mlxsw_core,
 #define MLXSW_CORE_RES_GET(mlxsw_core, short_res_id)			\
 	mlxsw_core_res_get(mlxsw_core, MLXSW_RES_ID_##short_res_id)
 
+static inline struct net *mlxsw_core_net(struct mlxsw_core *mlxsw_core)
+{
+	return devlink_net(priv_to_devlink(mlxsw_core));
+}
+
 #define MLXSW_BUS_F_TXRX	BIT(0)
 #define MLXSW_BUS_F_RESET	BIT(1)
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index a54a0dc82ff2..250448aecd67 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4864,7 +4864,7 @@ static int mlxsw_sp_init(struct mlxsw_core *mlxsw_core,
 	 * respin.
 	 */
 	mlxsw_sp->netdevice_nb.notifier_call = mlxsw_sp_netdevice_event;
-	err = register_netdevice_notifier_net(&init_net,
+	err = register_netdevice_notifier_net(mlxsw_sp_net(mlxsw_sp),
 					      &mlxsw_sp->netdevice_nb);
 	if (err) {
 		dev_err(mlxsw_sp->bus_info->dev, "Failed to register netdev notifier\n");
@@ -4888,7 +4888,7 @@ static int mlxsw_sp_init(struct mlxsw_core *mlxsw_core,
 err_ports_create:
 	mlxsw_sp_dpipe_fini(mlxsw_sp);
 err_dpipe_init:
-	unregister_netdevice_notifier_net(&init_net,
+	unregister_netdevice_notifier_net(mlxsw_sp_net(mlxsw_sp),
 					  &mlxsw_sp->netdevice_nb);
 err_netdev_notifier:
 	if (mlxsw_sp->clock)
@@ -4975,7 +4975,7 @@ static void mlxsw_sp_fini(struct mlxsw_core *mlxsw_core)
 
 	mlxsw_sp_ports_remove(mlxsw_sp);
 	mlxsw_sp_dpipe_fini(mlxsw_sp);
-	unregister_netdevice_notifier_net(&init_net,
+	unregister_netdevice_notifier_net(mlxsw_sp_net(mlxsw_sp),
 					  &mlxsw_sp->netdevice_nb);
 	if (mlxsw_sp->clock) {
 		mlxsw_sp->ptp_ops->fini(mlxsw_sp->ptp_state);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index b2a0028b1694..f58d45e770cd 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -14,6 +14,7 @@
 #include <linux/dcbnl.h>
 #include <linux/in6.h>
 #include <linux/notifier.h>
+#include <linux/net_namespace.h>
 #include <net/psample.h>
 #include <net/pkt_cls.h>
 #include <net/red.h>
@@ -982,4 +983,9 @@ int mlxsw_sp_trap_action_set(struct mlxsw_core *mlxsw_core,
 int mlxsw_sp_trap_group_init(struct mlxsw_core *mlxsw_core,
 			     const struct devlink_trap_group *group);
 
+static inline struct net *mlxsw_sp_net(struct mlxsw_sp *mlxsw_sp)
+{
+	return mlxsw_core_net(mlxsw_sp->core);
+}
+
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c
index 17f334b46c40..2153bcc4b585 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c
@@ -870,7 +870,7 @@ void mlxsw_sp_nve_fid_disable(struct mlxsw_sp *mlxsw_sp,
 		    mlxsw_sp_fid_vni(fid, &vni)))
 		goto out;
 
-	nve_dev = dev_get_by_index(&init_net, nve_ifindex);
+	nve_dev = dev_get_by_index(mlxsw_sp_net(mlxsw_sp), nve_ifindex);
 	if (!nve_dev)
 		goto out;
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 445e2daa54ac..3479f805b377 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -16,6 +16,7 @@
 #include <linux/if_macvlan.h>
 #include <linux/refcount.h>
 #include <linux/jhash.h>
+#include <linux/net_namespace.h>
 #include <net/netevent.h>
 #include <net/neighbour.h>
 #include <net/arp.h>
@@ -2551,14 +2552,14 @@ static int mlxsw_sp_router_schedule_work(struct net *net,
 	struct mlxsw_sp_netevent_work *net_work;
 	struct mlxsw_sp_router *router;
 
-	if (!net_eq(net, &init_net))
+	router = container_of(nb, struct mlxsw_sp_router, netevent_nb);
+	if (!net_eq(net, mlxsw_sp_net(router->mlxsw_sp)))
 		return NOTIFY_DONE;
 
 	net_work = kzalloc(sizeof(*net_work), GFP_ATOMIC);
 	if (!net_work)
 		return NOTIFY_BAD;
 
-	router = container_of(nb, struct mlxsw_sp_router, netevent_nb);
 	INIT_WORK(&net_work->work, cb);
 	net_work->mlxsw_sp = router->mlxsw_sp;
 	mlxsw_core_schedule_work(&net_work->work);
@@ -6195,7 +6196,7 @@ static int mlxsw_sp_router_fib_rule_event(unsigned long event,
 	rule = fr_info->rule;
 
 	/* Rule only affects locally generated traffic */
-	if (rule->iifindex == init_net.loopback_dev->ifindex)
+	if (rule->iifindex == mlxsw_sp_net(mlxsw_sp)->loopback_dev->ifindex)
 		return 0;
 
 	switch (info->family) {
@@ -7953,9 +7954,10 @@ static void mlxsw_sp_mp_hash_field_set(char *recr2_pl, int field)
 	mlxsw_reg_recr2_outer_header_fields_enable_set(recr2_pl, field, true);
 }
 
-static void mlxsw_sp_mp4_hash_init(char *recr2_pl)
+static void mlxsw_sp_mp4_hash_init(struct mlxsw_sp *mlxsw_sp, char *recr2_pl)
 {
-	bool only_l3 = !init_net.ipv4.sysctl_fib_multipath_hash_policy;
+	struct net *net = mlxsw_sp_net(mlxsw_sp);
+	bool only_l3 = !net->ipv4.sysctl_fib_multipath_hash_policy;
 
 	mlxsw_sp_mp_hash_header_set(recr2_pl,
 				    MLXSW_REG_RECR2_IPV4_EN_NOT_TCP_NOT_UDP);
@@ -7970,9 +7972,9 @@ static void mlxsw_sp_mp4_hash_init(char *recr2_pl)
 	mlxsw_sp_mp_hash_field_set(recr2_pl, MLXSW_REG_RECR2_TCP_UDP_DPORT);
 }
 
-static void mlxsw_sp_mp6_hash_init(char *recr2_pl)
+static void mlxsw_sp_mp6_hash_init(struct mlxsw_sp *mlxsw_sp, char *recr2_pl)
 {
-	bool only_l3 = !ip6_multipath_hash_policy(&init_net);
+	bool only_l3 = !ip6_multipath_hash_policy(mlxsw_sp_net(mlxsw_sp));
 
 	mlxsw_sp_mp_hash_header_set(recr2_pl,
 				    MLXSW_REG_RECR2_IPV6_EN_NOT_TCP_NOT_UDP);
@@ -8000,8 +8002,8 @@ static int mlxsw_sp_mp_hash_init(struct mlxsw_sp *mlxsw_sp)
 
 	seed = jhash(mlxsw_sp->base_mac, sizeof(mlxsw_sp->base_mac), 0);
 	mlxsw_reg_recr2_pack(recr2_pl, seed);
-	mlxsw_sp_mp4_hash_init(recr2_pl);
-	mlxsw_sp_mp6_hash_init(recr2_pl);
+	mlxsw_sp_mp4_hash_init(mlxsw_sp, recr2_pl);
+	mlxsw_sp_mp6_hash_init(mlxsw_sp, recr2_pl);
 
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(recr2), recr2_pl);
 }
@@ -8032,7 +8034,8 @@ static int mlxsw_sp_dscp_init(struct mlxsw_sp *mlxsw_sp)
 
 static int __mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp)
 {
-	bool usp = init_net.ipv4.sysctl_ip_fwd_update_priority;
+	struct net *net = mlxsw_sp_net(mlxsw_sp);
+	bool usp = net->ipv4.sysctl_ip_fwd_update_priority;
 	char rgcr_pl[MLXSW_REG_RGCR_LEN];
 	u64 max_rifs;
 	int err;
@@ -8134,7 +8137,8 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp)
 		goto err_dscp_init;
 
 	mlxsw_sp->router->fib_nb.notifier_call = mlxsw_sp_router_fib_event;
-	err = register_fib_notifier(&init_net, &mlxsw_sp->router->fib_nb,
+	err = register_fib_notifier(mlxsw_sp_net(mlxsw_sp),
+				    &mlxsw_sp->router->fib_nb,
 				    mlxsw_sp_router_fib_dump_flush, NULL);
 	if (err)
 		goto err_register_fib_notifier;
@@ -8174,7 +8178,8 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp)
 
 void mlxsw_sp_router_fini(struct mlxsw_sp *mlxsw_sp)
 {
-	unregister_fib_notifier(&init_net, &mlxsw_sp->router->fib_nb);
+	unregister_fib_notifier(mlxsw_sp_net(mlxsw_sp),
+				&mlxsw_sp->router->fib_nb);
 	unregister_netevent_notifier(&mlxsw_sp->router->netevent_nb);
 	mlxsw_sp_neigh_fini(mlxsw_sp);
 	mlxsw_sp_vrs_fini(mlxsw_sp);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 5ecb45118400..a3af171c6358 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -2591,7 +2591,7 @@ __mlxsw_sp_fdb_notify_mac_uc_tunnel_process(struct mlxsw_sp *mlxsw_sp,
 	if (err)
 		return err;
 
-	dev = __dev_get_by_index(&init_net, nve_ifindex);
+	dev = __dev_get_by_index(mlxsw_sp_net(mlxsw_sp), nve_ifindex);
 	if (!dev)
 		return -EINVAL;
 	*nve_dev = dev;
-- 
2.21.0

