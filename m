Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D218067D533
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 20:15:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbjAZTPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 14:15:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232177AbjAZTPN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 14:15:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3A0564696
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 11:15:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5ED6D618F4
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 19:15:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AC80C433EF;
        Thu, 26 Jan 2023 19:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674760508;
        bh=+5HLhRI8AkEOxcQiIJRwMRWzbDgjs1QJYrUcgCLqylU=;
        h=From:To:Cc:Subject:Date:From;
        b=eQxlDlSVKupDt+VyFWICDrzOgdDZlt27JVVxUJUFF6nEqFRQCkzrKjh8U57fCQFyw
         cRXDi7BIhvV0xSR0z29JMUrWLs58JuRm1AFt/sj6HjXk/rYDoE92kBS4pWDPQ6GJzS
         RsPnOVZwQEn/h/Wa51H+O+XnIJhfk0a8AyAM6/O+OTbR4UYVlpd8/fbjsMptQ9h6YN
         i06SRdth8vWz8SwW7F4TusVTp7NJwnMktOW34CkxyBwU8pSB5uQxGHRJ6d7KrR1VBp
         GXmwTjCvAIpAA5vTVBBANjLq+Vvw09I9fZTZ5jOUoDtH0SlVfabUWy1r8j4cUw6iSM
         b6HEYZHrxkGLw==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        bridge@lists.linux-foundation.org,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, Nikolay Aleksandrov <razor@blackwall.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next] netlink: provide an ability to set default extack message
Date:   Thu, 26 Jan 2023 21:15:03 +0200
Message-Id: <2919eb55e2e9b92265a3ba600afc8137a901ae5f.1674760340.git.leon@kernel.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

In netdev common pattern, xxtack pointer is forwarded to the drivers
to be filled with error message. However, the caller can easily
overwrite the filled message.

Instead of adding multiple "if (!extack->_msg)" checks before any
NL_SET_ERR_MSG() call, which appears after call to the driver, let's
add this check to common code.

[1] https://lore.kernel.org/all/Y9Irgrgf3uxOjwUm@unreal
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/linux/netlink.h   |  4 ++--
 net/bridge/br_switchdev.c | 10 ++++------
 net/dsa/master.c          |  4 +---
 net/dsa/slave.c           |  5 ++---
 4 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index 38f6334f408c..87d2900cb448 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -101,7 +101,7 @@ struct netlink_ext_ack {
 							\
 	do_trace_netlink_extack(__msg);			\
 							\
-	if (__extack)					\
+	if (__extack && !__extack->_msg)		\
 		__extack->_msg = __msg;			\
 } while (0)
 
@@ -111,7 +111,7 @@ struct netlink_ext_ack {
 #define NL_SET_ERR_MSG_FMT(extack, fmt, args...) do {			       \
 	struct netlink_ext_ack *__extack = (extack);			       \
 									       \
-	if (!__extack)							       \
+	if (!__extack || __extack->_msg)				       \
 		break;							       \
 	if (snprintf(__extack->_msg_buf, NETLINK_MAX_FMTMSG_LEN,	       \
 		     "%s" fmt "%s", "", ##args, "") >=			       \
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 7eb6fd5bb917..9f7ff63ef853 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -104,9 +104,8 @@ int br_switchdev_set_port_flag(struct net_bridge_port *p,
 		return 0;
 
 	if (err) {
-		if (extack && !extack->_msg)
-			NL_SET_ERR_MSG_MOD(extack,
-					   "bridge flag offload is not supported");
+		NL_SET_ERR_MSG_MOD(extack,
+				   "bridge flag offload is not supported");
 		return -EOPNOTSUPP;
 	}
 
@@ -115,9 +114,8 @@ int br_switchdev_set_port_flag(struct net_bridge_port *p,
 
 	err = switchdev_port_attr_set(p->dev, &attr, extack);
 	if (err) {
-		if (extack && !extack->_msg)
-			NL_SET_ERR_MSG_MOD(extack,
-					   "error setting offload flag on port");
+		NL_SET_ERR_MSG_MOD(extack,
+				   "error setting offload flag on port");
 		return err;
 	}
 
diff --git a/net/dsa/master.c b/net/dsa/master.c
index 26d90140d271..bcf39c524664 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -464,9 +464,7 @@ int dsa_master_lag_setup(struct net_device *lag_dev, struct dsa_port *cpu_dp,
 
 	err = dsa_port_lag_join(cpu_dp, lag_dev, uinfo, extack);
 	if (err) {
-		if (extack && !extack->_msg)
-			NL_SET_ERR_MSG_MOD(extack,
-					   "CPU port failed to join LAG");
+		NL_SET_ERR_MSG_MOD(extack, "CPU port failed to join LAG");
 		goto out_master_teardown;
 	}
 
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 6014ac3aad34..c5527aa2c403 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2692,9 +2692,8 @@ static int dsa_slave_changeupper(struct net_device *dev,
 			if (!err)
 				dsa_bridge_mtu_normalization(dp);
 			if (err == -EOPNOTSUPP) {
-				if (extack && !extack->_msg)
-					NL_SET_ERR_MSG_MOD(extack,
-							   "Offloading not supported");
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Offloading not supported");
 				err = 0;
 			}
 			err = notifier_from_errno(err);
-- 
2.39.1

