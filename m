Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA0923F871A
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 14:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242493AbhHZMRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 08:17:03 -0400
Received: from codesynthesis.com ([188.40.148.39]:49622 "EHLO
        codesynthesis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242415AbhHZMRC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 08:17:02 -0400
Received: from brak.codesynthesis.com (197-255-152-207.static.adept.co.za [197.255.152.207])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by codesynthesis.com (Postfix) with ESMTPSA id 4760D5F7CB;
        Thu, 26 Aug 2021 12:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codesynthesis.com;
        s=mail1; t=1629980173;
        bh=Wcp+spva27SDUMn5lh3p20Ss4YEIqbN0awnBME542Vc=;
        h=Date:From:To:Subject:Message-ID:MIME-Version:From;
        b=eaN58FnQWvzkHM296c9v+VrbfZQ49nAoJFz9UJX992sl6ORTlxe4hFsAr3kmjn3+t
         t5lEvmW+IVk4jEzoiuoeNBve+Q7EZho2ZKqCc+YHWky+7OHD4gqhxts5aFcXdUu8m7
         Dt/Fa1lmZldSU/4Yqq4NDO/p7NvA9IWQyisNDs0bNN4ANOx074wGDTokR0YA4ACnu2
         LKLauFGA+Ax0Q5OAJ+yYB1fC8Ogp1vvo1YbNQpSHPEcDPcn3XCwUbCSe3FIFj2lsGJ
         EeW5BL4FEolSf6EvSnLdd3szd8mf6pUEYEDBdaA+hzAiN9600nM1WcfKnNZT+FiZuc
         hfcHt8oR5T2cw==
Received: by brak.codesynthesis.com (Postfix, from userid 1000)
        id F0E911A800C4; Thu, 26 Aug 2021 14:16:09 +0200 (SAST)
Date:   Thu, 26 Aug 2021 14:16:09 +0200
From:   Boris Kolpackov <boris@codesynthesis.com>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Kalle Valo <kvalo@codeaurora.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Takashi Iwai <tiwai@suse.com>,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org, Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH] kconfig: forbid symbols that end with '_MODULE'
Message-ID: <boris.20210826140701@codesynthesis.com>
References: <20210825041637.365171-1-masahiroy@kernel.org>
 <boris.20210825172545@codesynthesis.com>
 <CAK7LNAS-NhR=94uHYcZUhRkdUEm=dYZSRbGKkB5zJJGNRw0z2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK7LNAS-NhR=94uHYcZUhRkdUEm=dYZSRbGKkB5zJJGNRw0z2A@mail.gmail.com>
Organization: Code Synthesis
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Masahiro Yamada <masahiroy@kernel.org> writes:

> On Thu, Aug 26, 2021 at 12:42 AM Boris Kolpackov
> <boris@codesynthesis.com> wrote:
> >
> > Masahiro Yamada <masahiroy@kernel.org> writes:
> >
> > > Kconfig (syncconfig) generates include/generated/autoconf.h to make
> > > CONFIG options available to the pre-processor.
> > >
> > > The macros are suffixed with '_MODULE' for symbols with the value 'm'.
> > >
> > > Here is a conflict; CONFIG_FOO=m results in '#define CONFIG_FOO_MODULE 1',
> > > but CONFIG_FOO_MODULE=y also results in the same define.
> > >
> > > fixdep always assumes CONFIG_FOO_MODULE comes from CONFIG_FOO=m, so the
> > > dependency is not properly tracked for symbols that end with '_MODULE'.
> >
> > It seem to me the problem is in autoconf.h/fixdep, not in the Kconfig
> > language.
> 
> So, what is your suggestion for doing this correctly?
> (of course without breaking the compatibility
> because this is how the kernel is configured/built
> for more than 20 years)

Yes, I appreciate that fixing this properly may not be an option
due to backwards-compatibility. How about then moving the check
from the language closer to the place where it will actually be
an issue. Specifically, can the error be triggered when we are
about to write #define to autoconf.h and see that the name ends
with _MODULE?


> > I know you don't care, but I will voice my objection, for the record:
> > Kconfig is used by projects other than the Linux kernel and some of
> > them do not use the autoconf.h functionality. For such projects this
> > restriction seems arbitrary and potentially backwards-incompatible.
> 
> I am not sure what your worry is, but this check resides in
> "if (modules_sym)" conditional, so projects using Kconfig but
> not module functionality (e.g. buildroot) will not be  affected.

The Kconfig module semantics is actually general enough that a
project other than the Linux kernel could reuse it. (I've written
more on this possibility here[1]).

[1] https://build2.org/libbuild2-kconfig/doc/build2-kconfig-manual.xhtml#lang-mod
