Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F028F243F61
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 21:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbgHMTj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 15:39:28 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:60590 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726253AbgHMTj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 15:39:27 -0400
From:   John Ogness <john.ogness@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1597347566;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=cHxWr4K717iNYyicWp7dXoDXvMnNK+4qcSlmZq+2kjA=;
        b=FfWWYol9ZfI6+cPX/qTj+Y64u1qcWbBtfIZuxxspIlI4J9yTWUcrkR2lL4t4JjhCgKw50M
        XJ6KTF8qqlXMROJMCmNj5jlU5EUO7t2Ptc/8st6bG0K4qpY3NChTwadVt4fUo9mPEhJuTm
        1bBiFizep1x9h3Q/aDsu971eF5eFZHhaaq/U/7yCDwHig1JiIdv09QN0ZgG8hY4sxWHdf0
        sMxnU3x7IKJuJwF9ZEQ2JckbAwz5WiigERa9qZaOg1xQhsobsA2obP2JtpCaEGDvrsV1W7
        nM7hxsj4Evc1fHDAwByIG31trNN2Xp5nLJNdKVnQ6K7hflv1C96ON48FRps4yQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1597347566;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=cHxWr4K717iNYyicWp7dXoDXvMnNK+4qcSlmZq+2kjA=;
        b=g3AF9+1CEEkBzkddAs3juyTKp1K2oX16sBKJyzRYDv1pidIZj+oXJjHffR/kEv/ofAxOGB
        +5AeXwKGAT7MEgDw==
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] af_packet: TPACKET_V3: fix fill status rwlock imbalance
Date:   Thu, 13 Aug 2020 21:45:25 +0206
Message-Id: <20200813193925.32477-1-john.ogness@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After @blk_fill_in_prog_lock is acquired there is an early out vnet
situation that can occur. In that case, the rwlock needs to be
released.

Also, since @blk_fill_in_prog_lock is only acquired when @tp_version
is exactly TPACKET_V3, only release it on that exact condition as
well.

And finally, add sparse annotation so that it is clearer that
prb_fill_curr_block() and prb_clear_blk_fill_status() are acquiring
and releasing @blk_fill_in_prog_lock, respectively. sparse is still
unable to understand the balance, but the warnings are now on a
higher level that make more sense.

Fixes: 632ca50f2cbd ("af_packet: TPACKET_V3: replace busy-wait loop")
Signed-off-by: John Ogness <john.ogness@linutronix.de>
Reported-by: kernel test robot <lkp@intel.com>
---
 net/packet/af_packet.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 0b8160d1a6e0..479c257ded73 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -941,6 +941,7 @@ static int prb_queue_frozen(struct tpacket_kbdq_core *pkc)
 }
 
 static void prb_clear_blk_fill_status(struct packet_ring_buffer *rb)
+	__releases(&pkc->blk_fill_in_prog_lock)
 {
 	struct tpacket_kbdq_core *pkc  = GET_PBDQC_FROM_RB(rb);
 
@@ -989,6 +990,7 @@ static void prb_fill_curr_block(char *curr,
 				struct tpacket_kbdq_core *pkc,
 				struct tpacket_block_desc *pbd,
 				unsigned int len)
+	__acquires(&pkc->blk_fill_in_prog_lock)
 {
 	struct tpacket3_hdr *ppd;
 
@@ -2286,8 +2288,11 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 	if (do_vnet &&
 	    virtio_net_hdr_from_skb(skb, h.raw + macoff -
 				    sizeof(struct virtio_net_hdr),
-				    vio_le(), true, 0))
+				    vio_le(), true, 0)) {
+		if (po->tp_version == TPACKET_V3)
+			prb_clear_blk_fill_status(&po->rx_ring);
 		goto drop_n_account;
+	}
 
 	if (po->tp_version <= TPACKET_V2) {
 		packet_increment_rx_head(po, &po->rx_ring);
@@ -2393,7 +2398,7 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 		__clear_bit(slot_id, po->rx_ring.rx_owner_map);
 		spin_unlock(&sk->sk_receive_queue.lock);
 		sk->sk_data_ready(sk);
-	} else {
+	} else if (po->tp_version == TPACKET_V3) {
 		prb_clear_blk_fill_status(&po->rx_ring);
 	}
 
-- 
2.20.1

