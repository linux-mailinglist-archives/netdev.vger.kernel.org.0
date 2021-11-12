Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA4D44EC0C
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 18:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235340AbhKLRj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 12:39:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233404AbhKLRj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 12:39:26 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B5F9C061766
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 09:36:35 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id n33-20020a05600c502100b0032fb900951eso5200577wmr.4
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 09:36:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k1UK6oAc8GL8iliGyGQ6wmcawS/Fuafi+uvg9X+yVl0=;
        b=S/6a/XNl2L2Hbg3gy6AM3qE1ESqMOWZ3MuaxMJXNxXhJBOu27YUT2UiaPv+SgqV3i/
         jQ3XG+oyID5Y6/l9PFB242jvSjVDKA4us/Sk2rz9isJTxllMBrno020WCDpWbtn2Aebi
         lwVFe/NeLUGwvrvT1mSb5tFLA4UADlRNrxHOZ9ZVLqQZ7GM7WcMMUfsTQmdNQ6ZWQZPk
         CtUCK8rhKkY6wvkmR50vYoIIdPOXP0829Yq/NED9/FDKHv5k4cFMlIDail/XZ/+8PPQm
         s7D9xFgq4bbjH2dYMR75Wu/KvSh2E2m0OX4zFeRUY52IjH7nuAgC6fvKbBMEUNQbrRD6
         oMTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k1UK6oAc8GL8iliGyGQ6wmcawS/Fuafi+uvg9X+yVl0=;
        b=Q0QokoWn7nawHgTGPAr2qJGt4nDj2gnxJbccjQZeoA7ZOcIO6Fy0htjTGkG0KDdBjm
         tJcgdyzXtdykk37Xkk/uk5JsmhV+GTrNX+tRH2j2OX7N/5YVNXlk0hxBMJFhytaPfiKp
         UD908lcXRAsgtb92C5orSbfj5cjvTK/w4t5BQanLYxpeSfB+icf58q/4goPB5ucCUhHb
         NKqylHXrVxKaWi3+g/iZljGIiVDKRwSLOA5xZmdJnpGWglmTPtkxPN/KFYAPQwyh39We
         k+8uPZtqbNjWRjCkbFGRle+/PbcOI08rOZQiZOBveMzqQCBrDcQsOcTVEJGCvZNHxpb1
         M+fA==
X-Gm-Message-State: AOAM531oW/vyeEEGEm4yoN8IJbIYA4ROIr8ZgWvctoJGrhphc4mLLb0P
        sgzY2CcYpoSauO+/PLGLS/Sq0dKiFI/9TdHZ2mtZ0Q==
X-Google-Smtp-Source: ABdhPJzC8UXw+K7snXFq3e1bcI/uOk7aOOiMgySh+iM4fT7VCKgBD1liWXt+ypq3eVH8x6ohK3XO+AviZTW/SD0ZyH4=
X-Received: by 2002:a05:600c:1f13:: with SMTP id bd19mr20125107wmb.9.1636738593420;
 Fri, 12 Nov 2021 09:36:33 -0800 (PST)
MIME-Version: 1.0
References: <20211112161950.528886-1-eric.dumazet@gmail.com>
 <YY6aKcUyZaERbBih@hirez.programming.kicks-ass.net> <CANn89iK=Ayph82DptYEGv4a+n2AnqgVMDhA2iLaJm=mQmE-tow@mail.gmail.com>
In-Reply-To: <CANn89iK=Ayph82DptYEGv4a+n2AnqgVMDhA2iLaJm=mQmE-tow@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 12 Nov 2021 09:36:20 -0800
Message-ID: <CANn89i+Pa9iD80=rQd5nwCSr1eN9j5q9GqC2QtEPCXPQazZh9A@mail.gmail.com>
Subject: Re: [PATCH v2] x86/csum: rewrite csum_partial()
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, x86@kernel.org,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 12, 2021 at 9:23 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Fri, Nov 12, 2021 at 8:45 AM Peter Zijlstra <peterz@infradead.org> wrote:
> >
>
> >
> > Looks nice, happen to have shiny perf numbers to show how awesome it it?
> > :-)
>
> On a networking load on cascadlake, line rate received on a single thread, I see
> perf -e cycles:pp -C <cpu>
>
> Before:
>        4.16%  [kernel]       [k] csum_partial
> After:
>         0.83%  [kernel]       [k] csum_partial
>
> If run in a loop 1,000,000 times,
>

However, there must be an error in my patch, return values are not the
same on unaligned buffers.
