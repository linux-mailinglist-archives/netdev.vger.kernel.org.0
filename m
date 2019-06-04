Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 380B53475E
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 14:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbfFDMyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 08:54:45 -0400
Received: from mail-vs1-f66.google.com ([209.85.217.66]:44749 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727394AbfFDMyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 08:54:44 -0400
Received: by mail-vs1-f66.google.com with SMTP id v129so4146747vsb.11;
        Tue, 04 Jun 2019 05:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I8kO1ihPctG1ALoFxeAqn+bcx97sgjF7Igmu2hN3Q44=;
        b=exCfEpz0aDM5HyM575FloA/YfJ++ceTkjCpBJK2XDsYT/gpO2+xGgJndeT0AC/ht2a
         wkNEotuLchAUzVIFK7e3lM3C+vWW6sEG7IqujCq+/qH/Gbi7xOmh5DpnIG33JQKDsylf
         60g9fz5sTCU66lDj5+XCOUVOSZr41pY18POyyahHIId6UN8/9M0jgMFvQMDneojjaOiE
         1L6LO96oyRw1vaFQSbapW/Gfo/sf3sUry+QLeNLqi162T7LbdR4a/J9kVlIeUS0RLo8o
         AV3bk6hO5+vbLl/bDW0Gx0mDrVu3P080n4+1E2VT7yhIvh6cBtympMYd4vtxvUywvUZw
         TGwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I8kO1ihPctG1ALoFxeAqn+bcx97sgjF7Igmu2hN3Q44=;
        b=UIadTNvFk/uGjFWyb38afnPRFXA0BZGZVVxXMY9g2XW9rrKU9vDjSahrcT/i0jG+V7
         535WmB6yAXplosgWTtURlEiTXRTcVbwIwHjSaYkJERLfnz1eFRELDiif1K939qQ9Kgtj
         I1XQbMMz0sDFEL6Mk03veilZKNuDZqNG6tUPG2yHpP94dl/CHIRW2TxD0d5A8jl8Hvly
         JIVQNaui+w5wrP0/xju4obfcxb1bcL9RCOIov69R3nxItwneIrsJHAkfgWu3lLdogHF8
         vs2/jWR1svullARXQSHajVDa9N8TcmpV+Z6YUWWhHWP+1bchL74SPSxg/OMGw2ttTtb9
         x4zQ==
X-Gm-Message-State: APjAAAWseRT2vZ3drI/gPFHYLAfeMzFPBXwqI9GsogA2Kps+Pax2LRxc
        0TWMmpu7/QxEYXDAl2FWMkw5YSGIQHjT/sfzEWI=
X-Google-Smtp-Source: APXvYqzU2dVgdxzCtI1Ajw8zYy3APA2LeWIn9GRpeCCU4Pvxi/E5TV+54X0G2v27ha80GXHttClSXmmRzeaSXyhw34c=
X-Received: by 2002:a67:cd14:: with SMTP id u20mr737938vsl.36.1559652883964;
 Tue, 04 Jun 2019 05:54:43 -0700 (PDT)
MIME-Version: 1.0
References: <1559651505-18137-1-git-send-email-92siuyang@gmail.com> <a4887243-9018-9926-0cbe-8c1ae3b7769e@iogearbox.net>
In-Reply-To: <a4887243-9018-9926-0cbe-8c1ae3b7769e@iogearbox.net>
From:   Yang Xiao <92siuyang@gmail.com>
Date:   Tue, 4 Jun 2019 20:54:02 +0800
Message-ID: <CAKgHYH1oBX-uquY2F=K5MDc37YKw=ts7NJb3cLRJ6jN0=Z37bA@mail.gmail.com>
Subject: Re: [PATCH] net: compat: fix msg_controllen overflow in scm_detach_fds_compat()
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 4, 2019 at 8:46 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 06/04/2019 02:31 PM, Young Xiao wrote:
> > There is a missing check between kmsg->msg_controllen and cmlen,
> > which can possibly lead to overflow.
> >
> > This bug is similar to vulnerability that was fixed in commit 6900317f5eff
> > ("net, scm: fix PaX detected msg_controllen overflow in scm_detach_fds").
>
> Back then I mentioned in commit 6900317f5eff:
>
>     In case of MSG_CMSG_COMPAT (scm_detach_fds_compat()), I haven't seen an
>     issue in my tests as alignment seems always on 4 byte boundary. Same
>     should be in case of native 32 bit, where we end up with 4 byte boundaries
>     as well.
>
> Do you have an actual reproducer or is it based on code inspection?

based on inspection.
>
> > Signed-off-by: Young Xiao <92siuyang@gmail.com>
> > ---
> >  net/compat.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/net/compat.c b/net/compat.c
> > index a031bd3..8e74dfb 100644
> > --- a/net/compat.c
> > +++ b/net/compat.c
> > @@ -301,6 +301,8 @@ void scm_detach_fds_compat(struct msghdr *kmsg, struct scm_cookie *scm)
> >                       err = put_user(cmlen, &cm->cmsg_len);
> >               if (!err) {
> >                       cmlen = CMSG_COMPAT_SPACE(i * sizeof(int));
> > +                     if (kmsg->msg_controllen < cmlen)
> > +                             cmlen = kmsg->msg_controllen;
> >                       kmsg->msg_control += cmlen;
> >                       kmsg->msg_controllen -= cmlen;
> >               }
> >
>


-- 
Best regards!

Young
-----------------------------------------------------------
