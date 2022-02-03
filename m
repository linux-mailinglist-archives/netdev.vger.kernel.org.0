Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6E14A83AE
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 13:18:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240746AbiBCMSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 07:18:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbiBCMSA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 07:18:00 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45870C061714;
        Thu,  3 Feb 2022 04:18:00 -0800 (PST)
Date:   Thu, 3 Feb 2022 13:17:57 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1643890678;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vvn8qgUi3T3ikktOAwWXqGPzvzbNPGlVe9HhrvIFYuo=;
        b=sjqmL5ZfHGC77vXR5Jo0NQN/xqnwPtFKGzTAXRv0EwNWSD9OgENJfsJHrz/Ojmp29YcNrK
        UKzqKONRghqJ+Nbqrllii2HAQPxBSIuPs1uDbVkwPIPiiOuXV6CSBZ3Uou2r0mcQdQjGtW
        8ZXyfNzo9hkhyc1XNUGnRkv6GpQm6Lb4XlgDboxT7CasX0Y4rrGBe2YeKARwCIBGktyP18
        2zkQpdG12Z2QLBguj/ksT+OTjWUpcTuGT42YGr0fZ+4D+9HFLzjf06mNi+Ibo9rCBKjJgE
        ABq0IC+L6uwVOggpB5nOhlbmhLx5sDXWI6IwKOYlblUZH3FhCOnMfqenmikVuA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1643890678;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vvn8qgUi3T3ikktOAwWXqGPzvzbNPGlVe9HhrvIFYuo=;
        b=HAIt09ok8U/cmfQzjyvMQahScg5rVD6tOQp+rS5uuoAcgR91L2pwtX+fltrZ3WZNLZsiM/
        4sgGFtvVl3s5J9Cg==
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
Subject: Re: [PATCH net-next 1/4] net: dev: Remove the preempt_disable() in
 netif_rx_internal().
Message-ID: <YfvH9YpKTIU4EByk@linutronix.de>
References: <20220202122848.647635-1-bigeasy@linutronix.de>
 <20220202122848.647635-2-bigeasy@linutronix.de>
 <CANn89iJm9krQ-kjVBxFzxh0nG46O5RWDg=QyXhiq1nA3Erf9KQ@mail.gmail.com>
 <87v8xwb1o9.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <87v8xwb1o9.fsf@toke.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-02-03 13:00:06 [+0100], Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > Here is the code in larger context:
> >
> > #ifdef CONFIG_RPS
> >     if (static_branch_unlikely(&rps_needed)) {
> >         struct rps_dev_flow voidflow, *rflow =3D &voidflow;
> >         int cpu;
> >
> >         preempt_disable();
> >         rcu_read_lock();
> >
> >         cpu =3D get_rps_cpu(skb->dev, skb, &rflow);
> >         if (cpu < 0)
> >             cpu =3D smp_processor_id();
> >
> >         ret =3D enqueue_to_backlog(skb, cpu, &rflow->last_qtail);
> >
> >         rcu_read_unlock();
> >         preempt_enable();
> >     } else
> > #endif
> >
> > This code needs the preempt_disable().
>=20
> This is mostly so that the CPU ID stays the same throughout that section
> of code, though, right? So wouldn't it work to replace the
> preempt_disable() with a migrate_disable()? That should keep _RT happy,
> no?

It would but as mentioned previously: BH is disabled and
smp_processor_id() is stable.

> -Toke

Sebastian
