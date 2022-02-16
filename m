Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B32E94B8FB0
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 18:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237136AbiBPRvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 12:51:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232449AbiBPRvC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 12:51:02 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A1E22B0B1F;
        Wed, 16 Feb 2022 09:50:50 -0800 (PST)
Date:   Wed, 16 Feb 2022 18:50:46 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1645033847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=YPEdXaJgjEi/SM/CGN0s0Wpl04buNzspNJbXpHNAuTU=;
        b=GhyB0Kl93o06tMrnWyGexxtTY3haCpMzApH8Mvauz+QyBOP/7cgsNmBTKSC4dNB5aEoP3Q
        5bcQucjACMZAVO1PRTzYCW70KHvusNYfNVUZMVNZeVZBv6dASkhpKJXzWqR+Z3A4KwVdWd
        f6kS3X4tPsSE5MqqFRpQAqxepR2+7/FCw6NHNqqDctqYw2FQCa28/TAuT/m38gLOYzZFGD
        MVhvpDOiPleRj0Nnkk+W3ZkZiw+zbFo0S5l367PBSGQYq9nebYOpWkH7tXSSdyPgFF6i6N
        XJhCuQOCyJXqn4JP519uwWAb7CCV/crlQHd6UmU+gfljnW2Yn/CtIDdCnsKJGA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1645033847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=YPEdXaJgjEi/SM/CGN0s0Wpl04buNzspNJbXpHNAuTU=;
        b=tr6SY6YlZUWYA//WWe6kGV1QcdkD2AMf8qeMCbNgKrP+4fcGvrVmal8OJeXo2g9+x9x8+Q
        qiUKUS988bNLfKDQ==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Marek Szyprowski <m.szyprowski@samsung.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH net-next] net: Correct wrong BH disable in hard-interrupt.
Message-ID: <Yg05duINKBqvnxUc@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I missed the obvious case where netif_ix() is invoked from hard-IRQ
context.

Disabling bottom halves is only needed in process context. This ensures
that the code remains on the current CPU and that the soft-interrupts
are processed at local_bh_enable() time.
In hard- and soft-interrupt context this is already the case and the
soft-interrupts will be processed once the context is left (at irq-exit
time).

Disable bottom halves if neither hard-interrupts nor soft-interrupts are
disabled. Update the kernel-doc, mention that interrupts must be enabled
if invoked from process context.

Fixes: baebdf48c3600 ("net: dev: Makes sure netif_rx() can be invoked in any context.")
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
Marek, does this work for you?

 net/core/dev.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 909fb38159108..87729491460fc 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4860,7 +4860,9 @@ EXPORT_SYMBOL(__netif_rx);
  *	congestion control or by the protocol layers.
  *	The network buffer is passed via the backlog NAPI device. Modern NIC
  *	driver should use NAPI and GRO.
- *	This function can used from any context.
+ *	This function can used from interrupt and from process context. The
+ *	caller from process context must not disable interrupts before invoking
+ *	this function.
  *
  *	return values:
  *	NET_RX_SUCCESS	(no congestion)
@@ -4870,12 +4872,15 @@ EXPORT_SYMBOL(__netif_rx);
 int netif_rx(struct sk_buff *skb)
 {
 	int ret;
+	bool need_bh_off = !(hardirq_count() | softirq_count());
 
-	local_bh_disable();
+	if (need_bh_off)
+		local_bh_disable();
 	trace_netif_rx_entry(skb);
 	ret = netif_rx_internal(skb);
 	trace_netif_rx_exit(ret);
-	local_bh_enable();
+	if (need_bh_off)
+		local_bh_enable();
 	return ret;
 }
 EXPORT_SYMBOL(netif_rx);
-- 
2.34.1

