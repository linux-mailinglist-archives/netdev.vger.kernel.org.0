Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF68E27FB0B
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 10:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731673AbgJAIHI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 1 Oct 2020 04:07:08 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:36667 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731383AbgJAIHG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 04:07:06 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-PlP_Dy8BNCOL9PTgHCWvXw-1; Thu, 01 Oct 2020 04:00:40 -0400
X-MC-Unique: PlP_Dy8BNCOL9PTgHCWvXw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AF2E018BE198;
        Thu,  1 Oct 2020 08:00:39 +0000 (UTC)
Received: from hog.localdomain, (unknown [10.40.192.241])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 884FA5C1CF;
        Thu,  1 Oct 2020 08:00:38 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net 06/12] bridge: advertise IFLA_LINK_NETNSID when dumping bridge ports
Date:   Thu,  1 Oct 2020 09:59:30 +0200
Message-Id: <616f74e09c5dca0735e25573ad6a8a10411f51df.1600770261.git.sd@queasysnail.net>
In-Reply-To: <cover.1600770261.git.sd@queasysnail.net>
References: <cover.1600770261.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=sd@queasysnail.net
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, we're not advertising link-netnsid for bridge ports, so the
"bridge link" command will not correctly interpret the value of the
IFLA_LINK attribute.

With this setup (ip link output):
    9: bridge0: <BROADCAST,MULTICAST> mtu 1500 ...
    10: veth0@if10: <BROADCAST,MULTICAST> mtu 1500 qdisc noop master bridge0 ...
    11: veth1@if9: <BROADCAST,MULTICAST> mtu 1500 qdisc noop master bridge0 ...

we'll get:
    10: veth0: <BROADCAST,MULTICAST> mtu 1500 master bridge0 ...
    11: veth1@bridge0: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 master ...

instead of:
    10: veth0@if10: <BROADCAST,MULTICAST> mtu 1500 master bridge0 ...
    11: veth1@if9: <BROADCAST,MULTICAST> mtu 1500 master bridge0 ...

br_fill_ifinfo can be called without RTNL (from
br_forward_delay_timer_expired), so we need to change get_link_net
callbacks to use rcu_dereference_rtnl instead of rtnl_dereference.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 drivers/net/can/vxcan.c | 2 +-
 drivers/net/veth.c      | 2 +-
 include/net/rtnetlink.h | 4 ++++
 net/bridge/br_netlink.c | 2 ++
 net/core/rtnetlink.c    | 8 +++++---
 5 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/vxcan.c b/drivers/net/can/vxcan.c
index d6ba9426be4d..870109d38b28 100644
--- a/drivers/net/can/vxcan.c
+++ b/drivers/net/can/vxcan.c
@@ -276,7 +276,7 @@ static const struct nla_policy vxcan_policy[VXCAN_INFO_MAX + 1] = {
 static struct net *vxcan_get_link_net(const struct net_device *dev)
 {
 	struct vxcan_priv *priv = netdev_priv(dev);
-	struct net_device *peer = rtnl_dereference(priv->peer);
+	struct net_device *peer = rcu_dereference_rtnl(priv->peer);
 
 	return peer ? dev_net(peer) : dev_net(dev);
 }
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index a475f48d43c4..5f814620d97e 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1433,7 +1433,7 @@ static const struct nla_policy veth_policy[VETH_INFO_MAX + 1] = {
 static struct net *veth_get_link_net(const struct net_device *dev)
 {
 	struct veth_priv *priv = netdev_priv(dev);
-	struct net_device *peer = rtnl_dereference(priv->peer);
+	struct net_device *peer = rcu_dereference_rtnl(priv->peer);
 
 	return peer ? dev_net(peer) : dev_net(dev);
 }
diff --git a/include/net/rtnetlink.h b/include/net/rtnetlink.h
index e2091bb2b3a8..c37cb3d98c7c 100644
--- a/include/net/rtnetlink.h
+++ b/include/net/rtnetlink.h
@@ -168,6 +168,10 @@ int rtnl_nla_parse_ifla(struct nlattr **tb, const struct nlattr *head, int len,
 			struct netlink_ext_ack *exterr);
 struct net *rtnl_get_net_ns_capable(struct sock *sk, int netnsid);
 
+int rtnl_fill_link_netnsid(struct sk_buff *skb,
+			   const struct net_device *dev,
+			   struct net *src_net, gfp_t gfp);
+
 #define MODULE_ALIAS_RTNL_LINK(kind) MODULE_ALIAS("rtnl-link-" kind)
 
 #endif
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 6af5d62ddf7b..81ea4e89edba 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -164,6 +164,7 @@ static inline size_t br_nlmsg_size(struct net_device *dev, u32 filter_mask)
 		+ nla_total_size(4) /* IFLA_MASTER */
 		+ nla_total_size(4) /* IFLA_MTU */
 		+ nla_total_size(4) /* IFLA_LINK */
+		+ nla_total_size(4) /* IFLA_LINK_NETNSID */
 		+ nla_total_size(1) /* IFLA_OPERSTATE */
 		+ nla_total_size(br_port_info_size()) /* IFLA_PROTINFO */
 		+ nla_total_size(br_get_link_af_size_filtered(dev,
@@ -410,6 +411,7 @@ static int br_fill_ifinfo(struct sk_buff *skb,
 	    nla_put_u8(skb, IFLA_OPERSTATE, operstate) ||
 	    (dev->addr_len &&
 	     nla_put(skb, IFLA_ADDRESS, dev->addr_len, dev->dev_addr)) ||
+	    rtnl_fill_link_netnsid(skb, dev, dev_net(br->dev), GFP_ATOMIC) ||
 	    (dev->netdev_ops && dev->netdev_ops->ndo_get_iflink &&
 	     nla_put_u32(skb, IFLA_LINK, dev_get_iflink(dev))))
 		goto nla_put_failure;
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 3d8051158890..26ce9fafc379 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1568,9 +1568,9 @@ static noinline_for_stack int nla_put_ifalias(struct sk_buff *skb,
 	return ret > 0 ? nla_put_string(skb, IFLA_IFALIAS, buf) : 0;
 }
 
-static int rtnl_fill_link_netnsid(struct sk_buff *skb,
-				  const struct net_device *dev,
-				  struct net *src_net, gfp_t gfp)
+int rtnl_fill_link_netnsid(struct sk_buff *skb,
+			   const struct net_device *dev,
+			   struct net *src_net, gfp_t gfp)
 {
 	if (dev->rtnl_link_ops && dev->rtnl_link_ops->get_link_net) {
 		struct net *link_net = dev->rtnl_link_ops->get_link_net(dev);
@@ -1585,6 +1585,7 @@ static int rtnl_fill_link_netnsid(struct sk_buff *skb,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(rtnl_fill_link_netnsid);
 
 static int rtnl_fill_link_af(struct sk_buff *skb,
 			     const struct net_device *dev,
@@ -4625,6 +4626,7 @@ int ndo_dflt_bridge_getlink(struct sk_buff *skb, u32 pid, u32 seq,
 	     nla_put_u32(skb, IFLA_MASTER, br_dev->ifindex)) ||
 	    (dev->addr_len &&
 	     nla_put(skb, IFLA_ADDRESS, dev->addr_len, dev->dev_addr)) ||
+	    rtnl_fill_link_netnsid(skb, dev, dev_net(br_dev), GFP_ATOMIC) ||
 	    (dev->netdev_ops && dev->netdev_ops->ndo_get_iflink &&
 	     nla_put_u32(skb, IFLA_LINK, dev_get_iflink(dev))))
 		goto nla_put_failure;
-- 
2.28.0

