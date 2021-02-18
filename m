Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC8C31ED6F
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 18:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234488AbhBRRiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 12:38:14 -0500
Received: from mail.zx2c4.com ([104.131.123.232]:52782 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232555AbhBRPlP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Feb 2021 10:41:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1613662820;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QeXYo05gCjLoQr043FsS0+GftkeLVR9Kiv3hV8U+gE4=;
        b=d5DR6vYpahLUTy+JnyGKLDPezbV1KDMLfViVc3qg5EOyUFNLXH5G4iRwWxSSPQ0pdt1W9B
        ZWALrWPHzrv5LAUopO9YmWE80eIiz2gW+RFzM039zl8lmsml8BAG/BChtNDSLGThuDM7N5
        hjDCii8EvnQAHoyZynJn7wJy8wVbP9Y=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 5a881e1b (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Thu, 18 Feb 2021 15:40:20 +0000 (UTC)
Received: by mail-yb1-f174.google.com with SMTP id l8so2518358ybe.12
        for <netdev@vger.kernel.org>; Thu, 18 Feb 2021 07:40:20 -0800 (PST)
X-Gm-Message-State: AOAM531u7GRCgePTGTumh31mVvW/wgDEMt3L09LOY/Amv2IGufH9ogr6
        kHCi8y0mgddGM1zDpS+xipSnEk2ZZsGXtwOffjI=
X-Google-Smtp-Source: ABdhPJzgZ3kxnqi9+9MTfVcgUa4mtnf1tZEj3NTJYB1tN5wE+QPtqkVBBxLbBoQEALM/y7cHWNUty0fY0kOMj+9Mqts=
X-Received: by 2002:a25:4981:: with SMTP id w123mr7166390yba.123.1613662820528;
 Thu, 18 Feb 2021 07:40:20 -0800 (PST)
MIME-Version: 1.0
References: <20210218123053.2239986-1-Jason@zx2c4.com> <CA+FuTSdyovtMVaQfdtpWquawpNDoUKz+qXa+8U8eBTzWVtPXHQ@mail.gmail.com>
In-Reply-To: <CA+FuTSdyovtMVaQfdtpWquawpNDoUKz+qXa+8U8eBTzWVtPXHQ@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 18 Feb 2021 16:40:09 +0100
X-Gmail-Original-Message-ID: <CAHmME9o-N5wamS0YbQCHUfFwo3tPD8D3UH=AZpU61oohEtvOKg@mail.gmail.com>
Message-ID: <CAHmME9o-N5wamS0YbQCHUfFwo3tPD8D3UH=AZpU61oohEtvOKg@mail.gmail.com>
Subject: Re: [PATCH net] net: icmp: zero-out cb in icmp{,v6}_ndo_send before sending
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        SinYu <liuxyon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Willem,

On Thu, Feb 18, 2021 at 3:57 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Thu, Feb 18, 2021 at 7:31 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> > The icmp{,v6}_send functions make all sorts of use of skb->cb, assuming
>
> Indeed that also casts skb->cb, to read IP6CB(skb)->iif, good catch.
>
> Still, might be good to more precisely detail the relevant bug:
> icmp_send casts the cb to an option struct.
>
>         __icmp_send(skb_in, type, code, info, &IPCB(skb_in)->opt);
>
> which is referenced to parse headers by __ip_options_echo, copying
> data into stack allocated icmp_param and so overwriting the stack
> frame.

The other way to fix this bug would be to just make icmp_ndo_send call
__icmp_send with an zeored stack-allocated ip_options, rather than
calling icmp_send which calls __icmp_send with the IPCB one. The
implementation of this is very easy, and that's what I did at first,
until I noticed that the v6 side would require a little bit more
plumbing to do right. But, I can go ahead and do that, if you think
that's the better strategy.

> This is from looking at all the callers of icmp{,v6}_ndo_send.
>
> If you look at the callers of icmp{,v6}_send there are even a couple
> more. Such as ipoib_cm_skb_reap (which memsets), clip_neigh_error
> (which doesn't), various tunnel devices (which live under net/ipv4,
> but are called as .ndo_start_xmit downstream from, e.g., segmentation
> (SKB_GSO_CB). Which are fixed (all?) in commit 5146d1f15112
> ("tunnel: Clear IPCB(skb)->opt before dst_link_failure called").
>
> Might be even better to do the memset in __icmp_send/icmp6_send,
> rather than in the wrapper. What do you think?

I don't think memsetting from icmp_send itself is a good idea, since
most callers of that are actually from the inet layer, where it makes
sense to look at IPCB. Other callers, from the ndo layer, should be
using the icmp_ndo_send helper instead. Or am I confused?

If there are places that are using icmp_send from ndo_start_xmit,
that's a problem that should be fixed, with those uses swapped for
icmp_ndo_send.

Jason
