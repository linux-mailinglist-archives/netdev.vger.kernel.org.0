Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEE4A6166E0
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 17:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbiKBQCw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 12:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbiKBQCc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 12:02:32 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C8A2C657
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 09:02:26 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id p13-20020a05600c468d00b003cf8859ed1bso1097922wmo.1
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 09:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HIcI3a876/c5vg406sttxggNBT8FJejpvY3acJUf35U=;
        b=tX85BFXX950QBu6OduIKHBT4JXF1pu/M86DKE+aSeJUiRkyLvH6g3Azll7dr1YDP3w
         Av+5CE786iP+Ddadmtb1zAcIDuV8mw+s1RcFg/KmdZl5244hUPmZwDfmC9+zzXpBFaI0
         WvpaQv72DO3Mo/EAPnbTVnTL1pH6cHxKe4AbddFxmjzrKfEOhTzncdALFwnPCSpT9zCC
         1FL2m5QVXjfDGIyTfp0aizXXQrkL2Ln5I8wJmveO6bZIVa0Jz2VvrsBOQ8DaaMJgLQ7J
         aXnetYjKqxc7ui5/dpvDxdE40VmHTdprnhQROm2Gxc8B58ll4YD7dUQwj82vrZc6N+As
         8DJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HIcI3a876/c5vg406sttxggNBT8FJejpvY3acJUf35U=;
        b=0p8MSzb1CHwXfwrNQZ8jPWwUmCVYPsJidDmuZbc1YdwTOZuOFBWpOvHUMWlWhdE+DI
         YpzD/dsHwv4hsNNaHFLvklEdsUcHRkKWhi417pAxwvRz42RMzMf2JZqM5OzpWm0e2t9t
         UYoTgFiJRV5cCDa1GsDv3xO65sNZN4Mhzv2ONSpPmisBTM+iRN/G4Z8zSPYDto9X5JrK
         JijQW0ROxroTJvDPq7ugNA4F30VwA1AjnLaG6rY78xQJASkZYmLlsC0dMCoZadjK+ni0
         4VbznLiB2KH6QZWxS7AUJdD1J6Q8v6frlxH/BnYx19JY4lCuTccCx94HpKuduIsXZhxc
         Y+Tw==
X-Gm-Message-State: ACrzQf2CqDYn64Sg7zAEcNU31lcEV854Kp4c6yCSmHFH9V+CkMc8jAV7
        Ye7dh4vn94d05hWrrQn4W9cpBYLJfs7wTWepvd4=
X-Google-Smtp-Source: AMsMyM44LuxUd2T021Qp2sVpqIh0sDMh6tN+Oli5I3smXKzMtdYDC3TnwAU56HIRQIRfHuSQuE8U7Q==
X-Received: by 2002:a1c:7207:0:b0:3cf:8115:b39a with SMTP id n7-20020a1c7207000000b003cf8115b39amr6078388wmc.80.1667404938877;
        Wed, 02 Nov 2022 09:02:18 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id j18-20020a5d6192000000b00228692033dcsm13095678wru.91.2022.11.02.09.02.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 09:02:18 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com, linux-rdma@vger.kernel.org
Subject: [patch net-next v4 04/13] net: devlink: take RTNL in port_fill() function only if it is not held
Date:   Wed,  2 Nov 2022 17:02:02 +0100
Message-Id: <20221102160211.662752-5-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221102160211.662752-1-jiri@resnulli.us>
References: <20221102160211.662752-1-jiri@resnulli.us>
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

