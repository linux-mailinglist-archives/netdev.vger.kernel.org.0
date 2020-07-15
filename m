Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E53C5220E53
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 15:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731844AbgGONjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 09:39:24 -0400
Received: from [195.135.220.15] ([195.135.220.15]:57050 "EHLO mx2.suse.de"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1730872AbgGONjY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 09:39:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1814DADB3;
        Wed, 15 Jul 2020 13:39:26 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 9DF9560302; Wed, 15 Jul 2020 15:39:22 +0200 (CEST)
Date:   Wed, 15 Jul 2020 15:39:22 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     "Michael J. Baars" <mjbaars1977.netdev@cyberfiber.eu>
Cc:     netdev@vger.kernel.org
Subject: Re: wake-on-lan
Message-ID: <20200715133922.tu2ptsfeu25fnuwe@lion.mk-sys.cz>
References: <309b0348938a475f256cbc8afbbc127c285fec69.camel@cyberfiber.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <309b0348938a475f256cbc8afbbc127c285fec69.camel@cyberfiber.eu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 15, 2020 at 11:27:20AM +0200, Michael J. Baars wrote:
> Hi Michal,
> 
> This is my network card:
> 
> 01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 0c)
> 	Subsystem: Realtek Semiconductor Co., Ltd. Device 0123
> 	Kernel driver in use: r8169
> 
> On the Realtek website
> (https://www.realtek.com/en/products/communications-network-ics/item/rtl8168e)
> it says that both wake-on-lan and remote wake-on-lan are supported. I
> got the wake-on-lan from my local network working, but I have problems
> getting the remote wake-on-lan to work.
> 
> When I set 'Wake-on' to 'g' and suspend my system, everything works
> fine (the router does lose the ip address assigned to the mac address
> of the system). I figured the SecureOn password is meant to forward
> magic packets to the correct machine when the router does not have an
> ip address assigned to a mac address, i.e. port-forwarding does not
> work.
> 
> Ethtool 'Supports Wake-on' gives 'pumbg', and when I try to set 'Wake-on' to 's' I get:
> 
> netlink error: cannot enable unsupported WoL mode (offset 36)
> netlink error: Invalid argument
> 
> Does this mean that remote wake-on-lan is not supported (according to
> ethtool)?

"MagicPacket" ('g') means that the NIC would wake on reception of packet
containing specific pattern described e.g. here:

  https://en.wikipedia.org/wiki/Wake-on-LAN#Magic_packet

This is the most frequently used wake on LAN mode and, in my experience,
what most people mean when they say "enable wake on LAN".

The "SecureOn(tm) mode" ('s') is an extension of this which seems to be
supported only by a handful of drivers; it involves a "password" (48-bit
value set by sopass parameter of ethtool) which is appended to the
MagicPacket.

I'm not sure how is the remote wake-on-lan supposed to work but
technically you need to get _any_ packet with the "magic" pattern to the
NIC.

> I also tried to set 'Wake-on' to 'b' and 'bg' but then the systems
> turns back on almost immediately for both settings.

This is not surprising as enabling "b" should wake the system upon
reception of any broadcast which means e.g. any ARP request. Enabling
multiple modes wakes the system on a packet matching any of them.

Michal
