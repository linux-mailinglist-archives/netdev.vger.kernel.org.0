Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56ADB32A31A
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381858AbhCBIrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:47:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445122AbhCBC4i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 21:56:38 -0500
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18ADDC061756;
        Mon,  1 Mar 2021 18:55:52 -0800 (PST)
Received: by mail-qk1-x72b.google.com with SMTP id a9so4359306qkn.13;
        Mon, 01 Mar 2021 18:55:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Bl6IeDCxrDL9nvZp+otJHxIDEfbgROq46lrAJqnFnwM=;
        b=mniu5Vf4V3rnWCaen6hZ8kwOFTgp21qID/i2cwrIIbdI4Yc0tFUT6BgyMMDyOa28le
         IwgOUvhyWMEK5sm+V6LgXZiIHgUXP90DV77aINtJSuvKqLGcKSWi2gh44Vp0GNwkx/3U
         3s7ZzkwksOc2vhQMgnLSh27ZyIMRW14G+7LuQLW2O1Y798Ug86hXvfy8wrdJtZJsU47G
         QfZnPTiMayCxSELQ6Kg3FwViMEF/fr8N9B4Sw2I1YFbujzK/AhMF+pG4Q6dw8XcfocBR
         L3OxszYAlalrGP0FFcQE2bnp87GzlGFKSMGU7YOWtaexosubkKURfiWL33CKd+nRAtMT
         9M6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Bl6IeDCxrDL9nvZp+otJHxIDEfbgROq46lrAJqnFnwM=;
        b=QWuonuJsvuJfkEpAukC1q1QD14jzk3E05uo7b6WijB4n2qKJIw6lWOonzFhelz8hC8
         gH5JfQiEoc+13Fgg0eyFTepBw+7yarjdY9P5/QHR+rcO6zviEc3zCErW68+PW3vsO9Dy
         OhqBy8QoNhG5eznaHYWIVcLFwiDZc/geIr2Knui7hgxGb5A8RZUM16Rk6fBRJhcVXvnz
         S2Co7EnVYChH5GGlObS2Bi37GIj6NCjEdSeHPMtceu9JfsarbqDBqCP8waLjqxX4TYuS
         taUP1rx7v2I9f9yS1ilJ9gq8J9T0xVA4bnXLPST7/PZ8d2MQsgGTRVMpfAWvI3CogwBN
         exKA==
X-Gm-Message-State: AOAM533UQG8v8CygTZEloACpU15Kgf9h6F9774TaslcyemmGygAyHZYW
        H5oTKZX+vKtL8humUrT2DAA=
X-Google-Smtp-Source: ABdhPJxWGAjxSZoyd8Q35SrKzkbIcq0nEtxFqxfOK3TXgrhw67fMRgLLx9PsoYPVvZXROrDYJwzoIg==
X-Received: by 2002:a05:620a:7d5:: with SMTP id 21mr17446786qkb.152.1614653751140;
        Mon, 01 Mar 2021 18:55:51 -0800 (PST)
Received: from tong-desktop.local ([2601:5c0:c200:27c6:d116:22cd:63bb:f8b])
        by smtp.googlemail.com with ESMTPSA id d20sm14437939qkb.88.2021.03.01.18.55.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 18:55:50 -0800 (PST)
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
Subject: [PATCH v2] can: c_can: move runtime PM enable/disable to c_can_platform
Date:   Mon,  1 Mar 2021 21:55:40 -0500
Message-Id: <20210302025542.987600-1-ztong0001@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210301150840.mqngl7og46o3nxjb@pengutronix.de>
References: <20210301150840.mqngl7og46o3nxjb@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently doing modprobe c_can_pci will make kernel complain
"Unbalanced pm_runtime_enable!", this is caused by pm_runtime_enable()
called before pm is initialized.
This fix is similar to 227619c3ff7c, move those pm_enable/disable code to
c_can_platform.

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
---
 drivers/net/can/c_can/c_can.c          | 24 +-----------------------
 drivers/net/can/c_can/c_can_platform.c |  6 +++++-
 2 files changed, 6 insertions(+), 24 deletions(-)

diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index ef474bae47a1..6958830cb983 100644
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
+	if (!err)
 		devm_can_led_init(dev);
-
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

