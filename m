Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53CA2474C4A
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 20:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232246AbhLNTvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 14:51:19 -0500
Received: from mga01.intel.com ([192.55.52.88]:56344 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231777AbhLNTvS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 14:51:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639511478; x=1671047478;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hPq5ji1vGIg+i4/EyY6IK4oBva4vgMRdiePpwogFND4=;
  b=PaI2sCNQY6d/hjmjr3Ex1dy/TNzzBTxLR1YjzdXalQGv5Wh99Hyyckvq
   2EeYazA1HpiUlsM+95muK6UaiSwBsQv8ub+s/AnQRU1jOWnaIgesnwdwf
   /U55LOnmLR58Bz2fkTJ587ttQRE42MEdLJM+oFB7rIANaNuH3ChRcFZK+
   lnwIAfUh0sMLRYEohF6rhd/JzNpxTp6AtCB3jpGq/aFlremjdoAZ8aIOi
   Wsj/LBnjgUbu1Gaum2bKK845EPXDyE6DNC71SA+B8bmqbdbMJOSWb2cgg
   r66gf3hPIYtjvdj3yTScM53/wbdRMGN/cBQtUgfFzCxSgzTDVPsEwTKNW
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10197"; a="263216672"
X-IronPort-AV: E=Sophos;i="5.88,205,1635231600"; 
   d="scan'208";a="263216672"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2021 11:51:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,205,1635231600"; 
   d="scan'208";a="753098710"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 14 Dec 2021 11:51:18 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Karol Kolacinski <karol.kolacinski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        richardcochran@gmail.com, Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net 1/2] ice: Use div64_u64 instead of div_u64 in adjfine
Date:   Tue, 14 Dec 2021 11:50:19 -0800
Message-Id: <20211214195020.1928635-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211214195020.1928635-1-anthony.l.nguyen@intel.com>
References: <20211214195020.1928635-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karol Kolacinski <karol.kolacinski@intel.com>

Change the division in ice_ptp_adjfine from div_u64 to div64_u64.
div_u64 is used when the divisor is 32 bit but in this case incval is
64 bit and it caused incorrect calculations and incval adjustments.

Fixes: 06c16d89d2cb ("ice: register 1588 PTP clock device object for E810 devices")
Signed-off-by: Karol Kolacinski <karol.kolacinski@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index bf7247c6f58e..ad7cabe7932f 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -705,7 +705,7 @@ static int ice_ptp_adjfine(struct ptp_clock_info *info, long scaled_ppm)
 		scaled_ppm = -scaled_ppm;
 	}
 
-	while ((u64)scaled_ppm > div_u64(U64_MAX, incval)) {
+	while ((u64)scaled_ppm > div64_u64(U64_MAX, incval)) {
 		/* handle overflow by scaling down the scaled_ppm and
 		 * the divisor, losing some precision
 		 */
-- 
2.31.1

