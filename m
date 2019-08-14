Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD688D660
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 16:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727997AbfHNOkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 10:40:39 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41303 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727900AbfHNOkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 10:40:37 -0400
Received: by mail-wr1-f67.google.com with SMTP id j16so9073888wrr.8
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 07:40:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EW+6AvSLzUYJxeji2mVd2Q1VYO3NHO/LYR1JxyZ6kvU=;
        b=WNOmqL6qONoJ2gEwwiKGqO+0EmHjINHWQyqF2Qet9WW22J0o5wQfiMNHwDSrm6mdZ8
         KMgplj9DMuCT7uNMqUCsJQlF0a/lNA5ijchdiH9NNVW+ShvYw9ZTotzmPHgoE1E9Qn69
         PQoKQke9/ef9dzmlMCBtu37t6VNFR+Z4XKQC4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EW+6AvSLzUYJxeji2mVd2Q1VYO3NHO/LYR1JxyZ6kvU=;
        b=lh7sJWZ9dQlsr2BY1NmTezlpY7Tkj47qofNYvoD0KLHqcDhpy68fN0auu9jMePXWU5
         mXdtfuysx4D3m+QxB7WQ/O4UrsciSrrL+qjdpttKwzEIQeaUZ7oqV6H9xIEwUabw65ZQ
         hfaddrSN3nQ4LbNeaUALyyB80DTuGuxkQd4pFhxEG9NsTCczFF7hsREvEmC2UZKQbkZX
         P++aPK5ntxyW2A1/Ry1Dn/sQdd4ztX/Ipe72rhm4lhPri8fCtLOjY2ycfaeVsr/Riakb
         SDviX+aMKt8vXfhpO5/7LfbhgWueWsesKpfJyhvfR3GoKsPVQmimMY9fsx1AxYRhy1QC
         kUYg==
X-Gm-Message-State: APjAAAXOOVLSoOfeS43jt0/FfDdWszxkng/ga22YSQxpjkqqZDlYNGrW
        gResUdFD5JFVl8ypWbXwViPW7mghJpk=
X-Google-Smtp-Source: APXvYqwrXjSgDiima9PAniMC+Jx2xjXyqTOLNY1i0Rr4PuH6v8wSgb40TN1T6ePOj2v/nR52gGtD5Q==
X-Received: by 2002:a5d:610d:: with SMTP id v13mr44002528wrt.249.1565793635856;
        Wed, 14 Aug 2019 07:40:35 -0700 (PDT)
Received: from wrk.www.tendawifi.com ([79.134.174.40])
        by smtp.gmail.com with ESMTPSA id o8sm3383874wma.1.2019.08.14.07.40.34
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 14 Aug 2019 07:40:35 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next 2/4] net: bridge: mdb: factor out mdb filling
Date:   Wed, 14 Aug 2019 17:40:22 +0300
Message-Id: <20190814144024.9710-3-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190814144024.9710-1-nikolay@cumulusnetworks.com>
References: <20190814144024.9710-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have to factor out the mdb fill portion in order to re-use it later for
the bridge mdb entries. No functional changes intended.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_mdb.c | 68 ++++++++++++++++++++++++---------------------
 1 file changed, 37 insertions(+), 31 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index ee6208c6d946..77730983097e 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -77,6 +77,40 @@ static void __mdb_entry_to_br_ip(struct br_mdb_entry *entry, struct br_ip *ip)
 #endif
 }
 
+static int __mdb_fill_info(struct sk_buff *skb,
+			   struct net_bridge_port_group *p)
+{
+	struct nlattr *nest_ent;
+	struct br_mdb_entry e;
+
+	memset(&e, 0, sizeof(e));
+	__mdb_entry_fill_flags(&e, p->flags);
+	e.ifindex = p->port->dev->ifindex;
+	e.vid = p->addr.vid;
+	if (p->addr.proto == htons(ETH_P_IP))
+		e.addr.u.ip4 = p->addr.u.ip4;
+#if IS_ENABLED(CONFIG_IPV6)
+	if (p->addr.proto == htons(ETH_P_IPV6))
+		e.addr.u.ip6 = p->addr.u.ip6;
+#endif
+	e.addr.proto = p->addr.proto;
+	nest_ent = nla_nest_start_noflag(skb,
+					 MDBA_MDB_ENTRY_INFO);
+	if (!nest_ent)
+		return -EMSGSIZE;
+
+	if (nla_put_nohdr(skb, sizeof(e), &e) ||
+	    nla_put_u32(skb,
+			MDBA_MDB_EATTR_TIMER,
+			br_timer_value(&p->timer))) {
+		nla_nest_cancel(skb, nest_ent);
+		return -EMSGSIZE;
+	}
+	nla_nest_end(skb, nest_ent);
+
+	return 0;
+}
+
 static int br_mdb_fill_info(struct sk_buff *skb, struct netlink_callback *cb,
 			    struct net_device *dev)
 {
@@ -95,7 +129,6 @@ static int br_mdb_fill_info(struct sk_buff *skb, struct netlink_callback *cb,
 	hlist_for_each_entry_rcu(mp, &br->mdb_list, mdb_node) {
 		struct net_bridge_port_group *p;
 		struct net_bridge_port_group __rcu **pp;
-		struct net_bridge_port *port;
 
 		if (idx < s_idx)
 			goto skip;
@@ -108,41 +141,14 @@ static int br_mdb_fill_info(struct sk_buff *skb, struct netlink_callback *cb,
 
 		for (pp = &mp->ports; (p = rcu_dereference(*pp)) != NULL;
 		      pp = &p->next) {
-			struct nlattr *nest_ent;
-			struct br_mdb_entry e;
-
-			port = p->port;
-			if (!port)
+			if (!p->port)
 				continue;
 
-			memset(&e, 0, sizeof(e));
-			e.ifindex = port->dev->ifindex;
-			e.vid = p->addr.vid;
-			__mdb_entry_fill_flags(&e, p->flags);
-			if (p->addr.proto == htons(ETH_P_IP))
-				e.addr.u.ip4 = p->addr.u.ip4;
-#if IS_ENABLED(CONFIG_IPV6)
-			if (p->addr.proto == htons(ETH_P_IPV6))
-				e.addr.u.ip6 = p->addr.u.ip6;
-#endif
-			e.addr.proto = p->addr.proto;
-			nest_ent = nla_nest_start_noflag(skb,
-							 MDBA_MDB_ENTRY_INFO);
-			if (!nest_ent) {
-				nla_nest_cancel(skb, nest2);
-				err = -EMSGSIZE;
-				goto out;
-			}
-			if (nla_put_nohdr(skb, sizeof(e), &e) ||
-			    nla_put_u32(skb,
-					MDBA_MDB_EATTR_TIMER,
-					br_timer_value(&p->timer))) {
-				nla_nest_cancel(skb, nest_ent);
+			err = __mdb_fill_info(skb, p);
+			if (err) {
 				nla_nest_cancel(skb, nest2);
-				err = -EMSGSIZE;
 				goto out;
 			}
-			nla_nest_end(skb, nest_ent);
 		}
 		nla_nest_end(skb, nest2);
 skip:
-- 
2.21.0

