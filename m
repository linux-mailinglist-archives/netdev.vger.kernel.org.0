Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1921563C5D0
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 17:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236508AbiK2Q6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 11:58:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235998AbiK2Q5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 11:57:31 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C02469DD5
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 08:51:45 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669740701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Se3VUV4VgV2Dm3+vYvjmbnzZL1Rh4a37GClYgreafSU=;
        b=4oulnpS3tENMtLzTYmHa18VvdLkr9/WmtdPLmSEdaq2lQYyzQiBdevWX1cj+86kWwmoy9W
        lmKvXXsYze1kF+veFbs/evlP9WLuilv4x0St7hHiEp0leaajmfuQraBU1QyrqFVWEJKV6d
        gs+vmPrzeAxc9LMZ9zz1+KxzSzvX4vBvRYJ2jKEaSKGEIxVtlCQf763p3bryWweje22IKO
        n+abVfDkLQodWxINxGAF2K9PKeJapcC21FCV6v4wDZM48GCDU+4Dz++tScJt0IP1mFz/nU
        1unUv9mSkQwK7/L6wX2E//dsNpslKY2hzESacTkkVk6U+1SqUzdbCZQuK9vGKQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669740701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Se3VUV4VgV2Dm3+vYvjmbnzZL1Rh4a37GClYgreafSU=;
        b=xLasiHkyVpbaUHDLJ0iUtdQv2cZhQw2VCZE8f7o/ncnwQXgPP5UXiKHilgBJcrZAX3A3vl
        tK07KOyBVYqLdwBA==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH v5 net-next 5/8] hsr: Synchronize sending frames to have always incremented outgoing seq nr.
Date:   Tue, 29 Nov 2022 17:48:12 +0100
Message-Id: <20221129164815.128922-6-bigeasy@linutronix.de>
In-Reply-To: <20221129164815.128922-1-bigeasy@linutronix.de>
References: <20221129164815.128922-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sending frames via the hsr (master) device requires a sequence number
which is tracked in hsr_priv::sequence_nr and protected by
hsr_priv::seqnr_lock. Each time a new frame is sent, it will obtain a
new id and then send it via the slave devices.
Each time a packet is sent (via hsr_forward_do()) the sequence number is
checked via hsr_register_frame_out() to ensure that a frame is not
handled twice. This make sense for the receiving side to ensure that the
frame is not injected into the stack twice after it has been received
from both slave ports.

There is no locking to cover the sending path which means the following
scenario is possible:

  CPU0				CPU1
  hsr_dev_xmit(skb1)		hsr_dev_xmit(skb2)
   fill_frame_info()             fill_frame_info()
    hsr_fill_frame_info()         hsr_fill_frame_info()
     handle_std_frame()            handle_std_frame()
      skb1's sequence_nr =3D 1
                                    skb2's sequence_nr =3D 2
   hsr_forward_do()              hsr_forward_do()

                                   hsr_register_frame_out(, 2)  // okay, se=
nd)

    hsr_register_frame_out(, 1) // stop, lower seq duplicate

Both skbs (or their struct hsr_frame_info) received an unique id.
However since skb2 was sent before skb1, the higher sequence number was
recorded in hsr_register_frame_out() and the late arriving skb1 was
dropped and never sent.

This scenario has been observed in a three node HSR setup, with node1 +
node2 having ping and iperf running in parallel. From time to time ping
reported a missing packet. Based on tracing that missing ping packet did
not leave the system.

It might be possible (didn't check) to drop the sequence number check on
the sending side. But if the higher sequence number leaves on wire
before the lower does and the destination receives them in that order
and it will drop the packet with the lower sequence number and never
inject into the stack.
Therefore it seems the only way is to lock the whole path from obtaining
the sequence number and sending via dev_queue_xmit() and assuming the
packets leave on wire in the same order (and don't get reordered by the
NIC).

Cover the whole path for the master interface from obtaining the ID
until after it has been forwarded via hsr_forward_skb() to ensure the
skbs are sent to the NIC in the order of the assigned sequence numbers.

Fixes: f421436a591d3 ("net/hsr: Add support for the High-availability Seaml=
ess Redundancy protocol (HSRv0)")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 net/hsr/hsr_device.c  | 12 +++++++-----
 net/hsr/hsr_forward.c |  3 +--
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index 84fba2a402a5b..b1e86a7265b32 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -219,7 +219,9 @@ static netdev_tx_t hsr_dev_xmit(struct sk_buff *skb, st=
ruct net_device *dev)
 		skb->dev =3D master->dev;
 		skb_reset_mac_header(skb);
 		skb_reset_mac_len(skb);
+		spin_lock_bh(&hsr->seqnr_lock);
 		hsr_forward_skb(skb, master);
+		spin_unlock_bh(&hsr->seqnr_lock);
 	} else {
 		dev_core_stats_tx_dropped_inc(dev);
 		dev_kfree_skb_any(skb);
@@ -306,7 +308,6 @@ static void send_hsr_supervision_frame(struct hsr_port =
*master,
 		hsr_stag->sequence_nr =3D htons(hsr->sequence_nr);
 		hsr->sequence_nr++;
 	}
-	spin_unlock_bh(&hsr->seqnr_lock);
=20
 	hsr_stag->tlv.HSR_TLV_type =3D type;
 	/* TODO: Why 12 in HSRv0? */
@@ -317,11 +318,13 @@ static void send_hsr_supervision_frame(struct hsr_por=
t *master,
 	hsr_sp =3D skb_put(skb, sizeof(struct hsr_sup_payload));
 	ether_addr_copy(hsr_sp->macaddress_A, master->dev->dev_addr);
=20
-	if (skb_put_padto(skb, ETH_ZLEN))
+	if (skb_put_padto(skb, ETH_ZLEN)) {
+		spin_unlock_bh(&hsr->seqnr_lock);
 		return;
+	}
=20
 	hsr_forward_skb(skb, master);
-
+	spin_unlock_bh(&hsr->seqnr_lock);
 	return;
 }
=20
@@ -360,9 +363,8 @@ static void send_prp_supervision_frame(struct hsr_port =
*master,
 		return;
 	}
=20
-	spin_unlock_bh(&hsr->seqnr_lock);
-
 	hsr_forward_skb(skb, master);
+	spin_unlock_bh(&hsr->seqnr_lock);
 }
=20
 /* Announce (supervision frame) timer function
diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index 0cb8f4040bfd1..b67e52af8967f 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -508,10 +508,9 @@ static void handle_std_frame(struct sk_buff *skb,
 		frame->is_from_san =3D true;
 	} else {
 		/* Sequence nr for the master node */
-		spin_lock_bh(&hsr->seqnr_lock);
+		lockdep_assert_held(&hsr->seqnr_lock);
 		frame->sequence_nr =3D hsr->sequence_nr;
 		hsr->sequence_nr++;
-		spin_unlock_bh(&hsr->seqnr_lock);
 	}
 }
=20
--=20
2.38.1

