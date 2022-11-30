Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3048463DCFB
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 19:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbiK3ST3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 13:19:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbiK3STM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 13:19:12 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A4828D649
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 10:16:22 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id s141so1906074oie.10
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 10:16:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BZx3c6pdH3tvbbV8hd9d5C+kOw6FjAWMt/tV6RWix8Y=;
        b=oBDpW4gxowQLjwbJ4RHVMMkexMHrXMKjhTZQiyPABVqPYrQ7s01TUq7w7ZZQI5r4Kc
         xu0yJ8r8HcgO+Nip5velLlgN0y+gGXA0vL+fjBPBfHGMF/OM2vvp/pnSvvU4WT0/+MIh
         M71zdaOSYzXBAjKLzTCXd0oAQ3DD1ySOkIDek=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BZx3c6pdH3tvbbV8hd9d5C+kOw6FjAWMt/tV6RWix8Y=;
        b=i//sF5B/lO/SV6IJ5KE/LT9ZZk1UkqNmAEwAI0lc83VIXF2cyAUaGEhI5oFt7QKo5d
         5e3HR1Obhm4QtnDeK/U0LuQ4dE2AjFrQjFxRd6z4ojAuMSIq9Ar/frB++zheg4zhYauh
         Xw3XWg9uTkcpMVB8+5mqob/sRR5bXmrZZbJgpRWgnmxjsG44zFtpB8XkaigPxl/YE8Pi
         Lc2Vb5Ft9JETydQ4vgULyTjjuX+HsuyqdQK4euQ5kCq/KUew6QeqzyvLBdF9LwzSPlWL
         X9gyB/JTLT3mXB06zLiMd/P5nLhtHy/qdheGodInh6s6SyduBpzc1uyq1Xjg1+qwzRK0
         LDyA==
X-Gm-Message-State: ANoB5pnL6M92jI0/IrPq7pL3wF6+FpjKeucSCbF8XqCLxQdGmfNihwoI
        M6BS9hHXOLyPYORa8gGJ85CjhKrph3BKLqNqoX9B3w==
X-Google-Smtp-Source: AA0mqf6ktv4Mbw61Q5evf5XgM9SEqSo3B9f7VRAeR5VeuVYN1GfdLs+BjPg/oU+Mvra8qnf8D7T0V+5TYSr+T+2Sxns=
X-Received: by 2002:a05:6808:1a09:b0:354:4a36:aa32 with SMTP id
 bk9-20020a0568081a0900b003544a36aa32mr32435098oib.15.1669832181662; Wed, 30
 Nov 2022 10:16:21 -0800 (PST)
MIME-Version: 1.0
References: <20221130181316.GA1012431@paulmck-ThinkPad-P17-Gen-1> <20221130181325.1012760-14-paulmck@kernel.org>
In-Reply-To: <20221130181325.1012760-14-paulmck@kernel.org>
From:   Joel Fernandes <joel@joelfernandes.org>
Date:   Wed, 30 Nov 2022 18:16:11 +0000
Message-ID: <CAEXW_YS1nfsV_ohXDaB1i2em=+0KP1DofktS24oGFa4wPAbiiw@mail.gmail.com>
Subject: Re: [PATCH rcu 14/16] rxrpc: Use call_rcu_hurry() instead of call_rcu()
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     rcu@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@meta.com, rostedt@goodmis.org,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

Could you give your ACK for this patch?

The networking testing passed on ChromeOS and it has been in -next for
some time so has gotten testing there. The CONFIG option is default
disabled.

Thanks a lot,

- Joel

On Wed, Nov 30, 2022 at 6:13 PM Paul E. McKenney <paulmck@kernel.org> wrote:
>
> From: "Joel Fernandes (Google)" <joel@joelfernandes.org>
>
> Earlier commits in this series allow battery-powered systems to build
> their kernels with the default-disabled CONFIG_RCU_LAZY=y Kconfig option.
> This Kconfig option causes call_rcu() to delay its callbacks in order
> to batch them.  This means that a given RCU grace period covers more
> callbacks, thus reducing the number of grace periods, in turn reducing
> the amount of energy consumed, which increases battery lifetime which
> can be a very good thing.  This is not a subtle effect: In some important
> use cases, the battery lifetime is increased by more than 10%.
>
> This CONFIG_RCU_LAZY=y option is available only for CPUs that offload
> callbacks, for example, CPUs mentioned in the rcu_nocbs kernel boot
> parameter passed to kernels built with CONFIG_RCU_NOCB_CPU=y.
>
> Delaying callbacks is normally not a problem because most callbacks do
> nothing but free memory.  If the system is short on memory, a shrinker
> will kick all currently queued lazy callbacks out of their laziness,
> thus freeing their memory in short order.  Similarly, the rcu_barrier()
> function, which blocks until all currently queued callbacks are invoked,
> will also kick lazy callbacks, thus enabling rcu_barrier() to complete
> in a timely manner.
>
> However, there are some cases where laziness is not a good option.
> For example, synchronize_rcu() invokes call_rcu(), and blocks until
> the newly queued callback is invoked.  It would not be a good for
> synchronize_rcu() to block for ten seconds, even on an idle system.
> Therefore, synchronize_rcu() invokes call_rcu_hurry() instead of
> call_rcu().  The arrival of a non-lazy call_rcu_hurry() callback on a
> given CPU kicks any lazy callbacks that might be already queued on that
> CPU.  After all, if there is going to be a grace period, all callbacks
> might as well get full benefit from it.
>
> Yes, this could be done the other way around by creating a
> call_rcu_lazy(), but earlier experience with this approach and
> feedback at the 2022 Linux Plumbers Conference shifted the approach
> to call_rcu() being lazy with call_rcu_hurry() for the few places
> where laziness is inappropriate.
>
> And another call_rcu() instance that cannot be lazy is the one
> in rxrpc_kill_connection(), which sometimes does a wakeup
> that should not be unduly delayed.
>
> Therefore, make rxrpc_kill_connection() use call_rcu_hurry() in order
> to revert to the old behavior.
>
> [ paulmck: Apply s/call_rcu_flush/call_rcu_hurry/ feedback from Tejun Heo. ]
>
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Marc Dionne <marc.dionne@auristor.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: <linux-afs@lists.infradead.org>
> Cc: <netdev@vger.kernel.org>
> Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> ---
>  net/rxrpc/conn_object.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/rxrpc/conn_object.c b/net/rxrpc/conn_object.c
> index 22089e37e97f0..9c5fae9ca106c 100644
> --- a/net/rxrpc/conn_object.c
> +++ b/net/rxrpc/conn_object.c
> @@ -253,7 +253,7 @@ void rxrpc_kill_connection(struct rxrpc_connection *conn)
>          * must carry a ref on the connection to prevent us getting here whilst
>          * it is queued or running.
>          */
> -       call_rcu(&conn->rcu, rxrpc_destroy_connection);
> +       call_rcu_hurry(&conn->rcu, rxrpc_destroy_connection);
>  }
>
>  /*
> --
> 2.31.1.189.g2e36527f23
>
