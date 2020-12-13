Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC11D2D8B01
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 03:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732437AbgLMCrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 21:47:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727077AbgLMCrs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 21:47:48 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3149C0613CF
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 18:47:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Date:Message-ID:Subject:From:Cc:To:Sender:Reply-To:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=IXd6Y4Vc2PJ09DwUXjh03zWFqR5Ru/ENT3gkqKgzMZw=; b=muZgoKr3xU5eWaeGwMrbDXTzNJ
        9HkNgWPs9TCSj21xIL6UJugU9vYJ3nP9VajYjvJdyIgyYwZAoaiiBEOVzwuLXpWwoNhaRigw4GDNM
        I8lIHGOP4UZdRzT0TsnHe9oxpInRUoB5s0XO0oJBRZaG/6PkDAsVNVZTeY76cLi8o0rcoijv4V+oI
        amsT/fU4PfFUMpIVaxVs0GtjGG5142lgPv2BL4JPPfzX+eG1rL9gyu4ulCG+Pz8SNd/UhjJ50y0me
        wJYqWGssJAsHxgA89vK1UA+e0wvDNMmtEFl3YfM1urFULL93mWI7HkQJiCi9yUMsdKE9ESNQPTgsL
        mriU7o6A==;
Received: from [2602:306:c5a2:a380:9e7b:efff:fe40:2b26]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1koHPc-0002YV-5s; Sun, 13 Dec 2020 02:47:04 +0000
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Evgeniy Polyakov <zbr@ioremap.net>, netdev@vger.kernel.org
From:   Geoff Levand <geoff@infradead.org>
Subject: [PATCH] net/connector: Add const qualifier to cb_id
Message-ID: <71249d9e-ab8e-ee81-0ea2-6533e6126c5b@infradead.org>
Date:   Sat, 12 Dec 2020 18:47:01 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The connector driver never modifies any cb_id passed to it, so add a const
qualifier to those arguments so callers can declare their struct cb_id as a
constant object.

Fixes build warnings like these when passing a constant struct cb_id:

  warning: passing argument 1 of ‘cn_add_callback’ discards ‘const’ qualifier from pointer target

Signed-off-by: Geoff Levand <geoff@infradead.org>
---
 Documentation/driver-api/connector.rst |  2 +-
 drivers/connector/cn_queue.c           |  8 ++++----
 drivers/connector/connector.c          |  4 ++--
 include/linux/connector.h              | 10 +++++-----
 4 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/Documentation/driver-api/connector.rst b/Documentation/driver-api/connector.rst
index c100c7482289..c4fb23ed2337 100644
--- a/Documentation/driver-api/connector.rst
+++ b/Documentation/driver-api/connector.rst
@@ -25,7 +25,7 @@ handling, etc...  The Connector driver allows any kernelspace agents to use
 netlink based networking for inter-process communication in a significantly
 easier way::
 
-  int cn_add_callback(struct cb_id *id, char *name, void (*callback) (struct cn_msg *, struct netlink_skb_parms *));
+  int cn_add_callback(const struct cb_id *id, char *name, void (*callback) (struct cn_msg *, struct netlink_skb_parms *));
   void cn_netlink_send_multi(struct cn_msg *msg, u16 len, u32 portid, u32 __group, int gfp_mask);
   void cn_netlink_send(struct cn_msg *msg, u32 portid, u32 __group, int gfp_mask);
 
diff --git a/drivers/connector/cn_queue.c b/drivers/connector/cn_queue.c
index 49295052ba8b..996f025eb63c 100644
--- a/drivers/connector/cn_queue.c
+++ b/drivers/connector/cn_queue.c
@@ -19,7 +19,7 @@
 
 static struct cn_callback_entry *
 cn_queue_alloc_callback_entry(struct cn_queue_dev *dev, const char *name,
-			      struct cb_id *id,
+			      const struct cb_id *id,
 			      void (*callback)(struct cn_msg *,
 					       struct netlink_skb_parms *))
 {
@@ -51,13 +51,13 @@ void cn_queue_release_callback(struct cn_callback_entry *cbq)
 	kfree(cbq);
 }
 
