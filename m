Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 644AA6EE659
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 19:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234926AbjDYRHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 13:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234921AbjDYRHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 13:07:18 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D2BA1999
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 10:07:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682442435; x=1713978435;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=4cqXsomecpGrmzF40ZjtIzyI9ohVSfi18QYfF77qlD4=;
  b=GWapSjTWMXk2+Y3jHKEZ0bdxQH2tzY5tLoxZYcdQo91/1BVXymTDAGgp
   ytrVPc/hdkBs/Qbyqbj2EEJTh5SivIX8lrPDKuqHghUruPxXj4mzIXcIs
   L8ILVYUOK3zQG+acEnz42Fp/PR/EvsKvqY+Q36/j0ahbGZfp+Jmh+GH4r
   62/HR2Cn/ja8eNpp1GPGSZ2VjyCYy7khAGHENUy0VqyTqjV0Jt7xRDujm
   sNEeMQKawqwzhg+8vjNrMx3E85yDQIERD0aqOnOi3irE67/LrR78MMoj9
   c2zg1yDwAJIoOlg7v6fmadSMdIuY1Az/I4hdyA8PQDlVWov603CDYIhad
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10691"; a="346859155"
X-IronPort-AV: E=Sophos;i="5.99,226,1677571200"; 
   d="scan'208";a="346859155"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2023 10:07:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10691"; a="939836296"
X-IronPort-AV: E=Sophos;i="5.99,226,1677571200"; 
   d="scan'208";a="939836296"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga006.fm.intel.com with ESMTP; 25 Apr 2023 10:07:02 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Andrii Staikov <andrii.staikov@intel.com>,
        anthony.l.nguyen@intel.com, richardcochran@gmail.com,
        Sunitha Mekala <sunithax.d.mekala@intel.com>
Subject: [PATCH net 1/1] i40e: fix PTP pins verification
Date:   Tue, 25 Apr 2023 10:04:06 -0700
Message-Id: <20230425170406.2522523-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrii Staikov <andrii.staikov@intel.com>

Fix PTP pins verification not to contain tainted arguments. As a new PTP
pins configuration is provided by a user, it may contain tainted
arguments that are out of bounds for the list of possible values that can
lead to a potential security threat. Change pin's state name from 'invalid'
to 'empty' for more clarification.

Fixes: 1050713026a0 ("i40e: add support for PTP external synchronization clock")
Signed-off-by: Andrii Staikov <andrii.staikov@intel.com>
Tested-by: Sunitha Mekala <sunithax.d.mekala@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_ptp.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ptp.c b/drivers/net/ethernet/intel/i40e/i40e_ptp.c
index c37abbb3cd06..78e7c705cd89 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ptp.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ptp.c
@@ -49,7 +49,7 @@ static struct ptp_pin_desc sdp_desc[] = {
 
 enum i40e_ptp_gpio_pin_state {
 	end = -2,
-	invalid,
+	empty,
 	off,
 	in_A,
 	in_B,
@@ -1078,11 +1078,19 @@ static int i40e_ptp_set_pins(struct i40e_pf *pf,
 	else if (pin_caps == CAN_DO_PINS)
 		return 0;
 
-	if (pins->sdp3_2 == invalid)
+	if ((pins->sdp3_2 < empty || pins->sdp3_2 > out_B) ||
+	    (pins->sdp3_3 < empty || pins->sdp3_3 > out_B) ||
+	    (pins->gpio_4 < empty || pins->gpio_4 > out_B)) {
+		dev_warn(&pf->pdev->dev,
+			 "The provided PTP configuration set contains meaningless values that may potentially pose a safety threat.\n");
+		return -EPERM;
+	}
+
+	if (pins->sdp3_2 == empty)
 		pins->sdp3_2 = pf->ptp_pins->sdp3_2;
-	if (pins->sdp3_3 == invalid)
+	if (pins->sdp3_3 == empty)
 		pins->sdp3_3 = pf->ptp_pins->sdp3_3;
-	if (pins->gpio_4 == invalid)
+	if (pins->gpio_4 == empty)
 		pins->gpio_4 = pf->ptp_pins->gpio_4;
 	while (i40e_ptp_pin_led_allowed_states[i].sdp3_2 != end) {
 		if (pins->sdp3_2 == i40e_ptp_pin_led_allowed_states[i].sdp3_2 &&
-- 
2.38.1

