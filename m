Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC21575BE
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 02:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbfF0AcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 20:32:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:35600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727335AbfF0AcA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 20:32:00 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6ECD2083B;
        Thu, 27 Jun 2019 00:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595519;
        bh=USMiDlK7H+yjx2U+GMP0w+qgryIory1Gzbd3k1HhKrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y3iJBDQ3pcJC03QlJdrw34EM4TsV6sFr5A+CZk+fuUb4BQOEQ5BgUiTKG/EHrPVRq
         sTHOCXO6mvq4OC5rFmmwbOw7gJhkHkvEbSRR84UIh8O2ZRVO+CJzFPTHsmCsyqyy0J
         UaWJMC3PlgV2waH6XmMLA0xkfIUjDCy15iSfou2M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 28/95] iwlwifi: Fix double-free problems in iwl_req_fw_callback()
Date:   Wed, 26 Jun 2019 20:29:13 -0400
Message-Id: <20190627003021.19867-28-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003021.19867-1-sashal@kernel.org>
References: <20190627003021.19867-1-sashal@kernel.org>
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
index 689a65b11cc3..4fd1737d768b 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1579,7 +1579,6 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	goto free;
 
  out_free_fw:
-	iwl_dealloc_ucode(drv);
 	release_firmware(ucode_raw);
  out_unbind:
 	complete(&drv->request_firmware_complete);
-- 
2.20.1

