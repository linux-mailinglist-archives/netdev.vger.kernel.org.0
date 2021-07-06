Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8F233BCDE3
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233193AbhGFLXz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:23:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:56688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232853AbhGFLVv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:21:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2659C61CDF;
        Tue,  6 Jul 2021 11:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570269;
        bh=eGCsxFpG369ra2/yp5FBcSX3MxKYhKaMSefN2aQyDZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LhB5E9RTSLQofNUxO4kKtdvmkHYR85AuE4GynmnDfi54DVweg1tyMGBRmT07/o+x+
         e0xhQXPISPnN3twyeWntsIjlRFbHbSSRtvYNyh5nLxUaqgtbJ5+Rg9+uoCo7g9r38S
         4nVdASDdDF7x7HspFYCDf+X7nWiZF+4JWx7t5tOwUQRnZ8Np1NBiU5Gg6Rw+Qpb//r
         FBRIjNRq/wtGy2k5FOY3sw7w+rPTVSysOa80PXojApNSqf8Ok0fpnMYlEx+ocBiX4T
         KW+TVMzsAz4NNrB3OzKfmwB/pAkSj6MVNyB/ZmEgSrR97xuhyMgHNaeBjY5rHf8+5F
         aclpQ8lA4Pt7Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 164/189] mac80211: Properly WARN on HW scan before restart
Date:   Tue,  6 Jul 2021 07:13:44 -0400
Message-Id: <20210706111409.2058071-164-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit 45daaa1318410794de956fb8e9d06aed2dbb23d0 ]

The following race was possible:

1. The device driver requests HW restart.
2. A scan is requested from user space and is propagated
   to the driver. During this flow HW_SCANNING flag is set.
3. The thread that handles the HW restart is scheduled,
   and before starting the actual reconfiguration it
   checks that HW_SCANNING is not set. The flow does so
   without acquiring any lock, and thus the WARN fires.

Fix this by checking that HW_SCANNING is on only after RTNL is
acquired, i.e., user space scan request handling is no longer
in transit.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210618133832.8238ab3e19ab.I2693c581c70251472b4f9089e37e06fb2c18268f@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/main.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index f33a3acd7f96..2481bfdfafd0 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -257,14 +257,13 @@ static void ieee80211_restart_work(struct work_struct *work)
 	/* wait for scan work complete */
 	flush_workqueue(local->workqueue);
 	flush_work(&local->sched_scan_stopped_work);
+	flush_work(&local->radar_detected_work);
+
+	rtnl_lock();
 
 	WARN(test_bit(SCAN_HW_SCANNING, &local->scanning),
 	     "%s called with hardware scan in progress\n", __func__);
 
-	flush_work(&local->radar_detected_work);
-	/* we might do interface manipulations, so need both */
-	rtnl_lock();
-	wiphy_lock(local->hw.wiphy);
 	list_for_each_entry(sdata, &local->interfaces, list) {
 		/*
 		 * XXX: there may be more work for other vif types and even
-- 
2.30.2

