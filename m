Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02D261BB9BC
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 11:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbgD1JV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 05:21:27 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:34078 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726376AbgD1JV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 05:21:26 -0400
Received: by mail-ot1-f65.google.com with SMTP id 72so31476241otu.1;
        Tue, 28 Apr 2020 02:21:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9M/t2ssNY0JGEJF7n9+3sQ5ye/4v7stz68WoUu6mGLc=;
        b=MuBPFSk4LNq8/mgcBXATejmiPu4dswIe3/Ox7TbYalFP3XOD+x1tDHVBIQZBFYv8nh
         iDN6wSTYXkQsnttUU9KIU/8sZ9TAzbq2PGladtiOKYu5+LtbnDfbG6gs1lptJCvTgpF3
         eRHL4eGmyCyA3tYT9cOjtKKw8nTTnFhHZqwzN2F1qVaFFk2R8k4BrHdKKC4jKvuk+UV1
         2Te7V4vI9mdjIYj4P6PBVHx6KGV9RvwpgCIzz87/Lelq+/HDZebztspJZPwCeoCCWKPI
         MH7D3dz4GvfiH4pmhWXWeiU5qYhAieeddzNMaTNq2OjI/lp5kdEcxKLTAqcIXO6fQS58
         pIpQ==
X-Gm-Message-State: AGi0Puac25RCFUJdajUv1xmKw2fl9JkTb3dKXWZT8wA4OelLXkaCBPsH
        diZpvU52lMcMPflh+sNz9+K7QfAdfkA7ipgmFbM=
X-Google-Smtp-Source: APiQypJDSbJ1DJDFQEdbLtTytIivKB3Crd4cHWR7cth2WfX/fmYiFAGLO+N+PbHKhKzMyhfehDsMKH8W2o7XS2RsbtQ=
X-Received: by 2002:a9d:7d85:: with SMTP id j5mr20615076otn.107.1588065686013;
 Tue, 28 Apr 2020 02:21:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200428090749.31983-1-clay@daemons.net>
In-Reply-To: <20200428090749.31983-1-clay@daemons.net>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 28 Apr 2020 11:21:15 +0200
Message-ID: <CAMuHMdXhVcp3j4Sq_4fsqavw1eH_DksN-yjajqC_8pRKnjM0zA@mail.gmail.com>
Subject: Re: [PATCH] net: Select PTP_1588_CLOCK in PTP-specific drivers
To:     Clay McClure <clay@daemons.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Mao Wenan <maowenan@huawei.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Edward Cree <ecree@solarflare.com>,
        Nicolas Pitre <nico@fluxnic.net>,
        Josh Triplett <josh@joshtriplett.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Clay,

Thanks for your patch!

On Tue, Apr 28, 2020 at 11:14 AM Clay McClure <clay@daemons.net> wrote:
> Commit d1cbfd771ce8 ("ptp_clock: Allow for it to be optional") changed
> all PTP-capable Ethernet drivers from `select PTP_1588_CLOCK` to `imply
> PTP_1588_CLOCK`, "in order to break the hard dependency between the PTP
> clock subsystem and ethernet drivers capable of being clock providers."
> As a result it is possible to build PTP-capable Ethernet drivers without
> the PTP subsystem by deselecting PTP_1588_CLOCK. Drivers are required to
> handle the missing dependency gracefully.
>
> Some PTP-capable Ethernet drivers (e.g., TI_CPSW) factor their PTP code
> out into separate drivers (e.g., TI_CPTS_MOD). The above commit also
> changed these PTP-specific drivers to `imply PTP_1588_CLOCK`, making it
> possible to build them without the PTP subsystem. But as Grygorii
> Strashko noted in [1]:
>
> On Wed, Apr 22, 2020 at 02:16:11PM +0300, Grygorii Strashko wrote:
>
> > Another question is that CPTS completely nonfunctional in this case and
> > it was never expected that somebody will even try to use/run such
> > configuration (except for random build purposes).
>
> In my view, enabling a PTP-specific driver without the PTP subsystem is
> a configuration error made possible by the above commit. Kconfig should
> not allow users to create a configuration with missing dependencies that
> results in "completely nonfunctional" drivers.
>
> I audited all network drivers that call ptp_clock_register() and found
> six that look like PTP-specific drivers that are likely nonfunctional
> without PTP_1588_CLOCK:
>
>     NET_DSA_MV88E6XXX_PTP
>     NET_DSA_SJA1105_PTP
>     MACB_USE_HWSTAMP
>     CAVIUM_PTP
>     TI_CPTS_MOD
>     PTP_1588_CLOCK_IXP46X
>
> Note how they all reference PTP or timestamping in their name; this is a
> clue that they depend on PTP_1588_CLOCK.
>
> Change these drivers back [2] to `select PTP_1588_CLOCK`. Note that this
> requires also selecting POSIX_TIMERS, a transitive dependency of
> PTP_1588_CLOCK.

If these drivers have a hard dependency on PTP_1588_CLOCK, IMHO they
should depend on PTP_1588_CLOCK, not select PTP_1588_CLOCK.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
