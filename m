Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA16240B87D
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 21:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233416AbhINUAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 16:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233389AbhINUAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 16:00:46 -0400
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E8AC061574;
        Tue, 14 Sep 2021 12:59:28 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4H8DhG4Yq6zQjhQ;
        Tue, 14 Sep 2021 21:59:26 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
From:   =?UTF-8?q?Jonas=20Dre=C3=9Fler?= <verdre@v0yd.nl>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     =?UTF-8?q?Jonas=20Dre=C3=9Fler?= <verdre@v0yd.nl>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Subject: [PATCH 2/9] mwifiex: Use function to check whether interface type change is allowed
Date:   Tue, 14 Sep 2021 21:59:02 +0200
Message-Id: <20210914195909.36035-3-verdre@v0yd.nl>
In-Reply-To: <20210914195909.36035-1-verdre@v0yd.nl>
References: <20210914195909.36035-1-verdre@v0yd.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AE7E11898
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of bailing out in the function which is supposed to do the type
change, detect invalid changes beforehand using a generic function and
return an error if the change is not allowed.

Signed-off-by: Jonas Dreßler <verdre@v0yd.nl>
---
 .../net/wireless/marvell/mwifiex/cfg80211.c   | 139 ++++++++++++------
 1 file changed, 92 insertions(+), 47 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index e8deba119ff1..dabc59c47de3 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -939,6 +939,76 @@ mwifiex_init_new_priv_params(struct mwifiex_private *priv,
 	return 0;
 }
 
