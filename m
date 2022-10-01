Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF1AD5F1A18
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 08:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiJAGCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 02:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiJAGB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 02:01:56 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FDEC237C4
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 23:01:54 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id rk17so12932777ejb.1
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 23:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=4OPPORshq4VgAOLtcB/+XK7KZeUHC5ZInXXdg8Odd/s=;
        b=AzkTZ89fl8aPymoclqcsP8UTFDzOv3gP2WvV4c0ACKWbWv/KfWm4gJRcDne/Iyvw4c
         +obMFZINpNM3CVE8udRYdoGx6ugt1KKR9qcsHdC9Vh0LvDmsneaZSWPUHJY0UNOIK+yG
         dPQPs9bTaI+pFCEvmNiDUODqpLiYQ2mGzgJeNlD1wZkSaZGqnPR5a0YjS1JCD9mlEW1x
         mOOC4XehZDV2qc+Z6VGz7Z56HqEFUp42V+zI/PeUvYfgXdEly7yrAJSKU8Q96Z+7ajZC
         ThcCaXSW/6O1wWAB5WucKYvjdxBol0zyB0phZZeJUReXjsdTA4f+aGJAzPmyE/oqPJHC
         2bNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=4OPPORshq4VgAOLtcB/+XK7KZeUHC5ZInXXdg8Odd/s=;
        b=UJdFyNFCXENP4+Jmgt0G1Iaf8V7bJhQ/Rz6hdKDBd+4vD1oJfHT3BmTmYheteCBf5N
         ddnlfZCIHaSEezOFcz3qQQ6g1QGx78VtxOczPhKlkuBhi5+devuVwWADI6xVM95bwpyB
         vlIxjkBNBtVwIu6thVkz76qmS43mgWZC+puy+qYaNl2imsHtktGMhPrvdRt6XHNNQJY7
         5HbB1EveR0rVe7j60dkSnlEOfx3UzU83RuQFNgnMFFAxC41ZoyW8XBSXXoOuOQaBEkgF
         J4fvoqIh9SYdSXpQMD7cI/tpUy2zAU9v0mKFsEG1ZMncoemDQgN2K7bHwQPJZlnjxIH2
         3pxQ==
X-Gm-Message-State: ACrzQf1JKG8wh4LvoKOdZk5Hz8Z414KSIF8nLZLT7g5feK3/FtOasc2g
        MIphYxyBBcI7K3OGyVW/8rab9syMdmCZCEzg
X-Google-Smtp-Source: AMsMyM6nnzBqqNgXI4gji6wb85EIugA2Xx0/R9s+b4EB0LiYTgv8l9A0h4fHGaMz/H4d3a0h+nN40A==
X-Received: by 2002:a17:907:3dab:b0:783:4b01:1ffe with SMTP id he43-20020a1709073dab00b007834b011ffemr8705761ejc.107.1664604114054;
        Fri, 30 Sep 2022 23:01:54 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id v18-20020a50d092000000b00457e5a760e3sm2957519edd.54.2022.09.30.23.01.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 23:01:53 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com
Subject: [patch net-next 04/13] net: devlink: take RTNL in port_fill() function only if it is not held
Date:   Sat,  1 Oct 2022 08:01:36 +0200
Message-Id: <20221001060145.3199964-5-jiri@resnulli.us>
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

