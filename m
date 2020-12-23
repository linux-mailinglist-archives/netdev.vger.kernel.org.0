Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0712E133F
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 03:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730417AbgLWCZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:25:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:52102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730399AbgLWCZJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:25:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BADFF22D73;
        Wed, 23 Dec 2020 02:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690293;
        bh=CkCr7Ne8EwKLQLtRVGEK4vxK5IljeBMhqVXo6PZ+UQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j12qdShL8uHxkMolyIEXNVGrY6yqqy8g7lL2fq3u8SVmRn6M64z03kiTbNhr21ybq
         orZmGf3DY2A1DVaO6m7UfYp57zYNIr9y/mLxeK4IFW8+/r3cwS5j857U5rrWR0EDrW
         swcJ0BSHkgMJtn7xoHt/rZy1M7bWNscgQquXhkbAIiMGjFN98csGkvEceFPNeyCBS3
         npDzrdX3Fh0IGMa9FQcfBp9zHNQjldlT6UNHWD/hgh6P6oBd+iC8mJQBcg/6xf+oye
         9qLQkHzSVlOVuMAHCVTgUGZEGaoWJGCBmgd4B4mIvv9aTju8B5F3C5Mt6h3HpRem4P
         4OU1/99lUBTpA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Safonov <dima@arista.com>,
        Yuji Nakao <contact@yujinakao.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 30/48] brcmsmac: ampdu: Check BA window size before checking block ack
Date:   Tue, 22 Dec 2020 21:23:58 -0500
Message-Id: <20201223022417.2794032-30-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022417.2794032-1-sashal@kernel.org>
References: <20201223022417.2794032-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Safonov <dima@arista.com>

[ Upstream commit 01c195de620bb6c3ecda0dbf295fe685d8232e10 ]

bindex can be out of BA window (64):
  tid 0 seq 2983, start_seq 2915, bindex 68, index 39
  tid 0 seq 2984, start_seq 2915, bindex 69, index 40
  tid 0 seq 2985, start_seq 2915, bindex 70, index 41
  tid 0 seq 2986, start_seq 2915, bindex 71, index 42
  tid 0 seq 2879, start_seq 2915, bindex 4060, index 63
  tid 0 seq 2854, start_seq 2915, bindex 4035, index 38
  tid 0 seq 2795, start_seq 2915, bindex 3976, index 43
  tid 0 seq 2989, start_seq 2924, bindex 65, index 45
  tid 0 seq 2992, start_seq 2924, bindex 68, index 48
  tid 0 seq 2993, start_seq 2924, bindex 69, index 49
  tid 0 seq 2994, start_seq 2924, bindex 70, index 50
  tid 0 seq 2997, start_seq 2924, bindex 73, index 53
  tid 0 seq 2795, start_seq 2941, bindex 3950, index 43
  tid 0 seq 2921, start_seq 2941, bindex 4076, index 41
  tid 0 seq 2929, start_seq 2941, bindex 4084, index 49
  tid 0 seq 3011, start_seq 2946, bindex 65, index 3
  tid 0 seq 3012, start_seq 2946, bindex 66, index 4
  tid 0 seq 3013, start_seq 2946, bindex 67, index 5

In result isset() will try to dereference something on the stack,
causing panics:
  BUG: unable to handle page fault for address: ffffa742800ed01f
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 6a4e9067 P4D 6a4e9067 PUD 6a4ec067 PMD 6a4ed067 PTE 0
  Oops: 0000 [#1] PREEMPT SMP PTI
  CPU: 1 PID: 0 Comm: swapper/1 Kdump: loaded Not tainted 5.8.5-arch1-1-kdump #1
  Hardware name: Apple Inc. MacBookAir3,1/Mac-942452F5819B1C1B, BIOS    MBA31.88Z.0061.B07.1201241641 01/24/12
  RIP: 0010:brcms_c_ampdu_dotxstatus+0x343/0x9f0 [brcmsmac]
  Code: 54 24 20 66 81 e2 ff 0f 41 83 e4 07 89 d1 0f b7 d2 66 c1 e9 03 0f b7 c9 4c 8d 5c 0c 48 49 8b 4d 10 48 8b 79 68 41 57 44 89 e1 <41> 0f b6 33 41 d3 e0 48 c7 c1 38 e0 ea c0 48 83 c7 10 44 21 c6 4c
  RSP: 0018:ffffa742800ecdd0 EFLAGS: 00010207
  RAX: 0000000000000019 RBX: 000000000000000b RCX: 0000000000000006
  RDX: 0000000000000ffe RSI: 0000000000000004 RDI: ffff8fc6ad776800
  RBP: ffff8fc6855acb00 R08: 0000000000000001 R09: 00000000000005d9
  R10: 00000000fffffffe R11: ffffa742800ed01f R12: 0000000000000006
  R13: ffff8fc68d75a000 R14: 00000000000005db R15: 0000000000000019
  FS:  0000000000000000(0000) GS:ffff8fc6aad00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: ffffa742800ed01f CR3: 000000002480a000 CR4: 00000000000406e0
  Call Trace:
   <IRQ>
   brcms_c_dpc+0xb46/0x1020 [brcmsmac]
   ? wlc_intstatus+0xc8/0x180 [brcmsmac]
   ? __raise_softirq_irqoff+0x1a/0x80
   brcms_dpc+0x37/0xd0 [brcmsmac]
   tasklet_action_common.constprop.0+0x51/0xb0
   __do_softirq+0xff/0x340
   ? handle_level_irq+0x1a0/0x1a0
   asm_call_on_stack+0x12/0x20
   </IRQ>
   do_softirq_own_stack+0x5f/0x80
   irq_exit_rcu+0xcb/0x120
   common_interrupt+0xd1/0x200
   asm_common_interrupt+0x1e/0x40
  RIP: 0010:cpuidle_enter_state+0xb3/0x420

Check if the block is within BA window and only then check block's
status. Otherwise as Behan wrote: "When I came back to Dublin I
was courtmartialed in my absence and sentenced to death in my absence,
so I said they could shoot me in my absence."

Also reported:
https://bbs.archlinux.org/viewtopic.php?id=258428
https://lore.kernel.org/linux-wireless/87tuwgi92n.fsf@yujinakao.com/

Reported-by: Yuji Nakao <contact@yujinakao.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20201116030635.645811-1-dima@arista.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/broadcom/brcm80211/brcmsmac/ampdu.c  | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/ampdu.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/ampdu.c
index fa391e4eb0989..44f65b8bff9e0 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/ampdu.c
@@ -953,14 +953,19 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 		index = TX_SEQ_TO_INDEX(seq);
 		ack_recd = false;
 		if (ba_recd) {
+			int block_acked;
+
 			bindex = MODSUB_POW2(seq, start_seq, SEQNUM_MAX);
+			if (bindex < AMPDU_TX_BA_MAX_WSIZE)
+				block_acked = isset(bitmap, bindex);
+			else
+				block_acked = 0;
 			brcms_dbg_ht(wlc->hw->d11core,
 				     "tid %d seq %d, start_seq %d, bindex %d set %d, index %d\n",
 				     tid, seq, start_seq, bindex,
-				     isset(bitmap, bindex), index);
+				     block_acked, index);
 			/* if acked then clear bit and free packet */
-			if ((bindex < AMPDU_TX_BA_MAX_WSIZE)
-			    && isset(bitmap, bindex)) {
+			if (block_acked) {
 				ini->txretry[index] = 0;
 
 				/*
-- 
2.27.0

