Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 641925AF6AC
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 23:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbiIFVNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 17:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbiIFVNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 17:13:09 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFAB1B81FC
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 14:13:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662498788; x=1694034788;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SzhxcI2MDmlaazjXXEihJzJXdFRPogx800EpXy0Jltc=;
  b=VARCCrVqcyAlzKG2JKMSvM2hV0t+Kfv0RaqUP9jELRb7EPQSdCEodQ6t
   03xLYMBolfsMo5TjbF0JzwJyFtxRr1VHAY4Mj0vCJrVS8Vc36hz7c57ql
   xFWl+veRXsEBFFduOUeYgWVApymLU8TlcKOsXh1HIq14rs1DVTLBf0vW4
   DbYe8yhU0R06Tjcgn4d8GS9WqP3fo6E9zMKMq+jeKtb5bv3T4WRCs098N
   +yc8cwbq7fHfnIOrmCJzOq4ZObRJPpmYy1NIaJ6lIh4Az4+UqT5Lh/LX2
   c4sIufvO5KoaDRrldLNm5qUr3p6iJ86uztfYv1fu9GcFeLGzf3fVTHEqz
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10462"; a="295441851"
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="295441851"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2022 14:13:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="591421368"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 06 Sep 2022 14:13:06 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Subject: [PATCH net-next 4/5] ice: switch: Simplify memory allocation
Date:   Tue,  6 Sep 2022 14:13:01 -0700
Message-Id: <20220906211302.3501186-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220906211302.3501186-1-anthony.l.nguyen@intel.com>
References: <20220906211302.3501186-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

'rbuf' is locale to the ice_get_initial_sw_cfg() function.
There is no point in using devm_kzalloc()/devm_kfree().

use kzalloc()/kfree() instead.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
As a side effect, it also require less memory. devm_kzalloc() has a small
memory overhead, and requesting ICE_SW_CFG_MAX_BUF_LEN (i.e. 2048) bytes,
4096 are really allocated.
---
 drivers/net/ethernet/intel/ice/ice_switch.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 697feb89188c..eb6e19deb70d 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -2274,9 +2274,7 @@ int ice_get_initial_sw_cfg(struct ice_hw *hw)
 	int status;
 	u16 i;
 
-	rbuf = devm_kzalloc(ice_hw_to_dev(hw), ICE_SW_CFG_MAX_BUF_LEN,
-			    GFP_KERNEL);
-
+	rbuf = kzalloc(ICE_SW_CFG_MAX_BUF_LEN, GFP_KERNEL);
 	if (!rbuf)
 		return -ENOMEM;
 
@@ -2324,7 +2322,7 @@ int ice_get_initial_sw_cfg(struct ice_hw *hw)
 		}
 	} while (req_desc && !status);
 
-	devm_kfree(ice_hw_to_dev(hw), rbuf);
+	kfree(rbuf);
 	return status;
 }
 
-- 
2.35.1

