Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 845771FF5C2
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 16:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbgFROxJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 18 Jun 2020 10:53:09 -0400
Received: from SMTP01.itecon.de ([80.242.182.181]:27897 "EHLO
        webmail.first-class-email.de" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725982AbgFROxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 10:53:07 -0400
Received: from S11085.first-class-email.de (10.1.80.101) by
 S10006.first-class-email.de (192.168.2.156) with Microsoft SMTP Server (TLS)
 id 8.3.485.1; Thu, 18 Jun 2020 12:08:28 +0200
Received: from pm-tm-ubuntu (77.179.155.119) by webmail.first-class-email.de
 (10.1.80.101) with Microsoft SMTP Server (TLS) id 14.3.487.0; Thu, 18 Jun
 2020 12:08:27 +0200
Date:   Thu, 18 Jun 2020 12:08:26 +0200
From:   Tanjeff-Nicolai Moos <tmoos@eltec.de>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Dan Williams <dcbw@redhat.com>, <netdev@vger.kernel.org>
Subject: Re: qmi_wwan not using netif_carrier_*()
Message-ID: <20200618120826.3d271e67@pm-tm-ubuntu>
In-Reply-To: <20200617172434.GH205574@lunn.ch>
References: <20200617152153.2e66ccaf@pm-tm-ubuntu>
        <20200617164800.GG205574@lunn.ch>
        <1f5ecd2a1138dd39893b8d2b9e608067468de891.camel@redhat.com>
        <20200617172434.GH205574@lunn.ch>
Organization: ELTEC
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [77.179.155.119]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Wed, 17 Jun 2020 19:24:34 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> On Wed, Jun 17, 2020 at 11:59:33AM -0500, Dan Williams wrote:
> > On Wed, 2020-06-17 at 18:48 +0200, Andrew Lunn wrote:
> > > On Wed, Jun 17, 2020 at 03:21:53PM +0200, Tanjeff-Nicolai Moos wrote:
> > > > Hi netdevs,
> > > >
> > > > Kernel version:
> > > >
> > > >   I'm working with kernel 4.14.137 (OpenWRT project). But I looked
> > > > at
> > > >   the source of kernel 5.7 and found the same situation.
> > > >
> > > > Problem:
> > > >
> > > >   I'm using the qmi_wwan driver for a Sierra Wireless EM7455 LTE
> > > >   modem. This driver does not use
> > > >   netif_carrier_on()/netif_carrier_off() to update its link status.
> > > >   This confuses ledtrig_netdev which uses netif_carrier_ok() to
> > > > obtain
> > > >   the link status.
> > > >
> > > > My solution:
> > > >
> > > >   As a solution (or workaround?) I would try:
> > > >
> > > >   1) In drivers/net/usb/qmi_wwan.c, lines 904/913: Add the flag
> > > >      FLAG_LINK_INTR.
> > > >
> > > >   2) In drivers/net/usb/usbnet.c, functions usbnet_open() and
> > > >      usbnet_stop(): Add a call to netif_carrier_*(),
> > > >      but only if FLAG_LINK_INTR is set.
> > > >
> > > > Question:
> > > >
> > > >   Is this the intended way to use FLAG_LINK_INTR and
> > > > netif_carrier_*()?
> > > >   Or is there another recommended way to obtain the link status of
> > > >   network devices (I could change ledtrig_netdev)?
> > >
> > > Hi Tanjeff
> > >
> > > With Ethernet, having a carrier means there is a link partner, the
> > > layer 2 of the OSI 7 layer stack model is working. If the interface
> > > is
> > > not open()ed, it clearly should not have carrier. However, just
> > > because it is open, does not mean it has carrier. The cable could be
> > > unplugged, etc.
> > >
> > > This is an LTE modem. What does carrier mean here? I don't know if it
> > > is well defined, but i would guess it is connected to a base station
> > > which is offering service. I'm assuming you are interested in data
> > > here, not wanting to make a 911/999/112/$EMERGENCY_SERVICE call which
> > > in theory all base stations should accept.
> > >
> > > Is there a way to get this state information from the hardware? That
> > > would be the correct way to set the carrier.
> >
> > There isn't. All the setup that would result in IFF_LOWER_UP (eg
> > ability to pass packets to the cellular network) happens over channels
> > *other* than the ethernet one. eg CDC-WDM, CDC-ACM, CDC-MBIM, AT
> > commands, QMI commands, MBIM commands, etc.
> >
> > Something in userspace handles the actual IP-level connection setup and
> > once that's done, only then do you really have IFF_LOWER_UP. One way to
> > solve this could be to require userspace connection managers to manage
> > the carrier state of the device, which is possible for some drivers
> > already IIRC.
>
> So Tanjeff, what is you real use case here? I assume you want to
> control an LED so it is on when the LTE modem is connected? Could you
> export the LED to user space and have a dhclient-enter/exit script change
> the state of the LED?
The LED should show whether the link is up (data transfer is possible),
and it should blink when data is being transferred. This functionality
is provided by the ledtrig_netdev driver. The blinking works already,
but the indicated link state is wrong, because the netif_carrier_ok()
function /always/ reports true.

When I control the LED by userspace software, it would probably not
blink during xfer. Therefore I would prefer to stick with
ledtrig_netdev (also, it will give me the same behavior as for WLAN,
where I also use ledtrig_netdev).

I observed that sierra.c does call netif_carrier_off(). Since I'm using
a Sierra modem, maybe I'm actually using this driver (sorry for my
limited knowledge), and things should already work? Then I would have
some misconfiguration...

I also observed that "ip address" shows the flags "UP" and "LOWER_UP"
when the interface is up. The kernel seems to know whether "the link"
is up, although I don't know which link is considered. Maybe it is
possible to get that knowledge from within qmi_wwan or usbnet and to
set the carrier accordingly.

Kind regards, tanjeff


--

Tanjeff-Nicolai Moos
Dipl.-Inf. (FH)
Senior Software Engineer

ELTEC Elektronik AG, Mainz
_________________________

Fon     +49 6131 918 342
Fax     +49 6131 918 195
Email   tmoos@eltec.de
Web     www.eltec.de

________________________________


*********************************************************
ELTEC Elektronik AG
Galileo-Galilei-Straße 11
D-55129 Mainz

Vorstand: Peter Albert
Aufsichtsratsvorsitzender: Andreas Kochhäuser

Registergericht: Amtsgericht Mainz
Registernummer: HRB 7038
Ust-ID: DE 149 049 790
*********************************************************
Wichtiger Hinweis:
Diese E-Mail kann Betriebs- oder Geschäftsgeheimnisse oder sonstige vertrauliche Informationen enthalten. Sollten Sie diese E-Mail irrtümlich erhalten haben, ist Ihnen eine Kenntnisnahme des Inhalts, eine Vervielfältigung oder Weitergabe der E-Mail ausdrücklich untersagt.
Bitte benachrichtigen Sie uns und vernichten Sie die empfangene E-Mail. Evtl. Anhänge dieser Nachricht wurden auf Viren überprüft!
Jede Form von Vervielfältigung, Abänderung, Verbreitung oder Veröffentlichung dieser E-Mail Nachricht ist untersagt! Das Verwenden von Informationen aus dieser Nachricht für irgendwelche Zwecke ist strengstens untersagt.
Es gelten unsere Allgemeinen Geschäftsbedingungen, zu finden unter www.eltec.de.