+static bool
+is_vif_type_change_allowed(struct mwifiex_adapter *adapter,
+			   enum nl80211_iftype old_iftype,
+			   enum nl80211_iftype new_iftype)
+{
+	switch (old_iftype) {
+	case NL80211_IFTYPE_ADHOC:
+		switch (new_iftype) {
+		case NL80211_IFTYPE_STATION:
+			return true;
+		case NL80211_IFTYPE_P2P_CLIENT:
+		case NL80211_IFTYPE_P2P_GO:
+			return adapter->curr_iface_comb.p2p_intf !=
+			       adapter->iface_limit.p2p_intf;
+		case NL80211_IFTYPE_AP:
+			return adapter->curr_iface_comb.uap_intf !=
+			       adapter->iface_limit.uap_intf;
+		default:
+			return false;
+		}
+
+	case NL80211_IFTYPE_STATION:
+		switch (new_iftype) {
+		case NL80211_IFTYPE_ADHOC:
+			return true;
+		case NL80211_IFTYPE_P2P_CLIENT:
+		case NL80211_IFTYPE_P2P_GO:
+			return adapter->curr_iface_comb.p2p_intf !=
+			       adapter->iface_limit.p2p_intf;
+		case NL80211_IFTYPE_AP:
+			return adapter->curr_iface_comb.uap_intf !=
+			       adapter->iface_limit.uap_intf;
+		default:
+			return false;
+		}
+
+	case NL80211_IFTYPE_AP:
+		switch (new_iftype) {
+		case NL80211_IFTYPE_ADHOC:
+		case NL80211_IFTYPE_STATION:
+			return adapter->curr_iface_comb.sta_intf !=
+			       adapter->iface_limit.sta_intf;
+		case NL80211_IFTYPE_P2P_CLIENT:
+		case NL80211_IFTYPE_P2P_GO:
+			return adapter->curr_iface_comb.p2p_intf !=
+			       adapter->iface_limit.p2p_intf;
+		default:
+			return false;
+		}
+
+	case NL80211_IFTYPE_P2P_CLIENT:
+	case NL80211_IFTYPE_P2P_GO:
+		switch (new_iftype) {
+		case NL80211_IFTYPE_ADHOC:
+		case NL80211_IFTYPE_STATION:
+			return true;
+		case NL80211_IFTYPE_AP:
+			return adapter->curr_iface_comb.uap_intf !=
+			       adapter->iface_limit.uap_intf;
+		default:
+			return false;
+		}
+
+	default:
+		break;
+	}
+
+	return false;
+}
+
 static int
 mwifiex_change_vif_to_p2p(struct net_device *dev,
 			  enum nl80211_iftype curr_iftype,
@@ -955,13 +1025,6 @@ mwifiex_change_vif_to_p2p(struct net_device *dev,
 
 	adapter = priv->adapter;
 
-	if (adapter->curr_iface_comb.p2p_intf ==
-	    adapter->iface_limit.p2p_intf) {
-		mwifiex_dbg(adapter, ERROR,
-			    "cannot create multiple P2P ifaces\n");
-		return -1;
-	}
-
 	mwifiex_dbg(adapter, INFO,
 		    "%s: changing role to p2p\n", dev->name);
 
@@ -1027,15 +1090,6 @@ mwifiex_change_vif_to_sta_adhoc(struct net_device *dev,
 
 	adapter = priv->adapter;
 
-	if ((curr_iftype != NL80211_IFTYPE_P2P_CLIENT &&
-	     curr_iftype != NL80211_IFTYPE_P2P_GO) &&
-	    (adapter->curr_iface_comb.sta_intf ==
-	     adapter->iface_limit.sta_intf)) {
-		mwifiex_dbg(adapter, ERROR,
-			    "cannot create multiple station/adhoc ifaces\n");
-		return -1;
-	}
-
 	if (type == NL80211_IFTYPE_STATION)
 		mwifiex_dbg(adapter, INFO,
 			    "%s: changing role to station\n", dev->name);
@@ -1086,13 +1140,6 @@ mwifiex_change_vif_to_ap(struct net_device *dev,
 
 	adapter = priv->adapter;
 
-	if (adapter->curr_iface_comb.uap_intf ==
-	    adapter->iface_limit.uap_intf) {
-		mwifiex_dbg(adapter, ERROR,
-			    "cannot create multiple AP ifaces\n");
-		return -1;
-	}
-
 	mwifiex_dbg(adapter, INFO,
 		    "%s: changing role to AP\n", dev->name);
 
@@ -1155,6 +1202,13 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 		return 0;
 	}
 
+	if (!is_vif_type_change_allowed(priv->adapter, curr_iftype, type)) {
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "%s: change from type %d to %d is not allowed\n",
+			    dev->name, curr_iftype, type);
+		return -EOPNOTSUPP;
+	}
+
 	switch (curr_iftype) {
 	case NL80211_IFTYPE_ADHOC:
 		switch (type) {
@@ -1175,12 +1229,9 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 			return mwifiex_change_vif_to_ap(dev, curr_iftype, type,
 							params);
 		default:
-			mwifiex_dbg(priv->adapter, ERROR,
-				    "%s: changing to %d not supported\n",
-				    dev->name, type);
-			return -EOPNOTSUPP;
+			goto errnotsupp;
 		}
-		break;
+
 	case NL80211_IFTYPE_STATION:
 		switch (type) {
 		case NL80211_IFTYPE_ADHOC:
@@ -1200,12 +1251,9 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 			return mwifiex_change_vif_to_ap(dev, curr_iftype, type,
 							params);
 		default:
-			mwifiex_dbg(priv->adapter, ERROR,
-				    "%s: changing to %d not supported\n",
-				    dev->name, type);
-			return -EOPNOTSUPP;
+			goto errnotsupp;
 		}
-		break;
+
 	case NL80211_IFTYPE_AP:
 		switch (type) {
 		case NL80211_IFTYPE_ADHOC:
@@ -1217,12 +1265,9 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 			return mwifiex_change_vif_to_p2p(dev, curr_iftype,
 							 type, params);
 		default:
-			mwifiex_dbg(priv->adapter, ERROR,
-				    "%s: changing to %d not supported\n",
-				    dev->name, type);
-			return -EOPNOTSUPP;
+			goto errnotsupp;
 		}
-		break;
+
 	case NL80211_IFTYPE_P2P_CLIENT:
 	case NL80211_IFTYPE_P2P_GO:
 		switch (type) {
@@ -1251,21 +1296,21 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 			return mwifiex_change_vif_to_ap(dev, curr_iftype, type,
 							params);
 		default:
-			mwifiex_dbg(priv->adapter, ERROR,
-				    "%s: changing to %d not supported\n",
-				    dev->name, type);
-			return -EOPNOTSUPP;
+			goto errnotsupp;
 		}
-		break;
+
 	default:
-		mwifiex_dbg(priv->adapter, ERROR,
-			    "%s: unknown iftype: %d\n",
-			    dev->name, dev->ieee80211_ptr->iftype);
-		return -EOPNOTSUPP;
+		goto errnotsupp;
 	}
 
 
 	return 0;
+
+errnotsupp:
+	mwifiex_dbg(priv->adapter, ERROR,
+		    "unsupported interface type transition: %d to %d\n",
+		    curr_iftype, type);
+	return -EOPNOTSUPP;
 }
 
 static void
-- 
2.31.1

