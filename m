Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4579628C942
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 09:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390152AbgJMH2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 03:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390091AbgJMH2T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 03:28:19 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45AA2C0613D0;
        Tue, 13 Oct 2020 00:28:19 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id h2so10190454pll.11;
        Tue, 13 Oct 2020 00:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=HG2RLk7bAh83YS4C2UPIzbvNav0ygPjqVjP+XYPnGa8=;
        b=jQvPWsmuJsXj0PSkBdKwoBtmaHFB5GPLXXL/hVb2QA2GA3Q9q2FpIKs0HJBQPTGWeR
         f+lnHvdpZh4L7HKHB+YWVq3cwxuirxPag1t91rh5F0o+/eVnrwV7gokKKaDUI11GobBU
         7SImRjeuPtsalRxwpEEylhX/M3wIlIwhbgmOL39Q5Tro81k2ZGnxfNoqXFlTvMNUk0/S
         88OMVF1PztUwjiR+bWASDyogTQVnu+GCcE8mNGHypZmrWJPX87qRAP+lOBZJDPvRl35d
         URWSi6qIxiCvazqnjjHoKERN8xzUjO20bl36flEJI/7VJrr2zog7M1eXnXKmxiCjRk6k
         eVuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=HG2RLk7bAh83YS4C2UPIzbvNav0ygPjqVjP+XYPnGa8=;
        b=acw7WmpNhi+8sygu8D6YizoN1hkWfUx6LEh3/eke2kRIVO5LxQprJZt5OlS1n8aDUN
         NcvMdHVc49EO1raN6IEjgaU2EBfQHxcNKS8bYkmTMYAfLQ5L4h7JTD0nhXT84S87o8Tj
         +ea2tXzzNjwUoj211CUbO8H64Wwz8OdO0dMFgJ/mrehnQ/kX6PnX4A8rQRROszOd6Cr7
         CgSHk554T4ec5f41+Sj9pTR3M1LiROO53661GOg/DciYuy12pWouPjQjTaJEv5ZlvM8S
         p4ZDmXilXdcbr3s0Ne/wjsD/LReGCvPKjieYP7O0wKV/2LnaJd+zbGy+D/HV46KgFX4y
         Nwjg==
X-Gm-Message-State: AOAM530zcggZ1amU02wnrtSfRTTDhr0aNmGrhRip43COfAmn5J7HIHDm
        S/ok/KAy3RVBU7TmBqXEOhWDUniGD3w=
X-Google-Smtp-Source: ABdhPJxB0J7iRqSObFz9JgUX8MLk45HC91/In/Tx8LpOqXITu7nYjF/Gvy5cYu62JufIj8DZptQQNQ==
X-Received: by 2002:a17:90a:f0c6:: with SMTP id fa6mr22667670pjb.12.1602574098479;
        Tue, 13 Oct 2020 00:28:18 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t3sm21270975pgm.42.2020.10.13.00.28.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Oct 2020 00:28:17 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        gnault@redhat.com, pabeni@redhat.com,
        willemdebruijn.kernel@gmail.com
Subject: [PATCHv3 net-next 04/16] sctp: create udp4 sock and add its encap_rcv
Date:   Tue, 13 Oct 2020 15:27:29 +0800
Message-Id: <7159fb58f44f9ff00ca5b3b8a26ee3aa2fd1bf8a.1602574012.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <dbad21ff524e119f83ae4444d1ae393ab165fa7c.1602574012.git.lucien.xin@gmail.com>
References: <cover.1602574012.git.lucien.xin@gmail.com>
 <fae9c57767447c4fd97476807b9e029e8fda607a.1602574012.git.lucien.xin@gmail.com>
 <c01a9a09096cb1b292d461aa5a1e72aae2ca942a.1602574012.git.lucien.xin@gmail.com>
 <dbad21ff524e119f83ae4444d1ae393ab165fa7c.1602574012.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1602574012.git.lucien.xin@gmail.com>
References: <cover.1602574012.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to add the functions to create/release udp4 sock,
and set the sock's encap_rcv to process the incoming udp encap
sctp packets. In sctp_udp_rcv(), as we can see, all we need to
do is fix the transport header for sctp_rcv(), then it would
implement the part of rfc6951#section-5.4:

  "When an encapsulated packet is received, the UDP header is removed.
   Then, the generic lookup is performed, as done by an SCTP stack
   whenever a packet is received, to find the association for the
   received SCTP packet"

Note that these functions will be called in the last patch of
this patchset when enabling this feature.

v1->v2:
  - Add pr_err() when fails to create udp v4 sock.
v2->v3:
  - Add 'select NET_UDP_TUNNEL' in sctp Kconfig.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/netns/sctp.h     |  5 +++++
 include/net/sctp/constants.h |  2 ++
 include/net/sctp/sctp.h      |  2 ++
 net/sctp/Kconfig             |  1 +
 net/sctp/protocol.c          | 43 +++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 53 insertions(+)

