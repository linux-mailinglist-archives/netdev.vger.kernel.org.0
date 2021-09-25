Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D98741815E
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 13:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244997AbhIYLZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 07:25:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:56016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245045AbhIYLZF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Sep 2021 07:25:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A281B6127C;
        Sat, 25 Sep 2021 11:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632569010;
        bh=pc8zwS3r8HsfwOxk/n265zyCXchtl5rU8VYtSBAYXS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XYVdSyk4Nov6ULK/fPAslkGEtxWs0lZ0lQ/xfjQJBfscVFxRhWcOjoJwGYAe3satN
         8otZtplAxDDhaNxERQKpq4F5wivWdImoSGdiUEjg4zXYIBpMRoa2bdDUpJGmNmgW71
         hpwFL/LKTPg4zAqy+Vpi1KFY5mrg0eDX1+zEsBSyoYzlimYAkMM6nlCYEXnESWKD+5
         hR7FPTAGNobhoUjByJKm8aaWrF0iFNv4F0o7emLxQvym3sK9pGu0/MhhTqiNbazSCD
         5+t8qDq7tx8Mm/fxLtgCvBT4lUN+5qTi9rwAt7SWJcT5MuB7K5KAZ/tPg0jWvkOHAK
         F+PsGCvrkN1fA==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, Ariel Elior <aelior@marvell.com>,
        Bin Luo <luobin9@huawei.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Coiby Xu <coiby.xu@gmail.com>,
        Derek Chickles <dchickles@marvell.com>, drivers@pensando.io,
        Felix Manlunas <fmanlunas@marvell.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        GR-everest-linux-l2@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        hariprasad <hkelam@marvell.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Intel Corporation <linuxwwan@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jerin Jacob <jerinj@marvell.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Linu Cherian <lcherian@marvell.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-staging@lists.linux.dev,
        Loic Poulain <loic.poulain@linaro.org>,
        Manish Chopra <manishc@marvell.com>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Michael Guralnik <michaelgur@mellanox.com>,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        Richard Cochran <richardcochran@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Satanand Burla <sburla@marvell.com>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Shannon Nelson <snelson@pensando.io>,
        Simon Horman <simon.horman@corigine.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next v1 08/21] net/prestera: Split devlink and traps registrations to separate routines
Date:   Sat, 25 Sep 2021 14:22:48 +0300
Message-Id: <0e3101259046a001c417415b84b834ca56d1bfd3.1632565508.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1632565508.git.leonro@nvidia.com>
References: <cover.1632565508.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Separate devlink registrations and traps registrations so devlink will
be registered when driver is fully initialized.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../marvell/prestera/prestera_devlink.c       | 29 ++++---------------
 .../marvell/prestera/prestera_devlink.h       |  4 ++-
 .../ethernet/marvell/prestera/prestera_main.c |  8 +++--
 3 files changed, 14 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_devlink.c b/drivers/net/ethernet/marvell/prestera/prestera_devlink.c
index 5cca007a3e17..06279cd6da67 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_devlink.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_devlink.c
@@ -345,8 +345,6 @@ static struct prestera_trap prestera_trap_items_arr[] = {
 	},
 };
 
-static void prestera_devlink_traps_fini(struct prestera_switch *sw);
-
 static int prestera_drop_counter_get(struct devlink *devlink,
 				     const struct devlink_trap *trap,
 				     u64 *p_drops);
@@ -381,8 +379,6 @@ static int prestera_trap_action_set(struct devlink *devlink,
 				    enum devlink_trap_action action,
 				    struct netlink_ext_ack *extack);
 
-static int prestera_devlink_traps_register(struct prestera_switch *sw);
-
 static const struct devlink_ops prestera_dl_ops = {
 	.info_get = prestera_dl_info_get,
 	.trap_init = prestera_trap_init,
@@ -407,34 +403,18 @@ void prestera_devlink_free(struct prestera_switch *sw)
 	devlink_free(dl);
 }
 
