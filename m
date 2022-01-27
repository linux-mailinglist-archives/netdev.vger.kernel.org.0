Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F72F49E573
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 16:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242661AbiA0PIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 10:08:15 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:45118 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236461AbiA0PIN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 10:08:13 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id BF9551F385;
        Thu, 27 Jan 2022 15:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1643296092; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=mvJIovCCwTZuCdni1wLB/3C4S6Z52Y9C071Ax9CQEfg=;
        b=jf60WUdW/fXlDfwzsRfgCO9f8Z7uxstryb7hrnmwPBJESHztvEBUfH3ttI/REYnXs6r6lJ
        ppd8EFmq62b+6nQ3w/D4aQdbHdZbwAEiUOZlY0vn/dhAWq4/wWZpMQNGCd22SnHGpOHzlM
        DhNnbT/DHbxBkYRTUtgT1brae4V1LSE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1643296092;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=mvJIovCCwTZuCdni1wLB/3C4S6Z52Y9C071Ax9CQEfg=;
        b=eepX5l7g6pGuILBefofCCu4h8dJCebYHI6A1uyrUMuvTqvgsOIzd/ui2m/+bKqv2UWm4lT
        xTveboO07szXyMAg==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 62F49A3B83;
        Thu, 27 Jan 2022 15:08:12 +0000 (UTC)
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Neftin <sasha.neftin@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] net: e1000e: Recover at least in-memory copy of NVM checksum
Date:   Thu, 27 Jan 2022 16:08:07 +0100
Message-Id: <20220127150807.26448-1-tbogendoerfer@suse.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 4051f68318ca ("e1000e: Do not take care about recovery NVM
checksum") causes a regression for systems with a broken NVM checksum
and hardware which is not able to update the NVM. Before the change the
in-memory copy was correct even the NVM update doesn't work, which is
good enough for the driver to work again.

See

https://bugzilla.opensuse.org/show_bug.cgi?id=1191663

for more details.

This patch reverts the change and moves the check for hardware without
NVM update capability right before the real flash update.

Fixes: 4051f68318ca ("e1000e: Do not take care about recovery NVM checksum")
Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
---
 drivers/net/ethernet/intel/e1000e/ich8lan.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index 5e4fc9b4e2ad..613a60f24ba6 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -3808,6 +3808,9 @@ static s32 e1000_update_nvm_checksum_spt(struct e1000_hw *hw)
 	if (nvm->type != e1000_nvm_flash_sw)
 		goto out;
 
+	if (hw->mac.type >= e1000_pch_cnp)
+		goto out;
+
 	nvm->ops.acquire(hw);
 
 	/* We're writing to the opposite bank so if we're on bank 1,
@@ -4136,17 +4139,13 @@ static s32 e1000_validate_nvm_checksum_ich8lan(struct e1000_hw *hw)
 		return ret_val;
 
 	if (!(data & valid_csum_mask)) {
-		e_dbg("NVM Checksum Invalid\n");
-
-		if (hw->mac.type < e1000_pch_cnp) {
-			data |= valid_csum_mask;
-			ret_val = e1000_write_nvm(hw, word, 1, &data);
-			if (ret_val)
-				return ret_val;
-			ret_val = e1000e_update_nvm_checksum(hw);
-			if (ret_val)
-				return ret_val;
-		}
+		data |= valid_csum_mask;
+		ret_val = e1000_write_nvm(hw, word, 1, &data);
+		if (ret_val)
+			return ret_val;
+		ret_val = e1000e_update_nvm_checksum(hw);
+		if (ret_val)
+			return ret_val;
 	}
 
 	return e1000e_validate_nvm_checksum_generic(hw);
-- 
2.29.2

