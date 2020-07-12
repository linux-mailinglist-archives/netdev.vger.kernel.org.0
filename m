Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6761D21CABE
	for <lists+netdev@lfdr.de>; Sun, 12 Jul 2020 19:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729352AbgGLRfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 13:35:48 -0400
Received: from smtp11.smtpout.orange.fr ([80.12.242.133]:50562 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729292AbgGLRfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 13:35:47 -0400
Received: from localhost.localdomain ([93.22.148.52])
        by mwinf5d89 with ME
        id 2Hbh2300C183tQl03HbijK; Sun, 12 Jul 2020 19:35:44 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 12 Jul 2020 19:35:44 +0200
X-ME-IP: 93.22.148.52
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     johannes@sipsolutions.net, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 1/2] nl80211: Remove a misleading label in 'nl80211_trigger_scan()'
Date:   Sun, 12 Jul 2020 19:35:39 +0200
Message-Id: <20200712173539.274395-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 5fe231e87372 ("cfg80211: vastly simplify locking"), the
'unlock' label at the end of 'nl80211_trigger_scan()' is useless and
misleading, because nothing is unlocked there.

Direct return can be used instead of 'err = -<error code>; goto unlock;'
construction.

Remove this label and simplify code accordingly.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 net/wireless/nl80211.c | 31 ++++++++++---------------------
 1 file changed, 10 insertions(+), 21 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 98bfc6a1c806..a671ee5f5da7 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7774,10 +7774,8 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 	if (!rdev->ops->scan)
 		return -EOPNOTSUPP;
 
-	if (rdev->scan_req || rdev->scan_msg) {
-		err = -EBUSY;
-		goto unlock;
-	}
+	if (rdev->scan_req || rdev->scan_msg)
+		return -EBUSY;
 
 	if (info->attrs[NL80211_ATTR_SCAN_FREQ_KHZ]) {
 		if (!wiphy_ext_feature_isset(wiphy,
@@ -7790,10 +7788,8 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 
 	if (scan_freqs) {
 		n_channels = validate_scan_freqs(scan_freqs);
-		if (!n_channels) {
-			err = -EINVAL;
-			goto unlock;
-		}
+		if (!n_channels)
+			return -EINVAL;
 	} else {
 		n_channels = ieee80211_get_num_supported_channels(wiphy);
 	}
@@ -7802,29 +7798,23 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 		nla_for_each_nested(attr, info->attrs[NL80211_ATTR_SCAN_SSIDS], tmp)
 			n_ssids++;
 
-	if (n_ssids > wiphy->max_scan_ssids) {
-		err = -EINVAL;
-		goto unlock;
-	}
+	if (n_ssids > wiphy->max_scan_ssids)
+		return -EINVAL;
 
 	if (info->attrs[NL80211_ATTR_IE])
 		ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
 	else
 		ie_len = 0;
 
-	if (ie_len > wiphy->max_scan_ie_len) {
-		err = -EINVAL;
-		goto unlock;
-	}
+	if (ie_len > wiphy->max_scan_ie_len)
+		return -EINVAL;
 
 	request = kzalloc(sizeof(*request)
 			+ sizeof(*request->ssids) * n_ssids
 			+ sizeof(*request->channels) * n_channels
 			+ ie_len, GFP_KERNEL);
-	if (!request) {
-		err = -ENOMEM;
-		goto unlock;
-	}
+	if (!request)
+		return -ENOMEM;
 
 	if (n_ssids)
 		request->ssids = (void *)&request->channels[n_channels];
@@ -8013,7 +8003,6 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 		kfree(request);
 	}
 
- unlock:
 	return err;
 }
 
-- 
2.25.1

