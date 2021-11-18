Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9EFD4553AA
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 05:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242877AbhKRESP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 23:18:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:36138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242859AbhKRESH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 23:18:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3647861B9F;
        Thu, 18 Nov 2021 04:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637208908;
        bh=ltUoO/KxmSnTQdtFvsm7WXNAq3nBA75DgWHprYlQ67w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o5NhMdFlkeOAM66mNxNNZ8tP2UyhyjL16rTfLsk0rFbAbmKU6YwdWYS2AepYzxHoP
         uSTWQKc+I/8esCbjouzy8qiN1iFMJjtusX10UmefdD9Nq8/j/DPxDPNqpRq3qcKGsA
         nRClKFZyvAv4Qyw/OktvYnsK3kNLwZ/P+xX4SVoK4oVTXGoFVJ6hNwGzhc7m94q7LC
         +wfdpKPXqcg1kWoqcauN7f+3CJETBPr5cQUVaHnmhv2HzMLc2ddV1tDIC2sLfaRrQK
         QC2uWf0D5OlNuEBzLX2aDfEwDIfuTKy93JDV8nWF1D+TcslqbqxJnOuumHK89w6n5C
         aKTw44PtmMufQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 8/9] dev_addr_list: put the first addr on the tree
Date:   Wed, 17 Nov 2021 20:15:00 -0800
Message-Id: <20211118041501.3102861-9-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211118041501.3102861-1-kuba@kernel.org>
References: <20211118041501.3102861-1-kuba@kernel.org>
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

