Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0AC763C5CA
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 17:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235858AbiK2Q57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 11:57:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236656AbiK2Q51 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 11:57:27 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2719D69DD1
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 08:51:43 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669740701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sp8CnyT8+d8v5Q3zWHZkcsCanTyrIjAXUbUopvzz0Q0=;
        b=idsCVvHd5a/Uma6C/ertgGDZvE+yP64l27h2NuuvEUUZ+nn63gL0MbZ3CnMv03DPNQ6l/M
        c7cKAT+5FMBPX5VN8t446yjyzIn4LbmvhvhwGMzfTbP/N2zN67+2/MOFY6w2ZroHC2oxuN
        9F9vDp1TqkUcOYKpPaWGWnOCFIz3T9qSBOeTXElqlhSjp1RZevCtCrKF537q5URhCq6vxx
        /tBtewjCRUBEL6p0X+dI1lZdIZZthF3+lxsSP5OQTnDTOUtH0vqtJwOVUxq8MOQeI3QnP6
        DYwz+fWAHR51T66GMkogEs6iLTFAlEk3O+O8+Euqnorze9EtY89l9gyVvBJyCw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669740701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sp8CnyT8+d8v5Q3zWHZkcsCanTyrIjAXUbUopvzz0Q0=;
        b=EKwYmVThloMqrl7uYQibWSbFJuFVgd27P7BBcGulevNdQmKIKgFTey6J3H1fLrHlP7rOb9
        uQPUkQyk5l/y13DQ==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH v5 net-next 4/8] hsr: Disable netpoll.
Date:   Tue, 29 Nov 2022 17:48:11 +0100
Message-Id: <20221129164815.128922-5-bigeasy@linutronix.de>
In-Reply-To: <20221129164815.128922-1-bigeasy@linutronix.de>
References: <20221129164815.128922-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The hsr device is a software device. Its
net_device_ops::ndo_start_xmit() routine will process the packet and
then pass the resulting skb to dev_queue_xmit().
During processing, hsr acquires a lock with spin_lock_bh()
(hsr_add_node()) which needs to be promoted to the _irq() suffix in
order to avoid a potential deadlock.
Then there are the warnings in dev_queue_xmit() (due to
local_bh_disable() with disabled interrupts) left.

Instead trying to address those (there is qdisc and=E2=80=A6) for netpoll s=
ake,
just disable netpoll on hsr.

Disable netpoll on hsr and replace the _irqsave() locking with _bh().

