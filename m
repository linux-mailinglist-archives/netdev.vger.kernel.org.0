Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6633E878B
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 12:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731885AbfJ2Lyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 07:54:46 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:44787 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730303AbfJ2Lyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 07:54:45 -0400
Received: by mail-lf1-f68.google.com with SMTP id v4so6867019lfd.11
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 04:54:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Hww5upUnq25xA8e1i+GROPBnDe7gAIXH4P2JTLAGhpo=;
        b=BmXmPPEMnBn8AMCYbbyh5WFo1JxDmxLI2YYcNXUvBkYjQe+fi3MAcbxX5UHJN96QDK
         AjcQ+GPml4hcVwUTuLCjG3OXEe+fp7W7lR0QxZ4AXdZ/F1hqrtFDpqQWtFu01gSIzPMM
         1UbUJSRrDj+3S7/T8u2OowAUyigkyP3eVIL4k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Hww5upUnq25xA8e1i+GROPBnDe7gAIXH4P2JTLAGhpo=;
        b=hVaSEZ+ZdPXJA4jQ7443Z8+h9HDgqwNkAQXvhZbjXhOxMNrQOCKCxtSHxU+86gXXnL
         0lNPKrSubM0B8i7520ed5b+unDUMFAC02G8fEaqvCIfAbQ1a4uXDq3iJ6z2+XKGxgu+9
         aoU4kuhwY+6ZUIs9pJ0KaDeXuIT5Ju3spUx7RLSi2JtD+JxMnfUj+zl/MXOsiSIihLuM
         AWXiLOMgEup4Gprdo7HigIXvHCzT+SLZNZlhZ5S9yJc2BPd3k8oKtYSgV7lYgBo/XZaT
         sP1DF1utiqVIYs4F7DZgGE0RFIN6K2j82Or7VuPtURdZA/r1aCO3Xu3iSch6vCHjdcaK
         jAdA==
X-Gm-Message-State: APjAAAWmw6RGO9HBXP5xl4pTPjZ2nGk9mb9oizcl7JRvVpY7uvuxHlwY
        hREUmTi4V7jBWWtqvJfiPuPuACRBo9w=
X-Google-Smtp-Source: APXvYqy4t8Rstd71DgKnxvB56Iq9HliPJWnWPTS3sMQFgUDX+sp7LA2zXXfn/ZqAA0SNdHaoHKSUmQ==
X-Received: by 2002:ac2:4822:: with SMTP id 2mr195898lft.115.1572350082308;
        Tue, 29 Oct 2019 04:54:42 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id r12sm11953310lfp.63.2019.10.29.04.54.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 04:54:41 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next 5/7] net: bridge: fdb: convert added_by_external_learn to use bitops
Date:   Tue, 29 Oct 2019 13:45:57 +0200
Message-Id: <20191029114559.28653-6-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191029114559.28653-1-nikolay@cumulusnetworks.com>
References: <20191029114559.28653-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the added_by_external_learn field to a flag and use bitops.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_fdb.c     | 19 +++++++++----------
 net/bridge/br_private.h |  4 ++--
 2 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 6f00cca4afc8..83d6be3f87f1 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -76,7 +76,7 @@ static inline int has_expired(const struct net_bridge *br,
 				  const struct net_bridge_fdb_entry *fdb)
 {
 	return !test_bit(BR_FDB_STATIC, &fdb->flags) &&
-	       !fdb->added_by_external_learn &&
+	       !test_bit(BR_FDB_ADDED_BY_EXT_LEARN, &fdb->flags) &&
 	       time_before_eq(fdb->updated + hold_time(br), jiffies);
 }
 
