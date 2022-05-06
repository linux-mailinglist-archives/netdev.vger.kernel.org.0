Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8838751DE96
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 20:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388827AbiEFSHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 14:07:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389385AbiEFSHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 14:07:37 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30DC76D3A9
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 11:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651860233; x=1683396233;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TEO8gciBtC2NnQOQ9Ul6+4tJKe7A75ArONBatSJ6e/4=;
  b=KX5LI7pTA/Cqux22hwKvDbBIIqY5Yg0YXSAuXbnllv3Kj5DGnqqeO0I1
   UWSsoDmo18T6AOksnGYvYqfkknj5U3DCzdI7cGYKrWa8grCevPD2U0sx7
   rF5RjmtoRS8adDzrPthe+vpoKh+pNNvL+2il9acGGD114aXu99CBB1bi4
   vYH1dXkIUCa4gkIyIDUxiYkWDVpK6tE9NKjrMCSwLzVAQhfy0kxlhIsvR
   YpTm9GaEIEW5GNxtJcVFwjPjpdUZ4nTWwxQjMOX8VD8ArHktjDWZ85vWq
   2aJaQnaV+hq/wV573cGnK79iTzCfvXK+uLmr13K20Ag4RRSK+N9yjZWdm
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10339"; a="354971161"
X-IronPort-AV: E=Sophos;i="5.91,205,1647327600"; 
   d="scan'208";a="354971161"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 11:03:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,205,1647327600"; 
   d="scan'208";a="600670833"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 06 May 2022 11:03:50 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Marcin Szycik <marcin.szycik@linux.intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Subject: [PATCH net-next 2/2] Revert "ice: Hide bus-info in ethtool for PRs in switchdev mode"
Date:   Fri,  6 May 2022 11:00:52 -0700
Message-Id: <20220506180052.5256-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220506180052.5256-1-anthony.l.nguyen@intel.com>
References: <20220506180052.5256-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marcin Szycik <marcin.szycik@linux.intel.com>

This reverts commit bfaaba99e680bf82bf2cbf69866c3f37434ff766.

Commit bfaaba99e680 ("ice: Hide bus-info in ethtool for PRs in switchdev
mode") was a workaround for lshw tool displaying incorrect
descriptions for port representors and PF in switchdev mode. Now the issue
has been fixed in the lshw tool itself [1].

Removing the workaround can be considered a regression, as the user might
be running older, unpatched lshw version. However, another important change
(ice: link representors to PCI device, which improves port representor
netdev naming with SET_NETDEV_DEV) also causes the same "regression" as
removing the workaround, i.e. unpatched lshw is able to access bus-info
information (this time not via ethtool) and the bug can occur. Therefore,
the workaround no longer prevents the bug and can be removed.

[1] https://ezix.org/src/pkg/lshw/commit/9bf4e4c9c1

Signed-off-by: Marcin Szycik <marcin.szycik@linux.intel.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 24cda7e1f916..476bd1c83c87 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -190,19 +190,17 @@ __ice_get_drvinfo(struct net_device *netdev, struct ethtool_drvinfo *drvinfo,
 	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
 		 "%x.%02x 0x%x %d.%d.%d", nvm->major, nvm->minor,
 		 nvm->eetrack, orom->major, orom->build, orom->patch);
+
+	strscpy(drvinfo->bus_info, pci_name(pf->pdev),
+		sizeof(drvinfo->bus_info));
 }
 
 static void
 ice_get_drvinfo(struct net_device *netdev, struct ethtool_drvinfo *drvinfo)
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
-	struct ice_pf *pf = np->vsi->back;
 
 	__ice_get_drvinfo(netdev, drvinfo, np->vsi);
-
-	strscpy(drvinfo->bus_info, pci_name(pf->pdev),
-		sizeof(drvinfo->bus_info));
-
 	drvinfo->n_priv_flags = ICE_PRIV_FLAG_ARRAY_SIZE;
 }
 
-- 
2.35.1

