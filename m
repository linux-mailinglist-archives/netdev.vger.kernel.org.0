Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 064C038EB33
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 17:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233127AbhEXPBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 11:01:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:34052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233729AbhEXO6T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 10:58:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C76E1613B0;
        Mon, 24 May 2021 14:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867767;
        bh=V+Ak+bq9QckCL6JpOKpd2weyQMBPabw2Ue2S46kTYZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cwbs6H/HiYwv1/eEcOU7dE6bAUZjsuEWg6L8x9fYrLRxZ358G5nQtsbwJYpUNTGGm
         PX8uHrmzpbCVvU1eUi1jq0kZU37hADokkTLF0ygoP8rFi64VuGUXZ1uur+SUH2KkZR
         hnz+EAv875bqkKmcap3gePW8OdAQjQwT2I8DhvVxY+doTwg+KgRaco5neI8wpc6mKz
         0KDuGDTq+YjslQKNr4xoM2e9Iy1wojdC1eQkN4FEQu8fC6OrhGyK6PYlMnkFI2F5v0
         oqMC1gZC2nJ8wkD6B0pP1EH1t00//YLuBarW7izAKp+qNcc+S/Z33Iu3mbQJW3kZjJ
         Xz5mPeC6tmJzQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Aditya Pakki <pakki001@umn.edu>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 20/52] Revert "isdn: mISDN: Fix potential NULL pointer dereference of kzalloc"
Date:   Mon, 24 May 2021 10:48:30 -0400
Message-Id: <20210524144903.2498518-20-sashal@kernel.org>
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
index 008a74a1ed44..7a051435c406 100644
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

