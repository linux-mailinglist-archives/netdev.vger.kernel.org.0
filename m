Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3247A3D9BAF
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 04:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233869AbhG2CVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 22:21:34 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:35892 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233485AbhG2CVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 22:21:13 -0400
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id 0D0FF21499; Thu, 29 Jul 2021 10:21:10 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     Matt Johnston <matt@codeconstruct.com.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net-next v4 14/15] mctp: Allow per-netns default networks
Date:   Thu, 29 Jul 2021 10:20:52 +0800
Message-Id: <20210729022053.134453-15-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210729022053.134453-1-jk@codeconstruct.com.au>
References: <20210729022053.134453-1-jk@codeconstruct.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matt Johnston <matt@codeconstruct.com.au>

Currently we have a compile-time default network
(MCTP_INITIAL_DEFAULT_NET). This change introduces a default_net field
on the net namespace, allowing future configuration for new interfaces.

Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
---
 include/net/mctp.h        |  2 ++
 include/net/netns/mctp.h  |  3 +++
 include/uapi/linux/mctp.h |  1 -
 net/mctp/af_mctp.c        |  3 +++
 net/mctp/device.c         |  2 +-
 net/mctp/route.c          | 14 ++++++++++++++
 6 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/include/net/mctp.h b/include/net/mctp.h
index 0a460ba185b8..54bbe042c973 100644
--- a/include/net/mctp.h
+++ b/include/net/mctp.h
@@ -37,6 +37,8 @@ struct mctp_hdr {
 
 #define MCTP_HEADER_MAXLEN	4
 
+#define MCTP_INITIAL_DEFAULT_NET	1
+
 static inline bool mctp_address_ok(mctp_eid_t eid)
 {
 	return eid >= 8 && eid < 255;
diff --git a/include/net/netns/mctp.h b/include/net/netns/mctp.h
index 14ae6d37e52a..acedef12a35e 100644
--- a/include/net/netns/mctp.h
+++ b/include/net/netns/mctp.h
@@ -25,6 +25,9 @@ struct netns_mctp {
 	spinlock_t keys_lock;
 	struct hlist_head keys;
 
+	/* MCTP network */
+	unsigned int default_net;
+
 	/* neighbour table */
 	struct mutex neigh_lock;
 	struct list_head neighbours;
diff --git a/include/uapi/linux/mctp.h b/include/uapi/linux/mctp.h
index a9d8edb3402b..52b54d13f385 100644
--- a/include/uapi/linux/mctp.h
+++ b/include/uapi/linux/mctp.h
@@ -26,7 +26,6 @@ struct sockaddr_mctp {
 };
 
 #define MCTP_NET_ANY		0x0
-#define MCTP_NET_DEFAULT	0x0
 
 #define MCTP_ADDR_NULL		0x00
 #define MCTP_ADDR_ANY		0xff
diff --git a/net/mctp/af_mctp.c b/net/mctp/af_mctp.c
index 9ca836df19d0..84f722d31fd7 100644
--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -94,6 +94,9 @@ static int mctp_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	if (!capable(CAP_NET_RAW))
 		return -EACCES;
 
+	if (addr->smctp_network == MCTP_NET_ANY)
+		addr->smctp_network = mctp_default_net(sock_net(sk));
+
 	rt = mctp_route_lookup(sock_net(sk), addr->smctp_network,
 			       addr->smctp_addr.s_addr);
 	if (!rt)
diff --git a/net/mctp/device.c b/net/mctp/device.c
index aa049590acda..b9f38e765f61 100644
--- a/net/mctp/device.c
+++ b/net/mctp/device.c
@@ -267,7 +267,7 @@ static struct mctp_dev *mctp_add_dev(struct net_device *dev)
 
 	spin_lock_init(&mdev->addrs_lock);
 
-	mdev->net = MCTP_INITIAL_DEFAULT_NET;
+	mdev->net = mctp_default_net(dev_net(dev));
 
 	/* associate to net_device */
 	rcu_assign_pointer(dev->mctp_ptr, mdev);
diff --git a/net/mctp/route.c b/net/mctp/route.c
index 38f0a7278520..b3101375c8e7 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -433,6 +433,19 @@ static struct mctp_route *mctp_route_alloc(void)
 	return rt;
 }
 
+unsigned int mctp_default_net(struct net *net)
+{
+	return READ_ONCE(net->mctp.default_net);
+}
+
+int mctp_default_net_set(struct net *net, unsigned int index)
+{
+	if (index == 0)
+		return -EINVAL;
+	WRITE_ONCE(net->mctp.default_net, index);
+	return 0;
+}
+
 /* tag management */
 static void mctp_reserve_tag(struct net *net, struct mctp_sk_key *key,
 			     struct mctp_sock *msk)
@@ -1045,6 +1058,7 @@ static int __net_init mctp_routes_net_init(struct net *net)
 	mutex_init(&ns->bind_lock);
 	INIT_HLIST_HEAD(&ns->keys);
 	spin_lock_init(&ns->keys_lock);
+	WARN_ON(mctp_default_net_set(net, MCTP_INITIAL_DEFAULT_NET));
 	return 0;
 }
 
-- 
2.30.2

