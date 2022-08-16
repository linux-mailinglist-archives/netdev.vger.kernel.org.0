Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90342595374
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 09:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbiHPHJL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 03:09:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbiHPHIr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 03:08:47 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028472DCE2D;
        Mon, 15 Aug 2022 20:33:46 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id f22so11856656edc.7;
        Mon, 15 Aug 2022 20:33:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=DEG/KDHanKqZe+WzYjSLFff9rFKakaJDsiFb2U0inBk=;
        b=mKGK+oC2ul1JQ4Qvo5Z7bjRTwuhNeUSUZT2F104IIcGhRODQI9hKcwqVgyqlen0EUV
         rR7YVa/tmyKEXPrbCW7inuTp2JtwxxmBA2wzRf3fthldXUdZ+dusMzpr6wggseeFg0zd
         QFigtZ7xOkE8WtNGuy1VM1OAnLz/Hxthx5BT1fgy9qJB7WcBNlPMMdBDZtNVeJgurf72
         OEk6PU6vFiyHOLQHL1bTIzpMFdlKfGyx/JLL07DJIH55CHS554o3zH63E+kTteDiwEYM
         cBIIKMxWuhNo6AlnFOrgnGUj2gH1I1zh49J7XsTCTTmLulb7baETFZY9riKeqpA3OKS1
         eNgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=DEG/KDHanKqZe+WzYjSLFff9rFKakaJDsiFb2U0inBk=;
        b=ZB9FxrTCG5F8FbRWMhzztJkOK1MUWEfxGMw9DK/dEpG4bAxWVXcLjYCuWNY6WKvXj+
         ZAdRP8YhGcKgLghQGPo79ZBaKmUCvUSsiYi7QF8oKeeBZe0vHURyDvw4H+06Pm+CIHy9
         NFqawtY/lgNmJaQ6bapbiRCymODTw7RPYejge7LEn33yRPsA5rAx7Xh2bbElNx038kgJ
         QO2yLiyZ89/tVYaK+M5VUIbeXkK30SB93n9PCFuQfb0n4oDVQQpOcu7T2LyxfH8hYzBe
         KCyfxQODU2JH2pcNjGB069lc3GkyO/GcKowqcOEfiYZa3siMgkltrFjbJVVzrsjwzj4y
         XOJQ==
X-Gm-Message-State: ACgBeo0LWJd9ZP9V67fAhbgC9gUOuRcOL6yIU+3f/vGc782vuxeWyhVj
        QTd1p9wqUD6gF4f0EeYB0rhB8R3vdqP7VU1DbgM=
X-Google-Smtp-Source: AA6agR7o6+cbAmbBXWrOEVSD8/8jpNtunHuIYuQyyAHx1LwhKi1/Xxr3KRLSmAnNCs+diMAHKFF+AYFi8krAbUbaSjc=
X-Received: by 2002:aa7:ccc4:0:b0:43d:9e0e:b7ff with SMTP id
 y4-20020aa7ccc4000000b0043d9e0eb7ffmr17529084edt.14.1660620825187; Mon, 15
 Aug 2022 20:33:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220810190724.2692127-1-kafai@fb.com> <20220810190809.2698442-1-kafai@fb.com>
In-Reply-To: <20220810190809.2698442-1-kafai@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 15 Aug 2022 20:33:33 -0700
Message-ID: <CAEf4BzZqyE9XKePk0pf8U7-3ei17vO8jQiEBH_fTN7vOst+gWg@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 07/15] bpf: Initialize the bpf_run_ctx in bpf_iter_run_prog()
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
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 10, 2022 at 12:11 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> The bpf-iter-prog for tcp and unix sk can do bpf_setsockopt()
> which needs has_current_bpf_ctx() to decide if it is called by a
> bpf prog.  This patch initializes the bpf_run_ctx in
> bpf_iter_run_prog() for the has_current_bpf_ctx() to use.
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  include/linux/bpf.h   | 2 +-
>  kernel/bpf/bpf_iter.c | 5 +++++
>  2 files changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 0a600b2013cc..15ab980e9525 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1967,7 +1967,7 @@ static inline bool unprivileged_ebpf_enabled(void)
>  }
>
>  /* Not all bpf prog type has the bpf_ctx.
> - * Only trampoline and cgroup-bpf have it.
> + * Only trampoline, cgroup-bpf, and iter have it.

Apart from this part which I'd drop, lgtm:

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>   * For the bpf prog type that has initialized the bpf_ctx,
>   * this function can be used to decide if a kernel function
>   * is called by a bpf program.
> diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
> index 4b112aa8bba3..6476b2c03527 100644
> --- a/kernel/bpf/bpf_iter.c
> +++ b/kernel/bpf/bpf_iter.c
> @@ -685,19 +685,24 @@ struct bpf_prog *bpf_iter_get_info(struct bpf_iter_meta *meta, bool in_stop)
>
>  int bpf_iter_run_prog(struct bpf_prog *prog, void *ctx)
>  {
> +       struct bpf_run_ctx run_ctx, *old_run_ctx;
>         int ret;
>
>         if (prog->aux->sleepable) {
>                 rcu_read_lock_trace();
>                 migrate_disable();
>                 might_fault();
> +               old_run_ctx = bpf_set_run_ctx(&run_ctx);
>                 ret = bpf_prog_run(prog, ctx);
> +               bpf_reset_run_ctx(old_run_ctx);
>                 migrate_enable();
>                 rcu_read_unlock_trace();
>         } else {
>                 rcu_read_lock();
>                 migrate_disable();
> +               old_run_ctx = bpf_set_run_ctx(&run_ctx);
>                 ret = bpf_prog_run(prog, ctx);
> +               bpf_reset_run_ctx(old_run_ctx);
>                 migrate_enable();
>                 rcu_read_unlock();
>         }
> --
> 2.30.2
>
