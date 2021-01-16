Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB0662F8E15
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 18:16:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728172AbhAPRPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 12:15:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:60688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727817AbhAPRPH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Jan 2021 12:15:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2EA020732
        for <netdev@vger.kernel.org>; Sat, 16 Jan 2021 17:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610816668;
        bh=bTvHQvp9eWwcNl2Oc0CzEA/CUDgnY2dH8evWcjG8HlU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=OERV65Jn4Ycm6T8KLayHLGetv2PBT2JP7eUrycilkr3TqkF1WDJEWRlpZrP/9ju31
         OVa8mSuIeqIV4/Z1BHU+ntd8jEIjCZQtPoWDrOUs5oeyIEhcVEDsI4ZW8D4KXKIVmy
         31vld53CgFHiDwiuYgriwviUNO0wi7x6jgg3khInb762/IOJ2Y3NU1h8b+GLB688H/
         WVbRy1l7jEOGUlAr9kJ2qJVDuRCJj8XIopn0MB59TCok4QQZIGLPj7Sax/eYjorGL6
         AUVvoVHGsEF1oYmPmHHBT5cK7Bh0LFn3gG9c4pZxkFlBVb1Z4OOz3zYSmYIMw09DK5
         SllYBf1KJhGIw==
Received: by mail-oi1-f176.google.com with SMTP id l200so13079391oig.9
        for <netdev@vger.kernel.org>; Sat, 16 Jan 2021 09:04:28 -0800 (PST)
X-Gm-Message-State: AOAM533R6/nzfj31tU0EKwEj7eBmZsNoJ2vM+CTrBYNWFbJ/QMY1pws9
        to7smZoCxgLu6yVsailaOiBJCcWmTssDE2hrxuk=
X-Google-Smtp-Source: ABdhPJx9Pvp3Pf/Fb2DS6lnbNp1sYyTr/LFKFhPF+GYpKs+QUSJYLjl1ixHxh5dznRaZNA0LwQk5kRU03gi6Uh9X+8A=
X-Received: by 2002:aca:e103:: with SMTP id y3mr8684502oig.11.1610816668050;
 Sat, 16 Jan 2021 09:04:28 -0800 (PST)
MIME-Version: 1.0
References: <20210116164828.40545-1-marex@denx.de>
In-Reply-To: <20210116164828.40545-1-marex@denx.de>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Sat, 16 Jan 2021 18:04:12 +0100
X-Gmail-Original-Message-ID: <CAK8P3a1iqXjsYERVh+nQs9Xz4x7FreW3aS7OQPSB8CWcntnL4A@mail.gmail.com>
Message-ID: <CAK8P3a1iqXjsYERVh+nQs9Xz4x7FreW3aS7OQPSB8CWcntnL4A@mail.gmail.com>
Subject: Re: [PATCH net-next V2] net: ks8851: Fix mixed module/builtin build
To:     Marek Vasut <marex@denx.de>
Cc:     Networking <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Arnd Bergmann <arnd@arndb.de>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Lukas Wunner <lukas@wunner.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 16, 2021 at 5:48 PM Marek Vasut <marex@denx.de> wrote:
>
> When either the SPI or PAR variant is compiled as module AND the other
> variant is compiled as built-in, the following build error occurs:
>
> arm-linux-gnueabi-ld: drivers/net/ethernet/micrel/ks8851_common.o: in function `ks8851_probe_common':
> ks8851_common.c:(.text+0x1564): undefined reference to `__this_module'
>
> Fix this by passing THIS_MODULE as argument to ks8851_probe_common(),
> ks8851_register_mdiobus(), and ultimately __mdiobus_register() in the
> ks8851_common.c.
>
> Fixes: ef3631220d2b ("net: ks8851: Register MDIO bus and the internal PHY")
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Lukas Wunner <lukas@wunner.de>

I don't really like this version, as it does not actually solve the problem of
linking the same object file into both vmlinux and a loadable module, which
can have all kinds of side-effects besides that link failure you saw.

If you want to avoid exporting all those symbols, a simpler hack would
be to '#include "ks8851_common.c" from each of the two files, which
then always duplicates the contents (even when both are built-in), but
at least builds the file the correct way.

       Arnd
