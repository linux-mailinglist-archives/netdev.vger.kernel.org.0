Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B17512FD923
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 20:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387796AbhATTHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 14:07:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392298AbhATS7V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 13:59:21 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0874EC0613CF
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 10:58:41 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id o10so3805390wmc.1
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 10:58:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Da0Os/7sx4er7foV9GW1VOQA0x7FItKgVqYSm/3LBhg=;
        b=MRMKS/Y4O2EyDAjX0FEgOiEF+2vZ4NUdfvs8KSujHP7PM+lIQMqSKs6V5oqrFAtRKG
         9nR95FoaewTLJ/ndL1HNbxs+sIOPb3Qrl1vqBtbiCXQN6nRePCcVGeco9Jnl1X+cErkk
         DV5k/gumv5jeL/Sd73Qq27iuVHF0T++Oe76AG1YbyMTgziqYqGtYanqKovMkrpW6/jSb
         bEZzbZZycgARNNmmGMKjyv831uYc4WINz/fiErYwEAbpbGo9kquimOofVBotIWm1GbkZ
         vjE66dBaT1Lus1qe9d/rseF4nt0sYwzvATlFjKkSe1SmyEr31MPqTO4yhMJTqCnbrtv9
         Mzkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Da0Os/7sx4er7foV9GW1VOQA0x7FItKgVqYSm/3LBhg=;
        b=OvQSu0yrnrMSu1Z7CjeN920qIoWo6cX9ecifZQsVr+S6/3F3JfAzGG91e9nGEwlzyF
         xGmc6fXzJMRGOyfsIvwatgL504VgJYbqtnoQGt2/VIhBVkSooOdwwzzpawAGZWcXRgZ5
         cbUpWZD4GRNTPVaXC44dBg7afjpF3ffFBrx7XOAjWg/nmpxDE3AqiiU1pEiq9xNfKHsD
         GpH5HD3NL/HIXqYWyAcafpDT19nrIE9HFHNoomvFDoUu82d8rapuKesarrMxOn+goTxJ
         u8o3QmrW1bs/9bdYKkb+BFidKbC1oI+ku5AY4Jwdn1JL5C8OcJnQXySJslEMTjEOdIRl
         gVEQ==
X-Gm-Message-State: AOAM532AQ6Yvo/wSZOMIpRiF6zU89yUCWgYG+7hGFOB1odKESj49DzCz
        OMXtVdU9y7GHqjdNDlqzr+uWYSAgi38dvxJ8rwc3afZFXA+/WA==
X-Google-Smtp-Source: ABdhPJx+OOlQ/LpoV7DU30eZEqhyHC5R2AMA21UUY3DLXvYAvsBCcHjdKjvo0pUNuzVkiuV+sox4bdpU7HPnuC12mRA=
X-Received: by 2002:a1c:2289:: with SMTP id i131mr5864619wmi.119.1611169119571;
 Wed, 20 Jan 2021 10:58:39 -0800 (PST)
MIME-Version: 1.0
References: <1611139794-11254-1-git-send-email-yangpc@wangsu.com> <CADVnQykgYGc4_U+eyXU72fky2C5tDQKuOuQ=BdfqfROTG++w7Q@mail.gmail.com>
In-Reply-To: <CADVnQykgYGc4_U+eyXU72fky2C5tDQKuOuQ=BdfqfROTG++w7Q@mail.gmail.com>
From:   Yuchung Cheng <ycheng@google.com>
Date:   Wed, 20 Jan 2021 10:58:02 -0800
Message-ID: <CAK6E8=e1sdqntpLzeaGKhFB_DhhcNrJmPBQ3u9M44fSqdNTg_Q@mail.gmail.com>
Subject: Re: tcp: rearm RTO timer does not comply with RFC6298
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Pengcheng Yang <yangpc@wangsu.com>,
        Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 6:59 AM Neal Cardwell <ncardwell@google.com> wrote:
>
> On Wed, Jan 20, 2021 at 5:50 AM Pengcheng Yang <yangpc@wangsu.com> wrote:
> >
> > hi,
> >
> > I have a doubt about tcp_rearm_rto().
> >
> > Early TCP always rearm the RTO timer to NOW+RTO when it receives
> > an ACK that acknowledges new data.
> >
> > Referring to RFC6298 SECTION 5.3: "When an ACK is received that
> > acknowledges new data, restart the retransmission timer so that
> > it will expire after RTO seconds (for the current value of RTO)."
> >
> > After ER and TLP, we rearm the RTO timer to *tstamp_of_head+RTO*
> > when switching from ER/TLP/RACK to original RTO in tcp_rearm_rto(),
> > in this case the RTO timer is triggered earlier than described in
> > RFC6298, otherwise the same.
> >
> > Is this planned? Or can we always rearm the RTO timer to
> > tstamp_of_head+RTO?
> >
> > Thanks.
> >
>
> This is a good question. As far as I can tell, this difference in
> behavior would only come into play in a few corner cases, like:
>
> (1) The TLP timer fires and the connection is unable to transmit a TLP
> probe packet. This could happen due to memory allocation failure  or
> the local qdisc being full.
>
> (2) The RACK reorder timer fires but the connection does not take the
> normal course of action and mark some packets lost and retransmit at
> least one of them. I'm not sure how this would happen. Maybe someone
> can think of a case.
>
> My sense would be that given how relatively rare (1)/(2) are, it is
> probably not worth changing the current behavior, given that it seems
> it would require extra state (an extra u32 snd_una_advanced_tstamp? )
> to save the time at which snd_una advanced (a cumulative ACK covered
> some data) in order to rearm the RTO timer for snd_una_advanced_tstamp
> + rto.

also there's an experimental proposal
https://tools.ietf.org/html/rfc7765

so Linux actually implements that in a limited way that only applies
in specific scenarios.

>
> neal
