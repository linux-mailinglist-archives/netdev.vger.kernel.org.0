Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 877BA5B27D1
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 22:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbiIHUhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 16:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiIHUhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 16:37:13 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3478010301E
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 13:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662669432; x=1694205432;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yB1l0q1ByLNfsp/uazLUBNaECPMbAj9RkoK8cnvWrlg=;
  b=jqPsGf3toDEiCn4YYDWIA+J0SEwnCoZOboo1m2mGCdpRESXEVRj/ibsm
   hW0UPXtW08ZPdDEfH/SKgmnLNj8Xf0ta/UT3V/zzTrOCbjx0eK8MjOsgf
   aqKhFK9KQdA3lgoa1uCubufBCX1/vr8gilbLdj1qI3LOzk013pkvB93LG
   yMPa15R7xgmeu+kTL7P0x7rBF6LnnvdxGn3VFsEV3QUPImbJFO/lHbQMh
   lUPwXf0zClKGJHgnjvJ/+Ta6sdfpSze2iTr48VPnfHjehn7hSk2THLyAX
   ahCQd22SAIHxSDZyghmoXTUZQnut9Sjgaiqwrq+M7QEBXRddgCCMYkLzm
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="294900356"
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="294900356"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 13:37:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="943509292"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 08 Sep 2022 13:37:10 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Norbert Zulinski <norbertx.zulinski@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net 3/4] iavf: Fix change VF's mac address
Date:   Thu,  8 Sep 2022 13:37:00 -0700
Message-Id: <20220908203701.2089562-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220908203701.2089562-1-anthony.l.nguyen@intel.com>
References: <20220908203701.2089562-1-anthony.l.nguyen@intel.com>
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

From: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>

Previously changing mac address gives false negative because
ip link set <interface> address <MAC> return with
RTNLINK: Permission denied.
In iavf_set_mac was check if PF handled our mac set request,
even before filter was added to list.
Because this check returns always true and it never waits for
PF's response.

Move iavf_is_mac_handled to wait_event_interruptible_timeout
instead of false. Now it will wait for PF's response and then
check if address was added or rejected.

Fixes: 35a2443d0910 ("iavf: Add waiting for response from PF in set mac")
Signed-off-by: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
Co-developed-by: Norbert Zulinski <norbertx.zulinski@intel.com>
Signed-off-by: Norbert Zulinski <norbertx.zulinski@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 10aa99dfdcdb..0c89f16bf1e2 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1077,7 +1077,6 @@ static int iavf_set_mac(struct net_device *netdev, void *p)
 {
 	struct iavf_adapter *adapter = netdev_priv(netdev);
 	struct sockaddr *addr = p;
-	bool handle_mac = iavf_is_mac_set_handled(netdev, addr->sa_data);
 	int ret;
 
 	if (!is_valid_ether_addr(addr->sa_data))
@@ -1094,10 +1093,9 @@ static int iavf_set_mac(struct net_device *netdev, void *p)
 		return 0;
 	}
 
-	if (handle_mac)
-		goto done;
-
-	ret = wait_event_interruptible_timeout(adapter->vc_waitqueue, false, msecs_to_jiffies(2500));
+	ret = wait_event_interruptible_timeout(adapter->vc_waitqueue,
+					       iavf_is_mac_set_handled(netdev, addr->sa_data),
+					       msecs_to_jiffies(2500));
 
 	/* If ret < 0 then it means wait was interrupted.
 	 * If ret == 0 then it means we got a timeout.
@@ -1111,7 +1109,6 @@ static int iavf_set_mac(struct net_device *netdev, void *p)
 	if (!ret)
 		return -EAGAIN;
 
-done:
 	if (!ether_addr_equal(netdev->dev_addr, addr->sa_data))
 		return -EACCES;
 
-- 
2.35.1

