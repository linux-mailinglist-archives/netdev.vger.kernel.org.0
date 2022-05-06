Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65ABA51CF1B
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 04:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388387AbiEFCzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 22:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388376AbiEFCzb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 22:55:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A731E5E151
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 19:51:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 589E6B83276
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 02:51:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAEFBC385A4;
        Fri,  6 May 2022 02:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651805508;
        bh=qE/eZqZHwhNyM1NGAjcnTztSUce3myhJ3er4Ta0Dnz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PUCh5zwHeQteGGHifYUV9wvodbyxAK/WejvBuv9nx1ZGj7ZfZ31QVtoApoWqZq9af
         6pN6y/akF8JCIiZP0i560trxcNkT6wVNVY7sdeIToTT9oi0KPbUoX7nnVI2z7hvixQ
         qPrTphaUgBQc13YPlJpBod9li2LJPSOSXRim3ok5ZPCqYRKfdPFsTTW55/x7PdyEoL
         NgGVld6dZ9LPDgK109GckozRgxIaWkFf0BKNuNFVMWmFQsQtDz4tCnz34oiRYrW9dw
         nX91PJVIKgqDL3E3YsFaqMuwNV0vhsN4JppXSANV1vcMxcbZpyp5zipPRgL7KqrrU6
         d0UaYIwRct5jA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        alexander.duyck@gmail.com, stephen@networkplumber.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 4/4] net: move netif_set_gso_max helpers
Date:   Thu,  5 May 2022 19:51:34 -0700
Message-Id: <20220506025134.794537-5-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220506025134.794537-1-kuba@kernel.org>
References: <20220506025134.794537-1-kuba@kernel.org>
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

These are now internal to the core, no need to expose them.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/netdevice.h | 21 ---------------------
 net/core/dev.h            | 21 +++++++++++++++++++++
 2 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index e12f7de6d6ae..8cf0ac616cb9 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4881,27 +4881,6 @@ static inline bool netif_needs_gso(struct sk_buff *skb,
 			 (skb->ip_summed != CHECKSUM_UNNECESSARY)));
 }
 
-static inline void netif_set_gso_max_size(struct net_device *dev,
-					  unsigned int size)
-{
-	/* dev->gso_max_size is read locklessly from sk_setup_caps() */
-	WRITE_ONCE(dev->gso_max_size, size);
-}
-
-static inline void netif_set_gso_max_segs(struct net_device *dev,
-					  unsigned int segs)
-{
-	/* dev->gso_max_segs is read locklessly from sk_setup_caps() */
-	WRITE_ONCE(dev->gso_max_segs, segs);
-}
-
-static inline void netif_set_gro_max_size(struct net_device *dev,
-					  unsigned int size)
-{
-	/* This pairs with the READ_ONCE() in skb_gro_receive() */
-	WRITE_ONCE(dev->gro_max_size, size);
-}
-
 void netif_set_tso_max_size(struct net_device *dev, unsigned int size);
 void netif_set_tso_max_segs(struct net_device *dev, unsigned int segs);
 void netif_inherit_tso_max(struct net_device *to,
diff --git a/net/core/dev.h b/net/core/dev.h
index 27923df00637..328b37af90ba 100644
--- a/net/core/dev.h
+++ b/net/core/dev.h
@@ -88,4 +88,25 @@ int dev_change_carrier(struct net_device *dev, bool new_carrier);
 
 void __dev_set_rx_mode(struct net_device *dev);
 
+static inline void netif_set_gso_max_size(struct net_device *dev,
+					  unsigned int size)
+{
+	/* dev->gso_max_size is read locklessly from sk_setup_caps() */
+	WRITE_ONCE(dev->gso_max_size, size);
+}
+
+static inline void netif_set_gso_max_segs(struct net_device *dev,
+					  unsigned int segs)
+{
+	/* dev->gso_max_segs is read locklessly from sk_setup_caps() */
+	WRITE_ONCE(dev->gso_max_segs, segs);
+}
+
+static inline void netif_set_gro_max_size(struct net_device *dev,
+					  unsigned int size)
+{
+	/* This pairs with the READ_ONCE() in skb_gro_receive() */
+	WRITE_ONCE(dev->gro_max_size, size);
+}
+
 #endif
-- 
2.34.1

