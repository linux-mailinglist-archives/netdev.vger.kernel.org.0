Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BFCF48E336
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 05:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239120AbiANER1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 23:17:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbiANERZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 23:17:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C72C061574;
        Thu, 13 Jan 2022 20:17:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 219D9B823A8;
        Fri, 14 Jan 2022 04:17:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A51F6C36AEA;
        Fri, 14 Jan 2022 04:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642133841;
        bh=IaC1j8evMMwZcJMXhPsRQqalbGeC4iRw3/bYrg/XhEM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=utufFiBtnm8ZDlQ6r/zygBK3ODIJHHiBdPzoUEFCEZF54z6sUifD5PAB9C0GJz0pW
         7L7e9z3cCxobRAex44fkQxDKSS3C7YcOghDTNTsXGW2obQ3x/sHZDukJHtaIUMxSQU
         OzjuRqQSkWyTcQusYBiQx0VFcuqtqQk/uKNAXQ0OosMMpeDkuZ5ARP1gm7qFIyuct7
         jTW3iETPnnT8382YMHcyZ8IbSZysrj+HZYrIaoEnNn8X4EYN0RcJcyXWGfgj4ZezMm
         qltYXWBXSur0G/FWp+5JWltJRF/sf4kr9puY2x8GAiqKpeA/BKWaUo+3GpYZuHcYou
         vZtjILjHtN8ng==
Date:   Thu, 13 Jan 2022 20:17:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ryan Lahfa <ryan@lahfa.xyz>
Cc:     netdev@vger.kernel.org, Hayes Wang <hayeswang@realtek.com>,
        Andreas Seiderer <x64multicore@googlemail.com>,
        linux-usb@vger.kernel.org
Subject: Re: RTL8156(A|B) chip requires r8156 to be force loaded to operate
Message-ID: <20220113201720.3aa6cb0f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20211230000338.6q6zlj7ibvuz7yqt@Thors>
References: <20211224203018.z2n7sylht47ownga@Thors>
        <20211227182124.5cbc0d07@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20211230000338.6q6zlj7ibvuz7yqt@Thors>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Dec 2021 01:03:38 +0100 Ryan Lahfa wrote:
> On Mon, Dec 27, 2021 at 06:21:24PM -0800, Jakub Kicinski wrote:
> > On Fri, 24 Dec 2021 21:30:18 +0100 Ryan Lahfa wrote: =20
> > > The network card is loaded with `cdc_ncm` driver and is unable to det=
ect
> > > any carrier even when one is actually plugged in, I tried multiple
> > > things, I confirmed independently that the carrier is working.
> > >=20
> > > Through further investigations and with the help of a user on
> > > Libera.Chat #networking channel, we blacklisted `cdc_ncm`, but nothing
> > > get loaded in turn.
> > >=20
> > > Then, I forced the usage of r8152 for the device 0bda:8156 using `echo
> > > 0bda 8156 > /sys/bus/usb/drivers/r8152/new_id`, and... miracle.
> > > Everything just worked.
> > >=20
> > > I am uncertain whether this falls in kernel's responsibility or not, =
it
> > > seems indeed that my device is listed for r8152: https://github.com/t=
orvalds/linux/blob/master/drivers/net/usb/r8152.c#L9790 introduced by this =
commit https://github.com/torvalds/linux/commit/195aae321c829dd1945900d7556=
1e6aa79cce208 if I understand well, which is tagged for 5.15.
> > >=20
> > > I am curious to see how difficult would that be to write a patch for
> > > this and fix it, meanwhile, here is my modest contribution with this =
bug
> > > report, hopefully, this is the right place for them. =20
> >=20
> > Can you please share the output of lsusb -d '0bda:8156' -vv ? =20
>=20
> Here it is, attached.

Dunno much about USB but it seems the driver matches:

	USB_DEVICE_INTERFACE_CLASS(vend, prod, USB_CLASS_VENDOR_SPEC), \

and

	USB_DEVICE_AND_INTERFACE_INFO(vend, prod, USB_CLASS_COMM, \
			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE), \

Both of these should match. Former because:

Bus 002 Device 002: ID 0bda:8156 Realtek Semiconductor Corp. USB=20
10/100/1G/2.5G LAN
[...]
 =C2=A0=C2=A0=C2=A0 Interface Descriptor:
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bLength=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 9
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bDescriptorType=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 4
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bInterfaceNumber=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 0
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bAlternateSetting=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 0
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bNumEndpoints=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 3
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bInterfaceClass=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 255 Vendor Specific Class
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bInterfaceSubClass=C2=A0=C2=A0=C2=A0 255 Ve=
ndor Specific Subclass

And the latter because of another config with:

 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bInterfaceClass=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 2 Communications
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bInterfaceSubClass=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 6 Ethernet Networking
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bInterfaceProtocol=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 0


Let's CC linux-usb@ - any ideas?
