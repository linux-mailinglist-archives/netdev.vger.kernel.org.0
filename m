Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2823A4BF59D
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 11:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbiBVKVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 05:21:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiBVKVa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 05:21:30 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0231013EFB5;
        Tue, 22 Feb 2022 02:21:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 611A8CE1316;
        Tue, 22 Feb 2022 10:20:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AE0BC340E8;
        Tue, 22 Feb 2022 10:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645525257;
        bh=c+MUjJQQSEz6EcrkGQwWMDKOpd6pQpqW5YnvVC432Ls=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gpJBpDdcB+qqUdfAoLh6lZyh+2gHjF8UO4QG+ufHTaisPt7A3i6lr6jdsxBU6G3FT
         ECQwmhgctyORBzXN1ozJ/2+UXL8QwWyR0/m1yjtikrNtPmudn9JHg5BZUDdkRLZEgg
         AUWkcrwQ4hB4XVRNR8gJk0WIhw72vseVvXZqzVZQ=
Date:   Tue, 22 Feb 2022 11:20:54 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Wolfram Sang <wsa@kernel.org>, Peter Rosin <peda@axentia.se>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: Re: [RFC 02/10] property: add fwnode_get_match_data()
Message-ID: <YhS5BnvofimMReDE@kroah.com>
References: <20220221162652.103834-1-clement.leger@bootlin.com>
 <20220221162652.103834-3-clement.leger@bootlin.com>
 <YhPP5GWt7XEv5xx8@smile.fi.intel.com>
 <20220222091902.198ce809@fixe.home>
 <CAHp75VdwfhGKOiGhJ1JsiG+R2ZdHa3N4hz6tyy5BmyFLripV5A@mail.gmail.com>
 <20220222094623.1f7166c3@fixe.home>
 <CAHp75VfduXwRvxkNg=At5jaN-tcP3=utiukEDL35PEv_grK4Pw@mail.gmail.com>
 <20220222104705.54a73165@fixe.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220222104705.54a73165@fixe.home>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 10:47:05AM +0100, Clément Léger wrote:
> Le Tue, 22 Feb 2022 10:24:13 +0100,
> Andy Shevchenko <andy.shevchenko@gmail.com> a écrit :
> 
> > > > If you want to use the device on an ACPI based platform, you need to
> > > > describe it in ACPI as much as possible. The rest we may discuss.  
> > >
> > > Agreed but the PCIe card might also be plugged in a system using a
> > > device-tree description (ARM for instance). I should I do that without
> > > duplicating the description both in DT and ACPI ?  
> > 
> > Why is it (duplication) a problem?
> > Each platform has its own kind of description, so one needs to provide
> > it in the format the platform accepts.
> > 
> 
> The problem that I see is not only duplication but also that the PCIe
> card won't work out of the box and will need a specific SSDT overlays
> each time it is used. According to your document about SSDT overlays,
> there is no way to load this from the driver. This means that the user
> will have to compile a platform specific .aml file to match its
> platform configuration. If the user wants to change the PCIe port, than
> I guess it will have to load another .aml file. I do not think a user
> expect to do so when plugging a PCIe card.
> 
> Moreover, the APCI documentation [1] says the following:
> 
> "PCI devices, which are below the host bridge, generally do not need to
> be described via ACPI. The OS can discover them via the standard PCI
> enumeration mechanism, using config accesses to discover and identify
> devices and read and size their BARs. However, ACPI may describe PCI
> devices if it provides power management or hotplug functionality for
> them or if the device has INTx interrupts connected by platform
> interrupt controllers and a _PRT is needed to describe those
> connections."
> 
> The device I want to use (a PCIe switch) does not fall into these
> categories so there should be no need to describe it using ACPI.

There should not be any need to describe it in any way, the device
should provide all of the needed information.  PCIe devices do not need
a DT entry, as that does not make sense.

thanks,

greg k-h
