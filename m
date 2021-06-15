Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86B373A72FE
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 02:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbhFOAcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 20:32:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbhFOAcl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 20:32:41 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9483C061767
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 17:30:23 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id v22so24006581lfa.3
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 17:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E6Xx52ZxvktgGxM0I//ONofdK4cxEcOYfqnuaBjbxng=;
        b=S0B2ua0KbNw1UrCGu4uCA5H72knrFTvayz+XorMxVWipXnadvk4NsF7Z4743m0XddG
         GU2Rjm/CciW7vLQ8hxvAqH9N1DM0226HFclFjCILvo7U6TQescDbyTGSGyhOWWE2JVqI
         d7VFafzbnOWlcr8kzJr4jcx0R1b27CzPa/+v/QWF5m7CKnW08k1xrl7YqTWXhR9u6dsW
         l9LygU5Gd9m4hLGEfAFGfH5pPHsBoNZKJyIeQUIf/tB3EtzIPAObqbGkRSbZsGGwjhyW
         MRdTBzGavtjd1MBNMVE+bTCWYutHVDU+D4MYzBXDTgvp8FV99Zj9aN9Ric4porTfnrLc
         JCtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E6Xx52ZxvktgGxM0I//ONofdK4cxEcOYfqnuaBjbxng=;
        b=fBgEDSjOR87THKgaf+8WoSdSoJpksI8v4/Oex/N6ZGoigfwcmMapG5+0ojUdFY6GXx
         qSXPT4gHBtpBaPWj3KgrO6IzHsQPDtNtVtFYdk6AKGsPEk9hbETpCzNxnc3HOh2XTYM3
         3ZxJjkaMhpeTKabNsJDkUl+kng6S0biFCGxY5wMwpPHwSJ9nw3qxS0P1yIqXquwIVFl6
         sMJKAULRrPl/sm4Vo61gFu1I+xdNOBtKaVVwrHOh0pHrDtDdhjuVRcP0nF8X+fwE9ICS
         /qWqiqijdufU2VgKIoh6h7IxP7m5GrznszmWXgE7AIYjtf8Ftu5cWQlEqW9wHovmrwW2
         eUHQ==
X-Gm-Message-State: AOAM533RTEuIc7e7efw8j46tVCbRG9UrUdf0N83WbweJ8tWg3M5BFe6X
        IYwVYpsPRbHDcFQs/lGo5dk=
X-Google-Smtp-Source: ABdhPJwBaW2rgHT9Nnbn6co6NXKACQBw501UEMlE7WMIbpeRWGYzSXpyJKz5mZpLaXElIbLmci4dYw==
X-Received: by 2002:a05:6512:1586:: with SMTP id bp6mr13424305lfb.599.1623717021042;
        Mon, 14 Jun 2021 17:30:21 -0700 (PDT)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id 9sm1635522lfy.41.2021.06.14.17.30.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 17:30:20 -0700 (PDT)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 01/10] wwan_hwsim: support network interface creation
Date:   Tue, 15 Jun 2021 03:30:07 +0300
Message-Id: <20210615003016.477-2-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210615003016.477-1-ryazanov.s.a@gmail.com>
References: <20210615003016.477-1-ryazanov.s.a@gmail.com>
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

