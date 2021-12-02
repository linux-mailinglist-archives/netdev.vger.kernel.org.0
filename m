Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA37465C23
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 03:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355010AbhLBCbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 21:31:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354811AbhLBCaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 21:30:01 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF142C061574
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 18:26:39 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id z6so19164318plk.6
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 18:26:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EPoch2HPmalMyteCJ4LJOCp+4tNtogcZXXk4/v0sF3s=;
        b=Ba80/TubPmh04LmebZlzKifWASS/Ec0l1b7JatLkIcFYQM/r9sUGkUGCuLA5Fc01Gm
         wDxDjNHmNR/jSwF5FirOf4184TnxLOEUmjKkcFKlG71Gv8BAajDf9GRxIUyS0F42NLMt
         Zbc0CXPWnw0XbdMfL88l9NCgxBgJ+pU4m2/nYeAwRnYs+CiaxG5OHL4jfvhW2/rH9bzH
         IMOaWNULqGEtiTT74+HEQtZQuQYVDcoDg4QHSwqrO22qluWprFyY+14hGBZOjPwjZeml
         w9SrE9Qj+JVjOS7l34avuutUoziTlwU7AhaQJ/G8Q/IboxYVfHhQNTXE859h9X56A9BC
         BIiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EPoch2HPmalMyteCJ4LJOCp+4tNtogcZXXk4/v0sF3s=;
        b=mHfTfXR0ZzyCOXpDq63xCPNjpQr8LvEuUrdngVvzNwBzstCTvkB7hUIBbIFiBYHfbI
         GqnNRD37qX2jI1rQzWcwAt4gn3Ou35B2tDFt9G13PC4MArIP9Y+svMroTK1SGS4zPc5g
         9945jgbD0BpxaKeWDqGeHhEbvDfofTNb9g/86fWDJNblTK9wyw95BqwNH0dbQ2QYyxpq
         trku/75JjM/7huOy+xcXy4CMryHqhroUBtOKStINdcRALqrueG7UA1sUucNMWjo0dqxF
         C6b3WwWQ3gm7H6hPwmHWLRkXQ1LyRzDbHbNi50Z/kGKJGtSW+51AJRT60AqMMKYsgWmj
         8KYw==
X-Gm-Message-State: AOAM531mhqemJMLQ5VIy2KyhUK+Clx/W6ZmjONEp0QqrO87TNplQli75
        qB8wydlWWblO78cUNRN2GfY=
X-Google-Smtp-Source: ABdhPJxLV8rMLJP9lz6dlRBS4dsZmcP+Pst7LHdtyMkexYXE8TQbs9rawiRPD6RMTaga3KPvpEFHOA==
X-Received: by 2002:a17:90a:eb03:: with SMTP id j3mr2565823pjz.149.1638411999270;
        Wed, 01 Dec 2021 18:26:39 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e768:caa5:c812:6a1c])
        by smtp.gmail.com with ESMTPSA id a22sm1129311pfh.111.2021.12.01.18.26.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 18:26:38 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH net] ipv4: convert fib_num_tclassid_users to atomic_t
Date:   Wed,  1 Dec 2021 18:26:35 -0800
Message-Id: <20211202022635.2864113-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Before commit faa041a40b9f ("ipv4: Create cleanup helper for fib_nh")
changes to net->ipv4.fib_num_tclassid_users were protected by RTNL.

After the change, this is no longer the case, as free_fib_info_rcu()
runs after rcu grace period, without rtnl being held.

