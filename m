Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34848E2270
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 20:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389246AbfJWSYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 14:24:39 -0400
Received: from mga03.intel.com ([134.134.136.65]:14899 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389043AbfJWSYb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 14:24:31 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Oct 2019 11:24:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,221,1569308400"; 
   d="scan'208";a="202075940"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga006.jf.intel.com with ESMTP; 23 Oct 2019 11:24:28 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 06/11] i40e: remove the macro with it's argument reuse
Date:   Wed, 23 Oct 2019 11:24:21 -0700
Message-Id: <20191023182426.13233-7-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191023182426.13233-1-jeffrey.t.kirsher@intel.com>
References: <20191023182426.13233-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aleksandr Loktionov <aleksandr.loktionov@intel.com>

Remove macro and call i40e_update_vfid_in_stats() function directly
to avoid checkpatch.pl complains about macro argument reuse and
possible side effects.

Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/i40e/i40e_ethtool.c    | 28 ++++---------------
 1 file changed, 6 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 67a6bd52eb95..883b43ac9816 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -2417,7 +2417,7 @@ static void i40e_get_ethtool_stats(struct net_device *netdev,
 }
 
 /**
- * __i40e_update_vfid_in_stats_strings - print VF num to stats names
+ * i40e_update_vfid_in_stats - print VF num to stats names
  * @stats_extra: array of stats structs with stats name strings
  * @strings_num: number of stats name strings in array above (length)
  * @vf_id: VF number to update stats name strings with
@@ -2425,8 +2425,8 @@ static void i40e_get_ethtool_stats(struct net_device *netdev,
  * Helper function to i40e_get_stat_strings() in case of extra stats.
  **/
 static inline void
-__i40e_update_vfid_in_stats_strings(struct i40e_stats stats_extra[],
-				    int strings_num, int vf_id)
+i40e_update_vfid_in_stats(struct i40e_stats stats_extra[],
+			  int strings_num, int vf_id)
 {
 	int i;
 
@@ -2438,24 +2438,6 @@ __i40e_update_vfid_in_stats_strings(struct i40e_stats stats_extra[],
 	}
 }
 
-/**
- * i40e_update_vfid_in_stats - print VF num to stat names
- * @stats_extra: array of stats structs with stats name strings
- * @vf_id: VF number to update stats name strings with
- *
- * Helper macro to i40e_get_stat_strings() to ease use of
- * __i40e_update_vfid_in_stats_strings() function due to extra stats.
- *
- * Macro to ease the use of __i40e_update_vfid_in_stats_strings by taking
- * a static constant stats array and passing the ARRAY_SIZE(). This avoids typos
- * by ensuring that we pass the size associated with the given stats array.
- *
- * The parameter @stats_extra is evaluated twice, so parameters with side
- * effects should be avoided.
- **/
-#define i40e_update_vfid_in_stats(stats_extra, vf_id) \
-__i40e_update_vfid_in_stats_strings(stats_extra, ARRAY_SIZE(stats_extra), vf_id)
-
 /**
  * i40e_get_stat_strings - copy stat strings into supplied buffer
  * @netdev: the netdev to collect strings for
@@ -2499,7 +2481,9 @@ static void i40e_get_stat_strings(struct net_device *netdev, u8 *data)
 		i40e_add_stat_strings(&data, i40e_gstrings_pfc_stats, i);
 
 	for (i = 0; i < I40E_STATS_EXTRA_COUNT; i++) {
-		i40e_update_vfid_in_stats(i40e_gstrings_eth_stats_extra, i);
+		i40e_update_vfid_in_stats
+			(i40e_gstrings_eth_stats_extra,
+			 ARRAY_SIZE(i40e_gstrings_eth_stats_extra), i);
 		i40e_add_stat_strings(&data, i40e_gstrings_eth_stats_extra);
 	}
 
-- 
2.21.0

