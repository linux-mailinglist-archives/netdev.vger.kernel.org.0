Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C63CBE878C
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 12:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732744AbfJ2Lyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 07:54:50 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:47003 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731449AbfJ2Lyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 07:54:46 -0400
Received: by mail-lf1-f67.google.com with SMTP id t8so10254651lfc.13
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 04:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Cc9Db+iLV3di9vuttgRlVWQ8N32hvZ1kSSyiv1aEwhw=;
        b=Mu5HSinoEpi79iLf9tMaiKVBJCR/ISpL6BaKn3OnjA2EOEXUIO7twDcbGa9TC56Wkt
         F4ALy14FU8q6B81aECLZgRaXgzhA6eL6bWRJ+AZMttX6zHUiCoauB6lGCvjcBhuf9kK/
         lPc4SgxkfqFj2UrFLA9jg4qi0ktismLAh0wH8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Cc9Db+iLV3di9vuttgRlVWQ8N32hvZ1kSSyiv1aEwhw=;
        b=DrfszMdWJLMzOH0lcvQVKymTmUy+XXpdI8k/HRHxEJHU9d5QfTL+htPoItOIrKDLPe
         IK69pbok9wNBsyGGiOEor578p2zXhGw/ptFSoWMNskmgHNH1B6Z6LyFqKnvMZI5lRVOw
         8PC6Eh8M4FXDkVFtHiDOvGgktLqgMiWgYMbynI9mDUNg9xdqeJFfsAhj/SEDM8H3unrW
         ErzhY8poERT7RTisWv4W+uxxC8o3c5bovQuFfZgna98oRY1afervU002G8nEQX5TDG8v
         F199puvXwm8lmC6rE2aw9u520bjOwuaAXn/FVTQuVtl3iGn49FI1tpgpkyjvv1mmaZLf
         CbpQ==
X-Gm-Message-State: APjAAAX+ZuRBsyigNJGFYtN7DNtfcg6NMNNtaOJH+YmTXGra8t9v1ws4
        2pNBxUfcRg09P9KKJiEX0MIlWiyMqrU=
X-Google-Smtp-Source: APXvYqwpPfHVx9OjblYZTsiudgRBu8idT9OggbLd4w3lzZUNWRCk/2kHApu+RjRA+wcukmJcGlyn+g==
X-Received: by 2002:a19:dc14:: with SMTP id t20mr2251956lfg.21.1572350083668;
        Tue, 29 Oct 2019 04:54:43 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id r12sm11953310lfp.63.2019.10.29.04.54.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 04:54:42 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next 6/7] net: bridge: fdb: convert offloaded to use bitops
Date:   Tue, 29 Oct 2019 13:45:58 +0200
Message-Id: <20191029114559.28653-7-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191029114559.28653-1-nikolay@cumulusnetworks.com>
References: <20191029114559.28653-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the offloaded field to a flag and use bitops.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_fdb.c       | 9 ++++-----
 net/bridge/br_private.h   | 2 +-
 net/bridge/br_switchdev.c | 6 ++++--
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 83d6be3f87f1..d4f6b398303d 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -506,7 +506,6 @@ static struct net_bridge_fdb_entry *fdb_create(struct net_bridge *br,
 			set_bit(BR_FDB_LOCAL, &fdb->flags);
 		if (is_static)
 			set_bit(BR_FDB_STATIC, &fdb->flags);
-		fdb->offloaded = 0;
 		fdb->updated = fdb->used = jiffies;
 		if (rhashtable_lookup_insert_fast(&br->fdb_hash_tbl,
 						  &fdb->rhnode,
@@ -656,7 +655,7 @@ static int fdb_fill_info(struct sk_buff *skb, const struct net_bridge *br,
 	ndm->ndm_ifindex = fdb->dst ? fdb->dst->dev->ifindex : br->dev->ifindex;
 	ndm->ndm_state   = fdb_to_nud(br, fdb);
 
-	if (fdb->offloaded)
+	if (test_bit(BR_FDB_OFFLOADED, &fdb->flags))
 		ndm->ndm_flags |= NTF_OFFLOADED;
 	if (test_bit(BR_FDB_ADDED_BY_EXT_LEARN, &fdb->flags))
 		ndm->ndm_flags |= NTF_EXT_LEARNED;
@@ -1188,8 +1187,8 @@ void br_fdb_offloaded_set(struct net_bridge *br, struct net_bridge_port *p,
 	spin_lock_bh(&br->hash_lock);
 
 	fdb = br_fdb_find(br, addr, vid);
-	if (fdb)
-		fdb->offloaded = offloaded;
+	if (fdb && offloaded != test_bit(BR_FDB_OFFLOADED, &fdb->flags))
+		change_bit(BR_FDB_OFFLOADED, &fdb->flags);
 
 	spin_unlock_bh(&br->hash_lock);
 }
@@ -1208,7 +1207,7 @@ void br_fdb_clear_offload(const struct net_device *dev, u16 vid)
 	spin_lock_bh(&p->br->hash_lock);
 	hlist_for_each_entry(f, &p->br->fdb_list, fdb_node) {
 		if (f->dst == p && f->key.vlan_id == vid)
-			f->offloaded = 0;
+			clear_bit(BR_FDB_OFFLOADED, &f->flags);
 	}
 	spin_unlock_bh(&p->br->hash_lock);
 }
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index cf325177a34e..f4754bf7f4bd 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -179,6 +179,7 @@ enum {
 	BR_FDB_STICKY,
 	BR_FDB_ADDED_BY_USER,
 	BR_FDB_ADDED_BY_EXT_LEARN,
+	BR_FDB_OFFLOADED,
 };
 
 struct net_bridge_fdb_key {
@@ -193,7 +194,6 @@ struct net_bridge_fdb_entry {
 	struct net_bridge_fdb_key	key;
 	struct hlist_node		fdb_node;
 	unsigned long			flags;
-	unsigned char			offloaded:1;
 
 	/* write-heavy members should not affect lookups */
 	unsigned long			updated ____cacheline_aligned_in_smp;
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 5010fbf74778..015209bf44aa 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -131,7 +131,8 @@ br_switchdev_fdb_notify(const struct net_bridge_fdb_entry *fdb, int type)
 						fdb->dst->dev,
 						test_bit(BR_FDB_ADDED_BY_USER,
 							 &fdb->flags),
-						fdb->offloaded);
+						test_bit(BR_FDB_OFFLOADED,
+							 &fdb->flags));
 		break;
 	case RTM_NEWNEIGH:
 		br_switchdev_fdb_call_notifiers(true, fdb->key.addr.addr,
@@ -139,7 +140,8 @@ br_switchdev_fdb_notify(const struct net_bridge_fdb_entry *fdb, int type)
 						fdb->dst->dev,
 						test_bit(BR_FDB_ADDED_BY_USER,
 							 &fdb->flags),
-						fdb->offloaded);
+						test_bit(BR_FDB_OFFLOADED,
+							 &fdb->flags));
 		break;
 	}
 }
-- 
2.21.0