Fixes: faa041a40b9f ("ipv4: Create cleanup helper for fib_nh")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: David Ahern <dsahern@kernel.org>
---
 include/net/ip_fib.h     | 2 +-
 include/net/netns/ipv4.h | 2 +-
 net/ipv4/fib_frontend.c  | 2 +-
 net/ipv4/fib_rules.c     | 4 ++--
 net/ipv4/fib_semantics.c | 4 ++--
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index ab5348e57db1a627cbce2dededb2e9b754d1f2cd..3417ba2d27ad6a1b5612a8855d2788f10d9fdf25 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -438,7 +438,7 @@ int fib_validate_source(struct sk_buff *skb, __be32 src, __be32 dst,
 #ifdef CONFIG_IP_ROUTE_CLASSID
 static inline int fib_num_tclassid_users(struct net *net)
 {
-	return net->ipv4.fib_num_tclassid_users;
+	return atomic_read(&net->ipv4.fib_num_tclassid_users);
 }
 #else
 static inline int fib_num_tclassid_users(struct net *net)
diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 2f65701a43c953bd3a9a9e3d491882cb7bb11859..6c5b2efc4f17d0d17be750d0c1a2e1d169ec063e 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -65,7 +65,7 @@ struct netns_ipv4 {
 	bool			fib_has_custom_local_routes;
 	bool			fib_offload_disabled;
 #ifdef CONFIG_IP_ROUTE_CLASSID
-	int			fib_num_tclassid_users;
+	atomic_t		fib_num_tclassid_users;
 #endif
 	struct hlist_head	*fib_table_hash;
 	struct sock		*fibnl;
diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 9fe13e4f5d08a5cf9cd9ff15033b9f6e0dc9e492..4d61ddd8a0ecfc4cc47b4802eb5a573beb84ee44 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -1582,7 +1582,7 @@ static int __net_init fib_net_init(struct net *net)
 	int error;
 
 #ifdef CONFIG_IP_ROUTE_CLASSID
-	net->ipv4.fib_num_tclassid_users = 0;
+	atomic_set(&net->ipv4.fib_num_tclassid_users, 0);
 #endif
 	error = ip_fib_net_init(net);
 	if (error < 0)
diff --git a/net/ipv4/fib_rules.c b/net/ipv4/fib_rules.c
index 364ad3446b2f3c056ea5dafea1542e4d3306ddb6..d279cb8ac1584487885f66819634b421c01bf819 100644
--- a/net/ipv4/fib_rules.c
+++ b/net/ipv4/fib_rules.c
@@ -264,7 +264,7 @@ static int fib4_rule_configure(struct fib_rule *rule, struct sk_buff *skb,
 	if (tb[FRA_FLOW]) {
 		rule4->tclassid = nla_get_u32(tb[FRA_FLOW]);
 		if (rule4->tclassid)
-			net->ipv4.fib_num_tclassid_users++;
+			atomic_inc(&net->ipv4.fib_num_tclassid_users);
 	}
 #endif
 
@@ -296,7 +296,7 @@ static int fib4_rule_delete(struct fib_rule *rule)
 
 #ifdef CONFIG_IP_ROUTE_CLASSID
 	if (((struct fib4_rule *)rule)->tclassid)
-		net->ipv4.fib_num_tclassid_users--;
+		atomic_dec(&net->ipv4.fib_num_tclassid_users);
 #endif
 	net->ipv4.fib_has_custom_rules = true;
 
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 3364cb9c67e018fea2b2e370046de5252581b996..fde7797b580694bb3924c5c6e9560cf04fd67387 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -220,7 +220,7 @@ void fib_nh_release(struct net *net, struct fib_nh *fib_nh)
 {
 #ifdef CONFIG_IP_ROUTE_CLASSID
 	if (fib_nh->nh_tclassid)
-		net->ipv4.fib_num_tclassid_users--;
+		atomic_dec(&net->ipv4.fib_num_tclassid_users);
 #endif
 	fib_nh_common_release(&fib_nh->nh_common);
 }
@@ -632,7 +632,7 @@ int fib_nh_init(struct net *net, struct fib_nh *nh,
 #ifdef CONFIG_IP_ROUTE_CLASSID
 	nh->nh_tclassid = cfg->fc_flow;
 	if (nh->nh_tclassid)
-		net->ipv4.fib_num_tclassid_users++;
+		atomic_inc(&net->ipv4.fib_num_tclassid_users);
 #endif
 #ifdef CONFIG_IP_ROUTE_MULTIPATH
 	nh->fib_nh_weight = nh_weight;
-- 
2.34.0.rc2.393.gf8c9666880-goog

