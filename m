Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BCEF44EC1B
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 18:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235472AbhKLRp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 12:45:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235122AbhKLRp2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 12:45:28 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C611AC061766
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 09:42:37 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id d3so16834042wrh.8
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 09:42:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z+ZTHnJEo9XK2bCz8GP8aGcGtLXBE8Pll/dbIu+ZDuk=;
        b=S+2Qk+3kQhTl0y7pHJtSEGZiwycxgoYFYsKuVD8KE7D1GgH5AX3KzMnxHRMZJN9jOC
         ymKcGqpU37lOUdlJjnRirQGZjDwmXwOEaESQ6vxNzD2okvpz2zzinoII9VwPhHYZ5fJ7
         JcJRuEhzLACS/3IJokMgQV3FxLGO3J16GVJsRcbZACgOZydNw7kvavIhPP/vVCMF6Bc8
         YKq1r7kDkc92SgUVqPWR1VUnloU1CfuO78JhI7xTUgDrrQv8Ft1ef9229FxYgmsAAVoh
         9+gi8OyHGZkFfiEQ/Xc6MifLdZz4UyjgmVD46juNH6BH30QoalMvBHCsMYOIRwuKysGl
         wLYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z+ZTHnJEo9XK2bCz8GP8aGcGtLXBE8Pll/dbIu+ZDuk=;
        b=qLqUuehfGgmlOrD873bDPdunfWe5EU8IUBGvjuIcKZLpndb1ZZiEtTybXKNxoiVofg
         Wl6F60/2C0DXt0rQlYIV6Zx+CeuLFpKc10HrNs9fAi1Y9/3g7agBbBKtHJFqBMdRXBKp
         8bAgJZMwH54/+ZRBJAmjULZnDNt0jKNvkeJ+PpIXfT9KPc7cbWrw4mKcc807HQDxvH9E
         3VKrDj2t/sOx8Sq1zABiDlipjZNVy8XEZkD07ezgUlbIlHzRrlseuGCRiU7ftRveIoTV
         QIzBSAIsuDitsokohm8OJhAiN3mf2LDzrxV5MAPI6HQMVF8Ot2avbvFOvcjWSUzlRdTJ
         PAnQ==
X-Gm-Message-State: AOAM531yM2UYm5bX8253EN4wFyfXbmsmAorjH4pbALcDPXQIvHuOMWOg
        nEcXETuY5VF2ug0cfyiL9xPn+VoGENpKePpnanU+d9zUFk8=
X-Google-Smtp-Source: ABdhPJwSC1N7af2ytPj9Q1gAXk3nc+oJZNAK9KtStXFrehh9ZNavEY9zws1Uw7Wpd8+eGCKhbGaYscEXQxMij+hx8cE=
X-Received: by 2002:a05:6000:1548:: with SMTP id 8mr21594712wry.279.1636738955426;
 Fri, 12 Nov 2021 09:42:35 -0800 (PST)
MIME-Version: 1.0
References: <20211112161950.528886-1-eric.dumazet@gmail.com>
 <YY6aKcUyZaERbBih@hirez.programming.kicks-ass.net> <CANn89iK=Ayph82DptYEGv4a+n2AnqgVMDhA2iLaJm=mQmE-tow@mail.gmail.com>
 <CANn89i+Pa9iD80=rQd5nwCSr1eN9j5q9GqC2QtEPCXPQazZh9A@mail.gmail.com>
In-Reply-To: <CANn89i+Pa9iD80=rQd5nwCSr1eN9j5q9GqC2QtEPCXPQazZh9A@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 12 Nov 2021 09:42:23 -0800
Message-ID: <CANn89iKbc=btFW9mJazEmNY==rqqtHo8AD5_asCQN6kMRUd11g@mail.gmail.com>
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

On Fri, Nov 12, 2021 at 9:36 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Fri, Nov 12, 2021 at 9:23 AM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Fri, Nov 12, 2021 at 8:45 AM Peter Zijlstra <peterz@infradead.org> wrote:
> > >
> >
> > >
> > > Looks nice, happen to have shiny perf numbers to show how awesome it it?
> > > :-)
> >
> > On a networking load on cascadlake, line rate received on a single thread, I see
> > perf -e cycles:pp -C <cpu>
> >
> > Before:
> >        4.16%  [kernel]       [k] csum_partial
> > After:
> >         0.83%  [kernel]       [k] csum_partial
> >
> > If run in a loop 1,000,000 times,
> >
>
> However, there must be an error in my patch, return values are not the
> same on unaligned buffers.

Oh silly me, the 32bit value is different, but the 16bit csum is good,
sorry for the noise.
