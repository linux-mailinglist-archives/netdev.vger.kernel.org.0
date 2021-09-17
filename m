Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 864C140FFE3
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 21:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235944AbhIQTih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 15:38:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:59694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234669AbhIQTih (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 15:38:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B3DE610C8;
        Fri, 17 Sep 2021 19:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631907434;
        bh=wGhE5farzIC2GEkz++0iBlfT/SWQr6RO+K140pDNmWA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ULf9G6ghqZzqAippa+RugI6ISG5wA3BxVUKqwnOrS3m7tgb8Uhwz7WAECA+drVLJs
         IUjmgKpArDtCqjCVJulrjO6sJZwkCfYaQ2nXlktY44sN43kKU4fQOmZyq11lSnGb1t
         HJiaUVeRESJfN7IdjHk63SmJ2u+6skxacI+/7b8HrVNxXWN/dIBgMxY3qmoW/fWE/8
         B2w5Nny5RJYs67OfROGOh2WWfsguZLRB3z+wNZ+2BAKrOfXlf5ggIuv9Nz2Nqtk1f7
         CZcikpRbdPwbt0CJaxtHWOtk/Pl+qcdCtwfWNaONnBnF+oMXTA+/cD3Osk9NZ3TPP9
         yvSItBLF8wVnw==
Date:   Fri, 17 Sep 2021 12:37:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maciej =?UTF-8?B?xbtlbmN6eWtvd3NraQ==?= <zenczykowski@gmail.com>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux NetDev <netdev@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: nt: usb: USB_RTL8153_ECM should not default to y
Message-ID: <20210917123713.67e116aa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CANP3RGfPzXTMX+FAvd73EWjQnqUPyczuTD0dTQ79RMoVpjyQMg@mail.gmail.com>
References: <CANP3RGeaOqxOMwCFKb=3X5EFaXNG+k3N2CfV4YT-8NiY5GW3Tg@mail.gmail.com>
        <20210917114924.2a7bda93@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANP3RGfPzXTMX+FAvd73EWjQnqUPyczuTD0dTQ79RMoVpjyQMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Sep 2021 21:05:55 +0200 Maciej =C5=BBenczykowski wrote:
> > Yeah.. more context here:
> >
> > https://lore.kernel.org/all/7fd014f2-c9a5-e7ec-f1c6-b3e4bb0f6eb6@samsun=
g.com/
> >
> > default !USB_RTL8152 would be my favorite but that probably doesn't
> > compute in kconfig land. Or perhaps bring back the 'y' but more clearly
> > mark it as a sub-option of CDCETHER? It's hard to blame people for
> > expecting drivers to default to n, we should make it clearer that this
> > is more of a "make driver X support variation Y", 'cause now it sounds
> > like a completely standalone driver from the Kconfig wording. At least
> > to a lay person like myself. =20
>=20
> I think:
>         depends on USB_NET_CDCETHER && (USB_RTL8152 || USB_RTL8152=3Dn)
>         default y
> accomplished exactly what was wanted.
>=20
> USB_NET_CDCETHER is a dependency, hence:
>=20
> USB_NET_CDCETHER=3Dn forces it off - as it should - it's an addon to cdce=
ther.
>=20
> USB_NET_CDCETHER=3Dm disallows 'y' - module implies addon must be module.
>=20
> similarly USB_RTL8152 is a dependency, so it being a module disallows 'y'.
> This is desired, because if CDCETHER is builtin, so this addon could
> be builtin, then RTL8152 would fail to bind it by default.
> ie. CDCETHER=3Dy && RTL8152=3Dm must force RTL8153_ECM !=3D y  (this is t=
he bugfix)
>=20
> basically the funky 'USB_RTL8152 || USB_RTL8152=3Dn' --> disallows 'y'
> iff RTL8152=3Dm
>=20
> 'default y' enables it by default as 'y' if possible, as 'm' if not,
> and disables it if impossible.
>=20
> So I believe this had the exact right default behaviour - and allowed
> all the valid options.

Right, it was _technically_ correct but run afoul of the "drivers
should default to 'n'" policy. If it should not be treated as a driver
but more of a feature of an existing driver which user has already
selected we should refine the name of the option to make that clear.
