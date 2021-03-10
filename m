Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 934B5333C6A
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 13:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232919AbhCJMQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 07:16:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232663AbhCJMPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 07:15:44 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F5DEC061760
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:15:44 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id c10so38186496ejx.9
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:15:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m3PiPYnLrxgFgRayqMMYvq2QfBel2LE9qR5ngBnunts=;
        b=V8Ei452ntlxryU03Rt2YeaHX72Q6hpX1ex5DehxWjJFfJec7PnlV4OKSg9tasV5bL+
         Pvft07lfYt+HklAX11RVs98pd/7jvuiEl4v5hVdZv6F+UKxOelXhnMDXl8mT9KjkTB1y
         AqrTtDOnN+5pG+/mPnddSQ+JsPeBT5TZ+2YZUOzT2rIZrw/ihc/s8+J43mil3EMIgxYW
         tKsAbDwghMN2eo041Dfuo9NVBmh1y+KVjrWJal0YcCSxJv+hr4m1UfcX641HbS7Z7AfA
         gU+Ft18r26d+78UTGcY9YQl0SMUGnUt6DMWbGub84jwg670rJIpkLXC6alHw7n9mkFw5
         4fhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m3PiPYnLrxgFgRayqMMYvq2QfBel2LE9qR5ngBnunts=;
        b=ia0eR9F2QMts00LNGgKrtXDgtbrZmeeSbRG4vsglYbowIVnwht7aczOrrJhuB44nRg
         8MY72tGuSmc1dvNkyIgkaObM3VfSB7h8XyBa+cM7WwVaFXI8bIqNmT558wjVclnMyyCB
         Lf0U9FNRMVki+cMk0/0LSIXnoHfAEDwtaXP/iPNndXcDcIQ6YqxNWmEkw+vKb9a7JIBi
         Xkt75+iSzkYariG1uzkscRCkOEdLKQ6X9PXW0pTcSTve19Fd5zWLGicNi50JhB9dIEp3
         BGz4VQUoCk+8oDKuBUsJ0A7JNl5YxhRLLtTWJefOkitFI0/YMyknXzpdLsebXLDQfl4g
         19+A==
X-Gm-Message-State: AOAM532mnGTRtqqaorX98jU5xybEW2bsmYEZ/kezD0AL5rvxKGkOqCsn
        NOeDAwoG7DlvzUdLW1rvELByqopmQ2r3qA==
X-Google-Smtp-Source: ABdhPJwjeUVpxFs1Wqfj1VEUynl6CuSP1HiGAbfQZgIR7bbae4AyGFHhHgmLxVqdHTLTMcsEII1z3g==
X-Received: by 2002:a17:906:4e57:: with SMTP id g23mr3284235ejw.47.1615378542764;
        Wed, 10 Mar 2021 04:15:42 -0800 (PST)
Received: from yoga-910.localhost ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id v15sm4865527edw.28.2021.03.10.04.15.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 04:15:42 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        jiri@resnulli.us, ruxandra.radulescu@nxp.com,
        netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 11/15] staging: dpaa2-switch: move the notifier register to module_init()
Date:   Wed, 10 Mar 2021 14:14:48 +0200
Message-Id: <20210310121452.552070-12-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210310121452.552070-1-ciorneiioana@gmail.com>
References: <20210310121452.552070-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Move the notifier blocks register into the module_init() step, instead of
object probe, so that all DPSW devices probed by the dpaa2-switch driver
can use the same notifiers.

This will enable us to have a more straightforward approach in
determining if an event is intended for an object managed by this driver
or not. Previously, the dpaa2_switch_port_dev_check() function was
forced to also check the notifier block beside the net_device_ops
structure to determine if the event is for us or not.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c | 176 +++++++++++++-----------
 drivers/staging/fsl-dpaa2/ethsw/ethsw.h |   6 +-
 2 files changed, 95 insertions(+), 87 deletions(-)

diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
index 5be07181399d..1f8976898291 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
@@ -80,7 +80,7 @@ static u16 dpaa2_switch_port_set_fdb(struct ethsw_port_priv *port_priv,
 	 * to be present in that bridge
 	 */
 	netdev_for_each_lower_dev(bridge_dev, other_dev, iter) {
-		if (!dpaa2_switch_port_dev_check(other_dev, NULL))
+		if (!dpaa2_switch_port_dev_check(other_dev))
 			continue;
 
 		if (other_dev == port_priv->netdev)
@@ -987,18 +987,9 @@ static const struct net_device_ops dpaa2_switch_port_ops = {
 	.ndo_get_phys_port_name = dpaa2_switch_port_get_phys_name,
 };
 
-bool dpaa2_switch_port_dev_check(const struct net_device *netdev,
-				 struct notifier_block *nb)
+bool dpaa2_switch_port_dev_check(const struct net_device *netdev)
 {
-	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
-
-	if (netdev->netdev_ops == &dpaa2_switch_port_ops &&
-	    (!nb || &port_priv->ethsw_data->port_nb == nb ||
-	     &port_priv->ethsw_data->port_switchdev_nb == nb ||
-	     &port_priv->ethsw_data->port_switchdevb_nb == nb))
-		return true;
-
-	return false;
+	return netdev->netdev_ops == &dpaa2_switch_port_ops;
 }
 
 static void dpaa2_switch_links_state_update(struct ethsw_core *ethsw)
@@ -1429,7 +1420,7 @@ static int dpaa2_switch_port_bridge_join(struct net_device *netdev,
 	int err;
 
 	netdev_for_each_lower_dev(upper_dev, other_dev, iter) {
-		if (!dpaa2_switch_port_dev_check(other_dev, NULL))
+		if (!dpaa2_switch_port_dev_check(other_dev))
 			continue;
 
 		other_port_priv = netdev_priv(other_dev);
@@ -1529,7 +1520,7 @@ static int dpaa2_switch_port_netdevice_event(struct notifier_block *nb,
 	struct net_device *upper_dev;
 	int err = 0;
 
-	if (!dpaa2_switch_port_dev_check(netdev, nb))
+	if (!dpaa2_switch_port_dev_check(netdev))
 		return NOTIFY_DONE;
 
 	/* Handle just upper dev link/unlink for the moment */
@@ -1606,7 +1597,7 @@ static int dpaa2_switch_port_event(struct notifier_block *nb,
 	struct switchdev_notifier_fdb_info *fdb_info = ptr;
 	struct ethsw_core *ethsw = port_priv->ethsw_data;
 
-	if (!dpaa2_switch_port_dev_check(dev, nb))
+	if (!dpaa2_switch_port_dev_check(dev))
 		return NOTIFY_DONE;
 
 	if (event == SWITCHDEV_PORT_ATTR_SET)
@@ -1673,7 +1664,7 @@ static int dpaa2_switch_port_blocking_event(struct notifier_block *nb,
 {
 	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
 
-	if (!dpaa2_switch_port_dev_check(dev, nb))
+	if (!dpaa2_switch_port_dev_check(dev))
 		return NOTIFY_DONE;
 
 	switch (event) {
@@ -1687,41 +1678,6 @@ static int dpaa2_switch_port_blocking_event(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
-static int dpaa2_switch_register_notifier(struct device *dev)
-{
-	struct ethsw_core *ethsw = dev_get_drvdata(dev);
-	int err;
-
-	ethsw->port_nb.notifier_call = dpaa2_switch_port_netdevice_event;
-	err = register_netdevice_notifier(&ethsw->port_nb);
-	if (err) {
-		dev_err(dev, "Failed to register netdev notifier\n");
-		return err;
-	}
-
-	ethsw->port_switchdev_nb.notifier_call = dpaa2_switch_port_event;
-	err = register_switchdev_notifier(&ethsw->port_switchdev_nb);
-	if (err) {
-		dev_err(dev, "Failed to register switchdev notifier\n");
-		goto err_switchdev_nb;
-	}
-
-	ethsw->port_switchdevb_nb.notifier_call = dpaa2_switch_port_blocking_event;
-	err = register_switchdev_blocking_notifier(&ethsw->port_switchdevb_nb);
-	if (err) {
-		dev_err(dev, "Failed to register switchdev blocking notifier\n");
-		goto err_switchdev_blocking_nb;
-	}
-
-	return 0;
-
-err_switchdev_blocking_nb:
-	unregister_switchdev_notifier(&ethsw->port_switchdev_nb);
-err_switchdev_nb:
-	unregister_netdevice_notifier(&ethsw->port_nb);
-	return err;
-}
-
 /* Build a linear skb based on a single-buffer frame descriptor */
 static struct sk_buff *dpaa2_switch_build_linear_skb(struct ethsw_core *ethsw,
 						     const struct dpaa2_fd *fd)
@@ -2426,10 +2382,6 @@ static int dpaa2_switch_init(struct fsl_mc_device *sw_dev)
 	if (err)
 		goto err_destroy_ordered_workqueue;
 
-	err = dpaa2_switch_register_notifier(dev);
-	if (err)
-		goto err_destroy_ordered_workqueue;
-
 	return 0;
 
 err_destroy_ordered_workqueue:
@@ -2496,38 +2448,12 @@ static int dpaa2_switch_port_init(struct ethsw_port_priv *port_priv, u16 port)
 	return err;
 }
 
-static void dpaa2_switch_unregister_notifier(struct device *dev)
-{
-	struct ethsw_core *ethsw = dev_get_drvdata(dev);
-	struct notifier_block *nb;
-	int err;
-
-	nb = &ethsw->port_switchdevb_nb;
-	err = unregister_switchdev_blocking_notifier(nb);
-	if (err)
-		dev_err(dev,
-			"Failed to unregister switchdev blocking notifier (%d)\n",
-			err);
-
-	err = unregister_switchdev_notifier(&ethsw->port_switchdev_nb);
-	if (err)
-		dev_err(dev,
-			"Failed to unregister switchdev notifier (%d)\n", err);
-
-	err = unregister_netdevice_notifier(&ethsw->port_nb);
-	if (err)
-		dev_err(dev,
-			"Failed to unregister netdev notifier (%d)\n", err);
-}
-
 static void dpaa2_switch_takedown(struct fsl_mc_device *sw_dev)
 {
 	struct device *dev = &sw_dev->dev;
 	struct ethsw_core *ethsw = dev_get_drvdata(dev);
 	int err;
 
-	dpaa2_switch_unregister_notifier(dev);
-
 	err = dpsw_close(ethsw->mc_io, 0, ethsw->dpsw_handle);
 	if (err)
 		dev_warn(dev, "dpsw_close err %d\n", err);
@@ -2761,7 +2687,93 @@ static struct fsl_mc_driver dpaa2_switch_drv = {
 	.match_id_table = dpaa2_switch_match_id_table
 };
 
-module_fsl_mc_driver(dpaa2_switch_drv);
+static struct notifier_block dpaa2_switch_port_nb __read_mostly = {
+	.notifier_call = dpaa2_switch_port_netdevice_event,
+};
+
+static struct notifier_block dpaa2_switch_port_switchdev_nb = {
+	.notifier_call = dpaa2_switch_port_event,
+};
+
+static struct notifier_block dpaa2_switch_port_switchdev_blocking_nb = {
+	.notifier_call = dpaa2_switch_port_blocking_event,
+};
+
+static int dpaa2_switch_register_notifiers(void)
+{
+	int err;
+
+	err = register_netdevice_notifier(&dpaa2_switch_port_nb);
+	if (err) {
+		pr_err("dpaa2-switch: failed to register net_device notifier (%d)\n", err);
+		return err;
+	}
+
+	err = register_switchdev_notifier(&dpaa2_switch_port_switchdev_nb);
+	if (err) {
+		pr_err("dpaa2-switch: failed to register switchdev notifier (%d)\n", err);
+		goto err_switchdev_nb;
+	}
+
+	err = register_switchdev_blocking_notifier(&dpaa2_switch_port_switchdev_blocking_nb);
+	if (err) {
+		pr_err("dpaa2-switch: failed to register switchdev blocking notifier (%d)\n", err);
+		goto err_switchdev_blocking_nb;
+	}
+
+	return 0;
+
+err_switchdev_blocking_nb:
+	unregister_switchdev_notifier(&dpaa2_switch_port_switchdev_nb);
+err_switchdev_nb:
+	unregister_netdevice_notifier(&dpaa2_switch_port_nb);
+
+	return err;
+}
+
+static void dpaa2_switch_unregister_notifiers(void)
+{
+	int err;
+
+	err = unregister_switchdev_blocking_notifier(&dpaa2_switch_port_switchdev_blocking_nb);
+	if (err)
+		pr_err("dpaa2-switch: failed to unregister switchdev blocking notifier (%d)\n",
+		       err);
+
+	err = unregister_switchdev_notifier(&dpaa2_switch_port_switchdev_nb);
+	if (err)
+		pr_err("dpaa2-switch: failed to unregister switchdev notifier (%d)\n", err);
+
+	err = unregister_netdevice_notifier(&dpaa2_switch_port_nb);
+	if (err)
+		pr_err("dpaa2-switch: failed to unregister net_device notifier (%d)\n", err);
+}
+
+static int __init dpaa2_switch_driver_init(void)
+{
+	int err;
+
+	err = fsl_mc_driver_register(&dpaa2_switch_drv);
+	if (err)
+		return err;
+
+	err = dpaa2_switch_register_notifiers();
+	if (err) {
+		fsl_mc_driver_unregister(&dpaa2_switch_drv);
+		return err;
+	}
+
+	return 0;
+}
+
+static void __exit dpaa2_switch_driver_exit(void)
+{
+	dpaa2_switch_unregister_notifiers();
+	fsl_mc_driver_unregister(&dpaa2_switch_drv);
+}
+
+module_init(dpaa2_switch_driver_init);
+module_exit(dpaa2_switch_driver_exit);
 
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("DPAA2 Ethernet Switch Driver");
diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.h b/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
index d83a9f17f672..0c228509fcd4 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
@@ -128,9 +128,6 @@ struct ethsw_core {
 
 	u8				vlans[VLAN_VID_MASK + 1];
 
-	struct notifier_block		port_nb;
-	struct notifier_block		port_switchdev_nb;
-	struct notifier_block		port_switchdevb_nb;
 	struct workqueue_struct		*workqueue;
 
 	struct dpaa2_switch_fq		fq[DPAA2_SWITCH_RX_NUM_FQS];
@@ -167,7 +164,6 @@ static inline bool dpaa2_switch_supports_cpu_traffic(struct ethsw_core *ethsw)
 	return true;
 }
 
-bool dpaa2_switch_port_dev_check(const struct net_device *netdev,
-				 struct notifier_block *nb);
+bool dpaa2_switch_port_dev_check(const struct net_device *netdev);
 
 #endif	/* __ETHSW_H */
-- 
2.30.0

