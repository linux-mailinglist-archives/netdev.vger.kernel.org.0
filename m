Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CBD6E878A
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 12:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732591AbfJ2Lyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 07:54:47 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:39892 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731648AbfJ2Lyr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 07:54:47 -0400
Received: by mail-lf1-f67.google.com with SMTP id 195so10288654lfj.6
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 04:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Alx6hwJFqQW86I9mK7sWZ4rlHiAVGWjJO9dOgPYX3IQ=;
        b=DX+diIgk94MzEFpurKXgwZUfqqbITZWORsqnY9rcz2UDh7eYO3yyCzSDJNc3IiyRkE
         lQVGNWhjL0/Zs1igUGeMwsrrPpqk+rgIw7lReYUl/D+xvxfvO5rlky3ceG/S6tCmriEP
         g9e5Cc6bXN4yjhzH9mF1xzSQTTBk+mXqqvTDQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Alx6hwJFqQW86I9mK7sWZ4rlHiAVGWjJO9dOgPYX3IQ=;
        b=Jo75rK+JKHKUr6JWJVCWsMC4mQDPRm0fBmzk2o36826IdljfNpWbdTMpulM27DwzPj
         UY/eux/47+W/pQYThXwwSQEXZYP2vcukH08WXBns0RZrZ2WfVuzhOt8Cin92e68PA9MW
         bIJf4vB/GI84rmALD5BlC6tLnoTnlGOfU9AIsbguvaukco/j6OvHS167eUaJjk2r+wY6
         Y+K2i9KOXoV7M0YK8ePJ0ZlEDYgbjXmdmGu8N7zjjqcPSM4enfbe44UrTWsinmwZHdeO
         pwdQLXT3Vd+VmyEfmWJTKBgrGZgVCzxCQcBdJ4umhXQUK9iJZDItk8Ms0hGII1XBl7V0
         cNXA==
X-Gm-Message-State: APjAAAV50Lagfx3PNCRtPXJXA4VrlwTOULX0cH11PVUuzi6ZVWNu1zOh
        ktDAP7KNB3XwLbbRoYlPMDU/3vcImQo=
X-Google-Smtp-Source: APXvYqyd688dx/2rsEqI+kl3+s5rhfCyxuhK3iWZEbwzmS1weC2bbcGt0DfwzIEPHjGP99RtxmjyKw==
X-Received: by 2002:a19:2d0c:: with SMTP id k12mr2250977lfj.38.1572350084962;
        Tue, 29 Oct 2019 04:54:44 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id r12sm11953310lfp.63.2019.10.29.04.54.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 04:54:44 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next 7/7] net: bridge: fdb: set flags directly in fdb_create
Date:   Tue, 29 Oct 2019 13:45:59 +0200
Message-Id: <20191029114559.28653-8-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191029114559.28653-1-nikolay@cumulusnetworks.com>
References: <20191029114559.28653-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No need to have separate arguments for each flag, just set the flags to
whatever was passed to fdb_create() before the fdb is published.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_fdb.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index d4f6b398303d..f244f2ac7156 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -491,8 +491,7 @@ static struct net_bridge_fdb_entry *fdb_create(struct net_bridge *br,
 					       struct net_bridge_port *source,
 					       const unsigned char *addr,
 					       __u16 vid,
-					       unsigned char is_local,
-					       unsigned char is_static)
+					       unsigned long flags)
 {
 	struct net_bridge_fdb_entry *fdb;
 
@@ -501,11 +500,7 @@ static struct net_bridge_fdb_entry *fdb_create(struct net_bridge *br,
 		memcpy(fdb->key.addr.addr, addr, ETH_ALEN);
 		fdb->dst = source;
 		fdb->key.vlan_id = vid;
-		fdb->flags = 0;
-		if (is_local)
-			set_bit(BR_FDB_LOCAL, &fdb->flags);
-		if (is_static)
-			set_bit(BR_FDB_STATIC, &fdb->flags);
+		fdb->flags = flags;
 		fdb->updated = fdb->used = jiffies;
 		if (rhashtable_lookup_insert_fast(&br->fdb_hash_tbl,
 						  &fdb->rhnode,
@@ -539,7 +534,8 @@ static int fdb_insert(struct net_bridge *br, struct net_bridge_port *source,
 		fdb_delete(br, fdb, true);
 	}
 
-	fdb = fdb_create(br, source, addr, vid, 1, 1);
+	fdb = fdb_create(br, source, addr, vid,
+			 BIT(BR_FDB_LOCAL) | BIT(BR_FDB_STATIC));
 	if (!fdb)
 		return -ENOMEM;
 
@@ -605,7 +601,7 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
 		}
 	} else {
 		spin_lock(&br->hash_lock);
-		fdb = fdb_create(br, source, addr, vid, 0, 0);
+		fdb = fdb_create(br, source, addr, vid, 0);
 		if (fdb) {
 			if (unlikely(added_by_user))
 				set_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
@@ -830,7 +826,7 @@ static int fdb_add_entry(struct net_bridge *br, struct net_bridge_port *source,
 		if (!(flags & NLM_F_CREATE))
 			return -ENOENT;
 
-		fdb = fdb_create(br, source, addr, vid, 0, 0);
+		fdb = fdb_create(br, source, addr, vid, 0);
 		if (!fdb)
 			return -ENOMEM;
 
@@ -1120,7 +1116,7 @@ int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
 
 	fdb = br_fdb_find(br, addr, vid);
 	if (!fdb) {
-		fdb = fdb_create(br, p, addr, vid, 0, 0);
+		fdb = fdb_create(br, p, addr, vid, 0);
 		if (!fdb) {
 			err = -ENOMEM;
 			goto err_unlock;
-- 
2.21.0

