Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5C66A5D5C
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 17:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbjB1Qo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 11:44:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjB1Qo4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 11:44:56 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CDD73A90
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 08:44:50 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id v10so4276644iox.8
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 08:44:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FfmsfN9yp2EN+4ywAFL2ggInjXPUo3zC4y0F8+5nOJ0=;
        b=qii2vstoJhDDQmxVP95OVwvu/e4OxzFgxjZrErRM+y2RKmrhUgV1a5+f7CO8w8rTPa
         kgxCjekNkx/T2f9m1k3YCE9iIAA1xQa4I+6/33/HPIpBBSzwHUL3wPmD8NoX2O3dJnYv
         Zai6nsyu9TXqds5EHpkZj7X5OB2xirGKTDv/fs9zJbWWFtUu4S9LyLCRo/40rtiH+kus
         aPdp1ySuDCMWXV9uTWNTV7VznodDtEH8/T65jiHAv0/FW8V/RTMU1jpzOikW1dBXmkTD
         JpWyKqSMFqAKthaIs5O14F7ilVXvwxXZl6Q52BQOFhsoz6fW4Kk07z9Ntp/SKFb1Qg6W
         7iBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FfmsfN9yp2EN+4ywAFL2ggInjXPUo3zC4y0F8+5nOJ0=;
        b=4O6Ck9Y6tVOZePVYupUO/E+FztccAXSlntqgLhekJUDequrvJW5BwO4eEQPWB/z04L
         ZEyZ6EnHkv1Un576mph1XAO5NdV93JyUadB4+7rkocoeOexsMvI8KWjOaRN+1bnlXL4y
         MThVT1tohWeEZv7BnkXR4xlIqLMyklmUBneue+QgcY3AWjB0a/LdVdZ1z99DGrMinc93
         588O2Lm3Vyi+8o7rIE1XzDtAiPD5K90jUwNTqTcHlputjguFOHvXuVjis2J1ZxPqwhKu
         HIiq4FZQK1pHmlbk8NLO6vWifr6ydz42rwEgoClnbKzTPLxjUwacjfhawTMDOcd3l7+M
         47Gg==
X-Gm-Message-State: AO0yUKXQkyLHa9nTFz+3CpHsJeIXjwC8p/kN7C3kyw6t2l63YCQPTCzg
        8s0WHFeNtYO2m2iw/RStKWWd56eyeSOdyIYyriVPdg==
X-Google-Smtp-Source: AK7set+pCqh56QRCfpLhZIT2kLQNaBses72ZJvW7JFWRD4cQorQh6GbeJ4MeG5M4BQ7RVog7/XDwLmFVnVMm9o8EbZk=
X-Received: by 2002:a02:85a1:0:b0:3c5:14cb:a83a with SMTP id
 d30-20020a0285a1000000b003c514cba83amr1569476jai.2.1677602689574; Tue, 28 Feb
 2023 08:44:49 -0800 (PST)
MIME-Version: 1.0
References: <20230224184606.7101-1-fw@strlen.de>
In-Reply-To: <20230224184606.7101-1-fw@strlen.de>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 28 Feb 2023 17:44:38 +0100
Message-ID: <CANn89iJ+7X8kLjR2YrGbT64zGSu_XQfT_T5+WPQfheDmgQrf2A@mail.gmail.com>
Subject: Re: [PATCH net] net: avoid indirect memory pressure calls
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, shakeelb@google.com, soheil@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Fri, Feb 24, 2023 at 7:49=E2=80=AFPM Florian Westphal <fw@strlen.de> wro=
te:
>
> There is a noticeable tcp performance regression (loopback or cross-netns=
),
> seen with iperf3 -Z (sendfile mode) when generic retpolines are needed.
>
> With SK_RECLAIM_THRESHOLD checks gone number of calls to enter/leave
> memory pressure happen much more often. For TCP indirect calls are
> used.
>
> We can't remove the if-set-return short-circuit check in
> tcp_enter_memory_pressure because there are callers other than
> sk_enter_memory_pressure.  Doing a check in the sk wrapper too
> reduces the indirect calls enough to recover some performance.
>
> Before,
> 0.00-60.00  sec   322 GBytes  46.1 Gbits/sec                  receiver
>
> After:
> 0.00-60.04  sec   359 GBytes  51.4 Gbits/sec                  receiver
>
> "iperf3 -c $peer -t 60 -Z -f g", connected via veth in another netns.
>
> Fixes: 4890b686f408 ("net: keep sk->sk_forward_alloc as small as possible=
")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/core/sock.c | 22 +++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)
>
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 341c565dbc26..45d247112aa5 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -2809,22 +2809,26 @@ EXPORT_SYMBOL(sock_cmsg_send);
>
>  static void sk_enter_memory_pressure(struct sock *sk)

This one is probably not called under normal circumstances.

>  {
> -       if (!sk->sk_prot->enter_memory_pressure)
> +       unsigned long *memory_pressure =3D sk->sk_prot->memory_pressure;
> +
> +       if (!memory_pressure || READ_ONCE(*memory_pressure))
>                 return;
>
> -       sk->sk_prot->enter_memory_pressure(sk);
> +       if (sk->sk_prot->enter_memory_pressure)
> +               sk->sk_prot->enter_memory_pressure(sk);
>  }
>
>  static void sk_leave_memory_pressure(struct sock *sk)
>  {
> -       if (sk->sk_prot->leave_memory_pressure) {
> -               sk->sk_prot->leave_memory_pressure(sk);
> -       } else {
> -               unsigned long *memory_pressure =3D sk->sk_prot->memory_pr=
essure;
> +       unsigned long *memory_pressure =3D sk->sk_prot->memory_pressure;
>
> -               if (memory_pressure && READ_ONCE(*memory_pressure))
> -                       WRITE_ONCE(*memory_pressure, 0);
> -       }
> +       if (!memory_pressure || READ_ONCE(*memory_pressure) =3D=3D 0)
> +               return;
> +
> +       if (sk->sk_prot->leave_memory_pressure)
> +               sk->sk_prot->leave_memory_pressure(sk);
> +       else
> +               WRITE_ONCE(*memory_pressure, 0);
>  }
>

For this one, we have too callers.

First one (__sk_mem_reduce_allocated) is using

   if (sk_under_memory_pressure(sk)
     ...

So I wonder if for consistency we could use the same heuristic [1] ?

Note that [1] is memcg aware/ready.

 Refactoring of sk_enter_memory_pressure() and
sk_leave_memory_pressure() could wait net-next maybe...

[1]
diff --git a/net/core/sock.c b/net/core/sock.c
index 341c565dbc262fcece1c5b410609d910a68edcb0..0472f8559a10136672ce6647f13=
3367c81a93cb7
100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2993,7 +2993,8 @@ int __sk_mem_raise_allocated(struct sock *sk,
int size, int amt, int kind)

        /* Under limit. */
        if (allocated <=3D sk_prot_mem_limits(sk, 0)) {
-               sk_leave_memory_pressure(sk);
+               if (sk_under_memory_pressure(sk))
+                       sk_leave_memory_pressure(sk);
                return 1;
        }
