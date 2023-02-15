Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB8906974FE
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 04:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbjBODoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 22:44:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232227AbjBODoI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 22:44:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CF7432CD0
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 19:44:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 060A7B81FA9
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 03:44:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56ECFC433EF;
        Wed, 15 Feb 2023 03:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676432643;
        bh=yYvoAxWrk68FXDeCu48gOFEDrdKeDmS8wCON745HxQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u6Ft1yF8+KU2vHVje2Ind/o1VKfJNbtnY/A91QqqkuTsoJV9IHHojz+Kr68Nnl/jH
         AE3iMXTsXNtfIcODevFNDuTQJMErBqgfTGfWw/jjFyddF0WdzfIVeHtnXVPGPoKe4Y
         2IfvydxcDXXX80hiPNvwFb8+Zx+WwIy8FLO3JoE+0saDtj1BchdnkrHh4KWE4SPipy
         Qr1o357htL2WMKd0ktdYA0A02iCojz/xH1ZG+iDYoniWQ+ZsMhIjSm2VOV718fVo60
         x3tQX595MeJvjsknU047PA5//wt5uCNxEq0BR544QTcy2hg1KzWs1BEFw4D1TeUxrZ
         t+JXTneUpJb9w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        willemb@google.com, fw@strlen.de, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 1/3] net: skb: carve the allocation out of skb_ext_add()
Date:   Tue, 14 Feb 2023 19:43:53 -0800
Message-Id: <20230215034355.481925-2-kuba@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230215034355.481925-1-kuba@kernel.org>
References: <20230215034355.481925-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Subsequent patches will try to add different skb_ext allocation
methods. Refactor skb_ext_add() so that most of its code moves
into a tail-called helper, and allocation can be easily swapped
out.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/core/skbuff.c | 52 ++++++++++++++++++++++++++++-------------------
 1 file changed, 31 insertions(+), 21 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 13ea10cf8544..6f0fc1f09536 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -6672,26 +6672,13 @@ void *__skb_ext_set(struct sk_buff *skb, enum skb_ext_id id,
 	return skb_ext_get_ptr(ext, id);
 }
 
-/**
- * skb_ext_add - allocate space for given extension, COW if needed
- * @skb: buffer
- * @id: extension to allocate space for
- *
- * Allocates enough space for the given extension.
- * If the extension is already present, a pointer to that extension
- * is returned.
- *
- * If the skb was cloned, COW applies and the returned memory can be
- * modified without changing the extension space of clones buffers.
- *
- * Returns pointer to the extension or NULL on allocation failure.
- */
-void *skb_ext_add(struct sk_buff *skb, enum skb_ext_id id)
+static void *skb_ext_add_finalize(struct sk_buff *skb, enum skb_ext_id id,
+				  struct skb_ext *new)
 {
-	struct skb_ext *new, *old = NULL;
 	unsigned int newlen, newoff;
+	struct skb_ext *old;
 
-	if (skb->active_extensions) {
+	if (!new) {
 		old = skb->extensions;
 
 		new = skb_ext_maybe_cow(old, skb->active_extensions);
@@ -6704,10 +6691,6 @@ void *skb_ext_add(struct sk_buff *skb, enum skb_ext_id id)
 		newoff = new->chunks;
 	} else {
 		newoff = SKB_EXT_CHUNKSIZEOF(*new);
-
-		new = __skb_ext_alloc(GFP_ATOMIC);
-		if (!new)
-			return NULL;
 	}
 
 	newlen = newoff + skb_ext_type_len[id];
@@ -6719,6 +6702,33 @@ void *skb_ext_add(struct sk_buff *skb, enum skb_ext_id id)
 	skb->active_extensions |= 1 << id;
 	return skb_ext_get_ptr(new, id);
 }
+
+/**
+ * skb_ext_add - allocate space for given extension, COW if needed
+ * @skb: buffer
+ * @id: extension to allocate space for
+ *
+ * Allocates enough space for the given extension.
+ * If the extension is already present, a pointer to that extension
+ * is returned.
+ *
+ * If the skb was cloned, COW applies and the returned memory can be
+ * modified without changing the extension space of clones buffers.
+ *
+ * Returns pointer to the extension or NULL on allocation failure.
+ */
+void *skb_ext_add(struct sk_buff *skb, enum skb_ext_id id)
+{
+	struct skb_ext *new = NULL;
+
+	if (!skb->active_extensions) {
+		new = __skb_ext_alloc(GFP_ATOMIC);
+		if (!new)
+			return NULL;
+	}
+
+	return skb_ext_add_finalize(skb, id, new);
+}
 EXPORT_SYMBOL(skb_ext_add);
 
 #ifdef CONFIG_XFRM
-- 
2.39.1

