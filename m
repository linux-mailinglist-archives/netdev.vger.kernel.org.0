Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA3A04B3CA1
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 18:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237517AbiBMRuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 12:50:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233106AbiBMRup (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 12:50:45 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F22F65A098
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 09:50:39 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id v186so39892586ybg.1
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 09:50:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zWdm+p4NcyfWnaF/hOU8AJkKj94DpB8kTr4sbwdnpIQ=;
        b=a+o7X9ffJoZN9SNLvG/Da5fK3UY21xr6rVL30k4UlnZFnCYbeIsTLtKb/YdR4iGSVl
         kEc+//t3rmmKBJ1SdWh6G8n7RGrKxTqkjLkBw6SYnk1is/8irzebPJU9JlD+NXiC0alS
         NTwe9Ux0YFWrd+r9EGuKuSqfvcordqOApILR0ID190yXRxQnJ1zUXfzMmACjA7PBNLlA
         ZFBRN/jR2pryUkqUYSuZS5LBr+HW6f6zjYOSMd/Y8+eFAMYCzaqjF/QwvRObFJE10eD9
         /DBV3mqT8HXcKt3k6ATbnC15ydesTk34dwLaKZ+RMh4NsFOGw6bo1guHsGL0f6z/DZEA
         Uugw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zWdm+p4NcyfWnaF/hOU8AJkKj94DpB8kTr4sbwdnpIQ=;
        b=vzsPvTq/MBhvXKpDCtwRDRk487aIDjfnFiTHGxvnnSbl7YMsfWPHV2+0P9cdmzAbfg
         nBi7jMNisfgnfxPQMg1Xdo2ln4M28YDoJBBtcub/oywbQzQ8PdAJkhIrgpJxJWeaq+5/
         uTpI/QLsh2b8eV6MlnoyTGKaWCEDHZ788B/M8X/k9sYiQ5BRS2OKyog+YFRWOinlyunL
         WTuJ+tNJYduMEw9FI36LcaIVeC7XzCjErj0IJ0l3t7ERuJmhIc5iLZzo+7HVqwl/tGPA
         yoG0aD/IU3JWYAM5O4gMDHSfOgrPuPVB0FAEwXNgSQI4SriEctf8/k/zoz27vt79pOuV
         /2Mw==
X-Gm-Message-State: AOAM533iehMV6R91Kd4i+yTbMLIhhdev/8LGNniXo9hXhFAzR3TnXguC
        +qfWC7ZO+0rDH2r4ElRi9BIUVNADYc6ZM1vE+eINAayuA1YCr07m
X-Google-Smtp-Source: ABdhPJyLtr1MvPYusNE86mRnQ/Vj/+MBi3NKQGxvKMt3+sr6uTQxl1s9KBugbDISjZCKAXE4U8booKsWC4lu0h1qcyQ=
X-Received: by 2002:a25:c788:: with SMTP id w130mr5113847ybe.753.1644774638792;
 Sun, 13 Feb 2022 09:50:38 -0800 (PST)
MIME-Version: 1.0
References: <20220213040545.365600-1-tilan7663@gmail.com> <CANn89i+=wXy-UFTy1a+1gaVgmynQ9u4LiAutFBf=dsE2fgF3rA@mail.gmail.com>
 <101663cb4d7d43e9b6bfa946f6b8036b@exmbdft6.ad.twosigma.com>
In-Reply-To: <101663cb4d7d43e9b6bfa946f6b8036b@exmbdft6.ad.twosigma.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sun, 13 Feb 2022 09:50:27 -0800
Message-ID: <CANn89iKDzgHk_gk9+56xumy9M40br-aEoUXJ13KtFgxZRQJVOw@mail.gmail.com>
Subject: Re: [PATCH] tcp: allow the initial receive window to be greater than 64KiB
To:     Tian Lan <Tian.Lan@twosigma.com>
Cc:     Tian Lan <tilan7663@gmail.com>, netdev <netdev@vger.kernel.org>,
        Andrew Chester <Andrew.Chester@twosigma.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Sun, Feb 13, 2022 at 9:37 AM Tian Lan <Tian.Lan@twosigma.com> wrote:
>
> > The only way a sender could use your bigger window would be to violate =
TCP specs and send more than > 64KB in the first RTT, assuming the receiver=
 has in fact a RWIN bigger than 64K ????
>
> Just want to clarify, the intent of this patch is not trying to violate t=
he TCP protocol. The goal is to allow the receiver advertise a much "larger=
" rcv_wnd once the connection is established. So instead of having the rece=
iver grow the rcv_wnd starting with 64KiB, the receiver could advertise the=
 new rcv_wnd based on a much larger initial window.
>
> Sorry for the confusion, happy to chat more if you have questions or conc=
erns.

To be clear, if the sender respects the initial window in first RTT ,
then first ACK it will receive allows a much bigger window (at least
2x),
 allowing for standard slow start behavior, doubling CWND at each RTT>

linux TCP stack is conservative, and wants a proof of remote peer well
behaving before opening the gates.

The thing is, we have this issue being discussed every 3 months or so,
because some people think the RWIN is never changed or something.

Last time, we asked to not change the stack, and instead suggested
users tune it using eBPF if they really need to bypass TCP standards.

https://lkml.org/lkml/2021/12/22/652


>
> -----Original Message-----
> From: Eric Dumazet <edumazet@google.com>
> Sent: Saturday, February 12, 2022 11:23 PM
> To: Tian Lan <tilan7663@gmail.com>
> Cc: netdev <netdev@vger.kernel.org>; Andrew Chester <Andrew.Chester@twosi=
gma.com>; Tian Lan <Tian.Lan@twosigma.com>
> Subject: Re: [PATCH] tcp: allow the initial receive window to be greater =
than 64KiB
>
> On Sat, Feb 12, 2022 at 8:06 PM Tian Lan <tilan7663@gmail.com> wrote:
> >
> > From: Tian Lan <Tian.Lan@twosigma.com>
> >
> > Commit 13d3b1ebe287 ("bpf: Support for setting initial receive
> > window") introduced a BPF_SOCK_OPS option which allows setting a
> > larger value for the initial advertised receive window up to the
> > receive buffer space for both active and passive TCP connections.
> >
> > However, the commit a337531b942b ("tcp: up initial rmem to 128KB and
> > SYN rwin to around 64KB") would limit the initial receive window to be
> > at most 64KiB which partially negates the change made previously.
> >
> > With this patch, the initial receive window will be set to the
> > min(64KiB, space) if there is no init_rcv_wnd provided. Else set the
> > initial receive window to be the min(init_rcv_wnd * mss, space).
>
>
> I do not see how pretending to have a large rcvwin is going to help for p=
assive connections, given the WIN in SYN and SYNACK packet is not scaled.
>
> So this patch I think is misleading. Get over it, TCP has not been design=
ed to announce more than 64KB in the 3WHS.
>
> The only way a sender could use your bigger window would be to violate TC=
P specs and send more than 64KB in the first RTT, assuming the receiver has=
 in fact a RWIN bigger than 64K ????
