Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAA343F7B94
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 19:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234115AbhHYRbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 13:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232053AbhHYRba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 13:31:30 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3194C061757
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 10:30:44 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id f15so428039ybg.3
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 10:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IjaKFcdDlMXQhr8y0HwTBE8DtlwAHkcS5mN74swsR6Y=;
        b=BBmNe5wV45Fcry5cA8g1RApKzotuemRgBPCV5EgsXeaUHksOI7Ngb/ESJ766LXC0gm
         LXykKKWEP4DBHAL2wbRnQZ6PNm9cgoJnoIRlLCxNAF2Pl+8+X5S7RmaaiXrE7hb1fc6N
         yr9cDKQPPyMOGsAtpK+HG6vqjyPh/gTah3ijJNcXhUXNmRxUN4DxbJZVNW4SPMR80dtD
         yjAGrmKRPE/g7kN0C0S34Utirqdy7dzVAYnrNP46mPwI6Wd9lrsX3oX2gE7MbYhQiqTf
         ITMFSTMGB24VZv0DZxny099839cMQoDMyz6zJDJ0RvjfPwVRpN5DOZ0rydYYl6p5iqSQ
         hEpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IjaKFcdDlMXQhr8y0HwTBE8DtlwAHkcS5mN74swsR6Y=;
        b=X3/a689MxBAJpZ7jNKo8v0AlL9i4SgVmakC6Vft5j4po5OejZ5bL4Wu+rfaRNZe96u
         mJvZpSqNfef540c1/OqJrB2323R+s0BPJgdp5+TlkBnF2Y+3MvaMgra3AuY1tvr5I8pW
         zQGxsYqkMcEdzBUm5tajRP4CKH3HcGREMZqQCQhNWrA7Fsrg0vxiuHOcWGIBqJnjGDyK
         An0eiRxDR8mRP7/TkRncExSTVUKzsd7Qn6SXZDQW8ziXfiXey8pZEf/8a35DimW/ywWR
         ai7koyqYeY9l8ELcz1ObZCFgMQntrm06xbEPisu84iFZksiQwUDmdHz5VdcqaVGNoKQD
         Y/wQ==
X-Gm-Message-State: AOAM532ekZvsvOfkLfuy0c+/EINF2sg8Cy05rZbS7iM6YAf0b36II24e
        lzhTyQP0dO7dpifh0UtzyOgApUFq7lI27sjAUKAx7g==
X-Google-Smtp-Source: ABdhPJyeMZZUoDCk62uqmfv04cxai6sVPMwaQ4o53o6zml5ROlVvs8babMxPXYIPcSXWjto3r/HMRo05sQJIERBr9L0=
X-Received: by 2002:a25:2cd5:: with SMTP id s204mr11145390ybs.452.1629912643509;
 Wed, 25 Aug 2021 10:30:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210819195443.1191973-1-ntspring@fb.com> <6070816e-f7d2-725a-ec10-9d85f15455a2@gmail.com>
 <BYAPR15MB251818EA80E5569A768F0EC5BAC69@BYAPR15MB2518.namprd15.prod.outlook.com>
In-Reply-To: <BYAPR15MB251818EA80E5569A768F0EC5BAC69@BYAPR15MB2518.namprd15.prod.outlook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 25 Aug 2021 10:30:32 -0700
Message-ID: <CANn89iLjeY6PBACwb0CetwUC3Pn-rryAqsCNytCrcFRwtwC6GA@mail.gmail.com>
Subject: Re: [PATCH net-next v2] tcp: enable mid stream window clamp
To:     Neil Spring <ntspring@fb.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ncardwell@google.com" <ncardwell@google.com>,
        "ycheng@google.com" <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 25, 2021 at 9:57 AM Neil Spring <ntspring@fb.com> wrote:
>
>
> Eric Dumazet wrote:
> > On 8/19/21 12:54 PM, Neil Spring wrote:
> > > The TCP_WINDOW_CLAMP socket option is defined in tcp(7) to "Bound the size of
> > > the advertised window to this value."  Window clamping is distributed across two
> > > variables, window_clamp ("Maximal window to advertise" in tcp.h) and rcv_ssthresh
> > > ("Current window clamp").
> > >
> > > This patch updates the function where the window clamp is set to also reduce the current
> > > window clamp, rcv_sshthresh, if needed.  With this, setting the TCP_WINDOW_CLAMP option
> > > has the documented effect of limiting the window.
> > >
> > > Signed-off-by: Neil Spring <ntspring@fb.com>
> > > ---
> > > v2: - fix email formatting
> > >
> > >
> > >  net/ipv4/tcp.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > >
> > > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > > index f931def6302e..2dc6212d5888 100644
> > > --- a/net/ipv4/tcp.c
> > > +++ b/net/ipv4/tcp.c
> > > @@ -3338,6 +3338,8 @@ int tcp_set_window_clamp(struct sock *sk, int val)
> > >        } else {
> > >                tp->window_clamp = val < SOCK_MIN_RCVBUF / 2 ?
> > >                        SOCK_MIN_RCVBUF / 2 : val;
> > > +             tp->rcv_ssthresh = min(tp->rcv_ssthresh,
> > > +                                    tp->window_clamp);
>
> > This fits in a single line I think.
> >                 tp->rcv_ssthresh = min(tp->rcv_ssthresh, tp->window_clamp);
>
> I'll fix in v3 in a moment, thanks!
>
> > >        }
> > >        return 0;
> > >  }
> > >
>
> > Hi Neil
> >
> > Can you provide a packetdrill test showing the what the new expected behavior is ?
>
> Sure.  I submitted a pull request on packetdrill -
> https://github.com/google/packetdrill/pull/56 - to document the intended behavior.
>
> > It is not really clear why you need this.
>
> The observation is that this option is currently ineffective at limiting once the
> connection is exchanging data. I interpret this as a result of only looking at
> the window clamp when growing rcv_ssthresh, not as a key to reduce this
> limit.
>
> The packetdrill example will fail at the point where an ack should have a reduced
> window due to the clamp.
>
> > Also if we are unable to increase tp->rcv_ssthresh, this means the following sequence
> > will not work as we would expect :
>
> > +0 setsockopt(5, IPPROTO_TCP, TCP_WINDOW_CLAMP, [10000], 4) = 0
> > +0 setsockopt(5, IPPROTO_TCP, TCP_WINDOW_CLAMP, [100000], 4) = 0
>
> The packetdrill shows that raising the window clamp works:
> tcp_grow_window takes over and raises the window quickly, but I'll add
> a specific test for this sequence (with no intervening data) to confirm.

Sure, raising the window clamping is working (even before your patch)

But after your patch, rcv_ssthresh will still be 10000, instead of
something maybe bigger ?

>
> > Thanks.
>
> Thanks Eric!
>
> -neil
