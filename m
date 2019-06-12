Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4E9428E8
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 16:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439713AbfFLO1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 10:27:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:46852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439683AbfFLO1O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 10:27:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 102C421019;
        Wed, 12 Jun 2019 14:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560349633;
        bh=pZawyhYLUwMYJInd74NXKDDc3/rQUOsSbMKQv27pQMg=;
        h=From:To:Cc:Subject:Date:From;
        b=x4d0QBl0Us82jBN7FcH/ZV3GMxb8EY+EEIGCjEtjKlLxpXeu54379RtKTaTcqn4SH
         gKndOb1s3iWl84cxVL140Xz/4sALHEuMAjWNzbb7aV+52MKs8df6bxu7pScim0BLVN
         3zswiQQJL7vLwdpc417m7MIodKeiFvoN8ficnBvk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Johannes Berg <johannes.berg@intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 1/5] iwlegacy: 3945: no need to check return value of debugfs_create functions
Date:   Wed, 12 Jun 2019 16:26:54 +0200
Message-Id: <20190612142658.12792-1-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
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
 drivers/net/wireless/intel/iwlegacy/3945-rs.c | 14 ++------------
 drivers/net/wireless/intel/iwlegacy/3945.h    |  3 ---
 2 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/3945-rs.c b/drivers/net/wireless/intel/iwlegacy/3945-rs.c
index a697edd46e7f..1d810cae6091 100644
--- a/drivers/net/wireless/intel/iwlegacy/3945-rs.c
+++ b/drivers/net/wireless/intel/iwlegacy/3945-rs.c
@@ -861,17 +861,8 @@ il3945_add_debugfs(void *il, void *il_sta, struct dentry *dir)
 {
 	struct il3945_rs_sta *lq_sta = il_sta;
 
-	lq_sta->rs_sta_dbgfs_stats_table_file =
-	    debugfs_create_file("rate_stats_table", 0600, dir, lq_sta,
-				&rs_sta_dbgfs_stats_table_ops);
-
-}
-
-static void
-il3945_remove_debugfs(void *il, void *il_sta)
-{
-	struct il3945_rs_sta *lq_sta = il_sta;
-	debugfs_remove(lq_sta->rs_sta_dbgfs_stats_table_file);
+	debugfs_create_file("rate_stats_table", 0600, dir, lq_sta,
+			    &rs_sta_dbgfs_stats_table_ops);
 }
 #endif
 
@@ -898,7 +889,6 @@ static const struct rate_control_ops rs_ops = {
 	.free_sta = il3945_rs_free_sta,
 #ifdef CONFIG_MAC80211_DEBUGFS
 	.add_sta_debugfs = il3945_add_debugfs,
-	.remove_sta_debugfs = il3945_remove_debugfs,
 #endif
 
 };
diff --git a/drivers/net/wireless/intel/iwlegacy/3945.h b/drivers/net/wireless/intel/iwlegacy/3945.h
index 00030d43a194..1aeb4b238fcf 100644
--- a/drivers/net/wireless/intel/iwlegacy/3945.h
+++ b/drivers/net/wireless/intel/iwlegacy/3945.h
@@ -87,9 +87,6 @@ struct il3945_rs_sta {
 	u8 start_rate;
 	struct timer_list rate_scale_flush;
 	struct il3945_rate_scale_data win[RATE_COUNT_3945];
-#ifdef CONFIG_MAC80211_DEBUGFS
-	struct dentry *rs_sta_dbgfs_stats_table_file;
-#endif
 
 	/* used to be in sta_info */
 	int last_txrate_idx;
-- 
2.22.0

