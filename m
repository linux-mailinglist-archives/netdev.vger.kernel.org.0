Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E78C868B1A
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 15:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731002AbfGONik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 09:38:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:39052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730966AbfGONii (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 09:38:38 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19BE9212F5;
        Mon, 15 Jul 2019 13:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563197917;
        bh=tAtuICIV1U+7yLjSH6QQHcFpIEFMJc06cGhrtThDr/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rffg+43Sw5IcgIS0wrEbnf9/ju8mnZ0LbEWMVRBkAS09wiupH6I6hM267pfNlcNmX
         ODe60wsODr62xnJeNM6Jx1SCD4TQusSr34NlDYkckD0xp7VvW6CJEYyI2jccSxj9Qz
         pAPfdqKlnm2j2TvQ0Wg5s+oY474bYe40TBq4L9qw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 010/219] wil6210: fix missed MISC mbox interrupt
Date:   Mon, 15 Jul 2019 09:34:42 -0400
Message-Id: <20190715133811.2441-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715133811.2441-1-sashal@kernel.org>
References: <20190715133811.2441-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maya Erez <merez@codeaurora.org>

[ Upstream commit 7441be71ba7e07791fd4fa2b07c932dff14ff4d9 ]

When MISC interrupt is triggered due to HALP bit, in parallel
to mbox events handling by the MISC threaded IRQ, new mbox
interrupt can be missed in the following scenario:
1. MISC ICR is read in the IRQ handler
2. Threaded IRQ is completed and all MISC interrupts are unmasked
3. mbox interrupt is set by FW
4. HALP is masked
The mbox interrupt in step 3 can be missed due to constant high level
of ICM.
Masking all MISC IRQs instead of masking only HALP bit in step 4
will guarantee that ICM will drop to 0 and interrupt will be triggered
once MISC interrupts will be unmasked.

Signed-off-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wil6210/interrupt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index 3f5bd177d55f..e41ba24011d8 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -580,7 +580,7 @@ static irqreturn_t wil6210_irq_misc(int irq, void *cookie)
 			/* no need to handle HALP ICRs until next vote */
 			wil->halp.handle_icr = false;
 			wil_dbg_irq(wil, "irq_misc: HALP IRQ invoked\n");
-			wil6210_mask_halp(wil);
+			wil6210_mask_irq_misc(wil, true);
 			complete(&wil->halp.comp);
 		}
 	}
-- 
2.20.1

