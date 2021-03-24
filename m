Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14D99346EBE
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 02:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234581AbhCXBbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 21:31:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234440AbhCXBbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 21:31:12 -0400
Received: from mail.netfilter.org (mail.netfilter.org [IPv6:2001:4b98:dc0:41:216:3eff:fe8c:2bda])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B519CC061763;
        Tue, 23 Mar 2021 18:31:12 -0700 (PDT)
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 68AB6630BB;
        Wed, 24 Mar 2021 02:31:04 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next,v2 06/24] net: dsa: resolve forwarding path for dsa slave ports
Date:   Wed, 24 Mar 2021 02:30:37 +0100
Message-Id: <20210324013055.5619-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210324013055.5619-1-pablo@netfilter.org>
References: <20210324013055.5619-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

Add .ndo_fill_forward_path for dsa slave port devices

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes.

 include/linux/netdevice.h |  5 +++++
 net/dsa/slave.c           | 16 ++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index cf1041756438..7ad7df75aaaa 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -853,6 +853,7 @@ enum net_device_path_type {
 	DEV_PATH_VLAN,
 	DEV_PATH_BRIDGE,
 	DEV_PATH_PPPOE,
+	DEV_PATH_DSA,
 };
 
 struct net_device_path {
@@ -873,6 +874,10 @@ struct net_device_path {
 			u16		vlan_id;
 			__be16		vlan_proto;
 		} bridge;
+		struct {
+			int port;
+			u16 proto;
+		} dsa;
 	};
 };
 
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 992fcab4b552..df7d789236fe 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1654,6 +1654,21 @@ static void dsa_slave_get_stats64(struct net_device *dev,
 		dev_get_tstats64(dev, s);
 }
 
+static int dsa_slave_fill_forward_path(struct net_device_path_ctx *ctx,
+				       struct net_device_path *path)
+{
+	struct dsa_port *dp = dsa_slave_to_port(ctx->dev);
+	struct dsa_port *cpu_dp = dp->cpu_dp;
+
+	path->dev = ctx->dev;
+	path->type = DEV_PATH_DSA;
+	path->dsa.proto = cpu_dp->tag_ops->proto;
+	path->dsa.port = dp->index;
+	ctx->dev = cpu_dp->master;
+
+	return 0;
+}
+
 static const struct net_device_ops dsa_slave_netdev_ops = {
 	.ndo_open	 	= dsa_slave_open,
 	.ndo_stop		= dsa_slave_close,
@@ -1679,6 +1694,7 @@ static const struct net_device_ops dsa_slave_netdev_ops = {
 	.ndo_vlan_rx_kill_vid	= dsa_slave_vlan_rx_kill_vid,
 	.ndo_get_devlink_port	= dsa_slave_get_devlink_port,
 	.ndo_change_mtu		= dsa_slave_change_mtu,
+	.ndo_fill_forward_path	= dsa_slave_fill_forward_path,
 };
 
 static struct device_type dsa_type = {
-- 
2.20.1

