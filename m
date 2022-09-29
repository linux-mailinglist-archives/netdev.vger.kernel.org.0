Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 147145EEAC7
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 03:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232007AbiI2BMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 21:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234059AbiI2BMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 21:12:24 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A9A11D0C9;
        Wed, 28 Sep 2022 18:12:14 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id z97so18496ede.8;
        Wed, 28 Sep 2022 18:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=cHToZx6wjQGjCx2ekRKNqNyuqI7/vfdpwwrkM2pgFRA=;
        b=PaKoie8sFeFN5DocXsjMsWZ/lkPYRqdLL+/ieKvIS3Ca3F5nvGm/c87tdMqCNgnqBg
         oVdob4/Ho4loboe+8RrmLsGHX+dhM49vdJVnzsV8s8yfqemNRz3XNs2jSHtVjen4r9Sc
         /fxQ3iwjBP/Y2TgZ9jON/a9P7yKagTZ5ql1Wn8/FMYjkCfM+DoGrxeQa4I8FFgNW6zyV
         1zZj/c8n8/qDAfro8NFusOl/nmNGzbBgJnH8RFoe/whGZYO3RHajTbWn+nzA1plfbqTx
         jM9WnNcAJLLrvRWF5iK0iyved0hRctOEnBDmvgZHC9Cq1IZ9jrlJxxjhDU3ZcqctyDOt
         qgig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=cHToZx6wjQGjCx2ekRKNqNyuqI7/vfdpwwrkM2pgFRA=;
        b=JhlHhPUcC5qtR4jKStnEbWbLYhtZwUmoNX/kV/BZ55GCc73/nWVSKyLbvjT/cm3e6s
         /RuBjvoMwcyWjyydw9TQajR+zeap7g+wJ01UFD8LJFQKk9KiEuI30EhnJrHBrH9kW9Og
         /ChjPnWCbM5J/p4+0iFPuCB7L7DKtHPHP5YMMej6FNJAjR07iOKsJ8NScYTBObB53Fb2
         LHMZds+Ge/uUgpZZ0rxlMTJyvF9h9LQY4hMJYqrjni+B1NWts1XxucaOAxGMQsd85gDM
         jxRftcJpudcfEAPukoXXZA9FctKLkYw3hWacaKd/5jt1D/xrIjMs4VdkihQgc+eWRzsf
         YiDQ==
X-Gm-Message-State: ACrzQf0RbrYKmVGeJrBzg7nEPK011L7PQ/PkfOSSJHKTkKChl6e8cQ7B
        jLNsbLdF3LtwFbFUXBBnx3/fkCiYuF4dtLnfWE/GJpbn
X-Google-Smtp-Source: AMsMyM7Gx6t1nioEPm8vDSHHPKF78tDZpWt3K5fzZSPOsVjFAR/ogpmQ/+BPwYVAaZZf4T5h/K6Az8PLMh3RWqxdlrQ=
X-Received: by 2002:aa7:c601:0:b0:458:1e8b:ada0 with SMTP id
 h1-20020aa7c601000000b004581e8bada0mr786058edq.338.1664413932648; Wed, 28 Sep
 2022 18:12:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220923224453.2351753-1-kafai@fb.com> <20220923224518.2353383-1-kafai@fb.com>
 <CAADnVQ+Hm3wbGjXzEKz+ody7kdZBnZH11GLXjbMzUxUz1wGuHg@mail.gmail.com>
In-Reply-To: <CAADnVQ+Hm3wbGjXzEKz+ody7kdZBnZH11GLXjbMzUxUz1wGuHg@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 28 Sep 2022 18:12:01 -0700
Message-ID: <CAADnVQJddHYrjRDMdKCuHtizuLNZU58Qg7-HKoJ4pSV17suMzw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 4/5] bpf: tcp: Stop bpf_setsockopt(TCP_CONGESTION)
 in init ops to recur itself
To:     Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
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

Eric,

Ping! This is an important fix for anyone using bpf-based tcp-cc.

