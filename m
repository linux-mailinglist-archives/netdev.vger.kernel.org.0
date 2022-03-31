Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A52E4EDE99
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 18:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239802AbiCaQVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 12:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239810AbiCaQVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 12:21:32 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 375DF1F124B
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 09:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648743585; x=1680279585;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VETUEL0gX3kmVN0c5bd2ZxTxB5uxWjhvLZWFrVeQtvY=;
  b=ObXxQcdV1t2yBAEMmxvy3xlayjvoDGTuZCLWV/4m5Du2ByqPF2ldUvvf
   wWc1Rn0LNt6e99ajOFqbd5gGtH7m9KMr/KsVxrMYkeYRGP5+fuXASiMi1
   ExaczZNMEoNHc3/QeFLLGF9rfTpNtAyZ607QCAVAI634DkNE8aN+nTyRb
   //JpKovDZTm9CPFNRF1+sJTMGnuTSv5JC34Du/3CBxaZOE1OjG3huHd0q
   dMAujwpZh1bc2JKo2GGydnGv5jQ6gQoVh76oB7x6nkQIdwoR7cz68u4AM
   SIN+v7+liXbqfv8IRJdoWKRck6+UTH3Hk+0mp16JuG/jHzCvlFrN6Cib5
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10302"; a="260067488"
X-IronPort-AV: E=Sophos;i="5.90,225,1643702400"; 
   d="scan'208";a="260067488"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 09:19:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,225,1643702400"; 
   d="scan'208";a="522407016"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 31 Mar 2022 09:19:39 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     alice.michael@intel.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
Cc:     Ivan Vecera <ivecera@redhat.com>, netdev@vger.kernel.org,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH net 1/3] ice: Clear default forwarding VSI during VSI release
Date:   Thu, 31 Mar 2022 09:20:06 -0700
Message-Id: <20220331162008.1891935-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220331162008.1891935-1-anthony.l.nguyen@intel.com>
References: <20220331162008.1891935-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ivan Vecera <ivecera@redhat.com>

VSI is set as default forwarding one when promisc mode is set for
PF interface, when PF is switched to switchdev mode or when VF
driver asks to enable allmulticast or promisc mode for the VF
interface (when vf-true-promisc-support priv flag is off).
The third case is buggy because in that case VSI associated with
VF remains as default one after VF removal.

Reproducer:
1. Create VF
   echo 1 > sys/class/net/ens7f0/device/sriov_numvfs
2. Enable allmulticast or promisc mode on VF
   ip link set ens7f0v0 allmulticast on
   ip link set ens7f0v0 promisc on
3. Delete VF
   echo 0 > sys/class/net/ens7f0/device/sriov_numvfs
4. Try to enable promisc mode on PF
   ip link set ens7f0 promisc on

Although it looks that promisc mode on PF is enabled the opposite
is true because ice_vsi_sync_fltr() responsible for IFF_PROMISC
handling first checks if any other VSI is set as default forwarding
one and if so the function does not do anything. At this point
it is not possible to enable promisc mode on PF without re-probe
device.

To resolve the issue this patch clear default forwarding VSI
during ice_vsi_release() when the VSI to be released is the default
one.

Fixes: 01b5e89aab49 ("ice: Add VF promiscuous support")
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Alice Michael <alice.michael@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index b897926f817d..6d6233204388 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2983,6 +2983,8 @@ int ice_vsi_release(struct ice_vsi *vsi)
 		}
 	}
 
+	if (ice_is_vsi_dflt_vsi(pf->first_sw, vsi))
+		ice_clear_dflt_vsi(pf->first_sw);
 	ice_fltr_remove_all(vsi);
 	ice_rm_vsi_lan_cfg(vsi->port_info, vsi->idx);
 	err = ice_rm_vsi_rdma_cfg(vsi->port_info, vsi->idx);
-- 
2.31.1

