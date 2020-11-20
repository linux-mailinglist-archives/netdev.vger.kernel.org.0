Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 356B92BA195
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 05:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbgKTE4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 23:56:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:53890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725936AbgKTE4f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 23:56:35 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 414522236F;
        Fri, 20 Nov 2020 04:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605848194;
        bh=+OjlNDeu9jaZJGfhXpJuG91CP3hMvNJ9Lf1xOd45q9A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nfZhlB+5b0SUH6Wvi2azR1k9xEyxi/W/PnsuePfZJM9P8fE+4Ngw2JbP74fakFb8M
         Z8CJ9xjjF9/Xb2hMT6SZNAXWwv2E3Oix9SoXKe62RCYUTv0ia3QZGondKDALU+2Lwq
         uLe7HD6F78ghY2LSp6x1MXNx9aT7tzw8jSVBt1s4=
Date:   Thu, 19 Nov 2020 20:56:33 -0800
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
Message-ID: <20201119205633.6775c072@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CAF2d9jgVhk8wOyNcKewBXP+B16Jh2FGakU64UH3fhFA+cTaNSg@mail.gmail.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Nov 2020 19:55:08 -0800 Mahesh Bandewar (=E0=A4=AE=E0=A4=B9=E0=
=A5=87=E0=A4=B6 =E0=A4=AC=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=A4=BE=E0=
=A4=B0) wrote:
> On Thu, Nov 19, 2020 at 12:03 AM Nicolas Dichtel
> > Le 18/11/2020 =C3=A0 18:39, Mahesh Bandewar (=E0=A4=AE=E0=A4=B9=E0=A5=
=87=E0=A4=B6 =E0=A4=AC=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=A4=BE=E0=A4=
=B0) a =C3=A9crit : =20
> > > netns but would create problems for workloads that create netns to
> > > disable networking. One can always disable it after creating the netns
> > > but that would mean change in the workflow and it could be viewed as
> > > regression. =20
> > The networking is very limited with only a loopback. Do you have some r=
eal use
> > case in mind? =20
>=20
> My use cases all use networking but I think principally we cannot
> break backward compatibility, right?
> Jakub, WDYT?

Do you have more details on what the use cases are that expect no
networking?

TBH I don't get the utility of this knob. If you want to write vaguely
portable software you have to assume the knob won't be useful, because
either (a) kernel may be old, or (b) you shouldn't assume to own the
sysctls and this is a global one (what if an application spawns that
expects legacy behavior?)

And if you have to check for those two things you're gonna write more
code than just ifuping lo would be.

Maybe you can shed some more light on how it makes life at Google
easier for you? Or someone else can enlighten me?

I don't have much practical experience with namespaces, but the more=20
I think about it the more pointless it seems.