Fixes: f421436a591d3 ("net/hsr: Add support for the High-availability Seaml=
ess Redundancy protocol (HSRv0)")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 net/hsr/hsr_device.c  | 14 ++++++--------
 net/hsr/hsr_forward.c |  5 ++---
 2 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index 7518f7e930431..84fba2a402a5b 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -278,7 +278,6 @@ static void send_hsr_supervision_frame(struct hsr_port =
*master,
 	__u8 type =3D HSR_TLV_LIFE_CHECK;
 	struct hsr_sup_payload *hsr_sp;
 	struct hsr_sup_tag *hsr_stag;
-	unsigned long irqflags;
 	struct sk_buff *skb;
=20
 	*interval =3D msecs_to_jiffies(HSR_LIFE_CHECK_INTERVAL);
@@ -299,7 +298,7 @@ static void send_hsr_supervision_frame(struct hsr_port =
*master,
 	set_hsr_stag_HSR_ver(hsr_stag, hsr->prot_version);
=20
 	/* From HSRv1 on we have separate supervision sequence numbers. */
-	spin_lock_irqsave(&master->hsr->seqnr_lock, irqflags);
+	spin_lock_bh(&hsr->seqnr_lock);
 	if (hsr->prot_version > 0) {
 		hsr_stag->sequence_nr =3D htons(hsr->sup_sequence_nr);
 		hsr->sup_sequence_nr++;
@@ -307,7 +306,7 @@ static void send_hsr_supervision_frame(struct hsr_port =
*master,
 		hsr_stag->sequence_nr =3D htons(hsr->sequence_nr);
 		hsr->sequence_nr++;
 	}
-	spin_unlock_irqrestore(&master->hsr->seqnr_lock, irqflags);
+	spin_unlock_bh(&hsr->seqnr_lock);
=20
 	hsr_stag->tlv.HSR_TLV_type =3D type;
 	/* TODO: Why 12 in HSRv0? */
@@ -332,7 +331,6 @@ static void send_prp_supervision_frame(struct hsr_port =
*master,
 	struct hsr_priv *hsr =3D master->hsr;
 	struct hsr_sup_payload *hsr_sp;
 	struct hsr_sup_tag *hsr_stag;
-	unsigned long irqflags;
 	struct sk_buff *skb;
=20
 	skb =3D hsr_init_skb(master);
@@ -347,7 +345,7 @@ static void send_prp_supervision_frame(struct hsr_port =
*master,
 	set_hsr_stag_HSR_ver(hsr_stag, (hsr->prot_version ? 1 : 0));
=20
 	/* From HSRv1 on we have separate supervision sequence numbers. */
-	spin_lock_irqsave(&master->hsr->seqnr_lock, irqflags);
+	spin_lock_bh(&hsr->seqnr_lock);
 	hsr_stag->sequence_nr =3D htons(hsr->sup_sequence_nr);
 	hsr->sup_sequence_nr++;
 	hsr_stag->tlv.HSR_TLV_type =3D PRP_TLV_LIFE_CHECK_DD;
@@ -358,11 +356,11 @@ static void send_prp_supervision_frame(struct hsr_por=
t *master,
 	ether_addr_copy(hsr_sp->macaddress_A, master->dev->dev_addr);
=20
 	if (skb_put_padto(skb, ETH_ZLEN)) {
-		spin_unlock_irqrestore(&master->hsr->seqnr_lock, irqflags);
+		spin_unlock_bh(&hsr->seqnr_lock);
 		return;
 	}
=20
-	spin_unlock_irqrestore(&master->hsr->seqnr_lock, irqflags);
+	spin_unlock_bh(&hsr->seqnr_lock);
=20
 	hsr_forward_skb(skb, master);
 }
@@ -444,7 +442,7 @@ void hsr_dev_setup(struct net_device *dev)
 	dev->header_ops =3D &hsr_header_ops;
 	dev->netdev_ops =3D &hsr_device_ops;
 	SET_NETDEV_DEVTYPE(dev, &hsr_type);
-	dev->priv_flags |=3D IFF_NO_QUEUE;
+	dev->priv_flags |=3D IFF_NO_QUEUE | IFF_DISABLE_NETPOLL;
=20
 	dev->needs_free_netdev =3D true;
=20
diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index 3a97b00b6d978..0cb8f4040bfd1 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -499,7 +499,6 @@ static void handle_std_frame(struct sk_buff *skb,
 {
 	struct hsr_port *port =3D frame->port_rcv;
 	struct hsr_priv *hsr =3D port->hsr;
-	unsigned long irqflags;
=20
 	frame->skb_hsr =3D NULL;
 	frame->skb_prp =3D NULL;
@@ -509,10 +508,10 @@ static void handle_std_frame(struct sk_buff *skb,
 		frame->is_from_san =3D true;
 	} else {
 		/* Sequence nr for the master node */
-		spin_lock_irqsave(&hsr->seqnr_lock, irqflags);
+		spin_lock_bh(&hsr->seqnr_lock);
 		frame->sequence_nr =3D hsr->sequence_nr;
 		hsr->sequence_nr++;
-		spin_unlock_irqrestore(&hsr->seqnr_lock, irqflags);
+		spin_unlock_bh(&hsr->seqnr_lock);
 	}
 }
=20
--=20
2.38.1

