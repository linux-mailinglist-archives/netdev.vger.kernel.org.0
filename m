Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 797E34E7CA3
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233575AbiCYVwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 17:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233563AbiCYVwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 17:52:14 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC1F641D
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 14:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=AmgDzcqO0uIzaQ0++POPJ1R2r+BTGhJcDvpNHeafAlE=; t=1648245039; x=1649454639; 
        b=GSdSvJQWLuNxMkTMtxLecq5OXnx7j772pTtGO01jcIgc5uAXddQWk6G22N402MRjUR6pQIpchFa
        17fYek8YirsErEjxPjjWUpvQwoD/TD3MhPFoCoc8FqjLycW6ZVkfSTZCKbbo9FTgRSCLe1un501du
        5vKldDaAFWs1g+SY2+XuQLOmlEibnVOF4ia/WKLJL8iYNnNBcH4ZA/bP9olr85YjqNn3f9iMrpqU1
        +aiGYR9kFQh0WAJHLNXfzfTXwBnaygeVoFNq9/PtIsH2ynYeuT6QgFxKlREXBOiiXqO0r86xbIw/d
        VCN1qW8x/e8dRdscucr6BukHtrMAaA2ti+2Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1nXrpK-000WZ7-5c;
        Fri, 25 Mar 2022 22:50:34 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] net: move net_unlink_todo() out of the header
Date:   Fri, 25 Mar 2022 22:50:23 +0100
Message-Id: <20220325225023.f49b9056fe1c.I6b901a2df00000837a9bd251a8dd259bd23f5ded@changeid>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

There's no reason for this to be in netdevice.h, it's all
just used in dev.c. Also make it no longer inline and let
the compiler decide to do that by itself.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/netdevice.h | 10 ----------
 net/core/dev.c            | 10 ++++++++++
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index cd7a597c55b1..59e27a2b7bf0 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4601,16 +4601,6 @@ bool netdev_has_upper_dev(struct net_device *dev, struct net_device *upper_dev);
 struct net_device *netdev_upper_get_next_dev_rcu(struct net_device *dev,
 						     struct list_head **iter);
 
-#ifdef CONFIG_LOCKDEP
-static LIST_HEAD(net_unlink_list);
-
-static inline void net_unlink_todo(struct net_device *dev)
-{
-	if (list_empty(&dev->unlink_list))
-		list_add_tail(&dev->unlink_list, &net_unlink_list);
-}
-#endif
-
 /* iterate through upper list, must be called under RCU read lock */
 #define netdev_for_each_upper_dev_rcu(dev, updev, iter) \
 	for (iter = &(dev)->adj_list.upper, \
diff --git a/net/core/dev.c b/net/core/dev.c
index 8a5109479dbe..8c6c08446556 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -7193,6 +7193,16 @@ static int __netdev_update_upper_level(struct net_device *dev,
 	return 0;
 }
 
+#ifdef CONFIG_LOCKDEP
+static LIST_HEAD(net_unlink_list);
+
+static void net_unlink_todo(struct net_device *dev)
+{
+	if (list_empty(&dev->unlink_list))
+		list_add_tail(&dev->unlink_list, &net_unlink_list);
+}
+#endif
+
 static int __netdev_update_lower_level(struct net_device *dev,
 				       struct netdev_nested_priv *priv)
 {
-- 
2.35.1

