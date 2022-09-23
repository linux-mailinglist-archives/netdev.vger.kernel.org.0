Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3F165E7E59
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 17:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232542AbiIWP1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 11:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbiIWP1J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 11:27:09 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC7F13EAFA;
        Fri, 23 Sep 2022 08:27:08 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id z97so685901ede.8;
        Fri, 23 Sep 2022 08:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=6JMTEY2lWNmisu5wgCvIjJuHrDPad0gYhdclOkvEFOA=;
        b=beW9ZPMZQWdJyVN9Zk2lZ2G6V9ZvIQ2LZlK2vGUP7EUOQcT7WkoxWFhmuMZQRulX9a
         X79LhL2CorE4QouVUv/A1cEmTuhUDV0bV+TQzZMMAHpVy6P2icyjPt+Vh1Z6QAyIPF7Q
         JP9obE5mEVtLttGNiaDxIoIAX+S60nwK4xN084pLXGReSpB5ZJt/TPOnDEBlihtGuWKQ
         1XCMNnkFpV4OTcyxZXS0/tHeQiIsPyv7ui0zDAQr+umvaS3DzR0a/gFLxKe3OZbemiRw
         Ky7cMiyE8+0B44bja1YdqVjFKzVva047QkNJVbLS5Jfw/b1N0WwZsRTe+s4GIrjzECW4
         kM6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=6JMTEY2lWNmisu5wgCvIjJuHrDPad0gYhdclOkvEFOA=;
        b=a8hUPxLrMsCm4jCLVee7ur292labRepMArL58hegY79U89YK86mFdzn/L1mOLVr8/K
         6LFNLTt/UmzEK5vfQJOms6GM+c7ccyhS7xQVh6478v5BJFDSvJdEGqgOw5155PwaFRHU
         ZYQl6Mw7og3J876ShKUuD5pn16dlkj+R6j1fSm97BrV5hAZ9y7QCqHEfwwAvvJwiYA50
         glfQ2tJSxbCM3F+kmsy/ZJqmfZqeVT7fWy0pS8IKO7FKRpjPw9Gi2rkPKZKjhN6msdBJ
         t4ePzbRitjWPy4TvzYPt3SjNjnmZPLcrb/5UA4yQDjDUrYIbql8ydaxNiBme+tHEkqKH
         GCjg==
X-Gm-Message-State: ACrzQf2aCYsonlpQlZcbTifqonCTT6zJm8YXIWtiAskRFRwhLY9da2yH
        P9/c+2kL3xKQJE4MUC7RA7Q3XkokcGwX2kLMw90=
X-Google-Smtp-Source: AMsMyM583AbFhoKMPu2EiMn+8gyvG7HHbuqkgOw/xOzPLYemM5WW+8nUN8sCYp0WwAqW/Md2eL1UJRfB3qgMwVEk5vo=
X-Received: by 2002:aa7:c619:0:b0:454:2cca:6c0d with SMTP id
 h25-20020aa7c619000000b004542cca6c0dmr9062655edq.6.1663946826562; Fri, 23 Sep
 2022 08:27:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220922225616.3054840-1-kafai@fb.com> <20220922225642.3058176-1-kafai@fb.com>
 <CAADnVQK4fVZ0KdWkV7MfP_F3As7cme46SoR30YU0bk0zAfpOrA@mail.gmail.com> <99e23c92-b1dc-db45-73f7-c210eb1debc8@linux.dev>
In-Reply-To: <99e23c92-b1dc-db45-73f7-c210eb1debc8@linux.dev>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 23 Sep 2022 08:26:55 -0700
Message-ID: <CAADnVQKFdpiQFxgF253V5XmtjnrVXcZ14sxT_Q3vOQ97WxScMQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/5] bpf: Stop bpf_setsockopt(TCP_CONGESTION) in
 init ops to recur itself
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Network Development <netdev@vger.kernel.org>
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

