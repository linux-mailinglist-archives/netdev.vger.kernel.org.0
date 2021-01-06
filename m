Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B797A2EC350
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 19:41:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbhAFSk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 13:40:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:60926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725800AbhAFSky (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 13:40:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B56282312E;
        Wed,  6 Jan 2021 18:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609958414;
        bh=+RzsTnhe1k6OhIx+Tp2vR0dTQGfo1k6qgy8dqBi1zfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yp6kb5Co74v9jefJdyBsxxixxJ53oilBzlWW9krWJqCY7Fz1DzQxyLu1APV+usS1g
         JNVmQvGvTHFI3bTZ6UILFEqgLtun3alHKj6pqSyxGWggYtOfspA/Udcct7WjoRD7gh
         ZUjzy1DN4b9UCKUEvFXBDx5/B0av7ulSgMh2WLTZNjQ1jSdvOaCsvqGCNq4O5abtXj
         /uZoDXPScFfcuUAx5QoOnjrz40naz8sYUNum1cE2fna+eTezbCuZ8bpl2oQYeh+FRh
         mSv+aHHD1mstx9+EX9JLUS3xfolnX7L9W2LcfJHf0YSnVwAZGpOk5IJtZoTChgxfaP
         yaiineGHYvSXA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        f.fainelli@gmail.com, xiyou.wangcong@gmail.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 1/3] docs: net: explain struct net_device lifetime
Date:   Wed,  6 Jan 2021 10:40:05 -0800
Message-Id: <20210106184007.1821480-2-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210106184007.1821480-1-kuba@kernel.org>
References: <20210106184007.1821480-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Explain the two basic flows of struct net_device's operation.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/netdevices.rst | 171 +++++++++++++++++++++++-
 net/core/rtnetlink.c                    |   2 +-
 2 files changed, 166 insertions(+), 7 deletions(-)

diff --git a/Documentation/networking/netdevices.rst b/Documentation/networking/netdevices.rst
index e65665c5ab50..17bdcb746dcf 100644
--- a/Documentation/networking/netdevices.rst
+++ b/Documentation/networking/netdevices.rst
@@ -10,18 +10,177 @@ Introduction
 The following is a random collection of documentation regarding
 network devices.
 
-struct net_device allocation rules
-==================================
+struct net_device lifetime rules
+================================
 Network device structures need to persist even after module is unloaded and
 must be allocated with alloc_netdev_mqs() and friends.
 If device has registered successfully, it will be freed on last use
-by free_netdev(). This is required to handle the pathologic case cleanly
-(example: rmmod mydriver </sys/class/net/myeth/mtu )
+by free_netdev(). This is required to handle the pathological case cleanly
+(example: ``rmmod mydriver </sys/class/net/myeth/mtu``)
 
-alloc_netdev_mqs()/alloc_netdev() reserve extra space for driver
+alloc_netdev_mqs() / alloc_netdev() reserve extra space for driver
 private data which gets freed when the network device is freed. If
 separately allocated data is attached to the network device
