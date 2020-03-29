Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D035E19705B
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 22:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728848AbgC2UuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 16:50:24 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:37154 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727370AbgC2UuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 16:50:23 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jIesj-003vlB-Sy; Sun, 29 Mar 2020 22:50:10 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, j@w1.fi,
        Johannes Berg <johannes.berg@intel.com>, stable@vger.kernel.org
Subject: [PATCH v2] mac80211: fix authentication with iwlwifi/mvm
Date:   Sun, 29 Mar 2020 22:50:06 +0200
Message-Id: <20200329225004.115da08b271d.I9712908b102ee30fe76fa72c9ec93c92f52ab689@changeid>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

The original patch didn't copy the ieee80211_is_data() condition
because on most drivers the management frames don't go through
this path. However, they do on iwlwifi/mvm, so we do need to keep
the condition here.

Cc: stable@vger.kernel.org
Fixes: ce2e1ca70307 ("mac80211: Check port authorization in the ieee80211_tx_dequeue() case")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
Dave, can you please apply this directly?

(sorry, I shall remember to use git commit --amend properly)

---
 net/mac80211/tx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index d9cca6dbd870..efe4c1fc68e5 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3610,7 +3610,8 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 		 * Drop unicast frames to unauthorised stations unless they are
 		 * EAPOL frames from the local station.
 		 */
-		if (unlikely(!ieee80211_vif_is_mesh(&tx.sdata->vif) &&
+		if (unlikely(ieee80211_is_data(hdr->frame_control) &&
+			     !ieee80211_vif_is_mesh(&tx.sdata->vif) &&
 			     tx.sdata->vif.type != NL80211_IFTYPE_OCB &&
 			     !is_multicast_ether_addr(hdr->addr1) &&
 			     !test_sta_flag(tx.sta, WLAN_STA_AUTHORIZED) &&
-- 
2.25.1

