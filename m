Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6415974E0
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 19:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241109AbiHQRNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 13:13:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241004AbiHQRNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 13:13:43 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B350357FF
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 10:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660756417; x=1692292417;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9V8Vd9i8gSodBx+LAcIS8Epwu01Q2jizVVikg1WQ74U=;
  b=jhtQXORKl0uHPTIa5GLBQd6pHYieYIBH5oHOpWxDSggsyYz63uqgKtSY
   vTW0aTR7AYR/6OP3TRqdePYeM5gGveOizt5mTzY9CC30PcQ9ByKK/y+p2
   TPIGRV6qk2LDvcmFCx65q79xahHCViSzNLtYh+tZOhoo1zG1g6aUvXv/l
   cNsMBrPYcfyaJ8wpzesDBGLAD76A911inZxowqJJoKYp8bmTuABbZm7GS
   ICvwlWNK5LJogcPsa7AWT7prJCDd8nm5rq/hZOG6yw6TxIQHRGE3sK4kd
   yh+I3wkzT67+T2eTNlq9RiOs6tTs6yFOFsYVSRkAoEWx+7fAfAadOKo/R
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10442"; a="291307363"
X-IronPort-AV: E=Sophos;i="5.93,243,1654585200"; 
   d="scan'208";a="291307363"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2022 10:13:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,243,1654585200"; 
   d="scan'208";a="558204979"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 17 Aug 2022 10:13:35 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Grzegorz Siwik <grzegorz.siwik@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>,
        Igor Raits <igor@gooddata.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net 1/5] ice: Fix double VLAN error when entering promisc mode
Date:   Wed, 17 Aug 2022 10:13:25 -0700
Message-Id: <20220817171329.65285-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220817171329.65285-1-anthony.l.nguyen@intel.com>
References: <20220817171329.65285-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grzegorz Siwik <grzegorz.siwik@intel.com>

Avoid enabling or disabling VLAN 0 when trying to set promiscuous
VLAN mode if double VLAN mode is enabled. This fix is needed
because the driver tries to add the VLAN 0 filter twice (once for
inner and once for outer) when double VLAN mode is enabled. The
filter program is rejected by the firmware when double VLAN is
enabled, because the promiscuous filter only needs to be set once.

This issue was missed in the initial implementation of double VLAN
mode.

Fixes: 5eda8afd6bcc ("ice: Add support for PF/VF promiscuous mode")
Signed-off-by: Grzegorz Siwik <grzegorz.siwik@intel.com>
Link: https://lore.kernel.org/all/CAK8fFZ7m-KR57M_rYX6xZN39K89O=LGooYkKsu6HKt0Bs+x6xQ@mail.gmail.com/
Tested-by: Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>
Tested-by: Igor Raits <igor@gooddata.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_switch.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 262e553e3b58..0c265739cce2 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -4445,6 +4445,13 @@ ice_set_vlan_vsi_promisc(struct ice_hw *hw, u16 vsi_handle, u8 promisc_mask,
 		goto free_fltr_list;
 
 	list_for_each_entry(list_itr, &vsi_list_head, list_entry) {
+		/* Avoid enabling or disabling VLAN zero twice when in double
+		 * VLAN mode
+		 */
+		if (ice_is_dvm_ena(hw) &&
+		    list_itr->fltr_info.l_data.vlan.tpid == 0)
+			continue;
+
 		vlan_id = list_itr->fltr_info.l_data.vlan.vlan_id;
 		if (rm_vlan_promisc)
 			status = ice_clear_vsi_promisc(hw, vsi_handle,
-- 
2.35.1

