Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9769637EE9
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 19:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbiKXSaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 13:30:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbiKXSaD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 13:30:03 -0500
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89A2F7F5B6;
        Thu, 24 Nov 2022 10:30:02 -0800 (PST)
Received: by mail-pf1-f179.google.com with SMTP id z26so2234552pff.1;
        Thu, 24 Nov 2022 10:30:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WrSnhGawiziKZAId0CeNhvCQHmhWxr93tkPNnVumOac=;
        b=uz4oatpsUcCU63j1kDRGQJ8ORtnBzg8f8HYWoQcPY9m0+/QxJmIl74NXAFVimqxY2R
         m4SGVKwR12Bss2ScfQKiZQ8RZBvH0T1lg9dWhOuP5NIotlcHM9BRcUysd8XUUO12eNGL
         XUR9mLrWpqpzmGQPQXQ0+vOO2i2pGSHHwxywblKe2IVAiBP6kiKmlMxN2mB0wGAJiwNl
         sJAbB9djiwdfDGm54GZBwhrmlESxQEnaibHEQV9tOdqEjyKndIWqkiQucg6Y7hWjkkSr
         JAXQtpLj1u9cbXjYbo+HLJjH4ZEkIHJfg/95eyFl7Scr80948IDHnwDuto8iqDPR0LLt
         vRhQ==
X-Gm-Message-State: ANoB5pm4379LsKAH+VUdmlIYQiTMUDrbzjCDGTt/L6zip3Gulqu5mLxa
        vlDq+xDoRCSV3jUbc8zTi5DQ3bEc7D9vwg==
X-Google-Smtp-Source: AA0mqf6pTXdH4ZH6sALO8n6314OUrJtTNyU3o/CIADgkNOAEtjQYd+tijx4B28a/3VUCuGmoT5V6Sw==
X-Received: by 2002:aa7:8d0e:0:b0:574:6a48:3fd9 with SMTP id j14-20020aa78d0e000000b005746a483fd9mr7156061pfe.36.1669314601744;
        Thu, 24 Nov 2022 10:30:01 -0800 (PST)
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com. [209.85.214.175])
        by smtp.gmail.com with ESMTPSA id t19-20020a170902e1d300b0017a09ebd1e2sm1603927pla.237.2022.11.24.10.30.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Nov 2022 10:30:01 -0800 (PST)
Received: by mail-pl1-f175.google.com with SMTP id y4so2085072plb.2;
        Thu, 24 Nov 2022 10:30:01 -0800 (PST)
X-Received: by 2002:a17:903:2694:b0:188:53b9:f003 with SMTP id
 jf20-20020a170903269400b0018853b9f003mr15441266plb.170.1669314600835; Thu, 24
 Nov 2022 10:30:00 -0800 (PST)
MIME-Version: 1.0
References: <166919846440.1258552.9618708344491052554.stgit@warthog.procyon.org.uk>
 <166919852169.1258552.10370784990641295051.stgit@warthog.procyon.org.uk>
