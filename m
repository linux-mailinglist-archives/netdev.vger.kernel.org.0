Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB30622ADCA
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 13:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728723AbgGWLaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 07:30:14 -0400
Received: from mail.katalix.com ([3.9.82.81]:44046 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728531AbgGWLaH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 07:30:07 -0400
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 029948AD87;
        Thu, 23 Jul 2020 12:30:04 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595503805; bh=OIIxnwb9DWGoR57H0e73lq1IK+kcyIZzTghpRyh4So0=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=205/6]=20l2tp:=20cleanup=20netli
         nk=20tunnel=20create=20address=20handling|Date:=20Thu,=2023=20Jul=
         202020=2012:29:54=20+0100|Message-Id:=20<20200723112955.19808-6-tp
         arkin@katalix.com>|In-Reply-To:=20<20200723112955.19808-1-tparkin@
         katalix.com>|References:=20<20200723112955.19808-1-tparkin@katalix
         .com>;
        b=LuU4mryaVsistTHPsMia6LnsxBDu/Pz3zjIqA4PA8Vpsv0ZHnkpEtTsRRdOAlcg27
         SLnZymNLwUS3jLHaZG+PN/hDlQ3K8FGU7EhmEji4ZNEa7W54XvWdJl1Heefg4HMbH+
         a/9UlNDLpXj0ZKW7sOaGrKijeiGtab71g4XHc2SdZrCTHBV39vrNlmAn6rIPPu6OzA
         hTH6sXk/mcp4FYZJMJ7RQ0HEIl40jt7nBDw3I0COfDiYj7uo9omnIH8UL53XKQtopj
         1ch4a+62PNhGa69abhdBQ0a7aA5ZANdSGZ27cINH7mPtMDXaInhRQrcCFfK6p6JcY6
         AYFfK1LvxS+LQ==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 5/6] l2tp: cleanup netlink tunnel create address handling
Date:   Thu, 23 Jul 2020 12:29:54 +0100
Message-Id: <20200723112955.19808-6-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200723112955.19808-1-tparkin@katalix.com>
References: <20200723112955.19808-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When creating an L2TP tunnel using the netlink API, userspace must
either pass a socket FD for the tunnel to use (for managed tunnels),
or specify the tunnel source/destination address (for unmanaged
tunnels).

Since source/destination addresses may be AF_INET or AF_INET6, the l2tp
netlink code has conditionally compiled blocks to support IPv6.

Rather than embedding these directly into l2tp_nl_cmd_tunnel_create
(where it makes the code difficult to read and confuses checkpatch to
boot) split the handling of address-related attributes into a separate
function.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_netlink.c | 57 ++++++++++++++++++++++++-----------------
 1 file changed, 33 insertions(+), 24 deletions(-)

diff --git a/net/l2tp/l2tp_netlink.c b/net/l2tp/l2tp_netlink.c
index 0021cc03417e..35716a6e1e2c 100644
--- a/net/l2tp/l2tp_netlink.c
+++ b/net/l2tp/l2tp_netlink.c
@@ -155,12 +155,38 @@ static int l2tp_session_notify(struct genl_family *family,
 	return ret;
 }
 
