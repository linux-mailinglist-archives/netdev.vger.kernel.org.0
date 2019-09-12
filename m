Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9799DB1302
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 18:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730240AbfILQsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 12:48:50 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45510 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726744AbfILQsu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 12:48:50 -0400
Received: by mail-pg1-f194.google.com with SMTP id 4so13756857pgm.12
        for <netdev@vger.kernel.org>; Thu, 12 Sep 2019 09:48:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Kqq7sIjPtw89XN/e42zrVXuxfVziFrFnbqEJAB1wO2I=;
        b=fxlqjbDVo/FW4gVb0VAB9xPQCzLmQrhSmlTNq50SggJZ86yy5dhMSp37skSSIUs0S0
         5WnLSzScF69Ry/vzn82UFFGVSDjyQhjAC4QpNd9OTpTk0XzVjgFntEDBHpZ6VtTSi0pB
         m1KeFyuCRIhD8v11XVzAv1AzbEYruy5NVpnS8dCcngGtyOEi9cUANa8EA4wHREF4GHpV
         tQa6rPypvQA+JX1tRrsGCRLkZjp8h/U3MyTczsafPFZ8FZ4MQmE4c3gNSZ1y97tBqFRC
         +LGQ3Qsmqe6hLYPS6EOy+8h2sgnUt/ZjlizekdON/ZZsEMKRalzWcB9Mb3rHQ462we6+
         mHgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kqq7sIjPtw89XN/e42zrVXuxfVziFrFnbqEJAB1wO2I=;
        b=OmTR1ssF74QS988r/hpagaaOkI+33ikiPiRCSm1oYCtmk8QAFCqYef6MqKnh9FodUQ
         sfLY/EWo8mb7jeljJoYngMxLgJboRRMWKzI84PWIITipMSstTht68O42JQ0vEx51if0Q
         Kg/OWT6XtMaXjxNeZQV946GvHdyWBGjy7FnBFRwaKSIiCX5PYDhTiIOee7Kbh5/QjH/g
         jBAwQyOmdkLbGlZ0IJPeEFW4ENbAXoNFjqBiAkOAdctJxFjR6dtQVIVDYSsHROzf4Bg/
         h+PctIQiUrEW7mM88e9pQ2dYAgesNnS/cIBRcOH6rnAZnJDrKLAB7SIAMkY37jlHspEH
         Xjkw==
X-Gm-Message-State: APjAAAUfsFiHxgIME0f6aS+MYTDMFGzKi+XBQRXz63KvSqHL+Eioxeya
        Gr499LNHsKZOlc1VH3Yck6vaqkwtsd/+Nh1/bLY=
X-Google-Smtp-Source: APXvYqw4rQoBAlfOQCui6gEWUogbB4nVk43Rl7Ubp2UBWkoq0BBR7f2t/bvs9PiJ7xeoCjiDGA4WWGXiZ3xKF4isDYU=
X-Received: by 2002:a62:4d45:: with SMTP id a66mr47629373pfb.24.1568306929299;
 Thu, 12 Sep 2019 09:48:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190911183445.32547-1-xiyou.wangcong@gmail.com>
 <7b5b69a9-7ace-2d21-f187-7a81fb1dae5a@gmail.com> <CAM_iQpVP6qVbWmV+kA8UGXG6r1LJftyV32UjUbqryGrX5Ud8Nw@mail.gmail.com>
 <CAHk-=whO37+O-mohvMODnD57ppCsK3Bcv8oHzSBvmwJbsT54cA@mail.gmail.com>
In-Reply-To: <CAHk-=whO37+O-mohvMODnD57ppCsK3Bcv8oHzSBvmwJbsT54cA@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 12 Sep 2019 09:48:38 -0700
Message-ID: <CAM_iQpWWSO_RBE-1ja0N88=ZedmCU4J37CyoQ=zME=Q0Fiq_Xg@mail.gmail.com>
Subject: Re: [Patch net] sch_sfb: fix a crash in sfb_destroy()
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzbot <syzbot+d5870a903591faaca4ae@syzkaller.appspotmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 12, 2019 at 3:31 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Thu, Sep 12, 2019 at 2:10 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > On Wed, Sep 11, 2019 at 2:36 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > >
> > > It seems a similar fix would be needed in net/sched/sch_dsmark.c ?
> > >
> >
> > Yeah, or just add a NULL check in dsmark_destroy().
>
> Well, this was why one of my suggestions was to just make
> "qdisc_put()" be happy with a NULL pointer (or even an ERR_PTR()).
>
> That would have fixed not just sfb, but also dsmark with a single patch.

Sure, I don't have any preference here, just want to find a minimum
fix for -stable.

I will send v2.

Thanks.
