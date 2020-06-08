Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A88C61F2217
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 01:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbgFHXGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 19:06:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:48960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726746AbgFHXGL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:06:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0076520774;
        Mon,  8 Jun 2020 23:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657570;
        bh=PGlP+JP7FvYzxdcy4SX9/FZl2RROoPdsSLINcj/iE2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UCWSXN3TdKUS3TAvBj9b4DTpRFhfWFUyMUA+BaF7WWO3aSDvoaX2L8FA4m2J9rNhI
         OoF+hkDfrJicKBX3kfOBWT8ayUgP1j1k/epyxff9hPc4QvCXfTH0h31MEbTZ7xpsEN
         yPU5eUgWx5ZuQ86f06+qj0/D42YKnUngRwFM1Ow8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maharaja Kennadyrajan <mkenna@codeaurora.org>,
        Govindaraj Saminathan <gsamin@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 002/274] ath10k: Fix the race condition in firmware dump work queue
Date:   Mon,  8 Jun 2020 19:01:35 -0400
Message-Id: <20200608230607.3361041-2-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maharaja Kennadyrajan <mkenna@codeaurora.org>

[ Upstream commit 3d1c60460fb2823a19ead9e6ec8f184dd7271aa7 ]

There is a race condition, when the user writes 'hw-restart' and
'hard' in the simulate_fw_crash debugfs file without any delay.
In the above scenario, the firmware dump work queue(scheduled by
'hard') should be handled gracefully, while the target is in the
'hw-restart'.

Tested HW: QCA9984
Tested FW: 10.4-3.9.0.2-00044

Co-developed-by: Govindaraj Saminathan <gsamin@codeaurora.org>
Signed-off-by: Govindaraj Saminathan <gsamin@codeaurora.org>
Signed-off-by: Maharaja Kennadyrajan <mkenna@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1585213077-28439-1-git-send-email-mkenna@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index ded7a220a4aa..cd1c5d60261f 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2074,6 +2074,7 @@ static void ath10k_pci_hif_stop(struct ath10k *ar)
 	ath10k_pci_irq_sync(ar);
 	napi_synchronize(&ar->napi);
 	napi_disable(&ar->napi);
+	cancel_work_sync(&ar_pci->dump_work);
 
 	/* Most likely the device has HTT Rx ring configured. The only way to
 	 * prevent the device from accessing (and possible corrupting) host
-- 
2.25.1

