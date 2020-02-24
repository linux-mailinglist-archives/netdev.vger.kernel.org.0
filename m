Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10C3416B186
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 22:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbgBXVIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 16:08:09 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34132 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727459AbgBXVIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 16:08:07 -0500
Received: by mail-wr1-f67.google.com with SMTP id z15so3775811wrl.1
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 13:08:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XBhkMU0qEazeCTxrnAQgNmenz7/lwCQE+0Tz/F5+3KU=;
        b=TCr7TlJrLZEabxgDDrcs1STyHu3F/7M8TMM8n6kR8VESzu/HnCkznjIquCKM3cq6cU
         q8zZmn+KD6x8CpDLsVNtT9TbG5RR3acBH9lL4jMtpOFQjK42qVkoUx9HuaO11kQGWR6r
         yeafpTEaK7VCKZCYuquqaQvz3lrmeu002NFb6+UDjTVW5+vhuTXLJe3zrorhSRnpiPGg
         7pkO6vubGQoyhfkLiZMIqeUOa3s9Ba4j+OJMENkAP/yAV67bHjC+6FBN42r1xFQzY+NI
         1LQBysvDbukYOEHgElPwaN8ZhJdU2qj6LJ7wB01seUa24TWfoLQ+bXZ8CEBuyoh78zuv
         D+4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XBhkMU0qEazeCTxrnAQgNmenz7/lwCQE+0Tz/F5+3KU=;
        b=M6K3G634gAhVKIGOxM1ATZSxO6Lilb+F+BysaNaI0JmDtEiK4FT3/qQ2py+r4yz/dl
         srOmgFz7Y71buc1N8PHBXzcfHV0BMGk+FB2wwHxgDEyXtxIWXnT780BMZxj8LByVmhqe
         3dE2b/CVotupovOU1R93esMCBWtoN4KioxW7shqZxCkz9469yzmEAfFD5g6HhYJtWUFC
         3dVvjkOKHMl2WZN7GdN7v4G7fF49dXTXr/zP4pRgQ90onM2nRD2OPQculTuo9dk6obZ+
         U8ploAZQJVSmsPJVGMlGhYFytJdq4jhy1kexYF3ExQmA9QveGbpHYoYp0psJlwvYbGr8
         qPPQ==
X-Gm-Message-State: APjAAAWt+sAm1OopGwVxRfnQnnG6/kNCHHUUh1S66K3/ejNHZGeOdVJl
        YvMLLjDuzI1mEK4L8gza3po5f9BHeKg=
X-Google-Smtp-Source: APXvYqz3gaS/R393Kp0krDwVECns63lvj8EIUo5eN/boZNlB2LBaSVkdaho+hrPIDSUPNxGRYU477g==
X-Received: by 2002:adf:f084:: with SMTP id n4mr68183810wro.200.1582578485243;
        Mon, 24 Feb 2020 13:08:05 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id b192sm872142wmb.40.2020.02.24.13.08.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 13:08:04 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, nhorman@tuxdriver.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next 04/10] devlink: extend devlink_trap_report() to accept cookie and pass
Date:   Mon, 24 Feb 2020 22:07:52 +0100
Message-Id: <20200224210758.18481-5-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200224210758.18481-1-jiri@resnulli.us>
References: <20200224210758.18481-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Add cookie argument to devlink_trap_report() allowing driver to pass in
the user cookie. Pass on the cookie down to drop monitor code.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c |  4 ++--
 drivers/net/netdevsim/dev.c                         |  2 +-
 include/net/devlink.h                               |  7 ++++---
 net/core/devlink.c                                  | 11 ++++++++---
 4 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index 04f2445f6d43..a55577a50e90 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -71,7 +71,7 @@ static void mlxsw_sp_rx_drop_listener(struct sk_buff *skb, u8 local_port,
 	in_devlink_port = mlxsw_core_port_devlink_port_get(mlxsw_sp->core,
 							   local_port);
 	skb_push(skb, ETH_HLEN);
-	devlink_trap_report(devlink, skb, trap_ctx, in_devlink_port);
+	devlink_trap_report(devlink, skb, trap_ctx, in_devlink_port, NULL);
 	consume_skb(skb);
 }
 
