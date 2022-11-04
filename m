Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5637961A2BE
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 21:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiKDUyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 16:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiKDUy2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 16:54:28 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79AF1DEE1
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 13:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667595267; x=1699131267;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9LTcJkpSfddEWtFxwfO6SBQ/SxCmK+sEv2j8ozaajuw=;
  b=B6T1oe64BPkSsRlfsy38mpEThPSyUErtLQ/l1kDwHJ7JGZOZF52EpNOa
   KzCXP58y8NannKEfu5irSABQ9m/kxJF1wGoHlTwDZgLi9ZIm6pTE8/+xP
   4C/4ZVGay58eQgUFdrkEuGN8Tg7gpGa2he73hUrLgtmyxT8Zvc/wbpi5e
   888igNYSy8m4x9j9QYGZo9EIM8eeXBP7To1mJPSLv2fN/Bcu7zWs0mszY
   fJhWCLtTziml7+l2VfgBI+tM8seztfNXH7cv0ZSFyUucHdzLvZr3d/8vj
   E4yShjNXt0x6JU7dDhT5salZg5d+u1gwWFhsoLq/AN6lH5DpyE4FjJcKu
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="372177366"
X-IronPort-AV: E=Sophos;i="5.96,138,1665471600"; 
   d="scan'208";a="372177366"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2022 13:54:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="637716214"
X-IronPort-AV: E=Sophos;i="5.96,138,1665471600"; 
   d="scan'208";a="637716214"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga007.fm.intel.com with ESMTP; 04 Nov 2022 13:54:26 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jan Sokolowski <jan.sokolowski@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 4/6] ixgbevf: Add error messages on vlan error
Date:   Fri,  4 Nov 2022 13:54:12 -0700
Message-Id: <20221104205414.2354973-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221104205414.2354973-1-anthony.l.nguyen@intel.com>
References: <20221104205414.2354973-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jan Sokolowski <jan.sokolowski@intel.com>

ixgbevf did not provide an error in dmesg if VLAN addition failed.

Add two descriptive failure messages in the kernel log.

Signed-off-by: Jan Sokolowski <jan.sokolowski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c   | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index be733677bdc8..0aaf70c063da 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -2044,12 +2044,16 @@ static int ixgbevf_vlan_rx_add_vid(struct net_device *netdev,
 
 	spin_unlock_bh(&adapter->mbx_lock);
 
-	/* translate error return types so error makes sense */
-	if (err == IXGBE_ERR_MBX)
-		return -EIO;
+	if (err) {
+		netdev_err(netdev, "VF could not set VLAN %d\n", vid);
+
+		/* translate error return types so error makes sense */
+		if (err == IXGBE_ERR_MBX)
+			return -EIO;
 
-	if (err == IXGBE_ERR_INVALID_ARGUMENT)
-		return -EACCES;
+		if (err == IXGBE_ERR_INVALID_ARGUMENT)
+			return -EACCES;
+	}
 
 	set_bit(vid, adapter->active_vlans);
 
@@ -2070,6 +2074,9 @@ static int ixgbevf_vlan_rx_kill_vid(struct net_device *netdev,
 
 	spin_unlock_bh(&adapter->mbx_lock);
 
+	if (err)
+		netdev_err(netdev, "Could not remove VLAN %d\n", vid);
+
 	clear_bit(vid, adapter->active_vlans);
 
 	return err;
-- 
2.35.1