-(netdev_priv(dev)) then it is up to the module exit handler to free that.
+(netdev_priv()) then it is up to the module exit handler to free that.
+
+There are two groups of APIs for registering struct net_device.
+First group can be used in normal contexts where ``rtnl_lock`` is not already
+held: register_netdev(), unregister_netdev().
+Second group can be used when ``rtnl_lock`` is already held:
+register_netdevice(), unregister_netdevice(), free_netdevice().
+
+Simple drivers
+--------------
+
+Most drivers (especially device drivers) handle lifetime of struct net_device
+in context where ``rtnl_lock`` is not held (e.g. driver probe and remove paths).
+
+In that case the struct net_device registration is done using
+the register_netdev(), and unregister_netdev() functions:
+
+.. code-block:: c
+
+  int probe()
+  {
+    struct my_device_priv *priv;
+    int err;
+
+    dev = alloc_netdev_mqs(...);
+    if (!dev)
+      return -ENOMEM;
+    priv = netdev_priv(dev);
+
+    /* ... do all device setup before calling register_netdev() ...
+     */
+
+    err = register_netdev(dev);
+    if (err)
+      goto err_undo;
+
+    /* net_device is visible to the user! */
+
+  err_undo:
+    /* ... undo the device setup ... */
+    free_netdev(dev);
+    return err;
+  }
+
+  void remove()
+  {
+    unregister_netdev(dev);
+    free_netdev(dev);
+  }
+
+Note that after calling register_netdev() the device is visible in the system.
+Users can open it and start sending / receiving traffic immediately,
+or run any other callback, so all initialization must be done prior to
+registration.
+
+unregister_netdev() closes the device and waits for all users to be done
+with it. The memory of struct net_device itself may still be referenced
+by sysfs but all operations on that device will fail.
+
+free_netdev() can be called after unregister_netdev() returns on when
+register_netdev() failed.
+
+Device management under RTNL
+----------------------------
+
+Registering struct net_device while in context which already holds
+the ``rtnl_lock`` requires extra care. In those scenarios most drivers
+will want to make use of struct net_device's ``needs_free_netdev``
+and ``priv_destructor`` members for freeing of state.
+
+Example flow of netdev handling under ``rtnl_lock``:
+
+.. code-block:: c
+
+  static void my_setup(struct net_device *dev)
+  {
+    dev->needs_free_netdev = true;
+  }
+
+  static void my_destructor(struct net_device *dev)
+  {
+    some_obj_destroy(priv->obj);
+    some_uninit(priv);
+  }
+
+  int create_link()
+  {
+    struct my_device_priv *priv;
+    int err;
+
+    ASSERT_RTNL();
+
+    dev = alloc_netdev(sizeof(*priv), "net%d", NET_NAME_UNKNOWN, my_setup);
+    if (!dev)
+      return -ENOMEM;
+    priv = netdev_priv(dev);
+
+    /* Implicit constructor */
+    err = some_init(priv);
+    if (err)
+      goto err_free_dev;
+
+    priv->obj = some_obj_create();
+    if (!priv->obj) {
+      err = -ENOMEM;
+      goto err_some_uninit;
+    }
+    /* End of constructor, set the destructor: */
+    dev->priv_destructor = my_destructor;
+
+    err = register_netdevice(dev);
+    if (err)
+      /* register_netdevice() calls destructor on failure */
+      goto err_free_dev;
+
+    /* If anything fails now unregister_netdevice() (or unregister_netdev())
+     * will take care of calling my_destructor and free_netdev().
+     */
+
+    return 0;
+
+  err_some_uninit:
+    some_uninit(priv);
+  err_free_dev:
+    free_netdev(dev);
+    return err;
+  }
+
+If struct net_device.priv_destructor is set it will be called by the core
+some time after unregister_netdevice(), it will also be called if
+register_netdevice() fails. The callback may be invoked with or without
+``rtnl_lock`` held.
+
+There is no explicit constructor callback, driver "constructs" the private
+netdev state after allocating it and before registration.
+
+Setting struct net_device.needs_free_netdev makes core call free_netdevice()
+automatically after unregister_netdevice() when all references to the device
+are gone. It only takes effect after a successful call to register_netdevice()
+so if register_netdevice() fails driver is responsible for calling
+free_netdev().
+
+free_netdev() is safe to call on error paths right after unregister_netdevice()
+or when register_netdevice() fails. Parts of netdev (de)registration process
+happen after ``rtnl_lock`` is released, therefore in those cases free_netdev()
+will defer some of the processing until ``rtnl_lock`` is released.
+
+Devices spawned from struct rtnl_link_ops should never free the
+struct net_device directly.
+
+.ndo_init and .ndo_uninit
+~~~~~~~~~~~~~~~~~~~~~~~~~
+
+``.ndo_init`` and ``.ndo_uninit`` callbacks are called during net_device
+registration and de-registration, under ``rtnl_lock``. Drivers can use
+those e.g. when parts of their init process need to run under ``rtnl_lock``.
+
+``.ndo_init`` runs before device is visible in the system, ``.ndo_uninit``
+runs during de-registering after device is closed but other subsystems
+may still have outstanding references to the netdevice.
 
 MTU
 ===
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index bb0596c41b3e..79f514afb17d 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3441,7 +3441,7 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	if (ops->newlink) {
 		err = ops->newlink(link_net ? : net, dev, tb, data, extack);
-		/* Drivers should call free_netdev() in ->destructor
+		/* Drivers should set dev->needs_free_netdev
 		 * and unregister it on failure after registration
 		 * so that device could be finally freed in rtnl_unlock.
 		 */
-- 
2.26.2

