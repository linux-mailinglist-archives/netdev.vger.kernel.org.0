Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAE446136AD
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 13:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231226AbiJaMnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 08:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231195AbiJaMm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 08:42:56 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C290CF588
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 05:42:54 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id v1so15778789wrt.11
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 05:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I45FK7zcDRBB0Zgi/S0IlH6Urr75YvzqB/X8kS4wMAg=;
        b=YKbUqwCgk8rRw9VnfIDT18etXKii/v8HDOECNkXs/oUxsf5cnz4xi/PH/1HH9WTbWy
         zmkmyDS6Sb9ee1Dzq/peG0E/CB+AUeWAtC9kO7De1HusYjlb3Ga2ejoqwt5QXU2Swc3S
         tu1lncLCS+SXaOB8ArPi63RwKeg89cwZoLvMhJicsRcOdcy0lf00Edw4e9n3i+IQwsI1
         y3c/cg7MBEUCkRsoYNWDgKJbMmh3JqZGkZzB9aau4mAut7q2up8xGO9/9e7dtyHm7u+1
         ldVZiQVxKn8/BMw7XwQYmeJuBrsD2OAbP6EkzYAi8yukjATK3ufkUHXwjx9D9/4UYwlj
         UkUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I45FK7zcDRBB0Zgi/S0IlH6Urr75YvzqB/X8kS4wMAg=;
        b=Y5wnAN7uTIjjo/PZnNra3rogL4tb1KOoRiDzTsz30fHRyIhJLa95bCANYMz1mtckIz
         CHbdfj5lc1fH/R0SnfiblMhEjzt/xuliB48HCsg/ohuZFgWWCfuYsIlbCfIZJzpW+tXb
         og5agsRzrQ/IuqNm9fvluP2wqn4pXYQ16zxGhEBeESHph5g5mGAHBwO3IHOKoBaCq8mB
         vU8EINsMFYz7/vz/wX4+DoGIzUDjtRoSnHrhyYrffTrhwxSI1lteUo5CW0USXNEIYyi/
         BAp8PHXPLbckjkjSCOW1SvCJXKPWI7c6LUeS+jc4sfFVe5VZKmJ8VfxuvQcK8DuqdnZp
         S/Eg==
X-Gm-Message-State: ACrzQf1oD56EoCev3OQHHmJMoB6TsrhnvrSL+t/S3T/l0nAoqjyACOiX
        RTneN6Sj3q4c/UEfb5rColKcS9R2AXDIFI6p
X-Google-Smtp-Source: AMsMyM7buebwdwXPxT87Z2iTSsM2hwy2rRybDfb1+BF55QuBz278qJHnvDodPdjod/Ge/rA5akm0SQ==
X-Received: by 2002:a5d:484f:0:b0:236:9c97:6f85 with SMTP id n15-20020a5d484f000000b002369c976f85mr8107086wrs.636.1667220173345;
        Mon, 31 Oct 2022 05:42:53 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id az29-20020a05600c601d00b003cdf141f363sm7282279wmb.11.2022.10.31.05.42.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 05:42:52 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com, linux-rdma@vger.kernel.org
Subject: [patch net-next v3 03/13] net: devlink: move port_type_netdev_checks() call to __devlink_port_type_set()
Date:   Mon, 31 Oct 2022 13:42:38 +0100
Message-Id: <20221031124248.484405-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221031124248.484405-1-jiri@resnulli.us>
References: <20221031124248.484405-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
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

