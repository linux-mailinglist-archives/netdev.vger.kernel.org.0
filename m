Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6231466BB05
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 10:55:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbjAPJzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 04:55:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbjAPJz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 04:55:28 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 779DA17CD0
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 01:54:55 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id c124so29599334ybb.13
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 01:54:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wu9td4ZRw+3rlrum00pYyaH6eULDTV19+cq5J6k5AKE=;
        b=Br4MTMaSVSXIVN1w+T0iS6EMQBtrqn8dhHIWOvvDY2TFrFtCVOWPsCb7WG366TSIzY
         9N6KakVUJkyXGTLeOJ4XSJvTNZzazACjXsI4rxsXiLxmZlgqIDZCvPo5RGMBLY0jybPm
         uLbFcuxtrseJmHu6iAtB/tJw1KN9usHhNhRoWq2OPSinjs61rlKklt7UmrRqH9Wu3z+p
         Z1E7Cjv/9KZ/eC8JNY1iJkhEHORH5LVDEmsatdcpOxjyL0zVx8ab7lOpcjWpcqALpDNV
         DIsahZEy7qsZ53Bb8CVea/1VrGse9VFp7P5PUCeDgXT/9UL/k99vv5cFOZ2BEsiOCLS/
         TG7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wu9td4ZRw+3rlrum00pYyaH6eULDTV19+cq5J6k5AKE=;
        b=EjozN/zLdftwWp7jZVc09ynq3prnt09FXTAh2bJQkazU6ZDsRmGnE4g0TiIcgssXDm
         NWjVw1zRFqUvjLoK3bQOQ523q9phL4AuKRaXkPNdaVoCdmx0oNJG4PlomTIOW0uDd7Kg
         N4YL/G/S0aQ8SMUcozfyvlTC5aITPKt7arLdzSVppfJONxiHdG1gh8g+NjhYv72vl84K
         ytmK177JNi9Fg6RyQjbIdY7UzLGwmpbMZDF81+CYQqAMPopYRhHVqkQwwCJw4xy0bWs7
         DK8ktrRha466tJ/Ko7NdG77FK2fIP1G187lipRky7n1jtqh5CiyMbMLMWrIHngL6Aa5C
         qa+w==
X-Gm-Message-State: AFqh2kpijcMONtaonVCdmbBOh3cUbnBkVBUQAqxGqxLt6j/sqnC8JlWF
        +hU8vTqPGlekHQ6utT5abzTlNyBiJNqFLWRAOyUZPg==
X-Google-Smtp-Source: AMrXdXuXhPKdrl4WGoiIw1lBKw8acjyrGEo6zVHGq5YZFzcwBDOFNNSb7N5awMFTZRFxSyFPUvzzB/f78SenjmHA0kM=
X-Received: by 2002:a25:b7cb:0:b0:7e7:7ad8:2ee8 with SMTP id
 u11-20020a25b7cb000000b007e77ad82ee8mr120309ybj.55.1673862894433; Mon, 16 Jan
 2023 01:54:54 -0800 (PST)
MIME-Version: 1.0
References: <20230116073813.24097-1-kerneljasonxing@gmail.com>
In-Reply-To: <20230116073813.24097-1-kerneljasonxing@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 16 Jan 2023 10:54:43 +0100
Message-ID: <CANn89i+qCZOCSaNbqRxirS8zouAWJFpvPX51deT=bG9uxnJ4oA@mail.gmail.com>
Subject: Re: [PATCH v4 net] tcp: avoid the lookup process failing to get sk in
 ehash table
To:     Jason Xing <kerneljasonxing@gmail.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
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

On Mon, Jan 16, 2023 at 8:38 AM Jason Xing <kerneljasonxing@gmail.com> wrote:
>
> From: Jason Xing <kernelxing@tencent.com>
>
> While one cpu is working on looking up the right socket from ehash
> table, another cpu is done deleting the request socket and is about
> to add (or is adding) the big socket from the table. It means that
> we could miss both of them, even though it has little chance.
>
>
> Fixes: 5e0724d027f0 ("tcp/dccp: fix hashdance race for passive sessions")
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Jason Xing <kernelxing@tencent.com>
> Link: https://lore.kernel.org/lkml/20230112065336.41034-1-kerneljasonxing@gmail.com/
> ---
> v4:
> 1) adjust the code style and make it easier to read.
>
> v3:
> 1) get rid of else-if statement.
>
> v2:
> 1) adding the sk node into the tail of list to prevent the race.
> 2) fix the race condition when handling time-wait socket hashdance.
> ---
>  net/ipv4/inet_hashtables.c    | 18 ++++++++++++++++--
>  net/ipv4/inet_timewait_sock.c |  6 +++---
>  2 files changed, 19 insertions(+), 5 deletions(-)
>
> diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> index 24a38b56fab9..c64eec874b31 100644
> --- a/net/ipv4/inet_hashtables.c
> +++ b/net/ipv4/inet_hashtables.c
> @@ -650,8 +650,21 @@ bool inet_ehash_insert(struct sock *sk, struct sock *osk, bool *found_dup_sk)
>         spin_lock(lock);
>         if (osk) {
>                 WARN_ON_ONCE(sk->sk_hash != osk->sk_hash);
> -               ret = sk_nulls_del_node_init_rcu(osk);
> -       } else if (found_dup_sk) {
> +               if (sk_hashed(osk)) {
> +                       /* Before deleting the node, we insert a new one to make
> +                        * sure that the look-up-sk process would not miss either
> +                        * of them and that at least one node would exist in ehash
> +                        * table all the time. Otherwise there's a tiny chance
> +                        * that lookup process could find nothing in ehash table.
> +                        */
> +                       __sk_nulls_add_node_tail_rcu(sk, list);
> +                       sk_nulls_del_node_init_rcu(osk);
> +               } else {
> +                       ret = false;


Well, you added another 'else' statement...

What about the following ?

diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 24a38b56fab9e9d7d893e23b30d26e275359ec70..1bcf5ce8dd1317b2144bcb47a2ad238532b9accf
100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -650,8 +650,14 @@ bool inet_ehash_insert(struct sock *sk, struct
sock *osk, bool *found_dup_sk)
        spin_lock(lock);
        if (osk) {
                WARN_ON_ONCE(sk->sk_hash != osk->sk_hash);
-               ret = sk_nulls_del_node_init_rcu(osk);
-       } else if (found_dup_sk) {
+               ret = sk_hashed(osk);
+               if (ret) {
+                       __sk_nulls_add_node_tail_rcu(sk, list);
+                       sk_nulls_del_node_init_rcu(osk);
+               }
+               goto unlock;
+       }
+       if (found_dup_sk) {
                *found_dup_sk = inet_ehash_lookup_by_sk(sk, list);
                if (*found_dup_sk)
                        ret = false;
@@ -659,7 +665,7 @@ bool inet_ehash_insert(struct sock *sk, struct
sock *osk, bool *found_dup_sk)

        if (ret)
                __sk_nulls_add_node_rcu(sk, list);
-
+unlock:
        spin_unlock(lock);

        return ret;