@@ -95,7 +95,7 @@ static void mlxsw_sp_rx_exception_listener(struct sk_buff *skb, u8 local_port,
 	in_devlink_port = mlxsw_core_port_devlink_port_get(mlxsw_sp->core,
 							   local_port);
 	skb_push(skb, ETH_HLEN);
-	devlink_trap_report(devlink, skb, trap_ctx, in_devlink_port);
+	devlink_trap_report(devlink, skb, trap_ctx, in_devlink_port, NULL);
 	skb_pull(skb, ETH_HLEN);
 	skb->offload_fwd_mark = 1;
 	netif_receive_skb(skb);
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index d7706a0346f2..aa17533c06e1 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -385,7 +385,7 @@ static void nsim_dev_trap_report(struct nsim_dev_port *nsim_dev_port)
 		 */
 		local_bh_disable();
 		devlink_trap_report(devlink, skb, nsim_trap_item->trap_ctx,
-				    &nsim_dev_port->devlink_port);
+				    &nsim_dev_port->devlink_port, NULL);
 		local_bh_enable();
 		consume_skb(skb);
 	}
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 014a8b3d1499..c9ca86b054bc 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -16,6 +16,7 @@
 #include <linux/workqueue.h>
 #include <linux/refcount.h>
 #include <net/net_namespace.h>
+#include <net/flow_offload.h>
 #include <uapi/linux/devlink.h>
 
 struct devlink_ops;
@@ -1050,9 +1051,9 @@ int devlink_traps_register(struct devlink *devlink,
 void devlink_traps_unregister(struct devlink *devlink,
 			      const struct devlink_trap *traps,
 			      size_t traps_count);
-void devlink_trap_report(struct devlink *devlink,
-			 struct sk_buff *skb, void *trap_ctx,
-			 struct devlink_port *in_devlink_port);
+void devlink_trap_report(struct devlink *devlink, struct sk_buff *skb,
+			 void *trap_ctx, struct devlink_port *in_devlink_port,
+			 const struct flow_action_cookie *fa_cookie);
 void *devlink_trap_ctx_priv(void *trap_ctx);
 
 #if IS_ENABLED(CONFIG_NET_DEVLINK)
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 12e6ef749b8a..49706031ab45 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -8205,12 +8205,14 @@ devlink_trap_stats_update(struct devlink_stats __percpu *trap_stats,
 static void
 devlink_trap_report_metadata_fill(struct net_dm_hw_metadata *hw_metadata,
 				  const struct devlink_trap_item *trap_item,
-				  struct devlink_port *in_devlink_port)
+				  struct devlink_port *in_devlink_port,
+				  const struct flow_action_cookie *fa_cookie)
 {
 	struct devlink_trap_group_item *group_item = trap_item->group_item;
 
 	hw_metadata->trap_group_name = group_item->group->name;
 	hw_metadata->trap_name = trap_item->trap->name;
+	hw_metadata->fa_cookie = fa_cookie;
 
 	spin_lock(&in_devlink_port->type_lock);
 	if (in_devlink_port->type == DEVLINK_PORT_TYPE_ETH)
@@ -8224,9 +8226,12 @@ devlink_trap_report_metadata_fill(struct net_dm_hw_metadata *hw_metadata,
  * @skb: Trapped packet.
  * @trap_ctx: Trap context.
  * @in_devlink_port: Input devlink port.
+ * @fa_cookie: Flow action cookie. Could be NULL.
  */
 void devlink_trap_report(struct devlink *devlink, struct sk_buff *skb,
-			 void *trap_ctx, struct devlink_port *in_devlink_port)
+			 void *trap_ctx, struct devlink_port *in_devlink_port,
+			 const struct flow_action_cookie *fa_cookie)
+
 {
 	struct devlink_trap_item *trap_item = trap_ctx;
 	struct net_dm_hw_metadata hw_metadata = {};
@@ -8235,7 +8240,7 @@ void devlink_trap_report(struct devlink *devlink, struct sk_buff *skb,
 	devlink_trap_stats_update(trap_item->group_item->stats, skb->len);
 
 	devlink_trap_report_metadata_fill(&hw_metadata, trap_item,
-					  in_devlink_port);
+					  in_devlink_port, fa_cookie);
 	net_dm_hw_report(skb, &hw_metadata);
 }
 EXPORT_SYMBOL_GPL(devlink_trap_report);
-- 
2.21.1

