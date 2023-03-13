Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3A686B8071
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 19:26:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbjCMS0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 14:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbjCMSZZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 14:25:25 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D47A77E796
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 11:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678731923; x=1710267923;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ho7zDDouw8mGp0Jp6l+txc/SwCs+3gFzaII8XY+omMQ=;
  b=CbUI7mOmgVN70v9wuEEDMBrCEEP9QHnLEmPmxLEh0yIUCE84e8KXcF8i
   MHG588Wc6MGqoZJuFEIwGI+Me6Vqy0cLtTRdfi8Ii4iGedAoI9ImBrIHN
   41DVe5c04foYSsx7heQFoLDN2WyRspEScMIT2f3A/L6kSXx6HeTkYXycD
   65WVWAfCok9Z9mkmULDTeRR3AnIPOrAvx7Ehb6FRff1whOYAIFGPdKCEC
   e/1bKzwC5EIm6ouZpdczcn7jZfSOp5KUyRX4JoE9BrZqSRFLo7CVhIALh
   oEq+0JEw9HxiFxv2R0BgChTT8DknwNYctBq+iJ1YGnfPxhPMa0eTk9lJo
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="338772417"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="338772417"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 11:23:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="767809124"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="767809124"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Mar 2023 11:23:07 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        anthony.l.nguyen@intel.com,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Marek Szlosek <marek.szlosek@intel.com>
Subject: [PATCH net-next 12/14] ice: print message if ice_mbx_vf_state_handler returns an error
Date:   Mon, 13 Mar 2023 11:21:21 -0700
Message-Id: <20230313182123.483057-13-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230313182123.483057-1-anthony.l.nguyen@intel.com>
References: <20230313182123.483057-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

If ice_mbx_vf_state_handler() returns an error, the ice_is_malicious_vf()
function just exits without printing anything.

Instead, use dev_warn_ratelimited to print a warning that we were unable to
check the status for this VF. The _ratelimited variant is used to avoid
potentially spamming the log if this function is failing consistently for
every single mailbox message.

Also we can drop the "goto" as it simply skips over a report_malvf check.
That variable should always be false if ice_mbx_vf_state_handler returns
non-zero.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Marek Szlosek <marek.szlosek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_sriov.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index 5ae923ea979c..f0daeda236de 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -1805,7 +1805,8 @@ ice_is_malicious_vf(struct ice_pf *pf, struct ice_rq_event_info *event,
 	status = ice_mbx_vf_state_handler(&pf->hw, mbxdata, &vf->mbx_info,
 					  &report_malvf);
 	if (status)
-		goto out_put_vf;
+		dev_warn_ratelimited(dev, "Unable to check status of mailbox overflow for VF %u MAC %pM, status %d\n",
+				     vf->vf_id, vf->dev_lan_addr, status);
 
 	if (report_malvf) {
 		struct ice_vsi *pf_vsi = ice_get_main_vsi(pf);
-- 
2.38.1

