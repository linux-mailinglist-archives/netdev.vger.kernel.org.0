Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4B862C5A4
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 17:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233490AbiKPQ7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 11:59:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232590AbiKPQ7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 11:59:51 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 197BF14D0D
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 08:59:51 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1668617989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iCnL0qNt30PdSk8bM1mrZseqVehkZGOwmgQKCwV4e64=;
        b=Snk6v3gOQRW5QbFNl68HBT5lBRRORSJGdC1sHW/k2pHHeBJDb55bQmWYE0KUarzEIa88B0
        7gLv03pfTCyXT7NbofpVRnVnckcfRDiAWxK+8/EAi4aMPU7qqPKUx0GIpMCZ2TGYBB6nNi
        YYgac4rMAiadSQ6uT7/hSwkijUmPVkhalW4hEqFxn6z1lZzDjgvPsXcM/nNagwhnZGPui9
        DciJ4pm381g+g3khBts3nnJRtK0MlRAEYZQ9MQ4A44N/KwxBInYOfIy72FLeOUIqDc5tlP
        /rRQ9L1BsEeqjTPbxbf4KqZr1r9Tcra02HrIXH2TlhV7QnPzp83TnRGV8ro+bQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1668617989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iCnL0qNt30PdSk8bM1mrZseqVehkZGOwmgQKCwV4e64=;
        b=xUt1qi8/JarJp6qQJK/ZHIC0fuvKJlioc1/prUR+YC3Cn/Hw2id7Evdrh+Dfwjm1jea6QP
        P8lhBj/rJ6BI7yBQ==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Juhee Kang <claudiajkang@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net 2/5] hsr: Add a rcu-read lock to hsr_forward_skb().
Date:   Wed, 16 Nov 2022 17:59:40 +0100
Message-Id: <20221116165943.1776754-3-bigeasy@linutronix.de>
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

hsr_forward_skb() a skb and keeps information in an on-stack
hsr_frame_info. hsr_get_node() assigns hsr_frame_info::node_src which is
from a RCU list. This pointer is used later in hsr_forward_do().
I don't see a reason why this pointer can't vanish midway since there is
no guarantee that hsr_forward_skb() is invoked from an RCU read section.

Use rcu_read_lock() to protect hsr_frame_info::node_src from its
assignment until it is no longer used.

Fixes: f266a683a4804 ("net/hsr: Better frame dispatch")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 net/hsr/hsr_forward.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index 9894962847d97..3a97b00b6d978 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -613,11 +613,13 @@ void hsr_forward_skb(struct sk_buff *skb, struct hsr_=
port *port)
 {
 	struct hsr_frame_info frame;
=20
+	rcu_read_lock();
 	if (fill_frame_info(&frame, skb, port) < 0)
 		goto out_drop;
=20
 	hsr_register_frame_in(frame.node_src, port, frame.sequence_nr);
 	hsr_forward_do(&frame);
+	rcu_read_unlock();
 	/* Gets called for ingress frames as well as egress from master port.
 	 * So check and increment stats for master port only here.
 	 */
@@ -632,6 +634,7 @@ void hsr_forward_skb(struct sk_buff *skb, struct hsr_po=
rt *port)
 	return;
=20
 out_drop:
+	rcu_read_unlock();
 	port->dev->stats.tx_dropped++;
 	kfree_skb(skb);
 }
--=20
2.38.1

