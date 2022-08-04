Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0047258A107
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 21:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237097AbiHDTDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 15:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbiHDTDT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 15:03:19 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E40D34D152;
        Thu,  4 Aug 2022 12:03:17 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id w3so850862edc.2;
        Thu, 04 Aug 2022 12:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=7hNm5OVPTeKv5pD0bNWYOivXOQxMpQHlZaolJaUQUC0=;
        b=Sn/S/ptMSDtI4uBvnbSMtweW3NaeRRsaqOoqei0I9M77BbO3QRGRufj8bT9/YTA2c/
         8EcvUYEFwhxqeflmlP0ZJ46Phw9ooXkKPC8vwFCWwOMlz7aJHJyRcax7SvtcOne6egTb
         1P6l5gxy5uXWZVTOrosAuXJjdrxULnt20nVICMs0GWxm6HRyo9Nd5w6u/M4lwmNO5oiV
         TyXnPOqvJfbiesEWZiDANPQ9auuLa6wE9+y5DRrzZ3vFYSxiOOkfLOdP3a8I0awUTTVH
         6LYDCfSXYPkHJtr5M8hlQxyMzdIvXTqia66SPHwnvw6yY333OREjOzGQa0vKsMt5Oy79
         2CMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=7hNm5OVPTeKv5pD0bNWYOivXOQxMpQHlZaolJaUQUC0=;
        b=4RwkgHuxQNSTNkNn2bLqg186GacgF0+ZI64ooHgzyNoV9Vu+O/edwmS2i66nApTF33
         mLFRDmqEBtjxgFJ7aE+phI8mJu2QHI2JbzbjAL5rTqJys15482mLpu+992Wu3TzwpPph
         nKUASV1FsKr34j/AecwCoCVqPSwN/dcIRrpmw2QkJQTHPrRE888K39bYBLqxQJjXT5yn
         FmWl9m8EemJZwt9dS3sGqesTbEXu84t/4o1hEBqzKaVI1+dmIRcO31Sm5A+fkoXriIe0
         Uc6NIudzDLvdiKjICEe3oDFOLUCo2W+LK9fn7Qj9MIV0fu9Sa7ZHe296BabiT6UjO+U3
         BTtA==
X-Gm-Message-State: ACgBeo3dnaggbFdvnmU6vOhbh22MfGoM4syB7p8uDQfttCIE+qDbfFGJ
        mdA8YyxZVwxSzrxtexY7eQNbFOz+RP9i+u7EWno=
X-Google-Smtp-Source: AA6agR7z9zqnbAJjWYMSN1489c76cWjVhhMoAVfnuclfYWaDXI8fgmCzIp9m8OFHNWgr7rbh3hdo1QFL0Y1s/Vec+0U=
X-Received: by 2002:a05:6402:28cb:b0:43b:c6d7:ef92 with SMTP id
 ef11-20020a05640228cb00b0043bc6d7ef92mr3432546edb.333.1659639796377; Thu, 04
 Aug 2022 12:03:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220803204601.3075863-1-kafai@fb.com> <20220803204614.3077284-1-kafai@fb.com>
In-Reply-To: <20220803204614.3077284-1-kafai@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 4 Aug 2022 12:03:04 -0700
Message-ID: <CAEf4Bzb9js_4UFChVWOjw52ik5TmNJroF5bXSicJtxyNZH8k3A@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 02/15] bpf: net: Avoid sk_setsockopt() taking
 sk lock when called from bpf
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com,
        Paolo Abeni <pabeni@redhat.com>,
        Stanislav Fomichev <sdf@google.com>
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

