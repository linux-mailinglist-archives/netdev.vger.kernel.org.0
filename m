Return-Path: <netdev+bounces-10188-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D301F72CC41
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 19:19:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F3EBC1C20A2C
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 17:19:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB21A1B8EB;
	Mon, 12 Jun 2023 17:19:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB13A17AB7
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 17:19:47 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 231A1B2
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 10:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686590386; x=1718126386;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6r9PGHnc0kz807jA6eUOUlX8b6SJLPf8rp9rwHDjMmc=;
  b=I77Z/Rsq9a9GFAxdHZf5I5E/3OUKTjU61idj2PZFWvC6RmjMTXAjCvWp
   bDAvfFy0pqbcrGQBQ28s0f9GTNWsWZBLfgsBsvR0PGEzZeOncv31cfmoH
   bBRCBVXLCTDcPSgKFl1ZybiweqvS1gB2jZRtZ3HF/dvBM/N1pndi9gUjX
   lGgbH7+DOT09cz3lcptktQHukyM+ZDtwg7jjY/oXYGcUDbhoraSByx8IA
   4yIsPyT0Uv/t373wO4qSH2QIZ9OPxjwLrkAGUGWKoI3vOCPpREzktvtVW
   Gf8XjbeUh7P5Ya0BJudIANye8GOBWuZd2yLo+i/q4a0ECHMArnrehOK41
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="356994487"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="356994487"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 10:19:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="705479537"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="705479537"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga007.jf.intel.com with ESMTP; 12 Jun 2023 10:18:59 -0700
From: Tony Nguyen <anthony.l.nguyen@intel.com>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	netdev@vger.kernel.org
Cc: Jakub Buchocki <jakubx.buchocki@intel.com>,
	anthony.l.nguyen@intel.com,
	michal.swiatkowski@linux.intel.com,
	jiri@resnulli.us,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH net v2] ice: Fix ice module unload
Date: Mon, 12 Jun 2023 10:14:21 -0700
Message-Id: <20230612171421.21570-1-anthony.l.nguyen@intel.com>
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
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Jakub Buchocki <jakubx.buchocki@intel.com>

Clearing the interrupt scheme before PFR reset,
during the removal routine, could cause the hardware
errors and possibly lead to system reboot, as the PF
reset can cause the interrupt to be generated.

Place the call for PFR reset inside ice_deinit_dev(),
wait until reset and all pending transactions are done,
then call ice_clear_interrupt_scheme().

This introduces a PFR reset to multiple error paths.

Additionally, remove the call for the reset from
ice_load() - it will be a part of ice_unload() now.

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
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
v2: Changed to avoid multiple, individual calls to ice_clear_interrupt_scheme().

v1: https://lore.kernel.org/netdev/20230523173033.3577110-1-anthony.l.nguyen@intel.com/

 drivers/net/ethernet/intel/ice/ice_main.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 03513d4871ab..42c318ceff61 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4802,9 +4802,13 @@ static int ice_init_dev(struct ice_pf *pf)
 static void ice_deinit_dev(struct ice_pf *pf)
 {
 	ice_free_irq_msix_misc(pf);
-	ice_clear_interrupt_scheme(pf);
 	ice_deinit_pf(pf);
 	ice_deinit_hw(&pf->hw);
+
+	/* Service task is already stopped, so call reset directly. */
+	ice_reset(&pf->hw, ICE_RESET_PFR);
+	pci_wait_for_pending_transaction(pf->pdev);
+	ice_clear_interrupt_scheme(pf);
 }
 
 static void ice_init_features(struct ice_pf *pf)
@@ -5094,10 +5098,6 @@ int ice_load(struct ice_pf *pf)
 	struct ice_vsi *vsi;
 	int err;
 
-	err = ice_reset(&pf->hw, ICE_RESET_PFR);
-	if (err)
-		return err;
-
 	err = ice_init_dev(pf);
 	if (err)
 		return err;
@@ -5354,12 +5354,6 @@ static void ice_remove(struct pci_dev *pdev)
 	ice_setup_mc_magic_wake(pf);
 	ice_set_wake(pf);
 
-	/* Issue a PFR as part of the prescribed driver unload flow.  Do not
-	 * do it via ice_schedule_reset() since there is no need to rebuild
-	 * and the service task is already stopped.
-	 */
-	ice_reset(&pf->hw, ICE_RESET_PFR);
-	pci_wait_for_pending_transaction(pdev);
 	pci_disable_device(pdev);
 }
 
-- 
2.38.1


