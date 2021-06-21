Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2301F3AF8D0
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 00:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232418AbhFUWxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 18:53:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232362AbhFUWx3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 18:53:29 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C1FC061766
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 15:51:12 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id s22so27437091ljg.5
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 15:51:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zcdADzIGh+z3t+SaH4RHteH4RWCo6WcuMAbfzh1uCAw=;
        b=eBf1uabi1uionfaYTbnmSj8afVcTCtsuOxiRLm5O9LeNJGvgQ6Cxyo4oPwmvuyDIYI
         fK3RR2XcOiWPUqwlxCtzizWnipZtYgQlMbasuXY9vTyXr662C5ipiJa4rEvnCNK/kR9i
         7J+UXlU0vDAS+gRuwwisBB5S1SW58YBktv2tcQA6JSBnQOc4MA/lro5JmPSp4ftpzaa7
         p7LJU7HMo2VtI72LB9Onp3Abxd+8UAM1eZ5Ty0BSXMhZ4vkfni4FzHjcXf3TkM62KWmz
         EAqHkJsBPlcBB+zL7o0zH/erXOJC0mZoV0Bt7MfYJli6BHjciZ/SR0VClAQd0qS/2Z40
         HmeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zcdADzIGh+z3t+SaH4RHteH4RWCo6WcuMAbfzh1uCAw=;
        b=rIAqsMvaY/nX+2wUKKMxDIdROR16z20YBT8wt4w5/GRqeYf6kfTAXfGX27w5/SWTpx
         2v2yiJmCSfNontW3Z1aJdzHgX4mmZCcU1A2jjfWboGWy5ChBCHSxl2wvz4FMiPvBYeIk
         Vg9Bbg08T/vcD42SzsjjXMUQ7evBgAMsat8cBK25FchM7qSuD6cA+3g03jb6ImYzYh68
         FmBBSy0Ve3R1dDLVs0TseX+lDxs9SzOCxE7nOMOswRmQy/9+oS8wHLCvFSyYaxQCGSVf
         jnmMd2MDP/HZLa0Dl7RZLIOyqkr+hw8u/rUADifGXM+N4+RKzXdLMbRjDUSnL0N8l20Q
         jwhQ==
X-Gm-Message-State: AOAM530pui9HB8ZfJPQiu+vWZWTy2jUY09HURuWz5JaKVPsihxQbg1Jr
        1sYee54NV9SCRgIfqit7KcQ=
X-Google-Smtp-Source: ABdhPJzRrQLbZtnRt0gq7Ezmxrtqr2RG8qZQiwfSTPfTFJx1XaaNHVXjSTQLQ16oSlivxpssh20oTA==
X-Received: by 2002:a2e:894e:: with SMTP id b14mr462895ljk.112.1624315871323;
        Mon, 21 Jun 2021 15:51:11 -0700 (PDT)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id x207sm124826lff.53.2021.06.21.15.51.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 15:51:10 -0700 (PDT)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next v2 07/10] wwan: core: no more hold netdev ops owning module
Date:   Tue, 22 Jun 2021 01:50:57 +0300
Message-Id: <20210621225100.21005-8-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210621225100.21005-1-ryazanov.s.a@gmail.com>
References: <20210621225100.21005-1-ryazanov.s.a@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The WWAN netdev ops owner holding was used to protect from the
unexpected memory disappear. This approach causes a dependency cycle
(driver -> core -> driver) and effectively prevents a WWAN driver
unloading. E.g. WWAN hwsim could not be unloaded until all simulated
devices are removed:

~# modprobe wwan_hwsim devices=2
~# lsmod | grep wwan
wwan_hwsim             16384  2
wwan                   20480  1 wwan_hwsim
~# rmmod wwan_hwsim
rmmod: ERROR: Module wwan_hwsim is in use
~# echo > /sys/kernel/debug/wwan_hwsim/hwsim0/destroy
~# echo > /sys/kernel/debug/wwan_hwsim/hwsim1/destroy
~# lsmod | grep wwan
wwan_hwsim             16384  0
wwan                   20480  1 wwan_hwsim
~# rmmod wwan_hwsim

For a real device driver this will cause an inability to unload module
until a served device is physically detached.

Since the last commit we are removing all child netdev(s) when a driver
unregister the netdev ops. This allows us to permit the driver
unloading, since any sane driver will call ops unregistering on a device
deinitialization. So, remove the holding of an ops owner to make it
easier to unload a driver module. The owner field has also beed removed
from the ops structure as there are no more users of this field.

Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
---

