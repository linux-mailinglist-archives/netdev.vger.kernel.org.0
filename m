Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91687217198
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 17:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729828AbgGGPWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 11:22:17 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:39264 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728494AbgGGPWO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 11:22:14 -0400
From:   John Ogness <john.ogness@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1594135332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=LxVBy1DoV2t42uekM6oHIWgLJZVcrbHKxbpdNbzHSDs=;
        b=IunFX7pjGAEVmxnZIas6oJ/9YwdsdmaOA9OE0FtMlOPvlgWFtOaDDqJlHXovnGOiHKnwhQ
        CwmW+ri3FxF7YregfVsAJREGXSzvsY4ZqHEvUR9G6B9I9JtAaqU5PgJJ+CY671yQs1SrTD
        CzIbm2ksIhMHNjW5uKURBWLEU48a/ZHAuKJYerMv/bXMxk9Ld5luig3w92mIP8SJh1i0Ix
        SiEvieSpDZNk90FEqL+pFe3asOgmXnQZQNRkDjN0xsKxmw8UbH87jBHjRX+3gPy/ED+D+S
        Q1ZCBwYmS2heNzlLDfIlSXcE4nCDwDLEBZvaL6e2zFOI4mpLSyK15kqdRmoxBA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1594135332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=LxVBy1DoV2t42uekM6oHIWgLJZVcrbHKxbpdNbzHSDs=;
        b=MchddIYbD4bgGWqwWIU33Se5uTwF1xc1iG+Q9Eqx0+0tI6PBGs9CAVHRdjslaOLlbkkHe1
        dX8EQH35Pne8orBQ==
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] af_packet: TPACKET_V3: replace busy-wait loop
Date:   Tue,  7 Jul 2020 17:28:04 +0206
Message-Id: <20200707152204.10314-1-john.ogness@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A busy-wait loop is used to implement waiting for bits to be copied
from the skb to the kernel buffer before retiring a block. This is
a problem on PREEMPT_RT because the copying task could be preempted
by the busy-waiting task and thus live lock in the busy-wait loop.

Replace the busy-wait logic with an rwlock_t. This provides lockdep
coverage and makes the code RT ready.

Signed-off-by: John Ogness <john.ogness@linutronix.de>
---
 patch against v5.8-rc4

 net/packet/af_packet.c | 20 ++++++++++----------
 net/packet/internal.h  |  2 +-
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 29bd405adbbd..dd1eec2dd6ef 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -593,6 +593,7 @@ static void init_prb_bdqc(struct packet_sock *po,
 						req_u->req3.tp_block_size);
 	p1->tov_in_jiffies = msecs_to_jiffies(p1->retire_blk_tov);
 	p1->blk_sizeof_priv = req_u->req3.tp_sizeof_priv;
+	rwlock_init(&p1->blk_fill_in_prog_lock);
 
 	p1->max_frame_len = p1->kblk_size - BLK_PLUS_PRIV(p1->blk_sizeof_priv);
 	prb_init_ft_ops(p1, req_u);
@@ -659,10 +660,9 @@ static void prb_retire_rx_blk_timer_expired(struct timer_list *t)
 	 *
 	 */
 	if (BLOCK_NUM_PKTS(pbd)) {
-		while (atomic_read(&pkc->blk_fill_in_prog)) {
-			/* Waiting for skb_copy_bits to finish... */
-			cpu_relax();
-		}
+		/* Waiting for skb_copy_bits to finish... */
+		write_lock(&pkc->blk_fill_in_prog_lock);
+		write_unlock(&pkc->blk_fill_in_prog_lock);
 	}
 
 	if (pkc->last_kactive_blk_num == pkc->kactive_blk_num) {
@@ -921,10 +921,9 @@ static void prb_retire_current_block(struct tpacket_kbdq_core *pkc,
 		 * the timer-handler already handled this case.
 		 */
 		if (!(status & TP_STATUS_BLK_TMO)) {
-			while (atomic_read(&pkc->blk_fill_in_prog)) {
-				/* Waiting for skb_copy_bits to finish... */
-				cpu_relax();
-			}
+			/* Waiting for skb_copy_bits to finish... */
+			write_lock(&pkc->blk_fill_in_prog_lock);
+			write_unlock(&pkc->blk_fill_in_prog_lock);
 		}
 		prb_close_block(pkc, pbd, po, status);
 		return;
@@ -944,7 +943,8 @@ static int prb_queue_frozen(struct tpacket_kbdq_core *pkc)
 static void prb_clear_blk_fill_status(struct packet_ring_buffer *rb)
 {
 	struct tpacket_kbdq_core *pkc  = GET_PBDQC_FROM_RB(rb);
-	atomic_dec(&pkc->blk_fill_in_prog);
+
+	read_unlock(&pkc->blk_fill_in_prog_lock);
 }
 
 static void prb_fill_rxhash(struct tpacket_kbdq_core *pkc,
@@ -998,7 +998,7 @@ static void prb_fill_curr_block(char *curr,
 	pkc->nxt_offset += TOTAL_PKT_LEN_INCL_ALIGN(len);
 	BLOCK_LEN(pbd) += TOTAL_PKT_LEN_INCL_ALIGN(len);
 	BLOCK_NUM_PKTS(pbd) += 1;
-	atomic_inc(&pkc->blk_fill_in_prog);
+	read_lock(&pkc->blk_fill_in_prog_lock);
 	prb_run_all_ft_ops(pkc, ppd);
 }
 
diff --git a/net/packet/internal.h b/net/packet/internal.h
index 907f4cd2a718..fd41ecb7f605 100644
--- a/net/packet/internal.h
+++ b/net/packet/internal.h
@@ -39,7 +39,7 @@ struct tpacket_kbdq_core {
 	char		*nxt_offset;
 	struct sk_buff	*skb;
 
-	atomic_t	blk_fill_in_prog;
+	rwlock_t	blk_fill_in_prog_lock;
 
 	/* Default is set to 8ms */
 #define DEFAULT_PRB_RETIRE_TOV	(8)
-- 
2.20.1

