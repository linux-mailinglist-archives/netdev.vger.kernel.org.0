Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 225A14FAFBD
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 21:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239856AbiDJTS0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 15:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234850AbiDJTSY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 15:18:24 -0400
X-Greylist: delayed 561 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 10 Apr 2022 12:16:09 PDT
Received: from mail.dr-lotz.de (mail.dr-lotz.de [5.9.59.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29C2136149;
        Sun, 10 Apr 2022 12:16:09 -0700 (PDT)
Received: from linus-pc.. (ipbcc0dc80.dynamic.kabel-deutschland.de [188.192.220.128])
        by mail.dr-lotz.de (Postfix) with ESMTPSA id DA43A6CC2D;
        Sun, 10 Apr 2022 21:06:45 +0200 (CEST)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=lotz.li; s=202112;
        t=1649617606;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yvR5KIYx1siUjLyjZY1sVsdO1xVwMh3dAu4n9WZQ60U=;
        b=6pwaIwUhy/ELWwmMHnDX9uVWES9K+D67W6Sdj6JloCPdR1YJYKswzjKQHhl/dL5i6tZDRr
        ugFDl5aadWF2WbAQ==
From:   Linus Karl <linus@lotz.li>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     wireguard@lists.zx2c4.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linus Karl <linus@lotz.li>
Subject: [PATCH v3] wireguard: add netlink mcast on endpoint change
Date:   Sun, 10 Apr 2022 21:06:35 +0200
Message-Id: <20220410190635.1171195-2-linus@lotz.li>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220410190635.1171195-1-linus@lotz.li>
References: <20220410190635.1171195-1-linus@lotz.li>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: -----
X-Rspamd-Queue-Id: DA43A6CC2D
Authentication-Results: ORIGINATING;
        auth=pass smtp.auth=linus smtp.mailfrom=linus@lotz.li
X-Spamd-Result: default: False [-5.60 / 15.00];
        REPLY(-4.00)[];
        BAYES_HAM(-3.00)[100.00%];
        MID_CONTAINS_FROM(1.00)[];
        R_MISSING_CHARSET(0.50)[];
        MIME_GOOD(-0.10)[text/plain];
        RCVD_COUNT_ZERO(0.00)[0];
        MIME_TRACE(0.00)[0:+];
        FROM_EQ_ENVFROM(0.00)[];
        RCPT_COUNT_SEVEN(0.00)[8];
        DKIM_SIGNED(0.00)[lotz.li:s=202112];
        TO_MATCH_ENVRCPT_ALL(0.00)[];
        ASN(0.00)[asn:3209, ipnet:188.192.0.0/14, country:DE];
        FROM_HAS_DN(0.00)[];
        TO_DN_SOME(0.00)[];
        ARC_NA(0.00)[]
X-Rspamd-Server: mail
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds a new multicast group "peers" to the netlink api for
wireguard. The purpose of this multicast group is to notify userspace
when the peers of an interface change. This is also triggered when
root changes the endpoint manually.

This feature is enabled through setting a new WGDEVICE_A_MONITOR
attribute to WGDEVICE_MONITOR_F_ENDPOINT.

An example for an consumer of this API would be a service that keeps
track of all peer endpoints and sends this information to the peers.
This would allow NAT-to-NAT connections without the need of using
STUN on each client.

Signed-off-by: Linus Karl <linus@lotz.li>
---
 drivers/net/wireguard/device.h  |  1 +
 drivers/net/wireguard/netlink.c | 68 +++++++++++++++++++++++++++++++--
 drivers/net/wireguard/netlink.h |  4 ++
 drivers/net/wireguard/socket.c  |  5 +++
 include/uapi/linux/wireguard.h  | 12 ++++++
 5 files changed, 87 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireguard/device.h b/drivers/net/wireguard/device.h
index 43c7cebbf50b..74d9d772cc94 100644
--- a/drivers/net/wireguard/device.h
+++ b/drivers/net/wireguard/device.h
@@ -54,6 +54,7 @@ struct wg_device {
 	unsigned int num_peers, device_update_gen;
 	u32 fwmark;
 	u16 incoming_port;
+	bool endpoint_monitor;
 };
 
 int wg_device_init(void);
diff --git a/drivers/net/wireguard/netlink.c b/drivers/net/wireguard/netlink.c
index d0f3b6d7f408..5902910e015e 100644
--- a/drivers/net/wireguard/netlink.c
+++ b/drivers/net/wireguard/netlink.c
@@ -27,7 +27,8 @@ static const struct nla_policy device_policy[WGDEVICE_A_MAX + 1] = {
 	[WGDEVICE_A_FLAGS]		= { .type = NLA_U32 },
 	[WGDEVICE_A_LISTEN_PORT]	= { .type = NLA_U16 },
 	[WGDEVICE_A_FWMARK]		= { .type = NLA_U32 },
-	[WGDEVICE_A_PEERS]		= { .type = NLA_NESTED }
+	[WGDEVICE_A_PEERS]		= { .type = NLA_NESTED },
+	[WGDEVICE_A_MONITOR]		= { .type = NLA_U8 }
 };
 
 static const struct nla_policy peer_policy[WGPEER_A_MAX + 1] = {
@@ -233,7 +234,9 @@ static int wg_get_device_dump(struct sk_buff *skb, struct netlink_callback *cb)
 				wg->incoming_port) ||
 		    nla_put_u32(skb, WGDEVICE_A_FWMARK, wg->fwmark) ||
 		    nla_put_u32(skb, WGDEVICE_A_IFINDEX, wg->dev->ifindex) ||
-		    nla_put_string(skb, WGDEVICE_A_IFNAME, wg->dev->name))
+		    nla_put_string(skb, WGDEVICE_A_IFNAME, wg->dev->name) ||
+		    nla_put_u8(skb, WGDEVICE_A_MONITOR,
+			       wg->endpoint_monitor ? WGDEVICE_MONITOR_F_ENDPOINT : 0))
 			goto out;
 
 		down_read(&wg->static_identity.lock);
