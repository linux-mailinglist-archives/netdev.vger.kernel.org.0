Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD1C301ABA
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 09:55:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbhAXIy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 03:54:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726475AbhAXIyR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 03:54:17 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 130FBC061574
        for <netdev@vger.kernel.org>; Sun, 24 Jan 2021 00:53:32 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id u4so6615848pjn.4
        for <netdev@vger.kernel.org>; Sun, 24 Jan 2021 00:53:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=AvGBdriL70KOTap+rozh0oGuAo+0gm9DtiAJTH7+5X8=;
        b=r+ks1UPLHNw7zyHHKhkLU5/zolPRnqvNNta/bDOttraEqnSxFvCjorsaQhWaYITY6c
         AzYPmMm6si3ee/Onc4HQZL30OQqAoGK2mdxfDrVhYfktUSAcoOwYUZycuWXkJk3wNfaA
         +8LIqq4xYGFFfiany+OCHGLOZGLC5I7TXzwa/MepMXhow3++m1p+KtlTHjPdJPsSA0CP
         f1t1ytD592s/qHIdEsZpHbk2aGj/lhbUvU8YOAHlgUCS0LBPryTkT1S7qLdquNYRJ6SH
         zul8Zu1VGrTmcUHEcDKW4E2B9idDk1np3I3/+IelDNgJBu5x+4xTWe8i2dcrA8EXOFvk
         FsSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=AvGBdriL70KOTap+rozh0oGuAo+0gm9DtiAJTH7+5X8=;
        b=hqPmV/gWLJTcJfx+y0XTb/yyZmhFlAfmKwTQufCR+sgWYQ4aR55KEWU1qyTBkTNJp9
         XLGzGDOZ1nzWpKglh2vr7EArvjUzAG2NQW2tYGSYJeqZ3Ju9kywUAZAV9y1+tcUGhPb3
         f3/VMAKqDHxYm+gxavLfJxh+eVi+fRW7NPhyNWi88vbwXefFvDcwL4mKdPUSJJbrZbtt
         rKV/f0SbW4siTYelmZN8mCGFr8V/tDZRaCmgmz3IsiZ+LpOpKNXBb/vcK/qscF7BqcDJ
         lQjhgg01atre/vdRP8IXqAHNjNV/y48cOHXDVKQtr8Pg1d71BBQPZ1nf2Z+eOW6Qhbte
         4oEg==
X-Gm-Message-State: AOAM531Pgv8zKhizyT8bLUCj1HAD6LExu0CPPfB/qjMDYAOXjwOoPg1V
        VwDM1VPmeCcNZBgv5TfsQuJvZ5wpjVX04A==
X-Google-Smtp-Source: ABdhPJw3eRcVqFd94nmlIaAi8pcHFeTdkPHXWn3xmXR31LZmPny06e8ICB9qwCRa8sNkVFgiiXrYvg==
X-Received: by 2002:a17:90a:470b:: with SMTP id h11mr15351841pjg.186.1611478410983;
        Sun, 24 Jan 2021 00:53:30 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p64sm13134704pfb.201.2021.01.24.00.53.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 Jan 2021 00:53:30 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        pabeni@redhat.com, Willem de Bruijn <willemb@google.com>,
        Martin Varghese <martin.varghese@nokia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        David Howells <dhowells@redhat.com>
Subject: [PATCHv3 net-next] udp: call udp_encap_enable for v6 sockets when enabling encap
Date:   Sun, 24 Jan 2021 16:53:23 +0800
Message-Id: <d2a9b26103c84ff535a886e875c6c619057641c8.1611478403.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When enabling encap for a ipv6 socket without udp_encap_needed_key
increased, UDP GRO won't work for v4 mapped v6 address packets as
sk will be NULL in udp4_gro_receive().

This patch is to enable it by increasing udp_encap_needed_key for
v6 sockets in udp_tunnel_encap_enable(), and correspondingly
decrease udp_encap_needed_key in udpv6_destroy_sock().

