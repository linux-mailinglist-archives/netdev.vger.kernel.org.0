Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB36E1BA79D
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 17:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbgD0PNs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 11:13:48 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:35207 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728015AbgD0PNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 11:13:46 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id B91B65C00BE;
        Mon, 27 Apr 2020 11:13:44 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 27 Apr 2020 11:13:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=IcvWH6XpFmqBUwy5NrU/YT40r5BpyQcUJ+8xXceks88=; b=WFgz6/9H
        2EF8x5yDtYWFYYVTHUphZqyZaP+W/jgfAzXn4FD8THWMNmQ5nhLbIsEa3gZW+mgF
        tL/N29oMRf4zpflLBbGPZN4gbR2JiHabb6LxmfqqClSaOBDbso66aoMKEza3o2Y8
        QH9RqhE580/AQjWfv8i1CuO5iE8VwC3h59CN3BgAdvm+b3Z3XnEIIbXjjTYj+YSt
        V7gW7eIV75zKbvhTdZzMCjnphpc14P26ckTmOqv2Z8/jrk93EntfouM2o/6L8n/e
        qUaJaZlEADEgrqE1mmhUq5t9E1prFSxiaM1iphhuQLL6zsQv43Aq5Z4o84s/vm4X
        QAx5QY9A5kEQ8A==
X-ME-Sender: <xms:qPamXl7TDSPzprE1trAnp9I6YFfdKAOKGWxUQ9URkjenw3kNg6Do-w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrheelgdekgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepjeelrddukedtrdehgedrudduieenucevlhhushhtvghruf
    hiiigvpeejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghh
    rdhorhhg
X-ME-Proxy: <xmx:qPamXvNfHHndPubZHLzRDr0b91tllVFY4-yatyAc0bKR6A_IiBmCow>
    <xmx:qPamXvM1TEzVU9jaZlks7f788Y1BdppdMac8J630s0jWovOOBP9emQ>
    <xmx:qPamXv_pgkMqVCOp3sMFXAV9LHXEiZVr8exDDnNr8IWhmsJ72N8hFA>
    <xmx:qPamXlLb8EF_RvebkQmRehjexrCkqfeD1Xm3m4ai7So28zc1muErdQ>
Received: from splinter.mtl.com (bzq-79-180-54-116.red.bezeqint.net [79.180.54.116])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7AA3B3280059;
        Mon, 27 Apr 2020 11:13:43 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 10/13] mlxsw: spectrum: Avoid copying sample values and use RCU pointer direcly instead
Date:   Mon, 27 Apr 2020 18:13:07 +0300
Message-Id: <20200427151310.3950411-11-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200427151310.3950411-1-idosch@idosch.org>
References: <20200427151310.3950411-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Currently, only the psample_group is accessed using RCU on RX path.
However, it is possible (unlikely) that other sample values get change
during RX processing. Fix this by having the port->sample struct
accessed as RCU pointer, containing all sample values including
psample_group pointer. That avoids extra alloc per-port, copying the
values and the race condition described above.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 30 ++++---------------
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  4 +--
 .../mellanox/mlxsw/spectrum_matchall.c        | 17 ++++-------
 3 files changed, 14 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index ff25f8fc55e9..5952ec26c169 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3527,13 +3527,6 @@ static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 		goto err_alloc_stats;
 	}
 
-	mlxsw_sp_port->sample = kzalloc(sizeof(*mlxsw_sp_port->sample),
-					GFP_KERNEL);
-	if (!mlxsw_sp_port->sample) {
-		err = -ENOMEM;
-		goto err_alloc_sample;
-	}
-
 	INIT_DELAYED_WORK(&mlxsw_sp_port->periodic_hw_stats.update_dw,
 			  &update_stats_cache);
 
@@ -3720,8 +3713,6 @@ static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 err_port_swid_set:
 	mlxsw_sp_port_module_unmap(mlxsw_sp_port);
 err_port_module_map:
-	kfree(mlxsw_sp_port->sample);
-err_alloc_sample:
 	free_percpu(mlxsw_sp_port->pcpu_stats);
 err_alloc_stats:
 	free_netdev(dev);
@@ -3749,7 +3740,6 @@ static void mlxsw_sp_port_remove(struct mlxsw_sp *mlxsw_sp, u8 local_port)
 	mlxsw_sp_port_tc_mc_mode_set(mlxsw_sp_port, false);
 	mlxsw_sp_port_swid_set(mlxsw_sp_port, MLXSW_PORT_SWID_DISABLED_PORT);
 	mlxsw_sp_port_module_unmap(mlxsw_sp_port);
-	kfree(mlxsw_sp_port->sample);
 	free_percpu(mlxsw_sp_port->pcpu_stats);
 	WARN_ON_ONCE(!list_empty(&mlxsw_sp_port->vlans_list));
 	free_netdev(mlxsw_sp_port->dev);
