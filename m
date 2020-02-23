Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5B8169476
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 03:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728686AbgBWCX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 21:23:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:52898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728661AbgBWCX0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Feb 2020 21:23:26 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C99072071E;
        Sun, 23 Feb 2020 02:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582424605;
        bh=eXXEwCxnzdfxbjn5nkEQ8AGAGP1DgqEPMJ10TE5Ql3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sLB72CR1KmgULm9w1HXhwVnyO952DTXsrH4Z+L59lKRGqZevqScq/493fEjwsVghE
         bV34dPQ1i7/quDgoHQEIuH8xfiL040TrfvJJih/SFLA34g6rDxNuqV2qWDbTG9cNno
         YbIrkN6Lu/K7zkerEP35bvPF2nR0PDlYq6cSBXI4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bruce Allan <bruce.w.allan@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 41/50] ice: update Unit Load Status bitmask to check after reset
Date:   Sat, 22 Feb 2020 21:22:26 -0500
Message-Id: <20200223022235.1404-41-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200223022235.1404-1-sashal@kernel.org>
References: <20200223022235.1404-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bruce Allan <bruce.w.allan@intel.com>

[ Upstream commit cf8fc2a0863f9ff27ebd2efcdb1f7d378b9fb8a6 ]

After a reset the Unit Load Status bits in the GLNVM_ULD register to check
for completion should be 0x7FF before continuing.  Update the mask to check
(minus the three reserved bits that are always set).

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_common.c     | 17 ++++++++++++-----
 drivers/net/ethernet/intel/ice/ice_hw_autogen.h |  6 ++++++
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 3a6b3950eb0e2..171f0b6254073 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -934,7 +934,7 @@ void ice_deinit_hw(struct ice_hw *hw)
  */
 enum ice_status ice_check_reset(struct ice_hw *hw)
 {
-	u32 cnt, reg = 0, grst_delay;
+	u32 cnt, reg = 0, grst_delay, uld_mask;
 
 	/* Poll for Device Active state in case a recent CORER, GLOBR,
 	 * or EMPR has occurred. The grst delay value is in 100ms units.
@@ -956,13 +956,20 @@ enum ice_status ice_check_reset(struct ice_hw *hw)
 		return ICE_ERR_RESET_FAILED;
 	}
 
-#define ICE_RESET_DONE_MASK	(GLNVM_ULD_CORER_DONE_M | \
-				 GLNVM_ULD_GLOBR_DONE_M)
+#define ICE_RESET_DONE_MASK	(GLNVM_ULD_PCIER_DONE_M |\
+				 GLNVM_ULD_PCIER_DONE_1_M |\
+				 GLNVM_ULD_CORER_DONE_M |\
+				 GLNVM_ULD_GLOBR_DONE_M |\
+				 GLNVM_ULD_POR_DONE_M |\
+				 GLNVM_ULD_POR_DONE_1_M |\
+				 GLNVM_ULD_PCIER_DONE_2_M)
+
+	uld_mask = ICE_RESET_DONE_MASK;
 
 	/* Device is Active; check Global Reset processes are done */
 	for (cnt = 0; cnt < ICE_PF_RESET_WAIT_COUNT; cnt++) {
-		reg = rd32(hw, GLNVM_ULD) & ICE_RESET_DONE_MASK;
-		if (reg == ICE_RESET_DONE_MASK) {
+		reg = rd32(hw, GLNVM_ULD) & uld_mask;
+		if (reg == uld_mask) {
 			ice_debug(hw, ICE_DBG_INIT,
 				  "Global reset processes done. %d\n", cnt);
 			break;
diff --git a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
index 152fbd556e9b4..9138b19de87e0 100644
--- a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
+++ b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
@@ -273,8 +273,14 @@
 #define GLNVM_GENS_SR_SIZE_S			5
 #define GLNVM_GENS_SR_SIZE_M			ICE_M(0x7, 5)
 #define GLNVM_ULD				0x000B6008
+#define GLNVM_ULD_PCIER_DONE_M			BIT(0)
+#define GLNVM_ULD_PCIER_DONE_1_M		BIT(1)
 #define GLNVM_ULD_CORER_DONE_M			BIT(3)
 #define GLNVM_ULD_GLOBR_DONE_M			BIT(4)
+#define GLNVM_ULD_POR_DONE_M			BIT(5)
+#define GLNVM_ULD_POR_DONE_1_M			BIT(8)
+#define GLNVM_ULD_PCIER_DONE_2_M		BIT(9)
+#define GLNVM_ULD_PE_DONE_M			BIT(10)
 #define GLPCI_CNF2				0x000BE004
 #define GLPCI_CNF2_CACHELINE_SIZE_M		BIT(1)
 #define PF_FUNC_RID				0x0009E880
-- 
2.20.1

