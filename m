Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE45A6B806A
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 19:26:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbjCMS0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 14:26:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230522AbjCMSZZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 14:25:25 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F8FF7F010
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 11:25:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678731921; x=1710267921;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Syd8dii4kKHR8DXSVgmZNN9/jeELvWOYwHToADnn3m8=;
  b=IXHN8ngvW7N88zdiNRcqAUc/uqPc1dKA87hG1wmN6lAUONNgT1EmGkmF
   4hOl+1l8ENbu37lmt9tlX2cMY1U5DV/AJD0RLKDPpqYGuCR5cStAb7KCc
   PpdsCcjn+EHVOWGJ0JHZ4vizKRrxHxcEQ/3QV5GGL9j4DEcGNoO2X83QU
   XlnFvMsTo7XGe4AF9LEbMSQoLnsqMSa6fvy3QAp4X0lgyXFl11qylY8GU
   jN8T0MCWxZrk7F6UIAN1Zki5Zx+HgQWGfrBlJlMk/zFhBmNfjnUBPLblf
   SYz6eV6yJ2vrlluW45ujg80SImoe8jMtMh34IViocJTHJgi10YPA6JS2P
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="338772378"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="338772378"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 11:23:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="767809068"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="767809068"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Mar 2023 11:23:02 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        anthony.l.nguyen@intel.com,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Marek Szlosek <marek.szlosek@intel.com>
Subject: [PATCH net-next 07/14] ice: initialize mailbox snapshot earlier in PF init
Date:   Mon, 13 Mar 2023 11:21:16 -0700
Message-Id: <20230313182123.483057-8-anthony.l.nguyen@intel.com>
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

Now that we no longer depend on the number of VFs being allocated, we can
move the ice_mbx_init_snapshot function earlier. This will be required by
Scalable IOV as we will not be calling ice_sriov_configure for Scalable
VFs.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Marek Szlosek <marek.szlosek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c   | 1 +
 drivers/net/ethernet/intel/ice/ice_sriov.c  | 2 --
 drivers/net/ethernet/intel/ice/ice_vf_mbx.h | 4 ++++
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 567694bf098b..615a731d7afe 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3891,6 +3891,7 @@ static int ice_init_pf(struct ice_pf *pf)
 
 	mutex_init(&pf->vfs.table_lock);
 	hash_init(pf->vfs.table);
+	ice_mbx_init_snapshot(&pf->hw);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index 6152c90d7286..79159cbb66ec 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -1023,8 +1023,6 @@ int ice_sriov_configure(struct pci_dev *pdev, int num_vfs)
 		return -EBUSY;
 	}
 
-	ice_mbx_init_snapshot(&pf->hw);
-
 	err = ice_pci_sriov_ena(pf, num_vfs);
 	if (err)
 		return err;
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_mbx.h b/drivers/net/ethernet/intel/ice/ice_vf_mbx.h
index 41250519bc56..44bc030d17e0 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_mbx.h
+++ b/drivers/net/ethernet/intel/ice/ice_vf_mbx.h
@@ -43,5 +43,9 @@ ice_conv_link_speed_to_virtchnl(bool __always_unused adv_link_support,
 	return 0;
 }
 
+static inline void ice_mbx_init_snapshot(struct ice_hw *hw)
+{
+}
+
 #endif /* CONFIG_PCI_IOV */
 #endif /* _ICE_VF_MBX_H_ */
-- 
2.38.1

