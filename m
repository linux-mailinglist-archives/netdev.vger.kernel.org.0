Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 029781FD3F2
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 20:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbgFQSBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 14:01:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44435 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726857AbgFQSBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 14:01:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592416901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ni7wqX9WIoGmTFzMUYiQ5ccbMYhJT1baFhAQiv8e10c=;
        b=bJTLMnnHb2Wfk54wovBT2y3ycZJVkgq+lwUo5t7suTml9seHW9Har0GJFnCMwRehWOi6Go
        ZmDucXnTs4+ILT6gp4i19rFjq35ZBr2UqaSWiRHi9qH/ORvqF4kOGzZsGQQp4t7X4PuYLS
        uoONT+/RXPncDhQplpuYFfr5mQrnY8w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-cRK8Kq9wPDaXoYskqTMVnw-1; Wed, 17 Jun 2020 14:01:40 -0400
X-MC-Unique: cRK8Kq9wPDaXoYskqTMVnw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CE368BFCD;
        Wed, 17 Jun 2020 18:01:04 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.3.128.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DAE411001901;
        Wed, 17 Jun 2020 18:01:03 +0000 (UTC)
Message-ID: <0b8291b51ccbeee0337b48fa31868a8b37a69590.camel@redhat.com>
Subject: Re: qmi_wwan not using netif_carrier_*()
From:   Dan Williams <dcbw@redhat.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Tanjeff-Nicolai Moos <tmoos@eltec.de>, netdev@vger.kernel.org
Date:   Wed, 17 Jun 2020 13:01:02 -0500
In-Reply-To: <20200617172434.GH205574@lunn.ch>
References: <20200617152153.2e66ccaf@pm-tm-ubuntu>
         <20200617164800.GG205574@lunn.ch>
         <1f5ecd2a1138dd39893b8d2b9e608067468de891.camel@redhat.com>
         <20200617172434.GH205574@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-06-17 at 19:24 +0200, Andrew Lunn wrote:
> On Wed, Jun 17, 2020 at 11:59:33AM -0500, Dan Williams wrote:
> > On Wed, 2020-06-17 at 18:48 +0200, Andrew Lunn wrote:
> > > On Wed, Jun 17, 2020 at 03:21:53PM +0200, Tanjeff-Nicolai Moos
> > > wrote:
> > > > Hi netdevs,
> > > > 
> > > > Kernel version:
> > > > 
> > > >   I'm working with kernel 4.14.137 (OpenWRT project). But I
> > > > looked
> > > > at
> > > >   the source of kernel 5.7 and found the same situation.
> > > > 
> > > > Problem:
> > > > 
> > > >   I'm using the qmi_wwan driver for a Sierra Wireless EM7455
> > > > LTE
> > > >   modem. This driver does not use
> > > >   netif_carrier_on()/netif_carrier_off() to update its link
> > > > status.
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
> > > >   Or is there another recommended way to obtain the link status
> > > > of
> > > >   network devices (I could change ledtrig_netdev)?
> > > 
> > > Hi Tanjeff
> > > 
> > > With Ethernet, having a carrier means there is a link partner,
> > > the
> > > layer 2 of the OSI 7 layer stack model is working. If the
> > > interface
> > > is
> > > not open()ed, it clearly should not have carrier. However, just
> > > because it is open, does not mean it has carrier. The cable could
> > > be
> > > unplugged, etc.
> > > 
> > > This is an LTE modem. What does carrier mean here? I don't know
> > > if it
> > > is well defined, but i would guess it is connected to a base
> > > station
> > > which is offering service. I'm assuming you are interested in
> > > data
> > > here, not wanting to make a 911/999/112/$EMERGENCY_SERVICE call
> > > which
> > > in theory all base stations should accept.
> > > 
> > > Is there a way to get this state information from the hardware?
> > > That
> > > would be the correct way to set the carrier.
> > 
> > There isn't. All the setup that would result in IFF_LOWER_UP (eg
> > ability to pass packets to the cellular network) happens over
> > channels
> > *other* than the ethernet one. eg CDC-WDM, CDC-ACM, CDC-MBIM, AT
> > commands, QMI commands, MBIM commands, etc.
> > 
> > Something in userspace handles the actual IP-level connection setup
> > and
> > once that's done, only then do you really have IFF_LOWER_UP. One
> > way to
> > solve this could be to require userspace connection managers to
> > manage
> > the carrier state of the device, which is possible for some drivers
> > already IIRC.
> 
> So Tanjeff, what is you real use case here? I assume you want to
> control an LED so it is on when the LTE modem is connected? Could you
> export the LED to user space and have a dhclient-enter/exit script
> change
> the state of the LED?

Most of these devices do not use DHCP either, but get the IP through
the control channel (QMI, MBIM, AT commands, etc).  I'd just watch for
an IP address on the interface instead.

Dan