@@ -538,6 +541,15 @@ static int wg_set_device(struct sk_buff *skb, struct genl_info *info)
 			goto out;
 	}
 
+	if (info->attrs[WGDEVICE_A_MONITOR]) {
+		u8 monitor = nla_get_u8(info->attrs[WGDEVICE_A_MONITOR]);
+
+		if (monitor & ~__WGDEVICE_MONITOR_F_ALL)
+			goto out;
+		wg->endpoint_monitor =
+			(monitor & WGDEVICE_MONITOR_F_ENDPOINT) == WGDEVICE_MONITOR_F_ENDPOINT;
+	}
+
 	if (flags & WGDEVICE_F_REPLACE_PEERS)
 		wg_peer_remove_all(wg);
 
@@ -618,6 +630,12 @@ static const struct genl_ops genl_ops[] = {
 	}
 };
 
+static const struct genl_multicast_group wg_genl_mcgrps[] = {
+	{
+		.name = WG_MULTICAST_GROUP_PEERS
+	}
+};
+
 static struct genl_family genl_family __ro_after_init = {
 	.ops = genl_ops,
 	.n_ops = ARRAY_SIZE(genl_ops),
@@ -626,7 +644,9 @@ static struct genl_family genl_family __ro_after_init = {
 	.maxattr = WGDEVICE_A_MAX,
 	.module = THIS_MODULE,
 	.policy = device_policy,
-	.netnsok = true
+	.netnsok = true,
+	.mcgrps = wg_genl_mcgrps,
+	.n_mcgrps = ARRAY_SIZE(wg_genl_mcgrps)
 };
 
 int __init wg_genetlink_init(void)
@@ -638,3 +658,45 @@ void __exit wg_genetlink_uninit(void)
 {
 	genl_unregister_family(&genl_family);
 }
+
+int wg_genl_mcast_peer_endpoint_change(struct wg_peer *peer)
+{
+	struct sk_buff *skb;
+	void *hdr, *peer_nest, *peer_array_nest;
+	int fail = 0;
+
+	skb = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	hdr = genlmsg_put(skb, 0, 0,
+			  &genl_family, 0, WG_CMD_CHANGED_PEER);
+
+	nla_put_u32(skb, WGDEVICE_A_IFINDEX, peer->device->dev->ifindex);
+	nla_put_string(skb, WGDEVICE_A_IFNAME, peer->device->dev->name);
+
+	peer_nest = nla_nest_start(skb, WGDEVICE_A_PEERS);
+	peer_array_nest = nla_nest_start(skb, 0);
+	down_read(&peer->handshake.lock);
+	nla_put(skb, WGPEER_A_PUBLIC_KEY, NOISE_PUBLIC_KEY_LEN,
+		peer->handshake.remote_static);
+	up_read(&peer->handshake.lock);
+
+	read_lock_bh(&peer->endpoint_lock);
+	if (peer->endpoint.addr.sa_family == AF_INET)
+		fail = nla_put(skb, WGPEER_A_ENDPOINT,
+			       sizeof(peer->endpoint.addr4),
+			       &peer->endpoint.addr4);
+	else if (peer->endpoint.addr.sa_family == AF_INET6)
+		fail = nla_put(skb, WGPEER_A_ENDPOINT,
+			       sizeof(peer->endpoint.addr6),
+			       &peer->endpoint.addr6);
+	read_unlock_bh(&peer->endpoint_lock);
+	if (fail)
+		return fail;
+
+	nla_nest_end(skb, peer_array_nest);
+	nla_nest_end(skb, peer_nest);
+	genlmsg_end(skb, hdr);
+
+	fail = genlmsg_multicast_netns(&genl_family, dev_net(peer->device->dev),
+				       skb, 0, 0, GFP_KERNEL);
+	return fail;
+}
diff --git a/drivers/net/wireguard/netlink.h b/drivers/net/wireguard/netlink.h
index 15100d92e2e3..74ecc72a79a6 100644
--- a/drivers/net/wireguard/netlink.h
+++ b/drivers/net/wireguard/netlink.h
@@ -6,6 +6,10 @@
 #ifndef _WG_NETLINK_H
 #define _WG_NETLINK_H
 
+#include "peer.h"
+
+int wg_genl_mcast_peer_endpoint_change(struct wg_peer *peer);
+
 int wg_genetlink_init(void);
 void wg_genetlink_uninit(void);
 
diff --git a/drivers/net/wireguard/socket.c b/drivers/net/wireguard/socket.c
index 0414d7a6ce74..33e4da2a37ee 100644
--- a/drivers/net/wireguard/socket.c
+++ b/drivers/net/wireguard/socket.c
@@ -8,6 +8,7 @@
 #include "socket.h"
 #include "queueing.h"
 #include "messages.h"
+#include "netlink.h"
 
 #include <linux/ctype.h>
 #include <linux/net.h>
@@ -294,6 +295,10 @@ void wg_socket_set_peer_endpoint(struct wg_peer *peer,
 	dst_cache_reset(&peer->endpoint_cache);
 out:
 	write_unlock_bh(&peer->endpoint_lock);
+
+	if (peer->device->endpoint_monitor) {
+		wg_genl_mcast_peer_endpoint_change(peer);
+	}
 }
 
 void wg_socket_set_peer_endpoint_from_skb(struct wg_peer *peer,
diff --git a/include/uapi/linux/wireguard.h b/include/uapi/linux/wireguard.h
index ae88be14c947..cde044fb1124 100644
--- a/include/uapi/linux/wireguard.h
+++ b/include/uapi/linux/wireguard.h
@@ -29,6 +29,7 @@
  *    WGDEVICE_A_PUBLIC_KEY: NLA_EXACT_LEN, len WG_KEY_LEN
  *    WGDEVICE_A_LISTEN_PORT: NLA_U16
  *    WGDEVICE_A_FWMARK: NLA_U32
+ *    WGDEVICE_A_MONITOR: NLA_U8
  *    WGDEVICE_A_PEERS: NLA_NESTED
  *        0: NLA_NESTED
  *            WGPEER_A_PUBLIC_KEY: NLA_EXACT_LEN, len WG_KEY_LEN
@@ -83,6 +84,9 @@
  *    WGDEVICE_A_PRIVATE_KEY: len WG_KEY_LEN, all zeros to remove
  *    WGDEVICE_A_LISTEN_PORT: NLA_U16, 0 to choose randomly
  *    WGDEVICE_A_FWMARK: NLA_U32, 0 to disable
+ *    WGDEVICE_A_MONITOR: NLA_U8, set to a value of wgdevice_monitor_flag to
+ *                      enable monitoring of events using multicast messages
+ *                      over netlink
  *    WGDEVICE_A_PEERS: NLA_NESTED
  *        0: NLA_NESTED
  *            WGPEER_A_PUBLIC_KEY: len WG_KEY_LEN
@@ -136,9 +140,12 @@
 
 #define WG_KEY_LEN 32
 
+#define WG_MULTICAST_GROUP_PEERS          "peers"
+
 enum wg_cmd {
 	WG_CMD_GET_DEVICE,
 	WG_CMD_SET_DEVICE,
+	WG_CMD_CHANGED_PEER,
 	__WG_CMD_MAX
 };
 #define WG_CMD_MAX (__WG_CMD_MAX - 1)
@@ -157,9 +164,14 @@ enum wgdevice_attribute {
 	WGDEVICE_A_LISTEN_PORT,
 	WGDEVICE_A_FWMARK,
 	WGDEVICE_A_PEERS,
+	WGDEVICE_A_MONITOR,
 	__WGDEVICE_A_LAST
 };
 #define WGDEVICE_A_MAX (__WGDEVICE_A_LAST - 1)
+enum wgdevice_monitor_flag {
+	WGDEVICE_MONITOR_F_ENDPOINT = 1U << 0,
+	__WGDEVICE_MONITOR_F_ALL = WGDEVICE_MONITOR_F_ENDPOINT
+};
 
 enum wgpeer_flag {
 	WGPEER_F_REMOVE_ME = 1U << 0,

base-commit: 1862a69c917417142190bc18c8ce16680598664b
-- 
2.35.1

