Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 864714BCF6D
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 16:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236452AbiBTPdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 10:33:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232319AbiBTPdV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 10:33:21 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9543E369C4
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 07:33:00 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id 75so12157582pgb.4
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 07:33:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8ttO1dyEeSfJbFEwSN0LzHEqcR5vGyrBvm/SgMkHrAI=;
        b=I3iok89sxZivLnf9F/IKUMgP/ES6ioYxZ0ryzCiH/Xe/1x7AAA6f80JYsTloIEyIVy
         9NaGkc3ubxB8MbpApIpmaWTYnsLGv136Y1FLmo3qIvcogV2hJXdQYY2j6a1N3nPPpyps
         phexfaknt4lMXNr8sdoRzb/MhfQvdGuGrG2SZdmtLLmhecI1krmow1fccdHdgYt+aFKD
         B1MAey3VFFJK1J1jAWv4fPBpUAFeGU91D1uyhkB/FUmFk/jiYvLmVUr9i/yNy04jotia
         3esCJT0IangzK+FU+bRLRCUpWfQh7hU6rRH7Lglr6RQK3UIjhjvJHDWWwUAt6Ossniel
         hR1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8ttO1dyEeSfJbFEwSN0LzHEqcR5vGyrBvm/SgMkHrAI=;
        b=FmbleKAtMak8MePcouGM83NaUtE04IFqFNBoObes6WwZ4+4A+ZVtRAAbil+Zxu4vgi
         XCrQA/6F94/ysIKsES8sEnpSgP7HMGXmKet8gNsg9ZR71+8oSP87E0XogkjmoegeCt53
         CYJYy7KzMiBpHp7LiXLQ9R2HK4uiQKNrM4Y1k0x9mT41z7E47Ghlb2tVSsfKXrzOKLu+
         +jqf36fvkhGz90gZ/uaVGx8SspSmVcEl+B/ucJw92YyzZWo7G2VJA2mRDQfEq1o0eWHt
         Z2bcdKtezrv7kiTmds1JdHCHwxyObfyeWV5y+OfPIJa3oN4CJyGMQHxbP0NubzhCRADW
         OixQ==
X-Gm-Message-State: AOAM531fDhJNy0tYMj28Y+4nCBJT0fpAoI25ysxfCQmFAvEOxthzFJKa
        mU2jw1xNohM2byL7oHYytpZMwHcoX154gIuOwLY=
X-Google-Smtp-Source: ABdhPJympChZVPOfqPQ2u4HGKfwOZzCXf+Jh0RW6cVvMtebmfbG2JnevOMgs6/+h1M/fh5usMEypRg==
X-Received: by 2002:a05:6a00:16cd:b0:4e1:366:7ee8 with SMTP id l13-20020a056a0016cd00b004e103667ee8mr16463972pfc.9.1645371179637;
        Sun, 20 Feb 2022 07:32:59 -0800 (PST)
Received: from localhost.localdomain ([58.76.185.115])
        by smtp.gmail.com with ESMTPSA id u19sm5583221pfk.203.2022.02.20.07.32.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Feb 2022 07:32:59 -0800 (PST)
From:   Juhee Kang <claudiajkang@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        eric.dumazet@gmail.com
Cc:     ennoerlangen@gmail.com, george.mccollister@gmail.com,
        olteanv@gmail.com, marco.wenzel@a-eberle.de
Subject: [PATCH net-next] net: hsr: fix hsr build error when lockdep is not enabled
Date:   Sun, 20 Feb 2022 15:32:50 +0000
Message-Id: <20220220153250.5285-1-claudiajkang@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In hsr, lockdep_is_held() is needed for rcu_dereference_bh_check().
But if lockdep is not enabled, lockdep_is_held() causes a build error:

    ERROR: modpost: "lockdep_is_held" [net/hsr/hsr.ko] undefined!

Thus, this patch solved by adding lockdep_hsr_is_held(). This helper
function calls the lockdep_is_held() when lockdep is enabled, and returns 1
if not defined.

Fixes: e7f27420681f ("net: hsr: fix suspicious RCU usage warning in hsr_node_get_first()")
Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
---
 net/hsr/hsr_framereg.c | 25 +++++++++++++++----------
 net/hsr/hsr_framereg.h |  8 +++++++-
 2 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
index 62272d76545c..584e21788799 100644
--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -20,6 +20,13 @@
 #include "hsr_framereg.h"
 #include "hsr_netlink.h"
 
