Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D494627F3ED
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 23:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730661AbgI3VH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 17:07:28 -0400
Received: from mail.katalix.com ([3.9.82.81]:34398 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgI3VH1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 17:07:27 -0400
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 89CF796D4C;
        Wed, 30 Sep 2020 22:07:24 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1601500044; bh=Ew6Gu8ZYt3H2BG4QitXglq3IoGnuRqhLSYy/yVM3/8w=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=20net-next=201/6]=20l2tp:=20add=
         20netlink=20info=20to=20session=20create=20callback|Date:=20Wed,=2
         030=20Sep=202020=2022:07:02=20+0100|Message-Id:=20<20200930210707.
         10717-2-tparkin@katalix.com>|In-Reply-To:=20<20200930210707.10717-
         1-tparkin@katalix.com>|References:=20<20200930210707.10717-1-tpark
         in@katalix.com>;
        b=oqMs4et/Rtg2Pr61NYFJrw3pR/1mm/bLubOZEPzSHGNyMQxYpUGGlYcenYe4vGkyq
         jQC8i00CABEZ5by8wp2G7nEJlxYajSUR6/aHgfiT2JcxbjDeXiQ8yYV6abgQ+F7Hgu
         CeU/YM9POuqZI4gfPf9jsFaQfMb08zy2ptAlLakIUu6rzQdX3py8V+oCDY0pMM3JaE
         HbFnK/vWAa6Yqu8hEfddo2ULhpxxSGUL6MzBbCK94imZnJkv7iu+ShQ3kt7AC4ERKO
         l9/rWbI5UGQu7WlGam5T8r3TAJQy0xdkdmVoCjAxU8Cuim4p7K0we25044XMH6ZgnP
         SRZl+MoFCj9nQ==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH net-next 1/6] l2tp: add netlink info to session create callback
Date:   Wed, 30 Sep 2020 22:07:02 +0100
Message-Id: <20200930210707.10717-2-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200930210707.10717-1-tparkin@katalix.com>
References: <20200930210707.10717-1-tparkin@katalix.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To support creating different types of pseudowire, l2tp's netlink
commands for session create and destroy are implemented using callbacks
into pseudowire-specific code.

The pseudowire types implemented so far (PPP and Ethernet) use common
parameters which are extracted by l2tp_netlink into a session
configuration structure.

Different pseudowires may require different parameters: rather than
adding these to the common configuration structure, make the netlink
info visible to the pseudowire code so that it can perform its own
validation of the extra attributes it requires.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_core.h    | 4 +++-
 net/l2tp/l2tp_eth.c     | 3 ++-
 net/l2tp/l2tp_netlink.c | 3 ++-
 net/l2tp/l2tp_ppp.c     | 3 ++-
 4 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/l2tp/l2tp_core.h b/net/l2tp/l2tp_core.h
index cb21d906343e..bd62a3e2c98d 100644
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -10,6 +10,7 @@
 
 #include <net/dst.h>
 #include <net/sock.h>
+#include <net/genetlink.h>
 
 #ifdef CONFIG_XFRM
 #include <net/xfrm.h>
@@ -196,7 +197,8 @@ struct l2tp_nl_cmd_ops {
 	 */
 	int (*session_create)(struct net *net, struct l2tp_tunnel *tunnel,
 			      u32 session_id, u32 peer_session_id,
-			      struct l2tp_session_cfg *cfg);
+			      struct l2tp_session_cfg *cfg,
+			      struct genl_info *info);
 
 	/* The pseudowire session delete callback is responsible for initiating the deletion
 	 * of a session instance.
diff --git a/net/l2tp/l2tp_eth.c b/net/l2tp/l2tp_eth.c
index 6cd97c75445c..b2545e699174 100644
--- a/net/l2tp/l2tp_eth.c
+++ b/net/l2tp/l2tp_eth.c
@@ -243,7 +243,8 @@ static void l2tp_eth_adjust_mtu(struct l2tp_tunnel *tunnel,
 
 static int l2tp_eth_create(struct net *net, struct l2tp_tunnel *tunnel,
 			   u32 session_id, u32 peer_session_id,
-			   struct l2tp_session_cfg *cfg)
+			   struct l2tp_session_cfg *cfg,
+			   struct genl_info *info)
 {
 	unsigned char name_assign_type;
 	struct net_device *dev;
diff --git a/net/l2tp/l2tp_netlink.c b/net/l2tp/l2tp_netlink.c
index 5ca5056e9636..7045eb105e6a 100644
--- a/net/l2tp/l2tp_netlink.c
+++ b/net/l2tp/l2tp_netlink.c
@@ -629,7 +629,8 @@ static int l2tp_nl_cmd_session_create(struct sk_buff *skb, struct genl_info *inf
 	ret = l2tp_nl_cmd_ops[cfg.pw_type]->session_create(net, tunnel,
 							   session_id,
 							   peer_session_id,
-							   &cfg);
+							   &cfg,
+							   info);
 
 	if (ret >= 0) {
 		session = l2tp_tunnel_get_session(tunnel, session_id);
diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index aea85f91f059..a2f7896d047e 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -853,7 +853,8 @@ static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
 /* Called when creating sessions via the netlink interface. */
 static int pppol2tp_session_create(struct net *net, struct l2tp_tunnel *tunnel,
 				   u32 session_id, u32 peer_session_id,
-				   struct l2tp_session_cfg *cfg)
+				   struct l2tp_session_cfg *cfg,
+				   struct genl_info *info)
 {
 	int error;
 	struct l2tp_session *session;
-- 
2.17.1