v1 -> v2:
 * fix a comment before wwan_unregister_ops() in the mhi/net.c

 drivers/net/mhi/net.c         |  3 +--
 drivers/net/wwan/wwan_core.c  | 10 ----------
 drivers/net/wwan/wwan_hwsim.c |  1 -
 include/linux/wwan.h          |  2 --
 4 files changed, 1 insertion(+), 15 deletions(-)

diff --git a/drivers/net/mhi/net.c b/drivers/net/mhi/net.c
index 6aa753387372..ffd1c01b3f35 100644
--- a/drivers/net/mhi/net.c
+++ b/drivers/net/mhi/net.c
@@ -383,7 +383,6 @@ static void mhi_net_dellink(void *ctxt, struct net_device *ndev,
 }
 
 static const struct wwan_ops mhi_wwan_ops = {
-	.owner = THIS_MODULE,
 	.priv_size = sizeof(struct mhi_net_dev),
 	.setup = mhi_net_setup,
 	.newlink = mhi_net_newlink,
@@ -436,7 +435,7 @@ static void mhi_net_remove(struct mhi_device *mhi_dev)
 	struct mhi_net_dev *mhi_netdev = dev_get_drvdata(&mhi_dev->dev);
 	struct mhi_controller *cntrl = mhi_dev->mhi_cntrl;
 
-	/* rtnetlink takes care of removing remaining links */
+	/* WWAN core takes care of removing remaining links */
 	wwan_unregister_ops(&cntrl->mhi_dev->dev);
 
 	if (create_default_iface)
diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
index ec6a69b23dd1..b634a0ba1196 100644
--- a/drivers/net/wwan/wwan_core.c
+++ b/drivers/net/wwan/wwan_core.c
@@ -929,11 +929,6 @@ int wwan_register_ops(struct device *parent, const struct wwan_ops *ops,
 		return -EBUSY;
 	}
 
-	if (!try_module_get(ops->owner)) {
-		wwan_remove_dev(wwandev);
-		return -ENODEV;
-	}
-
 	wwandev->ops = ops;
 	wwandev->ops_ctxt = ctxt;
 
@@ -960,7 +955,6 @@ static int wwan_child_dellink(struct device *dev, void *data)
 void wwan_unregister_ops(struct device *parent)
 {
 	struct wwan_device *wwandev = wwan_dev_get_by_parent(parent);
-	struct module *owner;
 	LIST_HEAD(kill_list);
 
 	if (WARN_ON(IS_ERR(wwandev)))
@@ -976,8 +970,6 @@ void wwan_unregister_ops(struct device *parent)
 	 */
 	put_device(&wwandev->dev);
 
-	owner = wwandev->ops->owner;	/* Preserve ops owner */
-
 	rtnl_lock();	/* Prevent concurent netdev(s) creation/destroying */
 
 	/* Remove all child netdev(s), using batch removing */
@@ -989,8 +981,6 @@ void wwan_unregister_ops(struct device *parent)
 
 	rtnl_unlock();
 
-	module_put(owner);
-
 	wwandev->ops_ctxt = NULL;
 	wwan_remove_dev(wwandev);
 }
diff --git a/drivers/net/wwan/wwan_hwsim.c b/drivers/net/wwan/wwan_hwsim.c
index c1e850b9c087..a8582a58a385 100644
--- a/drivers/net/wwan/wwan_hwsim.c
+++ b/drivers/net/wwan/wwan_hwsim.c
@@ -94,7 +94,6 @@ static void wwan_hwsim_netdev_setup(struct net_device *ndev)
 }
 
 static const struct wwan_ops wwan_hwsim_wwan_rtnl_ops = {
-	.owner = THIS_MODULE,
 	.priv_size = 0,			/* No private data */
 	.setup = wwan_hwsim_netdev_setup,
 };
diff --git a/include/linux/wwan.h b/include/linux/wwan.h
index 34222230360c..e1981ea3a2fd 100644
--- a/include/linux/wwan.h
+++ b/include/linux/wwan.h
@@ -128,14 +128,12 @@ void *wwan_port_get_drvdata(struct wwan_port *port);
 
 /**
  * struct wwan_ops - WWAN device ops
- * @owner: module owner of the WWAN ops
  * @priv_size: size of private netdev data area
  * @setup: set up a new netdev
  * @newlink: register the new netdev
  * @dellink: remove the given netdev
  */
 struct wwan_ops {
-	struct module *owner;
 	unsigned int priv_size;
 	void (*setup)(struct net_device *dev);
 	int (*newlink)(void *ctxt, struct net_device *dev,
-- 
2.26.3

