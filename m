Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C32646BE53
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 15:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238298AbhLGPAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 10:00:48 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:52632 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232266AbhLGPAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 10:00:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 371C6CE1B23;
        Tue,  7 Dec 2021 14:57:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C34C341C5;
        Tue,  7 Dec 2021 14:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638889034;
        bh=8X9IIQ927yf7quFBclyWEsUDPFz0AyOg8V9PcZ9FaD8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=OZSEJZn1JvoXxSpJOeq99WP/AU27anuWoXH+2t907gzrQA7eqb0gV6AJaXZ+mSzZi
         rxJH1Zv1JoKlb+vbbE+J7YRmNbKOak82743q0ACp7chsQF6LQ8HCEFGj++Ki1X/w8z
         3lcj3ZY2paTD9NHgqJDTh1HWhyVPnexyE5z8c4lD0N+x/Nym2BfIGn69tWG9lJ37qS
         O4e7JQdZS7dM1E4SxuRM7fAbS/mQOnhj7mppeWU6zQvpe2qQhgcUQ9i/yOZhE8jwlw
         JpyvsZhkFPMtY6J9kipTdfKjgIjVgZncsNdrYuipehgf+XTKD1vwyYW1jjw0sffJhY
         SFuf1uVee8Efg==
Received: by mail-wr1-f53.google.com with SMTP id c4so30010062wrd.9;
        Tue, 07 Dec 2021 06:57:14 -0800 (PST)
X-Gm-Message-State: AOAM533n4n5O3v3lzU7eTJJaodyTyG+8ahPDZ48hmCawy38fPJn61+zk
        jRSXv3IZcR+Et60+8KyRFw4uAkwSWsnuXpooxAk=
X-Google-Smtp-Source: ABdhPJy9YhTP+B4BabbmAtiU6wefpmhItbH/apCdy3BE5pONXd1pMcTyA/0MoUkyyXEOz0BrdrzNxTWp1Ycm2Wq5rdc=
X-Received: by 2002:adf:d091:: with SMTP id y17mr54628673wrh.418.1638889032670;
 Tue, 07 Dec 2021 06:57:12 -0800 (PST)
MIME-Version: 1.0
References: <20211207125430.2423871-1-arnd@kernel.org> <SA1PR11MB58258D60F7C1334471E2F434F26E9@SA1PR11MB5825.namprd11.prod.outlook.com>
 <CAK8P3a35HHPs2sMsfQ_SrX4DTKmzidFUOczu8khzwJJTAy++yw@mail.gmail.com> <5ed6ad0f5d4fed1cb0a49ecfd7f6b35dbe0f0803.camel@sipsolutions.net>
In-Reply-To: <5ed6ad0f5d4fed1cb0a49ecfd7f6b35dbe0f0803.camel@sipsolutions.net>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Tue, 7 Dec 2021 15:56:56 +0100
X-Gmail-Original-Message-ID: <CAK8P3a0dPZDSN_C9-J4k0oFFh4z+XSa64D_R0EhYwBBFQLV8vg@mail.gmail.com>
Message-ID: <CAK8P3a0dPZDSN_C9-J4k0oFFh4z+XSa64D_R0EhYwBBFQLV8vg@mail.gmail.com>
Subject: Re: [PATCH] iwlwifi: work around reverse dependency on MEI
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        "Coelho, Luciano" <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Beker, Ayala" <ayala.beker@intel.com>,
        "Korenblit, Miriam Rachel" <miriam.rachel.korenblit@intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 7, 2021 at 3:40 PM Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Tue, 2021-12-07 at 14:25 +0100, Arnd Bergmann wrote:
>
> > > >  config IWLMEI
> > > > -     tristate "Intel Management Engine communication over WLAN"
> > > > -     depends on INTEL_MEI
> > > > +     bool "Intel Management Engine communication over WLAN"
> > > > +     depends on INTEL_MEI=y || INTEL_MEI=IWLMVM
> > > > +     depends on IWLMVM=y || IWLWIFI=m
> > > >       depends on PM
> > > > -     depends on IWLMVM
> > > >       help
> > > >         Enables the iwlmei kernel module.
> > >
> > > Johannes suggested to make IWLMVM depend on IWLMEI || !IWLMEI
> > > That worked as well, I just had issues with this in our internal backport based tree.
> > > I need to spend a bit more time on this, but I admit my total ignorance in Kconfig's dialect.
> >
> > It's still not enough, the dependency is in iwlwifi, not in iwlmvm, so it
> > would remain broken for IWLWIFI=y IWLMVM=m IWLMEI=m.
> >
>
> I missed the pcie/trans.c dependency, and the others are (I think) in
> mvm...
>
> but then we can do
>
> config IWLWIFI
>         ...
>         depends on IWLMEI || !IWLMEI
>         ...
>
> no? That way, we exclude IWLWIFI=y && IWLMEI=m, which I believe causes
> the issue? And IWLMVM already depends on IWLWIFI (via the if clause), so
> that

Right, that should work. Testing with that version now.

         Arnd
