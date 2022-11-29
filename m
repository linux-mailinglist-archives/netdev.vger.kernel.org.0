Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AAAC63C5CE
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 17:58:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236225AbiK2Q6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 11:58:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236140AbiK2Q5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 11:57:31 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F5F869DE5
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 08:51:45 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669740702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0YBg6wNjoG7moyK7baDOJkZnjGpK2XumKcD7kvZsXz0=;
        b=cNhCWWiEL+sCnk3am278xF2CefaJIZ+PhQRp8niBknV6Jm0r7Y0H88YWqhTIVSp7xhPAGJ
        5Nm0Mmj2P+L53DIdgVDkodYCLNOSdpCxW9gaOaMp7xd7/fQOE4v+tNfbVZbMHi6Nkg3tfM
        daEd7+mJiB/AixZLFEsliznj5iPKJdNThOWbSpIKA/muR/Bp5nP+oAmSAj+DYC6wqh3Sju
        w672LkFB+6+neQQoC3IPk0+Cpgf12VROq18QTf14MvcS4qSjW3JZpR35FXG+Ri8vJwzxK2
        sEe/mrqIMK74lz/Y5fFpwI9hxJaaywnWPmtcccI52GAjqZ3WLgZr2L+si/+V2w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669740702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0YBg6wNjoG7moyK7baDOJkZnjGpK2XumKcD7kvZsXz0=;
        b=QQJQzOXEpbPH1H5gXt/cBrsC+NT6rP6rMcB40tIpRLNbHBYpSjB1E2bczBuvb0eNb3w4nR
        cfNZF27GqR7szvBw==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH v5 net-next 6/8] hsr: Synchronize sequence number updates.
Date:   Tue, 29 Nov 2022 17:48:13 +0100
Message-Id: <20221129164815.128922-7-bigeasy@linutronix.de>
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

hsr_register_frame_out() compares new sequence_nr vs the old one
recorded in hsr_node::seq_out and if the new sequence_nr is higher then
it will be written to hsr_node::seq_out as the new value.

This operation isn't locked so it is possible that two frames with the
same sequence number arrive (via the two slave devices) and are fed to
hsr_register_frame_out() at the same time. Both will pass the check and
update the sequence counter later to the same value. As a result the
content of the same packet is fed into the stack twice.

This was noticed by running ping and observing DUP being reported from
time to time.

Instead of using the hsr_priv::seqnr_lock for the whole receive path (as
it is for sending in the master node) add an additional lock that is only
used for sequence number checks and updates.

Add a per-node lock that is used during sequence number reads and
updates.

Fixes: f421436a591d3 ("net/hsr: Add support for the High-availability Seaml=
ess Redundancy protocol (HSRv0)")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 net/hsr/hsr_framereg.c | 9 ++++++++-
 net/hsr/hsr_framereg.h | 2 ++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
index f2dd846ff9038..39a6088080e93 100644
--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -157,6 +157,7 @@ static struct hsr_node *hsr_add_node(struct hsr_priv *h=
sr,
 		return NULL;
=20
 	ether_addr_copy(new_node->macaddress_A, addr);
+	spin_lock_init(&new_node->seq_out_lock);
=20
 	/* We are only interested in time diffs here, so use current jiffies
 	 * as initialization. (0 could trigger an spurious ring error warning).
@@ -353,6 +354,7 @@ void hsr_handle_sup_frame(struct hsr_frame_info *frame)
 	}
=20
 	ether_addr_copy(node_real->macaddress_B, ethhdr->h_source);
+	spin_lock_bh(&node_real->seq_out_lock);
 	for (i =3D 0; i < HSR_PT_PORTS; i++) {
 		if (!node_curr->time_in_stale[i] &&
 		    time_after(node_curr->time_in[i], node_real->time_in[i])) {
@@ -363,6 +365,7 @@ void hsr_handle_sup_frame(struct hsr_frame_info *frame)
 		if (seq_nr_after(node_curr->seq_out[i], node_real->seq_out[i]))
 			node_real->seq_out[i] =3D node_curr->seq_out[i];
 	}
+	spin_unlock_bh(&node_real->seq_out_lock);
 	node_real->addr_B_port =3D port_rcv->type;
=20
 	spin_lock_bh(&hsr->list_lock);
@@ -456,13 +459,17 @@ void hsr_register_frame_in(struct hsr_node *node, str=
uct hsr_port *port,
 int hsr_register_frame_out(struct hsr_port *port, struct hsr_node *node,
 			   u16 sequence_nr)
 {
+	spin_lock_bh(&node->seq_out_lock);
 	if (seq_nr_before_or_eq(sequence_nr, node->seq_out[port->type]) &&
 	    time_is_after_jiffies(node->time_out[port->type] +
-	    msecs_to_jiffies(HSR_ENTRY_FORGET_TIME)))
+	    msecs_to_jiffies(HSR_ENTRY_FORGET_TIME))) {
+		spin_unlock_bh(&node->seq_out_lock);
 		return 1;
+	}
=20
 	node->time_out[port->type] =3D jiffies;
 	node->seq_out[port->type] =3D sequence_nr;
+	spin_unlock_bh(&node->seq_out_lock);
 	return 0;
 }
=20
diff --git a/net/hsr/hsr_framereg.h b/net/hsr/hsr_framereg.h
index b5f902397bf1a..b23556251d621 100644
--- a/net/hsr/hsr_framereg.h
+++ b/net/hsr/hsr_framereg.h
@@ -69,6 +69,8 @@ void prp_update_san_info(struct hsr_node *node, bool is_s=
up);
=20
 struct hsr_node {
 	struct list_head	mac_list;
+	/* Protect R/W access to seq_out */
+	spinlock_t		seq_out_lock;
 	unsigned char		macaddress_A[ETH_ALEN];
 	unsigned char		macaddress_B[ETH_ALEN];
 	/* Local slave through which AddrB frames are received from this node */
--=20
2.38.1

