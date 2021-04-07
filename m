Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83A40356F30
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 16:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353261AbhDGOtg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 10:49:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:54298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353138AbhDGOtW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 10:49:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8556E61260;
        Wed,  7 Apr 2021 14:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617806952;
        bh=hV+1CHxB4/Qn8MeLrI1FDbzfUdFHpFPwedbnGxRaRFw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rioNKVxYTMgTXS2vXYN25Uibg36r1iRSebKGjPJWxXsPeK5yznf3acimGC8zfsM8Z
         2TFWHzSy7CwaQgZrNUbMuwLEoV/Gl0ZuePTNpbH93uOp7puqHioqnKUl8GEV3IM5q5
         ihJ3TiuMF28CV2MtH0oR7BTuDczoXKafvJruX4USKuB3AcQ1H03oLNSdRShCP7Q+TI
         Hd+41Zx4bINFYt5UgdtOBqmtnBDLN91E4qsEmugj9N8Jwtg6cnEjoyViwf6AxkIZBI
         MzSMUuEc/A+gLeHNRWs7BPbszRh0GTJRPpiiugWoBWCYtI6z6MskvbHdFGO3KM89MG
         DTIxnOZniYjZw==
Date:   Wed, 7 Apr 2021 16:49:08 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH kbuild] Makefile.extrawarn: disable -Woverride-init in
 W=1
Message-ID: <20210407164908.3f07f8c2@thinkpad>
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

You can look at the current definition in this patch
https://git.kernel.org/pub/scm/linux/kernel/git/kabel/linux.git/commit/?h=
=3Dmarvell10g-updates&id=3Da4ba5e6563ac4d9e352f55fbae8431339001acf1

And the previous patch, adding variadic-macro.h
https://git.kernel.org/pub/scm/linux/kernel/git/kabel/linux.git/commit/?h=
=3Dmarvell10g-updates&id=3Dd5f8438024b688e96bdd16349f717e5469183362

I fear it won't be possible to expand a macro in such a way to
initialize each member only once, without giving it the number of array
members it has to fill as a constant, i.e. if the bitmap is 100 bits on
a 32 bit machine, it has to fill up to 4 longs, so we would need to
give 4 as an argument:
  ... =3D INITIALIZE_BITMAP(4, ...);
but DIV_ROUND_UP(100, BITS_PER_LONG) won't work.

Another way around this is to use _Pragma to disable this specific
warning for a specific part of code. Unfortunately it seems that this
_Pragma operator cannot be used withing the designated initializer, it
has to be outside the expression declaring the variable, i.e.
  _Pragma("GCC diagnostic ignored \"-Woverride-init\"")
  ... =3D INITIALIZE_BITMAP(...);

What I am frustrated about is why doesn't the compiler have the option
to warn only if designated initializer initializes the same member to a
different value...

Marek
