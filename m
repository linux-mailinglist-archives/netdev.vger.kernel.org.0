Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0022529338
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 23:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348280AbiEPV4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 17:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345860AbiEPV4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 17:56:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB0435861;
        Mon, 16 May 2022 14:56:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0540FB8167E;
        Mon, 16 May 2022 21:56:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E64BC385AA;
        Mon, 16 May 2022 21:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652738204;
        bh=ls8JgtuOpHZ2dhUTbzwtVGDTIKO7WtBYziHxh3LZSZU=;
        h=From:To:Cc:Subject:Date:From;
        b=V/r3D+u2bdt+CXB8qu+SyLEotrkW0XR7/NAFmd2zPqtoZ63r6lUsQI2oFqF1kjWx9
         AWen9YpY8FpYoGKZXECjy4r2EQn735o7NjJZgODw6db7QlJ4/frz38f/xdSdFT9u5I
         YiG+3jcLuDVcW04vOsfqkF/b4LGTcG4EIf7HMOQLqetBSkb7U7KR9RfGUd03ndXuPQ
         FqmHJ3i8FeeICIp+CZl84CDCWx91s4lp4l8ZJ9RoIzPMqAXM6XnqIs7+GjdYjhIv38
         ra6391cW0k4oBMw0AlE4s2DrZp/IrQlvMcl3QMA4DevODw8kpXO5PcfF+v0VWVcz1U
         nNOBsEnwojAtA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, johannes@sipsolutions.net,
        alex.aring@gmail.com, stefan@datenfreihafen.org,
        mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        sven@narfation.org, linux-wireless@vger.kernel.org,
        linux-wpan@vger.kernel.org
Subject: [PATCH net-next] net: ifdefy the wireless pointers in struct net_device
Date:   Mon, 16 May 2022 14:56:38 -0700
Message-Id: <20220516215638.1787257-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most protocol-specific pointers in struct net_device are under
a respective ifdef. Wireless is the notable exception. Since
there's a sizable number of custom-built kernels for datacenter
workloads which don't build wireless it seems reasonable to
ifdefy those pointers as well.

While at it move IPv4 and IPv6 pointers up, those are special
for obvious reasons.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: johannes@sipsolutions.net
CC: alex.aring@gmail.com
CC: stefan@datenfreihafen.org
CC: mareklindner@neomailbox.ch
CC: sw@simonwunderlich.de
CC: a@unstable.cc
CC: sven@narfation.org
CC: linux-wireless@vger.kernel.org
CC: linux-wpan@vger.kernel.org
---
 include/linux/netdevice.h       | 8 ++++++--
 include/net/cfg80211.h          | 5 +----
 include/net/cfg802154.h         | 2 ++
 net/batman-adv/hard-interface.c | 2 ++
 net/wireless/core.c             | 6 ++++++
 5 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 536321691c72..f0604863f18c 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2119,6 +2119,8 @@ struct net_device {
 
 	/* Protocol-specific pointers */
 
+	struct in_device __rcu	*ip_ptr;
+	struct inet6_dev __rcu	*ip6_ptr;
 #if IS_ENABLED(CONFIG_VLAN_8021Q)
 	struct vlan_info __rcu	*vlan_info;
 #endif
@@ -2131,16 +2133,18 @@ struct net_device {
 #if IS_ENABLED(CONFIG_ATALK)
 	void 			*atalk_ptr;
 #endif
-	struct in_device __rcu	*ip_ptr;
 #if IS_ENABLED(CONFIG_DECNET)
 	struct dn_dev __rcu     *dn_ptr;
 #endif
-	struct inet6_dev __rcu	*ip6_ptr;
 #if IS_ENABLED(CONFIG_AX25)
 	void			*ax25_ptr;
 #endif
+#if IS_ENABLED(CONFIG_WIRELESS)
 	struct wireless_dev	*ieee80211_ptr;
+#endif
+#if IS_ENABLED(CONFIG_IEEE802154) || IS_ENABLED(CONFIG_6LOWPAN)
 	struct wpan_dev		*ieee802154_ptr;
+#endif
 #if IS_ENABLED(CONFIG_MPLS_ROUTING)
 	struct mpls_dev __rcu	*mpls_ptr;
 #endif
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 68713388b617..a4a7fc3241cf 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -8004,10 +8004,7 @@ int cfg80211_register_netdevice(struct net_device *dev);
  *
  * Requires the RTNL and wiphy mutex to be held.
  */
-static inline void cfg80211_unregister_netdevice(struct net_device *dev)
-{
-	cfg80211_unregister_wdev(dev->ieee80211_ptr);
-}
+void cfg80211_unregister_netdevice(struct net_device *dev);
 
 /**
  * struct cfg80211_ft_event_params - FT Information Elements
diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
index 85f9e8417688..d8d8719315fd 100644
--- a/include/net/cfg802154.h
+++ b/include/net/cfg802154.h
@@ -373,6 +373,7 @@ struct wpan_dev {
 
 #define to_phy(_dev)	container_of(_dev, struct wpan_phy, dev)
 
+#if IS_ENABLED(CONFIG_IEEE802154) || IS_ENABLED(CONFIG_6LOWPAN)
 static inline int
 wpan_dev_hard_header(struct sk_buff *skb, struct net_device *dev,
 		     const struct ieee802154_addr *daddr,
@@ -383,6 +384,7 @@ wpan_dev_hard_header(struct sk_buff *skb, struct net_device *dev,
 
 	return wpan_dev->header_ops->create(skb, dev, daddr, saddr, len);
 }
+#endif
 
 struct wpan_phy *
 wpan_phy_new(const struct cfg802154_ops *ops, size_t priv_size);
diff --git a/net/batman-adv/hard-interface.c b/net/batman-adv/hard-interface.c
index 83fb51b6e299..15d2bb4cd301 100644
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -307,9 +307,11 @@ static bool batadv_is_cfg80211_netdev(struct net_device *net_device)
 	if (!net_device)
 		return false;
 
+#if IS_ENABLED(CONFIG_WIRELESS)
 	/* cfg80211 drivers have to set ieee80211_ptr */
 	if (net_device->ieee80211_ptr)
 		return true;
+#endif
 
 	return false;
 }
diff --git a/net/wireless/core.c b/net/wireless/core.c
index f08d4b3bb148..a24944e6d01e 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1374,6 +1374,12 @@ int cfg80211_register_netdevice(struct net_device *dev)
 }
 EXPORT_SYMBOL(cfg80211_register_netdevice);
 
+void cfg80211_unregister_netdevice(struct net_device *dev)
+{
+	cfg80211_unregister_wdev(dev->ieee80211_ptr);
+}
+EXPORT_SYMBOL(cfg80211_unregister_netdevice);
+
 static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 					 unsigned long state, void *ptr)
 {
-- 
2.34.3

