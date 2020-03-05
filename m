Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1ED17B1E8
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 23:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbgCEWvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 17:51:17 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48348 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726162AbgCEWvQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 17:51:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3qWd/FDg2QYtcJ3hWrTP3iBZQ0Q7uGWqD6GFoseHOEo=; b=XPY1wvSZoVYfAgjNYMoY7uy+vA
        ktE/GuyM+THP9OC86YLMGjOlFRNIuGIqTgj8T3D27Kfy+VLyHc+bnpIpvfry5wY/0ymQfQOwEgtTe
        dIJbALSA8eun+nqdYGcBWyJa5YqEBYjJ3SixX9Brl6/wuL66m5XbcfOl3h8uC/8K8Src=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j9zKl-0000P2-A2; Thu, 05 Mar 2020 23:51:15 +0100
Date:   Thu, 5 Mar 2020 23:51:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sriram Chadalavada <sriram.chadalavada@mindleap.ca>
Cc:     netdev@vger.kernel.org
Subject: Re: Information on DSA driver initialization
Message-ID: <20200305225115.GC25183@lunn.ch>
References: <CAOK2joFxzSETFgHX7dRuhWPVSSEYswJ+-xfSxbPr5n3LcsMHzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOK2joFxzSETFgHX7dRuhWPVSSEYswJ+-xfSxbPr5n3LcsMHzw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 05, 2020 at 05:24:47PM -0500, Sriram Chadalavada wrote:
> Is there information in kernel documentation or elsewhere about DSA
> initialization process starting from the device tree parse to the
> Marvell switch being detected?
> 
> The specific problem I'm facing is that while I see this:
> root@SDhub:/# dmesg | grep igb
> [ 1.314324] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.4.0-k
> [ 1.314332] igb: Copyright (c) 2007-2014 Intel Corporation.
> [ 1.314679] igb 0000:03:00.0: enabling device (0140 -> 0142)
> [ 1.343926] igb 0000:03:00.0: added PHC on eth0
> [ 1.343938] igb 0000:03:00.0: Intel(R) Gigabit Ethernet Network Connection
> [ 1.343949] igb 0000:03:00.0: eth0: (PCIe:2.5Gb/s:Width x1) c4:48:38:00:63:eb
> [ 1.344019] igb 0000:03:00.0: eth0: PBA No: 000300-000
> [ 1.344030] igb 0000:03:00.0: Using MSI-X interrupts. 4 rx queue(s), 4
> tx queue(s)
> [ 1.344464] libphy: igb_enet_mii_bus: probed
> 
> I do NOT see this in the log:
> [ 1.505474] libphy: mdiobus_find: mii bus [igb_enet_mii_bus] found
> [ 1.645075] igb 0000:03:00.0 eth0: [0]: detected a Marvell 88E6176 switch
> [ 24.341748] igb 0000:03:00.0 eth0: igb_enet_mii_probe starts
> [ 24.344928] igb 0000:03:00.0 eth0: igb: eth0 NIC Link is Up 1000 Mbps
> Full Duplex, Flow Control: RX/TX
> 
> Any suggestions/speculations what may be going on here?

I think you have some patches applied here, because i don't think igb
supports linux mdio. It has its own implementation.

Assuming that is what you have, the probe of the switch normally fails
the first time. Generally, the mdio bus is registered before the
network interface. So when the switch tried to lookup the ethernet
interface, it does not exist. -EPROBE_DEFFER is returned. The core
will then try again, by which time the interfaces does exist.

You probably want to scatter some printk() in the code to see what is
happening.

	Andrew
