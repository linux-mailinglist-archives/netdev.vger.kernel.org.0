Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BDA2305B57
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 13:29:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S314020AbhAZWzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 17:55:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727131AbhAZFLr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 00:11:47 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79CCDC061756
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 21:11:07 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id d13so3420600plg.0
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 21:11:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=zuS3sLG5X3owhuldOzi8mp0n4Mfny2KWeYRnlbwvBqU=;
        b=rKLhGM2OQ4Yi1n5bcOEZusAxv6/J0o/aUaJLe19GCjEEWOp5FeNVKnshWCpKH+gSfR
         IqE1W30Iv6HkfByAaEuGYXLLLrTZ7f0aR0exM+s5OxZfAcusMbCnWHhSo9gI4Sxl69nV
         dV0xx/Z6ZfW4nWMMBvMyYFE16HnK+H2FNdFNyjnPC8aznl9ZbZraksqVpOA3IGRq5i6H
         m7FjCrsmEzjJm4nzxIToQtmzebgI7Eg0834RCN0PubwOkHE/xpO5A9g3sLvQZMw03xAL
         dZVmQW/looQ2hBJWZLULJt5Aayxjye07br/rGyN+AOqXPdb6Tjwtwu05ebTizFjC12uL
         Ye3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=zuS3sLG5X3owhuldOzi8mp0n4Mfny2KWeYRnlbwvBqU=;
        b=qIEx3wwg9NUR35DnrlN2JILUE6Qx4kb2p248QeGT7q7sSWy5gDbGhMYV8LdsIm4ves
         vU+vGO/EeXgCQ6eBJ9UbsdwIqvN14KAdehwR73qekaUw21OvFvD4FxLb2ecqDR1T5SMp
         MUvNXtk8WYSwvifHGklHJfMeyUNo7JKaqO4iEy0kUyDYHx+BZehNIDrWm+ZraG221kSn
         Sjm4UK195SfT2RPTS2UczwfTJZ6NsrwMaEHAsXFJpOE0MbypmoJ/rdPV2587aiuH0Gtd
         vfN0KGl8nWuMClrQDGPIqlCk0y6L82fvwYmG3G8ShcAHpEu7RS4KIo/7fp8gXpXb7cVq
         9WDA==
X-Gm-Message-State: AOAM533JW6/AGWoM+03ryBzbrFfFvwq/jGOTC0h9q1dTgdkfnpQCJpIZ
        cS5xfTuR1ee4rdNJMHMDH0wkk9QWyQvEpw==
X-Google-Smtp-Source: ABdhPJynIkn1FDxzU2xMVcaVk+Rlx0Pz/vlgJChfgsO10O8DTRKBJLNCi+MHnm6bXtJ1zkTu9SJDMA==
X-Received: by 2002:a17:90b:d8d:: with SMTP id bg13mr4165143pjb.189.1611637866786;
        Mon, 25 Jan 2021 21:11:06 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 30sm18680738pgl.77.2021.01.25.21.11.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Jan 2021 21:11:06 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        pabeni@redhat.com, Willem de Bruijn <willemb@google.com>,
        Martin Varghese <martin.varghese@nokia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        David Howells <dhowells@redhat.com>
Subject: [PATCHv4 net-next 1/2] udp: call udp_encap_enable for v6 sockets when enabling encap
Date:   Tue, 26 Jan 2021 13:10:48 +0800
Message-Id: <77cd57759f66c642fb0ed52be85abde201f8bfc9.1611637639.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1611637639.git.lucien.xin@gmail.com>
References: <cover.1611637639.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1611637639.git.lucien.xin@gmail.com>
References: <cover.1611637639.git.lucien.xin@gmail.com>
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
-- 
2.1.0

