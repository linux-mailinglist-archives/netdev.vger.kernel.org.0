Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8D1CCBE6
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 20:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387597AbfJESFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 14:05:01 -0400
Received: from mail-wr1-f41.google.com ([209.85.221.41]:39002 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729569AbfJESEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 14:04:53 -0400
Received: by mail-wr1-f41.google.com with SMTP id r3so10714090wrj.6
        for <netdev@vger.kernel.org>; Sat, 05 Oct 2019 11:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FVhyDzH3WCyIyCNCs211f+mB5M8bQNhgqHDuRlzmPD4=;
        b=NJtEjv+/pdbnmW2XALt4MJKN1RVicVx0e+4xKP5ip3/dRWSyBYdHC/8nZnJeOT7yJr
         Vt2ciwfnmt4aYaReB7exeGBegvo3RtU3cmSHhQJoE366d1pEmR9jiCpM8VQ2eAgrwLd4
         id1iWrZDN/noyKOZ4cYwBzO8HAw17E0hNV5pH2ip6NIYiZwbKsvl1HBYzng4bD19qWPH
         zvy1yVNnf5ZgAodAFsObXidJp6fBtoTS42Giv1AKvbtyQ7EpmO8LcXvnosB6HTH/PgCV
         lv1CxqVNych/m6/kGaOGb1AhwtdbpRmE5FH9CADeQMhkaWZZtY7pOAQijWsc915uegf6
         0Yqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FVhyDzH3WCyIyCNCs211f+mB5M8bQNhgqHDuRlzmPD4=;
        b=mi5UR2xZ4/ZpPnQxA0Mix0tyO8kbLO4XUlGfMSBYnVjj0rYwLqxWy9mjtd33l20379
         rUNO0v4mXNopJjUJV7kzKuoYEXaT++aNin7RLaVNw6Wdw1RHqNKOagQSIdi3NBznIYn0
         PpklvTcL9KsTT+0Z+3wctoEsSHSneXU9WxnC2d9rXLKPLBS5/RV4HdEi0TKkWiUh7pBY
         OjS0QuxbbLJnUjcCq5UDwKpsGeNaVnSxYhUSAEUZ+XdaSjRT+OFeF5vo1mxC+cGEHGbV
         mP9r2myWesfGxIh9QcZ+wZh+RYpBcUyOb1ggZTT3t4dmaQpMFRscU4zzZW4rBPpt6Y9H
         O1VQ==
X-Gm-Message-State: APjAAAXVzSPRNB8TZBTNDmJRdLc/6OAY7G9dy/nUmlDbnzI7gwRyr5J5
        N5cx1jk95VRxfIDh7qGA0eaVBTvlSh4=
X-Google-Smtp-Source: APXvYqye5L+ol5LbZ1Op45RfzaEPV0lQWnbKF70vm4Qx74o63GbLTOCJQNQr9IzD4Ouef8HjBjy5KQ==
X-Received: by 2002:a5d:69c8:: with SMTP id s8mr10562789wrw.32.1570298690283;
        Sat, 05 Oct 2019 11:04:50 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id x129sm14892868wmg.8.2019.10.05.11.04.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Oct 2019 11:04:49 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        alex.aring@gmail.com, stefan@datenfreihafen.org,
        jon.maloy@ericsson.com, ying.xue@windriver.com,
        johannes.berg@intel.com, mkubecek@suse.cz, yuehaibing@huawei.com,
        mlxsw@mellanox.com
Subject: [patch net-next 07/10] net: tipc: have genetlink code to parse the attrs during dumpit
Date:   Sat,  5 Oct 2019 20:04:39 +0200
Message-Id: <20191005180442.11788-8-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191005180442.11788-1-jiri@resnulli.us>
References: <20191005180442.11788-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Benefit from the fact that the generic netlink code can parse the attrs
for dumpit op and avoid need to parse it in the op callback.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 net/tipc/netlink.c   | 9 ++++++---
 net/tipc/node.c      | 6 +-----
 net/tipc/socket.c    | 6 +-----
 net/tipc/udp_media.c | 6 +-----
 4 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/net/tipc/netlink.c b/net/tipc/netlink.c
index d6165ad384c0..5f5df232d72b 100644
--- a/net/tipc/netlink.c
+++ b/net/tipc/netlink.c
@@ -176,7 +176,8 @@ static const struct genl_ops tipc_genl_v2_ops[] = {
 	},
 	{
 		.cmd	= TIPC_NL_PUBL_GET,
-		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.validate = GENL_DONT_VALIDATE_STRICT |
+			    GENL_DONT_VALIDATE_DUMP_STRICT,
 		.dumpit	= tipc_nl_publ_dump,
 	},
 	{
@@ -239,7 +240,8 @@ static const struct genl_ops tipc_genl_v2_ops[] = {
 	},
 	{
 		.cmd	= TIPC_NL_MON_PEER_GET,
-		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.validate = GENL_DONT_VALIDATE_STRICT |
+			    GENL_DONT_VALIDATE_DUMP_STRICT,
 		.dumpit	= tipc_nl_node_dump_monitor_peer,
 	},
 	{
@@ -250,7 +252,8 @@ static const struct genl_ops tipc_genl_v2_ops[] = {
 #ifdef CONFIG_TIPC_MEDIA_UDP
 	{
 		.cmd	= TIPC_NL_UDP_GET_REMOTEIP,
-		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.validate = GENL_DONT_VALIDATE_STRICT |
+			    GENL_DONT_VALIDATE_DUMP_STRICT,
 		.dumpit	= tipc_udp_nl_dump_remoteip,
 	},
 #endif
diff --git a/net/tipc/node.c b/net/tipc/node.c
index c8f6177dd5a2..f2e3cf70c922 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -2484,13 +2484,9 @@ int tipc_nl_node_dump_monitor_peer(struct sk_buff *skb,
 	int err;
 
 	if (!prev_node) {
-		struct nlattr **attrs;
+		struct nlattr **attrs = genl_dumpit_info(cb)->attrs;
 		struct nlattr *mon[TIPC_NLA_MON_MAX + 1];
 
-		err = tipc_nlmsg_parse(cb->nlh, &attrs);
-		if (err)
-			return err;
-
 		if (!attrs[TIPC_NLA_MON])
 			return -EINVAL;
 
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 3b9f8cc328f5..d579b64705b1 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -3588,13 +3588,9 @@ int tipc_nl_publ_dump(struct sk_buff *skb, struct netlink_callback *cb)
 	struct tipc_sock *tsk;
 
 	if (!tsk_portid) {
-		struct nlattr **attrs;
+		struct nlattr **attrs = genl_dumpit_info(cb)->attrs;
 		struct nlattr *sock[TIPC_NLA_SOCK_MAX + 1];
 
-		err = tipc_nlmsg_parse(cb->nlh, &attrs);
-		if (err)
-			return err;
-
 		if (!attrs[TIPC_NLA_SOCK])
 			return -EINVAL;
 
diff --git a/net/tipc/udp_media.c b/net/tipc/udp_media.c
index 287df68721df..43ca5fd6574d 100644
--- a/net/tipc/udp_media.c
+++ b/net/tipc/udp_media.c
@@ -448,15 +448,11 @@ int tipc_udp_nl_dump_remoteip(struct sk_buff *skb, struct netlink_callback *cb)
 	int i;
 
 	if (!bid && !skip_cnt) {
+		struct nlattr **attrs = genl_dumpit_info(cb)->attrs;
 		struct net *net = sock_net(skb->sk);
 		struct nlattr *battrs[TIPC_NLA_BEARER_MAX + 1];
-		struct nlattr **attrs;
 		char *bname;
 
-		err = tipc_nlmsg_parse(cb->nlh, &attrs);
-		if (err)
-			return err;
-
 		if (!attrs[TIPC_NLA_BEARER])
 			return -EINVAL;
 
-- 
2.21.0

