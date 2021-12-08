Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD45346D9C1
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 18:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237920AbhLHRfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 12:35:39 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:33320 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233218AbhLHRfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 12:35:39 -0500
Date:   Wed, 8 Dec 2021 18:32:05 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1638984726;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Sgdw76mLJ/C9D4V2Z4FYhwTVSAeEIaaCr7wyLEI5WYY=;
        b=FARBTHaAW8hUlsYvLpSqXsg0WMBHZ1w26HYGu9OAl++8fXyHwsQ/j5bs3el4fl3JS/EI80
        PPPZJ7r5l55ZpB+tP+0yTm6tPaDlPFLZvbMuXopPvn3gIaSCWOxrmOxYCk7IWoJ5YmeNjD
        YFAe3bJ+r/SGVnJS+t2u1PDptpnBXKrcyxjHjWezL6dkvmxiG0tlJT2lIDFLhSGp40gwDs
        MZIMyq9KwvrNnfJijJXEpYl2SvkW0lxbmzEDf9zb1ntfdii84IhnHhJehpYTGm6yknQJu1
        kIbeZZwpOfram1HXdk0s/+9ifMh4koq03LoJsoben/7H8I1KwzBHlQJ/Sn1FdQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1638984726;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Sgdw76mLJ/C9D4V2Z4FYhwTVSAeEIaaCr7wyLEI5WYY=;
        b=vgFDGk8KBBc3mra1P+5/P3GpSuveIHRvPCaD3wLoj04M8R56Div5ruMQ/pWxGZJbVA+kRy
        SqBGlU+TkSm7UFCA==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     wireguard@lists.zx2c4.com, netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [RFC] wiregard RX packet processing.
Message-ID: <20211208173205.zajfvg6zvi4g5kln@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I didn't understand everything, I just stumbled upon this while looking
for something else and don't have the time to figure everything out.
Also I might haven taken a wrong turn somewhere=E2=80=A6

need_resched() is something you want avoid unless you write core code.
On a PREEMPT kernel you never observe true here and cond_resched() is a
nop. On non-PREEMPT kernels need_resched() can return true/ false _and_
should_resched() (which is part of cond_resched()) returns only true if
the same bit is true. This means invoking only cond_resched() saves one
read access. Bonus points: On x86 that bit is folded into the preemption
counter so you avoid reading that bit entirely plus the whole thing is
optimized away on a PREEMPT kernel.

wg_queue_enqueue_per_peer_rx() enqueues somehow skb for NAPI processing
(this bit I haven't figured out yet but it has to) and then invokes
napi_schedule(). This napi_schedule() wasn't meant to be invoked from
preemptible context, only from an actual IRQ handler:
- if NAPI is already active (which can only happen if it is running on a
  remote CPU) then nothing happens. Good.

- if NAPI is idle then __napi_schedule() will "schedule" it. Here is
  the thing: You are in process context (kworker) so nothing happens
  right away: NET_RX_SOFTIRQ is set for the local CPU and NAPI struct is
  added to the list. Now you need to wait until a random interrupt
  appears which will notice that a softirq bit is set and will process
  it. So it will happen eventually=E2=80=A6

I would suggest to either:
- add a comment that this is know and it doesn't not matter because
  $REASON. I would imagine you might want to batch multiple skbs but=E2=80=
=A6

- add a BH disable section around wg_queue_enqueue_per_peer_rx() (see
  below). That bh-enable() will invoke pending softirqs which in your
  case should invoke wg_packet_rx_poll() where you see only one skb.

diff --git a/drivers/net/wireguard/receive.c b/drivers/net/wireguard/receiv=
e.c
index 7b8df406c7737..64e4ca1ded108 100644
--- a/drivers/net/wireguard/receive.c
+++ b/drivers/net/wireguard/receive.c
@@ -507,9 +507,11 @@ void wg_packet_decrypt_worker(struct work_struct *work)
 		enum packet_state state =3D
 			likely(decrypt_packet(skb, PACKET_CB(skb)->keypair)) ?
 				PACKET_STATE_CRYPTED : PACKET_STATE_DEAD;
+		local_bh_disable();
 		wg_queue_enqueue_per_peer_rx(skb, state);
-		if (need_resched())
-			cond_resched();
+		local_bh_enable();
+
+		cond_resched();
 	}
 }
=20

Sebastian
