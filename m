Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDEF213C888
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 16:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbgAOP4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 10:56:48 -0500
Received: from mail-yb1-f194.google.com ([209.85.219.194]:42646 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbgAOP4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 10:56:48 -0500
Received: by mail-yb1-f194.google.com with SMTP id c8so2504996ybk.9
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 07:56:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YdjfKgKLetCGu1ZW0KgSpCEYsKsIG0dHJMv78sEvBPA=;
        b=SG/MW7+K/+h9MnuBquRvqt7I/sPgIUR+qLh8r3da1WVGVngLB6Kj/AT8xRajIh2yMs
         ks52uuq0S2RE8gRbtHK4dqXoUSqRapPyabAsSDsgo5tFVjR5pEnx2jf97MQgScQIZMu0
         IvDIZ992OQwipAqoA5wYx1HAKQhDy0z73pE+FRbqQopyV87MMDQylhn9XbBmiGakn4xE
         /fOata6juWfAvBy1sKcGDyxMEjfrcauaF3rtc34xojs8U+xzRLYIOq4MQ8TunbZz17RU
         9wcQp3PAhiheuO854NyaNuiBLhewzIpo4e+8bGaG8D0mHVrTI8FZNgt0Pz5i7hfa967S
         EJvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YdjfKgKLetCGu1ZW0KgSpCEYsKsIG0dHJMv78sEvBPA=;
        b=KY9ILD9jVDW29MeoYYs4pPBKCTGPB/X8jTtCXa8zGnPRVUQNgzoG7+PCaM+f9oBp1n
         31OktE9V3GcK5sYA+hs2K93bZMPyeU2891SI0dyrcHykViWzaAU7KzjJzQ3yiKHkVtn4
         MfO0zt+Xxu074cwBOghE9xSZ+UuIpTHxwDPty1iwTvmyOQmw12Csriaz16c+/GlbYBZo
         4bYDoVQMOkvVtBG8yN+vhFcJWO5jyhtmwo/9P9TQtW+WiTz/ucuWMt6U4Nt1AUYD3/yS
         mrF7naQszcHufwivvCy1ilSc31QH5ybD+tCQnni1RbFpmzta6qiedtzzjYg2Zlwm7A/b
         JX7g==
X-Gm-Message-State: APjAAAVlnfNGEPTSvh/jCAkXMyCAXBZGICfPTBlSzfP5U4meBlOpiXPb
        eUB5PTd/GCpQ2wjwgMmi/35a++HmkQm+iTxsvxKPTQ==
X-Google-Smtp-Source: APXvYqyYPDovXaHYAKMejdIGa9GE9pNOpGZDh226ffCJfyI/eIjkD/t4T90aRtX985QmivaNy0o6vYDaQ50OgbWTLCE=
X-Received: by 2002:a25:7c42:: with SMTP id x63mr23200599ybc.101.1579103806495;
 Wed, 15 Jan 2020 07:56:46 -0800 (PST)
MIME-Version: 1.0
References: <20200114215128.87537-1-edumazet@google.com> <7b6aad5de9b62323f0a8b24ce2d5c7d5adcd89b4.camel@redhat.com>
In-Reply-To: <7b6aad5de9b62323f0a8b24ce2d5c7d5adcd89b4.camel@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 15 Jan 2020 07:56:35 -0800
Message-ID: <CANn89iLi2eAHTMveBQviUOh5v3qdiw7xBZRsucAW4CemrAnzHw@mail.gmail.com>
Subject: Re: [PATCH net] net/sched: act_ife: initalize ife->metalist earlier
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 15, 2020 at 1:14 AM Davide Caratti <dcaratti@redhat.com> wrote:
>
> On Tue, 2020-01-14 at 13:51 -0800, Eric Dumazet wrote:
> > It seems better to init ife->metalist earlier in tcf_ife_init()
> > to avoid the following crash :
>
> hello Eric, and thanks for the patch.
>
> If I well understand the problem, we have
>
> _tcf_ife_cleanup()
>
> that does dereference of NULL ife->metalist,
> because it has not yet initialized by tcf_ife_init(). This happened
> probably because the control action was not valid (hence the Fixes:tag):
> so, tcf_ife_init() jumped to the error path before doing INIT_LIST_HEAD().
>
> I applied your patch to my tree, and I see this:
>
> net/sched/act_ife.c: In function 'tcf_ife_init':
> net/sched/act_ife.c:533:3: warning: 'ife' may be used uninitialized in
> this function [-Wmaybe-uninitialized]
>    INIT_LIST_HEAD(&ife->metalist);
>    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>
> And I think the warning is telling us a real problem, because
>
>         ife = to_ife(*a);
>

Oops right, thanks for catching this. I am sending a V2.
