Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB9783AF8C9
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 00:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232272AbhFUWxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 18:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232064AbhFUWxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 18:53:23 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34711C061756
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 15:51:07 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id d13so27361998ljg.12
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 15:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dMyzUQy++YboJsJGgtN6WVWJcqkKPrNCnvp07T7VaEs=;
        b=ZPbk5IJzo+svcvKtsSgT41TSzGeQJjCMb7Ow4I82T6uYGJXZsm2Fv9D07rIIiUmfhq
         4X5O9uRZbdCE9tp5W/q377wEYUbbfjJzhO0yvmohSrR6lI4t/wbw/e66vLIkCmCpD2bN
         4cgNF6scCdDh3z1cA2j9/jLb26n54g8GXsyy0nWF1aFujRdcrKbGO4iGJo4OtjSSdG+W
         AUamcjCzdaFkpy5GCGZgSTgHDxAPXswk8SQFYQ+pOlxDzx6Em3yNFipxEmeI+mvQDm1s
         6GWMVaVXaO+4b39jGiNeCfGmM2nMPjG2gwPDTg+cSEn0fLHKKh0KaAdtNvMm11tTYQAa
         /OAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dMyzUQy++YboJsJGgtN6WVWJcqkKPrNCnvp07T7VaEs=;
        b=DgQxOXbIF9pagAFUAAsk3zPiSw3OyuS7m+mFgwOsLggSuFBEUKNUfoM4PacYagrHiV
         XoMSajsZ2NvxTuqCDcKOBLDVkzfa2HeaCaGRVg/uGSNFcmBoX9DB7LYWDNJ2jWPwY7IH
         DKRV3dUOPmXy+ZMFWTVEePlc+p4MrdmVHPL7eU4CzCxxADw+DlRsXXcYMl24qS6eA0a1
         jtp/SB6yiwqCLTdrtIgROzBFgK2ueds+H5PEz3HDB4UncpF2qF+VoCKMISu+zXIGJ2A0
         /6yI73HaCfElFWeGYf190wzI2DNezNbLkFPdmSaFbiORfUgulSar84PNYfgpDdu3TTZr
         qbVA==
X-Gm-Message-State: AOAM531b5+cMK7NoZqzYYgr4DerkJbgVKAVg9XhNpIP6xmnZAFdJHBXm
        ywNCZIO2PO/1jHgunn16gAc=
X-Google-Smtp-Source: ABdhPJxoPMRFyMui+6K0Sjgxm78jvq+eImcicKUAE425O/PxnreIKkTtuhg/5HPprwEIN+ZDv8p/OA==
X-Received: by 2002:a2e:5c08:: with SMTP id q8mr431730ljb.145.1624315865580;
        Mon, 21 Jun 2021 15:51:05 -0700 (PDT)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id x207sm124826lff.53.2021.06.21.15.51.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 15:51:05 -0700 (PDT)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next v2 01/10] wwan_hwsim: support network interface creation
Date:   Tue, 22 Jun 2021 01:50:51 +0300
Message-Id: <20210621225100.21005-2-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210621225100.21005-1-ryazanov.s.a@gmail.com>
References: <20210621225100.21005-1-ryazanov.s.a@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for networking interface creation via the WWAN core by
registering the WWAN netdev creation ops for each simulated WWAN device.
Implemented minimalistic netdev support where the xmit callback just
consumes all egress skbs.

This should help with WWAN network interfaces creation testing.

Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
---

v1 -> v2:
 * no changes

 drivers/net/wwan/wwan_hwsim.c | 48 +++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/drivers/net/wwan/wwan_hwsim.c b/drivers/net/wwan/wwan_hwsim.c
index 472cae544a2b..c1e850b9c087 100644
--- a/drivers/net/wwan/wwan_hwsim.c
+++ b/drivers/net/wwan/wwan_hwsim.c
@@ -14,10 +14,13 @@
 #include <linux/spinlock.h>
 #include <linux/list.h>
 #include <linux/skbuff.h>
+#include <linux/netdevice.h>
 #include <linux/wwan.h>
 #include <linux/debugfs.h>
 #include <linux/workqueue.h>
 
+#include <net/arp.h>
+
 static int wwan_hwsim_devsnum = 2;
 module_param_named(devices, wwan_hwsim_devsnum, int, 0444);
 MODULE_PARM_DESC(devices, "Number of simulated devices");
@@ -64,6 +67,38 @@ static const struct file_operations wwan_hwsim_debugfs_devdestroy_fops;
 static void wwan_hwsim_port_del_work(struct work_struct *work);
 static void wwan_hwsim_dev_del_work(struct work_struct *work);
 
+static netdev_tx_t wwan_hwsim_netdev_xmit(struct sk_buff *skb,
+					  struct net_device *ndev)
+{
+	ndev->stats.tx_packets++;
+	ndev->stats.tx_bytes += skb->len;
+	consume_skb(skb);
+	return NETDEV_TX_OK;
+}
+
+static const struct net_device_ops wwan_hwsim_netdev_ops = {
+	.ndo_start_xmit = wwan_hwsim_netdev_xmit,
+};
+
+static void wwan_hwsim_netdev_setup(struct net_device *ndev)
+{
+	ndev->netdev_ops = &wwan_hwsim_netdev_ops;
+	ndev->needs_free_netdev = true;
+
+	ndev->mtu = ETH_DATA_LEN;
+	ndev->min_mtu = ETH_MIN_MTU;
+	ndev->max_mtu = ETH_MAX_MTU;
+
+	ndev->type = ARPHRD_NONE;
+	ndev->flags = IFF_POINTOPOINT | IFF_NOARP;
+}
+
+static const struct wwan_ops wwan_hwsim_wwan_rtnl_ops = {
+	.owner = THIS_MODULE,
+	.priv_size = 0,			/* No private data */
+	.setup = wwan_hwsim_netdev_setup,
+};
+
 static int wwan_hwsim_port_start(struct wwan_port *wport)
 {
 	struct wwan_hwsim_port *port = wwan_port_get_drvdata(wport);
@@ -254,6 +289,10 @@ static struct wwan_hwsim_dev *wwan_hwsim_dev_new(void)
 
 	INIT_WORK(&dev->del_work, wwan_hwsim_dev_del_work);
 
+	err = wwan_register_ops(&dev->dev, &wwan_hwsim_wwan_rtnl_ops, dev);
+	if (err)
+		goto err_unreg_dev;
+
 	dev->debugfs_topdir = debugfs_create_dir(dev_name(&dev->dev),
 						 wwan_hwsim_debugfs_topdir);
 	debugfs_create_file("destroy", 0200, dev->debugfs_topdir, dev,
@@ -265,6 +304,12 @@ static struct wwan_hwsim_dev *wwan_hwsim_dev_new(void)
 
 	return dev;
 
+err_unreg_dev:
+	device_unregister(&dev->dev);
+	/* Memory will be freed in the device release callback */
+
+	return ERR_PTR(err);
+
 err_free_dev:
 	kfree(dev);
 
@@ -290,6 +335,9 @@ static void wwan_hwsim_dev_del(struct wwan_hwsim_dev *dev)
 
 	debugfs_remove(dev->debugfs_topdir);
 
+	/* This will remove all child netdev(s) */
+	wwan_unregister_ops(&dev->dev);
+
 	/* Make sure that there is no pending deletion work */
 	if (current_work() != &dev->del_work)
 		cancel_work_sync(&dev->del_work);
-- 
2.26.3

