Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2855F30D5A3
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 09:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232975AbhBCIzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 03:55:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232591AbhBCIzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 03:55:21 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67458C06174A
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 00:54:41 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id o63so16830552pgo.6
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 00:54:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=OqJkaBixyXF2rZOXQOUWllxQn/yRaTa3pePDUVl2py4=;
        b=q0xguaMJEcxCi8in2/E+orQX2cvvjtVkZFIeTBuvsgT5Sx9Yi3uQB5W85sof8+RlVF
         jO5J48079iM+YnMB+GhTZGeioTDJUbNKFflb4I47Mqgp7go427pNTpA4+rSFJ1htSdxA
         DRsGwtki6IHIPzul/+e0XtmH3Ja8+q1Eyx18HaiCxBEViDZKKXNtQi0iDr16qks1Qkck
         ZJ8HavpNiekLc0p5Et56jPtkSJG5N9eqK1jTXycRO+JIjfNMA8iANgnsDz86P9O8hPRo
         1Xsg9S899hNSLwNMMYFet2Y7UlhrBSidQ8VWQ77Y7k9pz+/YwUnNR3DtoZS7rJZ0i8LL
         yoEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=OqJkaBixyXF2rZOXQOUWllxQn/yRaTa3pePDUVl2py4=;
        b=W3Kz5tv383tAG9hZ7kK0Lc9K3wjwY7IMHWJ+W0MOEPMeq+QGVH9aovIO1mDy8uBRdL
         TNoZJ8G4NsJLm1o3eEHAysyVq6U+ErH1BkVltjesRGzlWp4HIYfEkQCGe58J8tHSe/OU
         7PzbNMgTc/CCn47PD4yD+3rPvU24QSJK3xXyo5+ZuMKEA7YggWP/eJsSbvk/HFsd3fxK
         coERRv0KuA4Sr08/jwdwykKxhHrN7wLtvBoe5eXzg3/xGIG9rPz1+Gbysq4ako/rhp4L
         HyOPSaaP1WgSz8OQ0tv8fsgWAmA3oYu5SyMaavf9f9Jm0TFxmmUBq21hUnukBbF6MwYr
         X11Q==
X-Gm-Message-State: AOAM533tduxFNH9PtjYoo0cbYWfSxOB7IFlJosV4r4kPwAHuddgR3m62
        sokXg0TCkI4+34qEkVmwL/s7FTkR2AUCzw==
X-Google-Smtp-Source: ABdhPJxvRK+feu/BHzi1c1v/Tcph6vYIAwcHckAuzyxnJath+5dbfmXXFZAAf9Uw1BEuU85VbXn6GQ==
X-Received: by 2002:a62:7957:0:b029:1bc:22d3:a22f with SMTP id u84-20020a6279570000b02901bc22d3a22fmr2212557pfc.52.1612342480626;
        Wed, 03 Feb 2021 00:54:40 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y75sm1461651pfg.119.2021.02.03.00.54.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Feb 2021 00:54:39 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        pabeni@redhat.com, Willem de Bruijn <willemb@google.com>,
        Martin Varghese <martin.varghese@nokia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        David Howells <dhowells@redhat.com>
Subject: [PATCHv5 net-next 1/2] udp: call udp_encap_enable for v6 sockets when enabling encap
Date:   Wed,  3 Feb 2021 16:54:22 +0800
Message-Id: <fc62f5e225f83d128ea5222cc752cb1c38c92304.1612342376.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1612342376.git.lucien.xin@gmail.com>
References: <cover.1612342376.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1612342376.git.lucien.xin@gmail.com>
References: <cover.1612342376.git.lucien.xin@gmail.com>
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
v3->v4:
  - move rxrpc part to another patch.

Acked-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 drivers/net/bareudp.c    | 6 ------
 include/net/udp.h        | 1 +
 include/net/udp_tunnel.h | 3 +--
 net/ipv4/udp.c           | 6 ++++++
 net/ipv6/udp.c           | 4 +++-
 5 files changed, 11 insertions(+), 9 deletions(-)

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
index 01351ba..5ddbb42 100644
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
-- 
2.1.0

