Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00F8B55741B
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 09:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbiFWHl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 03:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbiFWHlz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 03:41:55 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED57346677;
        Thu, 23 Jun 2022 00:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=+R/xhEucoyrrWHquY5Y6qcKmIfXy3pTHFtwvFEcWWgY=; b=cIYPzQly7i6A0laU0PeL+cCUVj
        8VjqJnSAjP/XMl2ei8giBxNJe7lC1GOlVnpuF9bDnvgfn9mpvoMk15xz+UYixAGpPxSXTaScfeP0b
        WG9C/YsZy7TMQk6QP8IPUrPl+KgX6+dWb5Hv9IIxIbbBP4w29VArqtaxuithK8YUpLLs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o4HTF-007wTu-Vv; Thu, 23 Jun 2022 09:41:45 +0200
Date:   Thu, 23 Jun 2022 09:41:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Len Brown <lenb@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Grzegorz Bernacki <gjb@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Samer El-Haj-Mahmoud <Samer.El-Haj-Mahmoud@arm.com>,
        upstream@semihalf.com
Subject: Re: [net-next: PATCH 08/12] ACPI: scan: prevent double enumeration
 of MDIO bus children
Message-ID: <YrQZOX4n0ZuTSANP@lunn.ch>
References: <20220620150225.1307946-1-mw@semihalf.com>
 <20220620150225.1307946-9-mw@semihalf.com>
 <YrDFmw4rziGQJCAu@lunn.ch>
 <CAJZ5v0g4q8N5wMgk7pRYpYoCLPQoH==Z+nrM0JLyFXSgF9y0+Q@mail.gmail.com>
 <54618c2a-e1f3-bbd0-8fb2-1669366a3b59@gmail.com>
 <CAJZ5v0j3A-VYFgcnziSqejp-qJVbrbyFP40S-m9eYTv=H9J0ow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJZ5v0j3A-VYFgcnziSqejp-qJVbrbyFP40S-m9eYTv=H9J0ow@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> And when the ACPI subsystem finds those device objects present in the
> ACPI tables, the mdio_device things have not been created yet and it
> doesn't know which ACPI device object will correspond to mdio_device
> eventually unless it is told about that somehow.  One way of doing
> that is to use a list of device IDs in the kernel.  The other is to
> have the firmware tell it about that which is what we are discussing.

Device IDs is a complex subject with MDIO devices. It has somewhat
evolved over time, and it could also be that ACPI decides to do
something different, or simpler, to what DT does.

If the device is an Ethernet PHY, and it follows C22, it has two
registers in a well defined location, which when combined give you a
vendor model and version. So we scan the bus, look at each address on
the bus, try to read these registers and if we don't get 0xffff back,
we assume it is a PHY, create an mdio_device, sub type it to
phy_device, and then load and probe the driver based on the ID
registers.

If the device is using C45, we currently will not be able to enumerate
it this way. We have a number of MDIO bus drivers which don't
implement C45, but also don't return -EOPNOTSUPP. They will perform a
malformed C22 transaction, or go wrong in some other horrible way. So
in DT, we have a compatible string to indicate there is a C45 devices
at the address. We then do look around in the C45 address space at the
different locations where the ID registers can be, and if we get a
valid looking ID, probe the driver using that.

We also have some chicken/egg problems. Some PHYs won't respond when
you read there ID registers until you have turned on clocks, disabled
reset lines, enable regulators etc. For these devices, we place the ID
as you would read from the ID registers in DT as the compatible
string. The mdio_device is created, sub-types as a PHY and the probe
happens using the ID register found in DT. The driver can then do what
it needs to do to get the device to respond on the bus.

Then we have devices on the bus which are not PHYs, but generic
mdio_devices. These are mostly Ethernet switches, but Broadcom have
some other MDIO devices which are not switches. For these, we have
compatible strings which identifies the device as a normal string,
which then probes the correct driver in the normal way for a
compatible string.

So giving the kernel a list of device IDs is not simple. I expect
dealing with this will be a big part of defining how MDIOSerialBus
works.

   Andrew





