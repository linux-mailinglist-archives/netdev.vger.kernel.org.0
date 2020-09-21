Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE0DE272195
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 12:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbgIUK4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 06:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726662AbgIUK4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 06:56:41 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F42C0613D3
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 03:56:28 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id e16so12259990wrm.2
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 03:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W1k28u9m4opk3xAHXu3X6yCLygcG5WtwBqkfTVt8j0k=;
        b=xyGBhkOGELPKn//wEelqXKR2capv+rcr01F4odCptjBa5YW1aMl9K9f6t/0AE/wp2F
         H8mU9/tvQ/ES2Gn5EstZdkbKciKhK/oKiGIWUjX3LtKCma9GaXbvw+gfcBg+t5W49o1A
         JHjfV7vzht0dYR7MYq/zmlq1IYz/NJMcNp441j3HZy23AMNTTznaX74gHX3SCSMwFNrx
         Vaey+fwS46Ycelax5JgnPTb3YsMBtq1X2N9kPwkPkyiSHD7sLTOx++j4LpbTQLHkUFkn
         DB/tET4zDJ1tQGLh3sW/wGCKCaipL+70mXN5PY4rRkJKirCxLDGDKUw4OOZ6ERVM6Z6T
         X7yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W1k28u9m4opk3xAHXu3X6yCLygcG5WtwBqkfTVt8j0k=;
        b=Zrlpdc9e4scymbFqX+rE2GZWcYO2pS7n4CIeAzxLBhO6CZeFCObnG+GsOpKEmOJmZv
         eDoxclsedNoVNWq3lnFppVHTpK2QusjCWSn30G7sbg6UrCwA9oY3Ajyqf1rTTPInInSr
         meWYfp96lXjEKptaorj1+Wm8PwAgMYnRB/fAlQ7EuXT6150+76nAryWEgp+1Wf3q2MnR
         qtBVczATgPYDJ0vIYM0+XfofdXIpQ7DI9s8kOk1fVutsNT9W/modjrjiasBbLSSIHGUH
         3szlS3TGjFJWck/dqTt3fXXQugJYg5QEbVTwY9x7aTFYB1MVw4IXsbDEIeoEmQF0SreG
         sFTw==
X-Gm-Message-State: AOAM533xulzL1k7qv658lic+VoHmbsGJ7T0NuFyVNIsiJ2XjixKruCzD
        q5eeFjhDvqqaiqJq9o7HWCv2B6bxTTzgJ+yEoZo9Qg==
X-Google-Smtp-Source: ABdhPJwcdLN2KgA8ISfNJtMrE9FRZfmoLfTdUJ1nxmQ+ZF48FONNG75fUXSJ8sUWvYqhodFwlbtEbg==
X-Received: by 2002:adf:f492:: with SMTP id l18mr54104001wro.280.1600685786973;
        Mon, 21 Sep 2020 03:56:26 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id s11sm19637727wrt.43.2020.09.21.03.56.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 03:56:26 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 16/16] net: bridge: mcast: when forwarding handle filter mode and blocked flag
Date:   Mon, 21 Sep 2020 13:55:26 +0300
Message-Id: <20200921105526.1056983-17-razor@blackwall.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200921105526.1056983-1-razor@blackwall.org>
References: <20200921105526.1056983-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

We need to avoid forwarding to ports in MCAST_INCLUDE filter mode when the
mdst entry is a *,G or when the port has the blocked flag.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_forward.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
index 4d12999e4576..e28ffadd1371 100644
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -274,10 +274,19 @@ void br_multicast_flood(struct net_bridge_mdb_entry *mdst,
 	struct net_bridge *br = netdev_priv(dev);
 	struct net_bridge_port *prev = NULL;
 	struct net_bridge_port_group *p;
+	bool allow_mode_include = true;
 	struct hlist_node *rp;
 
 	rp = rcu_dereference(hlist_first_rcu(&br->router_list));
-	p = mdst ? rcu_dereference(mdst->ports) : NULL;
+	if (mdst) {
+		p = rcu_dereference(mdst->ports);
+		if (br_multicast_should_handle_mode(br, mdst->addr.proto) &&
+		    br_multicast_is_star_g(&mdst->addr))
+			allow_mode_include = false;
+	} else {
+		p = NULL;
+	}
+
 	while (p || rp) {
 		struct net_bridge_port *port, *lport, *rport;
 
@@ -292,6 +301,10 @@ void br_multicast_flood(struct net_bridge_mdb_entry *mdst,
 						   local_orig);
 				goto delivered;
 			}
+			if ((!allow_mode_include &&
+			     p->filter_mode == MCAST_INCLUDE) ||
+			    (p->flags & MDB_PG_FLAGS_BLOCKED))
+				goto delivered;
 		} else {
 			port = rport;
 		}
-- 
2.25.4

