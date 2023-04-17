Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 301C36E5380
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 22:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbjDQU7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 16:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231398AbjDQU7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 16:59:13 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF79A40FF
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 13:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681765031; x=1713301031;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=gRIckOLc0394kqGecINNpcvouj7auAPVXwC8T1Aobw0=;
  b=Q559CirA7szA1Ym1bK+piujOWYAKjfLTMvHuU53J/uqQQNjC8JIWiUGu
   bpZFvQHP0DV9BVCLE+kL9zG2+zz+nYlRuImtStHYIFi/EolY2MSSCU9SW
   6bi2zqKsdEZ9p6NMuyX0WZfbJbYFj4Qc9XJ9KdEl8zGsWvuf28Xmluy0S
   8/EKdnRiUCmGL8CngQlZF6v+VEKExHRw6BDcjsc0R3CdpZ3bV7rC7OckY
   Wl8JmoA0zu/vJLgg4fIIceqEaiIRyO9f0mNwIBXUFEz0qbKpGGmLwH9uU
   RatE+q7bxgMPOSbu94nTAMM2hSctfZprpXa4VmmSshbbWGmDaZLXL1D0m
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10683"; a="431294561"
X-IronPort-AV: E=Sophos;i="5.99,205,1677571200"; 
   d="scan'208";a="431294561"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2023 13:56:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10683"; a="865126957"
X-IronPort-AV: E=Sophos;i="5.99,205,1677571200"; 
   d="scan'208";a="865126957"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga005.jf.intel.com with ESMTP; 17 Apr 2023 13:56:26 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Sebastian Basierski <sebastianx.basierski@intel.com>,
        anthony.l.nguyen@intel.com, kai.heng.feng@canonical.com,
        sasha.neftin@intel.com,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: [PATCH net 1/1] e1000e: Disable TSO on i219-LM card to increase speed
Date:   Mon, 17 Apr 2023 13:53:45 -0700
Message-Id: <20230417205345.1030801-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sebastian Basierski <sebastianx.basierski@intel.com>

While using i219-LM card currently it was only possible to achieve
about 60% of maximum speed due to regression introduced in Linux 5.8.
This was caused by TSO not being disabled by default despite commit
f29801030ac6 ("e1000e: Disable TSO for buffer overrun workaround").
Fix that by disabling TSO during driver probe.

Fixes: f29801030ac6 ("e1000e: Disable TSO for buffer overrun workaround")
Signed-off-by: Sebastian Basierski <sebastianx.basierski@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 51 +++++++++++-----------
 1 file changed, 26 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index e1eb1de88bf9..e14d1e45318f 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -5288,31 +5288,6 @@ static void e1000_watchdog_task(struct work_struct *work)
 				ew32(TARC(0), tarc0);
 			}
 
-			/* disable TSO for pcie and 10/100 speeds, to avoid
-			 * some hardware issues
-			 */
-			if (!(adapter->flags & FLAG_TSO_FORCE)) {
-				switch (adapter->link_speed) {
-				case SPEED_10:
-				case SPEED_100:
-					e_info("10/100 speed: disabling TSO\n");
-					netdev->features &= ~NETIF_F_TSO;
-					netdev->features &= ~NETIF_F_TSO6;
-					break;
-				case SPEED_1000:
-					netdev->features |= NETIF_F_TSO;
-					netdev->features |= NETIF_F_TSO6;
-					break;
-				default:
-					/* oops */
-					break;
-				}
-				if (hw->mac.type == e1000_pch_spt) {
-					netdev->features &= ~NETIF_F_TSO;
-					netdev->features &= ~NETIF_F_TSO6;
-				}
-			}
-
 			/* enable transmits in the hardware, need to do this
 			 * after setting TARC(0)
 			 */
@@ -7526,6 +7501,32 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			    NETIF_F_RXCSUM |
 			    NETIF_F_HW_CSUM);
 
+	/* disable TSO for pcie and 10/100 speeds to avoid
+	 * some hardware issues and for i219 to fix transfer
+	 * speed being capped at 60%
+	 */
+	if (!(adapter->flags & FLAG_TSO_FORCE)) {
+		switch (adapter->link_speed) {
+		case SPEED_10:
+		case SPEED_100:
+			e_info("10/100 speed: disabling TSO\n");
+			netdev->features &= ~NETIF_F_TSO;
+			netdev->features &= ~NETIF_F_TSO6;
+			break;
+		case SPEED_1000:
+			netdev->features |= NETIF_F_TSO;
+			netdev->features |= NETIF_F_TSO6;
+			break;
+		default:
+			/* oops */
+			break;
+		}
+		if (hw->mac.type == e1000_pch_spt) {
+			netdev->features &= ~NETIF_F_TSO;
+			netdev->features &= ~NETIF_F_TSO6;
+		}
+	}
+
 	/* Set user-changeable features (subset of all device features) */
 	netdev->hw_features = netdev->features;
 	netdev->hw_features |= NETIF_F_RXFCS;
-- 
2.38.1

