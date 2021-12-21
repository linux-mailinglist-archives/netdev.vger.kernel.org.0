Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7467847C625
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 19:16:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241109AbhLUSQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 13:16:23 -0500
Received: from mga14.intel.com ([192.55.52.115]:10321 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241104AbhLUSQW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 13:16:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640110582; x=1671646582;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1dOOCjogTPUu+dLMZxmRfnxSxkGin83blr0yG/R3azY=;
  b=cESWO88CdnfsmiHUKUkYN49yqDGDYvno2CB9+wy3sILZ++1OwYH0nKaj
   xxr3+MyeWJuWRiF0erRrSBrL8kRFeEYVkCm6oZ64d34VPCWBQoe61R2XC
   c2tDfrTFK+Vz1Tp7cDcki1KnjjI/Io8kH9fSQKaViLOGU0cU/nrq+DeWR
   X7RyDsMXtXtBRvET6SyGQR8rJs0o6xm00xNowyF7de42AvksaGPdDkJxE
   edTgPKGBYUIy/AbROJDJMvpniNeqynCo6fT23PeBN58KCyFkLR0+8iHnt
   GcSBUeShx1sBkz6vS0g6phBVXE9cXYlIDqANF2X+qGFBq5RGZilTvaDua
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10205"; a="240684214"
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="240684214"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 10:02:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="613557841"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 21 Dec 2021 10:02:53 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Nechama Kraus <nechamax.kraus@linux.intel.com>
Subject: [PATCH net-next 3/8] igc: Remove obsolete nvm type
Date:   Tue, 21 Dec 2021 10:01:55 -0800
Message-Id: <20211221180200.3176851-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211221180200.3176851-1-anthony.l.nguyen@intel.com>
References: <20211221180200.3176851-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

i225 devices use only spi nvm type. This patch comes to tidy up
obsolete nvm types.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Nechama Kraus <nechamax.kraus@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_hw.h   | 2 --
 drivers/net/ethernet/intel/igc/igc_i225.c | 2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_hw.h b/drivers/net/ethernet/intel/igc/igc_hw.h
index 76832e55cbbb..b1e72ec5f131 100644
--- a/drivers/net/ethernet/intel/igc/igc_hw.h
+++ b/drivers/net/ethernet/intel/igc/igc_hw.h
@@ -67,8 +67,6 @@ enum igc_media_type {
 enum igc_nvm_type {
 	igc_nvm_unknown = 0,
 	igc_nvm_eeprom_spi,
-	igc_nvm_flash_hw,
-	igc_nvm_invm,
 };
 
 struct igc_info {
diff --git a/drivers/net/ethernet/intel/igc/igc_i225.c b/drivers/net/ethernet/intel/igc/igc_i225.c
index b6807e16eea9..66ea566488d1 100644
--- a/drivers/net/ethernet/intel/igc/igc_i225.c
+++ b/drivers/net/ethernet/intel/igc/igc_i225.c
@@ -473,13 +473,11 @@ s32 igc_init_nvm_params_i225(struct igc_hw *hw)
 
 	/* NVM Function Pointers */
 	if (igc_get_flash_presence_i225(hw)) {
-		hw->nvm.type = igc_nvm_flash_hw;
 		nvm->ops.read = igc_read_nvm_srrd_i225;
 		nvm->ops.write = igc_write_nvm_srwr_i225;
 		nvm->ops.validate = igc_validate_nvm_checksum_i225;
 		nvm->ops.update = igc_update_nvm_checksum_i225;
 	} else {
-		hw->nvm.type = igc_nvm_invm;
 		nvm->ops.read = igc_read_nvm_eerd;
 		nvm->ops.write = NULL;
 		nvm->ops.validate = NULL;
-- 
2.31.1

