Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9EE2F73B7
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 08:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731351AbhAOHbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 02:31:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727470AbhAOHbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 02:31:08 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4262C0613C1
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 23:30:27 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id g3so4271859plp.2
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 23:30:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=Z7HSJSeBLeJa8F3YnHkBDKj2RIYYIjzsXg9wxk8bDWo=;
        b=W7GMYTwhKVtMPPAO0mgY0h3bToFgAoVEDe8CZBSU71YmuBxr05DCVooz4Ob2V7KGOc
         pULe6CPTqznLD2kb4WOFihU0gPR+Yr5eSLefgNPDmaN2qc2H1Lr7FkPZmrnXjPNGhEKD
         In8Za0Ic1YDVsQsXyZSzJMrHOhQFWLWVo9EnGMhDefvTZcwxZTqwkLfqC8+QG2nKjEZ9
         2SLBxxFsPBPOE19x1JEpwSdGolYYDpJXEIrrGscde7VjerO07Lf+NmeQ/l5F1KcPByFz
         r/FjOx5Lc7BAekoTVgSyIxKhSf5sOmrZORku6rLPCJby2YbKo5DlgundtZYYKo6kXvR/
         /mCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=Z7HSJSeBLeJa8F3YnHkBDKj2RIYYIjzsXg9wxk8bDWo=;
        b=R7SgFi5ebPe6rjOYx2Olsi0PIEo3FDkmediIiMOVR3S+qaQGK+itzIgcVdOxXDTLeQ
         fJ3MZTajCuGpGXCS0ekdh0lEF+fzoMFoSznnpbtAqWS0VYemU6mRMPEGr/VHir2Ucrqj
         ZiaSTXmPttibih/EbQPoJ/wISDGrSpbfTXXch2yoHnTst08ZqCTt1J7B2md4BKUHBHA4
         CN8A1noZYHEw8nXbbZKGhYshd7IkS5d6iv19WC6B6zF/wKC4EgOAD01MitXoIlvo3WMC
         iSII/+iz/pMn1Q4p86dfiiT+C+ZkQI+Y7xqkN+/nFAxfO8p9fLAQV1YTl/R7rGyerFcZ
         6+yg==
X-Gm-Message-State: AOAM531A/jXvtr454vA+bK+h3d96uZoie7XPhsy1qrPX1/ANApydi63w
        SVVEwgnqpAx0aO1FJWeHPL3hgW9BRiBbZg==
X-Google-Smtp-Source: ABdhPJytpKO1vACPgBvM6WTz+1/t+dfUzx1wqMEHPANm2plbpsmp6OOVKzkyRUt7Rlr627sr3GTg8Q==
X-Received: by 2002:a17:902:ea0f:b029:de:5fd5:abb9 with SMTP id s15-20020a170902ea0fb02900de5fd5abb9mr5785667plg.46.1610695827045;
        Thu, 14 Jan 2021 23:30:27 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p9sm7274200pjb.3.2021.01.14.23.30.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Jan 2021 23:30:26 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        pabeni@redhat.com, Willem de Bruijn <willemb@google.com>,
        Martin Varghese <martin.varghese@nokia.com>
Subject: [PATCHv2 net-next 1/2] udp: call udp_encap_enable for v6 sockets when enabling encap
Date:   Fri, 15 Jan 2021 15:30:08 +0800
Message-Id: <f85095ae5835c102d0b8434214f48084f4f4f279.1610695758.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1610695758.git.lucien.xin@gmail.com>
References: <cover.1610695758.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1610695758.git.lucien.xin@gmail.com>
References: <cover.1610695758.git.lucien.xin@gmail.com>
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

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/udp.h        | 1 +
 include/net/udp_tunnel.h | 3 +--
 net/ipv4/udp.c           | 6 ++++++
 net/ipv6/udp.c           | 4 +++-
 4 files changed, 11 insertions(+), 3 deletions(-)

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
index 7103b0a..28bfe60 100644
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

