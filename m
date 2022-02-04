Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 741484AA0F6
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 21:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236065AbiBDUNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 15:13:14 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:33982 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236161AbiBDUNN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 15:13:13 -0500
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1644005591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QCmgpUgDwS0Xt6iqbhC+90E3w4XFzwZYhxrMmDSM8fk=;
        b=Q2M9ncMEY1gxOvmLnTIA3gJZ8qb/kn0zGFMsAoUP45KHP1aWZTXxyM/vzFrl12sPwwG2PN
        XYVzJOyJps4ilZnuymHPPxNMpIiaPSfpb1V2vb5IJ1QXsaKyMguJbaoiWtx7S9CxVWUyy8
        HrxpYfpEN2uLeLK/ji2Ybf8LMU+Wd4GUcom4dwdkAQD3wLbBRpGhFERbfM4pfBrRWh1O6g
        7zWgQuJJBCPS7bmirSIUk/JGDLpGSckmQGRqfFekS9mDoGfFLu2j489z5dJrHZ8Pxy56cb
        HKFRqge98cCfnOIMUMRvG1Z6geiAK5ihy8BtYeR3SdtWOK7cX3VpYlDxE3Mcmw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1644005591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QCmgpUgDwS0Xt6iqbhC+90E3w4XFzwZYhxrMmDSM8fk=;
        b=cGA8qcQ4ZdpC/jrEdV9aJsMWWrjCqD5U5UfDFHdC4SruadrnSB01/WvmJeest7BbJeUp8t
        vwwh8wPG6VNaoTAg==
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net-next v2 1/3] net: dev: Remove preempt_disable() and get_cpu() in netif_rx_internal().
Date:   Fri,  4 Feb 2022 21:12:57 +0100
Message-Id: <20220204201259.1095226-2-bigeasy@linutronix.de>
In-Reply-To: <20220204201259.1095226-1-bigeasy@linutronix.de>
References: <20220204201259.1095226-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
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
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
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

