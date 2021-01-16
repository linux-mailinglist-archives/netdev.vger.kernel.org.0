Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39BC22F8F43
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 21:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbhAPUkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 15:40:31 -0500
Received: from bmailout2.hostsharing.net ([83.223.78.240]:56103 "EHLO
        bmailout2.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbhAPUk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jan 2021 15:40:29 -0500
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout2.hostsharing.net (Postfix) with ESMTPS id 5A7432800B3E0;
        Sat, 16 Jan 2021 21:39:45 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 4F65E1AF35; Sat, 16 Jan 2021 21:39:45 +0100 (CET)
Date:   Sat, 16 Jan 2021 21:39:45 +0100
From:   Lukas Wunner <lukas@wunner.de>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Marek Vasut <marex@denx.de>, Networking <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next V2] net: ks8851: Fix mixed module/builtin build
Message-ID: <20210116203945.GA32445@wunner.de>
References: <20210116164828.40545-1-marex@denx.de>
 <CAK8P3a1iqXjsYERVh+nQs9Xz4x7FreW3aS7OQPSB8CWcntnL4A@mail.gmail.com>
 <a660f328-19d9-1e97-3f83-533c1245622e@denx.de>
 <CAK8P3a3qtrmxMg+uva-s18f_zj7aNXJXcJCzorr2d-XxnqV1Hw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a3qtrmxMg+uva-s18f_zj7aNXJXcJCzorr2d-XxnqV1Hw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 16, 2021 at 08:26:22PM +0100, Arnd Bergmann wrote:
> On Sat, Jan 16, 2021 at 6:56 PM Marek Vasut <marex@denx.de> wrote:
> > On 1/16/21 6:04 PM, Arnd Bergmann wrote:
> > > On Sat, Jan 16, 2021 at 5:48 PM Marek Vasut <marex@denx.de> wrote:
> >
> > > I don't really like this version, as it does not actually solve the problem of
> > > linking the same object file into both vmlinux and a loadable module, which
> > > can have all kinds of side-effects besides that link failure you saw.
> > >
> > > If you want to avoid exporting all those symbols, a simpler hack would
> > > be to '#include "ks8851_common.c" from each of the two files, which
> > > then always duplicates the contents (even when both are built-in), but
> > > at least builds the file the correct way.
> >
> > That's the same as V1, isn't it ?
> 
> Ah, I had not actually looked at the original submission, but yes, that
> was slightly better than v2, provided you make all symbols static to
> avoid the new link error.
> 
> I still think that having three modules and exporting the symbols from
> the common part as Heiner Kallweit suggested would be the best
> way to do it.

FWIW I'd prefer V1 (the #include approach) as it allows going back to
using static inlines for register access.  That's what we had before
7a552c850c45.

It seems unlikely that a system uses both, the parallel *and* the SPI
variant of the ks8851.  So the additional memory necessary because of
code duplication wouldn't matter in practice.

Thanks,

Lukas
