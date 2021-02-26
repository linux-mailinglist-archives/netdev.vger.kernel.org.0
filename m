Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D445E3260F4
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 11:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbhBZKIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 05:08:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230503AbhBZKGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 05:06:15 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6B93C06178A
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 02:05:49 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id p193so8396845yba.4
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 02:05:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=49GnFrYPFPHTycmqTkD2BD8ogrbgPPtwTvQ0vamnNhk=;
        b=Nr/IzcE7QEu9SQ+y6Sds0oQt5x5cOMrK3eYuVqzoZcsOn5erO/iZPAdnTTlNZ1LvS7
         XL4CrXsZwalyILzlHPlVfTPgSDpyP+7/GSVfie0l139rkM/LskrkSrJbofAZbMH9Tu/f
         tFWVMRP+yYDnodHTPPP8jbLa023N8xs2QJhb05D8gGFqSIwhxlggXDWuXp4m7F88u2H2
         hGe7ix7AnW9WXMCIOWtkCt/3Kk37Z47lPYQk3za8V57uR+jE09ehUJmnwLxf5DZpF3iv
         VqzrefTY0cIJLRwkWnR3oE2YKv3ZkGG6vH4tUV0ExcqVByIzgIvUF+1g3e1vDVSxJeaV
         UxpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=49GnFrYPFPHTycmqTkD2BD8ogrbgPPtwTvQ0vamnNhk=;
        b=uD72uZoy09+6gU36KNAbklOp39aW6cMYSHXW1yzdZTbwwApx+9oYvCgsyzaNqRnJTI
         r09wYeDcUz6Lt3vC8QannTc1hOtQgKLAyYUaEQYWQ4ILWD/ZBWm73Oej09WMrcjyISEQ
         ptcluo49HkwSNRDsPISmJGClc7tElMQyXWxZjSVCMPPdqOII7jI/AMVgVhO75ivUFXY5
         Lz0Z9TjEUaZy11/SUNyyEhV6oTzR1rPTl02nnqFMhjoTi5dOdCOEDUeGb4c8N3PMzYLJ
         +fy+g3IsAEdxNWiOPj7uQXmcKYFjZZq2owNzCAULPndfXUefR1aQ8wJcgRipm5xZL3d8
         0LgQ==
X-Gm-Message-State: AOAM533ZeBuTyjiRrt32ooYDmEXraPeCRFK5I8iAnGdwbRoaQl9lMGAt
        JpUK2a3K9MofLAvZOtbUavn/gmTzlzujATRwe9ZEWQ==
X-Google-Smtp-Source: ABdhPJyw2iLI6UajEN735zf7e45Mnh0YrNHUzjMaGNqcnmP4wTxrES/vWHDbtkCfmxICE/I/AGF5d83TZV91KSjanG8=
X-Received: by 2002:a25:7306:: with SMTP id o6mr3445451ybc.132.1614333948487;
 Fri, 26 Feb 2021 02:05:48 -0800 (PST)
MIME-Version: 1.0
References: <20210225152515.2072b5a7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210225191552.19b36496@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210225191552.19b36496@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 26 Feb 2021 11:05:37 +0100
Message-ID: <CANn89iJwfXFKnSAQpwaBnfrrE01PXyxLUieBxaB0RzyOajCzLQ@mail.gmail.com>
Subject: Re: Spurious TCP retransmissions on ack vs kfree_skb reordering
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 26, 2021 at 4:15 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 25 Feb 2021 15:25:15 -0800 Jakub Kicinski wrote:
> > Hi!
> >
> > We see large (4-8x) increase of what looks like TCP RTOs after rising
> > the Tx coalescing above Rx coalescing timeout.
> >
> > Quick tracing of the events seems to indicate that the data has already
> > been acked when we enter tcp:tcp_retransmit_skb:
>
> Seems like I'm pretty lost here and the tcp:tcp_retransmit_skb events
> are less spurious than I thought. Looking at some tcpdump traces we see:
>
> 0.045277 IP6 A > B: Flags [SEW], seq 2248382925:2248383296, win 61920, options [mss 1440,sackOK,TS val 658870494 ecr 0,nop,wscale 11], length 371
>
> 0.045348 IP6 B > A: Flags [S.E], seq 961169456, ack 2248382926, win 65535, options [mss 1440,sackOK,TS val 883864022 ecr 658870494,nop,wscale 9], length 0

The SYNACK does not include the prior payload.

> 0.045369 IP6 A > B: Flags [P.], seq 1:372, ack 1, win 31, options [nop,nop,TS val 658870494 ecr 883864022], length 371

So this rtx is not spurious.

However in your prior email you wrote :

bytes_in:      0
bytes_out:   742
bytes_acked: 742

Are you sure that at the time of the retransmit, bytes_acked was 742 ?
I do not see how this could happen.

>
>
> So looks potentially TFO related?
>
> To try to count timeouts I run:
>
> bpftrace --btf -e 'tracepoint:tcp:tcp_retransmit_skb {
>   $icsk = (struct inet_connection_sock *)args->skaddr;
>   if ($icsk->icsk_ca_state != 4) { return; }
>   if ($icsk->icsk_pending)       { return; }
>
>   printf(...);
> }'
>
> At tx-usecs coalescing of 25us I see 0 of those events.
> At 100us there is a few.
> At 200us there is a lot.
