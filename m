Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71C5F25BDED
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 10:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728150AbgICIzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 04:55:14 -0400
Received: from mail.katalix.com ([3.9.82.81]:42252 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726726AbgICIzJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Sep 2020 04:55:09 -0400
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 45AFB86C72;
        Thu,  3 Sep 2020 09:55:06 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1599123306; bh=RBVGU1T3ZOMGmU8xZc6RIZhXD5Vx8GtLhe85IXLD/h0=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=20net-next=203/6]=20l2tp:=20drop
         =20net=20argument=20from=20l2tp_tunnel_create|Date:=20Thu,=20=203=
         20Sep=202020=2009:54:49=20+0100|Message-Id:=20<20200903085452.9487
         -4-tparkin@katalix.com>|In-Reply-To:=20<20200903085452.9487-1-tpar
         kin@katalix.com>|References:=20<20200903085452.9487-1-tparkin@kata
         lix.com>;
        b=ItlMc6u6oQn1hMqDzatFDElb7zCZYYwf+54BtsGQ8I01Ji9xw/Itu8WNGnX//g1ZA
         fO4K48UkP2Api8e5cMeIDb4B1OpTIKp9LANhfjsHZmxqiURViwx6vOse9TWhx/Hw72
         mX0lDOvdTY+p/qzaIcdBHoulwIex42Whbn8HkdTiIMFKw2MGM56HMQgdXLO9GpBTE1
         MCGfzE4UTKJ9GEHc6ObU098Cc7fKu7WWco4Si9RyMoDJ9TrrR2p8/0+j2PqVGqnC+t
         5zKJmYogjTSn3p7QyfjzusyoI/GEND7X5t/bHehJjUG2A9pvdMEtQ3hOGcSIXEaxxT
         WGE9bVGLGllyQ==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH net-next 3/6] l2tp: drop net argument from l2tp_tunnel_create
Date:   Thu,  3 Sep 2020 09:54:49 +0100
Message-Id: <20200903085452.9487-4-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200903085452.9487-1-tparkin@katalix.com>
References: <20200903085452.9487-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The argument is unused, so remove it.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_core.c    | 2 +-
 net/l2tp/l2tp_core.h    | 2 +-
 net/l2tp/l2tp_netlink.c | 2 +-
 net/l2tp/l2tp_ppp.c     | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 4a8fb285fada..da66a6ed8993 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1381,7 +1381,7 @@ static int l2tp_tunnel_sock_create(struct net *net,
 
 static struct lock_class_key l2tp_socket_class;
 
-int l2tp_tunnel_create(struct net *net, int fd, int version, u32 tunnel_id, u32 peer_tunnel_id,
+int l2tp_tunnel_create(int fd, int version, u32 tunnel_id, u32 peer_tunnel_id,
 		       struct l2tp_tunnel_cfg *cfg, struct l2tp_tunnel **tunnelp)
 {
 	struct l2tp_tunnel *tunnel = NULL;
diff --git a/net/l2tp/l2tp_core.h b/net/l2tp/l2tp_core.h
index 5550a42dda04..3ce90c3f3491 100644
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -235,7 +235,7 @@ struct l2tp_session *l2tp_session_get_by_ifname(const struct net *net,
  * Creation of a new instance is a two-step process: create, then register.
  * Destruction is triggered using the *_delete functions, and completes asynchronously.
  */
-int l2tp_tunnel_create(struct net *net, int fd, int version, u32 tunnel_id,
+int l2tp_tunnel_create(int fd, int version, u32 tunnel_id,
 		       u32 peer_tunnel_id, struct l2tp_tunnel_cfg *cfg,
 		       struct l2tp_tunnel **tunnelp);
 int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
diff --git a/net/l2tp/l2tp_netlink.c b/net/l2tp/l2tp_netlink.c
index 31a1e27eab20..83c015f7f20d 100644
--- a/net/l2tp/l2tp_netlink.c
+++ b/net/l2tp/l2tp_netlink.c
@@ -233,7 +233,7 @@ static int l2tp_nl_cmd_tunnel_create(struct sk_buff *skb, struct genl_info *info
 	switch (cfg.encap) {
 	case L2TP_ENCAPTYPE_UDP:
 	case L2TP_ENCAPTYPE_IP:
-		ret = l2tp_tunnel_create(net, fd, proto_version, tunnel_id,
+		ret = l2tp_tunnel_create(fd, proto_version, tunnel_id,
 					 peer_tunnel_id, &cfg, &tunnel);
 		break;
 	}
diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index 998e0c6abf25..68d2489fc133 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -712,7 +712,7 @@ static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
 				goto end;
 			}
 
-			error = l2tp_tunnel_create(sock_net(sk), info.fd,
+			error = l2tp_tunnel_create(info.fd,
 						   info.version,
 						   info.tunnel_id,
 						   info.peer_tunnel_id, &tcfg,
-- 
2.17.1

