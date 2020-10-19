Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECC1F292738
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 14:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbgJSM0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 08:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726249AbgJSM0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 08:26:11 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 583D8C0613CE;
        Mon, 19 Oct 2020 05:26:11 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d23so4895884pll.7;
        Mon, 19 Oct 2020 05:26:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=225QBlNOQv1I2VE0xISPJH7qhCAG1god2efxpwkOjzc=;
        b=VevDRD/9uGfLa4oNfbM25r6zXD9DgQ7i05pO1kYI4LKIzEUvlk1r36U4WtLA1bbfFI
         M0C1xC0Wb3SNXthWhIybofBlNDJQHxYHg1OArbw0Dl2Cb38d8TwDsQEVXXyO/l7TiS7M
         e4jy0thgrxwrVEWIVV4Pl4rwA/4IqtJLSD/mTaJRZhpRUobu5fDyrrmd6uvm10NRQf4l
         V2g31tm9MR4oxq2+BCE/d7qN8Bidk63HPxqfpUGYz9Qkzf0fjmqFh/g8P2TvpnxAZLUa
         QPmvd5hTmxkeV+GLk9jf6Em1Hzr2SX3hWuszOrkXUsNp3OE/S2ugExYwG8dOoXTlq1bO
         6Yfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=225QBlNOQv1I2VE0xISPJH7qhCAG1god2efxpwkOjzc=;
        b=oSMmjbZcfHZKm25p3Qkyqoc4k01tt8jgAjU4hfLtctOoMhfu1P1qdMItKSLfRI8KeQ
         lVLMOD9n8BgrSnmAYW9hrAP2cJrED1NMjo/hdK5LMHUNV83oBlkUSDofGAPgBOa7uYHq
         8ZM9YJa148i2F26TfuIGcVKH+3eJESovCaih3sjvDlvGTdCWF0Q72t71CQG3yTut4S2O
         NJ/mwBfCm7uEfSCscFRrAeDG7v4EtOs6yw2f9fHq/sJnza2uPP88+dbjTPEFbeGlE8oJ
         PwFyiKXfcckwUzrjydTb4Fm9aCv6P5/Vs39CljsExh0GeFHhpAELP0k7G7ERkq6VfeXF
         N8ig==
X-Gm-Message-State: AOAM5306jAQXycHN7kyuo0iooZUJ0g5dhd42mmf6n0TZtQgC2IzypmVg
        p6crlTZBPsAMJJMX9A905SJHy0f2GqI=
X-Google-Smtp-Source: ABdhPJyT27MG6t8vjwoq4OkQYC/6Uu8fC+GfRUX+C7bSf98oo3/AslnMXguL9VdSVGz1100p+LndPw==
X-Received: by 2002:a17:902:9347:b029:d3:7c08:86c6 with SMTP id g7-20020a1709029347b02900d37c0886c6mr16090772plp.84.1603110370557;
        Mon, 19 Oct 2020 05:26:10 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q24sm13667142pfn.72.2020.10.19.05.26.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Oct 2020 05:26:10 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        gnault@redhat.com, pabeni@redhat.com,
        willemdebruijn.kernel@gmail.com
Subject: [PATCHv4 net-next 04/16] sctp: create udp4 sock and add its encap_rcv
Date:   Mon, 19 Oct 2020 20:25:21 +0800
Message-Id: <e99845af51be8fdaa53a2575e8967b8c3c8d423a.1603110316.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <5f06ac649f4b63fc5a254812a963cada3183f136.1603110316.git.lucien.xin@gmail.com>
References: <cover.1603110316.git.lucien.xin@gmail.com>
 <71b3af0fb347f27b5c3bf846dbd34485d9f80af0.1603110316.git.lucien.xin@gmail.com>
 <de3a89ece8f3abd0dca08064d9fc4d36ca7ddba2.1603110316.git.lucien.xin@gmail.com>
 <5f06ac649f4b63fc5a254812a963cada3183f136.1603110316.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1603110316.git.lucien.xin@gmail.com>
References: <cover.1603110316.git.lucien.xin@gmail.com>
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
index d8d02e4..8cc9aff 100644
--- a/include/net/netns/sctp.h
+++ b/include/net/netns/sctp.h
@@ -22,6 +22,11 @@ struct netns_sctp {
 	 */
 	struct sock *ctl_sock;
 
+	/* UDP tunneling listening sock. */
+	struct sock *udp4_sock;
+	/* UDP tunneling listening port. */
+	int udp_port;
+
 	/* This is the global local address list.
 	 * We actively maintain this complete list of addresses on
 	 * the system by catching address add/delete events.
diff --git a/include/net/sctp/constants.h b/include/net/sctp/constants.h
index 122d9e2..14a0d22 100644
--- a/include/net/sctp/constants.h
+++ b/include/net/sctp/constants.h
@@ -286,6 +286,8 @@ enum { SCTP_MAX_GABS = 16 };
 				 * functions simpler to write.
 				 */
 
+#define SCTP_DEFAULT_UDP_PORT 9899	/* default UDP tunneling port */
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
index 2583323..6fb03fc 100644
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
+		pr_err("Failed to create the SCTP UDP tunneling v4 sock\n");
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
 
+	/* Set UDP tunneling listening port to default value */
+	net->sctp.udp_port = SCTP_DEFAULT_UDP_PORT;
+
 	/* Set SCOPE policy to enabled */
 	net->sctp.scope_policy = SCTP_SCOPE_POLICY_ENABLE;
 
-- 
2.1.0

