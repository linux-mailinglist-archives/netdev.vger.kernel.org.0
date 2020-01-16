Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC7F113E6F3
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 18:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391655AbgAPRWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:22:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:58544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390748AbgAPRN1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:13:27 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 733D9246AF;
        Thu, 16 Jan 2020 17:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194807;
        bh=wMgQC9Nxeaz0aIRTUtqD2m4QS3kZMLRfFhrPVF3c2AM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YQcR5Ak2cnhmS1224Qr/de5NIiG10eoZTQtt1MKfh5FARRvH/Ue8KKuY2u6MEW7lp
         snnei4aqsbA3XPy7coSR/19ZGOxFp5WDvYbpfnYSibAvZvG7gzqpr/6A3ObG2/leez
         CpFyQyhtxfF8/uGMsldt3NWnGhn7gVXDNjFwii80=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 616/671] cw1200: Fix a signedness bug in cw1200_load_firmware()
Date:   Thu, 16 Jan 2020 12:04:14 -0500
Message-Id: <20200116170509.12787-353-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
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

