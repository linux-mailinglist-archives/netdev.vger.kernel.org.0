Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 033BC41C939
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346048AbhI2QCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:02:45 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:27911 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345518AbhI2P7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:53 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HKLWw46mHzbmvZ;
        Wed, 29 Sep 2021 23:53:48 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:05 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:05 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 069/167] net: mac80211: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:51:56 +0800
Message-ID: <20210929155334.12454-70-shenjian15@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210929155334.12454-1-shenjian15@huawei.com>
References: <20210929155334.12454-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use netdev_feature_xxx helpers to replace the logical operation
for netdev features.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 net/mac80211/iface.c | 10 +++++++---
 net/mac80211/main.c  |  5 ++++-
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 62c95597704b..7e7431144727 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -2034,13 +2034,17 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 	ieee80211_setup_sdata(sdata, type);
 
 	if (ndev) {
+		netdev_features_t tmp;
+
 		ndev->ieee80211_ptr->use_4addr = params->use_4addr;
 		if (type == NL80211_IFTYPE_STATION)
 			sdata->u.mgd.use_4addr = params->use_4addr;
 
-		ndev->features |= local->hw.netdev_features;
-		ndev->hw_features |= ndev->features &
-					MAC80211_SUPPORTED_FEATURES_TX;
+		netdev_feature_or(&ndev->features, ndev->features,
+				  local->hw.netdev_features);
+		netdev_feature_copy(&tmp, ndev->features);
+		netdev_feature_and_bits(MAC80211_SUPPORTED_FEATURES_TX, &tmp);
+		netdev_feature_or(&ndev->hw_features, ndev->hw_features, tmp);
 
 		netdev_set_default_ethtool_ops(ndev, &ieee80211_ethtool_ops);
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 45fb517591ee..06142de8f8db 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -911,6 +911,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	int channels, max_bitrates;
 	bool supp_ht, supp_vht, supp_he;
 	struct cfg80211_chan_def dflt_chandef = {};
+	netdev_features_t tmp;
 
 	if (ieee80211_hw_check(hw, QUEUE_CONTROL) &&
 	    (local->hw.offchannel_tx_hw_queue == IEEE80211_INVAL_HW_QUEUE ||
@@ -960,7 +961,9 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	}
 
 	/* Only HW csum features are currently compatible with mac80211 */
-	if (WARN_ON(hw->netdev_features & ~MAC80211_SUPPORTED_FEATURES))
+	netdev_feature_copy(&tmp, hw->netdev_features);
+	netdev_feature_clear_bits(MAC80211_SUPPORTED_FEATURES, &tmp);
+	if (WARN_ON(!netdev_feature_empty(tmp)))
 		return -EINVAL;
 
 	if (hw->max_report_rates == 0)
-- 
2.33.0

