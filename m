Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF328405294
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353750AbhIIMoP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:44:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:46130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354811AbhIIMji (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:39:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABD9E61BD2;
        Thu,  9 Sep 2021 11:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188490;
        bh=BXcgJ5FGrSa1vP6CBtltDNlV8URBJBSRWoUnZO/prXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cXDmHwUXyhUsP6lwUTsfUe+Um5Dxew62CPaMVFgfQXhd9jXCCBFWYYaRwnGG4uK0B
         RbWvGwgaeKMfTzIf7+0GsuVE5ePqP+xYO9+Ds0r+AmKsQNE+4urpZUVMxLF2Px33zD
         9MGASox2H8MhkE2YH8DcOUXtY9z7woybCrIgW42MNeF+pbn0gcngtH/HcrdQAS6X0B
         3BIBDLkQyU4Ub/w7Glhog0vO8H+vwBxu8Weu/UYfsqPjc5fLDk4SiaDQVBZIFNnMXb
         aSGNl3jgN8UwRN3dn7sRyxV6gDdUHcf7H70xqWuuoI6ACsbdyAAEyditd6MS2ECYcB
         fJXJ0ro5iKZPA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 164/176] iwlwifi: fw: correctly limit to monitor dump
Date:   Thu,  9 Sep 2021 07:51:06 -0400
Message-Id: <20210909115118.146181-164-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115118.146181-1-sashal@kernel.org>
References: <20210909115118.146181-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit e6344c060209ef4e970cac18adeac1676a2a73cd ]

In commit 79f033f6f229 ("iwlwifi: dbg: don't limit dump decisions
to all or monitor") we changed the code to pass around a bitmap,
but in the monitor_only case, one place accidentally used the bit
number, not the bit mask, resulting in CSR and FW_INFO getting
dumped instead of monitor data. Fix that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210805141826.774fd8729a33.Ic985a787071d1c0b127ef0ba8367da896ee11f57@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index ab4a8b942c81..419eaa5cf0b5 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -2303,7 +2303,7 @@ static void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt,
 		return;
 
 	if (dump_data->monitor_only)
-		dump_mask &= IWL_FW_ERROR_DUMP_FW_MONITOR;
+		dump_mask &= BIT(IWL_FW_ERROR_DUMP_FW_MONITOR);
 
 	fw_error_dump.trans_ptr = iwl_trans_dump_data(fwrt->trans, dump_mask);
 	file_len = le32_to_cpu(dump_file->file_len);
-- 
2.30.2

