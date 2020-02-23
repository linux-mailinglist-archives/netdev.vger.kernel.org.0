Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3DA4169515
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 03:36:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbgBWCfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 21:35:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:51182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728054AbgBWCWO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Feb 2020 21:22:14 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D4E5206D7;
        Sun, 23 Feb 2020 02:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582424534;
        bh=eJdKrXY9up3SNWC2qqe1sddjplkQ6CTF+Cp0LH+q1tA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d1v5mhc0sEQDAOoNy/RcT0DnyYusFasWQthkNLfXaMtiKpwj7s62noJWr6ExWp2tq
         Y1GdMedbqy3gALm1cSLEjahnv7/PQhQW7/dvSuHpK5o5OSvirDvHoittEES/4k7mVg
         HGke7aNMBq5p3XivyYSFUy2f5ChQjQvgHWIBWqhM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bruce Allan <bruce.w.allan@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 45/58] ice: update Unit Load Status bitmask to check after reset
Date:   Sat, 22 Feb 2020 21:21:06 -0500
Message-Id: <20200223022119.707-45-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200223022119.707-1-sashal@kernel.org>
References: <20200223022119.707-1-sashal@kernel.org>
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
index fb1d930470c71..cb437a448305e 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -937,7 +937,7 @@ void ice_deinit_hw(struct ice_hw *hw)
  */
 enum ice_status ice_check_reset(struct ice_hw *hw)
 {
-	u32 cnt, reg = 0, grst_delay;
+	u32 cnt, reg = 0, grst_delay, uld_mask;
 
 	/* Poll for Device Active state in case a recent CORER, GLOBR,
 	 * or EMPR has occurred. The grst delay value is in 100ms units.
@@ -959,13 +959,20 @@ enum ice_status ice_check_reset(struct ice_hw *hw)
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
index e8f32350fed29..6f4a70fa39037 100644
--- a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
+++ b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
@@ -276,8 +276,14 @@
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

