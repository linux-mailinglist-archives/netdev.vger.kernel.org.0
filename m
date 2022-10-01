Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 045655F1A17
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 08:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbiJAGB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 02:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiJAGBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 02:01:55 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D57D4A97
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 23:01:53 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id lc7so12965977ejb.0
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 23:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=MLLT0DBq3qYfb0FI3RhPrSoc4c7bXFy4BPeqput8f2o=;
        b=MwdwRh2zqV0mkdtyz7MKxXhMny+sjeMbVAa0xYUOKmYePSPcecdiI8BxQ4YfxRk8sG
         fQ2m2yVnZ7EF5g/n2SvZDkBOlK/aYScNNwKXc7RI0KP5F/cf7hM9BwSA9MJYUQSMcM7L
         liOT4xXq9nEBMYXAR81VU++xhLvDA2sFcefEcArCOcWHHXKJ0AaMM007/W1r+M5ey8sH
         g6sPLMN0dgI91RuIFwC8WKz3CqzTxP6D1fGy58puAx5Q6BQyJLdZKF65NBBDAl40x8sm
         JhlxWGUHcXTtddwBfJnAAe9iGIQ7M7LTOV+60qp+S1WxyBylEduGIMDk9bQR4stOdbBi
         CCoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=MLLT0DBq3qYfb0FI3RhPrSoc4c7bXFy4BPeqput8f2o=;
        b=CxNDNxbYNvOV197XO6vNb5Os+fwZ038S9B0P47AxA/xzht96vieXBFloJeSGN3KUCn
         Etj0czepXXN6kLFEzVDI8MIvmuHsJ7YUGKny/glCzSse4CXEglZKsWcclTNWDd/CAM0X
         H/pVkRF5CS41ErNOfFDi6Q1yY0moc/mTNUgDmqG7KYM6ppx2eK97ppwM1weSOQG1ItQR
         mRiFDfwwv+jTYJFKBaqe9Q5RE75wi8wuXEaVk/xjC8OB+DVyCP2hqG3DiMIOcEIN5EDw
         di2eei+oyaatWITQ9EBo/m30EfgqcHGbtATUQewzDFF5I1W7Zkk8Sv+c+sSRE1MqXJno
         Mcng==
X-Gm-Message-State: ACrzQf24OzzX1gROPVjHYTT1TAJkdLvjdxYXhx9rnZnL0hF0lwvoJ7R5
        d48wxX5d5Wn+k9uiXmSXUygg58u4UEtod9Rn
X-Google-Smtp-Source: AMsMyM473fwiqFQJGfFPJBX5p0wPH8mbbuNHJlYTU5tySts6UNMIWHO76rzVqlf+CY0xIp/e7XcpHQ==
X-Received: by 2002:a17:907:94d0:b0:783:d969:f30c with SMTP id dn16-20020a17090794d000b00783d969f30cmr8703630ejc.165.1664604112415;
        Fri, 30 Sep 2022 23:01:52 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id u4-20020aa7d884000000b00456cbd8c65bsm2973434edq.6.2022.09.30.23.01.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 23:01:51 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com
Subject: [patch net-next 03/13] net: devlink: move port_type_netdev_checks() call to __devlink_port_type_set()
Date:   Sat,  1 Oct 2022 08:01:35 +0200
Message-Id: <20221001060145.3199964-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221001060145.3199964-1-jiri@resnulli.us>
References: <20221001060145.3199964-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

As __devlink_port_type_set() is going to be called directly from netdevice
notifier event handle in one of the follow-up patches, move the
port_type_netdev_checks() call there.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/core/devlink.c | 63 ++++++++++++++++++++++++----------------------
 1 file changed, 33 insertions(+), 30 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 218cb1cdb50e..e49ec10d613f 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -9994,33 +9994,6 @@ void devlink_port_unregister(struct devlink_port *devlink_port)
 }
 EXPORT_SYMBOL_GPL(devlink_port_unregister);
 
-static void __devlink_port_type_set(struct devlink_port *devlink_port,
-				    enum devlink_port_type type,
-				    void *type_dev)
-{
-	ASSERT_DEVLINK_PORT_REGISTERED(devlink_port);
-
-	if (type == DEVLINK_PORT_TYPE_NOTSET)
-		devlink_port_type_warn_schedule(devlink_port);
-	else
-		devlink_port_type_warn_cancel(devlink_port);
-
-	spin_lock_bh(&devlink_port->type_lock);
-	devlink_port->type = type;
-	switch (type) {
-	case DEVLINK_PORT_TYPE_ETH:
-		devlink_port->type_eth.netdev = type_dev;
-		break;
-	case DEVLINK_PORT_TYPE_IB:
-		devlink_port->type_ib.ibdev = type_dev;
-		break;
-	default:
-		break;
-	}
-	spin_unlock_bh(&devlink_port->type_lock);
-	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_NEW);
-}
-
 static void devlink_port_type_netdev_checks(struct devlink_port *devlink_port,
 					    struct net_device *netdev)
 {
@@ -10058,6 +10031,38 @@ static void devlink_port_type_netdev_checks(struct devlink_port *devlink_port,
 	}
 }
 
+static void __devlink_port_type_set(struct devlink_port *devlink_port,
+				    enum devlink_port_type type,
+				    void *type_dev)
+{
+	struct net_device *netdev = type_dev;
+
+	ASSERT_DEVLINK_PORT_REGISTERED(devlink_port);
+
+	if (type == DEVLINK_PORT_TYPE_NOTSET) {
+		devlink_port_type_warn_schedule(devlink_port);
+	} else {
+		devlink_port_type_warn_cancel(devlink_port);
+		if (type == DEVLINK_PORT_TYPE_ETH && netdev)
+			devlink_port_type_netdev_checks(devlink_port, netdev);
+	}
+
+	spin_lock_bh(&devlink_port->type_lock);
+	devlink_port->type = type;
+	switch (type) {
+	case DEVLINK_PORT_TYPE_ETH:
+		devlink_port->type_eth.netdev = netdev;
+		break;
+	case DEVLINK_PORT_TYPE_IB:
+		devlink_port->type_ib.ibdev = type_dev;
+		break;
+	default:
+		break;
+	}
+	spin_unlock_bh(&devlink_port->type_lock);
+	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_NEW);
+}
+
 /**
  *	devlink_port_type_eth_set - Set port type to Ethernet
  *
@@ -10067,9 +10072,7 @@ static void devlink_port_type_netdev_checks(struct devlink_port *devlink_port,
 void devlink_port_type_eth_set(struct devlink_port *devlink_port,
 			       struct net_device *netdev)
 {
-	if (netdev)
-		devlink_port_type_netdev_checks(devlink_port, netdev);
-	else
+	if (!netdev)
 		dev_warn(devlink_port->devlink->dev,
 			 "devlink port type for port %d set to Ethernet without a software interface reference, device type not supported by the kernel?\n",
 			 devlink_port->index);
-- 
2.37.1

