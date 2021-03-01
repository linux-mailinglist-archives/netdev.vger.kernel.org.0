Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB54C32769D
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 05:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233075AbhCAEQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 23:16:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233061AbhCAEQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Feb 2021 23:16:46 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 392DDC06174A;
        Sun, 28 Feb 2021 20:16:06 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id w6so11150146qti.6;
        Sun, 28 Feb 2021 20:16:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=26Q3tkzW5s8d+3ZDpjxr2Cr0H8veyHSn5hQXX2z5lpY=;
        b=Ou5r9TnQ1HePvn63miY+uu2uE+dsuTHzc50zMmQn4dDsOD3uRMAGSnTECopyuWXY4p
         y0pZIvu5FKD4ArOdtTn7fK80gYZdnLaIWlnPzkJXgVoSY73NW8vVu5vpm4OaQDv01Ec3
         0+8Am+RRSk+7ZOW6Ji7g8BjufUANbtAesOgWn5Z+zVdItbsZBNeb1fjixtI/WMiNOteC
         QUMN1Gx1Oq0HkQ6uB2VPm5BCbmWmRH4T3vhM/NXEspJaluCG6h1+azrtKoxkWeBfi9c+
         zcbYbHGvxVeY63BqwVRS0hUi7fLCTqv1cOopPo+EDnl9c77ptSRgVbTFp2i+S8DON+q9
         yTmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=26Q3tkzW5s8d+3ZDpjxr2Cr0H8veyHSn5hQXX2z5lpY=;
        b=kW4VvJwsU7WdwogKHkgxukPDQE6TcJmk0/n5Pm4etnPpnLzjshh8BEArmJdwno1Hlm
         QtUmKf8cUCvnoeQq4wnnnGD9QBZZwVGGD5bq33Od+HsfVIYNFnpYW14eRvMNxHygEti7
         Lgd0/Q/mlJMe/lTuTr2oKjAEYa1bWopKMZz3sF2Yq3Wl/bFvca/vIpX4M5UVPsK+ivRm
         LM+IVSABn0EvLW13v9VjS7wR/CJYdxWjWqgYry2SfDZSLEMcYYmk7Pj2msnSHvJHZsu6
         RRCZ2bimcTPThzZyUsxSwK/dC2nfGWFanE0Mv6u6TJErzs7h3MZfGBdYzVFE9QKl/zdx
         Priw==
X-Gm-Message-State: AOAM531LPZJc09BLw5nrDaISzVzJYLLI7AB/FPn1/mRsm3vIXp6mB4L6
        fE8be+piF5eW8/5Lhw6ZoWA=
X-Google-Smtp-Source: ABdhPJyDIvug2dnpTFHRyy/XuW/fjUfm+oRFSW6QvOwx96J210FFKx4xO5bFlCHgJLaSOzYljj2fdw==
X-Received: by 2002:a05:622a:183:: with SMTP id s3mr11902355qtw.223.1614572165055;
        Sun, 28 Feb 2021 20:16:05 -0800 (PST)
Received: from tong-desktop.local ([2601:5c0:c200:27c6:1d59:a36:514:a21])
        by smtp.googlemail.com with ESMTPSA id l24sm10310057qtj.50.2021.02.28.20.16.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Feb 2021 20:16:04 -0800 (PST)
From:   Tong Zhang <ztong0001@gmail.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Tong Zhang <ztong0001@gmail.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] can: c_can: move runtime PM enable/disable to c_can_platform
Date:   Sun, 28 Feb 2021 23:15:48 -0500
Message-Id: <20210301041550.795500-1-ztong0001@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently doing modprobe c_can_pci will make kernel complain
"Unbalanced pm_runtime_enable!", this is caused by pm_runtime_enable()
called before pm is initialized in register_candev() and doing so will
also cause it to enable twice.
This fix is similar to 227619c3ff7c, move those pm_enable/disable code to
c_can_platform.

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
---
 drivers/net/can/c_can/c_can.c          | 26 ++------------------------
 drivers/net/can/c_can/c_can_platform.c |  6 +++++-
 2 files changed, 7 insertions(+), 25 deletions(-)

diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index ef474bae47a1..04f783b3d9d3 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -212,18 +212,6 @@ static const struct can_bittiming_const c_can_bittiming_const = {
 	.brp_inc = 1,
 };
 
-static inline void c_can_pm_runtime_enable(const struct c_can_priv *priv)
-{
-	if (priv->device)
-		pm_runtime_enable(priv->device);
-}
-
-static inline void c_can_pm_runtime_disable(const struct c_can_priv *priv)
-{
-	if (priv->device)
-		pm_runtime_disable(priv->device);
-}
-
 static inline void c_can_pm_runtime_get_sync(const struct c_can_priv *priv)
 {
 	if (priv->device)
@@ -1335,7 +1323,6 @@ static const struct net_device_ops c_can_netdev_ops = {
 
 int register_c_can_dev(struct net_device *dev)
 {
-	struct c_can_priv *priv = netdev_priv(dev);
 	int err;
 
 	/* Deactivate pins to prevent DRA7 DCAN IP from being
@@ -1345,28 +1332,19 @@ int register_c_can_dev(struct net_device *dev)
 	 */
 	pinctrl_pm_select_sleep_state(dev->dev.parent);
 
-	c_can_pm_runtime_enable(priv);
-
 	dev->flags |= IFF_ECHO;	/* we support local echo */
 	dev->netdev_ops = &c_can_netdev_ops;
 
 	err = register_candev(dev);
-	if (err)
-		c_can_pm_runtime_disable(priv);
-	else
-		devm_can_led_init(dev);
-
+	if (!err)
+	  devm_can_led_init(dev);
 	return err;
 }
 EXPORT_SYMBOL_GPL(register_c_can_dev);
 
 void unregister_c_can_dev(struct net_device *dev)
 {
-	struct c_can_priv *priv = netdev_priv(dev);
-
 	unregister_candev(dev);
-
-	c_can_pm_runtime_disable(priv);
 }
 EXPORT_SYMBOL_GPL(unregister_c_can_dev);
 
diff --git a/drivers/net/can/c_can/c_can_platform.c b/drivers/net/can/c_can/c_can_platform.c
index 05f425ceb53a..47b251b1607c 100644
--- a/drivers/net/can/c_can/c_can_platform.c
+++ b/drivers/net/can/c_can/c_can_platform.c
@@ -29,6 +29,7 @@
 #include <linux/list.h>
 #include <linux/io.h>
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 #include <linux/clk.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
@@ -386,6 +387,7 @@ static int c_can_plat_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, dev);
 	SET_NETDEV_DEV(dev, &pdev->dev);
 
+	pm_runtime_enable(priv->device);
 	ret = register_c_can_dev(dev);
 	if (ret) {
 		dev_err(&pdev->dev, "registering %s failed (err=%d)\n",
@@ -398,6 +400,7 @@ static int c_can_plat_probe(struct platform_device *pdev)
 	return 0;
 
 exit_free_device:
+	pm_runtime_disable(priv->device);
 	free_c_can_dev(dev);
 exit:
 	dev_err(&pdev->dev, "probe failed\n");
@@ -408,9 +411,10 @@ static int c_can_plat_probe(struct platform_device *pdev)
 static int c_can_plat_remove(struct platform_device *pdev)
 {
 	struct net_device *dev = platform_get_drvdata(pdev);
+	struct c_can_priv *priv = netdev_priv(dev);
 
 	unregister_c_can_dev(dev);
-
+	pm_runtime_disable(priv->device);
 	free_c_can_dev(dev);
 
 	return 0;
-- 
2.25.1

