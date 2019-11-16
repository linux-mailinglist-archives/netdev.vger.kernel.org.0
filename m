Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80319FF083
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 17:06:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731711AbfKPQGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 11:06:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:59242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730492AbfKPPuv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 10:50:51 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 737AD2182A;
        Sat, 16 Nov 2019 15:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919450;
        bh=oh0ks+X54M4go9LLQLOV8qujEqe3WNtVIJ2zrYgMEqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TlDOMyccMMfzOFDeIHu0jL07O80EUa4AQNf3e+gx0yhRowXFnwzKDX3HUTDASPKn0
         4DTQnXt3bRrtShDf+OrULKro4rOaBtJrw67JMDqsT0l6nPVO/uoqIXO59BwPnhwP04
         RCbmGZOYs2/RX6kli3oLYHhoLwFfvJfMvyYs2Kj0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 150/150] cfg80211: call disconnect_wk when AP stops
Date:   Sat, 16 Nov 2019 10:47:28 -0500
Message-Id: <20191116154729.9573-150-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154729.9573-1-sashal@kernel.org>
References: <20191116154729.9573-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit e005bd7ddea06784c1eb91ac5bb6b171a94f3b05 ]

Since we now prevent regulatory restore during STA disconnect
if concurrent AP interfaces are active, we need to reschedule
this check when the AP state changes. This fixes never doing
a restore when an AP is the last interface to stop. Or to put
it another way: we need to re-check after anything we check
here changes.

Cc: stable@vger.kernel.org
Fixes: 113f3aaa81bd ("cfg80211: Prevent regulatory restore during STA disconnect in concurrent interfaces")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/ap.c   | 2 ++
 net/wireless/core.h | 2 ++
 net/wireless/sme.c  | 2 +-
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/wireless/ap.c b/net/wireless/ap.c
index 63682176c96cb..c4bd3ecef5089 100644
--- a/net/wireless/ap.c
+++ b/net/wireless/ap.c
@@ -40,6 +40,8 @@ int __cfg80211_stop_ap(struct cfg80211_registered_device *rdev,
 		cfg80211_sched_dfs_chan_update(rdev);
 	}
 
+	schedule_work(&cfg80211_disconnect_work);
+
 	return err;
 }
 
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 90f90c7d8bf9b..507ec6446eb67 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -429,6 +429,8 @@ void cfg80211_process_wdev_events(struct wireless_dev *wdev);
 bool cfg80211_does_bw_fit_range(const struct ieee80211_freq_range *freq_range,
 				u32 center_freq_khz, u32 bw_khz);
 
+extern struct work_struct cfg80211_disconnect_work;
+
 /**
  * cfg80211_chandef_dfs_usable - checks if chandef is DFS usable
  * @wiphy: the wiphy to validate against
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 66cccd16c24af..8344153800e27 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -667,7 +667,7 @@ static void disconnect_work(struct work_struct *work)
 	rtnl_unlock();
 }
 
-static DECLARE_WORK(cfg80211_disconnect_work, disconnect_work);
+DECLARE_WORK(cfg80211_disconnect_work, disconnect_work);
 
 
 /*
-- 
2.20.1

