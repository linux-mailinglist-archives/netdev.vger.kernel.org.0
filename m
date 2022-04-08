Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7E84F9AAC
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 18:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231840AbiDHQfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 12:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231303AbiDHQff (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 12:35:35 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8295D7891E
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 09:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649435610; x=1680971610;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1XTMApYMqHOhGTXzlGhsB/SFQzTCRq6ANjjfhBVsGPE=;
  b=GoeTLJA7W479H2w7Kw+k8d/JjLHrUIBrNaVxoFe0g4k8qzbF3bxxeCwa
   OoabkzhgNX6wVpT7BphIbx9gjNm0x5Ok1aozTNlbyzpbea7c5jYj8UWiy
   GnxBYK9qAw8exq4ELNdszv1w+//i3c54qNeEaugxTw2WEu4Q+Z93762ex
   MVzDFkg3Ndd2AAMwfpOdN7tswbnJjjoO7ltVqBxujvp0WncbWJ3fxYBbz
   TP+97AKrfthPFXHMSip0Hv8XoP10s3825g6fiBD7P/QlX7UoIVQHzKEdq
   e37xajz6V125lvZyCDPOh+xbHB6olzWJuZqKG1h4SJgLI2pe/EQ1xx7NK
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="261321987"
X-IronPort-AV: E=Sophos;i="5.90,245,1643702400"; 
   d="scan'208";a="261321987"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2022 09:33:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,245,1643702400"; 
   d="scan'208";a="642957825"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 08 Apr 2022 09:33:28 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Ivan Vecera <ivecera@redhat.com>
Subject: [PATCH net 1/2] ice: arfs: fix use-after-free when freeing @rx_cpu_rmap
Date:   Fri,  8 Apr 2022 09:34:10 -0700
Message-Id: <20220408163411.2415552-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220408163411.2415552-1-anthony.l.nguyen@intel.com>
References: <20220408163411.2415552-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <alexandr.lobakin@intel.com>

The CI testing bots triggered the following splat:

[  718.203054] BUG: KASAN: use-after-free in free_irq_cpu_rmap+0x53/0x80
[  718.206349] Read of size 4 at addr ffff8881bd127e00 by task sh/20834
[  718.212852] CPU: 28 PID: 20834 Comm: sh Kdump: loaded Tainted: G S      W IOE     5.17.0-rc8_nextqueue-devqueue-02643-g23f3121aca93 #1
[  718.219695] Hardware name: Intel Corporation S2600WFT/S2600WFT, BIOS SE5C620.86B.02.01.0012.070720200218 07/07/2020
[  718.223418] Call Trace:
[  718.227139]
[  718.230783]  dump_stack_lvl+0x33/0x42
[  718.234431]  print_address_description.constprop.9+0x21/0x170
[  718.238177]  ? free_irq_cpu_rmap+0x53/0x80
[  718.241885]  ? free_irq_cpu_rmap+0x53/0x80
[  718.245539]  kasan_report.cold.18+0x7f/0x11b
[  718.249197]  ? free_irq_cpu_rmap+0x53/0x80
[  718.252852]  free_irq_cpu_rmap+0x53/0x80
[  718.256471]  ice_free_cpu_rx_rmap.part.11+0x37/0x50 [ice]
[  718.260174]  ice_remove_arfs+0x5f/0x70 [ice]
[  718.263810]  ice_rebuild_arfs+0x3b/0x70 [ice]
[  718.267419]  ice_rebuild+0x39c/0xb60 [ice]
[  718.270974]  ? asm_sysvec_apic_timer_interrupt+0x12/0x20
[  718.274472]  ? ice_init_phy_user_cfg+0x360/0x360 [ice]
[  718.278033]  ? delay_tsc+0x4a/0xb0
[  718.281513]  ? preempt_count_sub+0x14/0xc0
[  718.284984]  ? delay_tsc+0x8f/0xb0
[  718.288463]  ice_do_reset+0x92/0xf0 [ice]
[  718.292014]  ice_pci_err_resume+0x91/0xf0 [ice]
[  718.295561]  pci_reset_function+0x53/0x80
<...>
[  718.393035] Allocated by task 690:
[  718.433497] Freed by task 20834:
[  718.495688] Last potentially related work creation:
[  718.568966] The buggy address belongs to the object at ffff8881bd127e00
                which belongs to the cache kmalloc-96 of size 96
[  718.574085] The buggy address is located 0 bytes inside of
                96-byte region [ffff8881bd127e00, ffff8881bd127e60)
[  718.579265] The buggy address belongs to the page:
[  718.598905] Memory state around the buggy address:
[  718.601809]  ffff8881bd127d00: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
[  718.604796]  ffff8881bd127d80: 00 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc
[  718.607794] >ffff8881bd127e00: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
[  718.610811]                    ^
[  718.613819]  ffff8881bd127e80: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
[  718.617107]  ffff8881bd127f00: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc

This is due to that free_irq_cpu_rmap() is always being called
*after* (devm_)free_irq() and thus it tries to work with IRQ descs
already freed. For example, on device reset the driver frees the
rmap right before allocating a new one (the splat above).
Make rmap creation and freeing function symmetrical with
{request,free}_irq() calls i.e. do that on ifup/ifdown instead
of device probe/remove/resume. These operations can be performed
independently from the actual device aRFS configuration.
Also, make sure ice_vsi_free_irq() clears IRQ affinity notifiers
only when aRFS is disabled -- otherwise, CPU rmap sets and clears
its own and they must not be touched manually.

Fixes: 28bf26724fdb0 ("ice: Implement aRFS")
Co-developed-by: Ivan Vecera <ivecera@redhat.com>
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Tested-by: Ivan Vecera <ivecera@redhat.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_arfs.c |  9 ++-------
 drivers/net/ethernet/intel/ice/ice_lib.c  |  5 ++++-
 drivers/net/ethernet/intel/ice/ice_main.c | 18 ++++++++----------
 3 files changed, 14 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_arfs.c b/drivers/net/ethernet/intel/ice/ice_arfs.c
index 5daade32ea62..fba178e07600 100644
--- a/drivers/net/ethernet/intel/ice/ice_arfs.c
+++ b/drivers/net/ethernet/intel/ice/ice_arfs.c
@@ -577,7 +577,7 @@ void ice_free_cpu_rx_rmap(struct ice_vsi *vsi)
 {
 	struct net_device *netdev;
 
-	if (!vsi || vsi->type != ICE_VSI_PF || !vsi->arfs_fltr_list)
+	if (!vsi || vsi->type != ICE_VSI_PF)
 		return;
 
 	netdev = vsi->netdev;
@@ -599,7 +599,7 @@ int ice_set_cpu_rx_rmap(struct ice_vsi *vsi)
 	int base_idx, i;
 
 	if (!vsi || vsi->type != ICE_VSI_PF)
-		return -EINVAL;
+		return 0;
 
 	pf = vsi->back;
 	netdev = vsi->netdev;
@@ -636,7 +636,6 @@ void ice_remove_arfs(struct ice_pf *pf)
 	if (!pf_vsi)
 		return;
 
-	ice_free_cpu_rx_rmap(pf_vsi);
 	ice_clear_arfs(pf_vsi);
 }
 
@@ -653,9 +652,5 @@ void ice_rebuild_arfs(struct ice_pf *pf)
 		return;
 
 	ice_remove_arfs(pf);
-	if (ice_set_cpu_rx_rmap(pf_vsi)) {
-		dev_err(ice_pf_to_dev(pf), "Failed to rebuild aRFS\n");
-		return;
-	}
 	ice_init_arfs(pf_vsi);
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 2774cbd5b12a..6d19c58ccacd 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2689,6 +2689,8 @@ void ice_vsi_free_irq(struct ice_vsi *vsi)
 		return;
 
 	vsi->irqs_ready = false;
+	ice_free_cpu_rx_rmap(vsi);
+
 	ice_for_each_q_vector(vsi, i) {
 		u16 vector = i + base;
 		int irq_num;
@@ -2702,7 +2704,8 @@ void ice_vsi_free_irq(struct ice_vsi *vsi)
 			continue;
 
 		/* clear the affinity notifier in the IRQ descriptor */
-		irq_set_affinity_notifier(irq_num, NULL);
+		if (!IS_ENABLED(CONFIG_RFS_ACCEL))
+			irq_set_affinity_notifier(irq_num, NULL);
 
 		/* clear the affinity_mask in the IRQ descriptor */
 		irq_set_affinity_hint(irq_num, NULL);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index d768925785ca..5b1198859da7 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2510,6 +2510,13 @@ static int ice_vsi_req_irq_msix(struct ice_vsi *vsi, char *basename)
 		irq_set_affinity_hint(irq_num, &q_vector->affinity_mask);
 	}
 
+	err = ice_set_cpu_rx_rmap(vsi);
+	if (err) {
+		netdev_err(vsi->netdev, "Failed to setup CPU RMAP on VSI %u: %pe\n",
+			   vsi->vsi_num, ERR_PTR(err));
+		goto free_q_irqs;
+	}
+
 	vsi->irqs_ready = true;
 	return 0;
 
@@ -3692,20 +3699,12 @@ static int ice_setup_pf_sw(struct ice_pf *pf)
 	 */
 	ice_napi_add(vsi);
 
-	status = ice_set_cpu_rx_rmap(vsi);
-	if (status) {
-		dev_err(dev, "Failed to set CPU Rx map VSI %d error %d\n",
-			vsi->vsi_num, status);
-		goto unroll_napi_add;
-	}
 	status = ice_init_mac_fltr(pf);
 	if (status)
-		goto free_cpu_rx_map;
+		goto unroll_napi_add;
 
 	return 0;
 
-free_cpu_rx_map:
-	ice_free_cpu_rx_rmap(vsi);
 unroll_napi_add:
 	ice_tc_indir_block_unregister(vsi);
 unroll_cfg_netdev:
@@ -5167,7 +5166,6 @@ static int __maybe_unused ice_suspend(struct device *dev)
 			continue;
 		ice_vsi_free_q_vectors(pf->vsi[v]);
 	}
-	ice_free_cpu_rx_rmap(ice_get_main_vsi(pf));
 	ice_clear_interrupt_scheme(pf);
 
 	pci_save_state(pdev);
-- 
2.31.1

