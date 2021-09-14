Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B27D40B885
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 22:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233775AbhINUBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 16:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233640AbhINUAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 16:00:54 -0400
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF74C061574;
        Tue, 14 Sep 2021 12:59:36 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4H8DhR1NGHzQjhQ;
        Tue, 14 Sep 2021 21:59:35 +0200 (CEST)
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
Subject: [PATCH 5/9] mwifiex: Update virtual interface counters right after setting bss_type
Date:   Tue, 14 Sep 2021 21:59:05 +0200
Message-Id: <20210914195909.36035-6-verdre@v0yd.nl>
In-Reply-To: <20210914195909.36035-1-verdre@v0yd.nl>
References: <20210914195909.36035-1-verdre@v0yd.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 57B83188F
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In mwifiex_init_new_priv_params() we update our private driver state to
reflect the currently selected virtual interface type. Most notably we
set the bss_mode to the mode we're going to put the firmware in.

Now after we updated the driver state we actually start talking to the
firmware and instruct it to set up the new mode. Those commands can and
will sometimes fail, in which case we return with an error from
mwifiex_change_vif_to_*. We currently update our virtual interface type
counters after this return, which means the code is never reached when a
firmware error happens and we never update the counters. Since we have
updated our bss_mode earlier though, the counters now no longer reflect
the actual state of the driver.

This will break things on the next virtual interface change, because the
virtual interface type we're switching away from didn't get its counter
incremented, and we end up decrementing a 0-counter.

To fix this, simply update the virtual interface type counters right
after updating our driver structures, so that they are always in sync.

Signed-off-by: Jonas Dreßler <verdre@v0yd.nl>
---
 .../net/wireless/marvell/mwifiex/cfg80211.c   | 25 +++++++++++--------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 8b9517c243c8..f2797102c5a2 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -1059,6 +1059,10 @@ mwifiex_change_vif_to_p2p(struct net_device *dev,
 	if (mwifiex_init_new_priv_params(priv, dev, type))
 		return -1;
 
+	update_vif_type_counter(adapter, curr_iftype, -1);
+	update_vif_type_counter(adapter, type, +1);
+	dev->ieee80211_ptr->iftype = type;
+
 	switch (type) {
 	case NL80211_IFTYPE_P2P_CLIENT:
 		if (mwifiex_cfg80211_init_p2p_client(priv))
@@ -1082,10 +1086,6 @@ mwifiex_change_vif_to_p2p(struct net_device *dev,
 	if (mwifiex_sta_init_cmd(priv, false, false))
 		return -1;
 
-	update_vif_type_counter(adapter, curr_iftype, -1);
-	update_vif_type_counter(adapter, type, +1);
-	dev->ieee80211_ptr->iftype = type;
-
 	return 0;
 }
 
@@ -1116,16 +1116,17 @@ mwifiex_change_vif_to_sta_adhoc(struct net_device *dev,
 		return -1;
 	if (mwifiex_init_new_priv_params(priv, dev, type))
 		return -1;
+
+	update_vif_type_counter(adapter, curr_iftype, -1);
+	update_vif_type_counter(adapter, type, +1);
+	dev->ieee80211_ptr->iftype = type;
+
 	if (mwifiex_send_cmd(priv, HostCmd_CMD_SET_BSS_MODE,
 			     HostCmd_ACT_GEN_SET, 0, NULL, true))
 		return -1;
 	if (mwifiex_sta_init_cmd(priv, false, false))
 		return -1;
 
-	update_vif_type_counter(adapter, curr_iftype, -1);
-	update_vif_type_counter(adapter, type, +1);
-	dev->ieee80211_ptr->iftype = type;
-
 	return 0;
 }
 
@@ -1152,15 +1153,17 @@ mwifiex_change_vif_to_ap(struct net_device *dev,
 		return -1;
 	if (mwifiex_init_new_priv_params(priv, dev, type))
 		return -1;
+
+	update_vif_type_counter(adapter, curr_iftype, -1);
+	update_vif_type_counter(adapter, type, +1);
+	dev->ieee80211_ptr->iftype = type;
+
 	if (mwifiex_send_cmd(priv, HostCmd_CMD_SET_BSS_MODE,
 			     HostCmd_ACT_GEN_SET, 0, NULL, true))
 		return -1;
 	if (mwifiex_sta_init_cmd(priv, false, false))
 		return -1;
 
-	update_vif_type_counter(adapter, curr_iftype, -1);
-	update_vif_type_counter(adapter, type, +1);
-	dev->ieee80211_ptr->iftype = type;
 	return 0;
 }
 /*
-- 
2.31.1