v1->v2:
  - add udp_encap_disable() and export it.
v2->v3:
  - add the change for rxrpc and bareudp into one patch, as Alex
    suggested.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 drivers/net/bareudp.c    | 6 ------
 include/net/udp.h        | 1 +
 include/net/udp_tunnel.h | 3 +--
 net/ipv4/udp.c           | 6 ++++++
 net/ipv6/udp.c           | 4 +++-
 net/rxrpc/local_object.c | 4 +++-
 6 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index 1b8f597..7511bca 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -240,12 +240,6 @@ static int bareudp_socket_create(struct bareudp_dev *bareudp, __be16 port)
 	tunnel_cfg.encap_destroy = NULL;
 	setup_udp_tunnel_sock(bareudp->net, sock, &tunnel_cfg);
 
-	/* As the setup_udp_tunnel_sock does not call udp_encap_enable if the
-	 * socket type is v6 an explicit call to udp_encap_enable is needed.
-	 */
-	if (sock->sk->sk_family == AF_INET6)
-		udp_encap_enable();
-
 	rcu_assign_pointer(bareudp->sock, sock);
 	return 0;
 }
diff --git a/include/net/udp.h b/include/net/udp.h
index 877832b..1e7b6cd 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -467,6 +467,7 @@ void udp_init(void);
 
 DECLARE_STATIC_KEY_FALSE(udp_encap_needed_key);
 void udp_encap_enable(void);
+void udp_encap_disable(void);
 #if IS_ENABLED(CONFIG_IPV6)
 DECLARE_STATIC_KEY_FALSE(udpv6_encap_needed_key);
 void udpv6_encap_enable(void);
diff --git a/include/net/udp_tunnel.h b/include/net/udp_tunnel.h
index 282d10e..afc7ce7 100644
--- a/include/net/udp_tunnel.h
+++ b/include/net/udp_tunnel.h
@@ -181,9 +181,8 @@ static inline void udp_tunnel_encap_enable(struct socket *sock)
 #if IS_ENABLED(CONFIG_IPV6)
 	if (sock->sk->sk_family == PF_INET6)
 		ipv6_stub->udpv6_encap_enable();
-	else
 #endif
-		udp_encap_enable();
+	udp_encap_enable();
 }
 
 #define UDP_TUNNEL_NIC_MAX_TABLES	4
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 69ea765..48208fb 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -596,6 +596,12 @@ void udp_encap_enable(void)
 }
 EXPORT_SYMBOL(udp_encap_enable);
 
+void udp_encap_disable(void)
+{
+	static_branch_dec(&udp_encap_needed_key);
+}
+EXPORT_SYMBOL(udp_encap_disable);
+
 /* Handler for tunnels with arbitrary destination ports: no socket lookup, go
  * through error handlers in encapsulations looking for a match.
  */
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index b9f3dfd..d754292 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1608,8 +1608,10 @@ void udpv6_destroy_sock(struct sock *sk)
 			if (encap_destroy)
 				encap_destroy(sk);
 		}
-		if (up->encap_enabled)
+		if (up->encap_enabled) {
 			static_branch_dec(&udpv6_encap_needed_key);
+			udp_encap_disable();
+		}
 	}
 
 	inet6_destroy_sock(sk);
diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index 8c28810..fc10234 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -135,11 +135,13 @@ static int rxrpc_open_socket(struct rxrpc_local *local, struct net *net)
 	udp_sk(usk)->gro_receive = NULL;
 	udp_sk(usk)->gro_complete = NULL;
 
-	udp_encap_enable();
 #if IS_ENABLED(CONFIG_AF_RXRPC_IPV6)
 	if (local->srx.transport.family == AF_INET6)
 		udpv6_encap_enable();
+	else
 #endif
+		udp_encap_enable();
+
 	usk->sk_error_report = rxrpc_error_report;
 
 	/* if a local address was supplied then bind it */
-- 
2.1.0

