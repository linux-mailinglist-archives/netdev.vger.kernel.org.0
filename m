Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7712795C1
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 02:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729903AbgIZA5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 20:57:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:47354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729846AbgIZA45 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 20:56:57 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1A8A2344C;
        Sat, 26 Sep 2020 00:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601081816;
        bh=PMhTMyN/lEjagOllt92jSzzJdYe0eYq7V3pPPJ4ezHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0I40HfV7UZjH/rCbMQ7zWx8mf7HTuPLBGqOIPip53h3zgHKYWAgQifitM530dwiZc
         4MlvRJQPsNlNyXWWqGsm5TLjh1C5wquhXGB7eXiS4QykHpQks1w4HI3x4GvL/VamME
         wmISWlcc8uatR32wit/kR1gE7vq3Q8XjnWJA0jSs=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 03/10] netdevsim: shared UDP tunnel port table support
Date:   Fri, 25 Sep 2020 17:56:42 -0700
Message-Id: <20200926005649.3285089-4-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200926005649.3285089-1-kuba@kernel.org>
References: <20200926005649.3285089-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the ability to simulate a device with a shared UDP tunnel port
table.

Try to reject the configurations and actions which are not supported
by the core, so we don't get syzcaller etc. warning reports.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/netdevsim/netdevsim.h   |  7 ++++++-
 drivers/net/netdevsim/udp_tunnels.c | 17 ++++++++++++++++-
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 0c86561e6d8d..11c840835517 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -20,6 +20,7 @@
 #include <linux/netdevice.h>
 #include <linux/u64_stats_sync.h>
 #include <net/devlink.h>
+#include <net/udp_tunnel.h>
 #include <net/xdp.h>
 
 #define DRV_NAME	"netdevsim"
@@ -84,7 +85,8 @@ struct netdevsim {
 	struct {
 		u32 inject_error;
 		u32 sleep;
-		u32 ports[2][NSIM_UDP_TUNNEL_N_PORTS];
+		u32 __ports[2][NSIM_UDP_TUNNEL_N_PORTS];
+		u32 (*ports)[NSIM_UDP_TUNNEL_N_PORTS];
 		struct debugfs_u32_array dfs_ports[2];
 	} udp_ports;
 
@@ -208,9 +210,12 @@ struct nsim_dev {
 	bool fail_trap_policer_set;
 	bool fail_trap_policer_counter_get;
 	struct {
+		struct udp_tunnel_nic_shared utn_shared;
+		u32 __ports[2][NSIM_UDP_TUNNEL_N_PORTS];
 		bool sync_all;
 		bool open_only;
 		bool ipv4_only;
+		bool shared;
 		u32 sleep;
 	} udp_ports;
 };
diff --git a/drivers/net/netdevsim/udp_tunnels.c b/drivers/net/netdevsim/udp_tunnels.c
index ad65b860bd7b..6b98e6d1188f 100644
--- a/drivers/net/netdevsim/udp_tunnels.c
+++ b/drivers/net/netdevsim/udp_tunnels.c
@@ -112,7 +112,7 @@ nsim_udp_tunnels_info_reset_write(struct file *file, const char __user *data,
 	struct net_device *dev = file->private_data;
 	struct netdevsim *ns = netdev_priv(dev);
 
-	memset(&ns->udp_ports.ports, 0, sizeof(ns->udp_ports.ports));
+	memset(ns->udp_ports.ports, 0, sizeof(ns->udp_ports.__ports));
 	rtnl_lock();
 	udp_tunnel_nic_reset_ntf(dev);
 	rtnl_unlock();
@@ -132,6 +132,17 @@ int nsim_udp_tunnels_info_create(struct nsim_dev *nsim_dev,
 	struct netdevsim *ns = netdev_priv(dev);
 	struct udp_tunnel_nic_info *info;
 
+	if (nsim_dev->udp_ports.shared && nsim_dev->udp_ports.open_only) {
+		dev_err(&nsim_dev->nsim_bus_dev->dev,
+			"shared can't be used in conjunction with open_only\n");
+		return -EINVAL;
+	}
+
+	if (!nsim_dev->udp_ports.shared)
+		ns->udp_ports.ports = ns->udp_ports.__ports;
+	else
+		ns->udp_ports.ports = nsim_dev->udp_ports.__ports;
+
 	debugfs_create_u32("udp_ports_inject_error", 0600,
 			   ns->nsim_dev_port->ddir,
 			   &ns->udp_ports.inject_error);
@@ -173,6 +184,8 @@ int nsim_udp_tunnels_info_create(struct nsim_dev *nsim_dev,
 		info->flags |= UDP_TUNNEL_NIC_INFO_OPEN_ONLY;
 	if (nsim_dev->udp_ports.ipv4_only)
 		info->flags |= UDP_TUNNEL_NIC_INFO_IPV4_ONLY;
+	if (nsim_dev->udp_ports.shared)
+		info->shared = &nsim_dev->udp_ports.utn_shared;
 
 	dev->udp_tunnel_nic_info = info;
 	return 0;
@@ -192,6 +205,8 @@ void nsim_udp_tunnels_debugfs_create(struct nsim_dev *nsim_dev)
 			    &nsim_dev->udp_ports.open_only);
 	debugfs_create_bool("udp_ports_ipv4_only", 0600, nsim_dev->ddir,
 			    &nsim_dev->udp_ports.ipv4_only);
+	debugfs_create_bool("udp_ports_shared", 0600, nsim_dev->ddir,
+			    &nsim_dev->udp_ports.shared);
 	debugfs_create_u32("udp_ports_sleep", 0600, nsim_dev->ddir,
 			   &nsim_dev->udp_ports.sleep);
 }
-- 
2.26.2