On Wed, Aug 3, 2022 at 1:49 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> Most of the code in bpf_setsockopt(SOL_SOCKET) are duplicated from
> the sk_setsockopt().  The number of supported optnames are
> increasing ever and so as the duplicated code.
>
> One issue in reusing sk_setsockopt() is that the bpf prog
> has already acquired the sk lock.  This patch adds a in_bpf()
> to tell if the sk_setsockopt() is called from a bpf prog.
> The bpf prog calling bpf_setsockopt() is either running in_task()
> or in_serving_softirq().  Both cases have the current->bpf_ctx
> initialized.  Thus, the in_bpf() only needs to test !!current->bpf_ctx.
>
> This patch also adds sockopt_{lock,release}_sock() helpers
> for sk_setsockopt() to use.  These helpers will test in_bpf()
> before acquiring/releasing the lock.  They are in EXPORT_SYMBOL
> for the ipv6 module to use in a latter patch.
>
> Note on the change in sock_setbindtodevice().  sockopt_lock_sock()
> is done in sock_setbindtodevice() instead of doing the lock_sock
> in sock_bindtoindex(..., lock_sk = true).
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  include/linux/bpf.h |  8 ++++++++
>  include/net/sock.h  |  3 +++
>  net/core/sock.c     | 26 +++++++++++++++++++++++---
>  3 files changed, 34 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 20c26aed7896..b905b1b34fe4 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1966,6 +1966,10 @@ static inline bool unprivileged_ebpf_enabled(void)
>         return !sysctl_unprivileged_bpf_disabled;
>  }
>
> +static inline bool in_bpf(void)

I think this function deserves a big comment explaining that it's not
100% accurate, as not every BPF program type sets bpf_ctx. As it is
named in_bpf() promises a lot more generality than it actually
provides.

Should this be named either more specific has_current_bpf_ctx() maybe?

Also, separately, should be make an effort to set bpf_ctx for all
program types (instead or in addition to the above)?

> +{
> +       return !!current->bpf_ctx;
> +}
>  #else /* !CONFIG_BPF_SYSCALL */
>  static inline struct bpf_prog *bpf_prog_get(u32 ufd)
>  {
> @@ -2175,6 +2179,10 @@ static inline bool unprivileged_ebpf_enabled(void)
>         return false;
>  }
>
> +static inline bool in_bpf(void)
> +{
> +       return false;
> +}
>  #endif /* CONFIG_BPF_SYSCALL */
>
>  void __bpf_free_used_btfs(struct bpf_prog_aux *aux,
> diff --git a/include/net/sock.h b/include/net/sock.h
> index a7273b289188..b2ff230860c6 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -1721,6 +1721,9 @@ static inline void unlock_sock_fast(struct sock *sk, bool slow)
>         }
>  }
>
> +void sockopt_lock_sock(struct sock *sk);
> +void sockopt_release_sock(struct sock *sk);
> +
>  /* Used by processes to "lock" a socket state, so that
>   * interrupts and bottom half handlers won't change it
>   * from under us. It essentially blocks any incoming
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 20269c37ab3b..82759540ae2c 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -703,7 +703,9 @@ static int sock_setbindtodevice(struct sock *sk, sockptr_t optval, int optlen)
>                         goto out;
>         }
>
> -       return sock_bindtoindex(sk, index, true);
> +       sockopt_lock_sock(sk);
> +       ret = sock_bindtoindex_locked(sk, index);
> +       sockopt_release_sock(sk);
>  out:
>  #endif
>
> @@ -1036,6 +1038,24 @@ static int sock_reserve_memory(struct sock *sk, int bytes)
>         return 0;
>  }
>
> +void sockopt_lock_sock(struct sock *sk)
> +{
> +       if (in_bpf())
> +               return;
> +
> +       lock_sock(sk);
> +}
> +EXPORT_SYMBOL(sockopt_lock_sock);
> +
> +void sockopt_release_sock(struct sock *sk)
> +{
> +       if (in_bpf())
> +               return;
> +
> +       release_sock(sk);
> +}
> +EXPORT_SYMBOL(sockopt_release_sock);
> +
>  /*
>   *     This is meant for all protocols to use and covers goings on
>   *     at the socket level. Everything here is generic.
> @@ -1067,7 +1087,7 @@ static int sk_setsockopt(struct sock *sk, int level, int optname,
>
>         valbool = val ? 1 : 0;
>
> -       lock_sock(sk);
> +       sockopt_lock_sock(sk);
>
>         switch (optname) {
>         case SO_DEBUG:
> @@ -1496,7 +1516,7 @@ static int sk_setsockopt(struct sock *sk, int level, int optname,
>                 ret = -ENOPROTOOPT;
>                 break;
>         }
> -       release_sock(sk);
> +       sockopt_release_sock(sk);
>         return ret;
>  }
>
> --
> 2.30.2
>
