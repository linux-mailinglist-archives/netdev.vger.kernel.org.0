Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5E1BCF8FC
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 13:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730711AbfJHL5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 07:57:02 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43897 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730495AbfJHL5C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 07:57:02 -0400
Received: by mail-pg1-f195.google.com with SMTP id i32so2816067pgl.10
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 04:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QE03MBHiq42pArEtShc+VYCmSluEXNyE+j/bDKF7iCQ=;
        b=jFIIaPlCeZZ1BgIWFfTi9rWEAEMoM5CeulU8wVwTG0DvWqbLbmd2Na0y/FptaIfb5H
         iaswzzm4R9jxcgrC4yJ8/FuSmIyywI2zFX6/xNwR+acbMfRmZVBZCK4WnJkM6rFuJqgA
         11w5rK46a8Y4e7pn/nqcxishCLcmhf7FalAmnAxK8fMjylQXd9oUidYRHaeYtmDgeTXs
         PNKeP9tlpGlz3VEy/B8lPvrjIUvcnck9TJ07QGwxXokMmgEx662wUykBAQppBS7cFpsz
         VMLUGt729fxcp3UxNZBQskQUbXVDdHp/8Prdqs4tA+0pXzBy5Pdkeex+2qfDHaP8B7zA
         vPEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QE03MBHiq42pArEtShc+VYCmSluEXNyE+j/bDKF7iCQ=;
        b=DRViaBZflpExySXeWEO8Yj6ZmQU1nU+cFavBKwvWtBaQpocI554VU36sFtRYUljcgc
         BCc6lSCyrRp1VRpduq7QGqCwqRL1cb+EoUYnqV6vZekxwgYLVwVHxW+sVnvT4G5H/mik
         K6KHagk2OyL5rSg8vPW87uPqA7XcpWo85kkPjk6qrAus7Cjkg8z7q+yEFO/clE8imHNA
         sa4okwVYC0LpxETS76w2NkQf6wDXCHDnfNnxr9QzwWiAYL6M9dufcTtTOvm/zkwSGXpD
         ft4X3nq+1zc0dQxYyYXVXxe5P/KUtNon++/eL5LG5JVU9Uh7LAblSGGTjzp/3tCfVHwX
         Ow9A==
X-Gm-Message-State: APjAAAUzOV9wqnChn51plGaOIudQZshxRkQQlLQ69RFD2gpMxstNKoHB
        TSbbprH2HBChDqsZXtZ/Cvg=
X-Google-Smtp-Source: APXvYqzGy0rVxT0f3JwmJRBlyMg+ZFyKOA8Nj6w/I8ktkSrJub2+yTz1w7hhMl5vp8P8hMFSDUlhXQ==
X-Received: by 2002:a62:684:: with SMTP id 126mr24377089pfg.104.1570535820459;
        Tue, 08 Oct 2019 04:57:00 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id b14sm18149932pfi.95.2019.10.08.04.56.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Oct 2019 04:57:00 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     gvrose8192@gmail.com, pshelar@ovn.org
Cc:     netdev@vger.kernel.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v2 04/10] net: openvswitch: optimize flow-mask cache hash collision
Date:   Tue,  8 Oct 2019 09:00:32 +0800
Message-Id: <1570496438-15460-5-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1570496438-15460-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1570496438-15460-1-git-send-email-xiangxia.m.yue@gmail.com>
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
index ff4c4b049..4c82960 100644
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

