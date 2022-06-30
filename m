Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69BD05625A0
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 23:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237649AbiF3Vws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 17:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237201AbiF3Vwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 17:52:46 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BBC553EFE
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 14:52:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656625965; x=1688161965;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=t3NDlxkBB3ZE9IRh4NBRTAY7kAzQb1Zad9Cnwck2gBA=;
  b=QfaDzwI/3zCR5rLzwizagrZHffVi7hb11BoE14IB4RcpXGSZD4gAtqdd
   oD3M6DwtDYx2zNZZU+IRP4EAUIi3friYbSUCa4GvfQWIuhcCyOl8NgkTt
   MoS+iLoVGh4rPwWqhIG+RP2q3y2+VKyS+RN000AYvMJKC26WFvbJodUa+
   LDXf4C/MUttLXqRnQM9F5wj/CFmlH4E1NC5spKHb0SInMMLSH5kGDhvaN
   DFNJpq+MOqkd/s7X78gjpKBSSMuxnR2d73YpMKuTK1IZYmry+EArWDUt2
   rZzKUwmJbnP55ZWymXQxVMGXmyYmSWwrEmcFSFi7ThArnf2R4x6hlnhaZ
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10394"; a="262881762"
X-IronPort-AV: E=Sophos;i="5.92,235,1650956400"; 
   d="scan'208";a="262881762"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 14:52:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,235,1650956400"; 
   d="scan'208";a="918221392"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 30 Jun 2022 14:52:44 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Norbert Zulinski <norbertx.zulinski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com, Jan Sokolowski <jan.sokolowski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net 2/2] i40e: Fix VF's MAC Address change on VM
Date:   Thu, 30 Jun 2022 14:49:40 -0700
Message-Id: <20220630214940.3036250-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220630214940.3036250-1-anthony.l.nguyen@intel.com>
References: <20220630214940.3036250-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Norbert Zulinski <norbertx.zulinski@intel.com>

Clear VF MAC from parent PF and remove VF filter from VSI when both
conditions are true:
-VIRTCHNL_VF_OFFLOAD_USO is not used
-VM MAC was not set from PF level

It affects older version of IAVF and it allow them to change MAC
Address on VM, newer IAVF won't change their behaviour.

Previously it wasn't possible to change VF's MAC Address on VM
because there is flag on IAVF driver that won't allow to
change MAC Address if this address is given from PF driver.

Fixes: 155f0ac2c96b ("iavf: allow permanent MAC address to change")
Signed-off-by: Norbert Zulinski <norbertx.zulinski@intel.com>
Signed-off-by: Jan Sokolowski <jan.sokolowski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 033ea71763e3..86b0f21287dc 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -2147,6 +2147,10 @@ static int i40e_vc_get_vf_resources_msg(struct i40e_vf *vf, u8 *msg)
 		/* VFs only use TC 0 */
 		vfres->vsi_res[0].qset_handle
 					  = le16_to_cpu(vsi->info.qs_handle[0]);
+		if (!(vf->driver_caps & VIRTCHNL_VF_OFFLOAD_USO) && !vf->pf_set_mac) {
+			i40e_del_mac_filter(vsi, vf->default_lan_addr.addr);
+			eth_zero_addr(vf->default_lan_addr.addr);
+		}
 		ether_addr_copy(vfres->vsi_res[0].default_mac_addr,
 				vf->default_lan_addr.addr);
 	}
-- 
2.35.1

