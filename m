Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DEEA24F331
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 09:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgHXHiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 03:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgHXHhz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 03:37:55 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E3C5C061573
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 00:37:55 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id s15so3322417qvv.7
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 00:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HybJcCBAZD4ChKMKFFeVZzK8aDkKxUg1eC+iaeI1GG4=;
        b=qpBdNdFLsHgUhxUDy3XT92FNN2zE9IJ6ehvaGENxcpaFgyFvH7aNfbGil6JwdaaohK
         sskts0Nf5Nvz2xB69mTP+YqeXQEqUum2Di7lOijN3Kh78zFLE0j+JCEwEkRdOAK8K3aO
         AYzc3e3B3LmXRdpKu6rB0iw9E0Q2LWgefThYSNdSS4UG3gga1LazghgTkvOVqvkqVDpN
         udutdkh6AZc72xrr49J2Xg8h7lOvEnFWgUCT3xxExJKuai6atc65lU1PwRB6XOulRkQg
         oTTJT8hLqwX83QulPMRRbjpIX88aoE7MBGa2cAx8LQVa0bchIPBjxUJmg6vQexeJt1iq
         pwSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HybJcCBAZD4ChKMKFFeVZzK8aDkKxUg1eC+iaeI1GG4=;
        b=QEebtkBQg2X3WzIJja5K4vu5WnU2X1Luh+7adNi7CB8LjgzDmhjMC7n+ObIGjrGeqT
         R81PN+AtcCjepiU71UTlStVAG8lhCPxBOTMfzVtZSDKGEuSX5qex5RljGNfMR+wFnO2a
         174fI9ZNrfdKNA+uMdHtt6ChCFdbpf8jCfX0jjfNqhz8m4ZsskFtckLA4biKfzLIbcdI
         dSHpByG6r0welT3lFrsQhHZ5Lf2d8+1V/YVM/8SmzXw/4pv3p8eywJjwNRlkOJYoQlHa
         Zqq7DIdlSFNDh4YAzosnWWYk/apHqOpAYtqr+hyNr9CGvwkOd573+jyAKhegC8ZZap7w
         ytrg==
X-Gm-Message-State: AOAM530E+Mkwt27l3AdJjgqKXc5+DNaodT6KYPW8jI6bsJBmC47KUtqW
        B58O4DrJS0gIAFA+/UqYLyQ=
X-Google-Smtp-Source: ABdhPJyEo6xCwkZ0ZIPCX0OISwIVc2/Q0B2C7EUt6KjK7OzKzqzGeThgr/g6f/EfDym6F+wPo9BQ/g==
X-Received: by 2002:ad4:4908:: with SMTP id bh8mr3855871qvb.218.1598254674446;
        Mon, 24 Aug 2020 00:37:54 -0700 (PDT)
Received: from localhost.localdomain ([50.236.19.102])
        by smtp.gmail.com with ESMTPSA id y9sm9092322qka.0.2020.08.24.00.37.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Aug 2020 00:37:53 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     davem@davemloft.net, pshelar@ovn.org, xiyou.wangcong@gmail.com
Cc:     dev@openvswitch.org, netdev@vger.kernel.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v2 2/3] net: openvswitch: refactor flow free function
Date:   Mon, 24 Aug 2020 15:36:01 +0800
Message-Id: <20200824073602.70812-3-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.15.0
In-Reply-To: <20200824073602.70812-1-xiangxia.m.yue@gmail.com>
References: <20200824073602.70812-1-xiangxia.m.yue@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Decrease table->count and ufid_count unconditionally,
because we only don't use count or ufid_count to count
when flushing the flows. To simplify the codes, we
remove the "count" argument of table_instance_flow_free.

To avoid a bug when deleting flows in the future, add
BUG_ON in flush flows function.

Cc: Pravin B Shelar <pshelar@ovn.org>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
v2:
add more details why refactor this function.
---
 net/openvswitch/flow_table.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index 4b7ab62d0e1a..f8a21dd80e72 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -459,18 +459,14 @@ static void flow_tbl_destroy_rcu_cb(struct rcu_head *rcu)
 static void table_instance_flow_free(struct flow_table *table,
 				     struct table_instance *ti,
 				     struct table_instance *ufid_ti,
-				     struct sw_flow *flow,
-				     bool count)
+				     struct sw_flow *flow)
 {
 	hlist_del_rcu(&flow->flow_table.node[ti->node_ver]);
-	if (count)
-		table->count--;
+	table->count--;
 
 	if (ovs_identifier_is_ufid(&flow->id)) {
 		hlist_del_rcu(&flow->ufid_table.node[ufid_ti->node_ver]);
-
-		if (count)
-			table->ufid_count--;
+		table->ufid_count--;
 	}
 
 	flow_mask_remove(table, flow->mask);
@@ -495,10 +491,13 @@ void table_instance_flow_flush(struct flow_table *table,
 					  flow_table.node[ti->node_ver]) {
 
 			table_instance_flow_free(table, ti, ufid_ti,
-						 flow, false);
+						 flow);
 			ovs_flow_free(flow, true);
 		}
 	}
+
+	BUG_ON(table->count != 0);
+	BUG_ON(table->ufid_count != 0);
 }
 
 static void table_instance_destroy(struct table_instance *ti,
@@ -635,8 +634,6 @@ int ovs_flow_tbl_flush(struct flow_table *flow_table)
 	rcu_assign_pointer(flow_table->ti, new_ti);
 	rcu_assign_pointer(flow_table->ufid_ti, new_ufid_ti);
 	flow_table->last_rehash = jiffies;
-	flow_table->count = 0;
-	flow_table->ufid_count = 0;
 
 	table_instance_flow_flush(flow_table, old_ti, old_ufid_ti);
 	table_instance_destroy(old_ti, old_ufid_ti);
@@ -954,7 +951,7 @@ void ovs_flow_tbl_remove(struct flow_table *table, struct sw_flow *flow)
 	struct table_instance *ufid_ti = ovsl_dereference(table->ufid_ti);
 
 	BUG_ON(table->count == 0);
-	table_instance_flow_free(table, ti, ufid_ti, flow, true);
+	table_instance_flow_free(table, ti, ufid_ti, flow);
 }
 
 static struct sw_flow_mask *mask_alloc(void)
-- 
2.23.0

