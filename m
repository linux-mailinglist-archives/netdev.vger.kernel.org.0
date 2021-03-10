Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 601B5333F7B
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 14:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232842AbhCJNmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 08:42:53 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:49630 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232712AbhCJNmv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 08:42:51 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lJz6v-00ABhO-FY; Wed, 10 Mar 2021 14:42:49 +0100
Date:   Wed, 10 Mar 2021 14:42:49 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Wyse, Chris" <cwyse@canoga.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "drichards@impinj.com" <drichards@impinj.com>
Subject: Re: DSA
Message-ID: <YEjM2T8rI05F/Fbr@lunn.ch>
References: <MWHPR06MB3503CE521D6993C7786A3E93DC8D0@MWHPR06MB3503.namprd06.prod.outlook.com>
 <20180430125030.GB10066@lunn.ch>
 <bf9115d87b65766dab2d5671eceb1764d0d8dc0c.camel@canoga.com>
 <YEemYTQ9EhQQ9jyH@lunn.ch>
 <20fd4a9ce09117e765dbf63f1baa9da5c834a64b.camel@canoga.com>
 <YEf8dFUCB+/vMkU8@lunn.ch>
 <9d866ab9d2f324f34804b3c74e350138d5413706.camel@canoga.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d866ab9d2f324f34804b3c74e350138d5413706.camel@canoga.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The current boot sequence is below:
> 1. i210 driver loads
> 2. Device Tree overlay installed (in addition to ACPI)
>    - Includes DSA switch and ports, but master port was incorrectly
> specified as the EMACLite IP module, which had a DT node
>    - No DT node for the i210
> 3. MFD driver reads DT overlay and instantiates supporting devices and
> the DSA driver
> 
> My thought was to create a DT entry for the i210 in the overlay, even
> though the driver is already loaded via ACPI.  The DT overlay node for
> the i210 would provide any needed information to the DSA driver.  It
> would be essentially a reference to the already loaded driver.

I don't think what works. The normal sequence is that the PCI bus is
probed and devices found. At that point in time, the PCI core looks in
DT and finds the DT node associated with the device, and assigns
dev->of_node to point to the DT node. The device is then registered
with the device core. It will go off and try to find a driver of the
device, probe it, etc.

Sometime later, the DSA driver will probe. The phandle in device tree
is turned into a pointer. And then all devices registered for the
netdev class are walked to see if any have dev->of_node set to the
node.

So for this sequence to work, the overload needs to be loaded at the
point the PCI bus is scanned for devices. Now, there could be some
magic going on when an overlay is loaded, scanning the DT for devices
which have already loaded, and assigning there dev->of_node? I've no
idea, i've not used overlays. You probably want to add some printk()
into pci_set_of_node().

The idea with hotplug is that i guess it should rescan the PCI bus. So
that should cause pci_set_of_node() to be called, and now there is a
DT node for the device.

So i suggest you scatter some printk() in the PCI code, and
of_find_net_device_by_node() and the functions it calls to see what is
really going on, do i have the sequencing correct.

       Andrew
