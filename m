Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DDD843F524
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 05:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbhJ2DEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 23:04:33 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:43110 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231592AbhJ2DEa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 23:04:30 -0400
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id 2DC8620298; Fri, 29 Oct 2021 11:01:54 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Andrew Jeffery <andrew@aj.id.au>
Subject: [PATCH net-next v2 3/3] mctp: Pass flow data & flow release events to drivers
Date:   Fri, 29 Oct 2021 11:01:45 +0800
Message-Id: <20211029030145.633626-4-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211029030145.633626-1-jk@codeconstruct.com.au>
References: <20211029030145.633626-1-jk@codeconstruct.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have an extension for MCTP data in skbs, populate the flow
when a key has been created for the packet, and add a device driver
operation to inform of flow destruction.

Includes a fix for a warning with test builds:
Reported-by: kernel test robot <lkp@intel.com>

Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>

---
v2:
 - forward-declare struct mctp_sk_key
---
 include/net/mctp.h       |  6 +++++
 include/net/mctpdevice.h | 16 ++++++++++++
 net/mctp/device.c        | 51 +++++++++++++++++++++++++++++++++++++
 net/mctp/route.c         | 55 ++++++++++++++++++++++++++++++++++++++--
 4 files changed, 126 insertions(+), 2 deletions(-)

