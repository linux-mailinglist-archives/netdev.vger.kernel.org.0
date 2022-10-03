Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3965F5F2F0D
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 12:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbiJCKwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 06:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiJCKwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 06:52:14 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A82A53D3C
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 03:52:12 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id 13so21267321ejn.3
        for <netdev@vger.kernel.org>; Mon, 03 Oct 2022 03:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=4OPPORshq4VgAOLtcB/+XK7KZeUHC5ZInXXdg8Odd/s=;
        b=bauJcDPqR46fWMGBsYLbYIbXmPW0QA10kJoJIJznCsriYz4uMwYkSWL3QSi6mPs13e
         czLTu8i8gQ7jxiMS8nz/zRQCRrrv7INsjudV+B8M1qid4IuL3/eELolKhPnycp2iliaw
         Jqa7seL63VuueJNMoOuR4X5ZLh5zlfhiM2Ltor18akMntXhrOu4UxcOJDDDhR0NhWoEm
         ERt7v0oW3r2BIlzjmzD9Oxqdqb62CGLYNp531AcOrkV5I2o4kVxRdchqcjY9YqJtRkMa
         R2R2biZ9Z9DJAArHIoszsYat4LL0WwmQLykWd1gB9dJwtTnVeswVtJ8/AO6hy0+Nkmla
         Sbjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=4OPPORshq4VgAOLtcB/+XK7KZeUHC5ZInXXdg8Odd/s=;
        b=o2AMUDP1JOr9ZbZtG12/fpVyyrGn437rCM6v6hVTJBlSb0DZn3aAPSzHVhOCkUvIgH
         Pn7uXXE4XS3OUvUos5vwnmCbGA9CLSxunSjjeZwu73yvC99oReO3uKQkGj0kbQyX7Sqo
         dc08QRW8gN9XieD5az+IBpZZSwVvVEqU2WIZOkW1LElE5wL9B/5yrl7Bw4uVyAlOFMuR
         q2Sln5h7trHrD4q1voNbHQm0YMZBh1skM8iWOfvV1dwa8thiDuXXkbYaEt+3blHDBYsK
         7AAP4fWNq1OKBQp4gdDBFUeGtB9R4NYdHKMXsqFcnhx1IzSv9zb7qK4lQ7ZKTBHDvG7D
         D+1Q==
X-Gm-Message-State: ACrzQf0Q+HIEo7NypJsOjaaRWnXO5BXcC/KHyH0g7S++0LiifusiFJ7T
        fPSH3ksyAhdvzyRxkVQalm0LrbOpYg0mVCMM6hc=
X-Google-Smtp-Source: AMsMyM6JODTwTOrYmZ1nEMbc+sjpwa5QxGONjhVKB4Uxy26PtxJKsA84awOuFB/0RTEToz4gMijqTQ==
X-Received: by 2002:a17:907:2723:b0:789:ae01:6fbd with SMTP id d3-20020a170907272300b00789ae016fbdmr6563974ejl.731.1664794330970;
        Mon, 03 Oct 2022 03:52:10 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id c10-20020a170906d18a00b0077a1dd3e7b7sm5281261ejz.102.2022.10.03.03.52.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 03:52:10 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com, linux-rdma@vger.kernel.org
Subject: [patch net-next v2 04/13] net: devlink: take RTNL in port_fill() function only if it is not held
Date:   Mon,  3 Oct 2022 12:51:55 +0200
Message-Id: <20221003105204.3315337-5-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221003105204.3315337-1-jiri@resnulli.us>
References: <20221003105204.3315337-1-jiri@resnulli.us>
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
index e49ec10d613f..ee14520d4690 100644
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
2.37.1

