Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 475E14F9AAB
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 18:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbiDHQfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 12:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231203AbiDHQfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 12:35:34 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABAC2108186
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 09:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649435610; x=1680971610;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=C5YudwniUk0Ke+D/nOjhjUYoWNOsPnSOtJM/5fW3xVo=;
  b=VlS3wYdRgqD2XWGXaxMselflQ1vIGUHuhUoIR0fxVdICSnoynGBfl3YA
   mRB+uKlxT+FcmhG6a+qyEQ22k9+fSscW6EkyLoQwqLO2hj5liCeDKi6DV
   8/q2bOJ9qQmb+k0lO8BOmh20Eh04l+qAynI3BZbVP7G+NybdAzCxSpevh
   T2oYaxYIxUQamZBRCbGw5D9N7A3jDbKi/7YykhUMsve8uwOLijSaKRLGY
   91BNtv+ud113+zxWmfQux5eIRbvMCl/I2fWifgfDOV15C1tODgJcvMeTI
   g/PJmmdLrDBYHcQZhIzX8yW4gh+VDk9gYJMrtmAn82/wJ40JlUpImzffV
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="261321989"
X-IronPort-AV: E=Sophos;i="5.90,245,1643702400"; 
   d="scan'208";a="261321989"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2022 09:33:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,245,1643702400"; 
   d="scan'208";a="642957828"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 08 Apr 2022 09:33:29 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Mateusz Palczewski <mateusz.palczewski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net 2/2] Revert "iavf: Fix deadlock occurrence during resetting VF interface"
Date:   Fri,  8 Apr 2022 09:34:11 -0700
Message-Id: <20220408163411.2415552-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220408163411.2415552-1-anthony.l.nguyen@intel.com>
References: <20220408163411.2415552-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mateusz Palczewski <mateusz.palczewski@intel.com>

This change caused a regression with resetting while changing network
namespaces. By clearing the IFF_UP flag, the kernel now thinks it has
fully closed the device.

This reverts commit 0cc318d2e8408bc0ffb4662a0c3e5e57005ac6ff.

Fixes: 0cc318d2e840 ("iavf: Fix deadlock occurrence during resetting VF interface")
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 190590d32faf..7dfcf78b57fb 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2871,7 +2871,6 @@ static void iavf_reset_task(struct work_struct *work)
 	running = adapter->state == __IAVF_RUNNING;
 
 	if (running) {
-		netdev->flags &= ~IFF_UP;
 		netif_carrier_off(netdev);
 		netif_tx_stop_all_queues(netdev);
 		adapter->link_up = false;
@@ -2988,7 +2987,7 @@ static void iavf_reset_task(struct work_struct *work)
 		 * to __IAVF_RUNNING
 		 */
 		iavf_up_complete(adapter);
-		netdev->flags |= IFF_UP;
+
 		iavf_irq_enable(adapter, true);
 	} else {
 		iavf_change_state(adapter, __IAVF_DOWN);
@@ -3004,10 +3003,8 @@ static void iavf_reset_task(struct work_struct *work)
 reset_err:
 	mutex_unlock(&adapter->client_lock);
 	mutex_unlock(&adapter->crit_lock);
-	if (running) {
+	if (running)
 		iavf_change_state(adapter, __IAVF_RUNNING);
-		netdev->flags |= IFF_UP;
-	}
 	dev_err(&adapter->pdev->dev, "failed to allocate resources during reinit\n");
 	iavf_close(netdev);
 }
-- 
2.31.1

