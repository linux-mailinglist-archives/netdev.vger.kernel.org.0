Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26BC52CB2DA
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 03:39:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbgLBCjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 21:39:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:56098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726245AbgLBCjB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 21:39:01 -0500
Date:   Tue, 1 Dec 2020 18:38:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606876700;
        bh=Pnd6//6CcMWFvmqDm03/DWJtHy6nRzWDhsVB80NTRAo=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=w+ExpNd8vPUoiYtwmhSlh7dvTh9T36KnPlCMBtMi+RYIm5FqJ/7q1GB2w+ZzkK+9y
         VtqBcevEBEyxOlwsHHxI1zIoVT2JFeO12BPpNZmzUF1YI2s+Av4i2Nrej1VtR1TvrZ
         AoQ1v9jJEAmRxW77pkEsp7Lztr7DVgy8dUATRBbg=
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Mahesh Bandewar (=?UTF-8?B?4KSu4KS54KWH4KS2IOCkrOCkguCkoeClh+CktQ==?=
        =?UTF-8?B?4KS+4KSw?=) " <maheshb@google.com>
Cc:     nicolas.dichtel@6wind.com, David Ahern <dsahern@gmail.com>,
        Ido Schimmel <idosch@idosch.org>,
        Jian Yang <jianyang.kernel@gmail.com>,
        David Miller <davem@davemloft.net>,
        linux-netdev <netdev@vger.kernel.org>,
        Jian Yang <jianyang@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next] net-loopback: allow lo dev initial state to be
 controlled
Message-ID: <20201201183818.7d19b620@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <CAF2d9jgHOqsQFHE7tMwkgAQv2N24t3UWcMrK+ZnmfYNXHsPWuQ@mail.gmail.com>
References: <20201111204308.3352959-1-jianyang.kernel@gmail.com>
        <20201114101709.42ee19e0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAF2d9jgYgUa4DPVT8CSsbMs9HFjE5fn_U8-P=JuZeOecfiYt-g@mail.gmail.com>
        <20201116123447.2be5a827@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAF2d9ji24VkLipTCFSAU+L8yqKt9nfPSNfks9_V1Tnb0ztPrfA@mail.gmail.com>
        <20201117171830.GA286718@shredder.lan>
        <CAF2d9jhJq76KWaMGZLTTX4rLGvLDp+jLxCG9cTvv6jWZCtcFAA@mail.gmail.com>
        <b3445db2-5c64-fd31-b555-6a49b0fa524e@gmail.com>
        <7e16f1f3-2551-dff5-8039-bcede955bbfc@6wind.com>
        <CAF2d9jiD5OpqB83fyyutsJqtGRg0AsuDkTsS6j4Fc-H-FHWiUQ@mail.gmail.com>
        <eb1a89d2-f0c0-1c10-6588-c92939162713@6wind.com>
        <CAF2d9jgVhk8wOyNcKewBXP+B16Jh2FGakU64UH3fhFA+cTaNSg@mail.gmail.com>
        <20201119205633.6775c072@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CAF2d9jgHOqsQFHE7tMwkgAQv2N24t3UWcMrK+ZnmfYNXHsPWuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Dec 2020 12:24:38 -0800 Mahesh Bandewar (=E0=A4=AE=E0=A4=B9=E0=A5=
=87=E0=A4=B6 =E0=A4=AC=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=A4=BE=E0=A4=
=B0) wrote:
> On Thu, Nov 19, 2020 at 8:56 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > Do you have more details on what the use cases are that expect no
> > networking?
> >
> > TBH I don't get the utility of this knob. If you want to write vaguely
> > portable software you have to assume the knob won't be useful, because
> > either (a) kernel may be old, or (b) you shouldn't assume to own the
> > sysctls and this is a global one (what if an application spawns that
> > expects legacy behavior?)
> >
> > And if you have to check for those two things you're gonna write more
> > code than just ifuping lo would be.
> >
> > Maybe you can shed some more light on how it makes life at Google
> > easier for you? Or someone else can enlighten me?
> >
> > I don't have much practical experience with namespaces, but the more
> > I think about it the more pointless it seems. =20
>=20
> Thanks for the input.
>=20
> Sorry, I was on vacation and couldn't process this response earlier.
>=20
> There are two things that this patch is providing and let me understand t=
he
> objections well.
>=20
> (a) Bring up lo by default
> (b) sysctl to protect the legacy behavior
>=20
> Frankly we really dont have any legacy-behavior use case and one can
> bring it back to life by just doing 'ifdown lo' if necessary.

If use cases depending on legacy behavior exist we are just trading the
ifup in one case for an ifdown in another.

Unless we can dispel the notion that sand-boxing by lo down is a
legitimate use case IMO we're just adding complexity and growing
a sysctl for something that can be trivially handled from user space.

> Most of
> the use cases involve using networking anyways. My belief was that we
> need to protect legacy behavior and hence went lengths to add sysctl
> to protect it. If we are OK not to have it, I'm more than happy to
> remove the sysctl and just have the 3 line patch to bring loopback up.
>=20
> If legacy-behavior is a concern (which I thought generally is), then
> either we can have the sysctl to have it around to protect it (the
> current implementation) but if we prefer to have kernel-command-line
> instead of sysctl that defaults to legacy behavior but if provided, we
> can set it UP by default during boot (or the other way around)?
>=20
> My primary motive is (a) while (b) is just a side-effect which we can
> get away if deemed unnecessary.

