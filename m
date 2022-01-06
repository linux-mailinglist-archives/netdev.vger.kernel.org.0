Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D984A486546
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 14:28:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239562AbiAFN2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 08:28:03 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:54438 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230323AbiAFN2D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 08:28:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Dc13GhzV7GMpFHXLCvgCedftWg7T/tGeHO9kPVdise8=; b=naWyluOJhBleVVZMCq3CJ3uvEk
        GkFmtvQdmb2RyZPhH1q4YsoRZbcasi2b1ojlATohPQHSvnYRALJGJpS79zr6FuD15LJGB7ElQTz1M
        PXanW1Pbc0zm0RDnzRV1+b0VUL4LbiI3El0+2C2O6LsU30KDWQElrZWgUJLy0o/O58GU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n5So9-000eji-G1; Thu, 06 Jan 2022 14:27:57 +0100
Date:   Thu, 6 Jan 2022 14:27:57 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     Oliver Neukum <oneukum@suse.com>,
        Aaron Ma <aaron.ma@canonical.com>, kuba@kernel.org,
        henning.schild@siemens.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, hayeswang@realtek.com, tiwai@suse.de
Subject: Re: [PATCH 1/3 v3] net: usb: r8152: Check used MAC passthrough
 address
Message-ID: <YdbuXbtc64+Knbhm@lunn.ch>
References: <20220105151427.8373-1-aaron.ma@canonical.com>
 <YdXVoNFB/Asq6bc/@lunn.ch>
 <bb6d8bc4-abee-8536-ca5b-bac11d1ecd53@suse.com>
 <YdYbZne6pBZzxSxA@lunn.ch>
 <CAAd53p52uGFjbiuOWAA-1dN7mTqQ0KFe9PxWvPL+fjfQb9K5vQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAd53p52uGFjbiuOWAA-1dN7mTqQ0KFe9PxWvPL+fjfQb9K5vQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Can udev in current form really handle the MAC race? Unless there's a
> new uevent right before ndo_open() so udev can decide which MAC to
> assign? Even with that, the race can still happen...

There will always be a race, since the kernel can start using the
interface before register_netdev() has even finished, before user
space is running. Take a look at how NFS root works.

But in general, you can change the MAC address at any time. Some MAC
drivers will return -EBUSY if the interface is up, but that is
generally artificial. After a change of MAC address ARP will time out
after a while and the link peers will get the new MAC address.

> 
> So what if we keep the existing behavior (i.e. copy MAC from ACPI),
> and let userspace daemon like NetworkManager to give the second NIC
> (r8152 in this case) a random MAC if the main NIC (I219 in this case)
> is already in use? Considering the userspace daemon has the all the
> information required and it's the policy maker here.

You should be thinking of this in more general terms. You want to
design a system that will work for any vendors laptop and dock.

You need to describe the two interfaces using some sort of bus
address, be it PCIe, USB, or a platform device address as used by
device tree etc.

Let the kernel do whatever it wants with MAC addresses for these two
interfaces. The only requirement you have is that the laptop internal
interface gets the vendor allocated MAC address, and that the dock get
some sort of MAC address, even if it is random.

On device creation, udev can check if it now has both interfaces? If
the internal interface is up, it is probably in use. Otherwise, take
its MAC address and assign it to the dock interface, and give the
internal interface a random MAC address, just in case.

You probably need to delay NetworkManager, systemd-networkkd,
/etc/network/interfaces etc, so that they don't do anything until
after udevd has settled, indicating all devices have probably been
found.

I suspect you will never get a 100% robust design, but you can
probably get it working enough for the cleaning staff and the CEO, who
have very simple setups. Power users are going to find all the corner
cases and will want to disable the udev rule.

     Andrew
