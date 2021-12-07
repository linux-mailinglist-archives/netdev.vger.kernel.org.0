Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE59746BC7A
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 14:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237040AbhLGN3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 08:29:44 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:55158 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbhLGN3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 08:29:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5991ACE1AB3;
        Tue,  7 Dec 2021 13:26:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B9FFC341C1;
        Tue,  7 Dec 2021 13:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638883570;
        bh=+PMXl8C2vXbjI2QYMOuXsbcxqTyVb3++/NqlyuDIFnk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=pdcuJE9whDlyBdGaUdRmtw7rc/2uC8XP6aUbDtydE/31O8TXy54LjlIOIngm5NJFd
         ZKKPxMaRCVxfMPgMlwOTH44+u3qnNY+qSus65O3E0HPKZjYRwjN/NaUq9dK3qbHK0p
         MOo55HlELhrKTLINdS3+xwI4mHXZriGzJy4ktyXpH/lXthXaEHmWAHmUApK2g5uyjO
         GeGpo2rUdWBDOQ3GPG5L2xd3qFCwyX0r5IkQa8nm6+L5aX47Ct2GRI+j2mvxeCPDRp
         I85BKNE0HhSymt9TdpQS6RnYr6f95m6QDKYDKkuQPZFWatNBSg0t7ntVY+g7yMKl08
         /0dvG0v4X8hEw==
Received: by mail-wr1-f52.google.com with SMTP id d9so29476735wrw.4;
        Tue, 07 Dec 2021 05:26:10 -0800 (PST)
X-Gm-Message-State: AOAM533VYy6fIaKslRqh/Eqfk7M2cVBRVmrTeQeTK6Fg3v4NqyzQPL5R
        lNG5gFgSQNdqZ/Y+3YGMebY8ZUcLUyLRPNP115U=
X-Google-Smtp-Source: ABdhPJwlN0Z5yI+R+jgBN3ZZ44OPA1YvCVDHGSNjueEg+kIdm0GolFkKVFVe+yKlfamA6x1vVKO0eZnmxqoxjoCmomY=
X-Received: by 2002:a5d:4107:: with SMTP id l7mr51031453wrp.209.1638883568777;
 Tue, 07 Dec 2021 05:26:08 -0800 (PST)
MIME-Version: 1.0
References: <20211207125430.2423871-1-arnd@kernel.org> <SA1PR11MB58258D60F7C1334471E2F434F26E9@SA1PR11MB5825.namprd11.prod.outlook.com>
In-Reply-To: <SA1PR11MB58258D60F7C1334471E2F434F26E9@SA1PR11MB5825.namprd11.prod.outlook.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Tue, 7 Dec 2021 14:25:52 +0100
X-Gmail-Original-Message-ID: <CAK8P3a35HHPs2sMsfQ_SrX4DTKmzidFUOczu8khzwJJTAy++yw@mail.gmail.com>
Message-ID: <CAK8P3a35HHPs2sMsfQ_SrX4DTKmzidFUOczu8khzwJJTAy++yw@mail.gmail.com>
Subject: Re: [PATCH] iwlwifi: work around reverse dependency on MEI
To:     "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc:     "Coelho, Luciano" <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Beker, Ayala" <ayala.beker@intel.com>,
        "Korenblit, Miriam Rachel" <miriam.rachel.korenblit@intel.com>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 7, 2021 at 2:19 PM Grumbach, Emmanuel
<emmanuel.grumbach@intel.com> wrote:
> > A better option would be change iwl_mei_is_connected() so it could be
> > called from iwlwifi regardless of whether the mei driver is reachable, but that
> > requires a larger rework in the driver.
>
> I can try to do that but I don't really see how..
> I can't really make a function that would behave differently based on whether the symbol is available or not.

I meant that this would be an inline function that only accesses variables
that are available to the iwlwifi driver already, rather than part of the iwlmei
driver.

Part of the problem here is that the current implementation checks a global
variable that is part of the iwlmei driver, so there is no easy way for iwlwifi
to access it.

> >  config IWLMEI
> > -     tristate "Intel Management Engine communication over WLAN"
> > -     depends on INTEL_MEI
> > +     bool "Intel Management Engine communication over WLAN"
> > +     depends on INTEL_MEI=y || INTEL_MEI=IWLMVM
> > +     depends on IWLMVM=y || IWLWIFI=m
> >       depends on PM
> > -     depends on IWLMVM
> >       help
> >         Enables the iwlmei kernel module.
>
> Johannes suggested to make IWLMVM depend on IWLMEI || !IWLMEI
> That worked as well, I just had issues with this in our internal backport based tree.
> I need to spend a bit more time on this, but I admit my total ignorance in Kconfig's dialect.

It's still not enough, the dependency is in iwlwifi, not in iwlmvm, so it
would remain broken for IWLWIFI=y IWLMVM=m IWLMEI=m.

One easy solution might be to link all the iwlmei objects intro the main
iwlwifi driver, the same way it links in the fw/*.c files.

       Arnd
