Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B76E62A5E02
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 07:03:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728371AbgKDGDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 01:03:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:37050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728346AbgKDGDG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 01:03:06 -0500
Received: from localhost (otava-0257.koleje.cuni.cz [78.128.181.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0114120759;
        Wed,  4 Nov 2020 06:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604469785;
        bh=CNBW6w417ntcAiRvrPfaTHAtsakiItDjd7ogIUkRVjg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GVCgSvXgLg4jtrjO5/iv7JCjPBeJb2nZPz6vfaEEa+mhFckLBdvYoPF79nbVLBdHv
         DAHf+WO5OgG2lVWt6+6QuXr1g8hGuwCQDpfv7kJb1tZYcDHUfWECiixYXMNxMmyL+k
         MEZxus7zlxiccHjzIaQxWXk4Gogff+2UF5TvDxsE=
Date:   Wed, 4 Nov 2020 07:02:51 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH net-next 1/5] r8152: use generic USB macros to define
 product table
Message-ID: <20201104070251.52fe638e@kernel.org>
In-Reply-To: <b83ddcca96cb40cf8785e6b44f9838e0@realtek.com>
References: <20201103192226.2455-1-kabel@kernel.org>
        <20201103192226.2455-2-kabel@kernel.org>
        <b83ddcca96cb40cf8785e6b44f9838e0@realtek.com>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 4 Nov 2020 01:57:10 +0000
Hayes Wang <hayeswang@realtek.com> wrote:

> Marek Beh=C3=BAn <kabel@kernel.org>
> > Sent: Wednesday, November 4, 2020 3:22 AM
> > diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
> > index b1770489aca5..85dda591c838 100644
> > --- a/drivers/net/usb/r8152.c
> > +++ b/drivers/net/usb/r8152.c
> > @@ -6862,20 +6862,12 @@ static void rtl8152_disconnect(struct
> > usb_interface *intf)
> >  }
> >=20
> >  #define REALTEK_USB_DEVICE(vend, prod)	\
> > -	.match_flags =3D USB_DEVICE_ID_MATCH_DEVICE | \
> > -		       USB_DEVICE_ID_MATCH_INT_CLASS, \
> > -	.idVendor =3D (vend), \
> > -	.idProduct =3D (prod), \
> > -	.bInterfaceClass =3D USB_CLASS_VENDOR_SPEC \
> > +	USB_DEVICE_INTERFACE_CLASS(vend, prod, USB_CLASS_VENDOR_SPEC)
> > \
> >  }, \
> >  { \
> > -	.match_flags =3D USB_DEVICE_ID_MATCH_INT_INFO | \
> > -		       USB_DEVICE_ID_MATCH_DEVICE, \
> > -	.idVendor =3D (vend), \
> > -	.idProduct =3D (prod), \
> > -	.bInterfaceClass =3D USB_CLASS_COMM, \
> > -	.bInterfaceSubClass =3D USB_CDC_SUBCLASS_ETHERNET, \
> > -	.bInterfaceProtocol =3D USB_CDC_PROTO_NONE
> > +	USB_DEVICE_AND_INTERFACE_INFO(vend, prod, USB_CLASS_COMM, \
> > +				      USB_CDC_SUBCLASS_ETHERNET, \
> > +				      USB_CDC_PROTO_NONE)
> >=20
> >  /* table of devices that work with this driver */
> >  static const struct usb_device_id rtl8152_table[] =3D { =20
>=20
> I don't use these, because checkpatch.pl would show error.
>=20
> 	$ scripts/checkpatch.pl --file --terse drivers/net/usb/r8152.c
> 	ERROR: Macros with complex values should be enclosed in parentheses
>=20
> Best Regards,
> Hayes
>=20

Hmm, checkpatch did not emit no warnings for me on these patches. Just
two CHECKs for the third patch.

BTW Hayes, is it possible for me gaining access to Realtek
documentation for these chips under NDA? For example via my employer,
CZ.NIC? I can't find any such information on Realtek website.

Also I could not download the driver from Realtek's website, I had to
find it on github. When clicking the download button on [1], it says:
  Warning
  The form #10 does not exist or it is not published.

BTW2 I am interested whether we can make the internal PHY visible to
the Linux PHY subsystem.

Marek

[1]
https://www.realtek.com/en/component/zoo/category/network-interface-control=
lers-10-100-1000m-gigabit-ethernet-usb-3-0-software