diff --git a/include/net/netns/sctp.h b/include/net/netns/sctp.h
index d8d02e4..3d10bef 100644
--- a/include/net/netns/sctp.h
+++ b/include/net/netns/sctp.h
@@ -22,6 +22,11 @@ struct netns_sctp {
 	 */
 	struct sock *ctl_sock;
 
+	/* udp tunneling listening sock. */
+	struct sock *udp4_sock;
+	/* udp tunneling listening port. */
+	int udp_port;
+
 	/* This is the global local address list.
 	 * We actively maintain this complete list of addresses on
 	 * the system by catching address add/delete events.
diff --git a/include/net/sctp/constants.h b/include/net/sctp/constants.h
index 122d9e2..b583166 100644
--- a/include/net/sctp/constants.h
+++ b/include/net/sctp/constants.h
@@ -286,6 +286,8 @@ enum { SCTP_MAX_GABS = 16 };
 				 * functions simpler to write.
 				 */
 
+#define SCTP_DEFAULT_UDP_PORT 9899	/* default udp tunneling port */
+
 /* These are the values for pf exposure, UNUSED is to keep compatible with old
  * applications by default.
  */
diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index 4fc747b..bfd87a0 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -84,6 +84,8 @@ int sctp_copy_local_addr_list(struct net *net, struct sctp_bind_addr *addr,
 struct sctp_pf *sctp_get_pf_specific(sa_family_t family);
 int sctp_register_pf(struct sctp_pf *, sa_family_t);
 void sctp_addr_wq_mgmt(struct net *, struct sctp_sockaddr_entry *, int);
+int sctp_udp_sock_start(struct net *net);
+void sctp_udp_sock_stop(struct net *net);
 
 /*
  * sctp/socket.c
diff --git a/net/sctp/Kconfig b/net/sctp/Kconfig
index 39d7fa9..5da599f 100644
--- a/net/sctp/Kconfig
+++ b/net/sctp/Kconfig
@@ -11,6 +11,7 @@ menuconfig IP_SCTP
 	select CRYPTO_HMAC
 	select CRYPTO_SHA1
 	select LIBCRC32C
+	select NET_UDP_TUNNEL
 	help
 	  Stream Control Transmission Protocol
 
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 2583323..2b7a3e1 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -44,6 +44,7 @@
 #include <net/addrconf.h>
 #include <net/inet_common.h>
 #include <net/inet_ecn.h>
+#include <net/udp_tunnel.h>
 
 #define MAX_SCTP_PORT_HASH_ENTRIES (64 * 1024)
 
@@ -840,6 +841,45 @@ static int sctp_ctl_sock_init(struct net *net)
 	return 0;
 }
 
+static int sctp_udp_rcv(struct sock *sk, struct sk_buff *skb)
+{
+	skb_set_transport_header(skb, sizeof(struct udphdr));
+	sctp_rcv(skb);
+	return 0;
+}
+
+int sctp_udp_sock_start(struct net *net)
+{
+	struct udp_tunnel_sock_cfg tuncfg = {NULL};
+	struct udp_port_cfg udp_conf = {0};
+	struct socket *sock;
+	int err;
+
+	udp_conf.family = AF_INET;
+	udp_conf.local_ip.s_addr = htonl(INADDR_ANY);
+	udp_conf.local_udp_port = htons(net->sctp.udp_port);
+	err = udp_sock_create(net, &udp_conf, &sock);
+	if (err) {
+		pr_err("Failed to create the SCTP udp tunneling v4 sock\n");
+		return err;
+	}
+
+	tuncfg.encap_type = 1;
+	tuncfg.encap_rcv = sctp_udp_rcv;
+	setup_udp_tunnel_sock(net, sock, &tuncfg);
+	net->sctp.udp4_sock = sock->sk;
+
+	return 0;
+}
+
+void sctp_udp_sock_stop(struct net *net)
+{
+	if (net->sctp.udp4_sock) {
+		udp_tunnel_sock_release(net->sctp.udp4_sock->sk_socket);
+		net->sctp.udp4_sock = NULL;
+	}
+}
+
 /* Register address family specific functions. */
 int sctp_register_af(struct sctp_af *af)
 {
@@ -1271,6 +1311,9 @@ static int __net_init sctp_defaults_init(struct net *net)
 	/* Enable ECN by default. */
 	net->sctp.ecn_enable = 1;
 
+	/* Set udp tunneling listening port to default value */
+	net->sctp.udp_port = SCTP_DEFAULT_UDP_PORT;
+
 	/* Set SCOPE policy to enabled */
 	net->sctp.scope_policy = SCTP_SCOPE_POLICY_ENABLE;
 
-- 
2.1.0

