Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54C891DE03E
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 08:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728373AbgEVG4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 02:56:16 -0400
Received: from mga14.intel.com ([192.55.52.115]:18659 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728036AbgEVG4M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 02:56:12 -0400
IronPort-SDR: 9WkXUHwKuMRGrin+4g1uCgxTLmEYcDSK787sM9zdSe/a9Y5babomJsNzzwVIZEhh0VZYKMxs2P
 ERWaPy3EgiLw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 23:56:09 -0700
IronPort-SDR: x8sk8qYB61sBuuB2JijHbyxYAMi6AE4cYpg1HLGOBrknm1CD86O4i0k20yDs+x3sv272rOG8KS
 hjfl77IW4/og==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,420,1583222400"; 
   d="scan'208";a="290017748"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 21 May 2020 23:56:09 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 05/17] ice: Fix check for contiguous TCs
Date:   Thu, 21 May 2020 23:55:55 -0700
Message-Id: <20200522065607.1680050-6-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200522065607.1680050-1-jeffrey.t.kirsher@intel.com>
References: <20200522065607.1680050-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

The current implementation for contiguous TC check
is assuming that the UPs will be mapped to TCs in
a linear progressing fashion.  This is obviously
not always true.

Change the check to allow for various UP2TC mapping
configurations.

Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index 448b7d2fb808..3c7f604c0c49 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -584,16 +584,21 @@ static int ice_dcb_sw_dflt_cfg(struct ice_pf *pf, bool ets_willing, bool locked)
  */
 static bool ice_dcb_tc_contig(u8 *prio_table)
 {
-	u8 max_tc = 0;
+	bool found_empty = false;
+	u8 used_tc = 0;
 	int i;
 
-	for (i = 0; i < CEE_DCBX_MAX_PRIO; i++) {
-		u8 cur_tc = prio_table[i];
+	/* Create a bitmap of used TCs */
+	for (i = 0; i < CEE_DCBX_MAX_PRIO; i++)
+		used_tc |= BIT(prio_table[i]);
 
-		if (cur_tc > max_tc)
-			return false;
-		else if (cur_tc == max_tc)
-			max_tc++;
+	for (i = 0; i < CEE_DCBX_MAX_PRIO; i++) {
+		if (used_tc & BIT(i)) {
+			if (found_empty)
+				return false;
+		} else {
+			found_empty = true;
+		}
 	}
 
 	return true;
-- 
2.26.2

