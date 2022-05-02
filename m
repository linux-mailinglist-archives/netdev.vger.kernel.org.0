Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 958FF517ACD
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 01:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiEBXcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 19:32:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231725AbiEBXa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 19:30:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA59660C8
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 16:27:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26F08B81ACE
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 23:27:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99DE4C385AC;
        Mon,  2 May 2022 23:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651534026;
        bh=M269q/Q1q3I5xl5JWtiVmhuHZWtU8NXYU54DcynYUXg=;
        h=From:To:Cc:Subject:Date:From;
        b=NEgcJdI4SoBxiMwJ4oNJs2k51SFx24lWuJuvLAsqL5ZA7ANOTo+HXlhqH3B0iQdAS
         VBTu+0IYPxUw11nG+/EC5EqJlX1WA1Few4BOhXaFN5Z61Fg3DVvs4MBUu6OXETt3PZ
         eiXC/Rn3+EC+wcp+dckBQJW0/AdsDbRGSx1FQixQLsbu+2zNKcsY3lOKfgrZo9d9KR
         6RweGmBk8FKD7sPpLdidK36qUXq83j8Ounkury0QNFzC58GE+F+WOw/6+aUIorOfRj
         euhs+m8YtqymB+1BxrtBhfuoJmA3pFL2TMiZ6OF/0nIStIsZlJwcHiFwCd27RkU+ss
         hyS/GpRKK6sYg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     pabeni@redhat.com, edumazet@google.com, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] netdev: reshuffle netif_napi_add() APIs to allow dropping weight
Date:   Mon,  2 May 2022 16:27:03 -0700
Message-Id: <20220502232703.396351-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most drivers should not have to worry about selecting the right
weight for their NAPI instances and pass NAPI_POLL_WEIGHT.
It'd be best if we didn't require the argument at all and selected
the default internally.

This change prepares the ground for such reshuffling, allowing
for a smooth transition. The following API should remain after
the next release cycle:
  netif_napi_add()
  netif_napi_add_weight()
  netif_napi_add_tx()
  netif_napi_add_tx_weight()
Where the _weight() variants take an explicit weight argument.
I opted for a _weight() suffix rather than a __ prefix, because
we use __ in places to mean that caller needs to also issue a
synchronize_net() call.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/netdevice.h | 50 ++++++++++++++++++++++++++-------------
 net/core/dev.c            |  6 ++---
 2 files changed, 36 insertions(+), 20 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 4aba92a4042a..eaf66e57d891 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2499,37 +2499,53 @@ static inline void *netdev_priv(const struct net_device *dev)
  */
 #define NAPI_POLL_WEIGHT 64
 
+void netif_napi_add_weight(struct net_device *dev, struct napi_struct *napi,
+			   int (*poll)(struct napi_struct *, int), int weight);
+
 /**
- *	netif_napi_add - initialize a NAPI context
- *	@dev:  network device
- *	@napi: NAPI context
- *	@poll: polling function
- *	@weight: default weight
+ * netif_napi_add() - initialize a NAPI context
+ * @dev:  network device
+ * @napi: NAPI context
+ * @poll: polling function
+ * @weight: default weight
  *
  * netif_napi_add() must be used to initialize a NAPI context prior to calling
  * *any* of the other NAPI-related functions.
  */
-void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
-		    int (*poll)(struct napi_struct *, int), int weight);
+static inline void
+netif_napi_add(struct net_device *dev, struct napi_struct *napi,
+	       int (*poll)(struct napi_struct *, int), int weight)
+{
+	netif_napi_add_weight(dev, napi, poll, weight);
+}
+
+static inline void
+netif_napi_add_tx_weight(struct net_device *dev,
+			 struct napi_struct *napi,
+			 int (*poll)(struct napi_struct *, int),
+			 int weight)
+{
+	set_bit(NAPI_STATE_NO_BUSY_POLL, &napi->state);
+	netif_napi_add_weight(dev, napi, poll, weight);
+}
+
+#define netif_tx_napi_add netif_napi_add_tx_weight
 
 /**
- *	netif_tx_napi_add - initialize a NAPI context
- *	@dev:  network device
- *	@napi: NAPI context
- *	@poll: polling function
- *	@weight: default weight
+ * netif_napi_add_tx() - initialize a NAPI context to be used for Tx only
+ * @dev:  network device
+ * @napi: NAPI context
+ * @poll: polling function
  *
  * This variant of netif_napi_add() should be used from drivers using NAPI
  * to exclusively poll a TX queue.
  * This will avoid we add it into napi_hash[], thus polluting this hash table.
  */
-static inline void netif_tx_napi_add(struct net_device *dev,
+static inline void netif_napi_add_tx(struct net_device *dev,
 				     struct napi_struct *napi,
-				     int (*poll)(struct napi_struct *, int),
-				     int weight)
+				     int (*poll)(struct napi_struct *, int))
 {
-	set_bit(NAPI_STATE_NO_BUSY_POLL, &napi->state);
-	netif_napi_add(dev, napi, poll, weight);
+	netif_napi_add_tx_weight(dev, napi, poll, NAPI_POLL_WEIGHT);
 }
 
 /**
diff --git a/net/core/dev.c b/net/core/dev.c
index d127164771f2..c2d73595a7c3 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6303,8 +6303,8 @@ int dev_set_threaded(struct net_device *dev, bool threaded)
 }
 EXPORT_SYMBOL(dev_set_threaded);
 
-void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
-		    int (*poll)(struct napi_struct *, int), int weight)
+void netif_napi_add_weight(struct net_device *dev, struct napi_struct *napi,
+			   int (*poll)(struct napi_struct *, int), int weight)
 {
 	if (WARN_ON(test_and_set_bit(NAPI_STATE_LISTED, &napi->state)))
 		return;
@@ -6337,7 +6337,7 @@ void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
 	if (dev->threaded && napi_kthread_create(napi))
 		dev->threaded = 0;
 }
-EXPORT_SYMBOL(netif_napi_add);
+EXPORT_SYMBOL(netif_napi_add_weight);
 
 void napi_disable(struct napi_struct *n)
 {
-- 
2.34.1

