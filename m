Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 019914CD93A
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 17:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240670AbiCDQmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 11:42:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiCDQl4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 11:41:56 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6C0C15F611
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 08:41:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646412068; x=1677948068;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BpObjkEYOWpfUHhmJHod3xYbHwzfc95NdhRYb5Ab2FA=;
  b=GZyoqojkZEUWjVE/3X1gp9IbA1cbocUheNdSpvBCONE852DX40PEwAop
   8XgBvGFvRMC8MOkqQzAV8RpXCpJyyvv0BKixxU5Toddm09cxnHNakJmRP
   KhzPLVBa8QWrYDqm4ZAkyiRgaTqByn8ALpWczbzapIym4pSOcF+TGa7Ix
   y1o9+MNvXXOtwegccMCEP0CJd62RgPJRrFN8qYkjoADVKOnwrh2XK2Idn
   l7FyBhQhcpc/81jQrLc3yR0QB4oxTj3vvRIwUCsmY53xoYqpGijofGM3h
   L1BacraZX2Yg9mBozZpoVrfBkQTMaRnKMEXWG7Wu4Qo0LkPuBNWlkbdr1
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="314726427"
X-IronPort-AV: E=Sophos;i="5.90,155,1643702400"; 
   d="scan'208";a="314726427"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 08:41:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,155,1643702400"; 
   d="scan'208";a="511901818"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga006.jf.intel.com with ESMTP; 04 Mar 2022 08:41:04 -0800
Received: from rozewie.igk.intel.com (rozewie.igk.intel.com [10.211.8.69])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 224Gf12H020994;
        Fri, 4 Mar 2022 16:41:02 GMT
From:   Marcin Szycik <marcin.szycik@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     michal.swiatkowski@linux.intel.com, wojciech.drewek@intel.com,
        davem@davemloft.net, kuba@kernel.org, pablo@netfilter.org,
        laforge@gnumonks.org, jiri@resnulli.us,
        osmocom-net-gprs@lists.osmocom.org,
        intel-wired-lan@lists.osuosl.org, xiyou.wangcong@gmail.com,
        jhs@mojatatu.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com
Subject: [PATCH net-next v10 1/7] gtp: Allow to create GTP device without FDs
Date:   Fri,  4 Mar 2022 17:40:42 +0100
Message-Id: <20220304164048.476900-2-marcin.szycik@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220304164048.476900-1-marcin.szycik@linux.intel.com>
References: <20220304164048.476900-1-marcin.szycik@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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

Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
---
v4: Use ntohs when creating UDP socket
v5: IFLA_GTP_CREATE_SOCKETS introduced, gtp_newlink refactor
v6: Reordering refactor removed
---
 drivers/net/gtp.c            | 101 +++++++++++++++++++++++++++++------
 include/uapi/linux/if_link.h |   1 +
 2 files changed, 85 insertions(+), 17 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index bf087171bcf0..25d8521897b3 100644
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
@@ -656,17 +666,69 @@ static void gtp_destructor(struct net_device *dev)
 	kfree(gtp->tid_hash);
 }
 
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
+
 static int gtp_newlink(struct net *src_net, struct net_device *dev,
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
@@ -677,11 +739,23 @@ static int gtp_newlink(struct net *src_net, struct net_device *dev,
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
 
@@ -726,6 +800,7 @@ static const struct nla_policy gtp_policy[IFLA_GTP_MAX + 1] = {
 	[IFLA_GTP_FD1]			= { .type = NLA_U32 },
 	[IFLA_GTP_PDP_HASHSIZE]		= { .type = NLA_U32 },
 	[IFLA_GTP_ROLE]			= { .type = NLA_U32 },
+	[IFLA_GTP_CREATE_SOCKETS]	= { .type = NLA_U8 },
 };
 
 static int gtp_validate(struct nlattr *tb[], struct nlattr *data[],
@@ -848,7 +923,9 @@ static int gtp_encap_enable(struct gtp_dev *gtp, struct nlattr *data[])
 {
 	struct sock *sk1u = NULL;
 	struct sock *sk0 = NULL;
-	unsigned int role = GTP_ROLE_GGSN;
+
+	if (!data[IFLA_GTP_FD0] && !data[IFLA_GTP_FD1])
+		return -EINVAL;
 
 	if (data[IFLA_GTP_FD0]) {
 		u32 fd0 = nla_get_u32(data[IFLA_GTP_FD0]);
@@ -868,18 +945,8 @@ static int gtp_encap_enable(struct gtp_dev *gtp, struct nlattr *data[])
 		}
 	}
 
-	if (data[IFLA_GTP_ROLE]) {
-		role = nla_get_u32(data[IFLA_GTP_ROLE]);
-		if (role > GTP_ROLE_SGSN) {
-			gtp_encap_disable_sock(sk0);
-			gtp_encap_disable_sock(sk1u);
-			return -EINVAL;
-		}
-	}
-
 	gtp->sk0 = sk0;
 	gtp->sk1u = sk1u;
-	gtp->role = role;
 
 	return 0;
 }
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index ddca20357e7e..ebd2aa3ef809 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -887,6 +887,7 @@ enum {
 	IFLA_GTP_FD1,
 	IFLA_GTP_PDP_HASHSIZE,
 	IFLA_GTP_ROLE,
+	IFLA_GTP_CREATE_SOCKETS,
 	__IFLA_GTP_MAX,
 };
 #define IFLA_GTP_MAX (__IFLA_GTP_MAX - 1)
-- 
2.35.1

