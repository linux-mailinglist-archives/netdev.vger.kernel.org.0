Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB33C4B2C40
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 19:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352385AbiBKR6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 12:58:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352375AbiBKR6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 12:58:19 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB6E92C9
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 09:58:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644602297; x=1676138297;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UmmtxBglVq6ahQ5bT+aIj/w3lzTTCs4uBlcnTwh+KmI=;
  b=I+ftGINV7BgqBnEB4D3JhKrR/ob25HwuV3TkrpJiZ5tR3YZFCyMUkvXS
   nbD1qsoE9zqYzTRfBGyA53+a7Jc3PYg9RzbjQ1qIkez2hUSOO/q/8m7fJ
   5MnMRyHTsyJD0xPm5CPewviw5n9UO9wrUBNhb20zioPqOf657Jg+yHc1r
   vrG9+ojZzAvgYXLGLn0AaJvn10nXw1jkuHxES2F+tcL+yxqmP9Zv8pDsB
   cKAgE5cgPI44aAgSis9KVbe6XKeXPFC1anA8jNVSnS7cVS78DvrM0rRLl
   T579+8fIs0nZgNllSjtDbc55e3SSmhAsvQBn468CFUZQnyN1DVEVwsTif
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10255"; a="247369641"
X-IronPort-AV: E=Sophos;i="5.88,361,1635231600"; 
   d="scan'208";a="247369641"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2022 09:58:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,361,1635231600"; 
   d="scan'208";a="537709622"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga007.fm.intel.com with ESMTP; 11 Feb 2022 09:58:15 -0800
Received: from switcheroo.igk.intel.com (switcheroo.igk.intel.com [172.22.229.137])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 21BHwEPE017238;
        Fri, 11 Feb 2022 17:58:14 GMT
From:   Marcin Szycik <marcin.szycik@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     michal.swiatkowski@linux.intel.com, wojciech.drewek@intel.com,
        davem@davemloft.net, kuba@kernel.org, pablo@netfilter.org,
        laforge@gnumonks.org, osmocom-net-gprs@lists.osmocom.org
Subject: [RFC PATCH net-next v5 1/6] gtp: Allow to create GTP device without FDs
Date:   Fri, 11 Feb 2022 18:55:00 +0100
Message-Id: <20220211175500.7805-1-marcin.szycik@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220211175405.7651-1-marcin.szycik@linux.intel.com>
References: <20220211175405.7651-1-marcin.szycik@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wojciech Drewek <wojciech.drewek@intel.com>

Currently, when the user wants to create GTP device, he has to
provide file handles to the sockets created in userspace (IFLA_GTP_FD0,
IFLA_GTP_FD1). This behaviour is not ideal, considering the option of
adding support for GTP device creation through ip link. Ip link
application is not a good place to create such sockets.

This patch allows to create GTP device without providing
IFLA_GTP_FD0 and IFLA_GTP_FD1 arguments. If the user sets
IFLA_GTP_CREATE_SOCKETS attribute, then GTP module takes care
of creating UDP sockets by itself. Sockets are created with the
commonly known UDP ports used for GTP protocol (GTP0_PORT and
GTP1U_PORT). In this case we don't have to provide encap_destroy
because no extra deinitialization is needed, everything is covered
by udp_tunnel_sock_release.

Note: GTP instance created with only this change applied, does
not handle GTP Echo Requests. This is implemented in the following
patch.

