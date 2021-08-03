Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADBC63DF373
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 19:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237776AbhHCRCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 13:02:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:36630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237691AbhHCRBS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 13:01:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D58C60F0F;
        Tue,  3 Aug 2021 17:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628010067;
        bh=xv6HDs8f0cdED9oqlZmIGfjdRrTqv1FrSIw7uMIr0g0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=i9nbXs1plRNmd9Odlhglnfe32A11VJ2JkyljXHuSCLliCVz9Vi14AeaJfWRM4fQB4
         SVZulln4H9D+zlY1z/9KmEHt/BEZf4H7GGw7O0ZhZHnqQdOAqnv0rnMSkkoNyAoDhb
         UH5WFTtcj+xdhkasiTcvMY/TEHvVc7DYNBJ57EvxwOlcmT5mDgKoWpvRv+G+oRd9T2
         9q2hcBKQnq0DmLiOv+cbFX+rFhLyaxlYIFqArk8Fr1pc84qh8u8ClndXB+UGdQp2bI
         LcURHqPudxt3UeurSjRAwizq6wvNBCZx3B2iqt1IUCi2+pjOQLh7b9mXru5SMSbWGG
         q43TrVh87VW1A==
Received: by mail-wm1-f54.google.com with SMTP id l11-20020a7bcf0b0000b0290253545c2997so2535599wmg.4;
        Tue, 03 Aug 2021 10:01:06 -0700 (PDT)
X-Gm-Message-State: AOAM531JTDpTZJB738l98frdNHDbiGkxyovtqnV2ybLlLlRTRFfGZOv/
        ZZBKe0mOvODUXvCbJ1KxYFicJX9Qu+rqfjFP89w=
X-Google-Smtp-Source: ABdhPJw97X/o6CV81AMjwzTqugYn505J+JoXq32bAbJq75QjyNy6S/smhZy5uTzyJLJCSdKFxevBxXiA194UwnGyOto=
X-Received: by 2002:a7b:ce10:: with SMTP id m16mr5114379wmc.75.1628010065645;
 Tue, 03 Aug 2021 10:01:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210802145937.1155571-1-arnd@kernel.org> <20210802164907.GA9832@hoboy.vegasvil.org>
 <bd631e36-1701-b120-a9b0-8825d14cc694@intel.com> <20210802230921.GA13623@hoboy.vegasvil.org>
 <CAK8P3a2XjgbEkYs6R7Q3RCZMV7v90gu_v82RVfFVs-VtUzw+_w@mail.gmail.com>
 <20210803155556.GD32663@hoboy.vegasvil.org> <20210803161434.GE32663@hoboy.vegasvil.org>
In-Reply-To: <20210803161434.GE32663@hoboy.vegasvil.org>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Tue, 3 Aug 2021 19:00:49 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2Wt9gnO4Ts_4Jw1+qpBj8HQc50jU2szjmR8MmZL9wrgQ@mail.gmail.com>
Message-ID: <CAK8P3a2Wt9gnO4Ts_4Jw1+qpBj8HQc50jU2szjmR8MmZL9wrgQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2] ethernet/intel: fix PTP_1588_CLOCK dependencies
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Nicolas Pitre <nico@fluxnic.net>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 3, 2021 at 6:14 PM Richard Cochran <richardcochran@gmail.com> wrote:
> On Tue, Aug 03, 2021 at 08:55:56AM -0700, Richard Cochran wrote:
> > On Tue, Aug 03, 2021 at 08:59:02AM +0200, Arnd Bergmann wrote:
> > > It may well be a lost cause, but a build fix is not the time to nail down
> > > that decision. The fix I proposed (with the added MAY_USE_PTP_1588_CLOCK
> > > symbol) is only two extra lines and leaves everything else working for the
> > > moment.
> >
> > Well, then we'll have TWO ugly and incomprehensible Kconfig hacks,
> > imply and MAY_USE.

I'm all in favor of removing imply elsewhere as well, but that needs much
broader consensus than removing it from PTP_1588_CLOCK.

It has already crept into cryto/ and sound/soc/codecs/, and at least in
the latter case it does seem to even make sense, so they are less
likely to remove it.

> > Can't we fix this once and for all?
> >
> > Seriously, "imply" has been nothing but a major PITA since day one,
> > and all to save 22 kb.  I can't think of another subsystem which
> > tolerates so much pain for so little gain.
>
> Here is what I want to have, in accordance with the KISS principle:
>
> config PTP_1588_CLOCK
>         bool "PTP clock support"
>         select NET
>         select POSIX_TIMERS
>         select PPS
>         select NET_PTP_CLASSIFY
>
> # driver variant 1:
>
> config ACME_MAC
>         select PTP_1588_CLOCK
>
> # driver variant 2:
>
> config ACME_MAC
>
> config ACME_MAC_PTP
>         depends on ACME_MAC
>         select PTP_1588_CLOCK
>
> Hm?

Selecting a subsystem (NET, POSIX_TIMES, PPS, NET_PTP_CLASSIFY)
from a device driver is the nightmare that 'imply' was meant to solve (but did
not): this causes dependency loops, and unintended behavior where you
end up accidentally enabling a lot more drivers than you actually need
(when other symbols depend on the selected ones, and default to y).

If you turn all those 'select' lines into 'depends on', this will work, but it's
not actually much different from what I'm suggesting. Maybe we can do it
in two steps: first fix the build failure by replacing all the 'imply'
statements
with the correct dependencies, and then you send a patch on top that
turns PPS and PTP_1588_CLOCK into bool options.

     Arnd