In-Reply-To: <166919852169.1258552.10370784990641295051.stgit@warthog.procyon.org.uk>
From:   Marc Dionne <marc.dionne@auristor.com>
Date:   Thu, 24 Nov 2022 14:29:49 -0400
X-Gmail-Original-Message-ID: <CAB9dFdsTCSnZcDezxyqQw7J_UVskB5QbcH2_BQKJqiohf=bRDQ@mail.gmail.com>
Message-ID: <CAB9dFdsTCSnZcDezxyqQw7J_UVskB5QbcH2_BQKJqiohf=bRDQ@mail.gmail.com>
Subject: Re: [PATCH net-next 07/17] rxrpc: Don't take spinlocks in the RCU
 callback functions
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 23, 2022 at 6:15 AM David Howells <dhowells@redhat.com> wrote:
>
> Don't take spinlocks in the RCU callback functions as these are run in
> softirq context - which then requires all other takers to use _bh-marked
> locks.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Marc Dionne <marc.dionne@auristor.com>
> cc: linux-afs@lists.infradead.org
> ---
>
>  net/rxrpc/call_object.c |   30 +++++++-----------------------
>  net/rxrpc/conn_object.c |   18 +++++++++---------
>  2 files changed, 16 insertions(+), 32 deletions(-)
>
> diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
> index 01ffe99516b8..d77b65bf3273 100644
> --- a/net/rxrpc/call_object.c
> +++ b/net/rxrpc/call_object.c
> @@ -613,36 +613,16 @@ void rxrpc_put_call(struct rxrpc_call *call, enum rxrpc_call_trace why)
>  /*
>   * Final call destruction - but must be done in process context.
>   */
> -static void rxrpc_destroy_call(struct work_struct *work)
> +static void rxrpc_destroy_call(struct rcu_head *rcu)
>  {
> -       struct rxrpc_call *call = container_of(work, struct rxrpc_call, processor);
> +       struct rxrpc_call *call = container_of(rcu, struct rxrpc_call, rcu);
>         struct rxrpc_net *rxnet = call->rxnet;
>
> -       rxrpc_delete_call_timer(call);
> -
> -       rxrpc_put_connection(call->conn, rxrpc_conn_put_call);
> -       rxrpc_put_peer(call->peer, rxrpc_peer_put_call);
>         kmem_cache_free(rxrpc_call_jar, call);
>         if (atomic_dec_and_test(&rxnet->nr_calls))
>                 wake_up_var(&rxnet->nr_calls);
>  }
>
> -/*
> - * Final call destruction under RCU.
> - */
> -static void rxrpc_rcu_destroy_call(struct rcu_head *rcu)
> -{
> -       struct rxrpc_call *call = container_of(rcu, struct rxrpc_call, rcu);
> -
> -       if (rcu_read_lock_held()) {
> -               INIT_WORK(&call->processor, rxrpc_destroy_call);
> -               if (!rxrpc_queue_work(&call->processor))
> -                       BUG();
> -       } else {
> -               rxrpc_destroy_call(&call->processor);
> -       }
> -}
> -
>  /*
>   * clean up a call
>   */
> @@ -663,8 +643,12 @@ void rxrpc_cleanup_call(struct rxrpc_call *call)
>         }
>         rxrpc_put_txbuf(call->tx_pending, rxrpc_txbuf_put_cleaned);
>         rxrpc_free_skb(call->acks_soft_tbl, rxrpc_skb_put_ack);
> +       rxrpc_delete_call_timer(call);

This is not safe to call directly here, since rxrpc_cleanup_call can
be called from the timer function, so the del_timer_sync may wait
forever.

> +
> +       rxrpc_put_connection(call->conn, rxrpc_conn_put_call);
> +       rxrpc_put_peer(call->peer, rxrpc_peer_put_call);
>
> -       call_rcu(&call->rcu, rxrpc_rcu_destroy_call);
> +       call_rcu(&call->rcu, rxrpc_destroy_call);
>  }
>
>  /*
> diff --git a/net/rxrpc/conn_object.c b/net/rxrpc/conn_object.c
> index f7c271a740ed..54821c2f6d89 100644
> --- a/net/rxrpc/conn_object.c
> +++ b/net/rxrpc/conn_object.c
> @@ -249,6 +249,15 @@ void rxrpc_kill_connection(struct rxrpc_connection *conn)
>          */
>         rxrpc_purge_queue(&conn->rx_queue);
>
> +       del_timer_sync(&conn->timer);
> +       rxrpc_purge_queue(&conn->rx_queue);
> +
> +       conn->security->clear(conn);
> +       key_put(conn->key);
> +       rxrpc_put_bundle(conn->bundle, rxrpc_bundle_put_conn);
> +       rxrpc_put_peer(conn->peer, rxrpc_peer_put_conn);
> +       rxrpc_put_local(conn->local, rxrpc_local_put_kill_conn);
> +
>         /* Leave final destruction to RCU.  The connection processor work item
>          * must carry a ref on the connection to prevent us getting here whilst
>          * it is queued or running.
> @@ -358,17 +367,8 @@ static void rxrpc_destroy_connection(struct rcu_head *rcu)
>
>         ASSERTCMP(refcount_read(&conn->ref), ==, 0);
>
> -       del_timer_sync(&conn->timer);
> -       rxrpc_purge_queue(&conn->rx_queue);
> -
> -       conn->security->clear(conn);
> -       key_put(conn->key);
> -       rxrpc_put_bundle(conn->bundle, rxrpc_bundle_put_conn);
> -       rxrpc_put_peer(conn->peer, rxrpc_peer_put_conn);
> -
>         if (atomic_dec_and_test(&conn->local->rxnet->nr_conns))
>                 wake_up_var(&conn->local->rxnet->nr_conns);
> -       rxrpc_put_local(conn->local, rxrpc_local_put_kill_conn);
>
>         kfree(conn);
>         _leave("");
