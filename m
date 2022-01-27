Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38B1249E2FA
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 14:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241446AbiA0NAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 08:00:24 -0500
Received: from mga06.intel.com ([134.134.136.31]:51976 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241433AbiA0NAX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 08:00:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643288423; x=1674824423;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/el1qt9lc5Co2J+eHPhJkacvEleK1FnA+se1S8lEmhc=;
  b=hh8K54X2octwX2ztChSwy5DeLTfjHfDiW7Kd1CPbsOvn9TYx70vFFzml
   Em5WBDc446C4EHW5dMJ7dJ5w+vT28ZVmEeU7dKQZK2aM565z/OYkhRdie
   kdoFmyx0hQqVZGIe48VqTZF/Xw32TPUeGFvuSVjWOmXNQikkwuIbLZgKM
   1P94838PhnYpdsuLm0zpXn9PCfJK+NQTBksQdy/bcOcg5urOzBEK+Y6+C
   m/EOl5ceT/YPDfFiFiQZjkdgdPF+jN4L+z1e+SWi6bgQhOzezSYe9o+7D
   4M2P1J7Zkm2w+3KDX/q++qkYR8xDHbVCZSQFZ2ye0oxjXUZVKvRHPf30A
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="307553614"
X-IronPort-AV: E=Sophos;i="5.88,320,1635231600"; 
   d="scan'208";a="307553614"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 05:00:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,320,1635231600"; 
   d="scan'208";a="625207553"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga002.fm.intel.com with ESMTP; 27 Jan 2022 05:00:20 -0800
Received: from switcheroo.igk.intel.com (switcheroo.igk.intel.com [172.22.229.137])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 20RD0Jl9020358;
        Thu, 27 Jan 2022 13:00:19 GMT
From:   Marcin Szycik <marcin.szycik@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     michal.swiatkowski@linux.intel.com, wojciech.drewek@intel.com,
        davem@davemloft.net, kuba@kernel.org, pablo@netfilter.org,
        laforge@gnumonks.org, osmocom-net-gprs@lists.osmocom.org
Subject: [RFC PATCH net-next v2 1/5] gtp: Allow to create GTP device without FDs
Date:   Thu, 27 Jan 2022 13:57:25 +0100
Message-Id: <20220127125725.125915-1-marcin.szycik@linux.intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
IFLA_GTP_FD0 and IFLA_GTP_FD1 arguments. If the user does not
provide file handles to the sockets, then GTP module takes care
of creating UDP sockets by itself. Sockets are created with the
commonly known UDP ports used for GTP protocol (GTP0_PORT and
GTP1U_PORT). In this case we don't have to provide encap_destroy
because no extra deinitialization is needed, everything is covered
by udp_tunnel_sock_release.

Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
---
 drivers/net/gtp.c | 74 ++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 67 insertions(+), 7 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 24e5c54d06c1..a2ad0af913cb 100644
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
@@ -664,9 +674,6 @@ static int gtp_newlink(struct net *src_net, struct net_device *dev,
 	struct gtp_net *gn;
 	int hashsize, err;
 
-	if (!data[IFLA_GTP_FD0] && !data[IFLA_GTP_FD1])
-		return -EINVAL;
-
 	gtp = netdev_priv(dev);
 
 	if (!data[IFLA_GTP_PDP_HASHSIZE]) {
@@ -677,6 +684,8 @@ static int gtp_newlink(struct net *src_net, struct net_device *dev,
 			hashsize = 1024;
 	}
 
+	gtp->net = src_net;
+
 	err = gtp_hashtable_new(gtp, hashsize);
 	if (err < 0)
 		return err;
@@ -844,6 +853,38 @@ static struct sock *gtp_encap_enable_socket(int fd, int type,
 	return sk;
 }
 
+static struct sock *gtp_encap_create_sock(int type, struct gtp_dev *gtp)
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
+		udp_conf.local_udp_port = GTP0_PORT;
+	else if (type == UDP_ENCAP_GTP1U)
+		udp_conf.local_udp_port = GTP1U_PORT;
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
 static int gtp_encap_enable(struct gtp_dev *gtp, struct nlattr *data[])
 {
 	struct sock *sk1u = NULL;
@@ -868,11 +909,30 @@ static int gtp_encap_enable(struct gtp_dev *gtp, struct nlattr *data[])
 		}
 	}
 
+	if (!data[IFLA_GTP_FD0] && !data[IFLA_GTP_FD1]) {
+		sk0 = gtp_encap_create_sock(UDP_ENCAP_GTP0, gtp);
+		if (IS_ERR(sk0))
+			return PTR_ERR(sk0);
+
+		sk1u = gtp_encap_create_sock(UDP_ENCAP_GTP1U, gtp);
+		if (IS_ERR(sk1u)) {
+			udp_tunnel_sock_release(sk0->sk_socket);
+			return PTR_ERR(sk1u);
+		}
+		gtp->sk_created = true;
+	}
+
 	if (data[IFLA_GTP_ROLE]) {
 		role = nla_get_u32(data[IFLA_GTP_ROLE]);
 		if (role > GTP_ROLE_SGSN) {
-			gtp_encap_disable_sock(sk0);
-			gtp_encap_disable_sock(sk1u);
+			if (gtp->sk_created) {
+				udp_tunnel_sock_release(sk0->sk_socket);
+				udp_tunnel_sock_release(sk1u->sk_socket);
+				gtp->sk_created = false;
+			} else {
+				gtp_encap_disable_sock(sk0);
+				gtp_encap_disable_sock(sk1u);
+			}
 			return -EINVAL;
 		}
 	}
-- 
2.31.1