@@ -352,7 +352,7 @@ void br_fdb_cleanup(struct work_struct *work)
 		unsigned long this_timer;
 
 		if (test_bit(BR_FDB_STATIC, &f->flags) ||
-		    f->added_by_external_learn)
+		    test_bit(BR_FDB_ADDED_BY_EXT_LEARN, &f->flags))
 			continue;
 		this_timer = f->updated + delay;
 		if (time_after(this_timer, now)) {
@@ -506,7 +506,6 @@ static struct net_bridge_fdb_entry *fdb_create(struct net_bridge *br,
 			set_bit(BR_FDB_LOCAL, &fdb->flags);
 		if (is_static)
 			set_bit(BR_FDB_STATIC, &fdb->flags);
-		fdb->added_by_external_learn = 0;
 		fdb->offloaded = 0;
 		fdb->updated = fdb->used = jiffies;
 		if (rhashtable_lookup_insert_fast(&br->fdb_hash_tbl,
@@ -593,8 +592,8 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
 				fdb->dst = source;
 				fdb_modified = true;
 				/* Take over HW learned entry */
-				if (unlikely(fdb->added_by_external_learn))
-					fdb->added_by_external_learn = 0;
+				test_and_clear_bit(BR_FDB_ADDED_BY_EXT_LEARN,
+						   &fdb->flags);
 			}
 			if (now != fdb->updated)
 				fdb->updated = now;
@@ -659,7 +658,7 @@ static int fdb_fill_info(struct sk_buff *skb, const struct net_bridge *br,
 
 	if (fdb->offloaded)
 		ndm->ndm_flags |= NTF_OFFLOADED;
-	if (fdb->added_by_external_learn)
+	if (test_bit(BR_FDB_ADDED_BY_EXT_LEARN, &fdb->flags))
 		ndm->ndm_flags |= NTF_EXT_LEARNED;
 	if (test_bit(BR_FDB_STICKY, &fdb->flags))
 		ndm->ndm_flags |= NTF_STICKY;
@@ -1129,7 +1128,7 @@ int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
 		}
 		if (swdev_notify)
 			set_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
-		fdb->added_by_external_learn = 1;
+		set_bit(BR_FDB_ADDED_BY_EXT_LEARN, &fdb->flags);
 		fdb_notify(br, fdb, RTM_NEWNEIGH, swdev_notify);
 	} else {
 		fdb->updated = jiffies;
@@ -1139,12 +1138,12 @@ int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
 			modified = true;
 		}
 
-		if (fdb->added_by_external_learn) {
+		if (test_bit(BR_FDB_ADDED_BY_EXT_LEARN, &fdb->flags)) {
 			/* Refresh entry */
 			fdb->used = jiffies;
 		} else if (!test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags)) {
 			/* Take over SW learned entry */
-			fdb->added_by_external_learn = 1;
+			set_bit(BR_FDB_ADDED_BY_EXT_LEARN, &fdb->flags);
 			modified = true;
 		}
 
@@ -1171,7 +1170,7 @@ int br_fdb_external_learn_del(struct net_bridge *br, struct net_bridge_port *p,
 	spin_lock_bh(&br->hash_lock);
 
 	fdb = br_fdb_find(br, addr, vid);
-	if (fdb && fdb->added_by_external_learn)
+	if (fdb && test_bit(BR_FDB_ADDED_BY_EXT_LEARN, &fdb->flags))
 		fdb_delete(br, fdb, swdev_notify);
 	else
 		err = -ENOENT;
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index bf4a4d1cc3bb..cf325177a34e 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -178,6 +178,7 @@ enum {
 	BR_FDB_STATIC,
 	BR_FDB_STICKY,
 	BR_FDB_ADDED_BY_USER,
+	BR_FDB_ADDED_BY_EXT_LEARN,
 };
 
 struct net_bridge_fdb_key {
@@ -192,8 +193,7 @@ struct net_bridge_fdb_entry {
 	struct net_bridge_fdb_key	key;
 	struct hlist_node		fdb_node;
 	unsigned long			flags;
-	unsigned char			added_by_external_learn:1,
-					offloaded:1;
+	unsigned char			offloaded:1;
 
 	/* write-heavy members should not affect lookups */
 	unsigned long			updated ____cacheline_aligned_in_smp;
-- 
2.21.0

