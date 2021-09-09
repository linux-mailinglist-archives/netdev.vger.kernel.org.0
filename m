Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4887E405537
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 15:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351256AbhIINI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 09:08:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:53486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357891AbhIINFS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 09:05:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59731632A5;
        Thu,  9 Sep 2021 12:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188811;
        bh=T/rhwYZkhyW9upUip2c7nRlGEMpA7f+b+5qETvMIk5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fgfGUzbDy6ZoCImts90pr4ipW589QZoptYawgxqAqiXwIuccUNkvi2fAEDJXsYq1x
         LxCk0Xppn2MNL9sxRBtYddDZbljlBGVGLRRDAg/Vrg7Mr2RGGWBgChUatNyLLY4wHY
         gV3IlCjPM8Fd4qSG0UfCnvZfkBfLXpr1YvUjQc1i3m4OxznGLFcQlctxqEmI4HzaRO
         YNqtKvhJy8PY+U+e+GeGotMRoESzMEALmTPM3sIPLo6s63S54T1tCjTCBfj7Xtb+Gp
         2W72elk4vsvdscqPSRczjeWY28XIUHXPue/De0Vj8LcUFWevvSwNMGqbIaF4o97ubo
         413yUM0iapnJA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zekun Shen <bruceshenzk@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 56/59] ath9k: fix OOB read ar9300_eeprom_restore_internal
Date:   Thu,  9 Sep 2021 07:58:57 -0400
Message-Id: <20210909115900.149795-56-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115900.149795-1-sashal@kernel.org>
References: <20210909115900.149795-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zekun Shen <bruceshenzk@gmail.com>

[ Upstream commit 23151b9ae79e3bc4f6a0c4cd3a7f355f68dad128 ]

Bad header can have large length field which can cause OOB.
cptr is the last bytes for read, and the eeprom is parsed
from high to low address. The OOB, triggered by the condition
length > cptr could cause memory error with a read on
negative index.

There are some sanity check around length, but it is not
compared with cptr (the remaining bytes). Here, the
corrupted/bad EEPROM can cause panic.

I was able to reproduce the crash, but I cannot find the
log and the reproducer now. After I applied the patch, the
bug is no longer reproducible.

Signed-off-by: Zekun Shen <bruceshenzk@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/YM3xKsQJ0Hw2hjrc@Zekuns-MBP-16.fios-router.home
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 76385834a7de..694a58b1e995 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3346,7 +3346,8 @@ static int ar9300_eeprom_restore_internal(struct ath_hw *ah,
 			"Found block at %x: code=%d ref=%d length=%d major=%d minor=%d\n",
 			cptr, code, reference, length, major, minor);
 		if ((!AR_SREV_9485(ah) && length >= 1024) ||
-		    (AR_SREV_9485(ah) && length > EEPROM_DATA_LEN_9485)) {
+		    (AR_SREV_9485(ah) && length > EEPROM_DATA_LEN_9485) ||
+		    (length > cptr)) {
 			ath_dbg(common, EEPROM, "Skipping bad header\n");
 			cptr -= COMP_HDR_LEN;
 			continue;
-- 
2.30.2

