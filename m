Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC1BEC2D2
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 13:39:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730436AbfKAMjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 08:39:01 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:35141 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727329AbfKAMjB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 08:39:01 -0400
Received: by mail-lj1-f195.google.com with SMTP id r7so1432621ljg.2
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 05:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x9TuCdX9GEGxaXl3QkkV+t/xdFViqljG9o/T16XlMAI=;
        b=e/T53YKK5rhC6nUDx55dHE/D1PSESCCFoqzKlZf8IXub9dqfOGutKAWCc5yHvhRMcH
         PHfiK2QteJnkXG8DGl1kVF9kw153uTtUl48CqBoKqwNycSFMMDk8f2kBtJDT8sVu27cu
         g6iIlQFVouTGs9fI/qLuHqF9UJnIa/xUwJt38=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x9TuCdX9GEGxaXl3QkkV+t/xdFViqljG9o/T16XlMAI=;
        b=ZGajuSpk9oa9VELCFHCHS/00pUVJKRgCrtipqgNMd5f+bivleIgFUwaY5uonUfgUc7
         XGZ27uO+rhSLLE/XuwmeLrYNhCXhUZNNF9JoMNPnoNCdkRsUuDgjEReZr+7DlPXjG3SU
         831e3p8mXQzPScW9m5PoHX6zB8ZWSXwSEJemCK01Mfo3cg1N2APueLCbY74u8wqP0JnK
         rOaOLSed/r9Xbe5073g7HQImrg5YyDm1SgDKCPYxyQM/WqrquJncdsygI4u/lYciz0sM
         U/u+AKc7+JUjmskEdCKi+aeRXAYjzZLTEamUUUsESTatwJFMIUlO71OmCPa5To+fJNz/
         MWeA==
X-Gm-Message-State: APjAAAV6Mpw6pVv9PaNl1zagGeD6xRyg7iRFx7SbTKWfSf56I8Q4D/FX
        D6KjLa3aF5d9odaVTOoRVGD6q1CTEfM=
X-Google-Smtp-Source: APXvYqyWL3iFX/LAp0txyZlMiWpSh8mnuqv/RdhbvWfChVuT/wlfG/eT+WGA/INljC7rlegIxLeqGQ==
X-Received: by 2002:a2e:9449:: with SMTP id o9mr7844192ljh.110.1572611937364;
        Fri, 01 Nov 2019 05:38:57 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id f25sm2349909ljp.100.2019.11.01.05.38.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 05:38:56 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, bridge@lists.linux-foundation.org,
        davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next 1/3] net: bridge: fdb: br_fdb_update can take flags directly
Date:   Fri,  1 Nov 2019 14:38:41 +0200
Message-Id: <20191101123844.17518-2-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191101123844.17518-1-nikolay@cumulusnetworks.com>
References: <20191101123844.17518-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we modify br_fdb_update() to take flags directly we can get rid of
one test and one atomic bitop in the learning path.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 The trace line was over 80 chars before, now it's very close and doesn't
 look good IMO when split.

 include/trace/events/bridge.h | 12 ++++++------
 net/bridge/br_fdb.c           | 15 ++++++---------
 net/bridge/br_input.c         |  4 ++--
 net/bridge/br_private.h       |  2 +-
 4 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/include/trace/events/bridge.h b/include/trace/events/bridge.h
