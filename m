Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6FD8251B
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 20:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730386AbfHESzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 14:55:10 -0400
Received: from mga06.intel.com ([134.134.136.31]:43661 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730229AbfHESzF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 14:55:05 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Aug 2019 11:55:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,350,1559545200"; 
   d="scan'208";a="373801249"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga006.fm.intel.com with ESMTP; 05 Aug 2019 11:55:02 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 7/8] i40e: verify string count matches even on early return
Date:   Mon,  5 Aug 2019 11:54:58 -0700
Message-Id: <20190805185459.12846-8-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190805185459.12846-1-jeffrey.t.kirsher@intel.com>
References: <20190805185459.12846-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

Similar to i40e_get_ethtool_stats, add a goto to verify that the data
pointer for the strings lines up with the expected stats count. This
helps ensure that bugs are not introduced when adding stats.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index ceca57a261dc..01e4615b1b4b 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -2342,7 +2342,7 @@ static void i40e_get_stat_strings(struct net_device *netdev, u8 *data)
 	}
 
 	if (vsi != pf->vsi[pf->lan_vsi] || pf->hw.partition_id != 1)
-		return;
+		goto check_data_pointer;
 
 	i40e_add_stat_strings(&data, i40e_gstrings_veb_stats);
 
@@ -2354,6 +2354,7 @@ static void i40e_get_stat_strings(struct net_device *netdev, u8 *data)
 	for (i = 0; i < I40E_MAX_USER_PRIORITY; i++)
 		i40e_add_stat_strings(&data, i40e_gstrings_pfc_stats, i);
 
+check_data_pointer:
 	WARN_ONCE(data - p != i40e_get_stats_count(netdev) * ETH_GSTRING_LEN,
 		  "stat strings count mismatch!");
 }
-- 
2.21.0

