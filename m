Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 615CF3B2470
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 03:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbhFXBUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 21:20:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52714 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229758AbhFXBUL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 21:20:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=PdTZfjbDLW3Cs289v9r6/DX24+QzrM8LQPMtC/3ieo8=; b=i8
        hjm9V7PNk1vC2AXCq0+MfwTJgsDnzL0+p3Syo7Jyn3rCr5w2brgW9PDy64weIrAQB2tbsJBX2NqOP
        6aqL+6YO+jF4R8KkyJK3+FrMbJVBpYqssT48M9RTCjeSlV12lnQmYLMdUy8eYhweg3NVNvTBOATnj
        IPmLhky/gkxjtwk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lwE06-00AuuW-Iq; Thu, 24 Jun 2021 03:17:50 +0200
Date:   Thu, 24 Jun 2021 03:17:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Grzegorz Bernacki <gjb@semihalf.com>, upstream@semihalf.com,
        Samer El-Haj-Mahmoud <Samer.El-Haj-Mahmoud@arm.com>,
        Jon Nettleton <jon@solid-run.com>,
        Tomasz Nowicki <tn@semihalf.com>, rjw@rjwysocki.net,
        lenb@kernel.org
Subject: Re: [net-next: PATCH v3 5/6] net: mvpp2: enable using phylink with
 ACPI
Message-ID: <YNPdPlYV5qwnJBdW@lunn.ch>
References: <20210621173028.3541424-1-mw@semihalf.com>
 <20210621173028.3541424-6-mw@semihalf.com>
 <YNObfrJN0Qk5RO+x@lunn.ch>
 <CAPv3WKfdCwq=AYhARGxfRA92XcZjXYwdOj6_JLP+wOmPV8xxzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPv3WKfdCwq=AYhARGxfRA92XcZjXYwdOj6_JLP+wOmPV8xxzQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 23, 2021 at 11:45:04PM +0200, Marcin Wojtas wrote:
> Hi,
> 
> śr., 23 cze 2021 o 22:37 Andrew Lunn <andrew@lunn.ch> napisał(a):
> >
> > > +static bool mvpp2_use_acpi_compat_mode(struct fwnode_handle *port_fwnode)
> > > +{
> > > +     if (!is_acpi_node(port_fwnode))
> > > +             return false;
> > > +
> > > +     return (!fwnode_property_present(port_fwnode, "phy-handle") &&
> > > +             !fwnode_property_present(port_fwnode, "managed") &&
> > > +             !fwnode_get_named_child_node(port_fwnode, "fixed-link"));
> >
> > I'm not too sure about this last one. You only use fixed-link when
> > connecting to an Ethernet switch. I doubt anybody will try ACPI and a
> > switch. It has been agreed, ACPI is for simple hardware, and you need
> > to use DT for advanced hardware configurations.
> >
> > What is your use case for fixed-link?
> >
> 
> Regardless of the "simple hardware" definition or whether DSA + ACPI
> feasibility, you can still have e.g. the switch left in "unmanaged"
> mode (or whatever the firmware configures), connected via fixed-link
> to the MAC. The same effect as booting with DT, but not loading the
> DSA/switch driver - the "CPU port" can be used as a normal netdev
> interface.

You can do this, but i would not recommend it. Without having STP,
your network is going to be vulnerable to broadcast storms killing
your network.

> I'd also prefer to have all 3 major interface types supported in
> phylink, explicitly checked in the driver - it has not been supported
> yet, but can be in the future, so let's have them covered in the
> backward compatibility check.

Maybe i'm not understanding this correctly, but isn't this condition
enforcing there must be a fixed link in order to use the new ACPI
binding? But i expect most boards never need a fixed-link, it is
optional after all.

	 Andrew
