Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F406357BC59
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 19:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232829AbiGTRKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 13:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233513AbiGTRKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 13:10:12 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 746201B797
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 10:10:11 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id 7so15589080ybw.0
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 10:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7RJxbc6X+Lqd7Ps0PV6dZcLQEF/AiZQzRAhaI8EtSwc=;
        b=h7uhrzu9AgTNk8DgnUwlDwuKu7y/FEGnlWi0fFONmJjPM6JsL4Zf+DP8AjFERCJgXi
         Cd1NVjGJ5q+dheIZmlF+YGCXTlO4Tyfxj5hEQ6aQyt3TMWAXMUGoUpPoJmDWzbno+tBh
         sC7FHelgKdRGv1ci8jYpE+QlOWL8kDb2XMGYHthklSDbifPtrlhz3VGoqIAiHF6VoTwj
         6OdFqzG8tZXuf/6PfRz0ezJCLwiIW6lOMuj0TRDzxb/SV7T4LhSXo6psu1OjfA3ao30r
         0VfJFUxVEcan+AHRemoH2pbs3Tfkf83JGJR/e3fypqJRI0jLPKXZ4huMcsK2m75n+sKx
         uEnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7RJxbc6X+Lqd7Ps0PV6dZcLQEF/AiZQzRAhaI8EtSwc=;
        b=fx1yVkzv9T1jgdryEVfIfwbpj0Ocm+H3XUmksVAegHtqVqz6wZdnLtI28acnO+3CK9
         9wdFg5xYHWjeolsVlydp4A4vomnkCmuBGI6zjOt+4wNoYh4l27SfkWINO3G6WBdJMW6Z
         QszWja4+Fyry8FctcZ4Q1VOTOGD2T3hBZJPJoOWs1pPkF3paZjtwpWrQx6On6o8w6RZg
         X6Zbq7UJ8ntlz/5UWCeHuhQic7eDl1oMbh+JtHmFWHi7F3y3ElwUiVzbQ+oScsnS+EiE
         k8QTtvpolS8qOb2SPRd6hiH3PU//NuVn9wrMbH612UUlSuS+jNgkNquDnlmPc0fk1OOM
         nCRQ==
X-Gm-Message-State: AJIora8AhRfw+5jgz99IZ0ZUa+rDQHBJ8MaH7B3MPDMwhe5MqTQaRpJ8
        MZvDofUPMpAP4jwn/Jb1/z2lepxXFY+2rzgD63uS7A==
X-Google-Smtp-Source: AGRyM1u5Flf9OQv4+m8UdpU25c8MKBtRtwaqt6H0hbgJU0fMZc7GBRVJ7JulaDPnDlnck22wJNrJ5UHzw0ov/6n2ubo=
X-Received: by 2002:a05:6902:114b:b0:66f:d0:57c7 with SMTP id
 p11-20020a056902114b00b0066f00d057c7mr37650036ybu.55.1658337010325; Wed, 20
 Jul 2022 10:10:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220715052235.1452170-1-kuba@kernel.org> <20220715052235.1452170-2-kuba@kernel.org>
 <CANn89iLtDU+w=5bb89Om5FGx6MrQwsDBQKp8UL6=O21wS0LFqw@mail.gmail.com> <20220720095936.3cfa28bc@kernel.org>
In-Reply-To: <20220720095936.3cfa28bc@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 20 Jul 2022 19:09:59 +0200
Message-ID: <CANn89iKcmSfWgvZjzNGbsrndmCch2HC_EPZ7qmGboDNaWoviNQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 01/11] tls: rx: allow only one reader at a time
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>, vfedorenko@novek.ru
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

On Wed, Jul 20, 2022 at 6:59 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 20 Jul 2022 10:37:02 +0200 Eric Dumazet wrote:
> > > +               if (!timeo)
> > > +                       return -EAGAIN;
> >
> > We return with socket lock held, and callers seem to not release the lock.
> >
> > > +               if (signal_pending(current))
> > > +                       return sock_intr_errno(timeo);
> >
> > same here.
>
> Thanks a lot for catching these.
>
> > Let's wait for syzbot to catch up :)
>
> I'll send the fixes later today. This is just a passing comment, right?
> There isn't a report you know is coming? Otherwise I can wait to give
> syzbot credit, too.

I now have a full syzbot report, with a repro and bisection, I am
releasing it now.

>
> I have two additional questions while I have you :)
>
> Is the timeo supposed to be for the entire operation? Right now TLS
> seems to use a fresh timeo every time it goes to wait so the cumulative
> wait can be much longer, as long as some data keeps coming in :/

Good question. I am not sure how this timeout is used in applications, but
I would think it serves as a way to make sure a stall is detected.
So restarting the timeout every time there is progress would make sense.

Application needing a different behavior can still use regular timer,
independent of networking, ( alarm() being the most simple one)

>
> Last one - I posted a bit of a disemboweling patch for TCP, LMK if it's
> no bueno:
>
> https://lore.kernel.org/all/20220719231129.1870776-6-kuba@kernel.org/
