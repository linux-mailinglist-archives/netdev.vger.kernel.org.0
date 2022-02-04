Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD1A64A9BE1
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 16:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359671AbiBDPVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 10:21:01 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:60628 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347891AbiBDPU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 10:20:59 -0500
Date:   Fri, 4 Feb 2022 16:20:56 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1643988058;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O2RFL13NjK+pKjOuoDC1J7i7UNoyTCUYPoTKwMLms+o=;
        b=wVC/a5wHNyzZAr0WzaugTL+xKpW3ZCSOYqfaSw+zTvJu9tBDU6JxFRSvWVlTJwTb4KBH4A
        WmhPJikz3hZVUkuGhyQVsGvo2Gf8448W2FPpoGR3dg1l+LnYkymHXeT0pv+Na76JaDqKbI
        tafkGD82IjwywXwJQ5vWuYFykJ/6dwtlsw6wBxuEr9OQg0b63GOPRDufqLyRAsTnT7jjpu
        G0IjKkVc5rxvEgQo9RzXGSTE39mMX3+QCYgBhKmA+grw6TJRid3QU5k+IV5nqZwO7rkvbx
        mC6mQhdlJPSQJi7Cqcw06elP0XNpAokN+UyVBzDT0ngZ4a8jo6YjWAgd/7Ui1A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1643988058;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O2RFL13NjK+pKjOuoDC1J7i7UNoyTCUYPoTKwMLms+o=;
        b=UQSH/uiXDSs+U1ZC/1bwLAdfjvLLftPRRx95Nozj4Hgjlox31dk3z2Q7NVETa5bmAybEBh
        vC3GKZcojjZr0jCw==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc:     Eric Dumazet <edumazet@google.com>, bpf <bpf@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH net-next v2 1/4] net: dev: Remove preempt_disable() and
 get_cpu() in netif_rx_internal().
Message-ID: <Yf1EWFgPtjIq3Hzw@linutronix.de>
References: <20220202122848.647635-1-bigeasy@linutronix.de>
 <20220202122848.647635-2-bigeasy@linutronix.de>
 <CANn89iJm9krQ-kjVBxFzxh0nG46O5RWDg=QyXhiq1nA3Erf9KQ@mail.gmail.com>
 <87v8xwb1o9.fsf@toke.dk>
 <YfvH9YpKTIU4EByk@linutronix.de>
 <87leysazrq.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <87leysazrq.fsf@toke.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The preempt_disable() () section was introduced in commit
    cece1945bffcf ("net: disable preemption before call smp_processor_id()")

and adds it in case this function is invoked from preemtible context and
because get_cpu() later on as been added.

The get_cpu() usage was added in commit
    b0e28f1effd1d ("net: netif_rx() must disable preemption")

because ip_dev_loopback_xmit() invoked netif_rx() with enabled preemption
causing a warning in smp_processor_id(). The function netif_rx() should
only be invoked from an interrupt context which implies disabled
preemption. The commit
   e30b38c298b55 ("ip: Fix ip_dev_loopback_xmit()")

was addressing this and replaced netif_rx() with in netif_rx_ni() in
ip_dev_loopback_xmit().

Based on the discussion on the list, the former patch (b0e28f1effd1d)
should not have been applied only the latter (e30b38c298b55).

Remove get_cpu() and preempt_disable() since the function is supposed to
be invoked from context with stable per-CPU pointers. Bottom halves have
to be disabled at this point because the function may raise softirqs
which need to be processed.

Link: https://lkml.kernel.org/r/20100415.013347.98375530.davem@davemloft.net
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
v1=E2=80=A6v2:
  - merge patch 1 und 2 from the series (as per Toke).
  - updated patch description and corrected the first commit number (as
    per Eric).

 net/core/dev.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 1baab07820f65..0d13340ed4054 100644
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
@@ -4806,14 +4805,12 @@ static int netif_rx_internal(struct sk_buff *skb)
 		ret =3D enqueue_to_backlog(skb, cpu, &rflow->last_qtail);
=20
 		rcu_read_unlock();
-		preempt_enable();
 	} else
 #endif
 	{
 		unsigned int qtail;
=20
-		ret =3D enqueue_to_backlog(skb, get_cpu(), &qtail);
-		put_cpu();
+		ret =3D enqueue_to_backlog(skb, smp_processor_id(), &qtail);
 	}
 	return ret;
 }
--=20
2.34.1

