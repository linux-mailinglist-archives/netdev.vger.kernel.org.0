Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 630012BC254
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 22:50:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728593AbgKUVsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 16:48:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:46838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728581AbgKUVsP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Nov 2020 16:48:15 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7E1121D7E;
        Sat, 21 Nov 2020 21:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605995294;
        bh=3zT8HhTxhglEPafgZciTM1Zx4u8EwfPn6PI0vYTn3Vw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vfPrdMnToohJtHEhoXJvfnIB8mNcre52A7IDEszCqH8f3c/ZlOaHJQYaO1IlvLKn1
         x2Ir2N6kEvRgKCzlAvp4CmCdx9+05lrxvMvRZQQyX3Vo9PMBTbtm3kme/cDVB3QEDZ
         oQ1OgciVt4wzYydGqMDBFExIwgVts3RlZO4jMuFo=
Date:   Sat, 21 Nov 2020 13:48:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH net-next] compat: always include linux/compat.h from
 net/compat.h
Message-ID: <20201121134813.2e9441b4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAK8P3a1sZ7CUwQ-fUCS-z4CkhgSiNqzPcc_MTc2D54-8vfmV=g@mail.gmail.com>
References: <20201121175224.1465831-1-kuba@kernel.org>
        <CAK8P3a1sZ7CUwQ-fUCS-z4CkhgSiNqzPcc_MTc2D54-8vfmV=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 21 Nov 2020 22:25:35 +0100 Arnd Bergmann wrote:
> On Sat, Nov 21, 2020 at 6:52 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > We're about to do some reshuffling in networking headers and make
> > some of the file lose the implicit includes. This results in:
> >
> > In file included from net/ipv4/netfilter/arp_tables.c:26:
> > include/net/compat.h:57:23: error: conflicting types for =E2=80=98uintp=
tr_t=E2=80=99
> >  #define compat_uptr_t uintptr_t
> >                        ^~~~~~~~~
> > include/asm-generic/compat.h:22:13: note: in expansion of macro =E2=80=
=98compat_uptr_t=E2=80=99
> >  typedef u32 compat_uptr_t;
> >              ^~~~~~~~~~~~~
> > In file included from include/linux/limits.h:6,
> >                  from include/linux/kernel.h:7,
> >                  from net/ipv4/netfilter/arp_tables.c:14:
> > include/linux/types.h:37:24: note: previous declaration of =E2=80=98uin=
tptr_t=E2=80=99 was here
> >  typedef unsigned long  uintptr_t;
> >                         ^~~~~~~~~
> >
> > Currently net/compat.h depends on linux/compat.h being included
> > first. After the upcoming changes this would break the 32bit build.
> >
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > ---
> > Not sure who officially maintains this. Arnd, Christoph any objections?=
 =20
>=20
> Looks good to me. I would actually go one step further and completely
> remove this #ifdef, if possible. In the old days, it was not possible to
> include linux/compat.h on 32-bit architectures, but now this should just
> work without an #ifdef.

Indeed, that appears to work, v2 coming up, thanks!
