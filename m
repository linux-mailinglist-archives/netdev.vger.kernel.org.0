Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1D15EEB6C
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 04:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234361AbiI2CFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 22:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234474AbiI2CFF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 22:05:05 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACCAEF8F80
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 19:05:03 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-354c7abf786so1344887b3.0
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 19:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=f1mRMNstfp0oU+nmSji3PZ99E2Ko9CadyHhA/0b7ZVY=;
        b=g+vc0etTbJBBLXzFAS8yKeHrBZt851C8B+4az5HoXVLTlk4sxKKM3q6pLNn2ijo8Bq
         gyMxtxcxrpk3AdmGx/O+7qSzAnax03XBstdOlK3kUjIGajONI0cGE/0Nc6jJKzb3T0Pm
         Y6NuoShfgjwLHApLiuv6PwM7d449HUqjV+m1OdsHbeHg6NaV1VF9wdyVXz6+dj1SNPCf
         kkuQPQtTuGawlMZK19wKjZ3u1DQu0r6j4CPWoTDg730Nd13/vfZBpjfinvw6Tt1ZpTSZ
         fkyf60Vfe5urQfOJIhpupuI03mQ3OOpFAqkNSCtLD+wmq9IcweLMdRbhZmwetuKi9EkP
         NtPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=f1mRMNstfp0oU+nmSji3PZ99E2Ko9CadyHhA/0b7ZVY=;
        b=X3Tt3Esh6XTXKT/kBZ1ahzWrJlsDgtXvKb6iqNibyVL5/upHvFMRUzcTqA52+eupFb
         Cbc4Y2zmPRjb6mXndqoUCuLJ4b4cUravA8uBBRY/wLTLAjJHJ3vIN4NGYKTElh3tteMN
         nyhw7hDWQMlk18EX2LiR5nipchI72AFLia2u5Ht9oIyygUkWa4zNNIxr2zDviMPYvHed
         nLdr+hJu4M3jxuN6O6ry2hGTWfR94b7YO4ZOn92nVWUOHW/klXdFYtbVIWxuVeXYKiFt
         pk9EDUi6UYeO25hXczDT4o1Ct+E+i1KGJC8gjh2whLX21GgeunT7sY+8gunUMelXpzgk
         qaTg==
X-Gm-Message-State: ACrzQf1gdTTwgg2Gw1cwq9kgzVzFLK7CB8CEWc4bi6bAJdoM+MYM2+0D
        CV+bbXJInchxnPUsfAXIJUudcCRav3WofsmcnMOiQg==
X-Google-Smtp-Source: AMsMyM7bNzFXGKCHRm7+OuTV+ImkGZi1Zf77Am7XvZsxwJ59F4KFrxldd6nnui+D+2CK+UpwE759F9Tb31L9h9jkMiM=
X-Received: by 2002:a81:4e0d:0:b0:351:99d8:1862 with SMTP id
 c13-20020a814e0d000000b0035199d81862mr930905ywb.278.1664417102609; Wed, 28
 Sep 2022 19:05:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220923224453.2351753-1-kafai@fb.com> <20220923224518.2353383-1-kafai@fb.com>
In-Reply-To: <20220923224518.2353383-1-kafai@fb.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 28 Sep 2022 19:04:51 -0700
Message-ID: <CANn89iLf+=AmMntTqy0HyOfbv6PASLsT+E4PhXMAX+xU1Zh2Yg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 4/5] bpf: tcp: Stop bpf_setsockopt(TCP_CONGESTION)
 in init ops to recur itself
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        kernel-team <kernel-team@fb.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Martin KaFai Lau <martin.lau@kernel.org>
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

