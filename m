Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC543405366
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354837AbhIIMvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:51:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:55852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355104AbhIIMlC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:41:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0B8D61BE5;
        Thu,  9 Sep 2021 11:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188499;
        bh=Uh4gAPJjL7EvxAYvjfESQ3h7Yip6zR0rBwfOQmMswjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nkv91EdXl3abxlWCXMFj8hPfHQR5l3huMSA9VJS0ZmfeGXAbRXDQlXAL01lM1OE0Q
         q2ESc9MBTwdSDejjSKZT1q1T7JaKTZUGKu7RwqwYfQAPo3e3VKDv1v77pntbuqpmHV
         rnfE81UYjXzeyaR5D4Ihgbsocsap38gyOSdjP8+TK6eRhS868fF2aBmDeWL5k0mQLo
         7z5sZTscOUm64ZJJQ2S8cMU1SSbvLd/RxIjpWH7Qx/d014k5WjiqxUtY5YU7mCSIHT
         1MYMfuh2jc4K3u8Y6e++Q+yXXuvkLKgJQUiBqowaVhWu9jU+I1/+3+LL9VZry107Mu
         pUEX7GpUzluZw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zekun Shen <bruceshenzk@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 171/176] ath9k: fix OOB read ar9300_eeprom_restore_internal
Date:   Thu,  9 Sep 2021 07:51:13 -0400
Message-Id: <20210909115118.146181-171-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115118.146181-1-sashal@kernel.org>
References: <20210909115118.146181-1-sashal@kernel.org>
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
index b4885a700296..b0a4ca3559fd 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3351,7 +3351,8 @@ static int ar9300_eeprom_restore_internal(struct ath_hw *ah,
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

