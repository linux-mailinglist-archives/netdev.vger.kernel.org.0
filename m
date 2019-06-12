Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6BD42901
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 16:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439749AbfFLO12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 10:27:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:47036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439731AbfFLO1W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 10:27:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2BA021734;
        Wed, 12 Jun 2019 14:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560349641;
        bh=/LeuXebJhvtr7J4eo2qjx+kcvUVpgOcHpoUCQd07BCw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YJQvX7lvTfqxZGPf8PjcgShXMSb4ZkU5AFlSEEQxOGIofAI9ZC5J2zhHsiwyOKTl8
         mW9QPhG26e8RHYaIoVbGnSOjK3W8xqDr1pP7s4RkPCao/X1HygVa8XP2PW+jCciTcA
         aNn/KPFsJLDi30LRBz1acGZxmPPk3bzxz5QjUwwE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Johannes Berg <johannes.berg@intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 2/5] iwlegacy: 4965: no need to check return value of debugfs_create functions
Date:   Wed, 12 Jun 2019 16:26:55 +0200
Message-Id: <20190612142658.12792-2-gregkh@linuxfoundation.org>
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

Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlegacy/4965-rs.c | 31 +++++--------------
 drivers/net/wireless/intel/iwlegacy/common.h  |  4 ---
 2 files changed, 8 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/4965-rs.c b/drivers/net/wireless/intel/iwlegacy/4965-rs.c
index 54ff83829afb..f640709d9862 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965-rs.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965-rs.c
@@ -2767,29 +2767,15 @@ static void
 il4965_rs_add_debugfs(void *il, void *il_sta, struct dentry *dir)
 {
 	struct il_lq_sta *lq_sta = il_sta;
-	lq_sta->rs_sta_dbgfs_scale_table_file =
-	    debugfs_create_file("rate_scale_table", 0600, dir,
-				lq_sta, &rs_sta_dbgfs_scale_table_ops);
-	lq_sta->rs_sta_dbgfs_stats_table_file =
-	    debugfs_create_file("rate_stats_table", 0400, dir, lq_sta,
-				&rs_sta_dbgfs_stats_table_ops);
-	lq_sta->rs_sta_dbgfs_rate_scale_data_file =
-	    debugfs_create_file("rate_scale_data", 0400, dir, lq_sta,
-				&rs_sta_dbgfs_rate_scale_data_ops);
-	lq_sta->rs_sta_dbgfs_tx_agg_tid_en_file =
-	    debugfs_create_u8("tx_agg_tid_enable", 0600, dir,
-			      &lq_sta->tx_agg_tid_en);
 
-}
-
-static void
-il4965_rs_remove_debugfs(void *il, void *il_sta)
-{
-	struct il_lq_sta *lq_sta = il_sta;
-	debugfs_remove(lq_sta->rs_sta_dbgfs_scale_table_file);
-	debugfs_remove(lq_sta->rs_sta_dbgfs_stats_table_file);
-	debugfs_remove(lq_sta->rs_sta_dbgfs_rate_scale_data_file);
-	debugfs_remove(lq_sta->rs_sta_dbgfs_tx_agg_tid_en_file);
+	debugfs_create_file("rate_scale_table", 0600, dir, lq_sta,
+			    &rs_sta_dbgfs_scale_table_ops);
+	debugfs_create_file("rate_stats_table", 0400, dir, lq_sta,
+			    &rs_sta_dbgfs_stats_table_ops);
+	debugfs_create_file("rate_scale_data", 0400, dir, lq_sta,
+			    &rs_sta_dbgfs_rate_scale_data_ops);
+	debugfs_create_u8("tx_agg_tid_enable", 0600, dir,
+			  &lq_sta->tx_agg_tid_en);
 }
 #endif
 
@@ -2816,7 +2802,6 @@ static const struct rate_control_ops rs_4965_ops = {
 	.free_sta = il4965_rs_free_sta,
 #ifdef CONFIG_MAC80211_DEBUGFS
 	.add_sta_debugfs = il4965_rs_add_debugfs,
-	.remove_sta_debugfs = il4965_rs_remove_debugfs,
 #endif
 };
 
diff --git a/drivers/net/wireless/intel/iwlegacy/common.h b/drivers/net/wireless/intel/iwlegacy/common.h
index 986646af8dfd..3c6f41763dde 100644
--- a/drivers/net/wireless/intel/iwlegacy/common.h
+++ b/drivers/net/wireless/intel/iwlegacy/common.h
@@ -2822,10 +2822,6 @@ struct il_lq_sta {
 	struct il_traffic_load load[TID_MAX_LOAD_COUNT];
 	u8 tx_agg_tid_en;
 #ifdef CONFIG_MAC80211_DEBUGFS
-	struct dentry *rs_sta_dbgfs_scale_table_file;
-	struct dentry *rs_sta_dbgfs_stats_table_file;
-	struct dentry *rs_sta_dbgfs_rate_scale_data_file;
-	struct dentry *rs_sta_dbgfs_tx_agg_tid_en_file;
 	u32 dbg_fixed_rate;
 #endif
 	struct il_priv *drv;
-- 
2.22.0

