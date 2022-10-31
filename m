Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 621446136B7
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 13:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbiJaMnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 08:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231386AbiJaMnT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 08:43:19 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C8E3FADB
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 05:43:01 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id bk15so15754027wrb.13
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 05:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7RwLLaFpo0sj1hbyFpn+0hHcMC94yUMEINPITw25T+o=;
        b=YXboiNgJgSwBdDAafhvs1a3TKOfakqFY7S7B2cefg8A8zrcfCQQGgsFFZa46dnEZR2
         EtTCmvvP8Z/+Ic2YA7bEiMeIYvln6qWYPwqyBljcdwXCYCAsrlSnOO2GUN/RnWLxd6aH
         oxHfHI+SVsvxdxgdis55TFKoMX2NX7ylxANHZSO/dakHbsOWl/+ibOSMtcRyek4Nl6TU
         InK5uDts+e5xXQdagU5KZPQgpih4jP/vdaVlG4pNm1og2MFgYFobXopy3KastQ7FOMju
         rV61XlQ36Dd35PRCIdRTuZRsYOQNoCc8nVcz7q05U3gHJZevQJ4Xhs7ReMtvLnYTX2xh
         NUBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7RwLLaFpo0sj1hbyFpn+0hHcMC94yUMEINPITw25T+o=;
        b=pYRS3XIptQFOjfZ1mZqNCMqY6W6A9bNhZVmoBIyta+FrdxJ+mkzHFG9/HOO4wDr8zH
         xT8vVOGrqbHIQbt7grpU1QzdifLBuivT5ipmxej7iaWapCklfBIQvX5Xk7XqH31aEKAk
         WR0lQ6O8pAhmuVwoEDlOYnqijO11q2+pqSSK3Uup0U3gEWUP22LKgatgoiMKD9ob9f8X
         SgKHgbPmNyTgz96gre68tB+kG0GapLu1fdLrbmr4WDOBhLd3r5TFRJ1NoZdu0G/9lyRU
         9HgKxC6FvxPyk+DO/OEc1npF4+W7JwAHmvKyHpXd/u7q/JuctenHUjwNbsV4iw0Zsh0T
         8NhA==
X-Gm-Message-State: ACrzQf0YrGJGu6QZZq/FfBaG9cPUyT4HL8mE9Ke2GAvXdsMD0Pu+ZHTa
        oddVUrW23tTN79XnNexsQvLVk3pQYCF54Q/O
X-Google-Smtp-Source: AMsMyM5z2ndQ20DngUC9tX2ixaUkmxfixvIGXM51ot/tA/n1GtMr5pL2c6Si3oBrdex846rSouUsIw==
X-Received: by 2002:adf:a792:0:b0:236:dbf9:5946 with SMTP id j18-20020adfa792000000b00236dbf95946mr859465wrc.465.1667220181010;
        Mon, 31 Oct 2022 05:43:01 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id f16-20020a05600c4e9000b003cf568a736csm5227796wmq.20.2022.10.31.05.43.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 05:43:00 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com, linux-rdma@vger.kernel.org
Subject: [patch net-next v3 09/13] net: devlink: store copy netdevice ifindex and ifname to allow port_fill() without RTNL held
Date:   Mon, 31 Oct 2022 13:42:44 +0100
Message-Id: <20221031124248.484405-10-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221031124248.484405-1-jiri@resnulli.us>
References: <20221031124248.484405-1-jiri@resnulli.us>
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

