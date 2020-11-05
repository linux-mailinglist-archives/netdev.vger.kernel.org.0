Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE8A42A7B0F
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 10:54:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725862AbgKEJyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 04:54:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:35924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725468AbgKEJyc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 04:54:32 -0500
Received: from localhost (otava-0257.koleje.cuni.cz [78.128.181.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BEFB2151B;
        Thu,  5 Nov 2020 09:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604570072;
        bh=9agbGEPPr9xW38aIK98jImG+WYCPaDEKvxORTCtGMbw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pZLxzjNoYbgOWtuJ54UDn/wO64zNb5m9vMiJPnhK2rCbnwupZREPYWxRbHtIrYTpw
         8J0E2VjSonrI4zE8c8ToIO7bozM0EJOvdSBTQo6ZI+d9QPeDMkNuQgb318aw5KTZm6
         1wzQOL40IsjeOg1CF43tFkTYpD7k6A2KJHWOxgUo=
Date:   Thu, 5 Nov 2020 10:54:18 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Hayes Wang <hayeswang@realtek.com>
Subject: Re: [PATCH net-next 3/5] r8152: add MCU typed read/write functions
Message-ID: <20201105105418.555d6e54@kernel.org>
In-Reply-To: <20201104121424.th4v6b3ucjhro5d3@skbuf>
References: <20201103192226.2455-1-kabel@kernel.org>
        <20201103192226.2455-4-kabel@kernel.org>
        <20201103214712.dzwpkj6d5val6536@skbuf>
        <20201104065524.36a85743@kernel.org>
        <20201104084710.wr3eq4orjspwqvss@skbuf>
        <20201104112511.78643f6e@kernel.org>
        <20201104113545.0428f3fe@kernel.org>
        <20201104110059.whkku3zlck6spnzj@skbuf>
        <20201104121053.44fae8c7@kernel.org>
        <20201104121424.th4v6b3ucjhro5d3@skbuf>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 4 Nov 2020 14:14:24 +0200
Vladimir Oltean <olteanv@gmail.com> wrote:

> On Wed, Nov 04, 2020 at 12:10:53PM +0100, Marek Beh=C3=BAn wrote:
> > > I'm not sure it's worth the change :(
> > > Let's put it another way, your diffstat has 338 insertions and 335
> > > deletions. Aka you're saving 3 lines overall.
> > > With this new approach that doesn't use token concatenation at all,
> > > you're probably not saving anything at all.
> > > Also, I'm not sure that you need to make the functions inline. The
> > > compiler should be smart enough to not generate functions for
> > > usb_ocp_read_byte etc. You can check with
> > > "make drivers/net/usb/r8152.lst". =20
> >=20
> > Vladimir, the purpose of this patch isn't to save lines, but to save us
> > from always writing MCU_TYPE_USB / MCU_TYPE_PLA.
> > It just transforms forms of
> >   ocp_read_word(tp, MCU_TYPE_USB, idx);
> >   ocp_write_dword(tp, MCU_TYPE_PLA, idx, val);
> > into
> >   usb_ocp_read_word(tp, idx);
> >   pla_ocp_write_dword(tp, idx, val);
> >=20
> > The fifth patch of this series saves lines by adding _modify functions,
> > to transform
> >   val =3D *_read(idx);
> >   val &=3D ~clr;
> >   val |=3D set;
> >   *_write(idx, val);
> > into
> >   *_modify(idx, clr, set);
> >  =20
>=20
> So if the point isn't to save lines, then why don't you go for something
> trivial?
>=20
> static void ocp_modify_byte(struct r8152 *tp, u16 type, u16 index, u8 clr,
> 			    u8 set)
> {
> 	u8 val =3D ocp_read_byte(tp, type, index);
>=20
> 	ocp_write_byte(tp, type, index, (val & ~clr) | set);
> }
>=20
> static void ocp_modify_word(struct r8152 *tp, u16 type, u16 index, u16 cl=
r,
> 			    u16 set)
> {
> 	u16 val =3D ocp_read_word(tp, type, index);
>=20
> 	ocp_write_word(tp, type, index, (val & ~clr) | set);
> }
>=20
> static void ocp_modify_dword(struct r8152 *tp, u16 type, u16 index, u32 c=
lr,
> 			     u32 set)
> {
> 	u32 val =3D ocp_read_dword(tp, type, index);
>=20
> 	ocp_write_dword(tp, type, index, (val & ~clr) | set);
> }
>=20
> #define pla_ocp_read_byte(tp, index)				\
> 	ocp_read_byte(tp, MCU_TYPE_PLA, index)
> #define pla_ocp_write_byte(tp, index, data)			\
> 	ocp_write_byte(tp, MCU_TYPE_PLA, index, data)
> #define pla_ocp_modify_byte(tp, index, clr, set)		\
> 	ocp_modify_byte(tp, MCU_TYPE_PLA, index, clr, set)
> #define pla_ocp_read_word(tp, index)				\
> 	ocp_read_word(tp, MCU_TYPE_PLA, index)
> #define pla_ocp_write_word(tp, index, data)			\
> 	ocp_write_word(tp, MCU_TYPE_PLA, index, data)
> #define pla_ocp_modify_word(tp, index, clr, set)		\
> 	ocp_modify_word(tp, MCU_TYPE_PLA, index, clr, set)
> #define pla_ocp_read_dword(tp, index)				\
> 	ocp_read_dword(tp, MCU_TYPE_PLA, index)
> #define pla_ocp_write_dword(tp, index, data)			\
> 	ocp_write_dword(tp, MCU_TYPE_PLA, index, data)
> #define pla_ocp_modify_dword(tp, index, clr, set)		\
> 	ocp_modify_dword(tp, MCU_TYPE_PLA, index, clr, set)
>=20
> #define usb_ocp_read_byte(tp, index)				\
> 	ocp_read_byte(tp, MCU_TYPE_USB, index)
> #define usb_ocp_write_byte(tp, index, data)			\
> 	ocp_write_byte(tp, MCU_TYPE_USB, index, data)
> #define usb_ocp_modify_byte(tp, index, clr, set)		\
> 	ocp_modify_byte(tp, MCU_TYPE_USB, index, clr, set)
> #define usb_ocp_read_word(tp, index)				\
> 	ocp_read_word(tp, MCU_TYPE_USB, index)
> #define usb_ocp_write_word(tp, index, data)			\
> 	ocp_write_word(tp, MCU_TYPE_USB, index, data)
> #define usb_ocp_modify_word(tp, index, clr, set)		\
> 	ocp_modify_word(tp, MCU_TYPE_USB, index, clr, set)
> #define usb_ocp_read_dword(tp, index)				\
> 	ocp_read_dword(tp, MCU_TYPE_USB, index)
> #define usb_ocp_write_dword(tp, index, data)			\
> 	ocp_write_dword(tp, MCU_TYPE_USB, index, data)
> #define usb_ocp_modify_dword(tp, index, clr, set)		\
> 	ocp_modify_dword(tp, MCU_TYPE_USB, index, clr, set)
>=20
> To my eyes this is easier to digest.
>=20
> That is, unless you want to go for function pointers and have separate
> structures for PLA and USB...

I thought that static inline functions are preferred to macros, since
compiler warns better if they are used incorrectly...
