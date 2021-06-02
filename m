Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA4D939841B
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 10:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232616AbhFBIai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 04:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232577AbhFBIa3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 04:30:29 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CA33C06174A;
        Wed,  2 Jun 2021 01:28:46 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1loMF2-000xxd-GJ; Wed, 02 Jun 2021 10:28:44 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     m.chetan.kumar@intel.com, loic.poulain@linaro.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: [RFC v2 2/5] rtnetlink: add alloc() method to rtnl_link_ops
Date:   Wed,  2 Jun 2021 10:28:37 +0200
Message-Id: <20210602102653.6e2d8b8026a2.Iadd04d389e9e8500e7de5e02081ab212c673d143@changeid>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210602082840.85828-1-johannes@sipsolutions.net>
References: <20210602082840.85828-1-johannes@sipsolutions.net>
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
the tb netlink data.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
v2:
 * remove data[] argument and thus many changes
---
 include/net/rtnetlink.h |  8 ++++++++
 net/core/rtnetlink.c    | 13 +++++++++++--
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/include/net/rtnetlink.h b/include/net/rtnetlink.h
index 479f60ef54c0..384e800665f2 100644
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
@@ -63,6 +66,11 @@ struct rtnl_link_ops {
 	const char		*kind;
 
 	size_t			priv_size;
+	struct net_device	*(*alloc)(struct nlattr *tb[],
+					  const char *ifname,
+					  unsigned char name_assign_type,
+					  unsigned int num_tx_queues,
+					  unsigned int num_rx_queues);
 	void			(*setup)(struct net_device *dev);
 
 	bool			netns_refund;
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 714d5fa38546..4975dd91407d 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3177,8 +3177,17 @@ struct net_device *rtnl_create_link(struct net *net, const char *ifname,
 		return ERR_PTR(-EINVAL);
 	}
 
-	dev = alloc_netdev_mqs(ops->priv_size, ifname, name_assign_type,
-			       ops->setup, num_tx_queues, num_rx_queues);
+	if (ops->alloc) {
+		dev = ops->alloc(tb, ifname, name_assign_type,
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
 
-- 
2.31.1

