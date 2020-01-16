Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7FF13ED48
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393547AbgAPRlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:41:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:58970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405649AbgAPRlW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:41:22 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66E6C24695;
        Thu, 16 Jan 2020 17:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196481;
        bh=wMgQC9Nxeaz0aIRTUtqD2m4QS3kZMLRfFhrPVF3c2AM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tct32E98bDL0uUIjnDyhM1LSIyUzcaoTrbAX7KVWaW2C1Th47quMA2bK2N403Kxgw
         mhlNhJ4ti03zvioLoCtrboC1Muj1EN+5gsazk61IuNY1Pm/0hx7/CaD3pzKiDfDtTz
         Z3ulfiv7Ium5VfaRrrxIBM0au1S3QQnu6T1GuVEo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 228/251] cw1200: Fix a signedness bug in cw1200_load_firmware()
Date:   Thu, 16 Jan 2020 12:36:17 -0500
Message-Id: <20200116173641.22137-188-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116173641.22137-1-sashal@kernel.org>
References: <20200116173641.22137-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 4a50d454502f1401171ff061a5424583f91266db ]

The "priv->hw_type" is an enum and in this context GCC will treat it
as an unsigned int so the error handling will never trigger.

Fixes: a910e4a94f69 ("cw1200: add driver for the ST-E CW1100 & CW1200 WLAN chipsets")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/st/cw1200/fwio.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/st/cw1200/fwio.c b/drivers/net/wireless/st/cw1200/fwio.c
index 30e7646d04af..16be7fa82a23 100644
--- a/drivers/net/wireless/st/cw1200/fwio.c
+++ b/drivers/net/wireless/st/cw1200/fwio.c
@@ -323,12 +323,12 @@ int cw1200_load_firmware(struct cw1200_common *priv)
 		goto out;
 	}
 
-	priv->hw_type = cw1200_get_hw_type(val32, &major_revision);
-	if (priv->hw_type < 0) {
+	ret = cw1200_get_hw_type(val32, &major_revision);
+	if (ret < 0) {
 		pr_err("Can't deduce hardware type.\n");
-		ret = -ENOTSUPP;
 		goto out;
 	}
+	priv->hw_type = ret;
 
 	/* Set DPLL Reg value, and read back to confirm writes work */
 	ret = cw1200_reg_write_32(priv, ST90TDS_TSET_GEN_R_W_REG_ID,
-- 
2.20.1

