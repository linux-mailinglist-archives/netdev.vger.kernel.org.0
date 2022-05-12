Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 975E35256F4
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 23:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358681AbiELVSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 17:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358677AbiELVSy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 17:18:54 -0400
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB1058CDAD
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 14:18:52 -0700 (PDT)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-2f7c57ee6feso71583977b3.2
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 14:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l4JJk+ewG2LNWAOShIee96q+d5mTnr66IKaxT9DB1Ig=;
        b=p+VLViJPr40k3kQbPAzBNiPW9Kmv8o59a0sJPe4L6FHZdn06b8e+lqxEm2icfgN7M8
         cuRdhC5ct+EW4wfjW5CqaunZnXi5GplVU/oqKuWLEWMXx4BRMgVOV7uqsCV6VeR3oedB
         Sw30gbGMsyOlN+n9zcA6doK9KeWdvJIpmxOn+R0/mmXkxggbp0GjblysEKck1PDWvfg/
         aMDknvoRWiwQ2n9nMOWZwW6OrbuX/SnQl3fCWF09MRAZu+QZ4SpBLuhg1SYbWLI5iz1a
         3RFmsjz0aWJ3ZsuOLAlXkWhwLn32n1DfyWOOHLjrCHcANtTOmjpItAzkB07EW9JfAurL
         jQSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l4JJk+ewG2LNWAOShIee96q+d5mTnr66IKaxT9DB1Ig=;
        b=GooVSgcdr4XoehVwg9BVOilUvJHg8XB7SZU6SeRBfRGvGhXjA09OGHPEeG1YLs5iIV
         46EbB6NXVO4lony1QFeWusTWB3Msk0c56O283TGHqzDh3fUZtRq9FUDbmPtW/JjIxLAy
         pUqIUB64jT8B2j1Oh2TlfuHdHMu5F/978ccDmIqO7iQ0yQdYGnN49MjwQmfiG8jhhgjC
         +oZv3Eoa9v1umHdSguVwrEmOK8X6L4vI613fDqzoGCRnSggQLO6J7ELTwwD6a7Ai0DyE
         JyWLolPnywa93wwbO/81F21LdSOlYXzga0+YEAbYVR35Pyf/o7iqbphLcHndv6q/XA4J
         g/dg==
X-Gm-Message-State: AOAM532F8ljBiW0PTF5u6XfOQOuzFzWGkgJnH4i2Xyvay8TYve83+Xy2
        SP2nhWLPMZTVqZgX/T1J8A/2ZZMO5IvJevDgnuvDDA==
X-Google-Smtp-Source: ABdhPJyP2X1EcFupaifbXZ28oMOBGFHPAjxR2D1ve+Lki2Tw6rePByxEyHT+aLUhrc6jA0aD9BnBKmE85kLCzc6+PLE=
X-Received: by 2002:a0d:cbd8:0:b0:2fb:958e:d675 with SMTP id
 n207-20020a0dcbd8000000b002fb958ed675mr2270591ywd.264.1652390331960; Thu, 12
 May 2022 14:18:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220512103322.380405-1-liujian56@huawei.com> <CANn89iJ7Lo7NNi4TrpKsaxzFrcVXdgbyopqTRQEveSzsDL7CFA@mail.gmail.com>
In-Reply-To: <CANn89iJ7Lo7NNi4TrpKsaxzFrcVXdgbyopqTRQEveSzsDL7CFA@mail.gmail.com>
From:   Marco Elver <elver@google.com>
Date:   Thu, 12 May 2022 23:18:15 +0200
Message-ID: <CANpmjNPRB-4f3tUZjycpFVsDBAK_GEW-vxDbTZti+gtJaEx2iw@mail.gmail.com>
Subject: Re: [PATCH net] tcp: Add READ_ONCE() to read tcp_orphan_count
To:     Eric Dumazet <edumazet@google.com>,
        "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Liu Jian <liujian56@huawei.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 May 2022 at 22:06, Eric Dumazet <edumazet@google.com> wrote:
>
> On Thu, May 12, 2022 at 3:32 AM Liu Jian <liujian56@huawei.com> wrote:
> >
> > The tcp_orphan_count per-CPU variable is read locklessly, so this commit
> > add the READ_ONCE() to a load in order to avoid below KCSAN warnning:
> >
> > BUG: KCSAN: data-race in tcp_orphan_count_sum net/ipv4/tcp.c:2476 [inline]
> > BUG: KCSAN: data-race in tcp_orphan_update+0x64/0x100 net/ipv4/tcp.c:2487
> >
> > race at unknown origin, with read to 0xffff9c63bbdac7a8 of 4 bytes by interrupt on cpu 2:
> >  tcp_orphan_count_sum net/ipv4/tcp.c:2476 [inline]
> >  tcp_orphan_update+0x64/0x100 net/ipv4/tcp.c:2487
> >  call_timer_fn+0x33/0x210 kernel/time/timer.c:1414
> >
> > Fixes: 19757cebf0c5 ("tcp: switch orphan_count to bare per-cpu counters")
> > Signed-off-by: Liu Jian <liujian56@huawei.com>
> > ---
> >  net/ipv4/tcp.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > index cf18fbcbf123..7245609f41e6 100644
> > --- a/net/ipv4/tcp.c
> > +++ b/net/ipv4/tcp.c
> > @@ -2718,7 +2718,7 @@ int tcp_orphan_count_sum(void)
> >         int i, total = 0;
> >
> >         for_each_possible_cpu(i)
> > -               total += per_cpu(tcp_orphan_count, i);
> > +               total += READ_ONCE(per_cpu(tcp_orphan_count, i));
>
> We might raise the discussion to lkml and/or KCSAN supporters.
>
> Presumably, all per_cpu() uses in the kernel will have the same issue ?
>
> By definition per-cpu data can be changed by other cpus.
>
> So maybe per_cpu() should contain the annotation, instead of having to
> annotate all users.

I guess the question is, is it the norm that per_cpu() retrieves data
that can legally be modified concurrently, or not. If not, and in most
cases it's a bug, the annotations should be here.

Paul, was there any guidance/documentation on this, but I fail to find
it right now? (access-marking.txt doesn't say much about per-CPU
data.)

Thanks,
-- Marco
