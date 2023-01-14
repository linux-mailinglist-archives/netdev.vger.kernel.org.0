Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E42066AAA3
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 10:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbjANJp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 04:45:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbjANJpi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 04:45:38 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F8BC6EA2
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 01:45:37 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id l139so25076558ybl.12
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 01:45:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vlkHxXRAjBY27dQMCNR+CzihlFwMuNW06sCOMehcAq0=;
        b=GHOUUpLRj6JqmyJ+OnKfQOyK4nGJxSufmjelFoejUpkbqGOrxcmSyXOJtt3s8s4u9G
         qia7s6/xIqHmMinGnDfCjJK44mjUY6y+asbzWFKEOA+PZFRoCGRSwgTKH0JW2ze33eKF
         9iRWXvOxsYM0sPsc+N4jN1IMDhlUf6+xASqm0NyOaCAEWz19SJQ+PiaWEEWD56Nf4XVT
         2ZeLe26sDJD69VNkXjPxJjT9czMWH8uWK85v+wdQkc/fvXZS7mTzhRYjhZRfn1h6ZdCI
         /RPAgvsiW6X5v7e5OEu+HG1QjQDCLChhO8zcGESFUVdk95UYCaSGqCFU4C8jBa+tbRgs
         tKRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vlkHxXRAjBY27dQMCNR+CzihlFwMuNW06sCOMehcAq0=;
        b=0hfZnNKmS+EGZnxR29ppBkhJM3srYnYYDdUasiKqmWVGb8GVtMX3XLZG1tqDH2sOeR
         IXyYwjtB/ghP4oGQiiwxApzQh2sJBTST1JHkb8UGSxkH/68Cb1WzrDoVedGWIUt/htKG
         DFI7AqnY/Lcpmqi6uIc9TOcq8K8oy033TFyrgBVHkp0JKRuHQXu5KWdp1xVS4kpJrbNP
         jVkD0BHIVDg+mr4nucxIhLVQV6V91/bs0wL9XXDmdl1gM2vjPCQ4pM+njfpm57mr+eAx
         yfiJ6JOk2Ltvb0vJv1IyNK7lNQsOa6AeFjWS75EdWtVXhSO12IhqquJGcKBuagVqRIs7
         AFyg==
X-Gm-Message-State: AFqh2kp7ju80ALidf0pGHGPoXIJDtYeYow26aGGgJeBnHFGKfrjUXmMn
        R8teodSosaBXyH5uyJ05T3cSg0XByNg8v5JODex/LQ==
X-Google-Smtp-Source: AMrXdXuYXKEa9LyboFMvv0dltRFS6i125pwCJVGtQZlEtAlthcfL9qbmcmgtR9CZ6ze8DvnU8x5L8SGOL0BDL2vwjzA=
X-Received: by 2002:a25:8f89:0:b0:7b3:bb8:9daf with SMTP id
 u9-20020a258f89000000b007b30bb89dafmr2207027ybl.427.1673689536628; Sat, 14
 Jan 2023 01:45:36 -0800 (PST)
MIME-Version: 1.0
References: <20230112065336.41034-1-kerneljasonxing@gmail.com>
In-Reply-To: <20230112065336.41034-1-kerneljasonxing@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 14 Jan 2023 10:45:23 +0100
Message-ID: <CANn89iKQjN1YiHqBTV3+zDYo0G11p-6=p7C-1GvFCp8Y=r4nvQ@mail.gmail.com>
Subject: Re: [PATCH net] tcp: avoid the lookup process failing to get sk in
 ehash table
To:     Jason Xing <kerneljasonxing@gmail.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org--cc, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 12, 2023 at 7:54 AM Jason Xing <kerneljasonxing@gmail.com> wrote:
>
> From: Jason Xing <kernelxing@tencent.com>
>
> While one cpu is working on looking up the right socket from ehash
> table, another cpu is done deleting the request socket and is about
> to add (or is adding) the big socket from the table. It means that
> we could miss both of them, even though it has little chance.
>
> Let me draw a call trace map of the server side.
>    CPU 0                           CPU 1
>    -----                           -----
> tcp_v4_rcv()                  syn_recv_sock()
>                             inet_ehash_insert()
>                             -> sk_nulls_del_node_init_rcu(osk)
> __inet_lookup_established()
>                             -> __sk_nulls_add_node_rcu(sk, list)
>
> Notice that the CPU 0 is receiving the data after the final ack
> during 3-way shakehands and CPU 1 is still handling the final ack.
>
> Why could this be a real problem?
> This case is happening only when the final ack and the first data
> receiving by different CPUs. Then the server receiving data with
> ACK flag tries to search one proper established socket from ehash
> table, but apparently it fails as my map shows above. After that,
> the server fetches a listener socket and then sends a RST because
> it finds a ACK flag in the skb (data), which obeys RST definition
> in RFC 793.
>
> Many thanks to Eric for great help from beginning to end.
>
> Fixes: 5e0724d027f0 ("tcp/dccp: fix hashdance race for passive sessions")
> Signed-off-by: Jason Xing <kernelxing@tencent.com>
> ---
>  net/ipv4/inet_hashtables.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> index 24a38b56fab9..18f88cb4efcb 100644
> --- a/net/ipv4/inet_hashtables.c
> +++ b/net/ipv4/inet_hashtables.c
> @@ -650,7 +650,16 @@ bool inet_ehash_insert(struct sock *sk, struct sock *osk, bool *found_dup_sk)
>         spin_lock(lock);
>         if (osk) {
>                 WARN_ON_ONCE(sk->sk_hash != osk->sk_hash);
> +               if (sk_hashed(osk))
> +                       /* Before deleting the node, we insert a new one to make
> +                        * sure that the look-up=sk process would not miss either
> +                        * of them and that at least one node would exist in ehash
> +                        * table all the time. Otherwise there's a tiny chance
> +                        * that lookup process could find nothing in ehash table.
> +                        */
> +                       __sk_nulls_add_node_rcu(sk, list);

In our private email exchange, I suggested to insert sk at the _tail_
of the hash bucket.

Inserting it at the _head_ would still leave a race condition, because
a concurrent reader might
have already started the bucket traversal, and would not see 'sk'.

Thanks.

>                 ret = sk_nulls_del_node_init_rcu(osk);
> +               goto unlock;
>         } else if (found_dup_sk) {
>                 *found_dup_sk = inet_ehash_lookup_by_sk(sk, list);
>                 if (*found_dup_sk)
> @@ -660,6 +669,7 @@ bool inet_ehash_insert(struct sock *sk, struct sock *osk, bool *found_dup_sk)
>         if (ret)
>                 __sk_nulls_add_node_rcu(sk, list);
>
> +unlock:
>         spin_unlock(lock);
>
>         return ret;
> --
> 2.37.3
>
