Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D52622879C
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730459AbgGURly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:41:54 -0400
Received: from mail.katalix.com ([3.9.82.81]:53296 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730322AbgGURlD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 13:41:03 -0400
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 2E62B93B09;
        Tue, 21 Jul 2020 18:33:02 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595352782; bh=fjWiUxPEoo9X0DjxqfBklZ8aHvXqcrapo+bP/UBWqWk=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20Tom=20Parkin=20<tparkin@katalix.com>|Subject:=20[PA
         TCH=2021/29]=20l2tp:=20cleanup=20netlink=20tunnel=20create=20addre
         ss=20handling|Date:=20Tue,=2021=20Jul=202020=2018:32:13=20+0100|Me
         ssage-Id:=20<20200721173221.4681-22-tparkin@katalix.com>|In-Reply-
         To:=20<20200721173221.4681-1-tparkin@katalix.com>|References:=20<2
         0200721173221.4681-1-tparkin@katalix.com>;
        b=eIbRdscQ1O/OWc2PN4iiOlsNzdaToAMmVITDJIuWKK1m3haYzCy35fFH7KLAr2NJ+
         UZpb1M0v7Xz6A7OgWa+V6jf8BH37O3S91vgKe4LdXMjgmtn8VDeyqm6l1KqZH2FjFe
         +ewVan7E/jkjorSWCiA1XAu6Q5tcRfcL3XSD8UkCaBWAfrIsAf8HrQBlO+ROdFJVQA
         bhG5geoi3hwpLhN+wPuFhNKxXgqY0hfsYkkJkPTP5LpixI+809VNZoTKoZtoG5QKGl
         OCMFX6IeHAKRPz8Mnuo5zDzOuovn+n+ufdcwJYtr2MXTf6lEfzeXTDsk/W8LYx3Hvj
         d3xwUCDleDUvw==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 21/29] l2tp: cleanup netlink tunnel create address handling
Date:   Tue, 21 Jul 2020 18:32:13 +0100
Message-Id: <20200721173221.4681-22-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200721173221.4681-1-tparkin@katalix.com>
References: <20200721173221.4681-1-tparkin@katalix.com>
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
index 8e03f2e367a0..35716a6e1e2c 100644
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
-		} else {
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

