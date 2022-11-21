Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54877632B64
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 18:46:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbiKURqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 12:46:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbiKURqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 12:46:13 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0FD356EC4
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 09:46:12 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669052771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VNq+vGNG0CTlw3VW3ZdooZgvUjXykmOxQ/6FpJtmkoU=;
        b=e9wB6eVV3xrZKF/SgC8KRvt3MLoJSt2KJ8etr3QHFRhIZajfjIX2s8XpXNroFZKfPXY3jx
        mm7cNlDyOW3f6vJtXdag4YzYqueqRFm78J9KWUrAVGTgN40unJozHJPOBPUkg8w1ulgDIp
        i4GxOAjS+wLG+3BuiUSXwbQevM4Q8sVL1YdsTlgRXe6xl7VaHZCDL73e0BYTahFKtVlp72
        agIKcL1YNuP1MT1q4FxzLwNV50cBPWwrrWkZ4SQGJF57wzEQarDgy8F82+C0/9+qWt1IEo
        VoBuKUYrwu6l1rDOfHDGdy0C62KDAOBxV8/LD5LwSbdaFQyQBTkdU/gn48MbbA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669052771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VNq+vGNG0CTlw3VW3ZdooZgvUjXykmOxQ/6FpJtmkoU=;
        b=lTH18K81A3ASnV+MWeAnOH4uLH/jLEBOxGdtzfCqQz3h81SHH6x0OsvcRtT0FGUdHT1HAH
        T5aBekA2lpYh+iDg==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH v2 net 2/7] hsr: Add a rcu-read lock to hsr_forward_skb().
Date:   Mon, 21 Nov 2022 18:46:00 +0100
Message-Id: <20221121174605.2456845-3-bigeasy@linutronix.de>
In-Reply-To: <20221121174605.2456845-1-bigeasy@linutronix.de>
References: <20221121174605.2456845-1-bigeasy@linutronix.de>
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
assigment until it is no longer used.

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

