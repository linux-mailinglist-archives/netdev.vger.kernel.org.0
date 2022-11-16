Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D05C962C5A9
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 18:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233578AbiKPRAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 12:00:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233518AbiKPQ7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 11:59:53 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F473DF71
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 08:59:52 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1668617990;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k8bdWLa7a0CfQJPJM9b7nroRcd000IAwQvQ4fN3pgNU=;
        b=VVTK7mse5s54n+mAkC1YYZKR0bprmjywaizjtOHXj0jUMVPcogaHZy0I1Qz4gzud54Ed3z
        dtiXgHHuQUmt0hjPH0JT5RBXKjnTWDf7kJR5YPBvGVQWu1falo4R/bkOq2M51fd/RNVQs+
        tUgxF4lwj0DNpwHzu6RebUrAU6DZHViGfjT5O8pEijilIGVi5HIIEU/Q/6gWEfT1WvcXzU
        vhAbqAfBdCp8Ve34By3OA1uB5p+H8Kl2CzYesOIW8rn3H7YHYCYDwTFFQ2BacdXbvxsqvX
        ck6amsIRTPM0V6acAt4N9FYaD/avT7DCwiEKVIKrxoL+++Rvksb/jHF4IpRhsg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1668617990;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k8bdWLa7a0CfQJPJM9b7nroRcd000IAwQvQ4fN3pgNU=;
        b=PSOieoNh5Q77Iu5AMHHVdf+PsuUCe3FfHS09zebA6393Hm5sWSO4sWp4xlRCNSYqHw4+hZ
        yPGB2mn5OrVhucCA==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Juhee Kang <claudiajkang@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net 5/5] hsr: Synchronize sequence number updates.
Date:   Wed, 16 Nov 2022 17:59:43 +0100
Message-Id: <20221116165943.1776754-6-bigeasy@linutronix.de>
In-Reply-To: <20221116165943.1776754-1-bigeasy@linutronix.de>
References: <20221116165943.1776754-1-bigeasy@linutronix.de>
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
it is for sending in the master node) ensure that the id is only updated
based on the expected old value.

Use cmpxchg() to only update sequence number if it is the old value,
that was also used for comparison.

Fixes: f421436a591d3 ("net/hsr: Add support for the High-availability Seaml=
ess Redundancy protocol (HSRv0)")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 net/hsr/hsr_framereg.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
index 9b8eaebce2549..7a9d4d36f114d 100644
--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -453,13 +453,19 @@ void hsr_register_frame_in(struct hsr_node *node, str=
uct hsr_port *port,
 int hsr_register_frame_out(struct hsr_port *port, struct hsr_node *node,
 			   u16 sequence_nr)
 {
-	if (seq_nr_before_or_eq(sequence_nr, node->seq_out[port->type]) &&
+	u16 old_seq;
+again:
+	old_seq =3D READ_ONCE(node->seq_out[port->type]);
+
+	if (seq_nr_before_or_eq(sequence_nr, old_seq) &&
 	    time_is_after_jiffies(node->time_out[port->type] +
 	    msecs_to_jiffies(HSR_ENTRY_FORGET_TIME)))
 		return 1;
=20
+	if (cmpxchg(&node->seq_out[port->type], old_seq, sequence_nr) !=3D old_se=
q)
+		goto again;
+
 	node->time_out[port->type] =3D jiffies;
-	node->seq_out[port->type] =3D sequence_nr;
 	return 0;
 }
=20
--=20
2.38.1

