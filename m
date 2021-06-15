Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E40EE3A72FC
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 02:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbhFOAcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 20:32:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbhFOAcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 20:32:32 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2D32C061280
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 17:30:28 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id f30so24011696lfj.1
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 17:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cdp9YxzUFC9kGIUU/5fRFVyTA0S6VIcnorPRw1B//34=;
        b=qGHoBAdd5afRP+ysBAcia5MeML2sTR9FjF1VBYx9rGSnqqeBFDbgHugCZ3r+AyYNCY
         gGHs7K+n6MHIbLoh8W1PDEGFz4boCMdBn6AXAhIqryksQJsE4JCPrFh0V77CuMl1spnu
         zzPzVkOtFTKgnqqti7i7HWRmVFbg3HjDJ/S2ObBOwOSlKx5xH2EMg2UfQo3lwZ0etPtI
         EZD0tDnW+09aXv4knMm7XCU3dRkWI0YlDs72F8iVore+6pO4468PMoC9N1nGKv6B40Dq
         2UFw2mzxMX2n02fB/outCqBM4vrHwyBYmGs7ncUbmFffTNCWvjJGqh18SdnwWK2oWw7i
         qulA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cdp9YxzUFC9kGIUU/5fRFVyTA0S6VIcnorPRw1B//34=;
        b=ewxO3Gs4rllnq7IhL3TZSYyMXExdIJ6POIU5/OR15MRUj7nA+hsNwuy4lgUjO2/xKn
         2Skif6n6z6Qaxzxm/gaHoVUkI1rTqOmXlw6dBq01NmL3MlrgaaWapk6ErpjytuDMqWVX
         jejkcKPZN9aPf1f67P1bCY2b14R9xepLC9DoL9iHE90EjKJGetn47kR45ahMffNUDKdc
         xUdEewgmdDtg3nnNGCIpSOD6D+dv15+c88bFfLosBM6Tx4vxFOaxl2NZrPoxwymFWw7t
         rPdL6rWJQVmrTIg4q5j+IoSkfw+XNG76YkRsWo0ThAAe4pUjzvycBx24djkzMp/jeU+B
         Gh2w==
X-Gm-Message-State: AOAM53385Muv4ULQLjdfUA0AJc0PQ5bUMfOBJgI8XFkW56gzXTvv42oZ
        HO5sh+0vued5JSyIdTqQ6gg=
X-Google-Smtp-Source: ABdhPJy4GzfjWbsXKuniuP01DeLz0Pk9huyLF7+ziiDOg4a7q3Kp7FtWFlS6QwXK45U7fdLIZhN1tA==
X-Received: by 2002:a19:e008:: with SMTP id x8mr14115788lfg.439.1623717027286;
        Mon, 14 Jun 2021 17:30:27 -0700 (PDT)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id 9sm1635522lfy.41.2021.06.14.17.30.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 17:30:26 -0700 (PDT)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 07/10] wwan: core: no more hold netdev ops owning module
Date:   Tue, 15 Jun 2021 03:30:13 +0300
Message-Id: <20210615003016.477-8-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210615003016.477-1-ryazanov.s.a@gmail.com>
References: <20210615003016.477-1-ryazanov.s.a@gmail.com>
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
 drivers/net/mhi/net.c         |  1 -
 drivers/net/wwan/wwan_core.c  | 10 ----------
 drivers/net/wwan/wwan_hwsim.c |  1 -
 include/linux/wwan.h          |  2 --
 4 files changed, 14 deletions(-)

diff --git a/drivers/net/mhi/net.c b/drivers/net/mhi/net.c
index 64af1e518484..ebd1dbf0a536 100644
--- a/drivers/net/mhi/net.c
+++ b/drivers/net/mhi/net.c
@@ -383,7 +383,6 @@ static void mhi_net_dellink(void *ctxt, struct net_device *ndev,
 }
 
 const struct wwan_ops mhi_wwan_ops = {
-	.owner = THIS_MODULE,
 	.priv_size = sizeof(struct mhi_net_dev),
 	.setup = mhi_net_setup,
 	.newlink = mhi_net_newlink,
diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
index 3f04e674cdaa..28590405172c 100644
--- a/drivers/net/wwan/wwan_core.c
+++ b/drivers/net/wwan/wwan_core.c
@@ -921,11 +921,6 @@ int wwan_register_ops(struct device *parent, const struct wwan_ops *ops,
 		return -EBUSY;
 	}
 
-	if (!try_module_get(ops->owner)) {
-		wwan_remove_dev(wwandev);
-		return -ENODEV;
-	}
-
 	wwandev->ops = ops;
 	wwandev->ops_ctxt = ctxt;
 
@@ -952,7 +947,6 @@ static int wwan_child_dellink(struct device *dev, void *data)
 void wwan_unregister_ops(struct device *parent)
 {
 	struct wwan_device *wwandev = wwan_dev_get_by_parent(parent);
-	struct module *owner;
 	LIST_HEAD(kill_list);
 
 	if (WARN_ON(IS_ERR(wwandev)))
@@ -968,8 +962,6 @@ void wwan_unregister_ops(struct device *parent)
 	 */
 	put_device(&wwandev->dev);
 
-	owner = wwandev->ops->owner;	/* Preserve ops owner */
-
 	rtnl_lock();	/* Prevent concurent netdev(s) creation/destroying */
 
 	/* Remove all child netdev(s), using batch removing */
@@ -981,8 +973,6 @@ void wwan_unregister_ops(struct device *parent)
 
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
index 430a3a0817de..656a571b52ed 100644
--- a/include/linux/wwan.h
+++ b/include/linux/wwan.h
@@ -119,14 +119,12 @@ void *wwan_port_get_drvdata(struct wwan_port *port);
 
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

