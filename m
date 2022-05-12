Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C803525634
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 22:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358252AbiELUGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 16:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343705AbiELUGj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 16:06:39 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19ADB5DBD0
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 13:06:38 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id j84so958587ybc.3
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 13:06:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7xSrUdnA1OiCjH5kvyp3iABoTsJX17lF1oCQIDPuInU=;
        b=oJmTqas0xC+2qy+kk8WgzgOdjTx5w6qZApvdhSwAEndyUXURPZKCZLybhoilwzTvzi
         l0wAH2cytfQ+DdcyuxCO7SHCaYu1K4TSjPEqk+L3k7VC+Zu4gqWjwvo9hC/VksHEh4gx
         KI1gfqoqXoOH0kRcq+gP99WoTnIsG6ly78eiOfDuSde/nrghdfNDqBRFsJunaTgIOojq
         F4lGABgENIBZtk2zqB4b2r5kOlDPoArntlXCiL4orMuzLVG3JyaFvjytpY+/KYIYvCGE
         Pv23RO0Ce1szZ8o4Ql2tVK29DPtkgxhFaMES3xtAOIAiBTUwTENXGRUod0MvS6XbEZ8h
         CERg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7xSrUdnA1OiCjH5kvyp3iABoTsJX17lF1oCQIDPuInU=;
        b=v7pTb4T6so139qP14c5iMbNztOZHi3BL6sKKX/hd1s665nMrZXnlOl8vQhW+aPdlNj
         kq3rJTGv+whhzZeSpo0DmUWmhYHMjwDPv+nOrtrQkOkpobTGDSI/r53Pvm8k+yv7DIQA
         TfIW+BQizIsJuINdR80lbmaPmbzolUiBA2aORzqFlZJwDVlBYwkj19apBy1b3EU9BBGn
         y3WX/1tUlkqgSTs/XZQ1aTqDGyJygWomMqjwB4bMCVn1BoCxUt2ku5vhM/uERFU3jcKm
         Q6bu3hTTAcwUhcP++OGt7B6KYE7gN+yhcV0H/l7/KYWVBXY6tUbmftvJiuoeBPDwgosr
         oeQw==
X-Gm-Message-State: AOAM531sEH5dIwF/gREmOxmmwKIIUz9FAHPtk15Q037pYDlObbCFAiw0
        IV1pBWpHMjNpyxN3VWoqVcdx/87YuOJwISSi0UrR2w==
X-Google-Smtp-Source: ABdhPJw8Y8k43/xV/isf7Q80Xc14MBCGk0QQ/DZqAosKF47RSj1duBiv3pC1djX3bb4W0pu1syMZObddvfAJVrJeVzY=
X-Received: by 2002:a25:230a:0:b0:64b:49c:c67c with SMTP id
 j10-20020a25230a000000b0064b049cc67cmr1573440ybj.598.1652385996916; Thu, 12
 May 2022 13:06:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220512103322.380405-1-liujian56@huawei.com>
In-Reply-To: <20220512103322.380405-1-liujian56@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 12 May 2022 13:06:25 -0700
Message-ID: <CANn89iJ7Lo7NNi4TrpKsaxzFrcVXdgbyopqTRQEveSzsDL7CFA@mail.gmail.com>
Subject: Re: [PATCH net] tcp: Add READ_ONCE() to read tcp_orphan_count
To:     Liu Jian <liujian56@huawei.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Marco Elver <elver@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Neal Cardwell <ncardwell@google.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 12, 2022 at 3:32 AM Liu Jian <liujian56@huawei.com> wrote:
>
> The tcp_orphan_count per-CPU variable is read locklessly, so this commit
> add the READ_ONCE() to a load in order to avoid below KCSAN warnning:
>
> BUG: KCSAN: data-race in tcp_orphan_count_sum net/ipv4/tcp.c:2476 [inline]
> BUG: KCSAN: data-race in tcp_orphan_update+0x64/0x100 net/ipv4/tcp.c:2487
>
> race at unknown origin, with read to 0xffff9c63bbdac7a8 of 4 bytes by interrupt on cpu 2:
>  tcp_orphan_count_sum net/ipv4/tcp.c:2476 [inline]
>  tcp_orphan_update+0x64/0x100 net/ipv4/tcp.c:2487
>  call_timer_fn+0x33/0x210 kernel/time/timer.c:1414
>
> Fixes: 19757cebf0c5 ("tcp: switch orphan_count to bare per-cpu counters")
> Signed-off-by: Liu Jian <liujian56@huawei.com>
> ---
>  net/ipv4/tcp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index cf18fbcbf123..7245609f41e6 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -2718,7 +2718,7 @@ int tcp_orphan_count_sum(void)
>         int i, total = 0;
>
>         for_each_possible_cpu(i)
> -               total += per_cpu(tcp_orphan_count, i);
> +               total += READ_ONCE(per_cpu(tcp_orphan_count, i));

We might raise the discussion to lkml and/or KCSAN supporters.

Presumably, all per_cpu() uses in the kernel will have the same issue ?

By definition per-cpu data can be changed by other cpus.

So maybe per_cpu() should contain the annotation, instead of having to
annotate all users.


>
>         return max(total, 0);
>  }
> --
> 2.17.1
>
