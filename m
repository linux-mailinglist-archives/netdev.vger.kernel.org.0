Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D480346EB1
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 02:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234534AbhCXBbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 21:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234180AbhCXBbK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 21:31:10 -0400
Received: from mail.netfilter.org (mail.netfilter.org [IPv6:2001:4b98:dc0:41:216:3eff:fe8c:2bda])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2A2B5C0613D8;
        Tue, 23 Mar 2021 18:31:10 -0700 (PDT)
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 7BAA0630C3;
        Wed, 24 Mar 2021 02:31:01 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next,v2 02/24] net: 8021q: resolve forwarding path for vlan devices
Date:   Wed, 24 Mar 2021 02:30:33 +0100
Message-Id: <20210324013055.5619-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210324013055.5619-1-pablo@netfilter.org>
References: <20210324013055.5619-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add .ndo_fill_forward_path for vlan devices.

For instance, assuming the following topology:

                   IP forwarding
                  /             \
            eth0.100             eth0
            |
            eth0
            .
            .
            .
           ethX
     ab:cd:ef:ab:cd:ef

For packets going through IP forwarding to eth0.100 whose destination
MAC address is ab:cd:ef:ab:cd:ef, dev_fill_forward_path() provides the
following path:

        eth0.100 -> eth0

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes.

 include/linux/netdevice.h |  7 +++++++
 net/8021q/vlan_dev.c      | 15 +++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index f9ac960699a4..6263bc3f2422 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -850,11 +850,18 @@ typedef u16 (*select_queue_fallback_t)(struct net_device *dev,
 
 enum net_device_path_type {
 	DEV_PATH_ETHERNET = 0,
+	DEV_PATH_VLAN,
 };
 
 struct net_device_path {
 	enum net_device_path_type	type;
 	const struct net_device		*dev;
+	union {
+		struct {
+			u16		id;
+			__be16		proto;
+		} encap;
+	};
 };
 
 #define NET_DEVICE_PATH_STACK_MAX	5
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index dc1a197792e6..1b1955a63f7f 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -776,6 +776,20 @@ static int vlan_dev_get_iflink(const struct net_device *dev)
 	return real_dev->ifindex;
 }
 
+static int vlan_dev_fill_forward_path(struct net_device_path_ctx *ctx,
+				      struct net_device_path *path)
+{
+	struct vlan_dev_priv *vlan = vlan_dev_priv(ctx->dev);
+
+	path->type = DEV_PATH_VLAN;
+	path->encap.id = vlan->vlan_id;
+	path->encap.proto = vlan->vlan_proto;
+	path->dev = ctx->dev;
+	ctx->dev = vlan->real_dev;
+
+	return 0;
+}
+
 static const struct ethtool_ops vlan_ethtool_ops = {
 	.get_link_ksettings	= vlan_ethtool_get_link_ksettings,
 	.get_drvinfo	        = vlan_ethtool_get_drvinfo,
@@ -814,6 +828,7 @@ static const struct net_device_ops vlan_netdev_ops = {
 #endif
 	.ndo_fix_features	= vlan_dev_fix_features,
 	.ndo_get_iflink		= vlan_dev_get_iflink,
+	.ndo_fill_forward_path	= vlan_dev_fill_forward_path,
 };
 
 static void vlan_dev_free(struct net_device *dev)
-- 
2.20.1

