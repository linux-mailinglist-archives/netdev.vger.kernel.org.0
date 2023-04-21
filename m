Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8256EA11D
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 03:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233271AbjDUBjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 21:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233081AbjDUBjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 21:39:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C840865BC
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 18:39:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66EF262D29
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 01:39:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 572BEC4339B;
        Fri, 21 Apr 2023 01:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682041172;
        bh=YrM9yQ4hVpZ3hjzTIDxWqNyla9IuMxm/QguPGzyaAV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X7RSwCDhYJjRiDHOB0JFOlI0D8AljNyJ5TmbrSyKKyE2UwV4NbGsKu+T8Ld8u0iD3
         EpfbcjYsQzzaPgMDKGHnfTAin+tU7GQ3oCt7SUra49P/O4fqPgvYy+PGdD3yelouqL
         tu55bzo7re0Vsa0b8kQsYFS478/VX5oeJzZr0ddBT0jto+nLt4gQo779Ovm8ZbxoGR
         S8f6GqNPT0lQ6wEzK5yCgOkvUV18VsyiMWPi82BK1yGFGWFzIoXEEhvRNbpfvFHQcc
         2rlXYZ8v9IzM7892DUMIajIhOXmnSSWpHcwvrwqtvtU7Mv3Pv4JtzGlGfRzPkJ2dBe
         BpznaI5Oda0Tw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maher Sanalla <msanalla@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [net-next 08/15] net/mlx5e: Add vnic devlink health reporter to representors
Date:   Thu, 20 Apr 2023 18:38:43 -0700
Message-Id: <20230421013850.349646-9-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230421013850.349646-1-saeed@kernel.org>
References: <20230421013850.349646-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maher Sanalla <msanalla@nvidia.com>

Create a new devlink health reporter for representor interface, which
reports the values of representor vnic diagnostic counters when diagnosed.

This patch will allow admins to monitor VF diagnostic counters through
the representor-interface vnic reporter.

Example of usage:
$ devlink health diagnose pci/0000:08:00.0/65537 reporter vnic
  vNIC env counters:
    total_error_queues: 0 send_queue_priority_update_flow: 0
    comp_eq_overrun: 0 async_eq_overrun: 0 cq_overrun: 0
    invalid_command: 0 quota_exceeded_command: 0
    nic_receive_steering_discard: 0

Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/devlink.rst        |  5 +-
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 52 ++++++++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/en_rep.h  |  1 +
 3 files changed, 55 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst
index ceab18e46456..3a7a714cc08f 100644
--- a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst
+++ b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst
@@ -285,5 +285,8 @@ steering but were discarded due to a mismatch in flow table.
 User commands examples:
 - Diagnose PF/VF vnic counters
         $ devlink health diagnose pci/0000:82:00.1 reporter vnic
+- Diagnose representor vnic counters (performed by supplying devlink port of the
+  representor, which can be obtained via devlink port command)
+        $ devlink health diagnose pci/0000:82:00.1/65537 reporter vnic
 
-NOTE: This command can run only on PF/VF ports.
+NOTE: This command can run over all interfaces such as PF/VF and representor ports.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 8ff654b4e9e1..2d87068f63fd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -53,6 +53,7 @@
 #include "lib/vxlan.h"
 #define CREATE_TRACE_POINTS
 #include "diag/en_rep_tracepoint.h"
+#include "diag/reporter_vnic.h"
 #include "en_accel/ipsec.h"
 #include "en/tc/int_port.h"
 #include "en/ptp.h"
@@ -1294,6 +1295,50 @@ static unsigned int mlx5e_ul_rep_stats_grps_num(struct mlx5e_priv *priv)
 	return ARRAY_SIZE(mlx5e_ul_rep_stats_grps);
 }
 
+static int
+mlx5e_rep_vnic_reporter_diagnose(struct devlink_health_reporter *reporter,
+				 struct devlink_fmsg *fmsg,
+				 struct netlink_ext_ack *extack)
+{
+	struct mlx5e_rep_priv *rpriv = devlink_health_reporter_priv(reporter);
+	struct mlx5_eswitch_rep *rep = rpriv->rep;
+
+	return mlx5_reporter_vnic_diagnose_counters(rep->esw->dev, fmsg,
+						    rep->vport, true);
+}
+
+static const struct devlink_health_reporter_ops mlx5_rep_vnic_reporter_ops = {
+	.name = "vnic",
+	.diagnose = mlx5e_rep_vnic_reporter_diagnose,
+};
+
+static void mlx5e_rep_vnic_reporter_create(struct mlx5e_priv *priv,
+					   struct devlink_port *dl_port)
+{
+	struct mlx5e_rep_priv *rpriv = priv->ppriv;
+	struct devlink_health_reporter *reporter;
+
+	reporter = devl_port_health_reporter_create(dl_port,
+						    &mlx5_rep_vnic_reporter_ops,
+						    0, rpriv);
+	if (IS_ERR(reporter)) {
+		mlx5_core_err(priv->mdev,
+			      "Failed to create representor vnic reporter, err = %ld\n",
+			      PTR_ERR(reporter));
+		return;
+	}
+
+	rpriv->rep_vnic_reporter = reporter;
+}
+
+static void mlx5e_rep_vnic_reporter_destroy(struct mlx5e_priv *priv)
+{
+	struct mlx5e_rep_priv *rpriv = priv->ppriv;
+
+	if (!IS_ERR_OR_NULL(rpriv->rep_vnic_reporter))
+		devl_health_reporter_destroy(rpriv->rep_vnic_reporter);
+}
+
 static const struct mlx5e_profile mlx5e_rep_profile = {
 	.init			= mlx5e_init_rep,
 	.cleanup		= mlx5e_cleanup_rep,
@@ -1394,8 +1439,10 @@ mlx5e_vport_vf_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 
 	dl_port = mlx5_esw_offloads_devlink_port(dev->priv.eswitch,
 						 rpriv->rep->vport);
-	if (dl_port)
+	if (dl_port) {
 		SET_NETDEV_DEVLINK_PORT(netdev, dl_port);
+		mlx5e_rep_vnic_reporter_create(priv, dl_port);
+	}
 
 	err = register_netdev(netdev);
 	if (err) {
@@ -1408,8 +1455,8 @@ mlx5e_vport_vf_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 	return 0;
 
 err_detach_netdev:
+	mlx5e_rep_vnic_reporter_destroy(priv);
 	mlx5e_detach_netdev(netdev_priv(netdev));
-
 err_cleanup_profile:
 	priv->profile->cleanup(priv);
 
@@ -1458,6 +1505,7 @@ mlx5e_vport_rep_unload(struct mlx5_eswitch_rep *rep)
 	}
 
 	unregister_netdev(netdev);
+	mlx5e_rep_vnic_reporter_destroy(priv);
 	mlx5e_detach_netdev(priv);
 	priv->profile->cleanup(priv);
 	mlx5e_destroy_netdev(priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
index dcfad0bf0f45..80b7f5079a5a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -118,6 +118,7 @@ struct mlx5e_rep_priv {
 	struct rtnl_link_stats64 prev_vf_vport_stats;
 	struct mlx5_flow_handle *send_to_vport_meta_rule;
 	struct rhashtable tc_ht;
+	struct devlink_health_reporter *rep_vnic_reporter;
 };
 
 static inline
-- 
2.39.2

