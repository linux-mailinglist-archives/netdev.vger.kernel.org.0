Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A08AB38EA89
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 16:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233904AbhEXO4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 10:56:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:34044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234009AbhEXOyL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 10:54:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1ED0613E6;
        Mon, 24 May 2021 14:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867715;
        bh=4q0YyHM0SbsFNSLazTrvIfuRC/KdV8PwvZYubE5KCAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PcC+EfC7fN9YJaSuKsLFw2lgMrvisxUjiEnTDCgTmuC2+V6xegqsscnatNQTpKW1l
         sGVMazN+JpLAStM5tlJ+/KGeW9B40r1lvVXHZcUYM9ik3xB265Oj7olu29eFroe+T/
         6fs5k2YjtV4sS1Ewxh/q/hNLH/aF3dTKSphe8FOTmVsKXdXEVG0RAp+CD6TncnHETO
         bQ5iW1DhFn9KuTFtAX0SfAufXq232nviOE0RtO8GA4Sc9vNFNPWNTbeZZ1NSxEnnx9
         MJEGqIkBI4jCioU4QG59MW1PeX47JG1EZn3kCjWIFwiIZdMDhaRSDmxZcuEjEqLpRd
         f7ark+0oaGnXw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kangjie Lu <kjlu@umn.edu>, Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 41/62] Revert "brcmfmac: add a check for the status of usb_register"
Date:   Mon, 24 May 2021 10:47:22 -0400
Message-Id: <20210524144744.2497894-41-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144744.2497894-1-sashal@kernel.org>
References: <20210524144744.2497894-1-sashal@kernel.org>
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