index 8ea966448b58..6b200059c2c5 100644
--- a/include/trace/events/bridge.h
+++ b/include/trace/events/bridge.h
@@ -95,16 +95,16 @@ TRACE_EVENT(fdb_delete,
 TRACE_EVENT(br_fdb_update,
 
 	TP_PROTO(struct net_bridge *br, struct net_bridge_port *source,
-		 const unsigned char *addr, u16 vid, bool added_by_user),
+		 const unsigned char *addr, u16 vid, unsigned long flags),
 
-	TP_ARGS(br, source, addr, vid, added_by_user),
+	TP_ARGS(br, source, addr, vid, flags),
 
 	TP_STRUCT__entry(
 		__string(br_dev, br->dev->name)
 		__string(dev, source->dev->name)
 		__array(unsigned char, addr, ETH_ALEN)
 		__field(u16, vid)
-		__field(bool, added_by_user)
+		__field(unsigned long, flags)
 	),
 
 	TP_fast_assign(
@@ -112,14 +112,14 @@ TRACE_EVENT(br_fdb_update,
 		__assign_str(dev, source->dev->name);
 		memcpy(__entry->addr, addr, ETH_ALEN);
 		__entry->vid = vid;
-		__entry->added_by_user = added_by_user;
+		__entry->flags = flags;
 	),
 
-	TP_printk("br_dev %s source %s addr %02x:%02x:%02x:%02x:%02x:%02x vid %u added_by_user %d",
+	TP_printk("br_dev %s source %s addr %02x:%02x:%02x:%02x:%02x:%02x vid %u flags 0x%lx",
 		  __get_str(br_dev), __get_str(dev), __entry->addr[0],
 		  __entry->addr[1], __entry->addr[2], __entry->addr[3],
 		  __entry->addr[4], __entry->addr[5], __entry->vid,
-		  __entry->added_by_user)
+		  __entry->flags)
 );
 
 
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index f244f2ac7156..b37e0f4c1b2b 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -557,7 +557,7 @@ int br_fdb_insert(struct net_bridge *br, struct net_bridge_port *source,
 }
 
 void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
-		   const unsigned char *addr, u16 vid, bool added_by_user)
+		   const unsigned char *addr, u16 vid, unsigned long flags)
 {
 	struct net_bridge_fdb_entry *fdb;
 	bool fdb_modified = false;
@@ -592,21 +592,18 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
 			}
 			if (now != fdb->updated)
 				fdb->updated = now;
-			if (unlikely(added_by_user))
+			if (unlikely(test_bit(BR_FDB_ADDED_BY_USER, &flags)))
 				set_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
 			if (unlikely(fdb_modified)) {
-				trace_br_fdb_update(br, source, addr, vid, added_by_user);
+				trace_br_fdb_update(br, source, addr, vid, flags);
 				fdb_notify(br, fdb, RTM_NEWNEIGH, true);
 			}
 		}
 	} else {
 		spin_lock(&br->hash_lock);
-		fdb = fdb_create(br, source, addr, vid, 0);
+		fdb = fdb_create(br, source, addr, vid, flags);
 		if (fdb) {
-			if (unlikely(added_by_user))
-				set_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
-			trace_br_fdb_update(br, source, addr, vid,
-					    added_by_user);
+			trace_br_fdb_update(br, source, addr, vid, flags);
 			fdb_notify(br, fdb, RTM_NEWNEIGH, true);
 		}
 		/* else  we lose race and someone else inserts
@@ -889,7 +886,7 @@ static int __br_fdb_add(struct ndmsg *ndm, struct net_bridge *br,
 		}
 		local_bh_disable();
 		rcu_read_lock();
-		br_fdb_update(br, p, addr, vid, true);
+		br_fdb_update(br, p, addr, vid, BIT(BR_FDB_ADDED_BY_USER));
 		rcu_read_unlock();
 		local_bh_enable();
 	} else if (ndm->ndm_flags & NTF_EXT_LEARNED) {
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 7f5f646dba6e..f37b05090f45 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -88,7 +88,7 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 	/* insert into forwarding database after filtering to avoid spoofing */
 	br = p->br;
 	if (p->flags & BR_LEARNING)
-		br_fdb_update(br, p, eth_hdr(skb)->h_source, vid, false);
+		br_fdb_update(br, p, eth_hdr(skb)->h_source, vid, 0);
 
 	local_rcv = !!(br->dev->flags & IFF_PROMISC);
 	if (is_multicast_ether_addr(eth_hdr(skb)->h_dest)) {
@@ -184,7 +184,7 @@ static void __br_handle_local_finish(struct sk_buff *skb)
 	if ((p->flags & BR_LEARNING) &&
 	    !br_opt_get(p->br, BROPT_NO_LL_LEARN) &&
 	    br_should_learn(p, skb, &vid))
-		br_fdb_update(p->br, p, eth_hdr(skb)->h_source, vid, false);
+		br_fdb_update(p->br, p, eth_hdr(skb)->h_source, vid, 0);
 }
 
 /* note: already called with rcu_read_lock */
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index f4754bf7f4bd..08742bff9bf0 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -571,7 +571,7 @@ int br_fdb_fillbuf(struct net_bridge *br, void *buf, unsigned long count,
 int br_fdb_insert(struct net_bridge *br, struct net_bridge_port *source,
 		  const unsigned char *addr, u16 vid);
 void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
-		   const unsigned char *addr, u16 vid, bool added_by_user);
+		   const unsigned char *addr, u16 vid, unsigned long flags);
 
 int br_fdb_delete(struct ndmsg *ndm, struct nlattr *tb[],
 		  struct net_device *dev, const unsigned char *addr, u16 vid);
-- 
2.21.0

