Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2A071CC36F
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 19:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728708AbgEIR7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 13:59:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:57842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728648AbgEIR7Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 13:59:16 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CEDC3208CA;
        Sat,  9 May 2020 17:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589047156;
        bh=3sScCn48hhWnKgXHIohdt15QapiKvWIgKGBDXo4oqkk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=o8/pelUrriPmGIul/Hzih1bIVUpEqHHacS3L6rMQ9uRXh4JtgX65MJXWgRM3wD81z
         AU+3OeOFXHpjzjLn4kH0dOs4TjFKfcGsCD2sDGkuoQaGkr21on8JnScq/7hhSWN5zC
         3Yrc8BG1aunPeTvQKmCAtS6VQmFozZxepd+PS3ts=
Date:   Sat, 9 May 2020 10:59:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stephen Kitt <steve@sk2.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Joe Perches <joe@perches.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: Protect INET_ADDR_COOKIE on 32-bit
 architectures
Message-ID: <20200509105914.04fd19c8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200509101322.12651ba0@heffalump.sk2.org>
References: <20200508120457.29422-1-steve@sk2.org>
        <20200508205025.3207a54e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200509101322.12651ba0@heffalump.sk2.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 9 May 2020 10:13:22 +0200 Stephen Kitt wrote:
> Hi,
>=20
> Thanks for taking the time to review my patch.
>=20
> On Fri, 8 May 2020 20:50:25 -0700, Jakub Kicinski <kuba@kernel.org> wrote:
> > On Fri,  8 May 2020 14:04:57 +0200 Stephen Kitt wrote: =20
> > > Commit c7228317441f ("net: Use a more standard macro for
> > > INET_ADDR_COOKIE") added a __deprecated marker to the cookie name on
> > > 32-bit architectures, with the intent that the compiler would flag
> > > uses of the name. However since commit 771c035372a0 ("deprecate the
> > > '__deprecated' attribute warnings entirely and for good"),
> > > __deprecated doesn't do anything and should be avoided.
> > >=20
> > > This patch changes INET_ADDR_COOKIE to declare a dummy struct so that
> > > any subsequent use of the cookie's name will in all likelihood break
> > > the build. It also removes the __deprecated marker. =20
> >=20
> > I think the macro is supposed to cause a warning when the variable
> > itself is accessed. And I don't think that happens with your patch
> > applied. =20
>=20
> Yes, the warning is what was lost when __deprecated lost its meaning. I w=
as
> trying to preserve that, or rather extend it so that the build would brea=
k if
> the cookie was used on 32-bit architectures, and my patch ensures it does=
 if
> the cookie is used in a comparison or assignment, but ...
>=20
> > +       kfree(&acookie); =20
>=20
> I hadn=E2=80=99t thought of taking a pointer to it.
>=20
> If we want to preserve the use of the macro with a semi-colon, which is w=
hat
> Joe=E2=80=99s patch introduced (along with the deprecation warning), we s=
till need
> some sort of declaration which can=E2=80=99t be used. Perhaps
>=20
> #define INET_ADDR_COOKIE(__name, __saddr, __daddr) \
> 	struct __name {} __attribute__((unused))
>=20
> would be better =E2=80=94 it declares the cookie as a struct, not a varia=
ble, so then
> the build fails if the cookie is used as anything other than a struct. If
> anyone does try to use it as a struct, the build will fail on 64-bit
> architectures...
>=20
>   CC      net/ipv4/inet_hashtables.o
> net/ipv4/inet_hashtables.c: In function =E2=80=98__inet_lookup_establishe=
d=E2=80=99:
> net/ipv4/inet_hashtables.c:362:9: error: =E2=80=98acookie=E2=80=99 undecl=
ared (first use in this function)
>   kfree(&acookie);
>          ^~~~~~~
> net/ipv4/inet_hashtables.c:362:9: note: each undeclared identifier is rep=
orted only once for each function it appears in
> make[2]: *** [scripts/Makefile.build:267: net/ipv4/inet_hashtables.o] Err=
or 1
> make[1]: *** [scripts/Makefile.build:488: net/ipv4] Error 2
> make: *** Makefile:1722: net] Error 2

Hm. That does seem better. Although thinking about it - we will not get
a warning when someone declares a variable with the same name..

What if we went back to your original proposal of an empty struct but
added in an extern in front? That way we should get linker error on
pointer references.
