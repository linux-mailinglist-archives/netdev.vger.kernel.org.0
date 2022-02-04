Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 171044A9997
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 14:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244237AbiBDNAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 08:00:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244168AbiBDNAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 08:00:15 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4EA1C06173D;
        Fri,  4 Feb 2022 05:00:14 -0800 (PST)
Date:   Fri, 4 Feb 2022 14:00:10 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1643979611;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HlD2lT0qLZrqUBY6puOj/ZakQbSaRYkvcZCDkXh3l30=;
        b=01U5Ghv5Kuo0VXxlC7AcdpNCYRFX0Il7tWUp/gMeH+RkD83gs6jjR4PTr7jkJ3sjigi3BC
        tQT5zb9gedcPf4tP0sXsQ4sLPHXd9/JB0H391f8ejPapFci9PwXfwic0LD3bQvxpYKzaEy
        etBaM77flA3MXfn/fSpzDqTBrIXu0zJcA79NQwZNZYo/s6oLM1P4by2+gPTKFpLfM6FraH
        IRqDyutUBBe9GRfNMv2r7jrkpwd1WOhHoqWPpo7twBdiMNbIBO+aUK6Mf9S5qAFc+if6NO
        AF6qpGI3mNfuyVgT2LEE93cQnupbgmX5X4uMk1ZdPknTAfUh8yuFJu2mtpjVkg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1643979611;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HlD2lT0qLZrqUBY6puOj/ZakQbSaRYkvcZCDkXh3l30=;
        b=R9eY82lJwMBv6TG8H15PvUP2l0FSMa2m5UuXnYb+ZrTnH9O83igRvOCHRyvuOvaWw9zQ0g
        qR0R73HLzANo5mBw==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Eric Dumazet <edumazet@google.com>
Cc:     bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH net-next v2 3/4] net: dev: Makes sure netif_rx() can be
 invoked in any context.
Message-ID: <Yf0jWtF2/0pYcjXI@linutronix.de>
References: <20220202122848.647635-1-bigeasy@linutronix.de>
 <20220202122848.647635-4-bigeasy@linutronix.de>
 <CANn89iLVPnhybrdjRh6ccv6UZHW-_W0ZHRO5c7dnWU44FUgd_g@mail.gmail.com>
 <YfvwbsKm4XtTUlsx@linutronix.de>
 <CANn89i+66MvzQVp=eTENzZY6s8+B+jQCoKEO_vXdzaDeHVTH5w@mail.gmail.com>
 <Yfv3c+5XieVR0xAh@linutronix.de>
 <CANn89i+t4TgrryvSBmBMfsY63m6Fhxi+smiKfOwHTRAKxvcPLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CANn89i+t4TgrryvSBmBMfsY63m6Fhxi+smiKfOwHTRAKxvcPLQ@mail.gmail.com>
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

Eric is concerned about the overhead of BH-disable+enable especially in
regard to the loopback driver. As critical as this driver is, it will
receive a shortcut to avoid the additional overhead which is not needed.

Add a local_bh_disable() section in netif_rx() to ensure softirqs are
handled if needed. Provide the internal bits as __netif_rx() which can
be used by the loopback driver. This function is not exported so it
can't be used by modules.
Make netif_rx_ni() and netif_rx_any_context() invoke netif_rx() so they
can be removed once they are no more users left.

Link: https://lkml.kernel.org/r/20100415.020246.218622820.davem@davemloft.n=
et
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
v1=E2=80=A6v2:
  - Provide netif_rx() as in v1 and additionally __netif_rx() without
    local_bh disable()+enable() for the loopback driver. __netif_rx() is
    not exported (loopback is built-in only) so it won't be used
    drivers. If this doesn't work then we can still export/ define a
    wrapper as Eric suggested.

  - Added a comment that netif_rx() considered legacy.

 drivers/net/loopback.c     |  2 +-
 include/linux/netdevice.h  | 14 ++++++++--
 include/trace/events/net.h | 14 ----------
 net/core/dev.c             | 53 +++++++++++---------------------------
 4 files changed, 28 insertions(+), 55 deletions(-)

diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
index ed0edf5884ef8..77f5b564382b6 100644
--- a/drivers/net/loopback.c
+++ b/drivers/net/loopback.c
@@ -86,7 +86,7 @@ static netdev_tx_t loopback_xmit(struct sk_buff *skb,
 	skb->protocol =3D eth_type_trans(skb, dev);
=20
 	len =3D skb->len;
-	if (likely(netif_rx(skb) =3D=3D NET_RX_SUCCESS))
+	if (likely(__netif_rx(skb) =3D=3D NET_RX_SUCCESS))
 		dev_lstats_add(dev, len);
=20
 	return NETDEV_TX_OK;
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index e490b84732d16..c9e883104adb1 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3669,8 +3669,18 @@ u32 bpf_prog_run_generic_xdp(struct sk_buff *skb, st=
ruct xdp_buff *xdp,
 void generic_xdp_tx(struct sk_buff *skb, struct bpf_prog *xdp_prog);
 int do_xdp_generic(struct bpf_prog *xdp_prog, struct sk_buff *skb);
 int netif_rx(struct sk_buff *skb);
-int netif_rx_ni(struct sk_buff *skb);
-int netif_rx_any_context(struct sk_buff *skb);
+int __netif_rx(struct sk_buff *skb);
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
index 5ef77b53507d4..b7578f47e151c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4829,6 +4829,16 @@ static int netif_rx_internal(struct sk_buff *skb)
 	return ret;
 }
=20
+int __netif_rx(struct sk_buff *skb)
+{
+	int ret;
+
+	trace_netif_rx_entry(skb);
+	ret =3D netif_rx_internal(skb);
+	trace_netif_rx_exit(ret);
+	return ret;
+}
+
 /**
  *	netif_rx	-	post buffer to the network code
  *	@skb: buffer to post
@@ -4837,58 +4847,25 @@ static int netif_rx_internal(struct sk_buff *skb)
  *	the upper (protocol) levels to process.  It always succeeds. The buffer
  *	may be dropped during processing for congestion control or by the
  *	protocol layers.
+ *	This interface is considered legacy. Modern NIC driver should use NAPI
+ *	and GRO.
  *
  *	return values:
  *	NET_RX_SUCCESS	(no congestion)
  *	NET_RX_DROP     (packet was dropped)
  *
  */
-
 int netif_rx(struct sk_buff *skb)
 {
 	int ret;
=20
-	trace_netif_rx_entry(skb);
-
-	ret =3D netif_rx_internal(skb);
-	trace_netif_rx_exit(ret);
-
+	local_bh_disable();
+	ret =3D __netif_rx(skb);
+	local_bh_enable();
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