On Fri, Sep 23, 2022 at 3:48 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> From: Martin KaFai Lau <martin.lau@kernel.org>
>
> When a bad bpf prog '.init' calls
> bpf_setsockopt(TCP_CONGESTION, "itself"), it will trigger this loop:
>
> .init => bpf_setsockopt(tcp_cc) => .init => bpf_setsockopt(tcp_cc) ...
> ... => .init => bpf_setsockopt(tcp_cc).
>
> It was prevented by the prog->active counter before but the prog->active
> detection cannot be used in struct_ops as explained in the earlier
> patch of the set.
>
> In this patch, the second bpf_setsockopt(tcp_cc) is not allowed
> in order to break the loop.  This is done by using a bit of
> an existing 1 byte hole in tcp_sock to check if there is
> on-going bpf_setsockopt(TCP_CONGESTION) in this tcp_sock.
>
> Note that this essentially limits only the first '.init' can
> call bpf_setsockopt(TCP_CONGESTION) to pick a fallback cc (eg. peer
> does not support ECN) and the second '.init' cannot fallback to
> another cc.  This applies even the second
> bpf_setsockopt(TCP_CONGESTION) will not cause a loop.
>
> Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
> ---
>  include/linux/tcp.h |  6 ++++++
>  net/core/filter.c   | 28 +++++++++++++++++++++++++++-
>  2 files changed, 33 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/tcp.h b/include/linux/tcp.h
> index a9fbe22732c3..3bdf687e2fb3 100644
> --- a/include/linux/tcp.h
> +++ b/include/linux/tcp.h
> @@ -388,6 +388,12 @@ struct tcp_sock {
>         u8      bpf_sock_ops_cb_flags;  /* Control calling BPF programs
>                                          * values defined in uapi/linux/tcp.h
>                                          */
> +       u8      bpf_chg_cc_inprogress:1; /* In the middle of
> +                                         * bpf_setsockopt(TCP_CONGESTION),
> +                                         * it is to avoid the bpf_tcp_cc->init()
> +                                         * to recur itself by calling
> +                                         * bpf_setsockopt(TCP_CONGESTION, "itself").
> +                                         */
>  #define BPF_SOCK_OPS_TEST_FLAG(TP, ARG) (TP->bpf_sock_ops_cb_flags & ARG)
>  #else
>  #define BPF_SOCK_OPS_TEST_FLAG(TP, ARG) 0
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 96f2f7a65e65..ac4c45c02da5 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -5105,6 +5105,9 @@ static int bpf_sol_tcp_setsockopt(struct sock *sk, int optname,
>  static int sol_tcp_sockopt_congestion(struct sock *sk, char *optval,
>                                       int *optlen, bool getopt)
>  {
> +       struct tcp_sock *tp;
> +       int ret;
> +
>         if (*optlen < 2)
>                 return -EINVAL;
>
> @@ -5125,8 +5128,31 @@ static int sol_tcp_sockopt_congestion(struct sock *sk, char *optval,
>         if (*optlen >= sizeof("cdg") - 1 && !strncmp("cdg", optval, *optlen))
>                 return -ENOTSUPP;
>
> -       return do_tcp_setsockopt(sk, SOL_TCP, TCP_CONGESTION,
> +       /* It stops this looping
> +        *
> +        * .init => bpf_setsockopt(tcp_cc) => .init =>
> +        * bpf_setsockopt(tcp_cc)" => .init => ....
> +        *
> +        * The second bpf_setsockopt(tcp_cc) is not allowed
> +        * in order to break the loop when both .init
> +        * are the same bpf prog.
> +        *
> +        * This applies even the second bpf_setsockopt(tcp_cc)
> +        * does not cause a loop.  This limits only the first
> +        * '.init' can call bpf_setsockopt(TCP_CONGESTION) to
> +        * pick a fallback cc (eg. peer does not support ECN)
> +        * and the second '.init' cannot fallback to
> +        * another.
> +        */
> +       tp = tcp_sk(sk);
> +       if (tp->bpf_chg_cc_inprogress)
> +               return -EBUSY;
> +

Is the socket locked (and owned by current thread) at this point ?
If not, changing bpf_chg_cc_inprogress would be racy.


> +       tp->bpf_chg_cc_inprogress = 1;
> +       ret = do_tcp_setsockopt(sk, SOL_TCP, TCP_CONGESTION,
>                                 KERNEL_SOCKPTR(optval), *optlen);
> +       tp->bpf_chg_cc_inprogress = 0;
> +       return ret;
>  }
>
>  static int sol_tcp_sockopt(struct sock *sk, int optname,
> --
> 2.30.2
>
