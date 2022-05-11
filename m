Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5EB523D30
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 21:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346661AbiEKTM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 15:12:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244322AbiEKTMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 15:12:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D62E7357F
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 12:12:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B61B61558
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 19:12:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7876CC340EE;
        Wed, 11 May 2022 19:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652296342;
        bh=VkSejbDmljo+kTQsjrlOHNSsa4PsqxJ6Frhd7EIRR9s=;
        h=From:To:Cc:Subject:Date:From;
        b=mB+MuGOjU3ZBwwsO9W9DEPIv5ETvg+L1TzOtHD9rqcTBrMoqdZkI8IDvdRFd+ui6t
         t5E+5uuzCkNIsiuuFpaIkJ0wltqbvGZlBXRM9ft2Wz3chhtzEXEsytMOmobK8OeOtW
         GZg3wze2xapbbCKY1+S7TmFpY7tOyqBgfgeIongDiMJB+Khp/slUdiF+7wfrgZ+UpB
         nfySHhyo1gVl3PuQONLftzBDjAqJSI7KNl3zDniaUZrtBN6ZEmkmxuVKpnetL9XiP/
         XKBVflvwibrhT+xGNz767jueNJZChhGbz7uQ+kJpF2z3y0qpRwfYnU/7JzkdYIOH/2
         IwPRXHRdE5qUg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        johannes@sipsolutions.net, pablo@netfilter.org,
        laforge@gnumonks.org, Jason@zx2c4.com, jgg@nvidia.com,
        leonro@nvidia.com, Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next] net: add ndo_alloc_and_init and ndo_release to replace priv_destructor
Date:   Wed, 11 May 2022 12:12:18 -0700
Message-Id: <20220511191218.1402380-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Old API
-------
Our current API includes .ndo_init, .ndo_uninit and .priv_destructor.
First two are part of netdev_ops the last one is a member of netdevice
and can be overwritten at will by the drivers.

The semantics are that .ndo_uninit releases anything that
can be freed once the device is unlisted, while .priv_destructor
should release any resources which may be accessed outside
of rtnl_lock, only with a reference on the netdev held.

BTW as far as I can tell there is no strong reason for .ndo_init
to exist. It gets called early during registration after
netdev's name gets filled in, and none of the users I checked
care about the name. They could have as well run the code
they have in .ndo_init before calling register_netdevice().

Problem
-------
.priv_destructor gets called if register_netdevice() fails
after calling .ndo_init. This takes many by surprise. We recommend
to move init into .ndo_init, but .ndo_init intuitively pairs
with .ndo_uninit, not .priv_destructor.

A common workaround is to set .priv_destructor after
register_netdevice() succeeds. This works fine in practice but
is not always correct. Theoretically something may nack the

  call_netdevice_notifiers(NETDEV_REGISTER, dev)

after an entity earlier on the notifier chain has taken a ref
on the netdev.

Also the fact that .priv_destructor is a member of netdevice
is slightly suboptimal, security people like when callbacks
live in read-only memory.

New API
-------
We want an intuitive API, which I think should mean symmetric
ndo callbacks only. There is no point in having two steps at
init time so this patch renames .ndo_init as .ndo_alloc_and_init.
.ndo_uninit remains untouched, while .priv_destructor gets
replaced by .ndo_release. (Logically speaking, obviously, the
old callbacks will get removed once current users are migrated.)

That's best I can come up. Using .ndo_free as a name may seem
like a better option but that may make people think it's called
from free_netdev().

.ndo_alloc_and_init grows an @arg parameter because ovs and
gtp want to pass parameters.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/netdevices.rst | 72 ++++++++++++++-----------
 include/linux/netdevice.h               | 40 ++++++++++----
 net/core/dev.c                          | 18 +++++--
 3 files changed, 84 insertions(+), 46 deletions(-)

diff --git a/Documentation/networking/netdevices.rst b/Documentation/networking/netdevices.rst
index 9e4cccb90b87..156417d8ca1f 100644
--- a/Documentation/networking/netdevices.rst
+++ b/Documentation/networking/netdevices.rst
@@ -89,7 +89,8 @@ Device management under RTNL
 Registering struct net_device while in context which already holds
 the ``rtnl_lock`` requires extra care. In those scenarios most drivers
 will want to make use of struct net_device's ``needs_free_netdev``
-and ``priv_destructor`` members for freeing of state.
+and ``.ndo_alloc_and_init`` / ``.ndo_uninit`` / ``.ndo_release`` members
+for freeing of the state.
 
 Example flow of netdev handling under ``rtnl_lock``:
 
@@ -100,12 +101,36 @@ and ``priv_destructor`` members for freeing of state.
     dev->needs_free_netdev = true;
   }
 
