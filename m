Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2449435763E
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 22:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230501AbhDGUoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 16:44:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:33456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229586AbhDGUoU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 16:44:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C333610F8;
        Wed,  7 Apr 2021 20:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617828250;
        bh=URZWGy1mjmdEc1Pm5+FHNqN8L31ZZ67xIgdElygE9zU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LsxAIJeimiAJh4rOxUzh6oTYxvk2C0yebgRxE4Oi+Cbi0RzQL+V9Tb9DNlBbltzGJ
         lZI7YEEQwrqZmaTwGT+HWS9Di9TjjbmP/E23fEG5gHRapm3Sv9wYtOSHErHTVMdQc3
         bGht4qkI5qYpSoUo/2igFz6T9Ex2W3Pp19d6KZJ2OABQnrDXJqbrCt39Le4Nxwp6hT
         lfBoiw1EFEGT1kkQfi7dri3pOg0v9/kSvZ9XeuyqoMJiAJoFp65btsaCfIYa3hnfA6
         nxmfEFb3H7ZmZO8lcTO8dGTITxyTWbIznNkBi3CAQBTRa/fC7gZ0jCVMDLl65nf4tZ
         Sa7T0l5cugKkQ==
Date:   Wed, 7 Apr 2021 22:44:06 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH kbuild] Makefile.extrawarn: disable -Woverride-init in
 W=1
Message-ID: <20210407224406.5420258b@thinkpad>
In-Reply-To: <CAK8P3a0_ruZSMv-kLMY7Jja7wq0K3aNNDviYqQPmN-3UayiHaQ@mail.gmail.com>
References: <20210407002450.10015-1-kabel@kernel.org>
        <CAK8P3a0_ruZSMv-kLMY7Jja7wq0K3aNNDviYqQPmN-3UayiHaQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 7 Apr 2021 09:14:29 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> On Wed, Apr 7, 2021 at 2:24 AM Marek Beh=C3=BAn <kabel@kernel.org> wrote:
> >
> > The -Wextra flag enables -Woverride-init in newer versions of GCC.
> >
> > This causes the compiler to warn when a value is written twice in a
> > designated initializer, for example:
> >   int x[1] =3D {
> >     [0] =3D 3,
> >     [0] =3D 3,
> >   };
> >
> > Note that for clang, this was disabled from the beginning with
> > -Wno-initializer-overrides in commit a1494304346a3 ("kbuild: add all
> > Clang-specific flags unconditionally").
> >
> > This prevents us from implementing complex macros for compile-time
> > initializers. =20
>=20
> I think this is generally a useful warning, and it has found a number
> of real bugs. I would want this to be enabled in both gcc and clang
> by default, and I have previously sent both bugfixes and patches to
> disable it locally.
>=20
> > For example a macro of the form INITIALIZE_BITMAP(bits...) that can be
> > used as
> >   static DECLARE_BITMAP(bm, 64) =3D INITIALIZE_BITMAP(0, 1, 32, 33);
> > can only be implemented by allowing a designated initializer to
> > initialize the same members multiple times (because the compiler
> > complains even if the multiple initializations initialize to the same
> > value). =20
>=20
> We don't have this kind of macro at the moment, and this may just mean
> you need to try harder to come up with a definition that only initializes
> each member once if you want to add this.
>=20
> How do you currently define it?
>=20
>             Arnd

Arnd,

since it is possible to create a macro which will expand N times if N
is a preprocessor numeric constant, i.e.
  EXPAND_N_TIMES(3, macro, args...)
would expand to
  macro(1, args...) macro(2, args...) macro(3, args...)

But the first argument to this EXPAND_N_TIMES macro would have to be a
number when preprocessing, so no expression via division, nor enums.

Example:

  The PHY_INTERFACE_MODE_* constants are defined via enum, and
  the last is PHY_INTERFACE_MODE_MAX.

  We could then implement bitmap initializers for PHY_INTERFACE_MODE
  bitmap in the following way:

  enum {
    ...
    PHY_INTERFACE_MODE_MAX
  };

  /* assume PHY_INTERFACE_MODE_MASK has value 50, so 2 longs on 32-bit
   * and 1 long on 64-bit. These have to be direct constant, no expressions
   * allowed. If more PHY_INTERFACE_MODE_* constants are added to the enum
   * above, the following must be changed accordingly. The static_assert
   * below guards against invalid value.
   */

  #define PHY_INTERFACE_BITMAP_LONGS_64  1
  #define PHY_INTERFACE_BITMAP_LONGS_32  2

  /* check if PHY_INTERFACE_BITMAP_LONGS_* have correct values */
  static_assert(PHY_INTERFACE_BITMAP_LONGS_64 =3D=3D
                DIV_ROUND_UP(PHY_INTERFACE_MODE_MASK, 64));
  static_assert(PHY_INTERFACE_BITMAP_LONGS_32 =3D=3D
                DIV_ROUND_UP(PHY_INTERFACE_MODE_MASK, 32));

  #define DECLARE_PHY_INTERFACE_MASK(name) \
    DECLARE_BITMAP(name, PHY_INTERFACE_MODE_MAX)

  #define INIT_PHY_INTERFACE_MASK(...) \
    INITIALIZE_BITMAP(PHY_INTERFACE_BITMAP_LONGS, ##__VA_ARGS__)

What do you think?

Marek