diff --git a/include/net/mctp.h b/include/net/mctp.h
index 7a5ba801703c..7e35ec79b909 100644
--- a/include/net/mctp.h
+++ b/include/net/mctp.h
@@ -152,6 +152,12 @@ struct mctp_sk_key {
 
 	/* expiry timeout; valid (above) cleared on expiry */
 	unsigned long	expiry;
+
+	/* free to use for device flow state tracking. Initialised to
+	 * zero on initial key creation
+	 */
+	unsigned long	dev_flow_state;
+	struct mctp_dev	*dev;
 };
 
 struct mctp_skb_cb {
diff --git a/include/net/mctpdevice.h b/include/net/mctpdevice.h
index 3a439463f055..5c0d04b5c12c 100644
--- a/include/net/mctpdevice.h
+++ b/include/net/mctpdevice.h
@@ -14,6 +14,8 @@
 #include <linux/types.h>
 #include <linux/refcount.h>
 
+struct mctp_sk_key;
+
 struct mctp_dev {
 	struct net_device	*dev;
 
@@ -21,6 +23,8 @@ struct mctp_dev {
 
 	unsigned int		net;
 
+	const struct mctp_netdev_ops *ops;
+
 	/* Only modified under RTNL. Reads have addrs_lock held */
 	u8			*addrs;
 	size_t			num_addrs;
@@ -29,12 +33,24 @@ struct mctp_dev {
 	struct rcu_head		rcu;
 };
 
+struct mctp_netdev_ops {
+	void			(*release_flow)(struct mctp_dev *dev,
+						struct mctp_sk_key *key);
+};
+
 #define MCTP_INITIAL_DEFAULT_NET	1
 
 struct mctp_dev *mctp_dev_get_rtnl(const struct net_device *dev);
 struct mctp_dev *__mctp_dev_get(const struct net_device *dev);
 
+int mctp_register_netdev(struct net_device *dev,
+			 const struct mctp_netdev_ops *ops);
+void mctp_unregister_netdev(struct net_device *dev);
+
 void mctp_dev_hold(struct mctp_dev *mdev);
 void mctp_dev_put(struct mctp_dev *mdev);
 
+void mctp_dev_set_key(struct mctp_dev *dev, struct mctp_sk_key *key);
+void mctp_dev_release_key(struct mctp_dev *dev, struct mctp_sk_key *key);
+
 #endif /* __NET_MCTPDEVICE_H */
diff --git a/net/mctp/device.c b/net/mctp/device.c
index 3827d62f52c9..8799ee77e7b7 100644
--- a/net/mctp/device.c
+++ b/net/mctp/device.c
@@ -260,6 +260,24 @@ void mctp_dev_put(struct mctp_dev *mdev)
 	}
 }
 
+void mctp_dev_release_key(struct mctp_dev *dev, struct mctp_sk_key *key)
+	__must_hold(&key->lock)
+{
+	if (!dev)
+		return;
+	if (dev->ops && dev->ops->release_flow)
+		dev->ops->release_flow(dev, key);
+	key->dev = NULL;
+	mctp_dev_put(dev);
+}
+
+void mctp_dev_set_key(struct mctp_dev *dev, struct mctp_sk_key *key)
+	__must_hold(&key->lock)
+{
+	mctp_dev_hold(dev);
+	key->dev = dev;
+}
+
 static struct mctp_dev *mctp_add_dev(struct net_device *dev)
 {
 	struct mctp_dev *mdev;
@@ -414,6 +432,39 @@ static int mctp_dev_notify(struct notifier_block *this, unsigned long event,
 	return NOTIFY_OK;
 }
 
+static int mctp_register_netdevice(struct net_device *dev,
+				   const struct mctp_netdev_ops *ops)
+{
+	struct mctp_dev *mdev;
+
+	mdev = mctp_add_dev(dev);
+	if (IS_ERR(mdev))
+		return PTR_ERR(mdev);
+
+	mdev->ops = ops;
+
+	return register_netdevice(dev);
+}
+
+int mctp_register_netdev(struct net_device *dev,
+			 const struct mctp_netdev_ops *ops)
+{
+	int rc;
+
+	rtnl_lock();
+	rc = mctp_register_netdevice(dev, ops);
+	rtnl_unlock();
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(mctp_register_netdev);
+
+void mctp_unregister_netdev(struct net_device *dev)
+{
+	unregister_netdev(dev);
+}
+EXPORT_SYMBOL_GPL(mctp_unregister_netdev);
+
 static struct rtnl_af_ops mctp_af_ops = {
 	.family = AF_MCTP,
 	.fill_link_af = mctp_fill_link_af,
diff --git a/net/mctp/route.c b/net/mctp/route.c
index 82cc10a2fb0c..46c44823edb7 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -29,6 +29,8 @@
 static const unsigned int mctp_message_maxlen = 64 * 1024;
 static const unsigned long mctp_key_lifetime = 6 * CONFIG_HZ;
 
+static void mctp_flow_prepare_output(struct sk_buff *skb, struct mctp_dev *dev);
+
 /* route output callbacks */
 static int mctp_route_discard(struct mctp_route *route, struct sk_buff *skb)
 {
@@ -152,8 +154,19 @@ static struct mctp_sk_key *mctp_key_alloc(struct mctp_sock *msk,
 
 void mctp_key_unref(struct mctp_sk_key *key)
 {
-	if (refcount_dec_and_test(&key->refs))
-		kfree(key);
+	unsigned long flags;
+
+	if (!refcount_dec_and_test(&key->refs))
+		return;
+
+	/* even though no refs exist here, the lock allows us to stay
+	 * consistent with the locking requirement of mctp_dev_release_key
+	 */
+	spin_lock_irqsave(&key->lock, flags);
+	mctp_dev_release_key(key->dev, key);
+	spin_unlock_irqrestore(&key->lock, flags);
+
+	kfree(key);
 }
 
 static int mctp_key_add(struct mctp_sk_key *key, struct mctp_sock *msk)
@@ -204,6 +217,7 @@ static void __mctp_key_unlock_drop(struct mctp_sk_key *key, struct net *net,
 	key->reasm_head = NULL;
 	key->reasm_dead = true;
 	key->valid = false;
+	mctp_dev_release_key(key->dev, key);
 	spin_unlock_irqrestore(&key->lock, flags);
 
 	spin_lock_irqsave(&net->mctp.keys_lock, flags);
@@ -222,6 +236,40 @@ static void __mctp_key_unlock_drop(struct mctp_sk_key *key, struct net *net,
 
 }
 
+#ifdef CONFIG_MCTP_FLOWS
+static void mctp_skb_set_flow(struct sk_buff *skb, struct mctp_sk_key *key)
+{
+	struct mctp_flow *flow;
+
+	flow = skb_ext_add(skb, SKB_EXT_MCTP);
+	if (!flow)
+		return;
+
+	refcount_inc(&key->refs);
+	flow->key = key;
+}
+
+static void mctp_flow_prepare_output(struct sk_buff *skb, struct mctp_dev *dev)
+{
+	struct mctp_sk_key *key;
+	struct mctp_flow *flow;
+
+	flow = skb_ext_find(skb, SKB_EXT_MCTP);
+	if (!flow)
+		return;
+
+	key = flow->key;
+
+	if (WARN_ON(key->dev && key->dev != dev))
+		return;
+
+	mctp_dev_set_key(dev, key);
+}
+#else
+static void mctp_skb_set_flow(struct sk_buff *skb, struct mctp_sk_key *key) {}
+static void mctp_flow_prepare_output(struct sk_buff *skb, struct mctp_dev *dev) {}
+#endif
+
 static int mctp_frag_queue(struct mctp_sk_key *key, struct sk_buff *skb)
 {
 	struct mctp_hdr *hdr = mctp_hdr(skb);
@@ -465,6 +513,8 @@ static int mctp_route_output(struct mctp_route *route, struct sk_buff *skb)
 		return -EHOSTUNREACH;
 	}
 
+	mctp_flow_prepare_output(skb, route->dev);
+
 	rc = dev_queue_xmit(skb);
 	if (rc)
 		rc = net_xmit_errno(rc);
@@ -803,6 +853,7 @@ int mctp_local_output(struct sock *sk, struct mctp_route *rt,
 			rc = PTR_ERR(key);
 			goto out_release;
 		}
+		mctp_skb_set_flow(skb, key);
 		/* done with the key in this scope */
 		mctp_key_unref(key);
 		tag |= MCTP_HDR_FLAG_TO;
-- 
2.33.0

