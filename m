Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66EC9E8785
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 12:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729183AbfJ2Lyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 07:54:38 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:43188 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfJ2Lyi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 07:54:38 -0400
Received: by mail-lj1-f195.google.com with SMTP id s4so14037098ljj.10
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 04:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I3GZTkmCUTgzs3luWXRqxZVOgjcYi99lwM4VQeSgHV0=;
        b=Jd1Gzx+onGddNKmbsaI3Yq00Wk3a2LfzT232Y1drs+RvLuvy4hUEE94lmpbBt6O6HK
         gIFob1B/fEsKt+Bz7nyUffSgSO4PR9NwGyvSS4f4qfxZIzRvRvJKy+cQ6hwOXJA/nqFW
         xykibLZaoRsIiEVFxcFU2oxhJwNJY6q9vC2qE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I3GZTkmCUTgzs3luWXRqxZVOgjcYi99lwM4VQeSgHV0=;
        b=aYHCjxYokirXSP1E/SUNfWz2EblAbfxlPVQy9OnXxeoG3LTN/Q4wxzF1QVThSkqS4o
         jqlEma3efRYP6A4YRba86JxPO18d+ylRu080sGdGEev+h36XEV9APQr1qlt+nnYhkEkq
         tEI0fqEJ6rKjLwQ1OgkL2tSViuBxBf9G/S1RQTw7wc+93IkjhFf+vbfkyDnbbgYMW/nL
         6Fdi7JMFlZ87YIoZjxBqSiVl1vPYajWUEZrYZZyDd+0U0yZXFby3MicEk13IKPlHc0Iq
         V1DUaN+nNz5R71cdONoY1XHcDVEa3enrntqIaTP7fU5s90yfh0SChZXPmyMBj9q/U7LQ
         oGDw==
X-Gm-Message-State: APjAAAW7NVKIU/2Ecvn0B54NfYuDcCixjw9ImISIMod20Ybz7bHFNjET
        mKcX0lb3sg0qWdAhB1gtFH3R5PRQhaA=
X-Google-Smtp-Source: APXvYqzzUtJumjzhEAPX0kG7hKFkIWZoW2PWM6PVAQ/wy7D5yMhqMAGgKnYGjgGUYLEJGeench1Zow==
X-Received: by 2002:a2e:3919:: with SMTP id g25mr2397358lja.232.1572350075765;
        Tue, 29 Oct 2019 04:54:35 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id r12sm11953310lfp.63.2019.10.29.04.54.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 04:54:35 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next 1/7] net: bridge: fdb: convert is_local to bitops
Date:   Tue, 29 Oct 2019 13:45:53 +0200
Message-Id: <20191029114559.28653-2-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191029114559.28653-1-nikolay@cumulusnetworks.com>
References: <20191029114559.28653-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch adds a new fdb flags field in the hole between the two cache
lines and uses it to convert is_local to bitops.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_fdb.c     | 32 +++++++++++++++++++-------------
 net/bridge/br_input.c   |  2 +-
 net/bridge/br_private.h |  9 +++++++--
 3 files changed, 27 insertions(+), 16 deletions(-)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index b1d3248c0252..e67d5eb8bc1d 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -250,7 +250,8 @@ void br_fdb_find_delete_local(struct net_bridge *br,
 
 	spin_lock_bh(&br->hash_lock);
 	f = br_fdb_find(br, addr, vid);
-	if (f && f->is_local && !f->added_by_user && f->dst == p)
+	if (f && test_bit(BR_FDB_LOCAL, &f->flags) &&
+	    !f->added_by_user && f->dst == p)
 		fdb_delete_local(br, p, f);
 	spin_unlock_bh(&br->hash_lock);
 }
