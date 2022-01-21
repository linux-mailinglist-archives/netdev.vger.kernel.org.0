Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2330E495729
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 01:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378310AbiAUADc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 19:03:32 -0500
Received: from mga02.intel.com ([134.134.136.20]:55926 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378241AbiAUADc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jan 2022 19:03:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642723412; x=1674259412;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SPSwnxlXIZynzmRcTdqPk8C7EgZmpGPPW4I0NX5ruQE=;
  b=ehMh07PZPwMZ1Mvwiij29UFCzQfpi88VdTsArGD78I89c9skHliL5YTz
   9szfvK4RsEemVM0S3ciNm9na8+DgiFydwWxnVs29PA0tKf1ja4bv+/qW2
   LBnXdalE5OOFd12eQehNG/CbjtvjkUBj51TSM/xl9Pu4Nx/OF88U5FB1g
   DWZo5KFf+tCUShjVe9HDtot/EXSN+6D+hp17GaY1Vp6gj6EnNwBfhnHjw
   fYzMl/Jf8y84fZxbutEOBYMKx9Qe/4w1RvGWMDnGWhad8K3VtjejLx4xa
   DvP7mbbXPUeON/QyRs/0VyVuVzE8L2luQagnzH/P0WahycKcceIW2/00c
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10233"; a="232879175"
X-IronPort-AV: E=Sophos;i="5.88,303,1635231600"; 
   d="scan'208";a="232879175"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2022 16:03:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,303,1635231600"; 
   d="scan'208";a="478015663"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 20 Jan 2022 16:03:30 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net 1/5] i40e: Increase delay to 1 s after global EMP reset
Date:   Thu, 20 Jan 2022 16:03:01 -0800
Message-Id: <20220121000305.1423587-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220121000305.1423587-1-anthony.l.nguyen@intel.com>
References: <20220121000305.1423587-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jedrzej Jagielski <jedrzej.jagielski@intel.com>

Recently simplified i40e_rebuild causes that FW sometimes
is not ready after NVM update, the ping does not return.

Increase the delay in case of EMP reset.
Old delay of 300 ms was introduced for specific cards for 710 series.
Now it works for all the cards and delay was increased.

Fixes: 1fa51a650e1d ("i40e: Add delay after EMP reset for firmware to recover")
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 2a3d8aef7f4e..1b0fd3eacd64 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -10574,15 +10574,9 @@ static void i40e_rebuild(struct i40e_pf *pf, bool reinit, bool lock_acquired)
 	}
 	i40e_get_oem_version(&pf->hw);
 
-	if (test_bit(__I40E_EMP_RESET_INTR_RECEIVED, pf->state) &&
-	    ((hw->aq.fw_maj_ver == 4 && hw->aq.fw_min_ver <= 33) ||
-	     hw->aq.fw_maj_ver < 4) && hw->mac.type == I40E_MAC_XL710) {
-		/* The following delay is necessary for 4.33 firmware and older
-		 * to recover after EMP reset. 200 ms should suffice but we
-		 * put here 300 ms to be sure that FW is ready to operate
-		 * after reset.
-		 */
-		mdelay(300);
+	if (test_and_clear_bit(__I40E_EMP_RESET_INTR_RECEIVED, pf->state)) {
+		/* The following delay is necessary for firmware update. */
+		mdelay(1000);
 	}
 
 	/* re-verify the eeprom if we just had an EMP reset */
-- 
2.31.1

