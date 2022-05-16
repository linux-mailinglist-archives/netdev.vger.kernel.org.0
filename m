Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 783DD529213
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 23:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349209AbiEPVGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 17:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348776AbiEPVGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 17:06:33 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D6AD3389A
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 13:43:35 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id q135so9865323ybg.10
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 13:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SWGK+KTkisZs3C9bpsTAI0RXU+XBBpI5GfJ2Y1m5tyc=;
        b=hOehNX6QH9tf4lx/ThE1sqy/2wL6wKWhDSeCIriioTBRNZCxC7tSJBk2UFgr2bE7Wc
         8erEAOXeZ/kNcy3OvVftcP28FwlNjTM/gXGI/J8Dhk0a4zbUwW5Lqhfy1BcgFzPLgt4W
         vRxxIYyGVQuDSwMOncm6OvYwZOQg9oPIe72OO69C5hj6B9c0KO/zMMpyrQiQ0EjNwGAd
         Y6DFjooJm+HMIY/uCV6J7o/Dox7XPDd1KHOZGvgy7rhycF7RzDkZ5nYZ9iUXcbYRlopK
         5qGOQx8UOPG8E8fxPJvZ3z3Ivn0hEiiu238QEiPbTmDFlgHoRJAVUUw4kVqGVViSh7hD
         rqYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SWGK+KTkisZs3C9bpsTAI0RXU+XBBpI5GfJ2Y1m5tyc=;
        b=qsdwEaDSc9pKqSL04MwpPkgWa0108BIkdKqxQYyDwiMNDt7nJbifqBTvShF75kpYxX
         5Ps0xnErgpm4PxOWsvhiJyCs204N5RVmKyNcUeRrY7ujya2Rt8p8XKFCZ3yCA2IbT2WG
         1m/Y0NtXThyFdx4eqeAWECHC1IVK85NY1jtGqqMV+gvBC3rLCZm2yM+lY9HiQg2CRpsq
         g5q7New2P5rn2rSIStfTz2DoVAMewTbwGWJFfKQPESb1i0YwH5QAfTwyUpxT5e64UCF0
         FT3jx1aPO7sG/dMRbFTuH4bN+O/f3+pmIYIHXI1MHjWQEBvHNndPw1wtPdXJKbTGmf47
         eI+w==
X-Gm-Message-State: AOAM530WOI0WWtKg0ik1moU21PjAg3FV+7FSxnRmJ2efUsdNY3agcg5b
        pBC0GsGYOEEhF5xtLfKMZ/8osh2n7vcGDCJx3pjWwi9njYD9upEo
X-Google-Smtp-Source: ABdhPJy1EksE+mmZs3jIcAdB7zUiJTxCrKktkz17lIglO/MOSW1K1TETXtIDtL8iWAlWNg29QaQ6/2ijSAHWLIH4544=
X-Received: by 2002:a05:6902:c9:b0:641:1998:9764 with SMTP id
 i9-20020a05690200c900b0064119989764mr19367439ybs.427.1652733814140; Mon, 16
 May 2022 13:43:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220516042456.3014395-1-eric.dumazet@gmail.com>
 <20220516042456.3014395-4-eric.dumazet@gmail.com> <20220516133941.7da6bac7@kernel.org>
In-Reply-To: <20220516133941.7da6bac7@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 16 May 2022 13:43:22 -0700
Message-ID: <CANn89iLmkpmuoLMHUkaigd2V6G6se-0Lj-UwhcaRZow_4fwhow@mail.gmail.com>
Subject: Re: [PATCH net-next 3/4] net: add skb_defer_max sysctl
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
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

On Mon, May 16, 2022 at 1:39 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sun, 15 May 2022 21:24:55 -0700 Eric Dumazet wrote:
> > @@ -6494,16 +6495,21 @@ void skb_attempt_defer_free(struct sk_buff *skb)
> >       int cpu = skb->alloc_cpu;
> >       struct softnet_data *sd;
> >       unsigned long flags;
> > +     unsigned int defer_max;
> >       bool kick;
> >
> >       if (WARN_ON_ONCE(cpu >= nr_cpu_ids) ||
> >           !cpu_online(cpu) ||
> >           cpu == raw_smp_processor_id()) {
> > -             __kfree_skb(skb);
> > +nodefer:     __kfree_skb(skb);
> >               return;
> >       }
> >
> >       sd = &per_cpu(softnet_data, cpu);
> > +     defer_max = READ_ONCE(sysctl_skb_defer_max);
> > +     if (READ_ONCE(sd->defer_count) >= defer_max)
> > +             goto nodefer;
> > +
> >       /* We do not send an IPI or any signal.
> >        * Remote cpu will eventually call skb_defer_free_flush()
> >        */
> > @@ -6513,11 +6519,8 @@ void skb_attempt_defer_free(struct sk_buff *skb)
> >       WRITE_ONCE(sd->defer_list, skb);
> >       sd->defer_count++;
> >
> > -     /* kick every time queue length reaches 128.
> > -      * This condition should hardly be hit under normal conditions,
> > -      * unless cpu suddenly stopped to receive NIC interrupts.
> > -      */
> > -     kick = sd->defer_count == 128;
> > +     /* Send an IPI every time queue reaches half capacity. */
> > +     kick = sd->defer_count == (defer_max >> 1);
>
> nit: it will behave a little strangely for defer_max == 1
> we'll let one skb get onto the list and free the subsequent
> skbs directly but we'll never kick the IPI

Yes, I was aware of this, but decided it was not a big deal.

Presumably people will be interested to disable the thing completely,
I am not sure about defer_max == 1

>
> Moving the sd->defer_count++; should fix it and have no significant
> side effects. I think.

SGTM, thanks !
