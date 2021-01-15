Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B61D22F85CE
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 20:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388429AbhAOTzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 14:55:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726970AbhAOTzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 14:55:35 -0500
Received: from mail.dr-lotz.de (mail.dr-lotz.de [IPv6:2a01:4f8:161:6ffe::5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D490BC061757;
        Fri, 15 Jan 2021 11:54:54 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mail.dr-lotz.de (Postfix) with ESMTP id 71F5F5AE08;
        Fri, 15 Jan 2021 20:54:50 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at mail.dr-lotz.de
Received: from mail.dr-lotz.de ([127.0.0.1])
        by localhost (mail.dr-lotz.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id B8Y0Tjl29kUU; Fri, 15 Jan 2021 20:54:46 +0100 (CET)
Received: from linus-pc.. (ipb21b6623.dynamic.kabel-deutschland.de [178.27.102.35])
        by mail.dr-lotz.de (Postfix) with ESMTPSA id 0929C5AE07;
        Fri, 15 Jan 2021 20:54:44 +0100 (CET)
From:   Linus Lotz <linus@lotz.li>
Cc:     Linus Lotz <linus@lotz.li>, kernel test robot <lkp@intel.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, wireguard@lists.zx2c4.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] wireguard: netlink: add multicast notification for peer changes
Date:   Fri, 15 Jan 2021 20:53:51 +0100
Message-Id: <20210115195353.11483-1-linus@lotz.li>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210109210056.160597-1-linus@lotz.li>
References: <20210109210056.160597-1-linus@lotz.li>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds a new multicast group to the netlink api for wireguard.
The purpose of this multicast group is to notify userspace when the
peers of an interface change. Right now this is only done when the
endpoint is changed by whatever means.

An example for an consumer of this API would be a service that keeps
track of all peer endpoints and sends this information to the peers.
This would allow NAT-to-NAT connections without the need of using
STUN on each client.

In v2 I fixed a possible uninitialized use.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Linus Lotz <linus@lotz.li>
---
 drivers/net/wireguard/netlink.c | 52 ++++++++++++++++++++++++++++++++-
 drivers/net/wireguard/netlink.h |  4 +++
 drivers/net/wireguard/socket.c  |  4 +++
 include/uapi/linux/wireguard.h  |  3 ++
 4 files changed, 62 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireguard/netlink.c b/drivers/net/wireguard/netlink.c
index d0f3b6d7f408..e9bb2a3a7b79 100644
--- a/drivers/net/wireguard/netlink.c
+++ b/drivers/net/wireguard/netlink.c
@@ -618,6 +618,12 @@ static const struct genl_ops genl_ops[] = {
 	}
 };
 
+static struct genl_multicast_group genl_mcgrps[] = {
+	{
+		.name = WG_MULTICAST_GROUP_PEER_CHANGE
+	}
+};
+
 static struct genl_family genl_family __ro_after_init = {
 	.ops = genl_ops,
 	.n_ops = ARRAY_SIZE(genl_ops),
@@ -626,7 +632,9 @@ static struct genl_family genl_family __ro_after_init = {
 	.maxattr = WGDEVICE_A_MAX,
 	.module = THIS_MODULE,
 	.policy = device_policy,
-	.netnsok = true
+	.netnsok = true,
+	.mcgrps = genl_mcgrps,
+	.n_mcgrps = ARRAY_SIZE(genl_mcgrps)
 };
 
 int __init wg_genetlink_init(void)
@@ -638,3 +646,45 @@ void __exit wg_genetlink_uninit(void)
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
index 410b318e57fb..d826e1f2b51c 100644
--- a/drivers/net/wireguard/socket.c
+++ b/drivers/net/wireguard/socket.c
@@ -8,6 +8,7 @@
 #include "socket.h"
 #include "queueing.h"
 #include "messages.h"
+#include "netlink.h"
 
 #include <linux/ctype.h>
 #include <linux/net.h>
@@ -293,6 +294,9 @@ void wg_socket_set_peer_endpoint(struct wg_peer *peer,
 	dst_cache_reset(&peer->endpoint_cache);
 out:
 	write_unlock_bh(&peer->endpoint_lock);
+
+	/* We need to notify the netlink listeners for about this change */
+	wg_genl_mcast_peer_endpoint_change(peer);
 }
 
 void wg_socket_set_peer_endpoint_from_skb(struct wg_peer *peer,
diff --git a/include/uapi/linux/wireguard.h b/include/uapi/linux/wireguard.h
index ae88be14c947..22a012644d71 100644
--- a/include/uapi/linux/wireguard.h
+++ b/include/uapi/linux/wireguard.h
@@ -136,9 +136,12 @@
 
 #define WG_KEY_LEN 32
 
+#define WG_MULTICAST_GROUP_PEER_CHANGE          "wg_peer_change"
+
 enum wg_cmd {
 	WG_CMD_GET_DEVICE,
 	WG_CMD_SET_DEVICE,
+	WG_CMD_CHANGED_PEER,
 	__WG_CMD_MAX
 };
 #define WG_CMD_MAX (__WG_CMD_MAX - 1)

base-commit: 65f0d2414b7079556fbbcc070b3d1c9f9587606d
-- 
2.26.2

