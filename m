Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 851E7396E82
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 10:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233300AbhFAIHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 04:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233194AbhFAIH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 04:07:27 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C09C7C061756;
        Tue,  1 Jun 2021 01:05:45 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lnzPD-000V6C-SC; Tue, 01 Jun 2021 10:05:44 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     m.chetan.kumar@intel.com, loic.poulain@linaro.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 2/4] rtnetlink: add alloc() method to rtnl_link_ops
Date:   Tue,  1 Jun 2021 10:05:36 +0200
Message-Id: <20210601100320.d72771182b79.Iadd04d389e9e8500e7de5e02081ab212c673d143@changeid>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210601080538.71036-1-johannes@sipsolutions.net>
References: <20210601080538.71036-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

In order to make rtnetlink ops that can create different
kinds of devices, like what we want to add to the WWAN
framework, the priv_size and setup parameters aren't quite
sufficient. Make this easier to manage by allowing ops to
allocate their own netdev via an @alloc method that gets
both the tb and data.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/bareudp.c   |  2 +-
 drivers/net/can/vxcan.c |  2 +-
 drivers/net/geneve.c    |  2 +-
 drivers/net/veth.c      |  2 +-
 drivers/net/vxlan.c     |  2 +-
 include/net/rtnetlink.h | 10 ++++++++++
 net/core/rtnetlink.c    | 17 ++++++++++++++---
 net/ipv4/ip_gre.c       |  2 +-
 8 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index edfad93e7b68..a694f6d8eb21 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -727,7 +727,7 @@ struct net_device *bareudp_dev_create(struct net *net, const char *name,
 
 	memset(tb, 0, sizeof(tb));
 	dev = rtnl_create_link(net, name, name_assign_type,
-			       &bareudp_link_ops, tb, NULL);
+			       &bareudp_link_ops, tb, NULL, NULL);
 	if (IS_ERR(dev))
 		return dev;
 
