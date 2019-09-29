Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16382C1A1C
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 04:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729383AbfI3CJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Sep 2019 22:09:09 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35778 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729329AbfI3CJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Sep 2019 22:09:08 -0400
Received: by mail-pf1-f194.google.com with SMTP id 205so4682252pfw.2
        for <netdev@vger.kernel.org>; Sun, 29 Sep 2019 19:09:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MfKiaD7BLDCj9sb393V4hNHiOobedPu8xnBx7OnK1E0=;
        b=G0r8JUgg586iEMATkDQ+j1c9J/emmG4kV1zt/OhoATyW6h8FWVgFyDBQz1PA5sOs56
         ezdW4TpT/AVH6n7ke8oqriVEbzMBpZhkxR6FZN3WMWQCnAyiiAweKu9TYz1WH1wxKToZ
         Sz4q6fdiWkX2DGasAoj8RsYNFbxknTJtwh3Q3egkM68nvvaMrSfi/FjLdbxakollXte9
         AeEOo4w+EBk1RNRdRTpw5ZmhPzlW8V4RR6W2ZZdkve/gHeHzcHrhIWU8w95idgO/smKp
         8zj/LJHmUpnMGj/cnby190cGhYt0S2lIYUU+hxdBZgg8ROaS1ewr+9yktYv8d7d4/HnX
         u6fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MfKiaD7BLDCj9sb393V4hNHiOobedPu8xnBx7OnK1E0=;
        b=qF0U++sVT+mtqJ4NQTNnevXwBpxrulz3FkFnYRTmW1sMBXao6ZXCZLEajd6sRfJkRX
         OHA6RkHugE2nZyjsRo5nGQilZtc3PH3BvqbK1vT9nM3V+z89HGUEQqJA4lsqiOI+yIoK
         ytOcrlnl7z706S1Y3VY4TIhMKfWKxayOzJ+645pBNBLwCOmZk4/Tmx5pnuNSGWysXC5A
         ckopBTmRMA4/suzt8Qqnhj/9zSm0xHIUtJyVWm+3xVV87Xe/At8Q45n3xHQv0t/qTDnK
         ydbqF+pUBr66HekoFKY4+NOKSnc6CJ3mkmmsxHHJGLw/XnjGNIsO43xZVGBFaeKxfFBK
         8+Kg==
X-Gm-Message-State: APjAAAWrieGmzobtETPBFAcBrIwt+wf6U2IMx1I746JErGz6HBuf6J5I
        essZLzxgRy48B8Kwf6AfTNk=
X-Google-Smtp-Source: APXvYqxerPlKvn7LzUcK8DmsolEscO37X2QOUlWxthYrg1nyHl5fnBXh78+U4CTtgqheNkPpbFypPw==
X-Received: by 2002:aa7:95a7:: with SMTP id a7mr18906916pfk.158.1569809347249;
        Sun, 29 Sep 2019 19:09:07 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id d69sm9941635pfd.175.2019.09.29.19.09.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 29 Sep 2019 19:09:06 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     gvrose8192@gmail.com, pshelar@ovn.org
Cc:     netdev@vger.kernel.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next 4/9] net: openvswitch: optimize flow mask cache hash collision
Date:   Mon, 30 Sep 2019 01:10:01 +0800
Message-Id: <1569777006-7435-5-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1569777006-7435-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1569777006-7435-1-git-send-email-xiangxia.m.yue@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Port the codes to linux upstream and with little changes.

Pravin B Shelar, says:
| In case hash collision on mask cache, OVS does extra flow
| lookup. Following patch avoid it.

Link: https://github.com/openvswitch/ovs/commit/0e6efbe2712da03522532dc5e84806a96f6a0dd1
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 net/openvswitch/flow_table.c | 95 ++++++++++++++++++++++++--------------------
 1 file changed, 53 insertions(+), 42 deletions(-)

diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index 9c72aab..e59fac5 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -516,6 +516,9 @@ static struct sw_flow *masked_flow_lookup(struct table_instance *ti,
 	return NULL;
 }
 
