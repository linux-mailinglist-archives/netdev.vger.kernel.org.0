Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09C2C40FF9D
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 20:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343570AbhIQSus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 14:50:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:49356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343571AbhIQSus (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 14:50:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82DCC61056;
        Fri, 17 Sep 2021 18:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631904565;
        bh=1FNPXiN1Fo6he6hEpv7/28fBcuMXfe8RZRxKzJE47A4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=t/w+uvxfQ+Md8NIgBrricO6nPw+ibkVMNHfHWHhqq7dffOp6wz7ybB1jFEAvGApcd
         nIiAdXryWzfpVIjtK6a5QGm66ZZ2UvCpJqFDb2UaREwDRmCe4I9R3te0sgcplL8NkN
         Tor+jWbh5MAn7zFOF5yRFOcjk/mWgxt6SlvKK98zy8X4N/cDWxYxkjoEaN7bF/gh0e
         IGLhPmLPSWVWMTzuSFGX7WhdL9Y6IfrpKtqULp3xq+hSsrUYILa5sBoZcvmTb9JH3l
         WHPtyhoKUicNt1vnA6pzlxuLfPeQG+41SrLsNaZ4nL4paA05t+hKpdmIp16s8RmakA
         gQNGJ/cVUEERQ==
Date:   Fri, 17 Sep 2021 11:49:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maciej =?UTF-8?B?xbtlbmN6eWtvd3NraQ==?= <zenczykowski@gmail.com>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux NetDev <netdev@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Maciej Zenczykowski <maze@google.com>
Subject: Re: nt: usb: USB_RTL8153_ECM should not default to y
Message-ID: <20210917114924.2a7bda93@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CANP3RGeaOqxOMwCFKb=3X5EFaXNG+k3N2CfV4YT-8NiY5GW3Tg@mail.gmail.com>
References: <CANP3RGeaOqxOMwCFKb=3X5EFaXNG+k3N2CfV4YT-8NiY5GW3Tg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Sep 2021 19:59:15 +0200 Maciej =C5=BBenczykowski wrote:
> I've been browsing some usb ethernet dongle related stuff in the
> kernel (trying to figure out which options to enable in Android 13
> 5.~15 kernels), and I've come across the following patch (see topic,
> full patch quoted below).
>=20
> Doesn't it entirely defeat the purpose of the patch it claims to fix
> (and the patch that fixed)?
> Certainly the reasoning provided (in general device drivers should not
> be enabled by default) doesn't jive with me.
> The device driver is CDC_ETHER and AFAICT this is just a compatibility
> option for it.
>=20
> Shouldn't it be reverted (ie. the 'default y' line be re-added) ?
>=20
> AFAICT the logic should be:
>   if we have CDC ETHER (aka. ECM), but we don't have R8152 then we
> need to have R8153_ECM.
>=20
> Alternatively, maybe there shouldn't be a config option for this at all?
>=20
> Instead r8153_ecm should simply be part of cdc_ether.ko iff r8152=3Dn
>=20
> I'm not knowledgeable enough about Kconfig syntax to know how to
> phrase the logic...
> Maybe there shouldn't be a Kconfig option at all, and just some Makefile =
if'ery.
>=20
> Something like:
>=20
> obj-$(CONFIG_USB_RTL8152) +=3D r8152.o
> obj-$(CONFIG_USB_NET_CDCETHER) +=3D cdc_ether.o obj-
> ifndef CONFIG_USB_RTL8152
> obj-$(CONFIG_USB_NET_CDCETHER) +=3D r8153_ecm.o
> endif
>=20
> Though it certainly would be nice to use 8153 devices with the
> CDCETHER driver even with the r8152 driver enabled...

Yeah.. more context here:

https://lore.kernel.org/all/7fd014f2-c9a5-e7ec-f1c6-b3e4bb0f6eb6@samsung.co=
m/

default !USB_RTL8152 would be my favorite but that probably doesn't
compute in kconfig land. Or perhaps bring back the 'y' but more clearly
mark it as a sub-option of CDCETHER? It's hard to blame people for
expecting drivers to default to n, we should make it clearer that this
is more of a "make driver X support variation Y", 'cause now it sounds
like a completely standalone driver from the Kconfig wording. At least
to a lay person like myself.
