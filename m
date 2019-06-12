Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3A1D42905
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 16:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439766AbfFLO1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 10:27:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:47238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439757AbfFLO1a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 10:27:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9E102082C;
        Wed, 12 Jun 2019 14:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560349650;
        bh=+CG/em/WzEi+E/T+JrEm9KL+zZHCOsy1eQ83aVjigNI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OCSkQxqk8ps2zA10tVJqsyAYcXM7OwnwOSNqzElNma7SJabToksdhqfVtuf4DT2Mg
         0+yLGDX2CEjTa8WAx5KRErU+ZuxKhvbIbZfXVdVvGohuEjXgDIAQ2h3eBw1i6fX7+4
         Q4UBwZ93Jpsj470Y8fosSgpRUYUPczvk4pBAb1Bs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Johannes Berg <johannes.berg@intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 5/5] mac80211: remove unused and unneeded remove_sta_debugfs callback
Date:   Wed, 12 Jun 2019 16:26:58 +0200
Message-Id: <20190612142658.12792-5-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190612142658.12792-1-gregkh@linuxfoundation.org>
References: <20190612142658.12792-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The remove_sta_debugfs callback in struct rate_control_ops is no longer
used by any driver, as there is no need for it (the debugfs directory is
already removed recursivly by the mac80211 core.)  Because no one needs
it, just remove it to keep anyone else from accidentally using it in the
future.

Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/mac80211.h  | 1 -
 net/mac80211/rate.h     | 9 ---------
 net/mac80211/sta_info.c | 1 -
 3 files changed, 11 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 72080d9d617e..f42c61422fdf 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -5939,7 +5939,6 @@ struct rate_control_ops {
 
 	void (*add_sta_debugfs)(void *priv, void *priv_sta,
 				struct dentry *dir);
-	void (*remove_sta_debugfs)(void *priv, void *priv_sta);
 
 	u32 (*get_expected_throughput)(void *priv_sta);
 };
diff --git a/net/mac80211/rate.h b/net/mac80211/rate.h
index d59198191a79..a94ce3804962 100644
--- a/net/mac80211/rate.h
+++ b/net/mac80211/rate.h
@@ -63,15 +63,6 @@ static inline void rate_control_add_sta_debugfs(struct sta_info *sta)
 #endif
 }
 
-static inline void rate_control_remove_sta_debugfs(struct sta_info *sta)
-{
-#ifdef CONFIG_MAC80211_DEBUGFS
-	struct rate_control_ref *ref = sta->rate_ctrl;
-	if (ref && ref->ops->remove_sta_debugfs)
-		ref->ops->remove_sta_debugfs(ref->priv, sta->rate_ctrl_priv);
-#endif
-}
-
 void ieee80211_check_rate_mask(struct ieee80211_sub_if_data *sdata);
 
 /* Get a reference to the rate control algorithm. If `name' is NULL, get the
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index a4932ee3595c..d2933b9f8197 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1027,7 +1027,6 @@ static void __sta_info_destroy_part2(struct sta_info *sta)
 	cfg80211_del_sta_sinfo(sdata->dev, sta->sta.addr, sinfo, GFP_KERNEL);
 	kfree(sinfo);
 
-	rate_control_remove_sta_debugfs(sta);
 	ieee80211_sta_debugfs_remove(sta);
 
 	cleanup_single_sta(sta);
-- 
2.22.0

