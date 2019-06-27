Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 837335780B
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 02:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728500AbfF0AhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 20:37:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:41618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728473AbfF0AhC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 20:37:02 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FC53217F4;
        Thu, 27 Jun 2019 00:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595821;
        bh=TLsgSGtgKQM0ER3F095t8sBGqT0ztUzj8ovd5GelsWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XEPhjQNX34jInVPSeYbB9DNDvCBLvTRoFmaL+d15Y3rpYd63hmChS9UEHA3LTcuRJ
         +lXy3Z4o/uafKvqNUyFHWMjjDttGZJMB9ZN8+XNgdoTP253EVtqAzY70vOEE+W//g6
         cLAKFGzIEYBzZ7UFYzkKPXGmdJClL1nz/5xxS6iM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 15/60] iwlwifi: Fix double-free problems in iwl_req_fw_callback()
Date:   Wed, 26 Jun 2019 20:35:30 -0400
Message-Id: <20190627003616.20767-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003616.20767-1-sashal@kernel.org>
References: <20190627003616.20767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit a8627176b0de7ba3f4524f641ddff4abf23ae4e4 ]

In the error handling code of iwl_req_fw_callback(), iwl_dealloc_ucode()
is called to free data. In iwl_drv_stop(), iwl_dealloc_ucode() is called
again, which can cause double-free problems.

To fix this bug, the call to iwl_dealloc_ucode() in
iwl_req_fw_callback() is deleted.

This bug is found by a runtime fuzzing tool named FIZZER written by us.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index c0631255aee7..db6628d390a2 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1547,7 +1547,6 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	goto free;
 
  out_free_fw:
-	iwl_dealloc_ucode(drv);
 	release_firmware(ucode_raw);
  out_unbind:
 	complete(&drv->request_firmware_complete);
-- 
2.20.1

