Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB38841C1E4
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 11:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245154AbhI2JrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 05:47:16 -0400
Received: from mail.katalix.com ([3.9.82.81]:53946 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245124AbhI2JrM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 05:47:12 -0400
Received: from jackdaw.fritz.box (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 7EBF37D434;
        Wed, 29 Sep 2021 10:45:26 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1632908726; bh=FAjJ1g9uiB6OGmO9V4yyEVQiGZISu++U6rknJTffO08=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[RFC=20PATCH=20net-next=203/3]=20net/l2
         tp:=20add=20netlink=20attribute=20to=20enable=20flow-based=20sessi
         on=20creation|Date:=20Wed,=2029=20Sep=202021=2010:45:14=20+0100|Me
         ssage-Id:=20<20210929094514.15048-4-tparkin@katalix.com>|In-Reply-
         To:=20<20210929094514.15048-1-tparkin@katalix.com>|References:=20<
         20210929094514.15048-1-tparkin@katalix.com>;
        b=lL5Vw7jCktBfel9hVrXXoaNcBqUrvNPYsB/tZJq4+sP1ptrRttYHfOO/yT6XQ9npi
         1gxehMwisNwsOoXry/oxOleKWm6OBntw5dapd1pUJDMwV9plH6zpCck0rWT3sJsCSD
         TMDtkrk5NTpHnZL1exWe05QDkrf3hhqIsbox7o2hUnVW+TdF89SySgJxRM1/gloCnq
         JBg4eVcTtfbvluI9JmAVPzoeYTTSbwrDdT7PqTil0+wasdmrVsWFD2KQBrYys+Zwx2
         57xO9lj7VJzWpVYEvh6VxAfaWmPggR5PUoqTiCNdqYFQWQcaS/hXDpqmuuYz9b+yFg
         pYymVGdr+h8VA==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [RFC PATCH net-next 3/3] net/l2tp: add netlink attribute to enable flow-based session creation
Date:   Wed, 29 Sep 2021 10:45:14 +0100
Message-Id: <20210929094514.15048-4-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210929094514.15048-1-tparkin@katalix.com>
References: <20210929094514.15048-1-tparkin@katalix.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an attribute to be used with L2TP_CMD_SESSION_CREATE in order to
enable the use of the flow-based datapath.

If the attribute is not included in the message, or is set false, the
traditional pseudowire lookup is used, which will lead to a virtual
session netdev being created.

If the attribute is included and is set, no virtual session netdev will
be created, and the administrator must use appropriate tc filter/action
rules in order to manage session data packets.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 include/uapi/linux/l2tp.h |  1 +
 net/l2tp/l2tp_netlink.c   | 36 +++++++++++++++++++++++-------------
 2 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/include/uapi/linux/l2tp.h b/include/uapi/linux/l2tp.h
index bab8c9708611..86e02c8e97a4 100644
--- a/include/uapi/linux/l2tp.h
+++ b/include/uapi/linux/l2tp.h
@@ -127,6 +127,7 @@ enum {
 	L2TP_ATTR_UDP_ZERO_CSUM6_TX,	/* flag */
 	L2TP_ATTR_UDP_ZERO_CSUM6_RX,	/* flag */
 	L2TP_ATTR_PAD,
+	L2TP_ATTR_FLOW_DATAPATH,	/* flag */
 	__L2TP_ATTR_MAX,
 };
 
diff --git a/net/l2tp/l2tp_netlink.c b/net/l2tp/l2tp_netlink.c
index 96eb91be9238..5fb5fca74abd 100644
--- a/net/l2tp/l2tp_netlink.c
+++ b/net/l2tp/l2tp_netlink.c
@@ -528,6 +528,7 @@ static int l2tp_nl_cmd_session_create(struct sk_buff *skb, struct genl_info *inf
 	struct l2tp_session *session;
 	struct l2tp_session_cfg cfg = { 0, };
 	struct net *net = genl_info_net(info);
+	bool flow_path = false;
 
 	if (!info->attrs[L2TP_ATTR_CONN_ID]) {
 		ret = -EINVAL;
@@ -617,22 +618,30 @@ static int l2tp_nl_cmd_session_create(struct sk_buff *skb, struct genl_info *inf
 	if (info->attrs[L2TP_ATTR_RECV_TIMEOUT])
 		cfg.reorder_timeout = nla_get_msecs(info->attrs[L2TP_ATTR_RECV_TIMEOUT]);
 
+	if (info->attrs[L2TP_ATTR_FLOW_DATAPATH])
+		flow_path = nla_get_flag(info->attrs[L2TP_ATTR_FLOW_DATAPATH]);
+
+	if (flow_path) {
+		ret = l2tp_flow_session_create(tunnel, session_id, peer_session_id, &cfg);
+	} else {
 #ifdef CONFIG_MODULES
-	if (!l2tp_nl_cmd_ops[cfg.pw_type]) {
-		genl_unlock();
-		request_module("net-l2tp-type-%u", cfg.pw_type);
-		genl_lock();
-	}
+		if (!l2tp_nl_cmd_ops[cfg.pw_type]) {
+			genl_unlock();
+			request_module("net-l2tp-type-%u", cfg.pw_type);
+			genl_lock();
+		}
 #endif
-	if (!l2tp_nl_cmd_ops[cfg.pw_type] || !l2tp_nl_cmd_ops[cfg.pw_type]->session_create) {
-		ret = -EPROTONOSUPPORT;
-		goto out_tunnel;
-	}
+		if (!l2tp_nl_cmd_ops[cfg.pw_type] ||
+		    !l2tp_nl_cmd_ops[cfg.pw_type]->session_create) {
+			ret = -EPROTONOSUPPORT;
+			goto out_tunnel;
+		}
 
-	ret = l2tp_nl_cmd_ops[cfg.pw_type]->session_create(net, tunnel,
-							   session_id,
-							   peer_session_id,
-							   &cfg);
+		ret = l2tp_nl_cmd_ops[cfg.pw_type]->session_create(net, tunnel,
+								   session_id,
+								   peer_session_id,
+								   &cfg);
+	}
 
 	if (ret >= 0) {
 		session = l2tp_tunnel_get_session(tunnel, session_id);
@@ -918,6 +927,7 @@ static const struct nla_policy l2tp_nl_policy[L2TP_ATTR_MAX + 1] = {
 		.type = NLA_BINARY,
 		.len = 8,
 	},
+	[L2TP_ATTR_FLOW_DATAPATH]	= { .type = NLA_U8 },
 };
 
 static const struct genl_small_ops l2tp_nl_ops[] = {
-- 
2.17.1

