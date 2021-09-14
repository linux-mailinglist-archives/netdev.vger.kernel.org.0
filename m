Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A480540B896
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 22:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233937AbhINUCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 16:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233763AbhINUA6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 16:00:58 -0400
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050::465:201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20595C0613D8;
        Tue, 14 Sep 2021 12:59:40 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4H8DhV5yNyzQjgH;
        Tue, 14 Sep 2021 21:59:38 +0200 (CEST)
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
Subject: [PATCH 6/9] mwifiex: Allow switching interface type from P2P_CLIENT to P2P_GO
Date:   Tue, 14 Sep 2021 21:59:06 +0200
Message-Id: <20210914195909.36035-7-verdre@v0yd.nl>
In-Reply-To: <20210914195909.36035-1-verdre@v0yd.nl>
References: <20210914195909.36035-1-verdre@v0yd.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EE06E188C
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's possible to change virtual interface type between P2P_CLIENT and
P2P_GO, the card supports that just fine, and it happens for example
when using miracast with the miraclecast software.

So allow type changes between P2P_CLIENT and P2P_GO and simply call into
mwifiex_change_vif_to_p2p(), which handles this just fine. We have to
call mwifiex_cfg80211_deinit_p2p() before though to make sure the old
p2p mode is properly uninitialized.

Signed-off-by: Jonas Dreßler <verdre@v0yd.nl>
---
 .../net/wireless/marvell/mwifiex/cfg80211.c   | 36 +++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index f2797102c5a2..ed4041ff9c89 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -990,11 +990,26 @@ is_vif_type_change_allowed(struct mwifiex_adapter *adapter,
 		}
 
 	case NL80211_IFTYPE_P2P_CLIENT:
+		switch (new_iftype) {
+		case NL80211_IFTYPE_ADHOC:
+		case NL80211_IFTYPE_STATION:
+			return true;
+		case NL80211_IFTYPE_P2P_GO:
+			return true;
+		case NL80211_IFTYPE_AP:
+			return adapter->curr_iface_comb.uap_intf !=
+			       adapter->iface_limit.uap_intf;
+		default:
+			return false;
+		}
+
 	case NL80211_IFTYPE_P2P_GO:
 		switch (new_iftype) {
 		case NL80211_IFTYPE_ADHOC:
 		case NL80211_IFTYPE_STATION:
 			return true;
+		case NL80211_IFTYPE_P2P_CLIENT:
+			return true;
 		case NL80211_IFTYPE_AP:
 			return adapter->curr_iface_comb.uap_intf !=
 			       adapter->iface_limit.uap_intf;
@@ -1265,6 +1280,24 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 		}
 
 	case NL80211_IFTYPE_P2P_CLIENT:
+		if (mwifiex_cfg80211_deinit_p2p(priv))
+			return -EFAULT;
+
+		switch (type) {
+		case NL80211_IFTYPE_ADHOC:
+		case NL80211_IFTYPE_STATION:
+			return mwifiex_change_vif_to_sta_adhoc(dev, curr_iftype,
+							       type, params);
+		case NL80211_IFTYPE_P2P_GO:
+			return mwifiex_change_vif_to_p2p(dev, curr_iftype,
+							 type, params);
+		case NL80211_IFTYPE_AP:
+			return mwifiex_change_vif_to_ap(dev, curr_iftype, type,
+							params);
+		default:
+			goto errnotsupp;
+		}
+
 	case NL80211_IFTYPE_P2P_GO:
 		if (mwifiex_cfg80211_deinit_p2p(priv))
 			return -EFAULT;
@@ -1274,6 +1307,9 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 		case NL80211_IFTYPE_STATION:
 			return mwifiex_change_vif_to_sta_adhoc(dev, curr_iftype,
 							       type, params);
+		case NL80211_IFTYPE_P2P_CLIENT:
+			return mwifiex_change_vif_to_p2p(dev, curr_iftype,
+							 type, params);
 		case NL80211_IFTYPE_AP:
 			return mwifiex_change_vif_to_ap(dev, curr_iftype, type,
 							params);
-- 
2.31.1

