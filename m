Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06DE515E183
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 17:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404916AbgBNQTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 11:19:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:51964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404899AbgBNQTB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 11:19:01 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C08B124681;
        Fri, 14 Feb 2020 16:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697140;
        bh=VfvffU7S8zEGaXj6VmTL+QQL8aRPhylVwpYC1om9tkw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c0t0rzzr/o2iRGC84StZkUABzKFApJT8slc15fGh3FrP8d2uw6V+oFtKp9V1ovfQ5
         ZWTFRLLBYNXzb96GOphsMLW7xPaPdkAdn0tC5k69lUcUARtlE0ke6Zthu3soqHoaUQ
         sHytNvDQqoi8OtMKEA/yv+Q2AYnj8937T7NdTOUQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Phong Tran <tranmanphong@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 081/186] rtlwifi: rtl_pci: Fix -Wcast-function-type
Date:   Fri, 14 Feb 2020 11:15:30 -0500
Message-Id: <20200214161715.18113-81-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161715.18113-1-sashal@kernel.org>
References: <20200214161715.18113-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Phong Tran <tranmanphong@gmail.com>

[ Upstream commit cb775c88da5d48a85d99d95219f637b6fad2e0e9 ]

correct usage prototype of callback in tasklet_init().
Report by https://github.com/KSPP/linux/issues/20

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/pci.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index 457a0f725c8aa..ab74f31558540 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -1091,13 +1091,15 @@ static irqreturn_t _rtl_pci_interrupt(int irq, void *dev_id)
 	return ret;
 }
 
-static void _rtl_pci_irq_tasklet(struct ieee80211_hw *hw)
+static void _rtl_pci_irq_tasklet(unsigned long data)
 {
+	struct ieee80211_hw *hw = (struct ieee80211_hw *)data;
 	_rtl_pci_tx_chk_waitq(hw);
 }
 
-static void _rtl_pci_prepare_bcn_tasklet(struct ieee80211_hw *hw)
+static void _rtl_pci_prepare_bcn_tasklet(unsigned long data)
 {
+	struct ieee80211_hw *hw = (struct ieee80211_hw *)data;
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
@@ -1223,10 +1225,10 @@ static void _rtl_pci_init_struct(struct ieee80211_hw *hw,
 
 	/*task */
 	tasklet_init(&rtlpriv->works.irq_tasklet,
-		     (void (*)(unsigned long))_rtl_pci_irq_tasklet,
+		     _rtl_pci_irq_tasklet,
 		     (unsigned long)hw);
 	tasklet_init(&rtlpriv->works.irq_prepare_bcn_tasklet,
-		     (void (*)(unsigned long))_rtl_pci_prepare_bcn_tasklet,
+		     _rtl_pci_prepare_bcn_tasklet,
 		     (unsigned long)hw);
 	INIT_WORK(&rtlpriv->works.lps_change_work,
 		  rtl_lps_change_work_callback);
-- 
2.20.1

