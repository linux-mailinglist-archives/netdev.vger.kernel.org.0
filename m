Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 665592CF675
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 23:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728252AbgLDV7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 16:59:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbgLDV7o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 16:59:44 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59ACCC0613D1;
        Fri,  4 Dec 2020 13:59:04 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id n10so4352387pgv.8;
        Fri, 04 Dec 2020 13:59:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bOYSy1/W+IvqY8VNMWbqot9NddWFzlzpEDfybh9Rd5c=;
        b=b2vEQeoXBtlIel+He++NoP+ym6WgZmlCXqhipUZQDrxaUKcn1aRJaKyA13lmTPgdY+
         NIZbE6Wrla+D4fgayTHMmef2G9qSWr0ku6EbwofDp7w54P2Q7uvGpJDhKrySfjvKdUqa
         jfWJssdr8Q5Gjw/Qms4ebI/SmIweC5lqiNGblxN+s3Vlu5rxrRPeSFO46TUoVXUBwRTs
         l8PxheIhtfHZ9ZNK2DZIGYqR9BGVPEdqSWoFTewbRX79j4OvemBZTifRgCROD7BXM75R
         RjElmoZzHEUvvJV2OxPeA4gw65QlDI1E/g9FzLQhO3PgeV+RVcGOdfQWFEoQSdMf/SXi
         MfZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bOYSy1/W+IvqY8VNMWbqot9NddWFzlzpEDfybh9Rd5c=;
        b=X//MM4sYHHMf9h8mVVE6PTVbfBjXmcux1X9rb7351ooAyfg0nh53hYf8/DD9Ile821
         waO3aUWYBww5jQRVsn1yKzN8mAVfe0Rd6J2oYjYdp1altGeb9ar82XK1mO7V5XjGXeCl
         dFf0dlDJv339KGk4iG7Ql02q+t9X5JZ/z9yKcOu+NeVTCJ3KjNOZpiei5QANWuV1tGo2
         bRI+GC+VAiiuFBMSpCxFjN921zvC48blHPtkkL232rc3rdm7mPvD8OJduNg3ZBstmK82
         t5Igt5EBKHfqicR1g9MKqff69RZ6x797qdCkLcKuGoMkjpERY9GwiRkeKnm1/5YuJ1Aw
         OjMA==
X-Gm-Message-State: AOAM532uqWC/axmLIjlgl3RItgEIQD/1kC7TO1uXJejj8PAUTLHUYoFC
        joPP4HnFjk4Sb5EezGDnidK4HbRilQxpT4TX
X-Google-Smtp-Source: ABdhPJxWZkwKOMw5wsvhYFHPjNU09TJegdW4joQRoUqOVAx1CiDNQolr7Dx7r+0KyjWzdasJM90s+g==
X-Received: by 2002:a63:4716:: with SMTP id u22mr9281667pga.407.1607119143128;
        Fri, 04 Dec 2020 13:59:03 -0800 (PST)
Received: from localhost.localdomain ([49.207.200.112])
        by smtp.gmail.com with ESMTPSA id s17sm5016246pge.37.2020.12.04.13.58.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Dec 2020 13:59:02 -0800 (PST)
From:   Anant Thazhemadam <anant.thazhemadam@gmail.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+49d4cab497c2142ee170@syzkaller.appspotmail.com
Subject: [PATCH] net: wireless: validate key indexes for cfg80211_registered_device
Date:   Sat,  5 Dec 2020 03:28:25 +0530
Message-Id: <20201204215825.129879-1-anant.thazhemadam@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot discovered a bug in which an OOB access was being made because
an unsuitable key_idx value was wrongly considered to be acceptable
while deleting a key in nl80211_del_key().

Since we don't know the cipher at the time of deletion, if
cfg80211_validate_key_settings() were to be called directly in
nl80211_del_key(), even valid keys would be wrongly determined invalid,
and deletion wouldn't occur correctly.
For this reason, a new function - cfg80211_valid_key_idx(), has been
created, to determine if the key_idx value provided is valid or not.
cfg80211_valid_key_idx() is directly called in 2 places -
nl80211_del_key(), and cfg80211_validate_key_settings().

