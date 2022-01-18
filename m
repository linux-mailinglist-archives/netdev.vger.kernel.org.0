Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A92A44919C2
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344603AbiARCzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:55:55 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35086 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345408AbiARCne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:43:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84478612F3;
        Tue, 18 Jan 2022 02:43:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9225AC36AF5;
        Tue, 18 Jan 2022 02:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473812;
        bh=Gvxsjpd5cfIoDoJ7uJZx2+ip3PN++DHEoQrmqb82lSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g8GxOkUl07+YEO1MEZD3XwSXHNlF4MVBn9sRBjnNgQGsqRCnCvSm9KC+Z4/Zz3iw+
         GojcH7MWKA4vzagVWiPETWuXjruaGYQK/bt2GHJLr8ioS0een4ovJvuODICyV7HhQK
         rDD7hzBEFAazesZXps/hwbDIXOs98LoPz/JSrralTBvuu5H/awU5cjFkvPeZ1tAFzo
         56BPYIGuT/8M7q3xe3O4AVTk9Sh2LfeGLwXMtMTMKD27DliQhOGflSf8KdJKonU76L
         XJxRufhmrDfXCzGwhtcTFUlKSCu2x0wfDjtegMtMHazWg0E2vVleaDr/ofQaZtMhsY
         72SHt4s3HiFJA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, johannes.berg@intel.com,
        mordechay.goodstein@intel.com, emmanuel.grumbach@intel.com,
        michael.golant@intel.com, ilan.peer@intel.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 083/116] iwlwifi: pcie: make sure prph_info is set when treating wakeup IRQ
Date:   Mon, 17 Jan 2022 21:39:34 -0500
Message-Id: <20220118024007.1950576-83-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024007.1950576-1-sashal@kernel.org>
References: <20220118024007.1950576-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

[ Upstream commit 459fc0f2c6b0f6e280bfa0f230c100c9dfe3a199 ]

In some rare cases when the HW is in a bad state, we may get this
interrupt when prph_info is not set yet.  Then we will try to
dereference it to check the sleep_notif element, which will cause an
oops.

Fix that by ignoring the interrupt if prph_info is not set yet.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20211219132536.0537aa562313.I183bb336345b9b3da196ba9e596a6f189fbcbd09@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 2c13fa8f28200..6aedf5762571d 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -2260,7 +2260,12 @@ irqreturn_t iwl_pcie_irq_msix_handler(int irq, void *dev_id)
 		}
 	}
 
-	if (inta_hw & MSIX_HW_INT_CAUSES_REG_WAKEUP) {
+	/*
+	 * In some rare cases when the HW is in a bad state, we may
+	 * get this interrupt too early, when prph_info is still NULL.
+	 * So make sure that it's not NULL to prevent crashing.
+	 */
+	if (inta_hw & MSIX_HW_INT_CAUSES_REG_WAKEUP && trans_pcie->prph_info) {
 		u32 sleep_notif =
 			le32_to_cpu(trans_pcie->prph_info->sleep_notif);
 		if (sleep_notif == IWL_D3_SLEEP_STATUS_SUSPEND ||
-- 
2.34.1

