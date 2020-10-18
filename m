Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1B642917D9
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 16:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbgJROVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 10:21:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:42646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbgJROVE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 10:21:04 -0400
Received: from devnote2 (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEA6921655;
        Sun, 18 Oct 2020 14:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603030864;
        bh=Y4gRkxpE94bomTsuLKGNom9qq/LJ88DqsOhF7n1C+uw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vxg29r+kG2J9BP2ZVKfzun0L68+mdq00drnLsoLhk8GSwDd80X+FUS9z6OrXQnFJ3
         vudLzwZ64l6qxiPGKtYjxv16WVxNeSzjFy6gnHT1niK30uavcLLuqdyVRs8NcEfmYh
         EQTSMNh8n6QrBoTgViWUBZycrYOC/w+BFQ8/L8QE=
Date:   Sun, 18 Oct 2020 23:20:58 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Sumit Garg <sumit.garg@linaro.org>,
        Alex =?UTF-8?B?QmVubsOpZQ==?= <alex.bennee@linaro.org>,
        steve@einval.com, Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>, Willy Liu <willy.liu@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Masahisa Kojima <masahisa.kojima@linaro.org>
Subject: Re: realtek PHY commit bbc4d71d63549 causes regression
Message-Id: <20201018232058.53a22758eba397695adc0352@kernel.org>
In-Reply-To: <CAMj1kXEY5jK7z+_ezDX733zbtHnaGUNCkJ_gHcPqAavOQPOzBQ@mail.gmail.com>
References: <20201017144430.GI456889@lunn.ch>
        <CAMj1kXHsNrRSkZfSJ_VatES+V1obLcvfo=Qab_4jy58Znpjy6Q@mail.gmail.com>
        <20201017151132.GK456889@lunn.ch>
        <CAMj1kXH+Z56dkZz8OYMhPuqbjPPCqW=UMV6w--=XXh87UyHVaQ@mail.gmail.com>
        <20201017161435.GA1768480@apalos.home>
        <CAMj1kXHXYprdC19m1S5p_LQ2BOHtDCbyCWCJ0eJ5xPxFv8hgoA@mail.gmail.com>
        <20201017180453.GM456889@lunn.ch>
        <CAMj1kXEcrULejk+h1Jv42W=r7odQ9Z_G0XDX_KrEnYYPEVgHkA@mail.gmail.com>
        <20201017182738.GN456889@lunn.ch>
        <CAMj1kXHwYkd0L63K3+e_iwfoSYEUOmYdWf_cKv90_qVXSxEesg@mail.gmail.com>
        <20201017194904.GP456889@lunn.ch>
        <CAMj1kXEY5jK7z+_ezDX733zbtHnaGUNCkJ_gHcPqAavOQPOzBQ@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 18 Oct 2020 00:19:25 +0200
Ard Biesheuvel <ardb@kernel.org> wrote:

> (cc'ing some folks who may care about functional networking on SynQuacer)
> 
> On Sat, 17 Oct 2020 at 21:49, Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > > So we can fix this firmware by just setting phy-mode to the empty
> > > string, right?
> >
> > I've never actually tried it, but i think so. There are no DT files
> > actually doing that, so you really do need to test it and see. And
> > there might be some differences between device_get_phy_mode() and
> > of_get_phy_mode().
> >
> 
> Yes, that works fine. Fixed now in the latest firmware build [0]

Great! I've just started chasing that bug this Friday.
Thanks!

> But that still leaves the question whether and how to work around this
> for units in the field. Ignoring the PHY mode in the driver would
> help, as all known hardware ships with firmware that configures the
> PHY with the correct settings, but we will lose the ability to use
> other PHY modes in the future, in case the SoC is ever used with DT
> based minimal firmware that does not configure networking.
> 
> Since ACPI implies rich firmware, we could make ACPI probing of the
> driver ignore the phy-mode setting in the DSDT. But if we don't do the
> same for DT, it would mean DT users are forced to upgrade their
> firmware, and hopefully do so before upgrading to a kernel that breaks
> networking. (These boxes are often used headless, so this can be
> annoying)
> 
> 
> [0] http://snapshots.linaro.org/components/kernel/leg-96boards-developerbox-edk2/83/


-- 
Masami Hiramatsu <mhiramat@kernel.org>
