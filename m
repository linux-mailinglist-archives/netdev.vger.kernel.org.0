Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7C84A62A2
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 18:38:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241545AbiBARiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 12:38:10 -0500
Received: from mga02.intel.com ([134.134.136.20]:11148 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241555AbiBARiJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Feb 2022 12:38:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643737089; x=1675273089;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Qs5CypaTnYnz6I96G/ki7zBlZguwBlhWTTc2nfEzyk4=;
  b=NVoA8oy5LMH470cARyWbEpOvn+Izl7AF5H89E4FY6gm5gK/aqJCFcvM0
   nWJaRLwk/1ZMfwsWqbxYkq2kDLAUUAD6cKbi9GEIs8C75AjtBr5OdaCVb
   LUGqYY2rPnQP56Jms4ChmWwnHIT97ajCmGDE+rIR7FjpdbzYdkHFpDisr
   BCoAbGVuPsRmCmBghg4sR0gTsk/8265F0sJBlQRPeuaxgJ9MkYAIqcW4m
   L8OgA9VWtOB0+xKV/tJ5ZxDl9O88XWRvIFm3Qc1c+NgurgXyLFyXuItGx
   J1X5p09elBltQvgtyWT8TeLQVuIY/ErFX5EOSPl0VB+BqwGib07InFqfd
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10245"; a="235141802"
X-IronPort-AV: E=Sophos;i="5.88,334,1635231600"; 
   d="scan'208";a="235141802"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2022 09:38:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,334,1635231600"; 
   d="scan'208";a="482465894"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 01 Feb 2022 09:38:07 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, vitaly.lifshits@intel.com,
        Nechama Kraus <nechamax.kraus@linux.intel.com>
Subject: [PATCH net 2/2] e1000e: Handshake with CSME starts from ADL platforms
Date:   Tue,  1 Feb 2022 09:37:54 -0800
Message-Id: <20220201173754.580305-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220201173754.580305-1-anthony.l.nguyen@intel.com>
References: <20220201173754.580305-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Handshake with CSME/AMT on none provisioned platforms during S0ix flow
is not supported on TGL platform and can cause to HW unit hang. Update
the handshake with CSME flow to start from the ADL platform.

Fixes: 3e55d231716e ("e1000e: Add handshake with the CSME to support S0ix")
Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Nechama Kraus <nechamax.kraus@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index d2de8bc4c3b7..a42aeb555f34 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6342,7 +6342,8 @@ static void e1000e_s0ix_entry_flow(struct e1000_adapter *adapter)
 	u32 mac_data;
 	u16 phy_data;
 
-	if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID) {
+	if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID &&
+	    hw->mac.type >= e1000_pch_adp) {
 		/* Request ME configure the device for S0ix */
 		mac_data = er32(H2ME);
 		mac_data |= E1000_H2ME_START_DPG;
@@ -6491,7 +6492,8 @@ static void e1000e_s0ix_exit_flow(struct e1000_adapter *adapter)
 	u16 phy_data;
 	u32 i = 0;
 
-	if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID) {
+	if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID &&
+	    hw->mac.type >= e1000_pch_adp) {
 		/* Request ME unconfigure the device from S0ix */
 		mac_data = er32(H2ME);
 		mac_data &= ~E1000_H2ME_START_DPG;
-- 
2.31.1

