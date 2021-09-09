Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEB2E405073
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244343AbhIIM1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:27:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:58740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349031AbhIIMWt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:22:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00C2861AF0;
        Thu,  9 Sep 2021 11:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188261;
        bh=cp4aSFPOVoAmW7bC4hEc24SYlKqIiehUK6guMD+qXfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ddcDcU/h1TqqkLbwHtIdVpKvZMS+Bo4WKjfGJnCRsEvVx8BIGjMVOBpgRyQqV8gEp
         oE5jYzUxBr4bGr+Zo0+qDyJEJpzNk8TJn2p+QCgL6ZDVGYOCaH52jx280LV7rOvZs6
         IMXCQkBh0UR00hoEnUk49SJObHHJiyrHOolz/eVqzRoCemrEb54MdTVTN3jtAWWZD4
         g7Y+R1NfVGr4prA6CBXwPaClgMnUpCuXAMdt7CMCLa9AmMYfFeDV6PNKjgtsirWRqo
         qtS5fYbGY1Dr+9Y/1FAp7VGRxdKjPfLB0+aGkwfVzZyCHOd9WvCrHgzj/0Wkouqcu/
         Q/bHomtcjEKrg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 207/219] iwlwifi: fw: correctly limit to monitor dump
Date:   Thu,  9 Sep 2021 07:46:23 -0400
Message-Id: <20210909114635.143983-207-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
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
index cc4e18ca9566..a27849419d29 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -2314,7 +2314,7 @@ static void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt,
 		return;
 
 	if (dump_data->monitor_only)
-		dump_mask &= IWL_FW_ERROR_DUMP_FW_MONITOR;
+		dump_mask &= BIT(IWL_FW_ERROR_DUMP_FW_MONITOR);
 
 	fw_error_dump.trans_ptr = iwl_trans_dump_data(fwrt->trans, dump_mask);
 	file_len = le32_to_cpu(dump_file->file_len);
-- 
2.30.2