Besides that, small refactor was done, functions used in gtp_newlink
were moved above it. Handling of IFLA_GTP_ROLE attribute was moved
to gtp_newlink.

Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
---
v4: use ntohs when creating UDP socket
v5: IFLA_GTP_CREATE_SOCKETS introduced, gtp_newlink refactor
---
 drivers/net/gtp.c            | 306 +++++++++++++++++++++--------------
 include/uapi/linux/if_link.h |   1 +
 2 files changed, 186 insertions(+), 121 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 24e5c54d06c1..29978c5e37e8 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -66,8 +66,10 @@ struct gtp_dev {
 
 	struct sock		*sk0;
 	struct sock		*sk1u;
+	u8			sk_created;
 
 	struct net_device	*dev;
+	struct net		*net;
 
 	unsigned int		role;
 	unsigned int		hash_size;
@@ -320,8 +322,16 @@ static void gtp_encap_disable_sock(struct sock *sk)
 
 static void gtp_encap_disable(struct gtp_dev *gtp)
 {
-	gtp_encap_disable_sock(gtp->sk0);
-	gtp_encap_disable_sock(gtp->sk1u);
+	if (gtp->sk_created) {
+		udp_tunnel_sock_release(gtp->sk0->sk_socket);
+		udp_tunnel_sock_release(gtp->sk1u->sk_socket);
+		gtp->sk_created = false;
+		gtp->sk0 = NULL;
+		gtp->sk1u = NULL;
+	} else {
+		gtp_encap_disable_sock(gtp->sk0);
+		gtp_encap_disable_sock(gtp->sk1u);
+	}
 }
 
 /* UDP encapsulation receive handler. See net/ipv4/udp.c.
@@ -645,8 +655,164 @@ static void gtp_link_setup(struct net_device *dev)
 	dev->needed_headroom	= LL_MAX_HEADER + max_gtp_header_len;
 }
 
-static int gtp_hashtable_new(struct gtp_dev *gtp, int hsize);
-static int gtp_encap_enable(struct gtp_dev *gtp, struct nlattr *data[]);
+static int gtp_hashtable_new(struct gtp_dev *gtp, int hsize)
+{
+	int i;
+
+	gtp->addr_hash = kmalloc_array(hsize, sizeof(struct hlist_head),
+				       GFP_KERNEL | __GFP_NOWARN);
+	if (gtp->addr_hash == NULL)
+		return -ENOMEM;
+
+	gtp->tid_hash = kmalloc_array(hsize, sizeof(struct hlist_head),
+				      GFP_KERNEL | __GFP_NOWARN);
+	if (gtp->tid_hash == NULL)
+		goto err1;
+
+	gtp->hash_size = hsize;
+
+	for (i = 0; i < hsize; i++) {
+		INIT_HLIST_HEAD(&gtp->addr_hash[i]);
+		INIT_HLIST_HEAD(&gtp->tid_hash[i]);
+	}
+	return 0;
+err1:
+	kfree(gtp->addr_hash);
+	return -ENOMEM;
+}
+
+static struct sock *gtp_encap_enable_socket(int fd, int type,
+					    struct gtp_dev *gtp)
+{
+	struct udp_tunnel_sock_cfg tuncfg = {NULL};
+	struct socket *sock;
+	struct sock *sk;
+	int err;
+
+	pr_debug("enable gtp on %d, %d\n", fd, type);
+
+	sock = sockfd_lookup(fd, &err);
+	if (!sock) {
+		pr_debug("gtp socket fd=%d not found\n", fd);
+		return NULL;
+	}
+
+	sk = sock->sk;
+	if (sk->sk_protocol != IPPROTO_UDP ||
+	    sk->sk_type != SOCK_DGRAM ||
+	    (sk->sk_family != AF_INET && sk->sk_family != AF_INET6)) {
+		pr_debug("socket fd=%d not UDP\n", fd);
+		sk = ERR_PTR(-EINVAL);
+		goto out_sock;
+	}
+
+	lock_sock(sk);
+	if (sk->sk_user_data) {
+		sk = ERR_PTR(-EBUSY);
+		goto out_rel_sock;
+	}
+
+	sock_hold(sk);
+
+	tuncfg.sk_user_data = gtp;
+	tuncfg.encap_type = type;
+	tuncfg.encap_rcv = gtp_encap_recv;
+	tuncfg.encap_destroy = gtp_encap_destroy;
+
+	setup_udp_tunnel_sock(sock_net(sock->sk), sock, &tuncfg);
+
+out_rel_sock:
+	release_sock(sock->sk);
+out_sock:
+	sockfd_put(sock);
+	return sk;
+}
+
+static int gtp_encap_enable(struct gtp_dev *gtp, struct nlattr *data[])
+{
+	struct sock *sk1u = NULL;
+	struct sock *sk0 = NULL;
+
+	if (!data[IFLA_GTP_FD0] && !data[IFLA_GTP_FD1])
+		return -EINVAL;
+
+	if (data[IFLA_GTP_FD0]) {
+		u32 fd0 = nla_get_u32(data[IFLA_GTP_FD0]);
+
+		sk0 = gtp_encap_enable_socket(fd0, UDP_ENCAP_GTP0, gtp);
+		if (IS_ERR(sk0))
+			return PTR_ERR(sk0);
+	}
+
+	if (data[IFLA_GTP_FD1]) {
+		u32 fd1 = nla_get_u32(data[IFLA_GTP_FD1]);
+
+		sk1u = gtp_encap_enable_socket(fd1, UDP_ENCAP_GTP1U, gtp);
+		if (IS_ERR(sk1u)) {
+			gtp_encap_disable_sock(sk0);
+			return PTR_ERR(sk1u);
+		}
+	}
+
+	gtp->sk0 = sk0;
+	gtp->sk1u = sk1u;
+
+	return 0;
+}
+
+static struct sock *gtp_create_sock(int type, struct gtp_dev *gtp)
+{
+	struct udp_tunnel_sock_cfg tuncfg = {};
+	struct udp_port_cfg udp_conf = {
+		.local_ip.s_addr	= htonl(INADDR_ANY),
+		.family			= AF_INET,
+	};
+	struct net *net = gtp->net;
+	struct socket *sock;
+	int err;
+
+	if (type == UDP_ENCAP_GTP0)
+		udp_conf.local_udp_port = htons(GTP0_PORT);
+	else if (type == UDP_ENCAP_GTP1U)
+		udp_conf.local_udp_port = htons(GTP1U_PORT);
+	else
+		return ERR_PTR(-EINVAL);
+
+	err = udp_sock_create(net, &udp_conf, &sock);
+	if (err)
+		return ERR_PTR(err);
+
+	tuncfg.sk_user_data = gtp;
+	tuncfg.encap_type = type;
+	tuncfg.encap_rcv = gtp_encap_recv;
+	tuncfg.encap_destroy = NULL;
+
+	setup_udp_tunnel_sock(net, sock, &tuncfg);
+
+	return sock->sk;
+}
+
+static int gtp_create_sockets(struct gtp_dev *gtp, struct nlattr *data[])
+{
+	struct sock *sk1u = NULL;
+	struct sock *sk0 = NULL;
+
+	sk0 = gtp_create_sock(UDP_ENCAP_GTP0, gtp);
+	if (IS_ERR(sk0))
+		return PTR_ERR(sk0);
+
+	sk1u = gtp_create_sock(UDP_ENCAP_GTP1U, gtp);
+	if (IS_ERR(sk1u)) {
+		udp_tunnel_sock_release(sk0->sk_socket);
+		return PTR_ERR(sk1u);
+	}
+
+	gtp->sk_created = true;
+	gtp->sk0 = sk0;
+	gtp->sk1u = sk1u;
+
+	return 0;
+}
 
 static void gtp_destructor(struct net_device *dev)
 {
@@ -660,13 +826,11 @@ static int gtp_newlink(struct net *src_net, struct net_device *dev,
 		       struct nlattr *tb[], struct nlattr *data[],
 		       struct netlink_ext_ack *extack)
 {
+	unsigned int role = GTP_ROLE_GGSN;
 	struct gtp_dev *gtp;
 	struct gtp_net *gn;
 	int hashsize, err;
 
-	if (!data[IFLA_GTP_FD0] && !data[IFLA_GTP_FD1])
-		return -EINVAL;
-
 	gtp = netdev_priv(dev);
 
 	if (!data[IFLA_GTP_PDP_HASHSIZE]) {
@@ -677,11 +841,23 @@ static int gtp_newlink(struct net *src_net, struct net_device *dev,
 			hashsize = 1024;
 	}
 
+	if (data[IFLA_GTP_ROLE]) {
+		role = nla_get_u32(data[IFLA_GTP_ROLE]);
+		if (role > GTP_ROLE_SGSN)
+			return -EINVAL;
+	}
+	gtp->role = role;
+
+	gtp->net = src_net;
+
 	err = gtp_hashtable_new(gtp, hashsize);
 	if (err < 0)
 		return err;
 
-	err = gtp_encap_enable(gtp, data);
+	if (data[IFLA_GTP_CREATE_SOCKETS])
+		err = gtp_create_sockets(gtp, data);
+	else
+		err = gtp_encap_enable(gtp, data);
 	if (err < 0)
 		goto out_hashtable;
 
@@ -726,6 +902,7 @@ static const struct nla_policy gtp_policy[IFLA_GTP_MAX + 1] = {
 	[IFLA_GTP_FD1]			= { .type = NLA_U32 },
 	[IFLA_GTP_PDP_HASHSIZE]		= { .type = NLA_U32 },
 	[IFLA_GTP_ROLE]			= { .type = NLA_U32 },
+	[IFLA_GTP_CREATE_SOCKETS]	= { .type = NLA_U8 },
 };
 
 static int gtp_validate(struct nlattr *tb[], struct nlattr *data[],
@@ -771,119 +948,6 @@ static struct rtnl_link_ops gtp_link_ops __read_mostly = {
 	.fill_info	= gtp_fill_info,
 };
 
-static int gtp_hashtable_new(struct gtp_dev *gtp, int hsize)
-{
-	int i;
-
-	gtp->addr_hash = kmalloc_array(hsize, sizeof(struct hlist_head),
-				       GFP_KERNEL | __GFP_NOWARN);
-	if (gtp->addr_hash == NULL)
-		return -ENOMEM;
-
-	gtp->tid_hash = kmalloc_array(hsize, sizeof(struct hlist_head),
-				      GFP_KERNEL | __GFP_NOWARN);
-	if (gtp->tid_hash == NULL)
-		goto err1;
-
-	gtp->hash_size = hsize;
-
-	for (i = 0; i < hsize; i++) {
-		INIT_HLIST_HEAD(&gtp->addr_hash[i]);
-		INIT_HLIST_HEAD(&gtp->tid_hash[i]);
-	}
-	return 0;
-err1:
-	kfree(gtp->addr_hash);
-	return -ENOMEM;
-}
-
-static struct sock *gtp_encap_enable_socket(int fd, int type,
-					    struct gtp_dev *gtp)
-{
-	struct udp_tunnel_sock_cfg tuncfg = {NULL};
-	struct socket *sock;
-	struct sock *sk;
-	int err;
-
-	pr_debug("enable gtp on %d, %d\n", fd, type);
-
-	sock = sockfd_lookup(fd, &err);
-	if (!sock) {
-		pr_debug("gtp socket fd=%d not found\n", fd);
-		return NULL;
-	}
-
-	sk = sock->sk;
-	if (sk->sk_protocol != IPPROTO_UDP ||
-	    sk->sk_type != SOCK_DGRAM ||
-	    (sk->sk_family != AF_INET && sk->sk_family != AF_INET6)) {
-		pr_debug("socket fd=%d not UDP\n", fd);
-		sk = ERR_PTR(-EINVAL);
-		goto out_sock;
-	}
-
-	lock_sock(sk);
-	if (sk->sk_user_data) {
-		sk = ERR_PTR(-EBUSY);
-		goto out_rel_sock;
-	}
-
-	sock_hold(sk);
-
-	tuncfg.sk_user_data = gtp;
-	tuncfg.encap_type = type;
-	tuncfg.encap_rcv = gtp_encap_recv;
-	tuncfg.encap_destroy = gtp_encap_destroy;
-
-	setup_udp_tunnel_sock(sock_net(sock->sk), sock, &tuncfg);
-
-out_rel_sock:
-	release_sock(sock->sk);
-out_sock:
-	sockfd_put(sock);
-	return sk;
-}
-
-static int gtp_encap_enable(struct gtp_dev *gtp, struct nlattr *data[])
-{
-	struct sock *sk1u = NULL;
-	struct sock *sk0 = NULL;
-	unsigned int role = GTP_ROLE_GGSN;
-
-	if (data[IFLA_GTP_FD0]) {
-		u32 fd0 = nla_get_u32(data[IFLA_GTP_FD0]);
-
-		sk0 = gtp_encap_enable_socket(fd0, UDP_ENCAP_GTP0, gtp);
-		if (IS_ERR(sk0))
-			return PTR_ERR(sk0);
-	}
-
-	if (data[IFLA_GTP_FD1]) {
-		u32 fd1 = nla_get_u32(data[IFLA_GTP_FD1]);
-
-		sk1u = gtp_encap_enable_socket(fd1, UDP_ENCAP_GTP1U, gtp);
-		if (IS_ERR(sk1u)) {
-			gtp_encap_disable_sock(sk0);
-			return PTR_ERR(sk1u);
-		}
-	}
-
-	if (data[IFLA_GTP_ROLE]) {
-		role = nla_get_u32(data[IFLA_GTP_ROLE]);
-		if (role > GTP_ROLE_SGSN) {
-			gtp_encap_disable_sock(sk0);
-			gtp_encap_disable_sock(sk1u);
-			return -EINVAL;
-		}
-	}
-
-	gtp->sk0 = sk0;
-	gtp->sk1u = sk1u;
-	gtp->role = role;
-
-	return 0;
-}
-
 static struct gtp_dev *gtp_find_dev(struct net *src_net, struct nlattr *nla[])
 {
 	struct gtp_dev *gtp = NULL;
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 6218f93f5c1a..42f3fb097271 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -822,6 +822,7 @@ enum {
 	IFLA_GTP_FD1,
 	IFLA_GTP_PDP_HASHSIZE,
 	IFLA_GTP_ROLE,
+	IFLA_GTP_CREATE_SOCKETS,
 	__IFLA_GTP_MAX,
 };
 #define IFLA_GTP_MAX (__IFLA_GTP_MAX - 1)
-- 
2.31.1

