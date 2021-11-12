Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEDBD44EBEE
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 18:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235122AbhKLR0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 12:26:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233404AbhKLR0p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 12:26:45 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCBBAC061766
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 09:23:54 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id d24so16834601wra.0
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 09:23:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f21AQvXYfLWnC5KaOFo8ug+OXSH4ek6eYgS+Z63qZVw=;
        b=dhIwLOh+RP9jj2v85oGyhBhNw8jijCLDknbYa2mmFHb///NMvFZ9szTFPYMurw9+tP
         ySJghpb6eq/draWgPShTUjxPcZewiSBTixlE6cjfeyoh6svP3Lpyw2moGr1xMHgiSBP6
         aCvvjz9X7oF7UcvKCgFKW2RIbe3jh3uwIZxHcvHwS46irEXoZiZJpLisHwFcs++XgdSZ
         p0mv1pc/6t4P2isYCZJ/YZPlkh2FJP6rVywgY/YOY23LPo38qyi3LGi+lHqK4TeEp3WB
         nKi2yrKdls2DuT5IECGIeutHxCgwUcKvfMRnyOYvYSHlAPJfuNKvqSjzxMz45IoDxENR
         BPWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f21AQvXYfLWnC5KaOFo8ug+OXSH4ek6eYgS+Z63qZVw=;
        b=taD2iLR5EJuA88FQSQpfJbTyDVhUYZx34eUNEvdkCx4bNA2zfotTMpjYTcnzf9rDpy
         cGdB4E/5W0M1DbBTo6LIypUyfL4SEHBfK+YygM14gAgsPs75PFxX0W57JcXVpJs9R6Gx
         TtvzF1bZNuVltbsXf27iWvl4y14++VaMP7XUWqGaql3eODleRWIOW+Vd2A+2Cif6rsWc
         8NdrBxpMO5BXi/LYjgxCY9+OvQxTvdDjli3yVKfZRI3fGjkA9wcMgw2HjYSz5LdJNhOt
         6g925q9ejEanPDBTB1O/UaafUYMeG5voglme7vXUjC3QmjX6qM7uMriLYxat690PrIRh
         i56w==
X-Gm-Message-State: AOAM530WTBsz0ZnV+bsGCjhiVc+qL9i/K5pLqYP3atLGvJ4y9acUSH7R
        Zt10MsFxbb0vcQjV8GBxRqEDg4BDR8uk1fm0CK+dtw==
X-Google-Smtp-Source: ABdhPJzXm9bYBKoKPPF6sYiO6dddQlJsWxkbsjg/dKlg8T8w+Q6YFgqtyr/7N9SIEVmEMK4/S2Ioh6oIj2xnqDbZRcw=
X-Received: by 2002:a05:6000:1548:: with SMTP id 8mr21452132wry.279.1636737832823;
 Fri, 12 Nov 2021 09:23:52 -0800 (PST)
MIME-Version: 1.0
References: <20211112161950.528886-1-eric.dumazet@gmail.com> <YY6aKcUyZaERbBih@hirez.programming.kicks-ass.net>
In-Reply-To: <YY6aKcUyZaERbBih@hirez.programming.kicks-ass.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 12 Nov 2021 09:23:39 -0800
Message-ID: <CANn89iK=Ayph82DptYEGv4a+n2AnqgVMDhA2iLaJm=mQmE-tow@mail.gmail.com>
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

On Fri, Nov 12, 2021 at 8:45 AM Peter Zijlstra <peterz@infradead.org> wrote:
>

>
> Looks nice, happen to have shiny perf numbers to show how awesome it it?
> :-)

On a networking load on cascadlake, line rate received on a single thread, I see
perf -e cycles:pp -C <cpu>

Before:
       4.16%  [kernel]       [k] csum_partial
After:
        0.83%  [kernel]       [k] csum_partial

If run in a loop 1,000,000 times,

Before:
       26,922,913      cycles                    # 3846130.429 GHz
        80,302,961      instructions              #    2.98  insn per
cycle
        21,059,816      branches                  # 3008545142.857
M/sec
             2,896      branch-misses             #    0.01% of all
branches
After:
        17,960,709      cycles                    # 3592141.800 GHz
        41,292,805      instructions              #    2.30  insn per
cycle
        11,058,119      branches                  # 2211623800.000
M/sec
             2,997      branch-misses             #    0.03% of all
branches

Thanks for your help !
