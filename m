Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD3835EB8DA
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 05:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbiI0Dek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 23:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231219AbiI0DeQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 23:34:16 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ED1DA8976;
        Mon, 26 Sep 2022 20:34:15 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id 13so18036506ejn.3;
        Mon, 26 Sep 2022 20:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=/pArgzIDYjI5OTryEd+t8yBwIM0MaNxz4+9fugMmZvQ=;
        b=qYElCTz6A7Ny/iWrn96dCrCYEBh3+Ew+5odf4j03IcoJqyWOGxDUJjJ/wAxMQULrSB
         KIDdBqcXouPjcHqOQeOpCeLqjlplVaKpVS1QEdOPnC1yTvKPESCH5UkU47rNMVoUpoTF
         kmkZbwRt9Gg4dc9lhh2I99GI14MECBg8lYEpDqg8k/m/MSKLRtz2VmtRrARKbKFuxS5V
         zcE3H/9nRxM5OISfk4PHYI+zWfhvDoVQvA1Ji18Ft4nb/WoDU6Qsdwmczp8G9aXJr1r9
         zBWtoNHNxCBeqXYVtQVVoQtAJR5+NZ6g37Iqpzqkb5h7uwrP2UFqvXz5C7EfevEjvzML
         sDqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=/pArgzIDYjI5OTryEd+t8yBwIM0MaNxz4+9fugMmZvQ=;
        b=Kl4Mpuv6qWNBpAVQvUS8Adp5X5/aRi0ZFFW6pll5nkHNe2DTkdqgJiGHuMuaHCLGzt
         YR+4zgzj5OHokKQBnoTr5j7mLXprjQDOyWf5NwQxF+H9E731ZX0nIl7OqCzwnaJKE7Ot
         N+Zv2ATD9Do3QZJV7+akpw10o5mPCo4EItD7YXOgL9h8mrTHeYTbUb06QEnadAbQxjLM
         7VxfL9VwGncJhnK3zSn8nsrXqd80tMjZs0vMuYQEuXBX4MWSABPoFWUxF0StFy26PLAm
         hEzqnWuJQ8F9okBxa49wm3ISZKhZjIFTkDECGWFpcMEoOdtheko2yFgPcxjtVUmtkCzF
         ks9Q==
X-Gm-Message-State: ACrzQf1KLxF/j2y2YKwCYKvTuC/d3jD6mX/N0UYSUQ1gw0Vud1NH63Ol
        OQdsCKnGIyQ49aNRv90iOHgzY2QwbvRR8GyWu1c=
X-Google-Smtp-Source: AMsMyM7bhHZiHwdECnO52Pntwte5Xgxid6kGVnzYsiMkJq1XE8T1/RBbKihV2LUVfqFifV3bLmvEtb8YCjOhLz2h7Po=
X-Received: by 2002:a17:907:3da2:b0:783:5a22:5042 with SMTP id
 he34-20020a1709073da200b007835a225042mr8165195ejc.58.1664249653329; Mon, 26
 Sep 2022 20:34:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220923224453.2351753-1-kafai@fb.com> <20220923224518.2353383-1-kafai@fb.com>
In-Reply-To: <20220923224518.2353383-1-kafai@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 26 Sep 2022 20:34:02 -0700
Message-ID: <CAADnVQ+Hm3wbGjXzEKz+ody7kdZBnZH11GLXjbMzUxUz1wGuHg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 4/5] bpf: tcp: Stop bpf_setsockopt(TCP_CONGESTION)
 in init ops to recur itself
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kernel Team <kernel-team@fb.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Martin KaFai Lau <martin.lau@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
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
> +       tp->bpf_chg_cc_inprogress = 1;
> +       ret = do_tcp_setsockopt(sk, SOL_TCP, TCP_CONGESTION,
>                                 KERNEL_SOCKPTR(optval), *optlen);
> +       tp->bpf_chg_cc_inprogress = 0;
> +       return ret;

Eric,

Could you please ack this patch?
