Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C87C82DA7A5
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 06:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbgLOFYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 00:24:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgLOFYX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 00:24:23 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F73DC0617A6
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 21:15:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:References:Cc:To:From:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=xly85DjGatg17Edo+wUB5O0tCMXcRqhDqmX2DuDRjDQ=; b=mS0Wt21zHm7Jja+Zq0CuXfwD6g
        WM9jpYxCFGC6qnpYabqa0/Icks4iQSv4udK2V5G7TJSRd0ACKvQ+jdTwt3xkQgz7jwgGx04GD5C1O
        VgO15LhuXqtOJuuoNbZ37YmKc4MOMCguhPj7v1ts6KYPbg9/8oFqruZD0RTWbt4Yv7JGMbsMkoq3I
        fSgBFURq/uqsSeb7mLpDK7E5vmzoHdSwK6EhJ5UdOo+TqSHNwgcJf5kAuOTLMJ3pvuSoTXMz5mMaL
        h7whKHX1Yr/JBLgTlrwpx7v8Mu9+XhmuQlWLzf+tuUyaCw0TOcccr1siwrOq9H3pma17mrO1srBnN
        UN/0LzBg==;
Received: from [2602:306:c5a2:a380:9e7b:efff:fe40:2b26]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kp2gi-0004Xr-5E; Tue, 15 Dec 2020 05:15:52 +0000
Subject: [PATCH v2] net/connector: Add const qualifier to cb_id
From:   Geoff Levand <geoff@infradead.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Evgeniy Polyakov <zbr@ioremap.net>, netdev@vger.kernel.org
References: <71249d9e-ab8e-ee81-0ea2-6533e6126c5b@infradead.org>
Message-ID: <a9e49c9e-67fa-16e7-0a6b-72f6bd30c58a@infradead.org>
Date:   Mon, 14 Dec 2020 21:15:47 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <71249d9e-ab8e-ee81-0ea2-6533e6126c5b@infradead.org>
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
v2: Rebase to net-next.git.

 Documentation/driver-api/connector.rst |  2 +-
 drivers/connector/cn_queue.c           |  8 ++++----
 drivers/connector/connector.c          |  4 ++--
 include/linux/connector.h              | 10 +++++-----
 4 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/Documentation/driver-api/connector.rst b/Documentation/driver-api/connector.rst
index 23d068191fb1..631b84a48aa5 100644
--- a/Documentation/driver-api/connector.rst
+++ b/Documentation/driver-api/connector.rst
@@ -25,7 +25,7 @@ handling, etc...  The Connector driver allows any kernelspace agents to use
 netlink based networking for inter-process communication in a significantly
 easier way::
 
-  int cn_add_callback(struct cb_id *id, char *name, void (*callback) (struct cn_msg *, struct netlink_skb_parms *));
+  int cn_add_callback(const struct cb_id *id, char *name, void (*callback) (struct cn_msg *, struct netlink_skb_parms *));
   void cn_netlink_send_mult(struct cn_msg *msg, u16 len, u32 portid, u32 __group, int gfp_mask);
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
index 7d59d18c6f26..48ec7ce6ecac 100644
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
@@ -214,7 +214,7 @@ EXPORT_SYMBOL_GPL(cn_add_callback);
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

