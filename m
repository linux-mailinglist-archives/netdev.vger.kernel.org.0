Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7D8435738
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 02:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231801AbhJUAZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 20:25:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:43754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232122AbhJUAYg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 20:24:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6217061130;
        Thu, 21 Oct 2021 00:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634775741;
        bh=AUqUU8MogCa7JJnv8XVEV8H16bZRliFWnzCQozhgL3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bOcNQH68uc7zTE4aHixiHVL5EjMYqNKrD84Pog28L2G0WSPgiLmj6xpz/qC0N7Zy7
         PWXC6WbgBFEh15unW3vhIYOmvriB1Mpdo7wJHY8qkZ9hrkF+tKmM+l5bgMEFXQB09l
         6Yz5VfD+NY4W3BPflvY4lCJKbPSYA0EpjqHstVvaj1wR7TTS2PdkbuCZwDtaEISQLv
         H4Y+mV6h+k/KJWr0SYNK+Y8Rk7lEKuXKAA2deQaugP37l0NltV8DLm3hc3Zxy0RL1y
         Tn1GOTWy4zYalD1ef+uVGD4Lez5YtSQnMRwQ0PlOGdofvFjYZTT4xueY+/+tGuWnim
         Z2SsxuFfviuCQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheyu Ma <zheyuma97@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, isdn@linux-pingi.de,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 08/14] isdn: mISDN: Fix sleeping function called from invalid context
Date:   Wed, 20 Oct 2021 20:21:49 -0400
Message-Id: <20211021002155.1129292-8-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211021002155.1129292-1-sashal@kernel.org>
References: <20211021002155.1129292-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zheyu Ma <zheyuma97@gmail.com>

[ Upstream commit 6510e80a0b81b5d814e3aea6297ba42f5e76f73c ]

The driver can call card->isac.release() function from an atomic
context.

Fix this by calling this function after releasing the lock.

The following log reveals it:

[   44.168226 ] BUG: sleeping function called from invalid context at kernel/workqueue.c:3018
[   44.168941 ] in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 5475, name: modprobe
[   44.169574 ] INFO: lockdep is turned off.
[   44.169899 ] irq event stamp: 0
[   44.170160 ] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
[   44.170627 ] hardirqs last disabled at (0): [<ffffffff814209ed>] copy_process+0x132d/0x3e00
[   44.171240 ] softirqs last  enabled at (0): [<ffffffff81420a1a>] copy_process+0x135a/0x3e00
[   44.171852 ] softirqs last disabled at (0): [<0000000000000000>] 0x0
[   44.172318 ] Preemption disabled at:
[   44.172320 ] [<ffffffffa009b0a9>] nj_release+0x69/0x500 [netjet]
[   44.174441 ] Call Trace:
[   44.174630 ]  dump_stack_lvl+0xa8/0xd1
[   44.174912 ]  dump_stack+0x15/0x17
[   44.175166 ]  ___might_sleep+0x3a2/0x510
[   44.175459 ]  ? nj_release+0x69/0x500 [netjet]
[   44.175791 ]  __might_sleep+0x82/0xe0
[   44.176063 ]  ? start_flush_work+0x20/0x7b0
[   44.176375 ]  start_flush_work+0x33/0x7b0
[   44.176672 ]  ? trace_irq_enable_rcuidle+0x85/0x170
[   44.177034 ]  ? kasan_quarantine_put+0xaa/0x1f0
[   44.177372 ]  ? kasan_quarantine_put+0xaa/0x1f0
[   44.177711 ]  __flush_work+0x11a/0x1a0
[   44.177991 ]  ? flush_work+0x20/0x20
[   44.178257 ]  ? lock_release+0x13c/0x8f0
[   44.178550 ]  ? __kasan_check_write+0x14/0x20
[   44.178872 ]  ? do_raw_spin_lock+0x148/0x360
[   44.179187 ]  ? read_lock_is_recursive+0x20/0x20
[   44.179530 ]  ? __kasan_check_read+0x11/0x20
[   44.179846 ]  ? do_raw_spin_unlock+0x55/0x900
[   44.180168 ]  ? ____kasan_slab_free+0x116/0x140
[   44.180505 ]  ? _raw_spin_unlock_irqrestore+0x41/0x60
[   44.180878 ]  ? skb_queue_purge+0x1a3/0x1c0
[   44.181189 ]  ? kfree+0x13e/0x290
[   44.181438 ]  flush_work+0x17/0x20
[   44.181695 ]  mISDN_freedchannel+0xe8/0x100
[   44.182006 ]  isac_release+0x210/0x260 [mISDNipac]
[   44.182366 ]  nj_release+0xf6/0x500 [netjet]
[   44.182685 ]  nj_remove+0x48/0x70 [netjet]
[   44.182989 ]  pci_device_remove+0xa9/0x250

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/hardware/mISDN/netjet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/isdn/hardware/mISDN/netjet.c b/drivers/isdn/hardware/mISDN/netjet.c
index 2a1ddd47a096..a52f275f8263 100644
--- a/drivers/isdn/hardware/mISDN/netjet.c
+++ b/drivers/isdn/hardware/mISDN/netjet.c
@@ -949,8 +949,8 @@ nj_release(struct tiger_hw *card)
 		nj_disable_hwirq(card);
 		mode_tiger(&card->bc[0], ISDN_P_NONE);
 		mode_tiger(&card->bc[1], ISDN_P_NONE);
-		card->isac.release(&card->isac);
 		spin_unlock_irqrestore(&card->lock, flags);
+		card->isac.release(&card->isac);
 		release_region(card->base, card->base_s);
 		card->base_s = 0;
 	}
-- 
2.33.0

