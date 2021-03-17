Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0284233E351
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 01:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbhCQA4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 20:56:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:32866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229879AbhCQAz5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 20:55:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0990664F9E;
        Wed, 17 Mar 2021 00:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942556;
        bh=mKRV0N9SBwXvBTUfqsAVI/V+AL+T3H/bcTuTKgboNPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EyNGe+L3CQYsYgWqOucuU7tzB99KMJ5zXf3TUiW9wyD+vAiLAqL92p8mjJxuGEpO4
         bDknP6G+nYZbCAJQjQp9eeIhZUhP2NWM7CjMtWqhv/ngbHd/+zlK9RSEb/UHsp4fs/
         NRt3s/vqUWPwP/k9MKuvfFwNoHEOMVXtKCsb9/z3JofUrMM8OAAVbMHREziQovxglk
         QHtjBFnFue5MQKwBy3TT7Caq6VKYQEiNo8dBooG1gdeCas9mjueQZCCieKPuZb1KAB
         fQe5DPRt2X4cXj53sGuvWShd6WSuSII3d0jlJo9N21oBHD+X2KFrnBBddn3dKt92k2
         Xwt8E1K5J/uLQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Braun <michael-dev@fami-braun.de>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 16/61] gianfar: fix jumbo packets+napi+rx overrun crash
Date:   Tue, 16 Mar 2021 20:54:50 -0400
Message-Id: <20210317005536.724046-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005536.724046-1-sashal@kernel.org>
References: <20210317005536.724046-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Braun <michael-dev@fami-braun.de>

[ Upstream commit d8861bab48b6c1fc3cdbcab8ff9d1eaea43afe7f ]

When using jumbo packets and overrunning rx queue with napi enabled,
the following sequence is observed in gfar_add_rx_frag:

   | lstatus                              |       | skb                   |
t  | lstatus,  size, flags                | first | len, data_len, *ptr   |
---+--------------------------------------+-------+-----------------------+
13 | 18002348, 9032, INTERRUPT LAST       | 0     | 9600, 8000,  f554c12e |
12 | 10000640, 1600, INTERRUPT            | 0     | 8000, 6400,  f554c12e |
11 | 10000640, 1600, INTERRUPT            | 0     | 6400, 4800,  f554c12e |
10 | 10000640, 1600, INTERRUPT            | 0     | 4800, 3200,  f554c12e |
09 | 10000640, 1600, INTERRUPT            | 0     | 3200, 1600,  f554c12e |
08 | 14000640, 1600, INTERRUPT FIRST      | 0     | 1600, 0,     f554c12e |
07 | 14000640, 1600, INTERRUPT FIRST      | 1     | 0,    0,     f554c12e |
06 | 1c000080, 128,  INTERRUPT LAST FIRST | 1     | 0,    0,     abf3bd6e |
05 | 18002348, 9032, INTERRUPT LAST       | 0     | 8000, 6400,  c5a57780 |
04 | 10000640, 1600, INTERRUPT            | 0     | 6400, 4800,  c5a57780 |
03 | 10000640, 1600, INTERRUPT            | 0     | 4800, 3200,  c5a57780 |
02 | 10000640, 1600, INTERRUPT            | 0     | 3200, 1600,  c5a57780 |
01 | 10000640, 1600, INTERRUPT            | 0     | 1600, 0,     c5a57780 |
00 | 14000640, 1600, INTERRUPT FIRST      | 1     | 0,    0,     c5a57780 |

So at t=7 a new packets is started but not finished, probably due to rx
overrun - but rx overrun is not indicated in the flags. Instead a new
packets starts at t=8. This results in skb->len to exceed size for the LAST
fragment at t=13 and thus a negative fragment size added to the skb.

This then crashes:

kernel BUG at include/linux/skbuff.h:2277!
Oops: Exception in kernel mode, sig: 5 [#1]
...
NIP [c04689f4] skb_pull+0x2c/0x48
LR [c03f62ac] gfar_clean_rx_ring+0x2e4/0x844
Call Trace:
[ec4bfd38] [c06a84c4] _raw_spin_unlock_irqrestore+0x60/0x7c (unreliable)
[ec4bfda8] [c03f6a44] gfar_poll_rx_sq+0x48/0xe4
[ec4bfdc8] [c048d504] __napi_poll+0x54/0x26c
[ec4bfdf8] [c048d908] net_rx_action+0x138/0x2c0
[ec4bfe68] [c06a8f34] __do_softirq+0x3a4/0x4fc
[ec4bfed8] [c0040150] run_ksoftirqd+0x58/0x70
[ec4bfee8] [c0066ecc] smpboot_thread_fn+0x184/0x1cc
[ec4bff08] [c0062718] kthread+0x140/0x144
[ec4bff38] [c0012350] ret_from_kernel_thread+0x14/0x1c

This patch fixes this by checking for computed LAST fragment size, so a
negative sized fragment is never added.
In order to prevent the newer rx frame from getting corrupted, the FIRST
flag is checked to discard the incomplete older frame.

Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/gianfar.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index d391a45cebb6..4fab2ee5bbf5 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -2391,6 +2391,10 @@ static bool gfar_add_rx_frag(struct gfar_rx_buff *rxb, u32 lstatus,
 		if (lstatus & BD_LFLAG(RXBD_LAST))
 			size -= skb->len;
 
+		WARN(size < 0, "gianfar: rx fragment size underflow");
+		if (size < 0)
+			return false;
+
 		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, page,
 				rxb->page_offset + RXBUF_ALIGNMENT,
 				size, GFAR_RXB_TRUESIZE);
@@ -2553,6 +2557,17 @@ static int gfar_clean_rx_ring(struct gfar_priv_rx_q *rx_queue,
 		if (lstatus & BD_LFLAG(RXBD_EMPTY))
 			break;
 
+		/* lost RXBD_LAST descriptor due to overrun */
+		if (skb &&
+		    (lstatus & BD_LFLAG(RXBD_FIRST))) {
+			/* discard faulty buffer */
+			dev_kfree_skb(skb);
+			skb = NULL;
+			rx_queue->stats.rx_dropped++;
+
+			/* can continue normally */
+		}
+
 		/* order rx buffer descriptor reads */
 		rmb();
 
-- 
2.30.1