Reported-by: syzbot+49d4cab497c2142ee170@syzkaller.appspotmail.com
Tested-by: syzbot+49d4cab497c2142ee170@syzkaller.appspotmail.com
Suggested-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
---
For the bug that was getting triggered, pairwise was true, and 
the NL80211_EXT_FEATURE_BEACON_PROTECTION feature was set too.
The control logic for cfg80211_validate_key_settings() has been
designed keeping this also in mind.

 net/wireless/core.h    |  2 ++
 net/wireless/nl80211.c |  7 ++++---
 net/wireless/util.c    | 27 ++++++++++++++++++++-------
 3 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/net/wireless/core.h b/net/wireless/core.h
index e3e9686859d4..7df91f940212 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -433,6 +433,8 @@ void cfg80211_sme_abandon_assoc(struct wireless_dev *wdev);
 
 /* internal helpers */
 bool cfg80211_supported_cipher_suite(struct wiphy *wiphy, u32 cipher);
+bool cfg80211_valid_key_idx(struct cfg80211_registered_device *rdev,
+			    int key_idx, bool pairwise);
 int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
 				   struct key_params *params, int key_idx,
 				   bool pairwise, const u8 *mac_addr);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a77174b99b07..db36158911ae 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4260,9 +4260,6 @@ static int nl80211_del_key(struct sk_buff *skb, struct genl_info *info)
 	if (err)
 		return err;
 
-	if (key.idx < 0)
-		return -EINVAL;
-
 	if (info->attrs[NL80211_ATTR_MAC])
 		mac_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
 
@@ -4278,6 +4275,10 @@ static int nl80211_del_key(struct sk_buff *skb, struct genl_info *info)
 	    key.type != NL80211_KEYTYPE_GROUP)
 		return -EINVAL;
 
+	if (!cfg80211_valid_key_idx(rdev, key.idx,
+				    key.type == NL80211_KEYTYPE_PAIRWISE))
+		return -EINVAL;
+
 	if (!rdev->ops->del_key)
 		return -EOPNOTSUPP;
 
diff --git a/net/wireless/util.c b/net/wireless/util.c
index f01746894a4e..07b17feb9b1e 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -272,18 +272,31 @@ bool cfg80211_supported_cipher_suite(struct wiphy *wiphy, u32 cipher)
 	return false;
 }
 
-int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
-				   struct key_params *params, int key_idx,
-				   bool pairwise, const u8 *mac_addr)
+bool cfg80211_valid_key_idx(struct cfg80211_registered_device *rdev,
+			    int key_idx, bool pairwise)
 {
 	int max_key_idx = 5;
 
-	if (wiphy_ext_feature_isset(&rdev->wiphy,
-				    NL80211_EXT_FEATURE_BEACON_PROTECTION) ||
-	    wiphy_ext_feature_isset(&rdev->wiphy,
-				    NL80211_EXT_FEATURE_BEACON_PROTECTION_CLIENT))
+	if (pairwise)
+		max_key_idx = 3;
+
+	else if (wiphy_ext_feature_isset(&rdev->wiphy,
+					 NL80211_EXT_FEATURE_BEACON_PROTECTION) ||
+		 wiphy_ext_feature_isset(&rdev->wiphy,
+					 NL80211_EXT_FEATURE_BEACON_PROTECTION_CLIENT))
 		max_key_idx = 7;
+
 	if (key_idx < 0 || key_idx > max_key_idx)
+		return false;
+
+	return true;
+}
+
+int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
+				   struct key_params *params, int key_idx,
+				   bool pairwise, const u8 *mac_addr)
+{
+	if (!cfg80211_valid_key_idx(rdev, key_idx, pairwise))
 		return -EINVAL;
 
 	if (!pairwise && mac_addr && !(rdev->wiphy.flags & WIPHY_FLAG_IBSS_RSN))
-- 
2.25.1

