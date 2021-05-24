Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FED538EA78
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 16:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233158AbhEXOzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 10:55:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:54806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233708AbhEXOwU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 10:52:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A878061418;
        Mon, 24 May 2021 14:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867692;
        bh=cPwcKQnQxS1/1/Xv3aws8qFtnBrWEAHlB+cKwVlNVms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A/tenNMbpnp3Uc/+ShXa4gyg7pA//LCf0lsqgl/jBlnuzHMC9cxNnkDgreMEFSS1B
         nEYcUncSbZAMAlvU2slxGyYtRm1jxMc061zjFfOLdz15xhFse74fn2KMWHiVP/R7K6
         Xij+QuG2aD36ZDPeBuxHeIZPjpljuviaxRbp/Z8RQzzTy80IpsHdazpq5gsbrZyVzS
         BMkmgC+EmWBADiPIrUp12UqUD/MVBrTqLIAoWi8ZQs0mC0EFfxEPNRAYoMFDOpwYxs
         fkN464GioNqA2f4ArBMwhA/gm1N7vJdYJtAIVowOJ29wcsJijZf5Ygmtx8DegCfTgL
         mZRWpoZl5U8Cw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Aditya Pakki <pakki001@umn.edu>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 23/62] Revert "isdn: mISDN: Fix potential NULL pointer dereference of kzalloc"
Date:   Mon, 24 May 2021 10:47:04 -0400
Message-Id: <20210524144744.2497894-23-sashal@kernel.org>
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

[ Upstream commit 36a2c87f7ed9e305d05b9a5c044cc6c494771504 ]

This reverts commit 38d22659803a033b1b66cd2624c33570c0dde77d.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, this commit was found to be incorrect for the reasons
below, so it must be reverted.  It will be fixed up "correctly" in a
later kernel change.

While it looks like the original change is correct, it is not, as none
of the setup actually happens, and the error value is not propagated
upwards.

Cc: Aditya Pakki <pakki001@umn.edu>
Cc: David S. Miller <davem@davemloft.net>
Link: https://lore.kernel.org/r/20210503115736.2104747-47-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/hardware/mISDN/hfcsusb.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcsusb.c b/drivers/isdn/hardware/mISDN/hfcsusb.c
index 70061991915a..4bb470d3963d 100644
--- a/drivers/isdn/hardware/mISDN/hfcsusb.c
+++ b/drivers/isdn/hardware/mISDN/hfcsusb.c
@@ -249,9 +249,6 @@ hfcsusb_ph_info(struct hfcsusb *hw)
 	int i;
 
 	phi = kzalloc(struct_size(phi, bch, dch->dev.nrbchan), GFP_ATOMIC);
-	if (!phi)
-		return;
-
 	phi->dch.ch.protocol = hw->protocol;
 	phi->dch.ch.Flags = dch->Flags;
 	phi->dch.state = dch->state;
-- 
2.30.2

