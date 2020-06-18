Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9EA1FFCED
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 22:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728588AbgFRUtz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 16:49:55 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:34313 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728196AbgFRUtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 16:49:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592513391;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H4QaT2rCikmYcDoi3NfvZ3bj2jjx6iC0ZbXMLOdIUDk=;
        b=bjVUYk9HW7satX/KOPM8GZFm2dj7CGqwjNQi2arJIfbCptFZ6g1q4YyWKUpsilkoEMoDCk
        Ms+GWturLxJ01+lhWBtkVIQ4WEJtdi4hYGCU7LFcCvH4MKNiulADY2O+5cbjijpPB4Jya5
        I4QAwZHZh0hGy0yF9sdcVKy+AezDTyk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-302-yXUE9CyvOguN8fA1ryxXHw-1; Thu, 18 Jun 2020 16:49:46 -0400
X-MC-Unique: yXUE9CyvOguN8fA1ryxXHw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4E134107ACCA;
        Thu, 18 Jun 2020 20:49:45 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.3.128.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 90FA060CD0;
        Thu, 18 Jun 2020 20:49:44 +0000 (UTC)
Message-ID: <ce29a52cabf10cdb8922eb816ebd92b57c869be4.camel@redhat.com>
Subject: Re: qmi_wwan not using netif_carrier_*()
From:   Dan Williams <dcbw@redhat.com>
To:     Tanjeff-Nicolai Moos <tmoos@eltec.de>, Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
Date:   Thu, 18 Jun 2020 15:49:43 -0500
In-Reply-To: <20200618120826.3d271e67@pm-tm-ubuntu>
References: <20200617152153.2e66ccaf@pm-tm-ubuntu>
         <20200617164800.GG205574@lunn.ch>
         <1f5ecd2a1138dd39893b8d2b9e608067468de891.camel@redhat.com>
         <20200617172434.GH205574@lunn.ch> <20200618120826.3d271e67@pm-tm-ubuntu>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-06-18 at 12:08 +0200, Tanjeff-Nicolai Moos wrote:
> 
> On Wed, 17 Jun 2020 19:24:34 +0200
> Andrew Lunn <andrew@lunn.ch> wrote:
> 
> > On Wed, Jun 17, 2020 at 11:59:33AM -0500, Dan Williams wrote:
> > > On Wed, 2020-06-17 at 18:48 +0200, Andrew Lunn wrote:
> > > > On Wed, Jun 17, 2020 at 03:21:53PM +0200, Tanjeff-Nicolai Moos
> > > > wrote:
> > > > > Hi netdevs,
> > > > > 
> > > > > Kernel version:
> > > > > 
> > > > >   I'm working with kernel 4.14.137 (OpenWRT project). But I
> > > > > looked
> > > > > at
> > > > >   the source of kernel 5.7 and found the same situation.
> > > > > 
> > > > > Problem:
> > > > > 
> > > > >   I'm using the qmi_wwan driver for a Sierra Wireless EM7455
> > > > > LTE
> > > > >   modem. This driver does not use
> > > > >   netif_carrier_on()/netif_carrier_off() to update its link
> > > > > status.
> > > > >   This confuses ledtrig_netdev which uses netif_carrier_ok()
> > > > > to
> > > > > obtain
> > > > >   the link status.
> > > > > 
> > > > > My solution:
> > > > > 
> > > > >   As a solution (or workaround?) I would try:
> > > > > 
> > > > >   1) In drivers/net/usb/qmi_wwan.c, lines 904/913: Add the
> > > > > flag
> > > > >      FLAG_LINK_INTR.
> > > > > 
> > > > >   2) In drivers/net/usb/usbnet.c, functions usbnet_open() and
> > > > >      usbnet_stop(): Add a call to netif_carrier_*(),
> > > > >      but only if FLAG_LINK_INTR is set.
> > > > > 
> > > > > Question:
> > > > > 
> > > > >   Is this the intended way to use FLAG_LINK_INTR and
> > > > > netif_carrier_*()?
> > > > >   Or is there another recommended way to obtain the link
> > > > > status of
> > > > >   network devices (I could change ledtrig_netdev)?
> > > > 
> > > > Hi Tanjeff
> > > > 
> > > > With Ethernet, having a carrier means there is a link partner,
> > > > the
> > > > layer 2 of the OSI 7 layer stack model is working. If the
> > > > interface
> > > > is
> > > > not open()ed, it clearly should not have carrier. However, just
> > > > because it is open, does not mean it has carrier. The cable
> > > > could be
> > > > unplugged, etc.
> > > > 
> > > > This is an LTE modem. What does carrier mean here? I don't know
> > > > if it
> > > > is well defined, but i would guess it is connected to a base
> > > > station
> > > > which is offering service. I'm assuming you are interested in
> > > > data
> > > > here, not wanting to make a 911/999/112/$EMERGENCY_SERVICE call
> > > > which
> > > > in theory all base stations should accept.
> > > > 
> > > > Is there a way to get this state information from the hardware?
> > > > That
> > > > would be the correct way to set the carrier.
> > > 
> > > There isn't. All the setup that would result in IFF_LOWER_UP (eg
> > > ability to pass packets to the cellular network) happens over
> > > channels
> > > *other* than the ethernet one. eg CDC-WDM, CDC-ACM, CDC-MBIM, AT
> > > commands, QMI commands, MBIM commands, etc.
> > > 
> > > Something in userspace handles the actual IP-level connection
> > > setup and
> > > once that's done, only then do you really have IFF_LOWER_UP. One
> > > way to
> > > solve this could be to require userspace connection managers to
> > > manage
> > > the carrier state of the device, which is possible for some
> > > drivers
> > > already IIRC.
> > 
> > So Tanjeff, what is you real use case here? I assume you want to
> > control an LED so it is on when the LTE modem is connected? Could
> > you
> > export the LED to user space and have a dhclient-enter/exit script
> > change
> > the state of the LED?
> The LED should show whether the link is up (data transfer is
> possible),
> and it should blink when data is being transferred. This
> functionality
> is provided by the ledtrig_netdev driver. The blinking works already,
> but the indicated link state is wrong, because the netif_carrier_ok()
> function /always/ reports true.
> 
> When I control the LED by userspace software, it would probably not
> blink during xfer. Therefore I would prefer to stick with
> ledtrig_netdev (also, it will give me the same behavior as for WLAN,
> where I also use ledtrig_netdev).
> 
> I observed that sierra.c does call netif_carrier_off(). Since I'm
> using
> a Sierra modem, maybe I'm actually using this driver (sorry for my
> limited knowledge), and things should already work? Then I would have
> some misconfiguration...

