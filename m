Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1943838A7
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 18:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244691AbhEQP63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 11:58:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:42556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343772AbhEQPwO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 May 2021 11:52:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDEF0611BD;
        Mon, 17 May 2021 15:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621266627;
        bh=+nSSPF4GpDDsU6ePZBycXg8ZRy2SPbyQatE3Kqthmnc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=t9b3vAdZVtqUfOZzdNKRa2x81EBOq1oxvAxntMSGK/+bmQECDng35jSLRWziZesGF
         vCN7KMF04y627h5Ut+LOcHyiOE2GgdX80nU2sRIT3F9YzUyGVgz4zBMRiKcWpPXypy
         myZeLMvNi+apy0obgK0U1zPcs2PbfUy6ZW9lrmvSqz9/xsTv+qqgG0mjqHeANGqGez
         AikyIXTJJI6SkS768oHU8mt6k9WHDj8jGdQFGeAfEVuZMPRmMjN65gzisesUA7P1wg
         9gOxBzRi5JmOx/FD06gSwqRN4En8vS5mokBMsRrHHwhlVwfsauhOD5FtA9AlFu6P21
         bMOi53pz4OMYQ==
Received: by mail-oi1-f171.google.com with SMTP id d21so6853080oic.11;
        Mon, 17 May 2021 08:50:26 -0700 (PDT)
X-Gm-Message-State: AOAM5315/ddVAtYS8JUOhmeJ93I34Xf04zAupUO+fRs2IZ7zAG1CGMTI
        p70l5tfhGJbJ0tptSgfrHMto7VCpapOY0OykL0E=
X-Google-Smtp-Source: ABdhPJzVUBOH90xJ9YwRev+KU3ubRnUYGQRm97PF8ZQPKuMupE+uVQ9A8PGEeKISaf4nIovDqzTeXsAx0s0vlz933Tc=
X-Received: by 2002:aca:3389:: with SMTP id z131mr375602oiz.11.1621266626294;
 Mon, 17 May 2021 08:50:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210515221320.1255291-1-arnd@kernel.org> <20210517143805.GQ258772@windriver.com>
In-Reply-To: <20210517143805.GQ258772@windriver.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Mon, 17 May 2021 17:49:17 +0200
X-Gmail-Original-Message-ID: <CAK8P3a06wap4uuN+q5rSGCyO5BkG_ZyJ+3QKcE9_wyaSb_Qq9Q@mail.gmail.com>
Message-ID: <CAK8P3a06wap4uuN+q5rSGCyO5BkG_ZyJ+3QKcE9_wyaSb_Qq9Q@mail.gmail.com>
Subject: Re: [RFC 00/13] [net-next] drivers/net/Space.c cleanup
To:     Paul Gortmaker <paul.gortmaker@windriver.com>
Cc:     Networking <netdev@vger.kernel.org>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sam Creasey <sammy@sammy.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Finn Thain <fthain@telegraphics.com.au>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 17, 2021 at 4:38 PM Paul Gortmaker
<paul.gortmaker@windriver.com> wrote:
> > From: Arnd Bergmann <arnd@arndb.de>
>
> I'd be willing to do a "Phase 2" of 930d52c012b8 ISA net delete;  I'm
> not sure the bounce through stable on the way out does much other than
> muddy the git history.  I'd be tempted to just propose the individual
> deletes and see where that goes....

I think the main benefit of going through drivers/staging would be that
it could be done somewhat more aggressively by moving more of the
presumed-unused hardware out at once, and waiting for media
coverage to wake up any remaining users. Then again, reverting
a removal isn't that different from reverting the move to staging.

If we do it one driver at a time, a good start might be the ones that
don't already have support for probing multiple devices in a loadable
module (ni65,smc9194, cs89x0-isa, cops, ltpc), which would let us
kill off drivers/net/Space.c by always using the module_init() logic.
These are all non-ISAPnP devices, and a second step could be
to remove support for all non-PNP devices (lance, wd80x3,
corkscrew and maybe the ISA WAN devices).

Unless we can agree to remove CONFIG_ISA completely, it's probably
best to leave ISA support for those drivers that also work on PCI, EISA
or m68k hardware, as those have the best chance to still get tested.
3c509 is probably the best maintained, given that it's the only network
driver that got converted to isa_register_driver() from the linux-2.0
style static probing. 3c515 has the distinction of being the only
remaining 100mbit one, and ne2k is obviously the one that one can
still find on ebay or the parent's attic.

       Arnd
