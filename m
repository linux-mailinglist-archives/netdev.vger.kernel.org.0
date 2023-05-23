Return-Path: <netdev+bounces-4780-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BC0D70E2C8
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 19:35:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 268721C20C85
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 17:34:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1688821078;
	Tue, 23 May 2023 17:34:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037C2206A8
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 17:34:58 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 315E718D
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 10:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684863278; x=1716399278;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=y9UU0vr6/8mGv06Q3bZa4sZdiUIJw34DYjaY5tIewX4=;
  b=lEJUv9OiYz/niv/hvWv84iCfOxH+xrv6PMQOiv+aEWVfQ0rEN5v2qjdF
   eEYNE3Z3j7TgjkjGdTB9vym2Lu18h/5WuSHSC64yIBKMO3iKUOyk9/NSk
   gbALU5AGx2iw9WXFnmPBGUDnqtBeKv9jZ9zlyTCogu72ANUYVxlPZth/H
   ZO3dc84tB+6z7LjTD7Y04dplH5u/DQbXsAAXuEXFaqr8+iMqckXWEv6LT
   7sSFL4WKNUwMKGTe7NcEqAFx+KMD+/tmDznGNAd205gc2nNBPp02zTBq2
   RjseTzCwgipl+7/ek+rdt0ncXJbUYjbczUfTXX0XNhZ1tiwpzPlNkij4S
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="353336448"
X-IronPort-AV: E=Sophos;i="6.00,187,1681196400"; 
   d="scan'208";a="353336448"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2023 10:34:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="878297602"
X-IronPort-AV: E=Sophos;i="6.00,187,1681196400"; 
   d="scan'208";a="878297602"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga005.jf.intel.com with ESMTP; 23 May 2023 10:34:31 -0700
From: Tony Nguyen <anthony.l.nguyen@intel.com>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	netdev@vger.kernel.org
Cc: Jakub Buchocki <jakubx.buchocki@intel.com>,
	anthony.l.nguyen@intel.com,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Arpana Arland <arpanax.arland@intel.com>
Subject: [PATCH net] ice: Fix ice module unload
Date: Tue, 23 May 2023 10:30:33 -0700
Message-Id: <20230523173033.3577110-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Jakub Buchocki <jakubx.buchocki@intel.com>

Clearing interrupt scheme before PFR reset, during the removal routine,
could cause the hardware errors and possibly lead to system reboot, as
the PF reset can cause the interrupt to be generated.
Move clearing interrupt scheme from device deinitialization subprocedure,
and call it directly in particular routines. In ice_remove(), call the
ice_clear_interrupt_scheme() after the PFR is complete and all pending
transactions are done.

