Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34E4C128886
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 11:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbfLUKWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 05:22:25 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35914 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbfLUKWZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Dec 2019 05:22:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=LUeT+vJhqzOCStN1rALj5m0u5shkr955QgTDlUmF/CU=; b=ONZAym9pwvDqXkKJAoNcfg33TR
        PFANvA/VrJI3zJZ+pYGw25vSh4x6KrXuO3HQ6fwZFf1gZayDC9eDhM/6I1E/3X14UQZDYPpOBeXBQ
        Ys+5SERL8VqLAxaxEOUnk3ohP9Bc+Dt4D4sDU+DJ8BYA1iX5EcfN6ZgLUwxAquePs9nw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1iibtp-0008JI-TY; Sat, 21 Dec 2019 11:22:17 +0100
Date:   Sat, 21 Dec 2019 11:22:17 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Baruch Siach <baruch@tkos.co.il>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>,
        netdev@vger.kernel.org,
        Denis Odintsov <d.odintsov@traviangames.com>
Subject: Re: [PATCH] net: dsa: mv88e6xxx: force cmode write on 6141/6341
Message-ID: <20191221102217.GA30801@lunn.ch>
References: <dd029665fdacef34a17f4fb8c5db4584211eacf6.1576748902.git.baruch@tkos.co.il>
 <20191220142725.GB2458874@t480s.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191220142725.GB2458874@t480s.localdomain>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Andrew,
> 
> We tend to avoid caching values in the mv88e6xxx driver the more we can and
> query the hardware instead to avoid errors like this. We can consider calling a
> new mv88e6xxx_port_get_cmode() helper when needed (e.g. in higher level callers
> like mv88e6xxx_serdes_power() and mv88e6xxx_serdes_irq_thread_fn()) and pass
> the value down to the routines previously accessing chip->ports[port].cmode,
> as a new argument. I can prepare a patch doing this. What do you think?

Hi Vivien

There is one problem area. The lower ports on the 6390X, port
2-7. They can have two different cmode values, 0x1f for internal PHY,
and 0x09 for 1000BaseX when using an SFP. The switch will swap between
external and internal depending on which gets link first. But in order
for the SFP to get link, the SERDES needs to be powered on. And we
currently decide to power it on, and enable interrupts, via the
cmode. In the normal case, this works, e.g. ports 9 and 10 of 6390,
the fibre port of 6352. The cmode of 6390X is directly writable, we
get the phy-mode from DT and write the correct value. For 6352,
strapping is used, cmode is read only, but has the correct value.

But for the lower ports of 6390X, the hardware cmode defaults to 0x1f
until the fibre gets link, and then it changes to 0x09. It is not
writable. The current generic code does write to the register, which
in this case is pointless since it is read only, and it updates the
cached value, which is R/W. Later, when the port is enabled, we look
at the cached value, and based on that, decide is the SERDES should be
powered up, interrupts enabled. At this point, the cached value is
what we have in DT, but the hardware cmode is probably still 0x1f,
internal PHY. If we were to use the hardware value, we would never
enable the SERDES and so never get link.

This is all a bit hidden in the code. So if you want to remove the
cache, you need to add something in its place. Maybe explicitly keep
the configured value in the port structure, and modify the code using
cmode so that it either looks at the actual cmode, or the configured
cmode, depending on what it is trying to achieve.

ZII devel C is a good test bed for this, port 3 has both a copper PHY
wired to an RJ45 socket, and an SFF.

      Andrew
