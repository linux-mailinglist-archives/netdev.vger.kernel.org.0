Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 153884A9D28
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 17:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376664AbiBDQx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 11:53:59 -0500
Received: from mga12.intel.com ([192.55.52.136]:1654 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233477AbiBDQx7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Feb 2022 11:53:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643993639; x=1675529639;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=25owBOloXIce/xpHBOuKPNsEf8I1V2XIse0r26HNT8o=;
  b=O5zYDYfmdKCW1U1An2RdeaCa6dE7TU6rrcyVgaGIF4OcaZQswoRNPxrr
   SAgvH8JAH0syxFjsZoGEQkr0x1gNQC1k6XC+08HdFdrts8lQfN2xhIxYR
   VnmvMaj3nSp51pTeh04J9Jei/34l5VOUrjjCzOLlXit/FqkYdonaPCW3R
   TSxXuy1XnXE5dIF/lJMBSoxQRKQUnXHcwJqZbD2N4n5LB+E8wLBz3X4lX
   GggrA+7/2iHpoeHbcXR5811pVxmrefZdR55cWzwIDC02LUG6vewIGt8Kb
   mXsHXwa4yiSqxWCjHNlvaoealtuKFYvxWwhDfVOtGQdooskspN31HqGeS
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10247"; a="228371444"
X-IronPort-AV: E=Sophos;i="5.88,343,1635231600"; 
   d="scan'208";a="228371444"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2022 08:53:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,343,1635231600"; 
   d="scan'208";a="770001698"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga006.fm.intel.com with ESMTP; 04 Feb 2022 08:53:57 -0800
Received: from switcheroo.igk.intel.com (switcheroo.igk.intel.com [172.22.229.137])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 214Gruoc026625;
        Fri, 4 Feb 2022 16:53:56 GMT
From:   Marcin Szycik <marcin.szycik@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     michal.swiatkowski@linux.intel.com, wojciech.drewek@intel.com,
        davem@davemloft.net, kuba@kernel.org, pablo@netfilter.org,
        laforge@gnumonks.org, osmocom-net-gprs@lists.osmocom.org
Subject: [RFC PATCH net-next v4 1/6] gtp: Allow to create GTP device without FDs
Date:   Fri,  4 Feb 2022 17:50:45 +0100
Message-Id: <20220204165045.10518-1-marcin.szycik@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220204164929.10356-1-marcin.szycik@linux.intel.com>
References: <20220204164929.10356-1-marcin.szycik@linux.intel.com>
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
v4: use ntohs when creating UDP socket
---
 drivers/net/gtp.c | 74 ++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 67 insertions(+), 7 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 24e5c54d06c1..6fa1cfe023ef 100644
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
+		udp_conf.local_udp_port = ntohs(GTP0_PORT);
+	else if (type == UDP_ENCAP_GTP1U)
+		udp_conf.local_udp_port = ntohs(GTP1U_PORT);
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

