Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 293155E7088
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 02:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbiIWANC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 20:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbiIWANB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 20:13:01 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29BFBF85AC;
        Thu, 22 Sep 2022 17:13:00 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id e17so15842885edc.5;
        Thu, 22 Sep 2022 17:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=1q6pZ6H4nJewkKT6iZEdx+z59BoVMt+IJxkI6GjHp80=;
        b=Rh5vAa12nnjYxDVoG7MH1kHi528pVkW/HquBtTBn6seNUQH3xxD2uNZUoO15Ro7OpC
         6n6GcAieHGl77YdK/oudKqBgN1+EipmV3s78PR2Z5rEc+6o4bxq8Wmr3hJDKD5jDxG9+
         g5i/qiDAK+blQtwxCb4jgUlz5s9D5F/H3XJK/KpuoN5d4+e0+1M5hh0OLGDRBbuR3OB2
         tllbaxYO0eHqCbP4+cuycz22+33SPDwUE8Wyc/b4xugaMGau2RnCyp21IOetddanfxIZ
         ypaWU+0qH8grZaGTETkCUN+NkXP/IDQCDsZV2EMsKy3mtdQIMQrTzxBRD82yH7rKXXw9
         AbaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=1q6pZ6H4nJewkKT6iZEdx+z59BoVMt+IJxkI6GjHp80=;
        b=ISWwJkhvaaDysqyZYN2Y6qT9wVpLifhyXW7iDfdEzXRT7Xep0ipFkbayM/b+gwwpVp
         XMxBzw1Gww3KUOknn/4x6SotSnpnUiZBFyoZQaRcXEpqmSNWcozU6HhteTW8Uzgzxs5N
         dktuoxxc3DY2DhOTfP/24Vgy8HkvOaFLMVyAJ21Hj2JNGJzjWMjXBpelFSoLFjxjMNFv
         /7mILvYfTEfjYfKcTXsoB4J2IfOENEK4iKp8jjUpBe/r6Eqhycc6m+sv1FRF/7hVKgwc
         pRhpyBTc8DX0AHdtTGl4UQ0jq/scHfQmGu5Xz+8HCHk9uf0yx1B5OQp6HhaxFJvDQZQk
         3qsA==
X-Gm-Message-State: ACrzQf0odZpO+t0ESLalk79Qc8CW3+BRmceuA29J+6Yx+I+/uPRA2MXa
        lq2qYY9Qn15ey8BJGH5bk2pYm0DTBkbljKteVKA=
X-Google-Smtp-Source: AMsMyM6305EAC4fyvc+N0VrsbyiR95hVkvpuQCPYaFX+9OrMwHRg8sIC3ktfyL6/fwe94eE2Z6xERlBtJaJ3/wJomug=
X-Received: by 2002:a05:6402:1d48:b0:44e:c6cf:778 with SMTP id
 dz8-20020a0564021d4800b0044ec6cf0778mr5834760edb.421.1663891978548; Thu, 22
 Sep 2022 17:12:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220922225616.3054840-1-kafai@fb.com> <20220922225642.3058176-1-kafai@fb.com>
In-Reply-To: <20220922225642.3058176-1-kafai@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 22 Sep 2022 17:12:47 -0700
Message-ID: <CAADnVQK4fVZ0KdWkV7MfP_F3As7cme46SoR30YU0bk0zAfpOrA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/5] bpf: Stop bpf_setsockopt(TCP_CONGESTION) in
 init ops to recur itself
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Network Development <netdev@vger.kernel.org>,
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

