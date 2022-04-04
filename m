Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B69394F15ED
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 15:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353044AbiDDNcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 09:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243632AbiDDNcp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 09:32:45 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39A041EACE;
        Mon,  4 Apr 2022 06:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649079049; x=1680615049;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=cjuK6YuB7DvTu+1ibjzsUPC9QtPmDTctVpzqH1N2zAk=;
  b=lI+0e2E8+fEd5Pt6AEVpkJdn+h8UzAWD7R7yyel4sIIdrAQ8LUcyVfFz
   7SZ+2ctyka1dpMF1DRoCBdERlQlvQjqw3wuJs+vuYo4HtV9RQK97ldAqv
   n9qnAA05l6/3eSEvzcn4e2Uhhf6gQ1m+UbkYUOlRDkxYccXmX/6bzxz/0
   O5K+mWz0LzCmLpIaX8pZpWsb2tmK0hRIhvCpT/pJdlD6iH5GrPZV4sFBj
   mR+l97Fgc/2J999aHmE3M97UFGO49r9Jx20cCesxmNGbPbq4UkTNK4pRP
   E4J5VF1p20xxTsyF3J39rfxnjdXPZayLlzvpXStAxm/K/0pYOYi2a3En+
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10306"; a="241100827"
X-IronPort-AV: E=Sophos;i="5.90,234,1643702400"; 
   d="scan'208";a="241100827"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2022 06:30:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,234,1643702400"; 
   d="scan'208";a="651494441"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga002.fm.intel.com with ESMTP; 04 Apr 2022 06:30:42 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 234DUerE005936;
        Mon, 4 Apr 2022 14:30:40 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Brett Creeley <brett@pensando.io>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Ivan Vecera <ivecera@redhat.com>
Subject: [PATCH net] ice: arfs: fix use-after-free when freeing @rx_cpu_rmap
Date:   Mon,  4 Apr 2022 15:28:32 +0200
Message-Id: <20220404132832.1936529-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HEXHASH_WORD,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
Netdev folks, some more urgent stuff, would like to have this in
-net directly.

Ivan, I probably should've waited for your response regarding
signatures, hope you'll approve this one :p Feel free to review
and/or test.
---
 drivers/net/ethernet/intel/ice/ice_arfs.c |  7 +------
 drivers/net/ethernet/intel/ice/ice_lib.c  |  5 ++++-
 drivers/net/ethernet/intel/ice/ice_main.c | 18 ++++++++----------
 3 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_arfs.c b/drivers/net/ethernet/intel/ice/ice_arfs.c
index 5daade32ea62..97347b796066 100644
--- a/drivers/net/ethernet/intel/ice/ice_arfs.c
+++ b/drivers/net/ethernet/intel/ice/ice_arfs.c
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
index 6d6233204388..7fe4bfd7882a 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2688,6 +2688,8 @@ void ice_vsi_free_irq(struct ice_vsi *vsi)
 		return;
 
 	vsi->irqs_ready = false;
+	ice_free_cpu_rx_rmap(vsi);
+
 	ice_for_each_q_vector(vsi, i) {
 		u16 vector = i + base;
 		int irq_num;
@@ -2701,7 +2703,8 @@ void ice_vsi_free_irq(struct ice_vsi *vsi)
 			continue;
 
 		/* clear the affinity notifier in the IRQ descriptor */
-		irq_set_affinity_notifier(irq_num, NULL);
+		if (!IS_ENABLED(CONFIG_RFS_ACCEL))
+			irq_set_affinity_notifier(irq_num, NULL);
 
 		/* clear the affinity_mask in the IRQ descriptor */
 		irq_set_affinity_hint(irq_num, NULL);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 1d2ca39add95..24d3279df231 100644
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
 
@@ -3690,20 +3697,12 @@ static int ice_setup_pf_sw(struct ice_pf *pf)
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
@@ -5165,7 +5164,6 @@ static int __maybe_unused ice_suspend(struct device *dev)
 			continue;
 		ice_vsi_free_q_vectors(pf->vsi[v]);
 	}
-	ice_free_cpu_rx_rmap(ice_get_main_vsi(pf));
 	ice_clear_interrupt_scheme(pf);
 
 	pci_save_state(pdev);
-- 
2.35.1