-int prestera_devlink_register(struct prestera_switch *sw)
+void prestera_devlink_register(struct prestera_switch *sw)
 {
 	struct devlink *dl = priv_to_devlink(sw);
-	int err;
 
 	devlink_register(dl);
-
-	err = prestera_devlink_traps_register(sw);
-	if (err) {
-		devlink_unregister(dl);
-		dev_err(sw->dev->dev, "devlink_traps_register failed: %d\n",
-			err);
-		return err;
-	}
-
-	return 0;
 }
 
 void prestera_devlink_unregister(struct prestera_switch *sw)
 {
-	struct prestera_trap_data *trap_data = sw->trap_data;
 	struct devlink *dl = priv_to_devlink(sw);
 
-	prestera_devlink_traps_fini(sw);
 	devlink_unregister(dl);
-
-	kfree(trap_data->trap_items_arr);
-	kfree(trap_data);
 }
 
 int prestera_devlink_port_register(struct prestera_port *port)
@@ -482,7 +462,7 @@ struct devlink_port *prestera_devlink_get_port(struct net_device *dev)
 	return &port->dl_port;
 }
 
-static int prestera_devlink_traps_register(struct prestera_switch *sw)
+int prestera_devlink_traps_register(struct prestera_switch *sw)
 {
 	const u32 groups_count = ARRAY_SIZE(prestera_trap_groups_arr);
 	const u32 traps_count = ARRAY_SIZE(prestera_trap_items_arr);
@@ -621,8 +601,9 @@ static int prestera_drop_counter_get(struct devlink *devlink,
 						 cpu_code_type, p_drops);
 }
 
-static void prestera_devlink_traps_fini(struct prestera_switch *sw)
+void prestera_devlink_traps_unregister(struct prestera_switch *sw)
 {
+	struct prestera_trap_data *trap_data = sw->trap_data;
 	struct devlink *dl = priv_to_devlink(sw);
 	const struct devlink_trap *trap;
 	int i;
@@ -634,4 +615,6 @@ static void prestera_devlink_traps_fini(struct prestera_switch *sw)
 
 	devlink_trap_groups_unregister(dl, prestera_trap_groups_arr,
 				       ARRAY_SIZE(prestera_trap_groups_arr));
+	kfree(trap_data->trap_items_arr);
+	kfree(trap_data);
 }
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_devlink.h b/drivers/net/ethernet/marvell/prestera/prestera_devlink.h
index cc34c3db13a2..b322295bad3a 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_devlink.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_devlink.h
@@ -9,7 +9,7 @@
 struct prestera_switch *prestera_devlink_alloc(struct prestera_device *dev);
 void prestera_devlink_free(struct prestera_switch *sw);
 
-int prestera_devlink_register(struct prestera_switch *sw);
+void prestera_devlink_register(struct prestera_switch *sw);
 void prestera_devlink_unregister(struct prestera_switch *sw);
 
 int prestera_devlink_port_register(struct prestera_port *port);
@@ -22,5 +22,7 @@ struct devlink_port *prestera_devlink_get_port(struct net_device *dev);
 
 void prestera_devlink_trap_report(struct prestera_port *port,
 				  struct sk_buff *skb, u8 cpu_code);
+int prestera_devlink_traps_register(struct prestera_switch *sw);
+void prestera_devlink_traps_unregister(struct prestera_switch *sw);
 
 #endif /* _PRESTERA_DEVLINK_H_ */
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 44c670807fb3..78a7a00bce22 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -851,7 +851,7 @@ static int prestera_switch_init(struct prestera_switch *sw)
 	if (err)
 		goto err_span_init;
 
-	err = prestera_devlink_register(sw);
+	err = prestera_devlink_traps_register(sw);
 	if (err)
 		goto err_dl_register;
 
@@ -863,12 +863,13 @@ static int prestera_switch_init(struct prestera_switch *sw)
 	if (err)
 		goto err_ports_create;
 
+	prestera_devlink_register(sw);
 	return 0;
 
 err_ports_create:
 	prestera_lag_fini(sw);
 err_lag_init:
-	prestera_devlink_unregister(sw);
+	prestera_devlink_traps_unregister(sw);
 err_dl_register:
 	prestera_span_fini(sw);
 err_span_init:
@@ -888,9 +889,10 @@ static int prestera_switch_init(struct prestera_switch *sw)
 
 static void prestera_switch_fini(struct prestera_switch *sw)
 {
+	prestera_devlink_unregister(sw);
 	prestera_destroy_ports(sw);
 	prestera_lag_fini(sw);
-	prestera_devlink_unregister(sw);
+	prestera_devlink_traps_unregister(sw);
 	prestera_span_fini(sw);
 	prestera_acl_fini(sw);
 	prestera_event_handlers_unregister(sw);
-- 
2.31.1

