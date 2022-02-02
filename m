Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D84464A70C5
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 13:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344067AbiBBM24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 07:28:56 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:46532 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbiBBM24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 07:28:56 -0500
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1643804934;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uxK2Br+YSRgI8layahcCJx/qLAO0UkG+gJh96tUahN0=;
        b=kaTIMGt1u8YwJHjfZz40FPcEepCRDvWM2zASqyzskNmcFdvhgLpgXEXQj+xSYbfCMAaC/n
        meBxkx7tkzWLx7WYmHOkUVc3iN0qpFsXk1TIh/EcJv+HHYZjZUKyfN76xc9UN/UCz+pI39
        ZAuPGMHWbtpEs3sNpzDSD+6Xqub8PMUhAKyzXARrFT2TOw4iv/nWcRAL24Q212rR4q47SN
        g5Vsm8HOVIf3WdDAeIUkN/0Hp4JzDhypOlIa69Mw16e0J1XrONTERAZzTbplMv9FMzJhjo
        AVubCJSnfDKKF7Xp31Tz8EOCT51piP6V51WhThsoHEoI6jP4D1XzfFPMXtJGzQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1643804934;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uxK2Br+YSRgI8layahcCJx/qLAO0UkG+gJh96tUahN0=;
        b=dcOMhmhZoxT1bMa0qCKsJ14XIaEdRnOin1N4DHVjjYpOpJFnE7TP59FA08b7F5CRmZuvMU
        Und4qPBKeZqRQqDg==
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net-next 3/4] net: dev: Makes sure netif_rx() can be invoked in any context.
Date:   Wed,  2 Feb 2022 13:28:47 +0100
Message-Id: <20220202122848.647635-4-bigeasy@linutronix.de>
In-Reply-To: <20220202122848.647635-1-bigeasy@linutronix.de>
References: <20220202122848.647635-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dave suggested a while ago (eleven years by now) "Let's make netif_rx()
work in all contexts and get rid of netif_rx_ni()". Eric agreed and
pointed out that modern devices should use netif_receive_skb() to avoid
the overhead.
In the meantime someone added another variant, netif_rx_any_context(),
which behaves as suggested.

netif_rx() must be invoked with disabled bottom halves to ensure that
pending softirqs, which were raised within the function, are handled.
netif_rx_ni() can be invoked only from process context (bottom halves
must be enabled) because the function handles pending softirqs without
checking if bottom halves were disabled or not.
netif_rx_any_context() invokes on the former functions by checking
in_interrupts().

netif_rx() could be taught to handle both cases (disabled and enabled
bottom halves) by simply disabling bottom halves while invoking
netif_rx_internal(). The local_bh_enable() invocation will then invoke
pending softirqs only if the BH-disable counter drops to zero.

Add a local_bh_disable() section in netif_rx() to ensure softirqs are
handled if needed. Make netif_rx_ni() and netif_rx_any_context() invoke
netif_rx() so they can be removed once they are no more users left.

Link: https://lkml.kernel.org/r/20100415.020246.218622820.davem@davemloft.n=
et
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 include/linux/netdevice.h  | 13 +++++++++++--
 include/trace/events/net.h | 14 --------------
 net/core/dev.c             | 34 ++--------------------------------
 3 files changed, 13 insertions(+), 48 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index e490b84732d16..4086f312f814e 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3669,8 +3669,17 @@ u32 bpf_prog_run_generic_xdp(struct sk_buff *skb, st=
ruct xdp_buff *xdp,
 void generic_xdp_tx(struct sk_buff *skb, struct bpf_prog *xdp_prog);
 int do_xdp_generic(struct bpf_prog *xdp_prog, struct sk_buff *skb);
 int netif_rx(struct sk_buff *skb);
-int netif_rx_ni(struct sk_buff *skb);
-int netif_rx_any_context(struct sk_buff *skb);
+
+static inline int netif_rx_ni(struct sk_buff *skb)
+{
+	return netif_rx(skb);
+}
+
+static inline int netif_rx_any_context(struct sk_buff *skb)
+{
+	return netif_rx(skb);
+}
+
 int netif_receive_skb(struct sk_buff *skb);
 int netif_receive_skb_core(struct sk_buff *skb);
 void netif_receive_skb_list_internal(struct list_head *head);
diff --git a/include/trace/events/net.h b/include/trace/events/net.h
index 78c448c6ab4c5..032b431b987b6 100644
--- a/include/trace/events/net.h
+++ b/include/trace/events/net.h
@@ -260,13 +260,6 @@ DEFINE_EVENT(net_dev_rx_verbose_template, netif_rx_ent=
ry,
 	TP_ARGS(skb)
 );
=20
-DEFINE_EVENT(net_dev_rx_verbose_template, netif_rx_ni_entry,
-
-	TP_PROTO(const struct sk_buff *skb),
-
-	TP_ARGS(skb)
-);
-
 DECLARE_EVENT_CLASS(net_dev_rx_exit_template,
=20
 	TP_PROTO(int ret),
@@ -312,13 +305,6 @@ DEFINE_EVENT(net_dev_rx_exit_template, netif_rx_exit,
 	TP_ARGS(ret)
 );
=20
-DEFINE_EVENT(net_dev_rx_exit_template, netif_rx_ni_exit,
-
-	TP_PROTO(int ret),
-
-	TP_ARGS(ret)
-);
-
 DEFINE_EVENT(net_dev_rx_exit_template, netif_receive_skb_list_exit,
=20
 	TP_PROTO(int ret),
diff --git a/net/core/dev.c b/net/core/dev.c
index 0d13340ed4054..f43d0580fa11d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4834,47 +4834,17 @@ int netif_rx(struct sk_buff *skb)
 {
 	int ret;
=20
+	local_bh_disable();
 	trace_netif_rx_entry(skb);
=20
 	ret =3D netif_rx_internal(skb);
 	trace_netif_rx_exit(ret);
+	local_bh_enable();
=20
 	return ret;
 }
 EXPORT_SYMBOL(netif_rx);
=20
-int netif_rx_ni(struct sk_buff *skb)
-{
-	int err;
-
-	trace_netif_rx_ni_entry(skb);
-
-	preempt_disable();
-	err =3D netif_rx_internal(skb);
-	if (local_softirq_pending())
-		do_softirq();
-	preempt_enable();
-	trace_netif_rx_ni_exit(err);
-
-	return err;
-}
-EXPORT_SYMBOL(netif_rx_ni);
-
-int netif_rx_any_context(struct sk_buff *skb)
-{
-	/*
-	 * If invoked from contexts which do not invoke bottom half
-	 * processing either at return from interrupt or when softrqs are
-	 * reenabled, use netif_rx_ni() which invokes bottomhalf processing
-	 * directly.
-	 */
-	if (in_interrupt())
-		return netif_rx(skb);
-	else
-		return netif_rx_ni(skb);
-}
-EXPORT_SYMBOL(netif_rx_any_context);
-
 static __latent_entropy void net_tx_action(struct softirq_action *h)
 {
 	struct softnet_data *sd =3D this_cpu_ptr(&softnet_data);
--=20
2.34.1

