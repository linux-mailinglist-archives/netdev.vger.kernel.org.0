Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A359428FF
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 16:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439740AbfFLO11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 10:27:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:47114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439675AbfFLO1Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 10:27:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92F7F2082C;
        Wed, 12 Jun 2019 14:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560349644;
        bh=6rtLmZ/YqQyYFHMy6ghrsSDwEwjy77H/Fnh+Yy9T58g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hMAmvKWRGTcRoCbEpRu7wgvynVapIio1yCjY+fZ4SitSdrWT+RL/AjCV5Yzy5vqCm
         X+9R6l/YTi8RXOMSowOpFRAx1SvvLY9nSXfWaroyGpBWrWxPi9JSZc/goydtA/UJSf
         5tv1Qg5j9AmQhcZ3j/kgqsYvrfT6elJ4UXo8KMXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Johannes Berg <johannes.berg@intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 3/5] iwlwifi: dvm: no need to check return value of debugfs_create functions
Date:   Wed, 12 Jun 2019 16:26:56 +0200
Message-Id: <20190612142658.12792-3-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190612142658.12792-1-gregkh@linuxfoundation.org>
References: <20190612142658.12792-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When calling debugfs functions, there is no need to ever check the
return value.  This driver was saving the debugfs file away to be
removed at a later time.  However, the 80211 core would delete the whole
directory that the debugfs files are created in, after it asks the
driver to do the deletion, so just rely on the 80211 core to do all of
the cleanup for us, making us not need to keep a pointer to the dentries
around at all.

This cleans up the structure of the driver data a bit and makes the code
a tiny bit smaller.

Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Luca Coelho <luciano.coelho@intel.com>
Cc: Intel Linux Wireless <linuxwifi@intel.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c | 29 ++++++---------------
 drivers/net/wireless/intel/iwlwifi/dvm/rs.h |  4 ---
 2 files changed, 8 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/rs.c b/drivers/net/wireless/intel/iwlwifi/dvm/rs.c
index ef4b9de256f7..91e571c99f81 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/rs.c
@@ -3271,28 +3271,16 @@ static void rs_add_debugfs(void *priv, void *priv_sta,
 					struct dentry *dir)
 {
 	struct iwl_lq_sta *lq_sta = priv_sta;
-	lq_sta->rs_sta_dbgfs_scale_table_file =
-		debugfs_create_file("rate_scale_table", 0600, dir,
-				    lq_sta, &rs_sta_dbgfs_scale_table_ops);
-	lq_sta->rs_sta_dbgfs_stats_table_file =
-		debugfs_create_file("rate_stats_table", 0400, dir,
-				    lq_sta, &rs_sta_dbgfs_stats_table_ops);
-	lq_sta->rs_sta_dbgfs_rate_scale_data_file =
-		debugfs_create_file("rate_scale_data", 0400, dir,
-				    lq_sta, &rs_sta_dbgfs_rate_scale_data_ops);
-	lq_sta->rs_sta_dbgfs_tx_agg_tid_en_file =
-		debugfs_create_u8("tx_agg_tid_enable", 0600, dir,
-				  &lq_sta->tx_agg_tid_en);
 
-}
+	debugfs_create_file("rate_scale_table", 0600, dir, lq_sta,
+			    &rs_sta_dbgfs_scale_table_ops);
+	debugfs_create_file("rate_stats_table", 0400, dir, lq_sta,
+			    &rs_sta_dbgfs_stats_table_ops);
+	debugfs_create_file("rate_scale_data", 0400, dir, lq_sta,
+			    &rs_sta_dbgfs_rate_scale_data_ops);
+	debugfs_create_u8("tx_agg_tid_enable", 0600, dir,
+			  &lq_sta->tx_agg_tid_en);
 
-static void rs_remove_debugfs(void *priv, void *priv_sta)
-{
-	struct iwl_lq_sta *lq_sta = priv_sta;
-	debugfs_remove(lq_sta->rs_sta_dbgfs_scale_table_file);
-	debugfs_remove(lq_sta->rs_sta_dbgfs_stats_table_file);
-	debugfs_remove(lq_sta->rs_sta_dbgfs_rate_scale_data_file);
-	debugfs_remove(lq_sta->rs_sta_dbgfs_tx_agg_tid_en_file);
 }
 #endif
 
@@ -3318,7 +3306,6 @@ static const struct rate_control_ops rs_ops = {
 	.free_sta = rs_free_sta,
 #ifdef CONFIG_MAC80211_DEBUGFS
 	.add_sta_debugfs = rs_add_debugfs,
-	.remove_sta_debugfs = rs_remove_debugfs,
 #endif
 };
 
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/rs.h b/drivers/net/wireless/intel/iwlwifi/dvm/rs.h
index b2df3a8cc464..92836a815234 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/rs.h
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/rs.h
@@ -367,10 +367,6 @@ struct iwl_lq_sta {
 	struct iwl_traffic_load load[IWL_MAX_TID_COUNT];
 	u8 tx_agg_tid_en;
 #ifdef CONFIG_MAC80211_DEBUGFS
-	struct dentry *rs_sta_dbgfs_scale_table_file;
-	struct dentry *rs_sta_dbgfs_stats_table_file;
-	struct dentry *rs_sta_dbgfs_rate_scale_data_file;
-	struct dentry *rs_sta_dbgfs_tx_agg_tid_en_file;
 	u32 dbg_fixed_rate;
 #endif
 	struct iwl_priv *drv;
-- 
2.22.0

