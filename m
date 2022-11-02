Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1BF6166D6
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 17:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbiKBQCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 12:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbiKBQCT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 12:02:19 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA252BB20
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 09:02:18 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id o4so25234705wrq.6
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 09:02:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I45FK7zcDRBB0Zgi/S0IlH6Urr75YvzqB/X8kS4wMAg=;
        b=Dc74jYC9LHWxvKGuw7BNL1LR4Ehfg/baudvcMA4RAD+A/OfdRQ0p2XjY7G4TME3SpM
         YbaFK7fpYN9pgW7x5m9owY/NBibe0CpT+SQBr/4gaCcechnIo6kY9wzyA525Rta7erv0
         MhGs2hxfwqjeXjwB6ToLTU4PbfnAVZyAOTcbxuHKvqhYSwGonc2iXBf/hJMEUywEpSLU
         yFHmS9R5xMQDoWWMKP8IvPBc36dgPL89NGEY7Mf8GHGEi9ZKUU2s99YidzclkjJtm0Z3
         sxv02l13RHWAtiUaX8TbTSRpfMXtNuJbG1KZVPEVwhzkEBI2w0t5OPJI82ILqpRHVZ0v
         M3iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I45FK7zcDRBB0Zgi/S0IlH6Urr75YvzqB/X8kS4wMAg=;
        b=hJqDj7/val9OBJJffWtCFDf3tWqeSOZ9LKOs505y435d/FeyW7DHLcD7X4oPAIwoJ1
         OCpRbCCv8BILdyaa52HYkkhMIi6epkwdCPuVMaUOK30R5fgmjvUr3CGaOfmaVyOxWjl6
         h3hWTNkJU4Sl7d3oYsNek8Fod1VAgYDHJHB43M+TEfXWL43v6zuTgEZ2sjHAWTSnF/0O
         E6q1n4PblcNdMFL2UZjaIaHfvJtFEIqYdtCzJpZHQFLCUoceGKHA1eqU12ZKsi4HLDRt
         uNh2lMGRCcDNGOcIUfFPfj/Byl0CSYndKvBL1S0HsOcEP13Cc1PohvmOj+CJP4WutJ9a
         mfiA==
X-Gm-Message-State: ACrzQf3kHPRFRAEOpifzRn6rhiHbwQewm3YtiXXs9c+mIODew53ryetX
        wkBz59bmM5sjkBY2PKQC8JmYNsXhOCpy2551xRM=
X-Google-Smtp-Source: AMsMyM55Kkqsrb5gps1B6nWrUx0HCWSipXZz0lRp30tsoEwU3SpkwpMuYh0hFjIeiXVbLQ0NaDCSsw==
X-Received: by 2002:adf:de8d:0:b0:236:6087:e07e with SMTP id w13-20020adfde8d000000b002366087e07emr15766235wrl.533.1667404937429;
        Wed, 02 Nov 2022 09:02:17 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id bp21-20020a5d5a95000000b002302dc43d77sm13405951wrb.115.2022.11.02.09.02.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 09:02:16 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com, linux-rdma@vger.kernel.org
Subject: [patch net-next v4 03/13] net: devlink: move port_type_netdev_checks() call to __devlink_port_type_set()
Date:   Wed,  2 Nov 2022 17:02:01 +0100
Message-Id: <20221102160211.662752-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221102160211.662752-1-jiri@resnulli.us>
References: <20221102160211.662752-1-jiri@resnulli.us>
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
index 3ba3435e2cd5..ff81a5a5087c 100644
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
2.37.3