@@ -265,7 +266,8 @@ void br_fdb_changeaddr(struct net_bridge_port *p, const unsigned char *newaddr)
 	spin_lock_bh(&br->hash_lock);
 	vg = nbp_vlan_group(p);
 	hlist_for_each_entry(f, &br->fdb_list, fdb_node) {
-		if (f->dst == p && f->is_local && !f->added_by_user) {
+		if (f->dst == p && test_bit(BR_FDB_LOCAL, &f->flags) &&
+		    !f->added_by_user) {
 			/* delete old one */
 			fdb_delete_local(br, p, f);
 
@@ -306,7 +308,8 @@ void br_fdb_change_mac_address(struct net_bridge *br, const u8 *newaddr)
 
 	/* If old entry was unassociated with any port, then delete it. */
 	f = br_fdb_find(br, br->dev->dev_addr, 0);
-	if (f && f->is_local && !f->dst && !f->added_by_user)
+	if (f && test_bit(BR_FDB_LOCAL, &f->flags) &&
+	    !f->dst && !f->added_by_user)
 		fdb_delete_local(br, NULL, f);
 
 	fdb_insert(br, NULL, newaddr, 0);
@@ -321,7 +324,8 @@ void br_fdb_change_mac_address(struct net_bridge *br, const u8 *newaddr)
 		if (!br_vlan_should_use(v))
 			continue;
 		f = br_fdb_find(br, br->dev->dev_addr, v->vid);
-		if (f && f->is_local && !f->dst && !f->added_by_user)
+		if (f && test_bit(BR_FDB_LOCAL, &f->flags) &&
+		    !f->dst && !f->added_by_user)
 			fdb_delete_local(br, NULL, f);
 		fdb_insert(br, NULL, newaddr, v->vid);
 	}
@@ -400,7 +404,7 @@ void br_fdb_delete_by_port(struct net_bridge *br,
 			if (f->is_static || (vid && f->key.vlan_id != vid))
 				continue;
 
-		if (f->is_local)
+		if (test_bit(BR_FDB_LOCAL, &f->flags))
 			fdb_delete_local(br, p, f);
 		else
 			fdb_delete(br, f, true);
@@ -469,7 +473,7 @@ int br_fdb_fillbuf(struct net_bridge *br, void *buf,
 		fe->port_no = f->dst->port_no;
 		fe->port_hi = f->dst->port_no >> 8;
 
-		fe->is_local = f->is_local;
+		fe->is_local = test_bit(BR_FDB_LOCAL, &f->flags);
 		if (!f->is_static)
 			fe->ageing_timer_value = jiffies_delta_to_clock_t(jiffies - f->updated);
 		++fe;
@@ -494,7 +498,9 @@ static struct net_bridge_fdb_entry *fdb_create(struct net_bridge *br,
 		memcpy(fdb->key.addr.addr, addr, ETH_ALEN);
 		fdb->dst = source;
 		fdb->key.vlan_id = vid;
-		fdb->is_local = is_local;
+		fdb->flags = 0;
+		if (is_local)
+			set_bit(BR_FDB_LOCAL, &fdb->flags);
 		fdb->is_static = is_static;
 		fdb->added_by_user = 0;
 		fdb->added_by_external_learn = 0;
@@ -526,7 +532,7 @@ static int fdb_insert(struct net_bridge *br, struct net_bridge_port *source,
 		/* it is okay to have multiple ports with same
 		 * address, just use the first one.
 		 */
-		if (fdb->is_local)
+		if (test_bit(BR_FDB_LOCAL, &fdb->flags))
 			return 0;
 		br_warn(br, "adding interface %s with same address as a received packet (addr:%pM, vlan:%u)\n",
 		       source ? source->dev->name : br->dev->name, addr, vid);
@@ -572,7 +578,7 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
 	fdb = fdb_find_rcu(&br->fdb_hash_tbl, addr, vid);
 	if (likely(fdb)) {
 		/* attempt to update an entry for a local interface */
-		if (unlikely(fdb->is_local)) {
+		if (unlikely(test_bit(BR_FDB_LOCAL, &fdb->flags))) {
 			if (net_ratelimit())
 				br_warn(br, "received packet on %s with own address as source address (addr:%pM, vlan:%u)\n",
 					source->dev->name, addr, vid);
@@ -616,7 +622,7 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
 static int fdb_to_nud(const struct net_bridge *br,
 		      const struct net_bridge_fdb_entry *fdb)
 {
-	if (fdb->is_local)
+	if (test_bit(BR_FDB_LOCAL, &fdb->flags))
 		return NUD_PERMANENT;
 	else if (fdb->is_static)
 		return NUD_NOARP;
@@ -840,19 +846,19 @@ static int fdb_add_entry(struct net_bridge *br, struct net_bridge_port *source,
 
 	if (fdb_to_nud(br, fdb) != state) {
 		if (state & NUD_PERMANENT) {
-			fdb->is_local = 1;
+			set_bit(BR_FDB_LOCAL, &fdb->flags);
 			if (!fdb->is_static) {
 				fdb->is_static = 1;
 				fdb_add_hw_addr(br, addr);
 			}
 		} else if (state & NUD_NOARP) {
-			fdb->is_local = 0;
+			clear_bit(BR_FDB_LOCAL, &fdb->flags);
 			if (!fdb->is_static) {
 				fdb->is_static = 1;
 				fdb_add_hw_addr(br, addr);
 			}
 		} else {
-			fdb->is_local = 0;
+			clear_bit(BR_FDB_LOCAL, &fdb->flags);
 			if (fdb->is_static) {
 				fdb->is_static = 0;
 				fdb_del_hw_addr(br, addr);
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 09b1dd8cd853..7f5f646dba6e 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -151,7 +151,7 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 	if (dst) {
 		unsigned long now = jiffies;
 
-		if (dst->is_local)
+		if (test_bit(BR_FDB_LOCAL, &dst->flags))
 			return br_pass_frame_up(skb);
 
 		if (now != dst->used)
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index ce2ab14ee605..888cbe9c639a 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -172,6 +172,11 @@ struct net_bridge_vlan_group {
 	u16				pvid;
 };
 
+/* bridge fdb flags */
+enum {
+	BR_FDB_LOCAL,
+};
+
 struct net_bridge_fdb_key {
 	mac_addr addr;
 	u16 vlan_id;
@@ -183,8 +188,8 @@ struct net_bridge_fdb_entry {
 
 	struct net_bridge_fdb_key	key;
 	struct hlist_node		fdb_node;
-	unsigned char			is_local:1,
-					is_static:1,
+	unsigned long			flags;
+	unsigned char			is_static:1,
 					is_sticky:1,
 					added_by_user:1,
 					added_by_external_learn:1,
-- 
2.21.0