Error example:
[   75.229328] ice 0000:ca:00.1: Failed to read Tx Scheduler Tree - User Selection data from flash
[   77.571315] {1}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 1
[   77.571418] {1}[Hardware Error]: event severity: recoverable
[   77.571459] {1}[Hardware Error]:  Error 0, type: recoverable
[   77.571500] {1}[Hardware Error]:   section_type: PCIe error
[   77.571540] {1}[Hardware Error]:   port_type: 4, root port
[   77.571580] {1}[Hardware Error]:   version: 3.0
[   77.571615] {1}[Hardware Error]:   command: 0x0547, status: 0x4010
[   77.571661] {1}[Hardware Error]:   device_id: 0000:c9:02.0
[   77.571703] {1}[Hardware Error]:   slot: 25
[   77.571736] {1}[Hardware Error]:   secondary_bus: 0xca
[   77.571773] {1}[Hardware Error]:   vendor_id: 0x8086, device_id: 0x347a
[   77.571821] {1}[Hardware Error]:   class_code: 060400
[   77.571858] {1}[Hardware Error]:   bridge: secondary_status: 0x2800, control: 0x0013
[   77.572490] pcieport 0000:c9:02.0: AER: aer_status: 0x00200000, aer_mask: 0x00100020
[   77.572870] pcieport 0000:c9:02.0:    [21] ACSViol                (First)
[   77.573222] pcieport 0000:c9:02.0: AER: aer_layer=Transaction Layer, aer_agent=Receiver ID
[   77.573554] pcieport 0000:c9:02.0: AER: aer_uncor_severity: 0x00463010
[   77.691273] {2}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 1
[   77.691738] {2}[Hardware Error]: event severity: recoverable
[   77.691971] {2}[Hardware Error]:  Error 0, type: recoverable
[   77.692192] {2}[Hardware Error]:   section_type: PCIe error
[   77.692403] {2}[Hardware Error]:   port_type: 4, root port
[   77.692616] {2}[Hardware Error]:   version: 3.0
[   77.692825] {2}[Hardware Error]:   command: 0x0547, status: 0x4010
[   77.693032] {2}[Hardware Error]:   device_id: 0000:c9:02.0
[   77.693238] {2}[Hardware Error]:   slot: 25
[   77.693440] {2}[Hardware Error]:   secondary_bus: 0xca
[   77.693641] {2}[Hardware Error]:   vendor_id: 0x8086, device_id: 0x347a
[   77.693853] {2}[Hardware Error]:   class_code: 060400
[   77.694054] {2}[Hardware Error]:   bridge: secondary_status: 0x0800, control: 0x0013
[   77.719115] pci 0000:ca:00.1: AER: can't recover (no error_detected callback)
[   77.719140] pcieport 0000:c9:02.0: AER: device recovery failed
[   77.719216] pcieport 0000:c9:02.0: AER: aer_status: 0x00200000, aer_mask: 0x00100020
[   77.719390] pcieport 0000:c9:02.0:    [21] ACSViol                (First)
[   77.719557] pcieport 0000:c9:02.0: AER: aer_layer=Transaction Layer, aer_agent=Receiver ID
[   77.719723] pcieport 0000:c9:02.0: AER: aer_uncor_severity: 0x00463010

Fixes: 5b246e533d01 ("ice: split probe into smaller functions")
Signed-off-by: Jakub Buchocki <jakubx.buchocki@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Arpana Arland <arpanax.arland@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index a1f7c8edc22f..5052250b147e 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4802,7 +4802,6 @@ static int ice_init_dev(struct ice_pf *pf)
 static void ice_deinit_dev(struct ice_pf *pf)
 {
 	ice_free_irq_msix_misc(pf);
-	ice_clear_interrupt_scheme(pf);
 	ice_deinit_pf(pf);
 	ice_deinit_hw(&pf->hw);
 }
@@ -5071,6 +5070,7 @@ static int ice_init(struct ice_pf *pf)
 	ice_dealloc_vsis(pf);
 err_alloc_vsis:
 	ice_deinit_dev(pf);
+	ice_clear_interrupt_scheme(pf);
 	return err;
 }
 
@@ -5098,6 +5098,8 @@ int ice_load(struct ice_pf *pf)
 	if (err)
 		return err;
 
+	ice_clear_interrupt_scheme(pf);
+
 	err = ice_init_dev(pf);
 	if (err)
 		return err;
@@ -5132,6 +5134,7 @@ int ice_load(struct ice_pf *pf)
 	ice_vsi_decfg(ice_get_main_vsi(pf));
 err_vsi_cfg:
 	ice_deinit_dev(pf);
+	ice_clear_interrupt_scheme(pf);
 	return err;
 }
 
@@ -5251,6 +5254,7 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 	ice_deinit_eth(pf);
 err_init_eth:
 	ice_deinit(pf);
+	ice_clear_interrupt_scheme(pf);
 err_init:
 	pci_disable_device(pdev);
 	return err;
@@ -5360,6 +5364,7 @@ static void ice_remove(struct pci_dev *pdev)
 	 */
 	ice_reset(&pf->hw, ICE_RESET_PFR);
 	pci_wait_for_pending_transaction(pdev);
+	ice_clear_interrupt_scheme(pf);
 	pci_disable_device(pdev);
 }
 
-- 
2.38.1


