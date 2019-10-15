Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8526CD9186
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 14:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405257AbfJPMun (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 08:50:43 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39014 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405248AbfJPMul (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 08:50:41 -0400
Received: by mail-pf1-f193.google.com with SMTP id v4so14674376pff.6
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 05:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BQZqcFwFIMbecsaknh9C7llBVU/lIsJ7X4zgcj4FguQ=;
        b=hhbGyzhQzFiWOFvd9r3LhQT9O/t0KNQez5n/uNv106rzembQYECkxmpjHCIkzlSkdk
         VAugfuwelQJGkXAujgDRaLV+Rni1s+5cDeLX3eFMHaA1wyZxsBu7vbqMA7pVncBuUw7h
         g+bhn1VIyGYrltvQnRtaBPmLL/pExBFBDmGdK7emknuk6DRE9dspWTu0hkV77gR+t2em
         A9tptRC8HUMK9d1CVQkNnRIwivPvRWYTcd9vrsdb8FR2YyJSDoSuQW0oKo/gqPaMSXSg
         OGIkmrsh8MrV+4Kqy75osrgXDfoXCwcIEeIm4TwpRDoSdCnUD8ssHzvHouz/IvEpl3+P
         XLBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=BQZqcFwFIMbecsaknh9C7llBVU/lIsJ7X4zgcj4FguQ=;
        b=SL9pbmjZn0WviShkR+nF/vlb24C+rHQrEbanEYfUF7H+MaFrFEKVXRFfvZEZ8zPOhW
         pcir5DtLV5DW4jwqFm1hs1qMX1goynf6lP85Ei9v+eB/0Gxq4aj1TsQOwGElPiPte1xb
         laPbnATet1ZOqCqhxBBRWC4ivsDw9Rk/IeSfNdx7UyH19D+g6iuo5ghnGry2I/u0DYKD
         7+sLPnlaaXD2P7bbiVUa24Oa+7JoclwzZ7OyPun1dLdl8EWm52owWwi69oyJqJqT8p7G
         to9DQ50rgEYSWNdwgHdeIAmgOqimjX8sNMHbRX3216xijBcThggKGVQZCqaCb98pdgcC
         ZXmQ==
X-Gm-Message-State: APjAAAUAOK2dkjU6yus4DXxtGL1Sy3BYz6yXFp7+gypiafauk0hAfQ08
        ZbvvQrA8QGZPWBSw8i//+DA=
X-Google-Smtp-Source: APXvYqylwHTv6CsidMvUJm9M4ha3Els8URuJC6AsQzu8VFtbnkaTa90Z5/M6E/Vk+6w7V/ug32HE0w==
X-Received: by 2002:a62:65c1:: with SMTP id z184mr44796867pfb.42.1571230240238;
        Wed, 16 Oct 2019 05:50:40 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id d19sm2747339pjz.5.2019.10.16.05.50.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Oct 2019 05:50:39 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     gvrose8192@gmail.com, pshelar@ovn.org
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v4 04/10] net: openvswitch: optimize flow mask cache hash collision
Date:   Tue, 15 Oct 2019 18:30:34 +0800
Message-Id: <1571135440-24313-5-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1571135440-24313-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1571135440-24313-1-git-send-email-xiangxia.m.yue@gmail.com>
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
Tested-by: Greg Rose <gvrose8192@gmail.com>
---
 net/openvswitch/flow_table.c | 95 ++++++++++++++++++++++++--------------------
 1 file changed, 53 insertions(+), 42 deletions(-)

diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index 237cf85..8d4f50d 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -508,6 +508,9 @@ static struct sw_flow *masked_flow_lookup(struct table_instance *ti,
 	return NULL;
 }
 
+/* Flow lookup does full lookup on flow table. It starts with
+ * mask from index passed in *index.
+ */
 static struct sw_flow *flow_lookup(struct flow_table *tbl,
 				   struct table_instance *ti,
 				   struct mask_array *ma,
@@ -516,18 +519,31 @@ static struct sw_flow *flow_lookup(struct flow_table *tbl,
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
 
@@ -546,58 +562,54 @@ struct sw_flow *ovs_flow_tbl_lookup_stats(struct flow_table *tbl,
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
@@ -607,9 +619,8 @@ struct sw_flow *ovs_flow_tbl_lookup(struct flow_table *tbl,
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

