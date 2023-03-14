Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E90166B9D4E
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 18:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbjCNRq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 13:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbjCNRqZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 13:46:25 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF5D7AD01D
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 10:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678815976; x=1710351976;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ypcZhK+w4XMjkLLE0oFas/DEQTTHh6MnXuzo3lHU+gI=;
  b=RvLXtCScJR/7k+UPNN/czuIDpqBXpWlzaTToAc53wDErxtSeKFsTSFqt
   Lt8hvwTlJ2F5Q8TDlaCcs6ag7ycK/zh0kMmcbKNdOPKs+oBs9PaifQjuE
   CrbmMS2kNF+QgJIpv8IYhVFz4v1wBydWyNZ12Nv42k9PV4zwtqujIDAqq
   HjORuj+wVgxOyGml3OvQkmPTzZfaU27tFCpKA/hHIY7s++gLwW1aljGGp
   sjnI5y0pXrk8VcSLfK+EOxQccyvWNQyqWHnSZcAlMRDluLuV+OAZdEhcn
   VM8U7oZ2iqiWIPP19j5fDwVdlSiBclHZkwBO3Ud47sBUs38U5aIIIohIS
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="317148716"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="317148716"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 10:46:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="1008516925"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="1008516925"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga005.fm.intel.com with ESMTP; 14 Mar 2023 10:46:06 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Ahmed Zaki <ahmed.zaki@intel.com>, anthony.l.nguyen@intel.com,
        Michal Kubiak <michal.kubiak@intel.com>,
        Rafal Romanowski <rafal.romanowski@intel.com>
Subject: [PATCH net 3/3] iavf: do not track VLAN 0 filters
Date:   Tue, 14 Mar 2023 10:44:23 -0700
Message-Id: <20230314174423.1048526-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230314174423.1048526-1-anthony.l.nguyen@intel.com>
References: <20230314174423.1048526-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ahmed Zaki <ahmed.zaki@intel.com>

When an interface with the maximum number of VLAN filters is brought up,
a spurious error is logged:

    [257.483082] 8021q: adding VLAN 0 to HW filter on device enp0s3
    [257.483094] iavf 0000:00:03.0 enp0s3: Max allowed VLAN filters 8. Remove existing VLANs or disable filtering via Ethtool if supported.

The VF driver complains that it cannot add the VLAN 0 filter.

On the other hand, the PF driver always adds VLAN 0 filter on VF
initialization. The VF does not need to ask the PF for that filter at
all.

Fix the error by not tracking VLAN 0 filters altogether. With that, the
check added by commit 0e710a3ffd0c ("iavf: Fix VF driver counting VLAN 0
filters") in iavf_virtchnl.c is useless and might be confusing if left as
it suggests that we track VLAN 0.

Fixes: 0e710a3ffd0c ("iavf: Fix VF driver counting VLAN 0 filters")
Signed-off-by: Ahmed Zaki <ahmed.zaki@intel.com>
Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c     | 4 ++++
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c | 2 --
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 3273aeb8fa67..eb8f944276ff 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -893,6 +893,10 @@ static int iavf_vlan_rx_add_vid(struct net_device *netdev,
 {
 	struct iavf_adapter *adapter = netdev_priv(netdev);
 
+	/* Do not track VLAN 0 filter, always added by the PF on VF init */
+	if (!vid)
+		return 0;
+
 	if (!VLAN_FILTERING_ALLOWED(adapter))
 		return -EIO;
 
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index 6d23338604bb..4e17d006c52d 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -2446,8 +2446,6 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 		list_for_each_entry(f, &adapter->vlan_filter_list, list) {
 			if (f->is_new_vlan) {
 				f->is_new_vlan = false;
-				if (!f->vlan.vid)
-					continue;
 				if (f->vlan.tpid == ETH_P_8021Q)
 					set_bit(f->vlan.vid,
 						adapter->vsi.active_cvlans);
-- 
2.38.1

