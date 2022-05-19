Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C72752DE3E
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 22:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244665AbiESUVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 16:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244685AbiESUVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 16:21:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A715B485;
        Thu, 19 May 2022 13:20:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D22C4B82844;
        Thu, 19 May 2022 20:20:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A958C385AA;
        Thu, 19 May 2022 20:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652991656;
        bh=8RL1uVxBlhAXGfSvxv6Av5XAUj5QRCkYw0P78PhQGyw=;
        h=From:To:Cc:Subject:Date:From;
        b=lyrHZ2YjMya82/jnIPhFupCrz9WtVJwa5F/AnoVXc/2nCRfOEe6USyMYfwtKyS82f
         j0CN6r6V68979dexO1At0Bei1uqK0OViPqo5pPss6Z/AUZhJvyTXeb3zSIlrpZn7m+
         HVNGzE9PAFnoF1rO2mPCJ5eV6YEqly4H0HoE623DvSrP/4GO9FIVuH9FekuT09bbTm
         tH7sHSDtU3xB49D1ESMjozD5gsWQCAAzlgTBFEEaCcTDAQ95B1x5fmRcHX8dpBoLIO
         fc7LwvXbEBn0Vx1hfzjxqHx2RBoQ5osNrNAhsGdgsULlxYwvgeSx2+Q8p5OhvAKDoU
         /EmKz3PvayS0g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sven Eckelmann <sven@narfation.org>, alex.aring@gmail.com,
        mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        linux-wireless@vger.kernel.org, linux-wpan@vger.kernel.org
Subject: [PATCH net-next v3] net: wrap the wireless pointers in struct net_device in an ifdef
Date:   Thu, 19 May 2022 13:20:54 -0700
Message-Id: <20220519202054.2200749-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Acked-by: Johannes Berg <johannes@sipsolutions.net>
Acked-by: Stefan Schmidt <stefan@datenfreihafen.org> # ieee802154
Acked-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
v1: https://lore.kernel.org/all/20220516215638.1787257-1-kuba@kernel.org/
v2: https://lore.kernel.org/all/20220518181807.2030747-1-kuba@kernel.org/
    - CONFIG_WIRELESS -> CONFIG_CFG80211 (this needs a bit of
      untangling in sysfs)
    - keep cfg80211_unregister_netdevice in the header
v3: - backtrack the joyous verbification of the subject
    - fix the kbuild bot-caught failure
      we can make wireless_group visible now, the compiler is
      good enough at dead data elimination (data size == 22636,
      by which I mean I checked)

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
 include/linux/netdevice.h       |  8 ++++++--
 include/net/cfg80211.h          |  2 ++
 include/net/cfg802154.h         |  2 ++
 net/batman-adv/hard-interface.c |  2 ++
 net/core/net-sysfs.c            | 21 +++++++++++++--------
 5 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 1ce91cb8074a..f615a66c89e9 100644
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
+#if IS_ENABLED(CONFIG_CFG80211)
 	struct wireless_dev	*ieee80211_ptr;
+#endif
+#if IS_ENABLED(CONFIG_IEEE802154) || IS_ENABLED(CONFIG_6LOWPAN)
 	struct wpan_dev		*ieee802154_ptr;
+#endif
 #if IS_ENABLED(CONFIG_MPLS_ROUTING)
 	struct mpls_dev __rcu	*mpls_ptr;
 #endif
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 68713388b617..d523b1e49d1e 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -8006,7 +8006,9 @@ int cfg80211_register_netdevice(struct net_device *dev);
  */
 static inline void cfg80211_unregister_netdevice(struct net_device *dev)
 {
+#if IS_ENABLED(CONFIG_CFG80211)
 	cfg80211_unregister_wdev(dev->ieee80211_ptr);
+#endif
 }
 
 /**
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
index 83fb51b6e299..b8f8da7ee3de 100644
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -307,9 +307,11 @@ static bool batadv_is_cfg80211_netdev(struct net_device *net_device)
 	if (!net_device)
 		return false;
 
+#if IS_ENABLED(CONFIG_CFG80211)
 	/* cfg80211 drivers have to set ieee80211_ptr */
 	if (net_device->ieee80211_ptr)
 		return true;
+#endif
 
 	return false;
 }
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 4980c3a50475..e319e242dddf 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -746,7 +746,6 @@ static const struct attribute_group netstat_group = {
 	.attrs  = netstat_attrs,
 };
 
-#if IS_ENABLED(CONFIG_WIRELESS_EXT) || IS_ENABLED(CONFIG_CFG80211)
 static struct attribute *wireless_attrs[] = {
 	NULL
 };
@@ -755,7 +754,19 @@ static const struct attribute_group wireless_group = {
 	.name = "wireless",
 	.attrs = wireless_attrs,
 };
+
+static bool wireless_group_needed(struct net_device *ndev)
+{
+#if IS_ENABLED(CONFIG_CFG80211)
+	if (ndev->ieee80211_ptr)
+		return true;
 #endif
+#if IS_ENABLED(CONFIG_WIRELESS_EXT)
+	if (ndev->wireless_handlers)
+		return true;
+#endif
+	return false;
+}
 
 #else /* CONFIG_SYSFS */
 #define net_class_groups	NULL
@@ -1996,14 +2007,8 @@ int netdev_register_kobject(struct net_device *ndev)
 
 	*groups++ = &netstat_group;
 
-#if IS_ENABLED(CONFIG_WIRELESS_EXT) || IS_ENABLED(CONFIG_CFG80211)
-	if (ndev->ieee80211_ptr)
-		*groups++ = &wireless_group;
-#if IS_ENABLED(CONFIG_WIRELESS_EXT)
-	else if (ndev->wireless_handlers)
+	if (wireless_group_needed(ndev))
 		*groups++ = &wireless_group;
-#endif
-#endif
 #endif /* CONFIG_SYSFS */
 
 	error = device_add(dev);
-- 
2.34.3

