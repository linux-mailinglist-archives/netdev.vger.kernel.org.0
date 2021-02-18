Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E144E31EDB0
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 18:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234751AbhBRRwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 12:52:21 -0500
Received: from mail.zx2c4.com ([104.131.123.232]:57120 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234322AbhBRRhH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Feb 2021 12:37:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1613669752;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yS9QXbzyO+lJNQofHs5bv8cLQin4iQddVT2ExrF572g=;
        b=BMfSIyvVrFbjWpIDEJpMpxCwPkPxESEbs2F7Jq0HzkZDgTOiuLBICb0IiKrLUwbfoJl0Td
        c7mnV/AqFgagecu5P9qpR5WUEl70vtyo6cp6pRt2jCClmXf15JIJI+6LpMx+/BcV1/4l9P
        Zt8QTkjD5OWpCJHRy8j/ZEXVq9d7Bjc=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id e66fda25 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Thu, 18 Feb 2021 17:35:52 +0000 (UTC)
Received: by mail-yb1-f179.google.com with SMTP id p186so2950866ybg.2
        for <netdev@vger.kernel.org>; Thu, 18 Feb 2021 09:35:52 -0800 (PST)
X-Gm-Message-State: AOAM5315fXyrNNJI2ZdQsTK6PZ1lmuj5qqros6MnWarSJlxx0KeWlKY6
        CZBKq3z7AQyLc+m+S40qO+dw+Qy5oE7pOJhw9fk=
X-Google-Smtp-Source: ABdhPJw6T5ceGMmY9nxNFv+LSIp9bhSCmfP1LVMpzcxXe26qnoUi9zc+DNaQrgz6U9wgIIcvwQJog4iuF0pMCxQJsoU=
X-Received: by 2002:a25:3cd:: with SMTP id 196mr8524075ybd.456.1613669751767;
 Thu, 18 Feb 2021 09:35:51 -0800 (PST)
MIME-Version: 1.0
References: <CAHmME9o-N5wamS0YbQCHUfFwo3tPD8D3UH=AZpU61oohEtvOKg@mail.gmail.com>
 <20210218160745.2343501-1-Jason@zx2c4.com> <CA+FuTSeyYti3TMUd2EgQqTAjHjV=EXVZtmY9HUdOP0=U8WRyJA@mail.gmail.com>
In-Reply-To: <CA+FuTSeyYti3TMUd2EgQqTAjHjV=EXVZtmY9HUdOP0=U8WRyJA@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 18 Feb 2021 18:35:40 +0100
X-Gmail-Original-Message-ID: <CAHmME9rVuw5tAHUpnsXrLh-WAMXmvqSNFdOUh1XaKZ8bLOow9g@mail.gmail.com>
Message-ID: <CAHmME9rVuw5tAHUpnsXrLh-WAMXmvqSNFdOUh1XaKZ8bLOow9g@mail.gmail.com>
Subject: Re: [PATCH net v2] net: icmp: pass zeroed opts from
 icmp{,v6}_ndo_send before sending
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        SinYu <liuxyon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 18, 2021 at 5:34 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
> Thanks for respinning.
>
> Making ipv4 and ipv6 more aligned is a good goal, but more for
> net-next than bug fixes that need to be backported to many stable
> branches.
>
> Beyond that, I'm not sure this fixes additional cases vs the previous
> patch? It uses new on-stack variables instead of skb->cb, which again
> is probably good in general, but adds more change than is needed for
> the stable fix.

It doesn't appear to be problematic for applying to stable. I think
this v2 is the "right way" to handle it. Zeroing out skb->cb is
unexpected and weird anyway. What if the caller was expecting to use
their skb->cb after calling icmp_ndo_send? Did they think it'd get
wiped out like that? This v2 prevents that weird behavior from
happening.

> My comment on fixing all callers of  icmp{,v6}_send was wrong, in
> hindsight. In most cases IPCB is set correctly before calling those,
> so we cannot just zero inside those. If we can only address the case
> for icmp{,v6}_ndo_send I think the previous patch introduced less
> churn, so is preferable. Unless I'm missing something.

As mentioned above it's weird and unexpected.

> Reminder of two main comments: sufficient to zero sizeof(IPCB..) and
> if respinning, please explicitly mention the path that leads to a
> stack overflow, as it is not immediately obvious (even from reading
> the fix code?).

I don't intend to respin v1, as I think v2 is more correct, and I
don't think only zeroing IPCB is a smart idea, as in the future that
code is bound to break when somebody forgets to update it. This v2
does away with the zeroing all together, though, so that the right
bytes to be zeroed are properly enforced all the time by the type
system.

Jason
