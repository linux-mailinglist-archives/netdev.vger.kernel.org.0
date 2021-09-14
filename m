Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA9D40B888
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 22:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233769AbhINUBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 16:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233585AbhINUAx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 16:00:53 -0400
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [IPv6:2001:67c:2050::465:102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50397C0613DE;
        Tue, 14 Sep 2021 12:59:34 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4H8DhP0GnQzQkBS;
        Tue, 14 Sep 2021 21:59:33 +0200 (CEST)
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
Subject: [PATCH 4/9] mwifiex: Use helper function for counting interface types
Date:   Tue, 14 Sep 2021 21:59:04 +0200
Message-Id: <20210914195909.36035-5-verdre@v0yd.nl>
In-Reply-To: <20210914195909.36035-1-verdre@v0yd.nl>
References: <20210914195909.36035-1-verdre@v0yd.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0910A188F
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use a small helper function to increment and decrement the counter of
the interface types we currently manage. This makes the code that
actually changes and sets up the interface type a bit less messy and
also helps avoiding mistakes in case someone increments/decrements a
counter wrongly.

Signed-off-by: Jonas Dreßler <verdre@v0yd.nl>
---
 .../net/wireless/marvell/mwifiex/cfg80211.c   | 110 ++++++------------
 1 file changed, 35 insertions(+), 75 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 146aabe14753..8b9517c243c8 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -1009,6 +1009,32 @@ is_vif_type_change_allowed(struct mwifiex_adapter *adapter,
 	return false;
 }
 
+static void
+update_vif_type_counter(struct mwifiex_adapter *adapter,
+			enum nl80211_iftype iftype,
+			int change)
+{
+	switch (iftype) {
+	case NL80211_IFTYPE_UNSPECIFIED:
+	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_STATION:
+		adapter->curr_iface_comb.sta_intf += change;
+		break;
+	case NL80211_IFTYPE_AP:
+		adapter->curr_iface_comb.uap_intf += change;
+		break;
+	case NL80211_IFTYPE_P2P_CLIENT:
+	case NL80211_IFTYPE_P2P_GO:
+		adapter->curr_iface_comb.p2p_intf += change;
+		break;
+	default:
+		mwifiex_dbg(adapter, ERROR,
+			    "%s: Unsupported iftype passed: %d\n",
+			    __func__, iftype);
+		break;
+	}
+}
+
 static int
 mwifiex_change_vif_to_p2p(struct net_device *dev,
 			  enum nl80211_iftype curr_iftype,
@@ -1056,19 +1082,8 @@ mwifiex_change_vif_to_p2p(struct net_device *dev,
 	if (mwifiex_sta_init_cmd(priv, false, false))
 		return -1;
 
-	switch (curr_iftype) {
-	case NL80211_IFTYPE_STATION:
-	case NL80211_IFTYPE_ADHOC:
-		adapter->curr_iface_comb.sta_intf--;
-		break;
-	case NL80211_IFTYPE_AP:
-		adapter->curr_iface_comb.uap_intf--;
-		break;
-	default:
-		break;
-	}
-
-	adapter->curr_iface_comb.p2p_intf++;
+	update_vif_type_counter(adapter, curr_iftype, -1);
+	update_vif_type_counter(adapter, type, +1);
 	dev->ieee80211_ptr->iftype = type;
 
 	return 0;
@@ -1107,20 +1122,10 @@ mwifiex_change_vif_to_sta_adhoc(struct net_device *dev,
 	if (mwifiex_sta_init_cmd(priv, false, false))
 		return -1;
 
-	switch (curr_iftype) {
-	case NL80211_IFTYPE_P2P_CLIENT:
-	case NL80211_IFTYPE_P2P_GO:
-		adapter->curr_iface_comb.p2p_intf--;
-		break;
-	case NL80211_IFTYPE_AP:
-		adapter->curr_iface_comb.uap_intf--;
-		break;
-	default:
-		break;
-	}
-
-	adapter->curr_iface_comb.sta_intf++;
+	update_vif_type_counter(adapter, curr_iftype, -1);
+	update_vif_type_counter(adapter, type, +1);
 	dev->ieee80211_ptr->iftype = type;
+
 	return 0;
 }
 
@@ -1153,20 +1158,8 @@ mwifiex_change_vif_to_ap(struct net_device *dev,
 	if (mwifiex_sta_init_cmd(priv, false, false))
 		return -1;
 
-	switch (curr_iftype) {
-	case NL80211_IFTYPE_P2P_CLIENT:
-	case NL80211_IFTYPE_P2P_GO:
-		adapter->curr_iface_comb.p2p_intf--;
-		break;
-	case NL80211_IFTYPE_STATION:
-	case NL80211_IFTYPE_ADHOC:
-		adapter->curr_iface_comb.sta_intf--;
-		break;
-	default:
-		break;
-	}
-
-	adapter->curr_iface_comb.uap_intf++;
+	update_vif_type_counter(adapter, curr_iftype, -1);
+	update_vif_type_counter(adapter, type, +1);
 	dev->ieee80211_ptr->iftype = type;
 	return 0;
 }
@@ -3128,23 +3121,7 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 	mwifiex_dev_debugfs_init(priv);
 #endif
 
-	switch (type) {
-	case NL80211_IFTYPE_UNSPECIFIED:
-	case NL80211_IFTYPE_STATION:
-	case NL80211_IFTYPE_ADHOC:
-		adapter->curr_iface_comb.sta_intf++;
-		break;
-	case NL80211_IFTYPE_AP:
-		adapter->curr_iface_comb.uap_intf++;
-		break;
-	case NL80211_IFTYPE_P2P_CLIENT:
-		adapter->curr_iface_comb.p2p_intf++;
-		break;
-	default:
-		/* This should be dead code; checked above */
-		mwifiex_dbg(adapter, ERROR, "type not supported\n");
-		return ERR_PTR(-EINVAL);
-	}
+	update_vif_type_counter(adapter, type, +1);
 
 	return &priv->wdev;
 
@@ -3210,24 +3187,7 @@ int mwifiex_del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev)
 	/* Clear the priv in adapter */
 	priv->netdev = NULL;
 
-	switch (priv->bss_mode) {
-	case NL80211_IFTYPE_UNSPECIFIED:
-	case NL80211_IFTYPE_STATION:
-	case NL80211_IFTYPE_ADHOC:
-		adapter->curr_iface_comb.sta_intf--;
-		break;
-	case NL80211_IFTYPE_AP:
-		adapter->curr_iface_comb.uap_intf--;
-		break;
-	case NL80211_IFTYPE_P2P_CLIENT:
-	case NL80211_IFTYPE_P2P_GO:
-		adapter->curr_iface_comb.p2p_intf--;
-		break;
-	default:
-		mwifiex_dbg(adapter, ERROR,
-			    "del_virtual_intf: type not supported\n");
-		break;
-	}
+	update_vif_type_counter(adapter, priv->bss_mode, -1);
 
 	priv->bss_mode = NL80211_IFTYPE_UNSPECIFIED;
 
-- 
2.31.1