+/* Flow lookup does full lookup on flow table. It starts with
+ * mask from index passed in *index.
+ */
 static struct sw_flow *flow_lookup(struct flow_table *tbl,
 				   struct table_instance *ti,
 				   struct mask_array *ma,
@@ -524,18 +527,31 @@ static struct sw_flow *flow_lookup(struct flow_table *tbl,
 				   u32 *index)
 {
 	struct sw_flow *flow;
+	struct sw_flow_mask *mask;
 	int i;
 
-	for (i = 0; i < ma->max; i++)  {
-		struct sw_flow_mask *mask;
-
-		mask = rcu_dereference_ovsl(ma->masks[i]);
+	if (*index < ma->max) {
+		mask = rcu_dereference_ovsl(ma->masks[*index]);
 		if (mask) {
 			flow = masked_flow_lookup(ti, key, mask, n_mask_hit);
-			if (flow) { /* Found */
-				*index = i;
+			if (flow)
 				return flow;
-			}
+		}
+	}
+
+	for (i = 0; i < ma->max; i++)  {
+
+		if (i == *index)
+			continue;
+
+		mask = rcu_dereference_ovsl(ma->masks[i]);
+		if (!mask)
+			continue;
+
+		flow = masked_flow_lookup(ti, key, mask, n_mask_hit);
+		if (flow) { /* Found */
+			*index = i;
+			return flow;
 		}
 	}
 
@@ -554,58 +570,54 @@ struct sw_flow *ovs_flow_tbl_lookup_stats(struct flow_table *tbl,
 					  u32 skb_hash,
 					  u32 *n_mask_hit)
 {
-	struct mask_array *ma = rcu_dereference_ovsl(tbl->mask_array);
-	struct table_instance *ti = rcu_dereference_ovsl(tbl->ti);
-	struct mask_cache_entry  *entries, *ce, *del;
+	struct mask_array *ma = rcu_dereference(tbl->mask_array);
+	struct table_instance *ti = rcu_dereference(tbl->ti);
+	struct mask_cache_entry *entries, *ce;
 	struct sw_flow *flow;
-	u32 hash = skb_hash;
+	u32 hash;
 	int seg;
 
 	*n_mask_hit = 0;
 	if (unlikely(!skb_hash)) {
-		u32 __always_unused mask_index;
+		u32 mask_index = 0;
 
 		return flow_lookup(tbl, ti, ma, key, n_mask_hit, &mask_index);
 	}
 
-	del = NULL;
+	/* Pre and post recirulation flows usually have the same skb_hash
+	 * value. To avoid hash collisions, rehash the 'skb_hash' with
+	 * 'recirc_id'.  */
+	if (key->recirc_id)
+		skb_hash = jhash_1word(skb_hash, key->recirc_id);
+
+	ce = NULL;
+	hash = skb_hash;
 	entries = this_cpu_ptr(tbl->mask_cache);
 
+	/* Find the cache entry 'ce' to operate on. */
 	for (seg = 0; seg < MC_HASH_SEGS; seg++) {
-		int index;
-
-		index = hash & (MC_HASH_ENTRIES - 1);
-		ce = &entries[index];
-
-		if (ce->skb_hash == skb_hash) {
-			struct sw_flow_mask *mask;
-			struct sw_flow *flow;
-
-			mask = rcu_dereference_ovsl(ma->masks[ce->mask_index]);
-			if (mask) {
-				flow = masked_flow_lookup(ti, key, mask,
-							  n_mask_hit);
-				if (flow)  /* Found */
-					return flow;
-			}
-
-			del = ce;
-			break;
+		int index = hash & (MC_HASH_ENTRIES - 1);
+		struct mask_cache_entry *e;
+
+		e = &entries[index];
+		if (e->skb_hash == skb_hash) {
+			flow = flow_lookup(tbl, ti, ma, key, n_mask_hit,
+					   &e->mask_index);
+			if (!flow)
+				e->skb_hash = 0;
+			return flow;
 		}
 
-		if (!del || (del->skb_hash && !ce->skb_hash) ||
-		    (rcu_dereference_ovsl(ma->masks[del->mask_index]) &&
-		     !rcu_dereference_ovsl(ma->masks[ce->mask_index]))) {
-			del = ce;
-		}
+		if (!ce || e->skb_hash < ce->skb_hash)
+			ce = e;  /* A better replacement cache candidate. */
 
 		hash >>= MC_HASH_SHIFT;
 	}
 
-	flow = flow_lookup(tbl, ti, ma, key, n_mask_hit, &del->mask_index);
-
+	/* Cache miss, do full lookup. */
+	flow = flow_lookup(tbl, ti, ma, key, n_mask_hit, &ce->mask_index);
 	if (flow)
-		del->skb_hash = skb_hash;
+		ce->skb_hash = skb_hash;
 
 	return flow;
 }
@@ -615,9 +627,8 @@ struct sw_flow *ovs_flow_tbl_lookup(struct flow_table *tbl,
 {
 	struct table_instance *ti = rcu_dereference_ovsl(tbl->ti);
 	struct mask_array *ma = rcu_dereference_ovsl(tbl->mask_array);
-
 	u32 __always_unused n_mask_hit;
-	u32 __always_unused index;
+	u32 index = 0;
 
 	return flow_lookup(tbl, ti, ma, key, &n_mask_hit, &index);
 }
-- 
1.8.3.1

