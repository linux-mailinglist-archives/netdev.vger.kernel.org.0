Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF1E35F1A1E
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 08:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbiJAGCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 02:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiJAGCL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 02:02:11 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F20E1806FD
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 23:02:03 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id l22so6972182edj.5
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 23:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=jd54FFw2OuGfjfJEFEp9xFaEIlXt58ZRb//Xx83pNdo=;
        b=sfhx30y75hzEThlL6Oedr3D8EZEvVYORdkdLmaTzMI6en65iE09P5bpUyRlNFi6Bm8
         qQ+yZec47uQgN7p7rY9lMNPveS6H/8HYqngrcF6ApYpijZIlB67A6EVLYDTqql7FeM3e
         jZwCd4plnAD1EWDLu7jPYPhBEvKblV5ehGZGdHBKvaPC9BDTugKW9WldIqxAs9iG2ZSf
         XrMVsnLn9hAaqNumkKnKPzrs6+137rO6noToTa1rQISvdrCXpL0JaBM2WB1cqyVOfJx+
         8piXm2eVtHayRwD6R/CmS0XM8/INl1+1O4gb+HYJWKrMuBh+ppLYEW45QsaKMYqMKWKu
         OcOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=jd54FFw2OuGfjfJEFEp9xFaEIlXt58ZRb//Xx83pNdo=;
        b=NsNEG2x1vI21/I1maxE2pFD9JG3KrS8OY3BkYqukjuRHc6Ia6iNpXsx0Hu3HpoOj1t
         Weu80tyKxDnKxj2mQXwYHKrWN057P5xhQlM+E2woxOwJEst7c+HdzHXND8IAikMk03ws
         wg/p92M9hE0Wtsn4+6Eh/Jz+8Wssj/8/9h/nLZlEeP7+JAgVwRX61cD3erp0I0/r9rUA
         13DxHZA0KW3BCXQP0JDD0N7iKbMs1Ct7j3oShFl/Iyla2XrczlDsfuVG7HKIQWoHQoYy
         /pAgcuaF5hKuo4VZMIci97GkKrSCAzqZm2u6HxKbW+9MlfkGeUovOQrM1Mxzr2PRhtCv
         WXqw==
X-Gm-Message-State: ACrzQf207G7AnJojwlEt632lrybfHiGk1pwHqj87m8KVzS1k+8s+/PsO
        FehX46KMxqHWxcegpOb1yR+KAy/96kUqwgPI
X-Google-Smtp-Source: AMsMyM5+8RnwCfceW4/E/dLnalqlTA60GsvLiQrvhIYWkN3oT+Jf462rH35oZ3l/4bL62lOIuS34Hw==
X-Received: by 2002:a05:6402:28ca:b0:43b:5235:f325 with SMTP id ef10-20020a05640228ca00b0043b5235f325mr10202841edb.320.1664604122481;
        Fri, 30 Sep 2022 23:02:02 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090604c200b0073d7bef38e3sm2200221eja.45.2022.09.30.23.02.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 23:02:01 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com
Subject: [patch net-next 09/13] net: devlink: store copy netdevice ifindex and ifname to allow port_fill() without RTNL held
Date:   Sat,  1 Oct 2022 08:01:41 +0200
Message-Id: <20221001060145.3199964-10-jiri@resnulli.us>
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
index b5a452bec313..2f565976979f 100644
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
2.37.1