On Mon, Sep 26, 2022 at 8:34 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Sep 23, 2022 at 3:48 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > From: Martin KaFai Lau <martin.lau@kernel.org>
> >
> > When a bad bpf prog '.init' calls
> > bpf_setsockopt(TCP_CONGESTION, "itself"), it will trigger this loop:
> >
> > .init => bpf_setsockopt(tcp_cc) => .init => bpf_setsockopt(tcp_cc) ...
> > ... => .init => bpf_setsockopt(tcp_cc).
> >
> > It was prevented by the prog->active counter before but the prog->active
> > detection cannot be used in struct_ops as explained in the earlier
> > patch of the set.
> >
> > In this patch, the second bpf_setsockopt(tcp_cc) is not allowed
> > in order to break the loop.  This is done by using a bit of
> > an existing 1 byte hole in tcp_sock to check if there is
> > on-going bpf_setsockopt(TCP_CONGESTION) in this tcp_sock.
> >
> > Note that this essentially limits only the first '.init' can
> > call bpf_setsockopt(TCP_CONGESTION) to pick a fallback cc (eg. peer
> > does not support ECN) and the second '.init' cannot fallback to
> > another cc.  This applies even the second
> > bpf_setsockopt(TCP_CONGESTION) will not cause a loop.
> >
> > Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
> > ---
> >  include/linux/tcp.h |  6 ++++++
> >  net/core/filter.c   | 28 +++++++++++++++++++++++++++-
> >  2 files changed, 33 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/tcp.h b/include/linux/tcp.h
> > index a9fbe22732c3..3bdf687e2fb3 100644
> > --- a/include/linux/tcp.h
> > +++ b/include/linux/tcp.h
> > @@ -388,6 +388,12 @@ struct tcp_sock {
> >         u8      bpf_sock_ops_cb_flags;  /* Control calling BPF programs
> >                                          * values defined in uapi/linux/tcp.h
> >                                          */
> > +       u8      bpf_chg_cc_inprogress:1; /* In the middle of
> > +                                         * bpf_setsockopt(TCP_CONGESTION),
> > +                                         * it is to avoid the bpf_tcp_cc->init()
> > +                                         * to recur itself by calling
> > +                                         * bpf_setsockopt(TCP_CONGESTION, "itself").
> > +                                         */
> >  #define BPF_SOCK_OPS_TEST_FLAG(TP, ARG) (TP->bpf_sock_ops_cb_flags & ARG)
> >  #else
> >  #define BPF_SOCK_OPS_TEST_FLAG(TP, ARG) 0
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index 96f2f7a65e65..ac4c45c02da5 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -5105,6 +5105,9 @@ static int bpf_sol_tcp_setsockopt(struct sock *sk, int optname,
> >  static int sol_tcp_sockopt_congestion(struct sock *sk, char *optval,
> >                                       int *optlen, bool getopt)
> >  {
> > +       struct tcp_sock *tp;
> > +       int ret;
> > +
> >         if (*optlen < 2)
> >                 return -EINVAL;
> >
> > @@ -5125,8 +5128,31 @@ static int sol_tcp_sockopt_congestion(struct sock *sk, char *optval,
> >         if (*optlen >= sizeof("cdg") - 1 && !strncmp("cdg", optval, *optlen))
> >                 return -ENOTSUPP;
> >
> > -       return do_tcp_setsockopt(sk, SOL_TCP, TCP_CONGESTION,
> > +       /* It stops this looping
> > +        *
> > +        * .init => bpf_setsockopt(tcp_cc) => .init =>
> > +        * bpf_setsockopt(tcp_cc)" => .init => ....
> > +        *
> > +        * The second bpf_setsockopt(tcp_cc) is not allowed
> > +        * in order to break the loop when both .init
> > +        * are the same bpf prog.
> > +        *
> > +        * This applies even the second bpf_setsockopt(tcp_cc)
> > +        * does not cause a loop.  This limits only the first
> > +        * '.init' can call bpf_setsockopt(TCP_CONGESTION) to
> > +        * pick a fallback cc (eg. peer does not support ECN)
> > +        * and the second '.init' cannot fallback to
> > +        * another.
> > +        */
> > +       tp = tcp_sk(sk);
> > +       if (tp->bpf_chg_cc_inprogress)
> > +               return -EBUSY;
> > +
> > +       tp->bpf_chg_cc_inprogress = 1;
> > +       ret = do_tcp_setsockopt(sk, SOL_TCP, TCP_CONGESTION,
> >                                 KERNEL_SOCKPTR(optval), *optlen);
> > +       tp->bpf_chg_cc_inprogress = 0;
> > +       return ret;
>
> Eric,
>
> Could you please ack this patch?
