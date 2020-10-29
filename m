Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04FC029E3E5
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 08:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbgJ2HVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 03:21:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbgJ2HU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 03:20:58 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F91CC08EA6C;
        Thu, 29 Oct 2020 00:05:54 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id o7so1586162pgv.6;
        Thu, 29 Oct 2020 00:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=NCNMRLeAt/3uxNYYJNKXmIUovKQtSPc7IGkvteiwh0Y=;
        b=vZU8RCSTDSZ98gDAiZDcgmuFZp0NYReBjyL6Twn7RgqfHKVzceSi9QFjHjKa1/17Wy
         61i54dDMOJ4Th0kXhH82X0JBumWXUmCp3i2HfOVg4FCCTFJ9FQwlCdwn20hzzQRqAKup
         fHH5L4tw7qh1xjhiVJXy0DDaFdNG7t2xIBHo4XJnLS4DV2lLAnmxESpZCPw8Y1rM7SFO
         QUWtNr7A1FDprMlUybXf/lzQcrY9iizfAhdnVvYx6kOhUs+/i5e0A43Od3IAXg8yyFAn
         yDvu5KGHzqAUabYAf04Lp8aFuPys7CskTHqox4Ub9F7NCaDt0sV1UJ8Y7RD0acSgUmEz
         9jrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=NCNMRLeAt/3uxNYYJNKXmIUovKQtSPc7IGkvteiwh0Y=;
        b=cFoS4vncO/SHwJUmT6LB6Hq+CAsOIWTmfMrQQlgPbJj9b15wpErBUsC32PLFiRNLvl
         FTay1QoQ6N7iO5dWQ+PyhrxEKctbdC75pEee5FBHIvkcJ6+R7W7EpZ8Rg9MiyOo/NMWo
         7/0ulqJLKOh7iWTwcM/sUPE3D6YcxnJNY++PY1ZHI1LXf/z4AMs0cTxZGBK29Vp5S3jO
         9PiFQPYDnhTlCtf6EG1O8qpaSx2jYdllp/jP41jKeR8N+Iw9BUVcqfo+2pZAuBL6/5Xg
         AanLp4Xqi2dgkwddn4SoxbCNaurArtvWO3AoXhbXvFn6S60i/MGWSPuJswXWV2UB3ZsV
         Ki/g==
X-Gm-Message-State: AOAM531Skku/qG12NiyF6KiSiTUpUqDxGqZkXunoTSvXm/LpSNNlx5fY
        YWIHG7UI61BYO52Wd/3lgmHEqhwYKmk=
X-Google-Smtp-Source: ABdhPJz/3tGRDcb2YNxkfYlSVEHH8xlSt3sCW12W7RhGdL0VRafec4JGUJ6s4aOHEkZxAqdnN1lZ0g==
X-Received: by 2002:a17:90b:3103:: with SMTP id gc3mr2944056pjb.158.1603955153411;
        Thu, 29 Oct 2020 00:05:53 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u13sm1731282pfl.162.2020.10.29.00.05.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Oct 2020 00:05:52 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>, gnault@redhat.com,
        pabeni@redhat.com, willemdebruijn.kernel@gmail.com
Subject: [PATCHv5 net-next 04/16] sctp: create udp4 sock and add its encap_rcv
Date:   Thu, 29 Oct 2020 15:04:58 +0800
Message-Id: <1cfd9ca0154d35389b25f68457ea2943a19e7da2.1603955040.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <e7575f9fea2b867bf0c7c3e8541e8a6101610055.1603955040.git.lucien.xin@gmail.com>
References: <cover.1603955040.git.lucien.xin@gmail.com>
 <48053c3bf48a46899bc0130dc43adca1e6925581.1603955040.git.lucien.xin@gmail.com>
 <4f439ed717442a649ba78dc0efc6f121208a9995.1603955040.git.lucien.xin@gmail.com>
 <e7575f9fea2b867bf0c7c3e8541e8a6101610055.1603955040.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1603955040.git.lucien.xin@gmail.com>
References: <cover.1603955040.git.lucien.xin@gmail.com>
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
v3->v4:
  - No change.
v4->v5:
  - Change to set udp_port to 0 by default.

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
index 2583323..0f79334 100644
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
 
+	/* Set UDP tunneling listening port to 0 by default */
+	net->sctp.udp_port = 0;
+
 	/* Set SCOPE policy to enabled */
 	net->sctp.scope_policy = SCTP_SCOPE_POLICY_ENABLE;
 
-- 
2.1.0

