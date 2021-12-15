Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34E3847613A
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 19:56:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344105AbhLOSzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 13:55:48 -0500
Received: from mga14.intel.com ([192.55.52.115]:57351 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344109AbhLOSzd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 13:55:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639594533; x=1671130533;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ANwe/dTH516a3Gx2E//lMSYKPiLXt91UVAu2o9hDwIw=;
  b=YQY3s9k3UgnND1i2/0JfyINJb9bnq89lk9HcbtgBs1UP43vW3PKKJf68
   duOf/4VhZhuhZK+2wYCA/MIAm6vipCno+ve5EfMcU4LobEbdmIM7Xh0jC
   ImpfQVhipmWI81OJiR2uvVMcQOR/NfMcql2D6Io3jQzssW0wVp11O/eAE
   XuoX6HJA6UlvsuBjR45PNavPHXVms9TOv7X6ycJ/RIJkQp18fdevCUqgt
   1so0PByKltwTLMr9ejdaaai8FQyv9ch1fU9MiZiPzn0mNa4CqE6FMTA3v
   DSDFpC7eWH/vNbFHQDEjxBtQUM77cr9+uXoLUgn6N//VUu314huHXcecX
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="239533302"
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="239533302"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2021 10:54:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="465729942"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 15 Dec 2021 10:54:54 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 4/9] ice: reduce time to read Option ROM CIVD data
Date:   Wed, 15 Dec 2021 10:53:50 -0800
Message-Id: <20211215185355.3249738-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211215185355.3249738-1-anthony.l.nguyen@intel.com>
References: <20211215185355.3249738-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

During probe and device reset, the ice driver reads some data from the
NVM image as part of ice_init_nvm. Part of this data includes a section
of the Option ROM which contains version information.

The function ice_get_orom_civd_data is used to locate the '$CIV' data
section of the Option ROM.

Timing of ice_probe and ice_rebuild indicate that the
ice_get_orom_civd_data function takes about 10 seconds to finish
executing.

The function locates the section by scanning the Option ROM every 512
bytes. This requires a significant number of NVM read accesses, since
the Option ROM bank is 500KB. In the worst case it would take about 1000
reads. Worse, all PFs serialize this operation during reload because of
acquiring the NVM semaphore.

The CIVD section is located at the end of the Option ROM image data.
Unfortunately, the driver has no easy method to determine the offset
manually. Practical experiments have shown that the data could be at
a variety of locations, so simply reversing the scanning order is not
sufficient to reduce the overall read time.

Instead, copy the entire contents of the Option ROM into memory. This
allows reading the data using 4Kb pages instead of 512 bytes at a time.
This reduces the total number of firmware commands by a factor of 8. In
addition, reading the whole section together at once allows better
indication to firmware of when we're "done".

Re-write ice_get_orom_civd_data to allocate virtual memory to store the
Option ROM data. Copy the entire OptionROM contents at once using
ice_read_flash_module. Finally, use this memory copy to scan for the
'$CIV' section.

This change significantly reduces the time to read the Option ROM CIVD
section from ~10 seconds down to ~1 second. This has a significant
impact on the total time to complete a driver rebuild or probe.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_nvm.c | 48 ++++++++++++++++++------
 1 file changed, 36 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.c b/drivers/net/ethernet/intel/ice/ice_nvm.c
index 2d95fe533d1e..f3fe6829c3df 100644
--- a/drivers/net/ethernet/intel/ice/ice_nvm.c
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.c
@@ -615,7 +615,7 @@ static int
 ice_get_orom_civd_data(struct ice_hw *hw, enum ice_bank_select bank,
 		       struct ice_orom_civd_info *civd)
 {
-	struct ice_orom_civd_info tmp;
+	u8 *orom_data;
 	int status;
 	u32 offset;
 
@@ -623,36 +623,60 @@ ice_get_orom_civd_data(struct ice_hw *hw, enum ice_bank_select bank,
 	 * The first 4 bytes must contain the ASCII characters "$CIV".
 	 * A simple modulo 256 sum of all of the bytes of the structure must
 	 * equal 0.
+	 *
+	 * The exact location is unknown and varies between images but is
+	 * usually somewhere in the middle of the bank. We need to scan the
+	 * Option ROM bank to locate it.
+	 *
+	 * It's significantly faster to read the entire Option ROM up front
+	 * using the maximum page size, than to read each possible location
+	 * with a separate firmware command.
 	 */
+	orom_data = vzalloc(hw->flash.banks.orom_size);
+	if (!orom_data)
+		return -ENOMEM;
+
+	status = ice_read_flash_module(hw, bank, ICE_SR_1ST_OROM_BANK_PTR, 0,
+				       orom_data, hw->flash.banks.orom_size);
+	if (status) {
+		ice_debug(hw, ICE_DBG_NVM, "Unable to read Option ROM data\n");
+		return status;
+	}
+
+	/* Scan the memory buffer to locate the CIVD data section */
 	for (offset = 0; (offset + 512) <= hw->flash.banks.orom_size; offset += 512) {
+		struct ice_orom_civd_info *tmp;
 		u8 sum = 0, i;
 
-		status = ice_read_flash_module(hw, bank, ICE_SR_1ST_OROM_BANK_PTR,
-					       offset, (u8 *)&tmp, sizeof(tmp));
-		if (status) {
-			ice_debug(hw, ICE_DBG_NVM, "Unable to read Option ROM CIVD data\n");
-			return status;
-		}
+		tmp = (struct ice_orom_civd_info *)&orom_data[offset];
 
 		/* Skip forward until we find a matching signature */
-		if (memcmp("$CIV", tmp.signature, sizeof(tmp.signature)) != 0)
+		if (memcmp("$CIV", tmp->signature, sizeof(tmp->signature)) != 0)
 			continue;
 
+		ice_debug(hw, ICE_DBG_NVM, "Found CIVD section at offset %u\n",
+			  offset);
+
 		/* Verify that the simple checksum is zero */
-		for (i = 0; i < sizeof(tmp); i++)
+		for (i = 0; i < sizeof(*tmp); i++)
 			/* cppcheck-suppress objectIndex */
-			sum += ((u8 *)&tmp)[i];
+			sum += ((u8 *)tmp)[i];
 
 		if (sum) {
 			ice_debug(hw, ICE_DBG_NVM, "Found CIVD data with invalid checksum of %u\n",
 				  sum);
-			return -EIO;
+			goto err_invalid_checksum;
 		}
 
-		*civd = tmp;
+		*civd = *tmp;
+		vfree(orom_data);
 		return 0;
 	}
 
+	ice_debug(hw, ICE_DBG_NVM, "Unable to locate CIVD data within the Option ROM\n");
+
+err_invalid_checksum:
+	vfree(orom_data);
 	return -EIO;
 }
 
-- 
2.31.1