+static int l2tp_nl_cmd_tunnel_create_get_addr(struct nlattr **attrs, struct l2tp_tunnel_cfg *cfg)
+{
+	if (attrs[L2TP_ATTR_UDP_SPORT])
+		cfg->local_udp_port = nla_get_u16(attrs[L2TP_ATTR_UDP_SPORT]);
+	if (attrs[L2TP_ATTR_UDP_DPORT])
+		cfg->peer_udp_port = nla_get_u16(attrs[L2TP_ATTR_UDP_DPORT]);
+	cfg->use_udp_checksums = nla_get_flag(attrs[L2TP_ATTR_UDP_CSUM]);
+
+	/* Must have either AF_INET or AF_INET6 address for source and destination */
+#if IS_ENABLED(CONFIG_IPV6)
+	if (attrs[L2TP_ATTR_IP6_SADDR] && attrs[L2TP_ATTR_IP6_DADDR]) {
+		cfg->local_ip6 = nla_data(attrs[L2TP_ATTR_IP6_SADDR]);
+		cfg->peer_ip6 = nla_data(attrs[L2TP_ATTR_IP6_DADDR]);
+		cfg->udp6_zero_tx_checksums = nla_get_flag(attrs[L2TP_ATTR_UDP_ZERO_CSUM6_TX]);
+		cfg->udp6_zero_rx_checksums = nla_get_flag(attrs[L2TP_ATTR_UDP_ZERO_CSUM6_RX]);
+		return 0;
+	}
+#endif
+	if (attrs[L2TP_ATTR_IP_SADDR] && attrs[L2TP_ATTR_IP_DADDR]) {
+		cfg->local_ip.s_addr = nla_get_in_addr(attrs[L2TP_ATTR_IP_SADDR]);
+		cfg->peer_ip.s_addr = nla_get_in_addr(attrs[L2TP_ATTR_IP_DADDR]);
+		return 0;
+	}
+	return -EINVAL;
+}
+
 static int l2tp_nl_cmd_tunnel_create(struct sk_buff *skb, struct genl_info *info)
 {
 	u32 tunnel_id;
 	u32 peer_tunnel_id;
 	int proto_version;
-	int fd;
+	int fd = -1;
 	int ret = 0;
 	struct l2tp_tunnel_cfg cfg = { 0, };
 	struct l2tp_tunnel *tunnel;
@@ -191,33 +217,16 @@ static int l2tp_nl_cmd_tunnel_create(struct sk_buff *skb, struct genl_info *info
 	}
 	cfg.encap = nla_get_u16(attrs[L2TP_ATTR_ENCAP_TYPE]);
 
-	fd = -1;
+	/* Managed tunnels take the tunnel socket from userspace.
+	 * Unmanaged tunnels must call out the source and destination addresses
+	 * for the kernel to create the tunnel socket itself.
+	 */
 	if (attrs[L2TP_ATTR_FD]) {
 		fd = nla_get_u32(attrs[L2TP_ATTR_FD]);
 	} else {
-#if IS_ENABLED(CONFIG_IPV6)
-		if (attrs[L2TP_ATTR_IP6_SADDR] && attrs[L2TP_ATTR_IP6_DADDR]) {
-			cfg.local_ip6 = nla_data(attrs[L2TP_ATTR_IP6_SADDR]);
-			cfg.peer_ip6 = nla_data(attrs[L2TP_ATTR_IP6_DADDR]);
-		} else
-#endif
-		if (attrs[L2TP_ATTR_IP_SADDR] && attrs[L2TP_ATTR_IP_DADDR]) {
-			cfg.local_ip.s_addr = nla_get_in_addr(attrs[L2TP_ATTR_IP_SADDR]);
-			cfg.peer_ip.s_addr = nla_get_in_addr(attrs[L2TP_ATTR_IP_DADDR]);
-		} else {
-			ret = -EINVAL;
+		ret = l2tp_nl_cmd_tunnel_create_get_addr(attrs, &cfg);
+		if (ret < 0)
 			goto out;
-		}
-		if (attrs[L2TP_ATTR_UDP_SPORT])
-			cfg.local_udp_port = nla_get_u16(attrs[L2TP_ATTR_UDP_SPORT]);
-		if (attrs[L2TP_ATTR_UDP_DPORT])
-			cfg.peer_udp_port = nla_get_u16(attrs[L2TP_ATTR_UDP_DPORT]);
-		cfg.use_udp_checksums = nla_get_flag(attrs[L2TP_ATTR_UDP_CSUM]);
-
-#if IS_ENABLED(CONFIG_IPV6)
-		cfg.udp6_zero_tx_checksums = nla_get_flag(attrs[L2TP_ATTR_UDP_ZERO_CSUM6_TX]);
-		cfg.udp6_zero_rx_checksums = nla_get_flag(attrs[L2TP_ATTR_UDP_ZERO_CSUM6_RX]);
-#endif
 	}
 
 	if (attrs[L2TP_ATTR_DEBUG])
-- 
2.17.1