@@ -4236,7 +4226,7 @@ static void mlxsw_sp_rx_listener_sample_func(struct sk_buff *skb, u8 local_port,
 {
 	struct mlxsw_sp *mlxsw_sp = priv;
 	struct mlxsw_sp_port *mlxsw_sp_port = mlxsw_sp->ports[local_port];
-	struct psample_group *psample_group;
+	struct mlxsw_sp_port_sample *sample;
 	u32 size;
 
 	if (unlikely(!mlxsw_sp_port)) {
@@ -4244,22 +4234,14 @@ static void mlxsw_sp_rx_listener_sample_func(struct sk_buff *skb, u8 local_port,
 				     local_port);
 		goto out;
 	}
-	if (unlikely(!mlxsw_sp_port->sample)) {
-		dev_warn_ratelimited(mlxsw_sp->bus_info->dev, "Port %d: sample skb received on unsupported port\n",
-				     local_port);
-		goto out;
-	}
-
-	size = mlxsw_sp_port->sample->truncate ?
-		  mlxsw_sp_port->sample->trunc_size : skb->len;
 
 	rcu_read_lock();
-	psample_group = rcu_dereference(mlxsw_sp_port->sample->psample_group);
-	if (!psample_group)
+	sample = rcu_dereference(mlxsw_sp_port->sample);
+	if (!sample)
 		goto out_unlock;
-	psample_sample_packet(psample_group, skb, size,
-			      mlxsw_sp_port->dev->ifindex, 0,
-			      mlxsw_sp_port->sample->rate);
+	size = sample->truncate ? sample->trunc_size : skb->len;
+	psample_sample_packet(sample->psample_group, skb, size,
+			      mlxsw_sp_port->dev->ifindex, 0, sample->rate);
 out_unlock:
 	rcu_read_unlock();
 out:
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 5c2f1af53e53..4cdb7f1d7436 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -192,7 +192,7 @@ struct mlxsw_sp_port_pcpu_stats {
 };
 
 struct mlxsw_sp_port_sample {
-	struct psample_group __rcu *psample_group;
+	struct psample_group *psample_group;
 	u32 trunc_size;
 	u32 rate;
 	bool truncate;
@@ -262,7 +262,7 @@ struct mlxsw_sp_port {
 		struct mlxsw_sp_port_xstats xstats;
 		struct delayed_work update_dw;
 	} periodic_hw_stats;
-	struct mlxsw_sp_port_sample *sample;
+	struct mlxsw_sp_port_sample __rcu *sample;
 	struct list_head vlans_list;
 	struct mlxsw_sp_port_vlan *default_vlan;
 	struct mlxsw_sp_qdisc_state *qdisc;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
index 41301027a47c..bda5fb34162a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
@@ -29,6 +29,7 @@ struct mlxsw_sp_mall_entry {
 		struct mlxsw_sp_mall_mirror_entry mirror;
 		struct mlxsw_sp_port_sample sample;
 	};
+	struct rcu_head rcu;
 };
 
 static struct mlxsw_sp_mall_entry *
@@ -90,17 +91,11 @@ mlxsw_sp_mall_port_sample_add(struct mlxsw_sp_port *mlxsw_sp_port,
 {
 	int err;
 
-	if (!mlxsw_sp_port->sample)
-		return -EOPNOTSUPP;
-	if (rtnl_dereference(mlxsw_sp_port->sample->psample_group)) {
+	if (rtnl_dereference(mlxsw_sp_port->sample)) {
 		netdev_err(mlxsw_sp_port->dev, "sample already active\n");
 		return -EEXIST;
 	}
-	rcu_assign_pointer(mlxsw_sp_port->sample->psample_group,
-			   mall_entry->sample.psample_group);
-	mlxsw_sp_port->sample->truncate = mall_entry->sample.truncate;
-	mlxsw_sp_port->sample->trunc_size = mall_entry->sample.trunc_size;
-	mlxsw_sp_port->sample->rate = mall_entry->sample.rate;
+	rcu_assign_pointer(mlxsw_sp_port->sample, &mall_entry->sample);
 
 	err = mlxsw_sp_mall_port_sample_set(mlxsw_sp_port, true,
 					    mall_entry->sample.rate);
@@ -109,7 +104,7 @@ mlxsw_sp_mall_port_sample_add(struct mlxsw_sp_port *mlxsw_sp_port,
 	return 0;
 
 err_port_sample_set:
-	RCU_INIT_POINTER(mlxsw_sp_port->sample->psample_group, NULL);
+	RCU_INIT_POINTER(mlxsw_sp_port->sample, NULL);
 	return err;
 }
 
@@ -120,7 +115,7 @@ mlxsw_sp_mall_port_sample_del(struct mlxsw_sp_port *mlxsw_sp_port)
 		return;
 
 	mlxsw_sp_mall_port_sample_set(mlxsw_sp_port, false, 1);
-	RCU_INIT_POINTER(mlxsw_sp_port->sample->psample_group, NULL);
+	RCU_INIT_POINTER(mlxsw_sp_port->sample, NULL);
 }
 
 static int
@@ -221,5 +216,5 @@ void mlxsw_sp_mall_destroy(struct mlxsw_sp_port *mlxsw_sp_port,
 	mlxsw_sp_mall_port_rule_del(mlxsw_sp_port, mall_entry);
 
 	list_del(&mall_entry->list);
-	kfree(mall_entry);
+	kfree_rcu(mall_entry, rcu); /* sample RX packets may be in-flight */
 }
-- 
2.24.1