-  static void my_destructor(struct net_device *dev)
+  static int my_ndo_alloc_and_init(struct net_device *dev, void *arg)
   {
+    struct my_device_priv *priv = netdev_priv(dev);
+    int err;
+
+    priv->obj = some_obj_create();
+    if (!priv->obj)
+      return -ENOMEM;
+
+    err = some_init(priv);
+    if (err)
+      goto err_some_free;
+
+    return 0;
+
+  err_some_uninit:
     some_obj_destroy(priv->obj);
+    return err;
+  }
+
+  static void my_ndo_uninit(struct net_device *dev)
+  {
     some_uninit(priv);
   }
 
+  static void my_ndo_release(struct net_device *dev)
+  {
+    some_obj_destroy(priv->obj);
+  }
+
   int create_link()
   {
     struct my_device_priv *priv;
@@ -118,19 +143,6 @@ and ``priv_destructor`` members for freeing of state.
       return -ENOMEM;
     priv = netdev_priv(dev);
 
-    /* Implicit constructor */
-    err = some_init(priv);
-    if (err)
-      goto err_free_dev;
-
-    priv->obj = some_obj_create();
-    if (!priv->obj) {
-      err = -ENOMEM;
-      goto err_some_uninit;
-    }
-    /* End of constructor, set the destructor: */
-    dev->priv_destructor = my_destructor;
-
     err = register_netdevice(dev);
     if (err)
       /* register_netdevice() calls destructor on failure */
@@ -149,13 +161,9 @@ and ``priv_destructor`` members for freeing of state.
     return err;
   }
 
-If struct net_device.priv_destructor is set it will be called by the core
-some time after unregister_netdevice(), it will also be called if
-register_netdevice() fails. The callback may be invoked with or without
-``rtnl_lock`` held.
-
-There is no explicit constructor callback, driver "constructs" the private
-netdev state after allocating it and before registration.
+``.ndo_alloc_and_init`` prepares and allocates all the state. ``.ndo_uninit``
+cleans up what can be cleaned up while not all references are gone,
+``.ndo_release`` cleans up what needs to wait for references to be released.
 
 Setting struct net_device.needs_free_netdev makes core call free_netdevice()
 automatically after unregister_netdevice() when all references to the device
@@ -171,16 +179,20 @@ will defer some of the processing until ``rtnl_lock`` is released.
 Devices spawned from struct rtnl_link_ops should never free the
 struct net_device directly.
 
-.ndo_init and .ndo_uninit
-~~~~~~~~~~~~~~~~~~~~~~~~~
+.ndo_alloc_and_init, .ndo_uninit and .ndo_release
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+``.ndo_alloc_and_init`` and ``.ndo_uninit`` callbacks are called during
+net_device registration and de-registration, under ``rtnl_lock``. Drivers can
+use those e.g. when parts of their init process need to run under ``rtnl_lock``.
 
-``.ndo_init`` and ``.ndo_uninit`` callbacks are called during net_device
-registration and de-registration, under ``rtnl_lock``. Drivers can use
-those e.g. when parts of their init process need to run under ``rtnl_lock``.
+``.ndo_alloc_and_init`` runs before device is visible in the system,
+``.ndo_uninit`` runs during de-registering after device is closed but
+other subsystems may still have outstanding references to the netdevice.
 