On Thu, Sep 22, 2022 at 6:11 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>
> On 9/22/22 5:12 PM, Alexei Starovoitov wrote:
> > On Thu, Sep 22, 2022 at 3:56 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >>
> >> From: Martin KaFai Lau <martin.lau@kernel.org>
> >>
> >> When a bad bpf prog '.init' calls
> >> bpf_setsockopt(TCP_CONGESTION, "itself"), it will trigger this loop:
> >>
> >> .init => bpf_setsockopt(tcp_cc) => .init => bpf_setsockopt(tcp_cc) ...
> >> ... => .init => bpf_setsockopt(tcp_cc).
> >>
> >> It was prevented by the prog->active counter before but the prog->active
> >> detection cannot be used in struct_ops as explained in the earlier
> >> patch of the set.
> >>
> >> In this patch, the second bpf_setsockopt(tcp_cc) is not allowed
> >> in order to break the loop.  This is done by checking the
> >> previous bpf_run_ctx has saved the same sk pointer in the
> >> bpf_cookie.
> >>
> >> Note that this essentially limits only the first '.init' can
> >> call bpf_setsockopt(TCP_CONGESTION) to pick a fallback cc (eg. peer
> >> does not support ECN) and the second '.init' cannot fallback to
> >> another cc.  This applies even the second
> >> bpf_setsockopt(TCP_CONGESTION) will not cause a loop.
> >>
> >> Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
> >> ---
> >>   include/linux/filter.h |  3 +++
> >>   net/core/filter.c      |  4 ++--
> >>   net/ipv4/bpf_tcp_ca.c  | 54 ++++++++++++++++++++++++++++++++++++++++++
> >>   3 files changed, 59 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/include/linux/filter.h b/include/linux/filter.h
> >> index 98e28126c24b..9942ecc68a45 100644
> >> --- a/include/linux/filter.h
> >> +++ b/include/linux/filter.h
> >> @@ -911,6 +911,9 @@ int sk_get_filter(struct sock *sk, sockptr_t optval, unsigned int len);
> >>   bool sk_filter_charge(struct sock *sk, struct sk_filter *fp);
> >>   void sk_filter_uncharge(struct sock *sk, struct sk_filter *fp);
> >>
> >> +int _bpf_setsockopt(struct sock *sk, int level, int optname,
> >> +                   char *optval, int optlen);
> >> +
> >>   u64 __bpf_call_base(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5);
> >>   #define __bpf_call_base_args \
> >>          ((u64 (*)(u64, u64, u64, u64, u64, const struct bpf_insn *)) \
> >> diff --git a/net/core/filter.c b/net/core/filter.c
> >> index f4cea3ff994a..e56a1ebcf1bc 100644
> >> --- a/net/core/filter.c
> >> +++ b/net/core/filter.c
> >> @@ -5244,8 +5244,8 @@ static int __bpf_setsockopt(struct sock *sk, int level, int optname,
> >>          return -EINVAL;
> >>   }
> >>
> >> -static int _bpf_setsockopt(struct sock *sk, int level, int optname,
> >> -                          char *optval, int optlen)
> >> +int _bpf_setsockopt(struct sock *sk, int level, int optname,
> >> +                   char *optval, int optlen)
> >>   {
> >>          if (sk_fullsock(sk))
> >>                  sock_owned_by_me(sk);
> >> diff --git a/net/ipv4/bpf_tcp_ca.c b/net/ipv4/bpf_tcp_ca.c
> >> index 6da16ae6a962..a9f2cab5ffbc 100644
> >> --- a/net/ipv4/bpf_tcp_ca.c
> >> +++ b/net/ipv4/bpf_tcp_ca.c
> >> @@ -144,6 +144,57 @@ static const struct bpf_func_proto bpf_tcp_send_ack_proto = {
> >>          .arg2_type      = ARG_ANYTHING,
> >>   };
> >>
> >> +BPF_CALL_5(bpf_init_ops_setsockopt, struct sock *, sk, int, level,
> >> +          int, optname, char *, optval, int, optlen)
> >> +{
> >> +       struct bpf_tramp_run_ctx *run_ctx, *saved_run_ctx;
> >> +       int ret;
> >> +
> >> +       if (optname != TCP_CONGESTION)
> >> +               return _bpf_setsockopt(sk, level, optname, optval, optlen);
> >> +
> >> +       run_ctx = (struct bpf_tramp_run_ctx *)current->bpf_ctx;
> >> +       if (unlikely(run_ctx->saved_run_ctx &&
> >> +                    run_ctx->saved_run_ctx->type == BPF_RUN_CTX_TYPE_STRUCT_OPS)) {
> >> +               saved_run_ctx = (struct bpf_tramp_run_ctx *)run_ctx->saved_run_ctx;
> >> +               /* It stops this looping
> >> +                *
> >> +                * .init => bpf_setsockopt(tcp_cc) => .init =>
> >> +                * bpf_setsockopt(tcp_cc)" => .init => ....
> >> +                *
> >> +                * The second bpf_setsockopt(tcp_cc) is not allowed
> >> +                * in order to break the loop when both .init
> >> +                * are the same bpf prog.
> >> +                *
> >> +                * This applies even the second bpf_setsockopt(tcp_cc)
> >> +                * does not cause a loop.  This limits only the first
> >> +                * '.init' can call bpf_setsockopt(TCP_CONGESTION) to
> >> +                * pick a fallback cc (eg. peer does not support ECN)
> >> +                * and the second '.init' cannot fallback to
> >> +                * another cc.
> >> +                */
> >> +               if (saved_run_ctx->bpf_cookie == (uintptr_t)sk)
> >> +                       return -EBUSY;
> >> +       }
> >> +
> >> +       run_ctx->bpf_cookie = (uintptr_t)sk;
> >> +       ret = _bpf_setsockopt(sk, level, optname, optval, optlen);
> >> +       run_ctx->bpf_cookie = 0;
> >
> > Instead of adding 4 bytes for enum in patch 3
> > (which will be 8 bytes due to alignment)
> > and abusing bpf_cookie here
> > (which struct_ops bpf prog might eventually read and be surprised
> > to find sk pointer in there)
> > how about adding 'struct task_struct *saved_current' as another arg
> > to bpf_tramp_run_ctx ?
> > Always store the current task in there in prog_entry_struct_ops
> > and then compare it here in this specialized bpf_init_ops_setsockopt?
> >
> > Or maybe always check in enter_prog_struct_ops:
> > if (container_of(current->bpf_ctx, struct bpf_tramp_run_ctx,
> > run_ctx)->saved_current == current) // goto out since recursion?
> > it will prevent issues in case we don't know about and will
> > address the good recursion case as explained in patch 1?
> > I'm assuming 2nd ssthresh runs in a different task..
> > Or is it actually the same task?
>
> The 2nd ssthresh() should run in the same task but different sk.  The
> first ssthresh(sk[1]) was run in_task() context and then got
> interrupted.  The softirq then handles the rcv path which just happens
> to also call ssthresh(sk[2]) in the unlikely pkt-loss case. It is like
> ssthresh(sk[1]) => softirq => ssthresh(sk[2]).
>
> The tcp-cc ops can recur but cannot recur on the same sk because it
> requires to hold the sk lock, so the patch remembers what was the
> previous sk to ensure it does not recur on the same sk.  Then it needs
> to peek into the previous run ctx which may not always be
> bpf_trump_run_ctx.  eg. a cg bpf prog (with bpf_cg_run_ctx) can call
> bpf_setsockopt(TCP_CONGESTION, "a_bpf_tcp_cc") which then will call the
> a_bpf_tcp_cc->init().  It needs a bpf_run_ctx_type so it can safely peek
> the previous bpf_run_ctx.

got it.

>
> Since struct_ops is the only one that needs to peek into the previous
> run_ctx (through tramp_run_ctx->saved_run_ctx),  instead of adding 4
> bytes to the bpf_run_ctx, one idea just came to my mind is to use one
> bit in the tramp_run_ctx->saved_run_ctx pointer itsef.  Something like
> this if it reuses the bpf_cookie (probably missed some int/ptr type
> casting):
>
> #define BPF_RUN_CTX_STRUCT_OPS_BIT 1UL
>
> u64 notrace __bpf_prog_enter_struct_ops(struct bpf_prog *prog,
>                                      struct bpf_tramp_run_ctx *run_ctx)
>          __acquires(RCU)
> {
>         rcu_read_lock();
>         migrate_disable();
>
>         run_ctx->saved_run_ctx = bpf_set_run_ctx((&run_ctx->run_ctx) |
>                                         BPF_RUN_CTX_STRUCT_OPS_BIT);
>
>          return bpf_prog_start_time();
> }
>
> BPF_CALL_5(bpf_init_ops_setsockopt, struct sock *, sk, int, level,
>             int, optname, char *, optval, int, optlen)
> {
>         /* ... */
>         if (unlikely((run_ctx->saved_run_ctx &
>                         BPF_RUN_CTX_STRUCT_OPS_BIT) && ...) {
>                 /* ... */
>                 if (bpf_cookie == (uintptr_t)sk)
>                         return -EBUSY;
>         }
>
> }

that should work, but don't you need to loop through all previous
run_ctx and check all with BPF_RUN_CTX_STRUCT_OPS_BIT type ?
Since run_ctx is saved in the task and we have preemptible
rpgos there could be tracing prog in the chain:
struct_ops_run_ctx->tracing_run_ctx->struct_ops_run_ctx
where 1st and last have the same 'sk'.
