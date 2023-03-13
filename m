Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 948126B8070
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 19:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbjCMS0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 14:26:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbjCMSZZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 14:25:25 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ADB67D55C
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 11:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678731922; x=1710267922;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pQwpW8AM0dzr2j0noCJQysLOWxH83LuHb08i7Pe2KsI=;
  b=B4lH1hUSHpnrn4JwAhTrSDEtlDLClZ5RI9H4lZYMRJKbAAJzU5M9LOQ7
   xO1nq+gEqDOFN3H4dIIOg07GSlFJjaR35lsS0gNBzhRA3KE6Rhv1aROS9
   H/jji4C0MXekz3Q5ipgN34Dl2UxBbumRbiVGuo1Rq9nfjv9YcRoYPS1N+
   4c5G6MWJCEP03xwiEc0oiOfL8c9DQWf/0dTRfo/GSnLTp7DIiW4UzV7wq
   uoq3q96jBIRc001WK1dOpI161dUOsaQZSER+YIfVYf8UA9VhUwhjtdeZN
   k84wvi3GfkYv1Arr3rsSWvaLH2sVwQwo9g7sJeXMbHUfdj0VJ8SPGTudi
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="338772391"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="338772391"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 11:23:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="767809088"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="767809088"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Mar 2023 11:23:04 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        anthony.l.nguyen@intel.com,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Marek Szlosek <marek.szlosek@intel.com>
Subject: [PATCH net-next 09/14] ice: always report VF overflowing mailbox even without PF VSI
Date:   Mon, 13 Mar 2023 11:21:18 -0700
Message-Id: <20230313182123.483057-10-anthony.l.nguyen@intel.com>
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

In ice_is_malicious_vf we report a message warning the system administrator
when a VF is potentially spamming the PF with asynchronous messages that
could overflow the PF mailbox.

The specific message was requested by our customer support team to include
the VF and PF MAC address. In some cases we may not be able to locate the
PF VSI to obtain the MAC address for the PF. The current implementation
discards the message entirely in this case. Fix this to instead print a
zero address in that case so that we always print something here. Note that
dev_warn will also include the PCI device information allowing another
mechanism for determining on which PF the potentially malicious VF belongs.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Marek Szlosek <marek.szlosek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_sriov.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index 79159cbb66ec..185673afb781 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -1817,11 +1817,11 @@ ice_is_malicious_vf(struct ice_pf *pf, struct ice_rq_event_info *event,
 
 	if (report_malvf) {
 		struct ice_vsi *pf_vsi = ice_get_main_vsi(pf);
+		u8 zero_addr[ETH_ALEN] = {};
 
-		if (pf_vsi)
-			dev_warn(dev, "VF MAC %pM on PF MAC %pM is generating asynchronous messages and may be overflowing the PF message queue. Please see the Adapter User Guide for more information\n",
-				 &vf->dev_lan_addr[0],
-				 pf_vsi->netdev->dev_addr);
+		dev_warn(dev, "VF MAC %pM on PF MAC %pM is generating asynchronous messages and may be overflowing the PF message queue. Please see the Adapter User Guide for more information\n",
+			 &vf->dev_lan_addr[0],
+			 pf_vsi ? pf_vsi->netdev->dev_addr : zero_addr);
 	}
 
 out_put_vf:
-- 
2.38.1

