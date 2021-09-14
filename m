Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B73340B87B
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 21:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233353AbhINUAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 16:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233263AbhINUAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 16:00:44 -0400
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050::465:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55BCEC061574;
        Tue, 14 Sep 2021 12:59:26 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4H8DhD0b9RzQkBj;
        Tue, 14 Sep 2021 21:59:24 +0200 (CEST)
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
Subject: [PATCH 1/9] mwifiex: Small cleanup for handling virtual interface type changes
Date:   Tue, 14 Sep 2021 21:59:01 +0200
Message-Id: <20210914195909.36035-2-verdre@v0yd.nl>
In-Reply-To: <20210914195909.36035-1-verdre@v0yd.nl>
References: <20210914195909.36035-1-verdre@v0yd.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 356F11898
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Handle the obvious invalid virtual interface type changes with a general
check instead of looking at the individual change.

For type changes from P2P_CLIENT to P2P_GO and the other way round, this
changes the behavior slightly: We now still do nothing, but return
-EOPNOTSUPP instead of 0. Now that behavior was incorrect before and
still is, because type changes between these two types are actually
possible and supported, which we'll fix in a following commit.

Signed-off-by: Jonas Dreßler <verdre@v0yd.nl>
---
 .../net/wireless/marvell/mwifiex/cfg80211.c   | 39 +++++++------------
 1 file changed, 14 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 0961f4a5e415..e8deba119ff1 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -1141,6 +1141,20 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 		return -EBUSY;
 	}
 
+	if (type == NL80211_IFTYPE_UNSPECIFIED) {
+		mwifiex_dbg(priv->adapter, INFO,
+			    "%s: no new type specified, keeping old type %d\n",
+			    dev->name, curr_iftype);
+		return 0;
+	}
+
+	if (curr_iftype == type) {
+		mwifiex_dbg(priv->adapter, INFO,
+			    "%s: interface already is of type %d\n",
+			    dev->name, curr_iftype);
+		return 0;
+	}
+
 	switch (curr_iftype) {
 	case NL80211_IFTYPE_ADHOC:
 		switch (type) {
@@ -1160,12 +1174,6 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 		case NL80211_IFTYPE_AP:
 			return mwifiex_change_vif_to_ap(dev, curr_iftype, type,
 							params);
-		case NL80211_IFTYPE_UNSPECIFIED:
-			mwifiex_dbg(priv->adapter, INFO,
-				    "%s: kept type as IBSS\n", dev->name);
-			fallthrough;
-		case NL80211_IFTYPE_ADHOC:	/* This shouldn't happen */
-			return 0;
 		default:
 			mwifiex_dbg(priv->adapter, ERROR,
 				    "%s: changing to %d not supported\n",
@@ -1191,12 +1199,6 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 		case NL80211_IFTYPE_AP:
 			return mwifiex_change_vif_to_ap(dev, curr_iftype, type,
 							params);
-		case NL80211_IFTYPE_UNSPECIFIED:
-			mwifiex_dbg(priv->adapter, INFO,
-				    "%s: kept type as STA\n", dev->name);
-			fallthrough;
-		case NL80211_IFTYPE_STATION:	/* This shouldn't happen */
-			return 0;
 		default:
 			mwifiex_dbg(priv->adapter, ERROR,
 				    "%s: changing to %d not supported\n",
@@ -1214,12 +1216,6 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 		case NL80211_IFTYPE_P2P_GO:
 			return mwifiex_change_vif_to_p2p(dev, curr_iftype,
 							 type, params);
-		case NL80211_IFTYPE_UNSPECIFIED:
-			mwifiex_dbg(priv->adapter, INFO,
-				    "%s: kept type as AP\n", dev->name);
-			fallthrough;
-		case NL80211_IFTYPE_AP:		/* This shouldn't happen */
-			return 0;
 		default:
 			mwifiex_dbg(priv->adapter, ERROR,
 				    "%s: changing to %d not supported\n",
@@ -1254,13 +1250,6 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 				return -EFAULT;
 			return mwifiex_change_vif_to_ap(dev, curr_iftype, type,
 							params);
-		case NL80211_IFTYPE_UNSPECIFIED:
-			mwifiex_dbg(priv->adapter, INFO,
-				    "%s: kept type as P2P\n", dev->name);
-			fallthrough;
-		case NL80211_IFTYPE_P2P_CLIENT:
-		case NL80211_IFTYPE_P2P_GO:
-			return 0;
 		default:
 			mwifiex_dbg(priv->adapter, ERROR,
 				    "%s: changing to %d not supported\n",
-- 
2.31.1

