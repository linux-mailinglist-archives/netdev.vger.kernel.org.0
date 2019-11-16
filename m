Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC4AAFF24C
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 17:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732021AbfKPQSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 11:18:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:52836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729407AbfKPPqa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 10:46:30 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F01E20830;
        Sat, 16 Nov 2019 15:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919189;
        bh=K2mUBlq0bWqG4T1h8dGfD3rHxWPBe1z4CoWD4grBUYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y6hwIvRujf8ID2ed8hMruWfET/MhCQbdov+qwxZKqC5TB+vsLPJyuhXXHQ42AWUYD
         Cf9yIcMjHI/Y4nBVuMGiOij9MjMTmhWjdoRqo6C02ZjEBh2qtNMhDnrkTpesQzYbH8
         MnCcFY24x41MzIbcHqAL+ivFF8XgLCLb+lF1c4D4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 198/237] wil6210: fix RGF_CAF_ICR address for Talyn-MB
Date:   Sat, 16 Nov 2019 10:40:33 -0500
Message-Id: <20191116154113.7417-198-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maya Erez <merez@codeaurora.org>

[ Upstream commit 7c69709f8ed27197b16aa1c3f9b0744402b2fa02 ]

RGF_CAF_ICR register location has changed in Talyn-MB.
Add RGF_CAF_ICR_TALYN_MB to support the new address.

Signed-off-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wil6210/main.c    | 11 +++++++++--
 drivers/net/wireless/ath/wil6210/wil6210.h |  1 +
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index a0fe8cbad104f..aeed45f127ad6 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -1396,8 +1396,15 @@ static void wil_pre_fw_config(struct wil6210_priv *wil)
 	wil6210_clear_irq(wil);
 	/* CAF_ICR - clear and mask */
 	/* it is W1C, clear by writing back same value */
-	wil_s(wil, RGF_CAF_ICR + offsetof(struct RGF_ICR, ICR), 0);
-	wil_w(wil, RGF_CAF_ICR + offsetof(struct RGF_ICR, IMV), ~0);
+	if (wil->hw_version < HW_VER_TALYN_MB) {
+		wil_s(wil, RGF_CAF_ICR + offsetof(struct RGF_ICR, ICR), 0);
+		wil_w(wil, RGF_CAF_ICR + offsetof(struct RGF_ICR, IMV), ~0);
+	} else {
+		wil_s(wil,
+		      RGF_CAF_ICR_TALYN_MB + offsetof(struct RGF_ICR, ICR), 0);
+		wil_w(wil, RGF_CAF_ICR_TALYN_MB +
+		      offsetof(struct RGF_ICR, IMV), ~0);
+	}
 	/* clear PAL_UNIT_ICR (potential D0->D3 leftover)
 	 * In Talyn-MB host cannot access this register due to
 	 * access control, hence PAL_UNIT_ICR is cleared by the FW
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 17c294b1ead13..75fe1a3b70466 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -319,6 +319,7 @@ struct RGF_ICR {
 /* MAC timer, usec, for packet lifetime */
 #define RGF_MAC_MTRL_COUNTER_0		(0x886aa8)
 
+#define RGF_CAF_ICR_TALYN_MB		(0x8893d4) /* struct RGF_ICR */
 #define RGF_CAF_ICR			(0x88946c) /* struct RGF_ICR */
 #define RGF_CAF_OSC_CONTROL		(0x88afa4)
 	#define BIT_CAF_OSC_XTAL_EN		BIT(0)
-- 
2.20.1

