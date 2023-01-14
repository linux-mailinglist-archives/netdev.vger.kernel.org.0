Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5D366A890
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 03:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbjANCPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 21:15:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230411AbjANCP3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 21:15:29 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13E742AD1;
        Fri, 13 Jan 2023 18:15:28 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id s6so1309338edd.13;
        Fri, 13 Jan 2023 18:15:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=08xKjRAaUU5vL4m6asSrruqwqR53UH8i8ksNXZDwM04=;
        b=MDuaIl5FHKh5OpugPjoRptOP4kHc8A1VwRxiV+IHCTR6CY1/PJh6YTUYBZM2JmkPwy
         N8pKb+j47KwWfvz3Ci45QpgHgkqoO3ephz6x9AeVmW6D6xcA5+HaY4Jst29eIjNVM/Rp
         sqffby4Z50NqUfmj4NiUMWXp5CaZ4ejYsKT6XFdWoU/dEr3InS7WFZP7aaEsp1v3/N+k
         p90C6UlCaq7tFKEONb/CtZshJZ4byXbLO3SunD5zhk3cwpe7AzPo4ZZZtOQqldn5cl0Y
         TwfuuZm/QbHtQzVOd9b2GSSNtNEPNgZjb1dNhc3EoYEWgOw/O8SFfmzhL1CmeWB3PYwt
         66BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=08xKjRAaUU5vL4m6asSrruqwqR53UH8i8ksNXZDwM04=;
        b=40lm8aYRgDKFcwp8vvZhFrwFByctdcaz1qvhD41H0PV3p/+b1N1C2eO8AxnCfNaEcb
         MtT0KXl+U9ryZHGEqlrVx/lmfS4AYm4KGDVkre197HGDzeG+uDV36I9g3oz2vckjL3zp
         C2zjhB9JZGkNlEgW8Es6kctY+8BxY4Xav4lDSRCl9Z4Ppund8r7BxBjFSkcx4ev63OId
         2sbB5OC0H4SjTGGtIURquclv/T0VvwDjWOsqIyz/JzgrTEzRBFX2BTkbFNQcYwylhebl
         9xntcvSvigr/LgGmwJqwGcjcj898F1QWCkCfne629ZTPcXREkCzgM8hyAv+GvgmXT1RV
         ABAA==
X-Gm-Message-State: AFqh2koNMWisr73BQXVrhZySH+iVKeM1H1dvp9H2RmZI+tlFx9Uv1TOF
        avIXrNuxoonFDjjcXHBFXmOxTVqivCn+wwd7svM=
X-Google-Smtp-Source: AMrXdXtALo2wVHA89lvdV+tPiDnBoZSqAmNKXN1BfE2N0UtUumGEDqOLRPlfkKuuhzD3eo3fEga/jX98DrU+beviaTI=
X-Received: by 2002:a50:ff0d:0:b0:499:cf8b:35a9 with SMTP id
 a13-20020a50ff0d000000b00499cf8b35a9mr1592068edu.126.1673662526461; Fri, 13
 Jan 2023 18:15:26 -0800 (PST)
MIME-Version: 1.0
References: <20230112065336.41034-1-kerneljasonxing@gmail.com>
In-Reply-To: <20230112065336.41034-1-kerneljasonxing@gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Sat, 14 Jan 2023 10:14:50 +0800
Message-ID: <CAL+tcoB2ZpgM6HM+m=wF2EkQ5caeettcbeUQQBxpLWVuwSSxbw@mail.gmail.com>
Subject: Re: [PATCH net] tcp: avoid the lookup process failing to get sk in
 ehash table
To:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, pabeni@redhat.com, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 12, 2023 at 2:54 PM Jason Xing <kerneljasonxing@gmail.com> wrot=
e:
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

I extracted one part from the commit 5e0724d027f0 as follows.

@@ -423,30 +423,41 @@ int inet_ehash_insert(struct sock *sk, struct sock *o=
sk)
=E2=80=A6=E2=80=A6
-     __sk_nulls_add_node_rcu(sk, list);
      if (osk) {
-         WARN_ON(sk->sk_hash !=3D osk->sk_hash);
-         sk_nulls_del_node_init_rcu(osk);
+        WARN_ON_ONCE(sk->sk_hash !=3D osk->sk_hash);
+        ret =3D sk_nulls_del_node_init_rcu(osk);
      }
+    if (ret)
+         __sk_nulls_add_node_rcu(sk, list);
=E2=80=A6=E2=80=A6

In this patch I submitted, I reverse, or we can say, restore the
original order of inserting and deleting before the commit
5e0724d027f0 as Eric suggested.

I believe it does not have an impact on other user cases.  The only
thing I want to do is fix this issue as soon as possible no matter
what exactly kind of patch gets merged and who writes the patch at
last if there is a better one.
At that time I'll get the big information back to my customers who
complain about this issue more often than not and tell them "see the
kernel community settles completely".

So could someone please take some time to help me review the patch?
It's not complicated. Thank you from the bottom of my heart in
advance.

Jason

> Signed-off-by: Jason Xing <kernelxing@tencent.com>
> ---
>  net/ipv4/inet_hashtables.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> index 24a38b56fab9..18f88cb4efcb 100644
> --- a/net/ipv4/inet_hashtables.c
> +++ b/net/ipv4/inet_hashtables.c
> @@ -650,7 +650,16 @@ bool inet_ehash_insert(struct sock *sk, struct sock =
*osk, bool *found_dup_sk)
>         spin_lock(lock);
>         if (osk) {
>                 WARN_ON_ONCE(sk->sk_hash !=3D osk->sk_hash);
> +               if (sk_hashed(osk))
> +                       /* Before deleting the node, we insert a new one =
to make
> +                        * sure that the look-up=3Dsk process would not m=
iss either
> +                        * of them and that at least one node would exist=
 in ehash
> +                        * table all the time. Otherwise there's a tiny c=
hance
> +                        * that lookup process could find nothing in ehas=
h table.
> +                        */
> +                       __sk_nulls_add_node_rcu(sk, list);
>                 ret =3D sk_nulls_del_node_init_rcu(osk);
> +               goto unlock;
>         } else if (found_dup_sk) {
>                 *found_dup_sk =3D inet_ehash_lookup_by_sk(sk, list);
>                 if (*found_dup_sk)
> @@ -660,6 +669,7 @@ bool inet_ehash_insert(struct sock *sk, struct sock *=
osk, bool *found_dup_sk)
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
