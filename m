Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C19238E938
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 16:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233348AbhEXOs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 10:48:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:54230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233216AbhEXOsQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 10:48:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8366613C8;
        Mon, 24 May 2021 14:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867605;
        bh=L6/9C92JDBgplMtoVklmzjavKJBt2S6f6PqJFK2r8qA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Og1BuuCKzYzuIi7+ZToxDtRlEYF3TDdSskU9S3r4ARSVyRXgPB0a/q99dU69me/ub
         wWkw1Ha5Kosidb2uxHGqaKdHzjRGnvE8JcHzdkdNDgIVNX3RCkuo3WqNGRJLK0PdoM
         YGjG2cDDiTmiuQP9YbmpsX1C59HaRQt8dtY9tgAoh4VzzcVUZ62zeRvYQp+3s4bI7K
         KvjsxxvJwIbwbaPqG1hJyoRp1RrnC7QC1BBjtaKFtPsMp45p3fX0v2X93ORrhTOiSi
         +Kul9k+GUlXpjZVCy/w3ECQVAoSu6jwIR4EgcqqBbfawq8yMWuTVKegTFtHihXq4G1
         F9fpAnJBxW9fg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kangjie Lu <kjlu@umn.edu>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 19/63] Revert "isdn: mISDNinfineon: fix potential NULL pointer dereference"
Date:   Mon, 24 May 2021 10:45:36 -0400
Message-Id: <20210524144620.2497249-19-sashal@kernel.org>
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

[ Upstream commit abd7bca23bd4247124265152d00ffd4b2b0d6877 ]

This reverts commit d721fe99f6ada070ae8fc0ec3e01ce5a42def0d9.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, this commit was found to be incorrect for the reasons
below, so it must be reverted.  It will be fixed up "correctly" in a
later kernel change.

The original commit was incorrect, it should have never have used
"unlikely()" and if it ever does trigger, resources are left grabbed.

Given there are no users for this code around, I'll just revert this and
leave it "as is" as the odds that ioremap() will ever fail here is
horrendiously low.

Cc: Kangjie Lu <kjlu@umn.edu>
Cc: David S. Miller <davem@davemloft.net>
Link: https://lore.kernel.org/r/20210503115736.2104747-41-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/hardware/mISDN/mISDNinfineon.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/mISDNinfineon.c b/drivers/isdn/hardware/mISDN/mISDNinfineon.c
index a16c7a2a7f3d..fa9c491f9c38 100644
--- a/drivers/isdn/hardware/mISDN/mISDNinfineon.c
+++ b/drivers/isdn/hardware/mISDN/mISDNinfineon.c
@@ -697,11 +697,8 @@ setup_io(struct inf_hw *hw)
 				(ulong)hw->addr.start, (ulong)hw->addr.size);
 			return err;
 		}
-		if (hw->ci->addr_mode == AM_MEMIO) {
+		if (hw->ci->addr_mode == AM_MEMIO)
 			hw->addr.p = ioremap(hw->addr.start, hw->addr.size);
-			if (unlikely(!hw->addr.p))
-				return -ENOMEM;
-		}
 		hw->addr.mode = hw->ci->addr_mode;
 		if (debug & DEBUG_HW)
 			pr_notice("%s: IO addr %lx (%lu bytes) mode%d\n",
-- 
2.30.2

