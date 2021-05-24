Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2177938EB5F
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 17:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234417AbhEXPCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 11:02:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:37276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234508AbhEXO75 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 10:59:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D5F3613FE;
        Mon, 24 May 2021 14:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867790;
        bh=g6d2Jt9q55l7Ht6mRDOobLRlNSvQALDKJx4ukrRtYhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BbU2jto9ZnyNa4wnpZ8hFbxwIfqqeA1Kdil7gDY9F2Ugc6Xdo38YrVgFkdwPHlYoE
         YXKyMwya6nfl7fHTWClyvlsiZOXhm5D/ZboFjax8R7n/NHsiCAQk+NBOyD1wpYekmD
         15drb0vL7d7U+dGP10fxpKKvSmRleFm89q7pCdJAdzRaWG6q/c1PA4/4b6wUTRboLA
         juIHyvUMEjAs6nJMj1IzuyHwquZDxeBwiCYtMKHxB7Xy8s+VP6nOQdt1r8R1nTP3QW
         NP+X++8CReIofw3n9YRDUWqNjhxPvVKL/U4BlVcdGqWuGdtgJVEckwPtzo65oe9pw6
         7EzMhKY/+PFiQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kangjie Lu <kjlu@umn.edu>, Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 38/52] Revert "brcmfmac: add a check for the status of usb_register"
Date:   Mon, 24 May 2021 10:48:48 -0400
Message-Id: <20210524144903.2498518-38-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144903.2498518-1-sashal@kernel.org>
References: <20210524144903.2498518-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 30a350947692f794796f563029d29764497f2887 ]

This reverts commit 42daad3343be4a4e1ee03e30a5f5cc731dadfef5.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, this commit was found to be incorrect for the reasons
below, so it must be reverted.  It will be fixed up "correctly" in a
later kernel change.

The original commit here did nothing to actually help if usb_register()
failed, so it gives a "false sense of security" when there is none.  The
correct solution is to correctly unwind from this error.

Cc: Kangjie Lu <kjlu@umn.edu>
Cc: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210503115736.2104747-69-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
index 575ed19e9195..6f41d28930e4 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
@@ -1560,10 +1560,6 @@ void brcmf_usb_exit(void)
 
 void brcmf_usb_register(void)
 {
-	int ret;
-
 	brcmf_dbg(USB, "Enter\n");
-	ret = usb_register(&brcmf_usbdrvr);
-	if (ret)
-		brcmf_err("usb_register failed %d\n", ret);
+	usb_register(&brcmf_usbdrvr);
 }
-- 
2.30.2

