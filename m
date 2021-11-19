Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A365457086
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 15:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235833AbhKSOZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 09:25:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:59204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235821AbhKSOZC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 09:25:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BB9661502;
        Fri, 19 Nov 2021 14:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637331720;
        bh=ltUoO/KxmSnTQdtFvsm7WXNAq3nBA75DgWHprYlQ67w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZAP/8hgmEULds+N3kp8/KLKUvN9q2jq0h8a76ofFtO0HLNgrISriYDCIbUUpj+dUr
         ctskgbuPz+bS/BWfuN1R5RZMBGyB9FE+Nmw5avGkSD4xVwyd9+3Y6tRMcHl42d/eSl
         XgRz6IQyBXn6VSGub6NPs1ekGx+F86duzbGooMLYz3zNl+z8R4mSBUaFp2/qC0S/Do
         NC2rjQ8zHoCUQUlImwa7zij1fn5s6DEDtBgyIEpc4r6rJhmAROMowd70sYz+eKJhL+
         iNzyvLUYOGbgky3lefSqf0NZA5nVkMHSoKXInpvepsUKxpn5ghr75f87lArOh32+8l
         0tmCVj/m3A8Xg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 6/7] dev_addr_list: put the first addr on the tree
Date:   Fri, 19 Nov 2021 06:21:54 -0800
Message-Id: <20211119142155.3779933-7-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211119142155.3779933-1-kuba@kernel.org>
References: <20211119142155.3779933-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since all netdev->dev_addr modifications go via dev_addr_mod()
we can put it on the list. When address is change remove it
and add it back.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/core/dev_addr_lists.c | 62 +++++++++++++++++++++------------------
 1 file changed, 34 insertions(+), 28 deletions(-)

diff --git a/net/core/dev_addr_lists.c b/net/core/dev_addr_lists.c
index 969942734951..bead38ca50bd 100644
--- a/net/core/dev_addr_lists.c
+++ b/net/core/dev_addr_lists.c
@@ -16,6 +16,35 @@
  * General list handling functions
  */
 
+static int __hw_addr_insert(struct netdev_hw_addr_list *list,
+			    struct netdev_hw_addr *new, int addr_len)
+{
+	struct rb_node **ins_point = &list->tree.rb_node, *parent = NULL;
+	struct netdev_hw_addr *ha;
+
+	while (*ins_point) {
+		int diff;
+
+		ha = rb_entry(*ins_point, struct netdev_hw_addr, node);
+		diff = memcmp(new->addr, ha->addr, addr_len);
+		if (diff == 0)
+			diff = memcmp(&new->type, &ha->type, sizeof(new->type));
+
+		parent = *ins_point;
+		if (diff < 0)
+			ins_point = &parent->rb_left;
+		else if (diff > 0)
+			ins_point = &parent->rb_right;
+		else
+			return -EEXIST;
+	}
+
+	rb_link_node_rcu(&new->node, parent, ins_point);
+	rb_insert_color(&new->node, &list->tree);
+
+	return 0;
+}
+
 static struct netdev_hw_addr*
 __hw_addr_create(const unsigned char *addr, int addr_len,
 		 unsigned char addr_type, bool global, bool sync)
@@ -50,11 +79,6 @@ static int __hw_addr_add_ex(struct netdev_hw_addr_list *list,
 	if (addr_len > MAX_ADDR_LEN)
 		return -EINVAL;
 
-	ha = list_first_entry(&list->list, struct netdev_hw_addr, list);
-	if (ha && !memcmp(addr, ha->addr, addr_len) &&
-	    (!addr_type || addr_type == ha->type))
-		goto found_it;
-
 	while (*ins_point) {
 		int diff;
 
@@ -69,7 +93,6 @@ static int __hw_addr_add_ex(struct netdev_hw_addr_list *list,
 		} else if (diff > 0) {
 			ins_point = &parent->rb_right;
 		} else {
-found_it:
 			if (exclusive)
 				return -EEXIST;
 			if (global) {
@@ -94,16 +117,8 @@ static int __hw_addr_add_ex(struct netdev_hw_addr_list *list,
 	if (!ha)
 		return -ENOMEM;
 
-	/* The first address in dev->dev_addrs is pointed to by dev->dev_addr
-	 * and mutated freely by device drivers and netdev ops, so if we insert
-	 * it into the tree we'll end up with an invalid rbtree.
-	 */
-	if (list->count > 0) {
-		rb_link_node(&ha->node, parent, ins_point);
-		rb_insert_color(&ha->node, &list->tree);
-	} else {
-		RB_CLEAR_NODE(&ha->node);
-	}
+	rb_link_node(&ha->node, parent, ins_point);
+	rb_insert_color(&ha->node, &list->tree);
 
 	list_add_tail_rcu(&ha->list, &list->list);
 	list->count++;
@@ -138,8 +153,7 @@ static int __hw_addr_del_entry(struct netdev_hw_addr_list *list,
 	if (--ha->refcount)
 		return 0;
 
-	if (!RB_EMPTY_NODE(&ha->node))
-		rb_erase(&ha->node, &list->tree);
+	rb_erase(&ha->node, &list->tree);
 
 	list_del_rcu(&ha->list);
 	kfree_rcu(ha, rcu_head);
@@ -151,18 +165,8 @@ static struct netdev_hw_addr *__hw_addr_lookup(struct netdev_hw_addr_list *list,
 					       const unsigned char *addr, int addr_len,
 					       unsigned char addr_type)
 {
-	struct netdev_hw_addr *ha;
 	struct rb_node *node;
 
-	/* The first address isn't inserted into the tree because in the dev->dev_addrs
-	 * list it's the address pointed to by dev->dev_addr which is freely mutated
-	 * in place, so we need to check it separately.
-	 */
-	ha = list_first_entry(&list->list, struct netdev_hw_addr, list);
-	if (ha && !memcmp(addr, ha->addr, addr_len) &&
-	    (!addr_type || addr_type == ha->type))
-		return ha;
-
 	node = list->tree.rb_node;
 
 	while (node) {
@@ -571,8 +575,10 @@ void dev_addr_mod(struct net_device *dev, unsigned int offset,
 	dev_addr_check(dev);
 
 	ha = container_of(dev->dev_addr, struct netdev_hw_addr, addr[0]);
+	rb_erase(&ha->node, &dev->dev_addrs.tree);
 	memcpy(&ha->addr[offset], addr, len);
 	memcpy(&dev->dev_addr_shadow[offset], addr, len);
+	WARN_ON(__hw_addr_insert(&dev->dev_addrs, ha, dev->addr_len));
 }
 EXPORT_SYMBOL(dev_addr_mod);
 
-- 
2.31.1

