Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 863A84A70CC
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 13:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344164AbiBBM3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 07:29:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344145AbiBBM25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 07:28:57 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD22C06173D;
        Wed,  2 Feb 2022 04:28:56 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1643804934;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K47l6RiCN9/QajBAo5t2g/2ZmVf5Mm+Chno5arbg/P0=;
        b=tIvFgOEIEpi+4iP6xggXWvqvQPe9d6VdvUOCoWhlkjn+3af6Lnw/fcn/WDd6FYh0yAb5dr
        Afp+58MgGSs6OKv1qy1pzkOLx5b89y4GR41zDajH0ZJ9wjkYSWtD75iP1oP3b0Fxjnfryv
        mTSLXfgDlN5XwD+BZNcU5+ejl4GYicde/2nWZB9yz/ycN+F8e+0hfMUuqj8J4wTcBplGxq
        oHObSPvBS9YcBqxUiORG6LqtZb3oFDS+IqYXXNbvkzJLOV6bXLp2iteeqQ/lCOV64MAe3Z
        LUFlLWN6V7/vqTdwRcgM7WuwWrleoAh8IZQtPhDace3g39NkX2+REeZ8ydTuKg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1643804934;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K47l6RiCN9/QajBAo5t2g/2ZmVf5Mm+Chno5arbg/P0=;
        b=SPBDuk+aUo4wGcYLrIe7o2u8KSzV09+TP43S/k9JOLMblMEuDDHg6A9eRCX2oJQMctqX1e
        6eZj0yE9zVsEEMBQ==
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
Subject: [PATCH net-next 1/4] net: dev: Remove the preempt_disable() in netif_rx_internal().
Date:   Wed,  2 Feb 2022 13:28:45 +0100
Message-Id: <20220202122848.647635-2-bigeasy@linutronix.de>
In-Reply-To: <20220202122848.647635-1-bigeasy@linutronix.de>
References: <20220202122848.647635-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The preempt_disable() and rcu_disable() section was introduced in commit
   bbbe211c295ff ("net: rcu lock and preempt disable missing around generic=
 xdp")

The backtrace shows that bottom halves were disabled and so the usage of
smp_processor_id() would not trigger a warning.
The "suspicious RCU usage" warning was triggered because
rcu_dereference() was not used in rcu_read_lock() section (only
rcu_read_lock_bh()). A rcu_read_lock() is sufficient.

Remove the preempt_disable() statement which is not needed.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 net/core/dev.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 1baab07820f65..325b70074f4ae 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4796,7 +4796,6 @@ static int netif_rx_internal(struct sk_buff *skb)
 		struct rps_dev_flow voidflow, *rflow =3D &voidflow;
 		int cpu;
=20
-		preempt_disable();
 		rcu_read_lock();
=20
 		cpu =3D get_rps_cpu(skb->dev, skb, &rflow);
@@ -4806,7 +4805,6 @@ static int netif_rx_internal(struct sk_buff *skb)
 		ret =3D enqueue_to_backlog(skb, cpu, &rflow->last_qtail);
=20
 		rcu_read_unlock();
-		preempt_enable();
 	} else
 #endif
 	{
--=20
2.34.1