diff --git a/drivers/net/can/vxcan.c b/drivers/net/can/vxcan.c
index 8861a7d875e7..f904c78b4c23 100644
--- a/drivers/net/can/vxcan.c
+++ b/drivers/net/can/vxcan.c
@@ -204,7 +204,7 @@ static int vxcan_newlink(struct net *net, struct net_device *dev,
 		return PTR_ERR(peer_net);
 
 	peer = rtnl_create_link(peer_net, ifname, name_assign_type,
-				&vxcan_link_ops, tbp, extack);
+				&vxcan_link_ops, tbp, NULL, extack);
 	if (IS_ERR(peer)) {
 		put_net(peer_net);
 		return PTR_ERR(peer);
diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 1ab94b5f9bbf..130397110623 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -1840,7 +1840,7 @@ struct net_device *geneve_dev_create_fb(struct net *net, const char *name,
 
 	memset(tb, 0, sizeof(tb));
 	dev = rtnl_create_link(net, name, name_assign_type,
-			       &geneve_link_ops, tb, NULL);
+			       &geneve_link_ops, tb, NULL, NULL);
 	if (IS_ERR(dev))
 		return dev;
 
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index bdb7ce3cb054..788faa8faa98 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1498,7 +1498,7 @@ static int veth_newlink(struct net *src_net, struct net_device *dev,
 		return PTR_ERR(net);
 
 	peer = rtnl_create_link(net, ifname, name_assign_type,
-				&veth_link_ops, tbp, extack);
+				&veth_link_ops, tbp, NULL, extack);
 	if (IS_ERR(peer)) {
 		put_net(net);
 		return PTR_ERR(peer);
diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 02a14f1b938a..b8a63a8bcb73 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -4483,7 +4483,7 @@ struct net_device *vxlan_dev_create(struct net *net, const char *name,
 	memset(&tb, 0, sizeof(tb));
 
 	dev = rtnl_create_link(net, name, name_assign_type,
-			       &vxlan_link_ops, tb, NULL);
+			       &vxlan_link_ops, tb, NULL, NULL);
 	if (IS_ERR(dev))
 		return dev;
 
diff --git a/include/net/rtnetlink.h b/include/net/rtnetlink.h
index 479f60ef54c0..75426ad5a05b 100644
--- a/include/net/rtnetlink.h
+++ b/include/net/rtnetlink.h
@@ -37,6 +37,9 @@ static inline int rtnl_msg_family(const struct nlmsghdr *nlh)
  *	@maxtype: Highest device specific netlink attribute number
  *	@policy: Netlink policy for device specific attribute validation
  *	@validate: Optional validation function for netlink/changelink parameters
+ *	@alloc: netdev allocation function, can be %NULL and is then used
+ *		in place of alloc_netdev_mqs(), in this case @priv_size
+ *		and @setup are unused. Returns a netdev or ERR_PTR().
  *	@priv_size: sizeof net_device private space
  *	@setup: net_device setup function
  *	@newlink: Function for configuring and registering a new device
@@ -63,6 +66,12 @@ struct rtnl_link_ops {
 	const char		*kind;
 
 	size_t			priv_size;
+	struct net_device	*(*alloc)(struct nlattr *tb[],
+					  struct nlattr *data[],
+					  const char *ifname,
+					  unsigned char name_assign_type,
+					  unsigned int num_tx_queues,
+					  unsigned int num_rx_queues);
 	void			(*setup)(struct net_device *dev);
 
 	bool			netns_refund;
@@ -162,6 +171,7 @@ struct net_device *rtnl_create_link(struct net *net, const char *ifname,
 				    unsigned char name_assign_type,
 				    const struct rtnl_link_ops *ops,
 				    struct nlattr *tb[],
+				    struct nlattr *data[],
 				    struct netlink_ext_ack *extack);
 int rtnl_delete_link(struct net_device *dev);
 int rtnl_configure_link(struct net_device *dev, const struct ifinfomsg *ifm);
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 714d5fa38546..9da38639f088 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3151,6 +3151,7 @@ struct net_device *rtnl_create_link(struct net *net, const char *ifname,
 				    unsigned char name_assign_type,
 				    const struct rtnl_link_ops *ops,
 				    struct nlattr *tb[],
+				    struct nlattr *data[],
 				    struct netlink_ext_ack *extack)
 {
 	struct net_device *dev;
@@ -3177,8 +3178,17 @@ struct net_device *rtnl_create_link(struct net *net, const char *ifname,
 		return ERR_PTR(-EINVAL);
 	}
 
-	dev = alloc_netdev_mqs(ops->priv_size, ifname, name_assign_type,
-			       ops->setup, num_tx_queues, num_rx_queues);
+	if (ops->alloc) {
+		dev = ops->alloc(tb, data, ifname, name_assign_type,
+				 num_tx_queues, num_rx_queues);
+		if (IS_ERR(dev))
+			return dev;
+	} else {
+		dev = alloc_netdev_mqs(ops->priv_size, ifname,
+				       name_assign_type, ops->setup,
+				       num_tx_queues, num_rx_queues);
+	}
+
 	if (!dev)
 		return ERR_PTR(-ENOMEM);
 
@@ -3440,7 +3450,8 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	}
 
 	dev = rtnl_create_link(link_net ? : dest_net, ifname,
-			       name_assign_type, ops, tb, extack);
+			       name_assign_type, ops, tb, data,
+			       extack);
 	if (IS_ERR(dev)) {
 		err = PTR_ERR(dev);
 		goto out;
diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index a68bf4c6fe9b..7680f5b87f61 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -1637,7 +1637,7 @@ struct net_device *gretap_fb_dev_create(struct net *net, const char *name,
 	memset(&tb, 0, sizeof(tb));
 
 	dev = rtnl_create_link(net, name, name_assign_type,
-			       &ipgre_tap_ops, tb, NULL);
+			       &ipgre_tap_ops, tb, NULL, NULL);
 	if (IS_ERR(dev))
 		return dev;
 
-- 
2.31.1

