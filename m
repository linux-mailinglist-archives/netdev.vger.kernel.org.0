Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF7DC4B3161
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 00:39:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354221AbiBKXiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 18:38:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354209AbiBKXix (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 18:38:53 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2508BCF9;
        Fri, 11 Feb 2022 15:38:51 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1644622728;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ATsKdC9KCgLlEgJacS2PBoSxU0nFqsevos/PGJKezXU=;
        b=cQ7hBRqaMWADLhipEsKziFOmqxZUWzgHN9VxFkF0uY4ObkSujk8fEkG7FLS2VwoW6uW/2b
        F8JExNOV7bOjRR6pR+1Tlxrqk+v5W3EWk9uIvObi3HdTCkJfn7Zdh+9tQuwiXovJj4NQUG
        YDVO6cNSGLKkuOZ+jkQfwxRHwlgY6v1v298B+iWW3Hv8w9LVdMvx1AYrLki+a0Mb2lJs+Y
        zqw8tyLFtYmVBcZEBg+25PkB1TMHwLHwQXsNv7jgU6f+CDVA8AhdMGZStJgyNx8INwVOWy
        nOAQmKlYrMo+mYfTPddku7vUc3wW8cRbxO+Pa7bTvdrPb5orqkdbi42EwzXWSg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1644622728;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ATsKdC9KCgLlEgJacS2PBoSxU0nFqsevos/PGJKezXU=;
        b=fyrL32tObXtcpqWOqWPU5CEaaZkmt2j4OZnylBrqv5lMQj95j+R4DOySaWd408uKn6V1uJ
        OSCBjzOwDF+XiaDw==
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
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH net-next v3 1/3] net: dev: Remove preempt_disable() and get_cpu() in netif_rx_internal().
Date:   Sat, 12 Feb 2022 00:38:37 +0100
Message-Id: <20220211233839.2280731-2-bigeasy@linutronix.de>
In-Reply-To: <20220211233839.2280731-1-bigeasy@linutronix.de>
References: <20220211233839.2280731-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
Reviewed-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
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

