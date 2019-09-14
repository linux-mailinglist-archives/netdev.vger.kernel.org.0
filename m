Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66D48B2A28
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 08:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbfINGqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 02:46:21 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46822 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726707AbfINGqT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Sep 2019 02:46:19 -0400
Received: by mail-wr1-f65.google.com with SMTP id o18so2806476wrv.13
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 23:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3rLQMBXGkFrc5blu2ohoMO3XO4SwoUMPynuFthD5eTc=;
        b=BCsC1U7I4gF2+RAKVG4xGrj/JGZfGt+NjHuwarcilaqX3ZprRsRHFapZORtLlFqc9t
         fvejkMafS3/f7bfHBPgG+sOaAdXt+uRxyWsLcrr+i2e9pabW1txoncal2mjMUAVZ+H8X
         yzhi/N9IaSU64bokWrvjqhSLASkLnP5ci1znn8oOQl9cArC4VewmWbEj9e59+Qkyb90Y
         o0iPIInP+ONsAXDBut8ACeQlbzP7NZX59xAm+HkzulYl/b/ZH+lQRehFJ43f0sdB4bGF
         /HOs7qOXCJW1mHzl/AN/wNyy/aP21z/OzFqhdEWpLtgs8ou45BYe/UnLgC7OTlOqAkXF
         7g4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3rLQMBXGkFrc5blu2ohoMO3XO4SwoUMPynuFthD5eTc=;
        b=ZkYSjf6f0qInqd8veE3sHUCrjNTJDorD1ytldLE0eBPnKVQVDVx4BKrDGMWuw4iq4x
         w7V3WbcjGqrJlojTmBl339pYQuHWi+hIvB48ZB9yNzxj7DAhHl8v1XP7965ZQf1o+EyN
         I5wx2r1ts1JG4kJumsYkEXAwvXcuAMybC0bYPFA8QDmJ13/fRxI2SwH7nQjQ/r2zANjL
         3KPLQVPlrT694OwvMfgcpKqBOJ+G/zbQ7Xz7FLsshfw55nzV+jfn5PnKEQ+VCboZueY7
         6D9RVP1m47Est/+/kMsSZTdihdEy4HSCOODudyeezXJOtjN9mrH7GjxoCI92QjBsfug2
         fdyA==
X-Gm-Message-State: APjAAAW5tVkC+Z/Z61V7P7aVvq/8THGb/CiAlEYdjuyKmuwtlVLytU0P
        fa3IOIBmFoipHPMjlh5p0lqWOVsP5xI=
X-Google-Smtp-Source: APXvYqyd5t/pliCKyCQoZHCPxFyBHIEz4uVJJ07nnnoduDwm3GTbBqw9izrKu1Kkrw7KXlLp7gxEDQ==
X-Received: by 2002:adf:904f:: with SMTP id h73mr886167wrh.128.1568443577451;
        Fri, 13 Sep 2019 23:46:17 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id e20sm60962373wrc.34.2019.09.13.23.46.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Sep 2019 23:46:16 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        saeedm@mellanox.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, mlxsw@mellanox.com
Subject: [patch net-next 07/15] mlxsw: spectrum: Take devlink net instead of init_net
Date:   Sat, 14 Sep 2019 08:46:00 +0200
Message-Id: <20190914064608.26799-8-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190914064608.26799-1-jiri@resnulli.us>
References: <20190914064608.26799-1-jiri@resnulli.us>
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
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  6 +++++
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  6 +++++
 .../ethernet/mellanox/mlxsw/spectrum_nve.c    |  2 +-
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 27 +++++++++++--------
 .../mellanox/mlxsw/spectrum_switchdev.c       |  2 +-
 5 files changed, 30 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index b65a17d49e43..693b3c5ab355 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -11,6 +11,7 @@
 #include <linux/types.h>
 #include <linux/skbuff.h>
 #include <linux/workqueue.h>
+#include <linux/net_namespace.h>
 #include <net/devlink.h>
 
 #include "trap.h"
@@ -345,6 +346,11 @@ u64 mlxsw_core_res_get(struct mlxsw_core *mlxsw_core,
 #define MLXSW_CORE_RES_GET(mlxsw_core, short_res_id)			\
 	mlxsw_core_res_get(mlxsw_core, MLXSW_RES_ID_##short_res_id)
 
+static inline struct net *mlxsw_core_net(struct mlxsw_core *mlxsw_core)
+{
+	return devlink_net(priv_to_devlink(mlxsw_core));
+}
+
 #define MLXSW_BUS_F_TXRX	BIT(0)
 #define MLXSW_BUS_F_RESET	BIT(1)
 
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
index 5d2cdb9d7d16..a1c06889178c 100644
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

