Return-Path: <netdev+bounces-10097-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DFE6972C385
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 13:55:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E47BA1C20B2E
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 11:55:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6F7C18C38;
	Mon, 12 Jun 2023 11:55:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB618EBE
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 11:55:55 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9560BB7
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 04:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686570954; x=1718106954;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=kGiZDMBs9zzbV4mOYI15lTjvZQcX2GITTlI5US0c2Oc=;
  b=lrK8WWJaeYa6mpgOtRnSQtHBPdmIGiiihti6mdPe91TK1TTmn7QEyZOV
   nn1tFTNBu/rd6ghNHl83gKaZmjqWguRHf1wqZr8eSs+81Vd8aJPwc8WrC
   2MVORc9BG8QvtV4huBbYtQGCEJ2hqnodnAQh89QWFBhvr6Us5QHgjOoR2
   MZBlZ+1Ey/tpaI6FJfb8SjoMd79OVSNhX64vOMdBvppk1X4hCOBbXA3q/
   HfaTeOhPS7TIhUIr3YuQ/MQLRicZPU4rGNspU66ZU47RMoAdMniHA/J8x
   IaQ+QPJDsJnTpsk1fVVDV5R1SPuW7ZMM+t8NrviDjoTIBWLkRcy0Gsbye
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="358012671"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="358012671"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 04:55:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="781179273"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="781179273"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by fmsmga004.fm.intel.com with ESMTP; 12 Jun 2023 04:55:52 -0700
Received: from pelor.igk.intel.com (pelor.igk.intel.com [10.123.220.13])
	by irvmail002.ir.intel.com (Postfix) with ESMTP id 59FB234912;
	Mon, 12 Jun 2023 12:55:51 +0100 (IST)
From: Przemek Kitszel <przemyslaw.kitszel@intel.com>
To: intel-wired-lan@lists.osuosl.org
Cc: Tony Nguyen <anthony.l.nguyen@intel.com>,
	Piotr Gardocki <piotrx.gardocki@intel.com>,
	netdev@vger.kernel.org,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>
Subject: [PATCH iwl-next] ice: fix VSI LUT size flag
Date: Mon, 12 Jun 2023 07:53:34 -0400
Message-Id: <20230612115334.8262-1-przemyslaw.kitszel@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Fix VSI LUT size flag to be 0.

Fixes: 99faff6dea0a ("ice: clean up __ice_aq_get_set_rss_lut()")
Reported-by: Piotr Gardocki <piotrx.gardocki@intel.com>

---
Tony, please meld this commit into my recent refactor (see Fixes tag).
I have overlooked it while applying review changes, sorry :/
---
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 6ea0d4c017f0..acea49007f2a 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1819,7 +1819,7 @@ enum ice_lut_size {
  * LUT size and LUT type, last of which does not need neither shift nor mask.
  */
 enum ice_aqc_lut_flags {
-	ICE_AQC_LUT_SIZE_SMALL = BIT(1), /* size = 64 or 128 */
+	ICE_AQC_LUT_SIZE_SMALL = 0, /* size = 64 or 128 */
 	ICE_AQC_LUT_SIZE_512 = BIT(2),
 	ICE_AQC_LUT_SIZE_2K = BIT(3),
 
-- 
2.40.1