-int cn_cb_equal(struct cb_id *i1, struct cb_id *i2)
+int cn_cb_equal(const struct cb_id *i1, const struct cb_id *i2)
 {
 	return ((i1->idx == i2->idx) && (i1->val == i2->val));
 }
 
 int cn_queue_add_callback(struct cn_queue_dev *dev, const char *name,
-			  struct cb_id *id,
+			  const struct cb_id *id,
 			  void (*callback)(struct cn_msg *,
 					   struct netlink_skb_parms *))
 {
@@ -90,7 +90,7 @@ int cn_queue_add_callback(struct cn_queue_dev *dev, const char *name,
 	return 0;
 }
 
-void cn_queue_del_callback(struct cn_queue_dev *dev, struct cb_id *id)
+void cn_queue_del_callback(struct cn_queue_dev *dev, const struct cb_id *id)
 {
 	struct cn_callback_entry *cbq, *n;
 	int found = 0;
diff --git a/drivers/connector/connector.c b/drivers/connector/connector.c
index 2d22d6bf52f2..19003f895648 100644
--- a/drivers/connector/connector.c
+++ b/drivers/connector/connector.c
@@ -193,7 +193,7 @@ static void cn_rx_skb(struct sk_buff *skb)
  *
  * May sleep.
  */
-int cn_add_callback(struct cb_id *id, const char *name,
+int cn_add_callback(const struct cb_id *id, const char *name,
 		    void (*callback)(struct cn_msg *,
 				     struct netlink_skb_parms *))
 {
@@ -219,7 +219,7 @@ EXPORT_SYMBOL_GPL(cn_add_callback);
  *
  * May sleep while waiting for reference counter to become zero.
  */
-void cn_del_callback(struct cb_id *id)
+void cn_del_callback(const struct cb_id *id)
 {
 	struct cn_dev *dev = &cdev;
 
diff --git a/include/linux/connector.h b/include/linux/connector.h
index cb732643471b..8ea860efea37 100644
--- a/include/linux/connector.h
+++ b/include/linux/connector.h
@@ -64,14 +64,14 @@ struct cn_dev {
  * @callback:	connector's callback.
  * 		parameters are %cn_msg and the sender's credentials
  */
-int cn_add_callback(struct cb_id *id, const char *name,
+int cn_add_callback(const struct cb_id *id, const char *name,
 		    void (*callback)(struct cn_msg *, struct netlink_skb_parms *));
 /**
  * cn_del_callback() - Unregisters new callback with connector core.
  *
  * @id:		unique connector's user identifier.
  */
-void cn_del_callback(struct cb_id *id);
+void cn_del_callback(const struct cb_id *id);
 
 
 /**
@@ -122,14 +122,14 @@ int cn_netlink_send_mult(struct cn_msg *msg, u16 len, u32 portid, u32 group, gfp
 int cn_netlink_send(struct cn_msg *msg, u32 portid, u32 group, gfp_t gfp_mask);
 
 int cn_queue_add_callback(struct cn_queue_dev *dev, const char *name,
-			  struct cb_id *id,
+			  const struct cb_id *id,
 			  void (*callback)(struct cn_msg *, struct netlink_skb_parms *));
-void cn_queue_del_callback(struct cn_queue_dev *dev, struct cb_id *id);
+void cn_queue_del_callback(struct cn_queue_dev *dev, const struct cb_id *id);
 void cn_queue_release_callback(struct cn_callback_entry *);
 
 struct cn_queue_dev *cn_queue_alloc_dev(const char *name, struct sock *);
 void cn_queue_free_dev(struct cn_queue_dev *dev);
 
-int cn_cb_equal(struct cb_id *, struct cb_id *);
+int cn_cb_equal(const struct cb_id *, const struct cb_id *);
 
 #endif				/* __CONNECTOR_H */
-- 
2.25.1

