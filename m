Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0892F8B42
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 05:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729809AbhAPEdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 23:33:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729785AbhAPEdi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 23:33:38 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92FE0C061796
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 20:32:25 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id b5so6399225pjl.0
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 20:32:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=Z7HSJSeBLeJa8F3YnHkBDKj2RIYYIjzsXg9wxk8bDWo=;
        b=gCUBCrqqH07oKDjh6D1k7eTk2+AcSwJbH/sMdHbllGOteSy/GizCJM6qTlHwJjwAeE
         Z4RpX4meQP3GM/stMD1YyOgtBWCw4OqWKWH0EY3KR8TfPb0dkkv4iVPXxsrA8hLBGV3w
         ULUPtyCkOxgCTsKz9dQ3Ced9WzMDfAumUD9aAomjCxVB/qAGZXyusmNshUN6f5yGXSW6
         +LFnMPdHMtBH3eApdm4llWS5CsCYDVIiql+OPtfwPoRxAK6IrtXLviAei8TiEh0JRYDN
         +xa2aB9PZhILo90612aNEFZ1CK3E6K0tVIwpL8reXvnUuxn8eN2xnv5f972ULEUM+ubn
         D9Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=Z7HSJSeBLeJa8F3YnHkBDKj2RIYYIjzsXg9wxk8bDWo=;
        b=OLk8xct6GS0SB+0e93ztfU0Rp+Ge1I5LnlEMkXY6P1uoO0gYRP7gblE/rNb5dV6xde
         Hniln538xjxkMNaVFRvUS0TMQURwCPrNNyZ1iq5XLPE6+SNR6B1r0LXqqMWcWoJaIr8D
         C/HUM8B+0Ps+7Yt5wTXu6ihokj7bFdFvpaWMf3ZpHCeRvPshsFKeZXsOS/ah385ICeEq
         8JxP4peNBrpxLArxWtXk+AicqFoQzydrw5BsztRGLyhIXsqGOFnsoBLprbOmGlI69aAB
         vTYEzJenTAsIMCUCf5myc3EcDKc6hRudjb2c4juUWe9mlXvuLvtLtKaWMxvtXkRCcDB0
         DIfA==
X-Gm-Message-State: AOAM533jUa26/gqLM+AHtsj5Tw82NpIhfsQvmrwiMViJ4LWaE4Ze/7vt
        I2MSMlt/LlecZmJL3x6+r9HQF6S1/ZcgaQ==
X-Google-Smtp-Source: ABdhPJyGVQTB6S5Mf9QN+RmMzw2HefBBdSTAvSSPpua4YXtDCEGL8isqqevmx5xyECJZ3bcfcHpm2g==
X-Received: by 2002:a17:902:e901:b029:db:c0d6:62cc with SMTP id k1-20020a170902e901b02900dbc0d662ccmr15998623pld.7.1610771544911;
        Fri, 15 Jan 2021 20:32:24 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b65sm6301268pga.54.2021.01.15.20.32.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Jan 2021 20:32:24 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        pabeni@redhat.com, Willem de Bruijn <willemb@google.com>,
        Martin Varghese <martin.varghese@nokia.com>
Subject: [PATCHv3 net-next 1/2] udp: call udp_encap_enable for v6 sockets when enabling encap
Date:   Sat, 16 Jan 2021 12:32:07 +0800
Message-Id: <0ba74e791c186444af53489ebc55664462a1caf6.1610771509.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1610771509.git.lucien.xin@gmail.com>
References: <cover.1610771509.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1610771509.git.lucien.xin@gmail.com>
References: <cover.1610771509.git.lucien.xin@gmail.com>
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