-``.ndo_init`` runs before device is visible in the system, ``.ndo_uninit``
-runs during de-registering after device is closed but other subsystems
-may still have outstanding references to the netdevice.
+For freeing state which needs to remain in place until all netdev references
+had been released use ``.ndo_release``. Note, however, that ``.ndo_release``
+does not give guarantees on whether the ``rtnl_lock`` is held.
 
 MTU
 ===
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 050aa4d95a69..97ed639a04f0 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1033,16 +1033,6 @@ struct netdev_net_notifier {
  * The following hooks can be defined; unless noted otherwise, they are
  * optional and can be filled with a null pointer.
  *
- * int (*ndo_init)(struct net_device *dev);
- *     This function is called once when a network device is registered.
- *     The network device can use this for any late stage initialization
- *     or semantic validation. It can fail with an error code which will
- *     be propagated back to register_netdev.
- *
- * void (*ndo_uninit)(struct net_device *dev);
- *     This function is called when device is unregistered or when registration
- *     fails. It is not called if init fails.
- *
  * int (*ndo_open)(struct net_device *dev);
  *     This function is called when a network device transitions to the up
  *     state.
@@ -1365,8 +1355,32 @@ struct netdev_net_notifier {
  *	free running cycle counter.
  */
 struct net_device_ops {
+	/*
+	 * @ndo_init:
+	 * @ndo_alloc_and_init:
+	 *	Called once when a network device is registered.
+	 *	The network device can use this for any late stage
+	 *	initialization or semantic validation. It can fail with an error
+	 *	code which will be propagated back to register_netdev().
+	 *	Context: sleeping, RTNL lock held.
+	 * @ndo_uninit:
+	 *	Called when device is unregistered or when registration fails
+	 *	after calling @ndo_alloc_and_init. Outstanding references
+	 *	to the netdev may still exist.
+	 *	Context: sleeping, RTNL lock held.
+	 * @ndo_release:
+	 *	Called when all netdev references had been released when
+	 *	device is unregistered or when registration fails after calling
+	 *	@ndo_init. Use this callback to free device-specific state
+	 *	which may be accessed without the RTNL lock, only a reference
+	 *	on the netdev.
+	 *	Context: sleeping, RTNL *may* be held!
+	 */
 	int			(*ndo_init)(struct net_device *dev);
+	int			(*ndo_alloc_and_init)(struct net_device *dev,
+						      void *arg);
 	void			(*ndo_uninit)(struct net_device *dev);
+	void			(*ndo_release)(struct net_device *dev);
 	int			(*ndo_open)(struct net_device *dev);
 	int			(*ndo_stop)(struct net_device *dev);
 	netdev_tx_t		(*ndo_start_xmit)(struct sk_buff *skb,
@@ -3001,7 +3015,11 @@ static inline int dev_direct_xmit(struct sk_buff *skb, u16 queue_id)
 	return ret;
 }
 
-int register_netdevice(struct net_device *dev);
+int register_netdevice_arg(struct net_device *dev, void *arg);
+static inline int register_netdevice(struct net_device *dev)
+{
+	return register_netdevice_arg(dev, NULL);
+}
 void unregister_netdevice_queue(struct net_device *dev, struct list_head *head);
 void unregister_netdevice_many(struct list_head *head);
 static inline void unregister_netdevice(struct net_device *dev)
diff --git a/net/core/dev.c b/net/core/dev.c
index 91b7e7784da9..c39a623267e0 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9927,8 +9927,9 @@ void netif_tx_stop_all_queues(struct net_device *dev)
 EXPORT_SYMBOL(netif_tx_stop_all_queues);
 
 /**
- *	register_netdevice	- register a network device
+ *	register_netdevice_arg() - register a network device
  *	@dev: device to register
+ *	@arg: optional argument for .ndo_alloc_and_init
  *
  *	Take a completed network device structure and add it to the kernel
  *	interfaces. A %NETDEV_REGISTER message is sent to the netdev notifier
@@ -9943,7 +9944,7 @@ EXPORT_SYMBOL(netif_tx_stop_all_queues);
  *	will not get the same name.
  */
 
-int register_netdevice(struct net_device *dev)
+int register_netdevice_arg(struct net_device *dev, void *arg)
 {
 	int ret;
 	struct net *net = dev_net(dev);
@@ -9976,8 +9977,11 @@ int register_netdevice(struct net_device *dev)
 		goto out;
 
 	/* Init, if this function is available */
-	if (dev->netdev_ops->ndo_init) {
-		ret = dev->netdev_ops->ndo_init(dev);
+	if (dev->netdev_ops->ndo_init || dev->netdev_ops->ndo_alloc_and_init) {
+		if (dev->netdev_ops->ndo_init)
+			ret = dev->netdev_ops->ndo_init(dev);
+		else if (dev->netdev_ops->ndo_alloc_and_init)
+			ret = dev->netdev_ops->ndo_alloc_and_init(dev, arg);
 		if (ret) {
 			if (ret > 0)
 				ret = -EIO;
@@ -10102,13 +10106,15 @@ int register_netdevice(struct net_device *dev)
 err_uninit:
 	if (dev->netdev_ops->ndo_uninit)
 		dev->netdev_ops->ndo_uninit(dev);
+	if (dev->netdev_ops->ndo_release)
+		dev->netdev_ops->ndo_release(dev);
 	if (dev->priv_destructor)
 		dev->priv_destructor(dev);
 err_free_name:
 	netdev_name_node_free(dev->name_node);
 	goto out;
 }
-EXPORT_SYMBOL(register_netdevice);
+EXPORT_SYMBOL(register_netdevice_arg);
 
 /**
  *	init_dummy_netdev	- init a dummy network device for NAPI
@@ -10351,6 +10357,8 @@ void netdev_run_todo(void)
 #if IS_ENABLED(CONFIG_DECNET)
 		WARN_ON(dev->dn_ptr);
 #endif
+		if (dev->netdev_ops->ndo_release)
+			dev->netdev_ops->ndo_release(dev);
 		if (dev->priv_destructor)
 			dev->priv_destructor(dev);
 		if (dev->needs_free_netdev)
-- 
2.34.3