+#ifdef CONFIG_LOCKDEP
+int lockdep_hsr_is_held(spinlock_t *lock)
+{
+	return lockdep_is_held(lock);
+}
+#endif
+
 u32 hsr_mac_hash(struct hsr_priv *hsr, const unsigned char *addr)
 {
 	u32 hash = jhash(addr, ETH_ALEN, hsr->hash_seed);
@@ -27,11 +34,12 @@ u32 hsr_mac_hash(struct hsr_priv *hsr, const unsigned char *addr)
 	return reciprocal_scale(hash, hsr->hash_buckets);
 }
 
-struct hsr_node *hsr_node_get_first(struct hlist_head *head, int cond)
+struct hsr_node *hsr_node_get_first(struct hlist_head *head, spinlock_t *lock)
 {
 	struct hlist_node *first;
 
-	first = rcu_dereference_bh_check(hlist_first_rcu(head), cond);
+	first = rcu_dereference_bh_check(hlist_first_rcu(head),
+					 lockdep_hsr_is_held(lock));
 	if (first)
 		return hlist_entry(first, struct hsr_node, mac_list);
 
@@ -59,8 +67,7 @@ bool hsr_addr_is_self(struct hsr_priv *hsr, unsigned char *addr)
 {
 	struct hsr_node *node;
 
-	node = hsr_node_get_first(&hsr->self_node_db,
-				  lockdep_is_held(&hsr->list_lock));
+	node = hsr_node_get_first(&hsr->self_node_db, &hsr->list_lock);
 	if (!node) {
 		WARN_ONCE(1, "HSR: No self node\n");
 		return false;
@@ -107,8 +114,7 @@ int hsr_create_self_node(struct hsr_priv *hsr,
 	ether_addr_copy(node->macaddress_B, addr_b);
 
 	spin_lock_bh(&hsr->list_lock);
-	oldnode = hsr_node_get_first(self_node_db,
-				     lockdep_is_held(&hsr->list_lock));
+	oldnode = hsr_node_get_first(self_node_db, &hsr->list_lock);
 	if (oldnode) {
 		hlist_replace_rcu(&oldnode->mac_list, &node->mac_list);
 		spin_unlock_bh(&hsr->list_lock);
@@ -127,8 +133,7 @@ void hsr_del_self_node(struct hsr_priv *hsr)
 	struct hsr_node *node;
 
 	spin_lock_bh(&hsr->list_lock);
-	node = hsr_node_get_first(self_node_db,
-				  lockdep_is_held(&hsr->list_lock));
+	node = hsr_node_get_first(self_node_db, &hsr->list_lock);
 	if (node) {
 		hlist_del_rcu(&node->mac_list);
 		kfree_rcu(node, rcu_head);
@@ -194,7 +199,7 @@ static struct hsr_node *hsr_add_node(struct hsr_priv *hsr,
 
 	spin_lock_bh(&hsr->list_lock);
 	hlist_for_each_entry_rcu(node, node_db, mac_list,
-				 lockdep_is_held(&hsr->list_lock)) {
+				 lockdep_hsr_is_held(&hsr->list_lock)) {
 		if (ether_addr_equal(node->macaddress_A, addr))
 			goto out;
 		if (ether_addr_equal(node->macaddress_B, addr))
@@ -601,7 +606,7 @@ void *hsr_get_next_node(struct hsr_priv *hsr, void *_pos,
 
 	if (!_pos) {
 		node = hsr_node_get_first(&hsr->node_db[hash],
-					  lockdep_is_held(&hsr->list_lock));
+					  &hsr->list_lock);
 		if (node)
 			ether_addr_copy(addr, node->macaddress_A);
 		return node;
diff --git a/net/hsr/hsr_framereg.h b/net/hsr/hsr_framereg.h
index 2efd03fb3465..f3762e9e42b5 100644
--- a/net/hsr/hsr_framereg.h
+++ b/net/hsr/hsr_framereg.h
@@ -28,8 +28,14 @@ struct hsr_frame_info {
 	bool is_from_san;
 };
 
+#ifdef CONFIG_LOCKDEP
+int lockdep_hsr_is_held(spinlock_t *lock);
+#else
+#define lockdep_hsr_is_held(lock)	1
+#endif
+
 u32 hsr_mac_hash(struct hsr_priv *hsr, const unsigned char *addr);
-struct hsr_node *hsr_node_get_first(struct hlist_head *head, int cond);
+struct hsr_node *hsr_node_get_first(struct hlist_head *head, spinlock_t *lock);
 void hsr_del_self_node(struct hsr_priv *hsr);
 void hsr_del_nodes(struct hlist_head *node_db);
 struct hsr_node *hsr_get_node(struct hsr_port *port, struct hlist_head *node_db,
-- 
2.25.1