Follow-up patch is going to introduce a netdevice notifier event
processing which is called with RTNL mutex held. Processing of this will
eventually lead to call to port_notity() and port_fill() which currently
takes RTNL mutex internally. So as a temporary solution, propagate a
bool indicating if the mutex is already held. This will go away in one
of the follow-up patches.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/core/devlink.c | 46 +++++++++++++++++++++++++++++++---------------
 1 file changed, 31 insertions(+), 15 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index ff81a5a5087c..3387dfbb80c5 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -1278,7 +1278,8 @@ devlink_nl_port_function_attrs_put(struct sk_buff *msg, struct devlink_port *por
 static int devlink_nl_port_fill(struct sk_buff *msg,
 				struct devlink_port *devlink_port,
 				enum devlink_command cmd, u32 portid, u32 seq,
-				int flags, struct netlink_ext_ack *extack)
+				int flags, struct netlink_ext_ack *extack,
+				bool rtnl_held)
 {
 	struct devlink *devlink = devlink_port->devlink;
 	void *hdr;
@@ -1293,7 +1294,8 @@ static int devlink_nl_port_fill(struct sk_buff *msg,
 		goto nla_put_failure;
 
 	/* Hold rtnl lock while accessing port's netdev attributes. */
-	rtnl_lock();
+	if (!rtnl_held)
+		rtnl_lock();
 	spin_lock_bh(&devlink_port->type_lock);
 	if (nla_put_u16(msg, DEVLINK_ATTR_PORT_TYPE, devlink_port->type))
 		goto nla_put_failure_type_locked;
@@ -1321,7 +1323,8 @@ static int devlink_nl_port_fill(struct sk_buff *msg,
 			goto nla_put_failure_type_locked;
 	}
 	spin_unlock_bh(&devlink_port->type_lock);
-	rtnl_unlock();
+	if (!rtnl_held)
+		rtnl_unlock();
 	if (devlink_nl_port_attrs_put(msg, devlink_port))
 		goto nla_put_failure;
 	if (devlink_nl_port_function_attrs_put(msg, devlink_port, extack))
@@ -1336,14 +1339,15 @@ static int devlink_nl_port_fill(struct sk_buff *msg,
 
 nla_put_failure_type_locked:
 	spin_unlock_bh(&devlink_port->type_lock);
-	rtnl_unlock();
+	if (!rtnl_held)
+		rtnl_unlock();
 nla_put_failure:
 	genlmsg_cancel(msg, hdr);
 	return -EMSGSIZE;
 }
 
-static void devlink_port_notify(struct devlink_port *devlink_port,
-				enum devlink_command cmd)
+static void __devlink_port_notify(struct devlink_port *devlink_port,
+				  enum devlink_command cmd, bool rtnl_held)
 {
 	struct devlink *devlink = devlink_port->devlink;
 	struct sk_buff *msg;
@@ -1358,7 +1362,8 @@ static void devlink_port_notify(struct devlink_port *devlink_port,
 	if (!msg)
 		return;
 
-	err = devlink_nl_port_fill(msg, devlink_port, cmd, 0, 0, 0, NULL);
+	err = devlink_nl_port_fill(msg, devlink_port, cmd, 0, 0, 0, NULL,
+				   rtnl_held);
 	if (err) {
 		nlmsg_free(msg);
 		return;
@@ -1368,6 +1373,12 @@ static void devlink_port_notify(struct devlink_port *devlink_port,
 				0, DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
 }
 
+static void devlink_port_notify(struct devlink_port *devlink_port,
+				enum devlink_command cmd)
+{
+	__devlink_port_notify(devlink_port, cmd, false);
+}
+
 static void devlink_rate_notify(struct devlink_rate *devlink_rate,
 				enum devlink_command cmd)
 {
@@ -1531,7 +1542,7 @@ static int devlink_nl_cmd_port_get_doit(struct sk_buff *skb,
 
 	err = devlink_nl_port_fill(msg, devlink_port, DEVLINK_CMD_PORT_NEW,
 				   info->snd_portid, info->snd_seq, 0,
-				   info->extack);
+				   info->extack, false);
 	if (err) {
 		nlmsg_free(msg);
 		return err;
@@ -1561,7 +1572,8 @@ static int devlink_nl_cmd_port_get_dumpit(struct sk_buff *msg,
 						   DEVLINK_CMD_NEW,
 						   NETLINK_CB(cb->skb).portid,
 						   cb->nlh->nlmsg_seq,
-						   NLM_F_MULTI, cb->extack);
+						   NLM_F_MULTI, cb->extack,
+						   false);
 			if (err) {
 				devl_unlock(devlink);
 				devlink_put(devlink);
@@ -1773,7 +1785,8 @@ static int devlink_port_new_notify(struct devlink *devlink,
 	}
 
 	err = devlink_nl_port_fill(msg, devlink_port, DEVLINK_CMD_NEW,
-				   info->snd_portid, info->snd_seq, 0, NULL);
+				   info->snd_portid, info->snd_seq, 0, NULL,
+				   false);
 	if (err)
 		goto out;
 
@@ -10033,7 +10046,7 @@ static void devlink_port_type_netdev_checks(struct devlink_port *devlink_port,
 
 static void __devlink_port_type_set(struct devlink_port *devlink_port,
 				    enum devlink_port_type type,
-				    void *type_dev)
+				    void *type_dev, bool rtnl_held)
 {
 	struct net_device *netdev = type_dev;
 
@@ -10060,7 +10073,7 @@ static void __devlink_port_type_set(struct devlink_port *devlink_port,
 		break;
 	}
 	spin_unlock_bh(&devlink_port->type_lock);
-	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_NEW);
+	__devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_NEW, rtnl_held);
 }
 
 /**
@@ -10077,7 +10090,8 @@ void devlink_port_type_eth_set(struct devlink_port *devlink_port,
 			 "devlink port type for port %d set to Ethernet without a software interface reference, device type not supported by the kernel?\n",
 			 devlink_port->index);
 
-	__devlink_port_type_set(devlink_port, DEVLINK_PORT_TYPE_ETH, netdev);
+	__devlink_port_type_set(devlink_port, DEVLINK_PORT_TYPE_ETH, netdev,
+				false);
 }
 EXPORT_SYMBOL_GPL(devlink_port_type_eth_set);
 
@@ -10090,7 +10104,8 @@ EXPORT_SYMBOL_GPL(devlink_port_type_eth_set);
 void devlink_port_type_ib_set(struct devlink_port *devlink_port,
 			      struct ib_device *ibdev)
 {
-	__devlink_port_type_set(devlink_port, DEVLINK_PORT_TYPE_IB, ibdev);
+	__devlink_port_type_set(devlink_port, DEVLINK_PORT_TYPE_IB, ibdev,
+				false);
 }
 EXPORT_SYMBOL_GPL(devlink_port_type_ib_set);
 
@@ -10101,7 +10116,8 @@ EXPORT_SYMBOL_GPL(devlink_port_type_ib_set);
  */
 void devlink_port_type_clear(struct devlink_port *devlink_port)
 {
-	__devlink_port_type_set(devlink_port, DEVLINK_PORT_TYPE_NOTSET, NULL);
+	__devlink_port_type_set(devlink_port, DEVLINK_PORT_TYPE_NOTSET, NULL,
+				false);
 }
 EXPORT_SYMBOL_GPL(devlink_port_type_clear);
 
-- 
2.37.3