To avoid a need to take RTNL mutex in port_fill() function, benefit from
the introduce infrastructure that tracks netdevice notifier events.
Store the ifindex and ifname upon register and change name events.
Remove the rtnl_held bool propagated down to port_fill() function as it
is no longer needed.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 include/net/devlink.h |  2 ++
 net/core/devlink.c    | 68 +++++++++++++++++--------------------------
 2 files changed, 29 insertions(+), 41 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index b1582b32183a..7befad57afd4 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -129,6 +129,8 @@ struct devlink_port {
 	union {
 		struct {
 			struct net_device *netdev;
+			int ifindex;
+			char ifname[IFNAMSIZ];
 		} type_eth;
 		struct {
 			struct ib_device *ibdev;
diff --git a/net/core/devlink.c b/net/core/devlink.c
index d948bb2fdd5f..38de3a1dff36 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -1279,8 +1279,7 @@ devlink_nl_port_function_attrs_put(struct sk_buff *msg, struct devlink_port *por
 static int devlink_nl_port_fill(struct sk_buff *msg,
 				struct devlink_port *devlink_port,
 				enum devlink_command cmd, u32 portid, u32 seq,
-				int flags, struct netlink_ext_ack *extack,
-				bool rtnl_held)
+				int flags, struct netlink_ext_ack *extack)
 {
 	struct devlink *devlink = devlink_port->devlink;
 	void *hdr;
@@ -1294,9 +1293,6 @@ static int devlink_nl_port_fill(struct sk_buff *msg,
 	if (nla_put_u32(msg, DEVLINK_ATTR_PORT_INDEX, devlink_port->index))
 		goto nla_put_failure;
 
-	/* Hold rtnl lock while accessing port's netdev attributes. */
-	if (!rtnl_held)
-		rtnl_lock();
 	spin_lock_bh(&devlink_port->type_lock);
 	if (nla_put_u16(msg, DEVLINK_ATTR_PORT_TYPE, devlink_port->type))
 		goto nla_put_failure_type_locked;
@@ -1305,13 +1301,11 @@ static int devlink_nl_port_fill(struct sk_buff *msg,
 			devlink_port->desired_type))
 		goto nla_put_failure_type_locked;
 	if (devlink_port->type == DEVLINK_PORT_TYPE_ETH) {
-		struct net_device *netdev = devlink_port->type_eth.netdev;
-
-		if (netdev &&
+		if (devlink_port->type_eth.netdev &&
 		    (nla_put_u32(msg, DEVLINK_ATTR_PORT_NETDEV_IFINDEX,
-				 netdev->ifindex) ||
+				 devlink_port->type_eth.ifindex) ||
 		     nla_put_string(msg, DEVLINK_ATTR_PORT_NETDEV_NAME,
-				    netdev->name)))
+				    devlink_port->type_eth.ifname)))
 			goto nla_put_failure_type_locked;
 	}
 	if (devlink_port->type == DEVLINK_PORT_TYPE_IB) {
@@ -1323,8 +1317,6 @@ static int devlink_nl_port_fill(struct sk_buff *msg,
 			goto nla_put_failure_type_locked;
 	}
 	spin_unlock_bh(&devlink_port->type_lock);
-	if (!rtnl_held)
-		rtnl_unlock();
 	if (devlink_nl_port_attrs_put(msg, devlink_port))
 		goto nla_put_failure;
 	if (devlink_nl_port_function_attrs_put(msg, devlink_port, extack))
@@ -1339,15 +1331,13 @@ static int devlink_nl_port_fill(struct sk_buff *msg,
 
 nla_put_failure_type_locked:
 	spin_unlock_bh(&devlink_port->type_lock);
-	if (!rtnl_held)
-		rtnl_unlock();
 nla_put_failure:
 	genlmsg_cancel(msg, hdr);
 	return -EMSGSIZE;
 }
 
-static void __devlink_port_notify(struct devlink_port *devlink_port,
-				  enum devlink_command cmd, bool rtnl_held)
+static void devlink_port_notify(struct devlink_port *devlink_port,
+				enum devlink_command cmd)
 {
 	struct devlink *devlink = devlink_port->devlink;
 	struct sk_buff *msg;
@@ -1362,8 +1352,7 @@ static void __devlink_port_notify(struct devlink_port *devlink_port,
 	if (!msg)
 		return;
 
-	err = devlink_nl_port_fill(msg, devlink_port, cmd, 0, 0, 0, NULL,
-				   rtnl_held);
+	err = devlink_nl_port_fill(msg, devlink_port, cmd, 0, 0, 0, NULL);
 	if (err) {
 		nlmsg_free(msg);
 		return;
@@ -1373,12 +1362,6 @@ static void __devlink_port_notify(struct devlink_port *devlink_port,
 				0, DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
 }
 
-static void devlink_port_notify(struct devlink_port *devlink_port,
-				enum devlink_command cmd)
-{
-	__devlink_port_notify(devlink_port, cmd, false);
-}
-
 static void devlink_rate_notify(struct devlink_rate *devlink_rate,
 				enum devlink_command cmd)
 {
@@ -1542,7 +1525,7 @@ static int devlink_nl_cmd_port_get_doit(struct sk_buff *skb,
 
 	err = devlink_nl_port_fill(msg, devlink_port, DEVLINK_CMD_PORT_NEW,
 				   info->snd_portid, info->snd_seq, 0,
-				   info->extack, false);
+				   info->extack);
 	if (err) {
 		nlmsg_free(msg);
 		return err;
@@ -1572,8 +1555,7 @@ static int devlink_nl_cmd_port_get_dumpit(struct sk_buff *msg,
 						   DEVLINK_CMD_NEW,
 						   NETLINK_CB(cb->skb).portid,
 						   cb->nlh->nlmsg_seq,
-						   NLM_F_MULTI, cb->extack,
-						   false);
+						   NLM_F_MULTI, cb->extack);
 			if (err) {
 				devl_unlock(devlink);
 				devlink_put(devlink);
@@ -1785,8 +1767,7 @@ static int devlink_port_new_notify(struct devlink *devlink,
 	}
 
 	err = devlink_nl_port_fill(msg, devlink_port, DEVLINK_CMD_NEW,
-				   info->snd_portid, info->snd_seq, 0, NULL,
-				   false);
+				   info->snd_portid, info->snd_seq, 0, NULL);
 	if (err)
 		goto out;
 
@@ -10062,7 +10043,7 @@ static void devlink_port_type_netdev_checks(struct devlink_port *devlink_port,
 
 static void __devlink_port_type_set(struct devlink_port *devlink_port,
 				    enum devlink_port_type type,
-				    void *type_dev, bool rtnl_held)
+				    void *type_dev)
 {
 	struct net_device *netdev = type_dev;
 
@@ -10081,6 +10062,13 @@ static void __devlink_port_type_set(struct devlink_port *devlink_port,
 	switch (type) {
 	case DEVLINK_PORT_TYPE_ETH:
 		devlink_port->type_eth.netdev = netdev;
+		if (netdev) {
+			ASSERT_RTNL();
+			devlink_port->type_eth.ifindex = netdev->ifindex;
+			BUILD_BUG_ON(sizeof(devlink_port->type_eth.ifname) !=
+				     sizeof(netdev->name));
+			strcpy(devlink_port->type_eth.ifname, netdev->name);
+		}
 		break;
 	case DEVLINK_PORT_TYPE_IB:
 		devlink_port->type_ib.ibdev = type_dev;
@@ -10089,7 +10077,7 @@ static void __devlink_port_type_set(struct devlink_port *devlink_port,
 		break;
 	}
 	spin_unlock_bh(&devlink_port->type_lock);
-	__devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_NEW, rtnl_held);
+	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_NEW);
 }
 
 /**
@@ -10104,8 +10092,7 @@ void devlink_port_type_eth_set(struct devlink_port *devlink_port)
 	dev_warn(devlink_port->devlink->dev,
 		 "devlink port type for port %d set to Ethernet without a software interface reference, device type not supported by the kernel?\n",
 		 devlink_port->index);
-	__devlink_port_type_set(devlink_port, DEVLINK_PORT_TYPE_ETH, NULL,
-				false);
+	__devlink_port_type_set(devlink_port, DEVLINK_PORT_TYPE_ETH, NULL);
 }
 EXPORT_SYMBOL_GPL(devlink_port_type_eth_set);
 
@@ -10118,8 +10105,7 @@ EXPORT_SYMBOL_GPL(devlink_port_type_eth_set);
 void devlink_port_type_ib_set(struct devlink_port *devlink_port,
 			      struct ib_device *ibdev)
 {
-	__devlink_port_type_set(devlink_port, DEVLINK_PORT_TYPE_IB, ibdev,
-				false);
+	__devlink_port_type_set(devlink_port, DEVLINK_PORT_TYPE_IB, ibdev);
 }
 EXPORT_SYMBOL_GPL(devlink_port_type_ib_set);
 
@@ -10137,8 +10123,7 @@ void devlink_port_type_clear(struct devlink_port *devlink_port)
 		dev_warn(devlink_port->devlink->dev,
 			 "devlink port type for port %d cleared without a software interface reference, device type not supported by the kernel?\n",
 			 devlink_port->index);
-	__devlink_port_type_set(devlink_port, DEVLINK_PORT_TYPE_NOTSET, NULL,
-				false);
+	__devlink_port_type_set(devlink_port, DEVLINK_PORT_TYPE_NOTSET, NULL);
 }
 EXPORT_SYMBOL_GPL(devlink_port_type_clear);
 
@@ -10161,16 +10146,17 @@ static int devlink_netdevice_event(struct notifier_block *nb,
 		 * netdevice register
 		 */
 		__devlink_port_type_set(devlink_port, DEVLINK_PORT_TYPE_ETH,
-					NULL, true);
+					NULL);
 		break;
 	case NETDEV_REGISTER:
+	case NETDEV_CHANGENAME:
 		/* Set the netdev on top of previously set type. Note this
 		 * event happens also during net namespace change so here
 		 * we take into account netdev pointer appearing in this
 		 * namespace.
 		 */
 		__devlink_port_type_set(devlink_port, DEVLINK_PORT_TYPE_ETH,
-					netdev, true);
+					netdev);
 		break;
 	case NETDEV_UNREGISTER:
 		/* Clear netdev pointer, but not the type. This event happens
@@ -10178,14 +10164,14 @@ static int devlink_netdevice_event(struct notifier_block *nb,
 		 * pointer to netdev that is going to another net namespace.
 		 */
 		__devlink_port_type_set(devlink_port, DEVLINK_PORT_TYPE_ETH,
-					NULL, true);
+					NULL);
 		break;
 	case NETDEV_PRE_UNINIT:
 		/* Clear the type and the netdev pointer. Happens one during
 		 * netdevice unregister.
 		 */
 		__devlink_port_type_set(devlink_port, DEVLINK_PORT_TYPE_NOTSET,
-					NULL, true);
+					NULL);
 		break;
 	}
 
-- 
2.37.3

