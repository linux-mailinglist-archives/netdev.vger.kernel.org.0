Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2F5C6136AE
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 13:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbiJaMnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 08:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231262AbiJaMm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 08:42:57 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BC8FF024
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 05:42:56 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id w14so15773823wru.8
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 05:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HIcI3a876/c5vg406sttxggNBT8FJejpvY3acJUf35U=;
        b=DU7akXW330PPrDWP/IKMgPzKiA27grJ580dB6fGAdV4g/kFzeK7xogZ31Gaq3B2JB8
         y2HtifyYPTJA0QPHuv66YLrGaoC2TvqF6tORVXGgASlUquxnJgUdAh67WIe277PomaDn
         m2+ITSPjoK0Ur00Z4EYXD9Bu6sD5zDnNRUruICR6enBidGfuY+FgEegVGK6sbpSOifih
         LmEkoQ9x7128CLyoHhmM+57UNyRK46skGJSNQ62Seblg8W2wrI/fX42XEBko0/2rRYL/
         J9Q1xG6ziJZuAl04HbL4mi4koA/tWWmF/WOohtWdGKpad2b0vC/cTlNRNYbQhvpdE+JL
         aYvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HIcI3a876/c5vg406sttxggNBT8FJejpvY3acJUf35U=;
        b=CnWM21OKf45wpVwSng1DA8bFQ4HMj7dImwlRL1ewRwJbZpPtJge1yblnq4EMQPGkFx
         cjxwHhv+bE1gGSmlqMwYeMfAVRutA/bq9aVUWz8mVEi3ddbZamDkaRFHf2kjlUbFQ3U0
         pkhwUL4uD5rNOsnkHNO82u9QQXMa67LSxKqaWlbqiUGADiAPhV80YRTvf45jEZkdHRM6
         +N6pA2Zk6S6fe0iRV4Rtxbojvegw8Dw88kQ0OF41+d/xSRV87ZhpRw1kg/9txHPh03V+
         np5Kdxw8ggLe9YNaAYStf6yWGOLiISb06xeLtyyDBf+O5kNO8IVAovo0gybmCvrkT0fZ
         AdzQ==
X-Gm-Message-State: ACrzQf3XVChoV9ggzRLkFiOImeTCPY1Sp/dy5HP2vly4E4EUBMwjublU
        mOUCsJDpYp2iFqzeOTmkDSZFyvmSCNRkVPqv
X-Google-Smtp-Source: AMsMyM6TDkVJVhr8VodvGtkvz9/2aEDjGg3JQgQRM+ooXNOFQ8psLxXa+IsU9ej+2AIX/AQ8pNmGtQ==
X-Received: by 2002:a5d:4e04:0:b0:236:5d2d:8c38 with SMTP id p4-20020a5d4e04000000b002365d2d8c38mr8203479wrt.593.1667220174618;
        Mon, 31 Oct 2022 05:42:54 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id m2-20020a5d4a02000000b00236695ff94fsm7009660wrq.34.2022.10.31.05.42.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 05:42:54 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com, linux-rdma@vger.kernel.org
Subject: [patch net-next v3 04/13] net: devlink: take RTNL in port_fill() function only if it is not held
Date:   Mon, 31 Oct 2022 13:42:39 +0100
Message-Id: <20221031124248.484405-5-jiri@resnulli.us>
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

