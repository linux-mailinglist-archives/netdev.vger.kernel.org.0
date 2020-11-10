Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7352ACD90
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 05:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387717AbgKJECp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 23:02:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:56300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733000AbgKJDzH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 22:55:07 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F18B620870;
        Tue, 10 Nov 2020 03:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604980506;
        bh=ngR+eEhE9rr6vZajJF1T7kU57sIScihzAvTclnLi42g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lQVqBS1Prfq060cCHcu4ME2aHI0LFt77c/FEvRh/n50beyWY0UOHkwtyPBpWRBapj
         OIQMZNcn1lfyY4s7Ar6CnmpX3s6W2SoBXemuMJgUh7tS7EeovZmYJ/yu8SdXiz9llj
         HQ+qeZnIQPjp59UjvVlfGQ66TCAegIi1rorZVOxo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 18/42] cfg80211: initialize wdev data earlier
Date:   Mon,  9 Nov 2020 22:54:16 -0500
Message-Id: <20201110035440.424258-18-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201110035440.424258-1-sashal@kernel.org>
References: <20201110035440.424258-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 9bdaf3b91efd229dd272b228e13df10310c80d19 ]

There's a race condition in the netdev registration in that
NETDEV_REGISTER actually happens after the netdev is available,
and so if we initialize things only there, we might get called
with an uninitialized wdev through nl80211 - not using a wdev
but using a netdev interface index.

I found this while looking into a syzbot report, but it doesn't
really seem to be related, and unfortunately there's no repro
for it (yet). I can't (yet) explain how it managed to get into
cfg80211_release_pmsr() from nl80211_netlink_notify() without
the wdev having been initialized, as the latter only iterates
the wdevs that are linked into the rdev, which even without the
change here happened after init.

However, looking at this, it seems fairly clear that the init
needs to be done earlier, otherwise we might even re-init on a
netns move, when data might still be pending.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Link: https://lore.kernel.org/r/20201009135821.fdcbba3aad65.Ie9201d91dbcb7da32318812effdc1561aeaf4cdc@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/core.c    | 57 +++++++++++++++++++++++-------------------
 net/wireless/core.h    |  5 ++--
 net/wireless/nl80211.c |  3 ++-
 3 files changed, 36 insertions(+), 29 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index ee5bb8d8af04e..5d151e8f89320 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1224,8 +1224,7 @@ void cfg80211_stop_iface(struct wiphy *wiphy, struct wireless_dev *wdev,
 }
 EXPORT_SYMBOL(cfg80211_stop_iface);
 
-void cfg80211_init_wdev(struct cfg80211_registered_device *rdev,
-			struct wireless_dev *wdev)
+void cfg80211_init_wdev(struct wireless_dev *wdev)
 {
 	mutex_init(&wdev->mtx);
 	INIT_LIST_HEAD(&wdev->event_list);
@@ -1236,6 +1235,30 @@ void cfg80211_init_wdev(struct cfg80211_registered_device *rdev,
 	spin_lock_init(&wdev->pmsr_lock);
 	INIT_WORK(&wdev->pmsr_free_wk, cfg80211_pmsr_free_wk);
 
+#ifdef CONFIG_CFG80211_WEXT
+	wdev->wext.default_key = -1;
+	wdev->wext.default_mgmt_key = -1;
+	wdev->wext.connect.auth_type = NL80211_AUTHTYPE_AUTOMATIC;
+#endif
+
+	if (wdev->wiphy->flags & WIPHY_FLAG_PS_ON_BY_DEFAULT)
+		wdev->ps = true;
+	else
+		wdev->ps = false;
+	/* allow mac80211 to determine the timeout */
+	wdev->ps_timeout = -1;
+
+	if ((wdev->iftype == NL80211_IFTYPE_STATION ||
+	     wdev->iftype == NL80211_IFTYPE_P2P_CLIENT ||
+	     wdev->iftype == NL80211_IFTYPE_ADHOC) && !wdev->use_4addr)
+		wdev->netdev->priv_flags |= IFF_DONT_BRIDGE;
+
+	INIT_WORK(&wdev->disconnect_wk, cfg80211_autodisconnect_wk);
+}
+
+void cfg80211_register_wdev(struct cfg80211_registered_device *rdev,
+			    struct wireless_dev *wdev)
+{
 	/*
 	 * We get here also when the interface changes network namespaces,
 	 * as it's registered into the new one, but we don't want it to
@@ -1269,6 +1292,11 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 	switch (state) {
 	case NETDEV_POST_INIT:
 		SET_NETDEV_DEVTYPE(dev, &wiphy_type);
+		wdev->netdev = dev;
+		/* can only change netns with wiphy */
+		dev->features |= NETIF_F_NETNS_LOCAL;
+
+		cfg80211_init_wdev(wdev);
 		break;
 	case NETDEV_REGISTER:
 		/*
@@ -1276,35 +1304,12 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		 * called within code protected by it when interfaces
 		 * are added with nl80211.
 		 */
-		/* can only change netns with wiphy */
-		dev->features |= NETIF_F_NETNS_LOCAL;
-
 		if (sysfs_create_link(&dev->dev.kobj, &rdev->wiphy.dev.kobj,
 				      "phy80211")) {
 			pr_err("failed to add phy80211 symlink to netdev!\n");
 		}
-		wdev->netdev = dev;
-#ifdef CONFIG_CFG80211_WEXT
-		wdev->wext.default_key = -1;
-		wdev->wext.default_mgmt_key = -1;
-		wdev->wext.connect.auth_type = NL80211_AUTHTYPE_AUTOMATIC;
-#endif
-
-		if (wdev->wiphy->flags & WIPHY_FLAG_PS_ON_BY_DEFAULT)
-			wdev->ps = true;
-		else
-			wdev->ps = false;
-		/* allow mac80211 to determine the timeout */
-		wdev->ps_timeout = -1;
-
-		if ((wdev->iftype == NL80211_IFTYPE_STATION ||
-		     wdev->iftype == NL80211_IFTYPE_P2P_CLIENT ||
-		     wdev->iftype == NL80211_IFTYPE_ADHOC) && !wdev->use_4addr)
-			dev->priv_flags |= IFF_DONT_BRIDGE;
-
-		INIT_WORK(&wdev->disconnect_wk, cfg80211_autodisconnect_wk);
 
-		cfg80211_init_wdev(rdev, wdev);
+		cfg80211_register_wdev(rdev, wdev);
 		break;
 	case NETDEV_GOING_DOWN:
 		cfg80211_leave(rdev, wdev);
diff --git a/net/wireless/core.h b/net/wireless/core.h
index ed487e3245714..d83c8e009448a 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -210,8 +210,9 @@ struct wiphy *wiphy_idx_to_wiphy(int wiphy_idx);
 int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
 			  struct net *net);
 
-void cfg80211_init_wdev(struct cfg80211_registered_device *rdev,
-			struct wireless_dev *wdev);
+void cfg80211_init_wdev(struct wireless_dev *wdev);
+void cfg80211_register_wdev(struct cfg80211_registered_device *rdev,
+			    struct wireless_dev *wdev);
 
 static inline void wdev_lock(struct wireless_dev *wdev)
 	__acquires(wdev)
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 672b70730e898..dbac5c0995a0f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3654,7 +3654,8 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
 		 * P2P Device and NAN do not have a netdev, so don't go
 		 * through the netdev notifier and must be added here
 		 */
-		cfg80211_init_wdev(rdev, wdev);
+		cfg80211_init_wdev(wdev);
+		cfg80211_register_wdev(rdev, wdev);
 		break;
 	default:
 		break;
-- 
2.27.0