The Sierra driver is only for their very old (2000s and early 2010s)
devices that use DirectIP mode. It's very unlikely you're using it.

I don't think you're going to get qmi_wwan to set the carrier state
like you expect. That would require qmi_wwan to snoop on the QMI
control messages passed back and forth from the modem to userspace, and
have some knowledge of the data sessions. That's not something qmi_wwan
should be doing.

Instead, you can have a script that looks for an IP address assigned to
the interface and if so, check its packet counters and if they change,
blink the LED. Doesn't need to be done from kernel space.
Dan

> I also observed that "ip address" shows the flags "UP" and "LOWER_UP"
> when the interface is up. The kernel seems to know whether "the link"
> is up, although I don't know which link is considered. Maybe it is
> possible to get that knowledge from within qmi_wwan or usbnet and to
> set the carrier accordingly.
> 
> Kind regards, tanjeff
> 
> 
> --
> 
> Tanjeff-Nicolai Moos
> Dipl.-Inf. (FH)
> Senior Software Engineer
> 
> ELTEC Elektronik AG, Mainz
> _________________________
> 
> Fon     +49 6131 918 342
> Fax     +49 6131 918 195
> Email   tmoos@eltec.de
> Web     www.eltec.de
> 
> ________________________________
> 
> 
> *********************************************************
> ELTEC Elektronik AG
> Galileo-Galilei-Straße 11
> D-55129 Mainz
> 
> Vorstand: Peter Albert
> Aufsichtsratsvorsitzender: Andreas Kochhäuser
> 
> Registergericht: Amtsgericht Mainz
> Registernummer: HRB 7038
> Ust-ID: DE 149 049 790
> *********************************************************
> Wichtiger Hinweis:
> Diese E-Mail kann Betriebs- oder Geschäftsgeheimnisse oder sonstige
> vertrauliche Informationen enthalten. Sollten Sie diese E-Mail
> irrtümlich erhalten haben, ist Ihnen eine Kenntnisnahme des Inhalts,
> eine Vervielfältigung oder Weitergabe der E-Mail ausdrücklich
> untersagt.
> Bitte benachrichtigen Sie uns und vernichten Sie die empfangene E-
> Mail. Evtl. Anhänge dieser Nachricht wurden auf Viren überprüft!
> Jede Form von Vervielfältigung, Abänderung, Verbreitung oder
> Veröffentlichung dieser E-Mail Nachricht ist untersagt! Das Verwenden
> von Informationen aus dieser Nachricht für irgendwelche Zwecke ist
> strengstens untersagt.
> Es gelten unsere Allgemeinen Geschäftsbedingungen, zu finden unter 
> www.eltec.de.
> 