On Thu, Sep 22, 2022 at 3:56 PM Martin KaFai Lau <kafai@fb.com> wrote:
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
> in order to break the loop.  This is done by checking the
> previous bpf_run_ctx has saved the same sk pointer in the
> bpf_cookie.
>
> Note that this essentially limits only the first '.init' can
> call bpf_setsockopt(TCP_CONGESTION) to pick a fallback cc (eg. peer
> does not support ECN) and the second '.init' cannot fallback to
> another cc.  This applies even the second
> bpf_setsockopt(TCP_CONGESTION) will not cause a loop.
>
> Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
> ---
>  include/linux/filter.h |  3 +++
>  net/core/filter.c      |  4 ++--
>  net/ipv4/bpf_tcp_ca.c  | 54 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 59 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index 98e28126c24b..9942ecc68a45 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -911,6 +911,9 @@ int sk_get_filter(struct sock *sk, sockptr_t optval, unsigned int len);
>  bool sk_filter_charge(struct sock *sk, struct sk_filter *fp);
>  void sk_filter_uncharge(struct sock *sk, struct sk_filter *fp);
>
> +int _bpf_setsockopt(struct sock *sk, int level, int optname,
> +                   char *optval, int optlen);
> +
>  u64 __bpf_call_base(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5);
>  #define __bpf_call_base_args \
>         ((u64 (*)(u64, u64, u64, u64, u64, const struct bpf_insn *)) \
> diff --git a/net/core/filter.c b/net/core/filter.c
> index f4cea3ff994a..e56a1ebcf1bc 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -5244,8 +5244,8 @@ static int __bpf_setsockopt(struct sock *sk, int level, int optname,
>         return -EINVAL;
>  }
>
> -static int _bpf_setsockopt(struct sock *sk, int level, int optname,
> -                          char *optval, int optlen)
> +int _bpf_setsockopt(struct sock *sk, int level, int optname,
> +                   char *optval, int optlen)
>  {
>         if (sk_fullsock(sk))
>                 sock_owned_by_me(sk);
> diff --git a/net/ipv4/bpf_tcp_ca.c b/net/ipv4/bpf_tcp_ca.c
> index 6da16ae6a962..a9f2cab5ffbc 100644
> --- a/net/ipv4/bpf_tcp_ca.c
> +++ b/net/ipv4/bpf_tcp_ca.c
> @@ -144,6 +144,57 @@ static const struct bpf_func_proto bpf_tcp_send_ack_proto = {
>         .arg2_type      = ARG_ANYTHING,
>  };
>
> +BPF_CALL_5(bpf_init_ops_setsockopt, struct sock *, sk, int, level,
> +          int, optname, char *, optval, int, optlen)
> +{
> +       struct bpf_tramp_run_ctx *run_ctx, *saved_run_ctx;
> +       int ret;
> +
> +       if (optname != TCP_CONGESTION)
> +               return _bpf_setsockopt(sk, level, optname, optval, optlen);
> +
> +       run_ctx = (struct bpf_tramp_run_ctx *)current->bpf_ctx;
> +       if (unlikely(run_ctx->saved_run_ctx &&
> +                    run_ctx->saved_run_ctx->type == BPF_RUN_CTX_TYPE_STRUCT_OPS)) {
> +               saved_run_ctx = (struct bpf_tramp_run_ctx *)run_ctx->saved_run_ctx;
> +               /* It stops this looping
> +                *
> +                * .init => bpf_setsockopt(tcp_cc) => .init =>
> +                * bpf_setsockopt(tcp_cc)" => .init => ....
> +                *
> +                * The second bpf_setsockopt(tcp_cc) is not allowed
> +                * in order to break the loop when both .init
> +                * are the same bpf prog.
> +                *
> +                * This applies even the second bpf_setsockopt(tcp_cc)
> +                * does not cause a loop.  This limits only the first
> +                * '.init' can call bpf_setsockopt(TCP_CONGESTION) to
> +                * pick a fallback cc (eg. peer does not support ECN)
> +                * and the second '.init' cannot fallback to
> +                * another cc.
> +                */
> +               if (saved_run_ctx->bpf_cookie == (uintptr_t)sk)
> +                       return -EBUSY;
> +       }
> +
> +       run_ctx->bpf_cookie = (uintptr_t)sk;
> +       ret = _bpf_setsockopt(sk, level, optname, optval, optlen);
> +       run_ctx->bpf_cookie = 0;

Instead of adding 4 bytes for enum in patch 3
(which will be 8 bytes due to alignment)
and abusing bpf_cookie here
(which struct_ops bpf prog might eventually read and be surprised
to find sk pointer in there)
how about adding 'struct task_struct *saved_current' as another arg
to bpf_tramp_run_ctx ?
Always store the current task in there in prog_entry_struct_ops
and then compare it here in this specialized bpf_init_ops_setsockopt?

Or maybe always check in enter_prog_struct_ops:
if (container_of(current->bpf_ctx, struct bpf_tramp_run_ctx,
run_ctx)->saved_current == current) // goto out since recursion?
it will prevent issues in case we don't know about and will
address the good recursion case as explained in patch 1?
I'm assuming 2nd ssthresh runs in a different task..
Or is it actually the same task?
