Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA97738E9A4
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 16:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233465AbhEXOuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 10:50:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:54354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233456AbhEXOsm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 10:48:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 591F2613E6;
        Mon, 24 May 2021 14:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867634;
        bh=4q0YyHM0SbsFNSLazTrvIfuRC/KdV8PwvZYubE5KCAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tw9CKcqs+tTmgCCy0jOiMuLQ4q1NqbYORkaM/3U7Q7LMnZoXoRfkwDo154wM5F7d9
         K65OOHHkv0SSuk679yOVPUQsLlb8tpnvaZsjyjkWmuFbb8u09/AU5MdcxnVGtaND/Q
         OCRDs175YQk4/Shs5wV8gpuX3I6hLi9lnj9PNq71eJ3de3LzfHO3LLWcplRdUcNPfo
         NAM/BxBAkVAA87EiGI46WCPp8iGsYv66kwQGdP8CblL27uayUVxAAoOZ4UQwxv3Hra
         taERSOyUudSXMdV9fthxd1JfW26KVTNkwhF6Jqn/H5DTGWaDVw776PZYMmsqoPDGfH
         ocxB7CJxDc9Tg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kangjie Lu <kjlu@umn.edu>, Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 41/63] Revert "brcmfmac: add a check for the status of usb_register"
Date:   Mon, 24 May 2021 10:45:58 -0400
Message-Id: <20210524144620.2497249-41-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144620.2497249-1-sashal@kernel.org>
References: <20210524144620.2497249-1-sashal@kernel.org>
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
index 586f4dfc638b..d2a803fc8ac6 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
@@ -1586,10 +1586,6 @@ void brcmf_usb_exit(void)
 
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

