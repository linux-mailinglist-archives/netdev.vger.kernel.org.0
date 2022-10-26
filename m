Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 010F660E367
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 16:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234118AbiJZOd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 10:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233693AbiJZOd5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 10:33:57 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16C8E1162CD
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 07:33:57 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id 187so10018972ybe.1
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 07:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=O8ox5Vjpqbut2HWEJqXTMWMGhh1V8cXSr+71zLXWLVk=;
        b=cS+OEkce0Epvs5RObk0TjuOpGoAyKkMtjZGrxaLSPfQQN/33ph2elTppkEOA2XMrdN
         ePIAU6G0iXWCllBDfplra+KVD0B+p2oGhC2ji2m5uS/ariiOBEWvOw1S7LlTJyHZHIXE
         sTj1RiZIOfhXsHK7//csSbIIpy8HyTmfhAJI3DlZotDjkFaLNROABB9iKjBY2PS1m2i8
         0C1otqS5sAI2BIJ1JIvOc2arODS4CeGT68ZgrcA3oxlsQULr1JMSS8ETsPWJgBKdSXFf
         qd/XgVhounSzbVVFcJnooihcNcxXP9VAPATTliDGZsnZRaw+oT4xCVTc4kh7cnL+TIRb
         gNxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O8ox5Vjpqbut2HWEJqXTMWMGhh1V8cXSr+71zLXWLVk=;
        b=TDREe8B/xoJyIWF0Uxmo5/y9q+zK/rfnBalRfuTFq7Mpi/PHWMQQJRXWZbd6fcWqLT
         hPDoKlCwhnqp0BieqjMEzIYkgaEAOjIox8GLVMhVrfqIM85sEr/P1edgICc2/uniA6ac
         uxzUYqv4+RGr7LDE4xhoz1d2bhLTvfxpDl7GE7y113YkTehV/+/AcNyCvBywD5jYsTZv
         hYflXzfC8bktiEc6Io40fazi6W6O1Q5ygJLVm858QjxyInwUu3hh+9g/q+jJ09u8YR4j
         BqwVDGnbMgQrY+4fQE6FzRQKX+VDvnHy2z7giitQicX07Fl+XuqMWQDTLGGKUuwluL4S
         Hn5w==
X-Gm-Message-State: ACrzQf32/CMJivhnFSVlsgTCy1KdPBI2f9911UPHZpXq92l5uUYgNnML
        VRkWTWSDtJJvSES0iaFRGXDCOwEcMR/oRgDcP5EKLA==
X-Google-Smtp-Source: AMsMyM7Kj+ix8NfjCr41vIWWndaLObJzWDT2NZzLiwnVvhaUK3KUloDnlVr8djl6/9qLamliHAWkt3Hs78Zc6WBwqqQ=
X-Received: by 2002:a25:7a01:0:b0:6b0:820:dd44 with SMTP id
 v1-20020a257a01000000b006b00820dd44mr36720991ybc.387.1666794836054; Wed, 26
 Oct 2022 07:33:56 -0700 (PDT)
MIME-Version: 1.0
References: <20221026151558.4165020-1-luwei32@huawei.com> <CANn89iJQn5ET3U9cYeiT0ijTkab2tRDBB1YP3Y6oELVq0dj6Zw@mail.gmail.com>
In-Reply-To: <CANn89iJQn5ET3U9cYeiT0ijTkab2tRDBB1YP3Y6oELVq0dj6Zw@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 26 Oct 2022 07:33:45 -0700
Message-ID: <CANn89iLcnPAzLZFiCazM_y==33+Zhg=3bGY70ev=5YwDoZw-Vg@mail.gmail.com>
Subject: Re: [PATCH net] tcp: reset tp->sacked_out when sack is enabled
To:     Lu Wei <luwei32@huawei.com>, "Denis V. Lunev" <den@openvz.org>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pabeni@redhat.com, xemul@parallels.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Wed, Oct 26, 2022 at 7:30 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Wed, Oct 26, 2022 at 7:12 AM Lu Wei <luwei32@huawei.com> wrote:
> >
> > The meaning of tp->sacked_out depends on whether sack is enabled
> > or not. If setsockopt is called to enable sack_ok via
> > tcp_repair_options_est(), tp->sacked_out should be cleared, or it
> > will trigger warning in tcp_verify_left_out as follows:
> >
> > ============================================
> > WARNING: CPU: 8 PID: 0 at net/ipv4/tcp_input.c:2132
> > tcp_timeout_mark_lost+0x154/0x160
> > tcp_enter_loss+0x2b/0x290
> > tcp_retransmit_timer+0x50b/0x640
> > tcp_write_timer_handler+0x1c8/0x340
> > tcp_write_timer+0xe5/0x140
> > call_timer_fn+0x3a/0x1b0
> > __run_timers.part.0+0x1bf/0x2d0
> > run_timer_softirq+0x43/0xb0
> > __do_softirq+0xfd/0x373
> > __irq_exit_rcu+0xf6/0x140
> >
> > This warning occurs in several steps:
> > Step1. If sack is not enabled, when server receives dup-ack,
> >        it calls tcp_add_reno_sack() to increase tp->sacked_out.
> >
> > Step2. Setsockopt() is called to enable sack
> >
> > Step3. The retransmit timer expires, it calls tcp_timeout_mark_lost()
> >        to increase tp->lost_out but not clear tp->sacked_out because
> >        sack is enabled and tcp_is_reno() is false.
> >
> > So tp->left_out is increased repeatly in Step1 and Step3 and it is
> > greater than tp->packets_out and trigger the warning. In function
> > tcp_timeout_mark_lost(), tp->sacked_out will be cleared if Step2 not
> > happen and the warning will not be triggered. So this patch clears
> > tp->sacked_out in tcp_repair_options_est().
> >
> > Fixes: b139ba4e90dc ("tcp: Repair connection-time negotiated parameters")
> > Signed-off-by: Lu Wei <luwei32@huawei.com>
> > ---
> >  net/ipv4/tcp.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > index ef14efa1fb70..188d5c0e440f 100644
> > --- a/net/ipv4/tcp.c
> > +++ b/net/ipv4/tcp.c
> > @@ -3282,6 +3282,9 @@ static int tcp_repair_options_est(struct sock *sk, sockptr_t optbuf,
> >                         if (opt.opt_val != 0)
> >                                 return -EINVAL;
> >
> > +                       if (tcp_is_reno(tp))
> > +                               tp->sacked_out = 0;
> > +
> >                         tp->rx_opt.sack_ok |= TCP_SACK_SEEN;
> >                         break;
> >                 case TCPOPT_TIMESTAMP:
> > --
> > 2.31.1
> >
>
> Hmm, I am not sure this is the right fix.
>
> Probably TCP_REPAIR_OPTIONS should not be allowed if data has already been sent.
>
> Pavel, what do you think ?

Routing to Denis V. Lunev <den@openvz.org>, because Pavel's address no
longer works.

Thanks !
