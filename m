Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C809BAD027
	for <lists+netdev@lfdr.de>; Sun,  8 Sep 2019 19:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730351AbfIHRTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Sep 2019 13:19:05 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:39087 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730062AbfIHRTF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Sep 2019 13:19:05 -0400
Received: by mail-lf1-f65.google.com with SMTP id l11so8668199lfk.6
        for <netdev@vger.kernel.org>; Sun, 08 Sep 2019 10:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MN/k8JnJCOEcYirzdoyavFDle+e4eQE4j09q5zgR3Mc=;
        b=P/fOWPzFGuUw2HnbXH0aGI1vTJtMlTcyLYQJDi7B1Fc6zZotQHBs4dKyvRTgVICulo
         PAakjj5F8cfS2TJ/i/Gj9latl50LmDpUKB3ppf/OcTYNuOfab5BrnCwLljNSj7BTCk5m
         QcvzdjLjAqPpiaGGVmEn+6xGYd0KEMGPisGGA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MN/k8JnJCOEcYirzdoyavFDle+e4eQE4j09q5zgR3Mc=;
        b=Jw3c+cW8ZcvcsceyhguPTj6Btw6VMhtaJ2uC+muAfogqUBt9KBIXVhTySSeBnQrIB3
         /Vxaqhsf0LoScqwsAwwNi4IBDtmbJBTAr3o1WZ+C4JLO0Z1DYJfynTzOQvqJtduIjhJv
         4BBF2iJHk2deTOvT+K+g2VJCNaqD1oYgVkLoev8yrH01uqYnopRpzfwQ44fuo+o01ElD
         JfF9+TF6AKz8mWUsmDFvIyhJnVz+6YcdaG3jccMrwd8DGuamSvZTk8Q7Mo1a52Z6c2g5
         LvZBjyoneVIaV9T0Vh0NDkF8TX7b+ol/+g8jgn5o/0gOahHPRRdGBW/3W2Ulwbz8dVM3
         phRw==
X-Gm-Message-State: APjAAAUoJs32YxGZGA4v99O499jB6gmW353uxdwjPDJNTj/zm2XsiLSw
        upDr6Ge34Q7AxfX/4Ns4TNpv5E0Lqcs=
X-Google-Smtp-Source: APXvYqw+Z4dTkp2CjLd7aQ5XO2rqEmV8FeUqA+nIRs8BlU7OQ/I5GL79f3/merqahvwyV50MiiDRBA==
X-Received: by 2002:ac2:4d04:: with SMTP id r4mr13359867lfi.57.1567963141856;
        Sun, 08 Sep 2019 10:19:01 -0700 (PDT)
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com. [209.85.208.173])
        by smtp.gmail.com with ESMTPSA id g10sm2330595lfb.76.2019.09.08.10.18.58
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Sep 2019 10:18:59 -0700 (PDT)
Received: by mail-lj1-f173.google.com with SMTP id q22so5859955ljj.2
        for <netdev@vger.kernel.org>; Sun, 08 Sep 2019 10:18:58 -0700 (PDT)
X-Received: by 2002:a05:651c:1108:: with SMTP id d8mr5088745ljo.180.1567963138439;
 Sun, 08 Sep 2019 10:18:58 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000df42500592047e0a@google.com>
In-Reply-To: <000000000000df42500592047e0a@google.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 8 Sep 2019 10:18:42 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgZneAegyitz7f+JLjB6=28ewtvT7M4xy_a-wqsTjOX_w@mail.gmail.com>
Message-ID: <CAHk-=wgZneAegyitz7f+JLjB6=28ewtvT7M4xy_a-wqsTjOX_w@mail.gmail.com>
Subject: Re: general protection fault in qdisc_put
To:     syzbot <syzbot+d5870a903591faaca4ae@syzkaller.appspotmail.com>
Cc:     akinobu.mita@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Dmitry Vyukov <dvyukov@google.com>, jhs@mojatatu.com,
        jiri@resnulli.us,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 7, 2019 at 11:08 PM syzbot
<syzbot+d5870a903591faaca4ae@syzkaller.appspotmail.com> wrote:
>
> The bug was bisected to:
>
> commit e41d58185f1444368873d4d7422f7664a68be61d
> Author: Dmitry Vyukov <dvyukov@google.com>
> Date:   Wed Jul 12 21:34:35 2017 +0000
>
>      fault-inject: support systematic fault injection

That commit does seem a bit questionable, but not the cause of this
problem (just the trigger).

I think the questionable part is that the new code doesn't honor the
task filtering, and will fail even for protected tasks. Dmitry?

> kasan: GPF could be caused by NULL-ptr deref or user memory access
> general protection fault: 0000 [#1] PREEMPT SMP KASAN
> CPU: 1 PID: 9699 Comm: syz-executor169 Not tainted 5.3.0-rc7+ #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> RIP: 0010:qdisc_put+0x25/0x90 net/sched/sch_generic.c:983

Yes, looks like 'qdisc' is NULL.

This is the

        qdisc_put(q->qdisc);

in sfb_destroy(), called from qdisc_create().

I think what is happening is this (in qdisc_create()):

        if (ops->init) {
                err = ops->init(sch, tca[TCA_OPTIONS], extack);
                if (err != 0)
                        goto err_out5;
        }
        ...
err_out5:
        /* ops->init() failed, we call ->destroy() like qdisc_create_dflt() */
        if (ops->destroy)
                ops->destroy(sch);

and "ops->init" is sfb_init(), which will not initialize q->qdisc if
tcf_block_get() fails.

I see two solutions:

 (a) move the

        q->qdisc = &noop_qdisc;

     up earlier in sfb_init(), so that qdisc is always initialized
after sfb_init(), even on failure.

 (b) just make qdisc_put(NULL) just silently work as a no-op.

 (c) change all the semantics to not call ->destroy if ->init failed.

Honestly, (a) seems very fragile - do all the other init routines do
this? And (c) sounds like a big change, and very fragile too.

So I'd suggest that qdisc_put() be made to just ignore a NULL pointer
(and maybe an error pointer too?).

But I'll leave it to the maintainers to sort out the proper fix.
Maybe people prefer (a)?

                   Linus
