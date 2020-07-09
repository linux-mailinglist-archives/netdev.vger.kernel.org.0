Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AEC521A145
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 15:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbgGINxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 09:53:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55320 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727082AbgGINxh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 09:53:37 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jtWzX-004L8q-M3; Thu, 09 Jul 2020 15:53:35 +0200
Date:   Thu, 9 Jul 2020 15:53:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?utf-8?B?0b3SieG2rOG4s+KEoA==?= <vtol@gmx.net>
Cc:     netdev@vger.kernel.org
Subject: Re: [DSA] L2 Forwarding Offload not working
Message-ID: <20200709135335.GL928075@lunn.ch>
References: <29a9c85b-8f5a-2b85-2c7d-9b7ca0a6cb41@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <29a9c85b-8f5a-2b85-2c7d-9b7ca0a6cb41@gmx.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 09, 2020 at 11:32:00AM +0000, ѽ҉ᶬḳ℠ wrote:
> "kernel":"5.4.50", "system":"ARMv7 Processor rev 1
> (v7l)","model":"Turris
> Omnia","board_name":"cznic,turris-omnia","release":{"distribution":"OpenWrt","version":"SNAPSHOT","revision":"r13719-66e04abbb6","target":"mvebu/cortexa9","}
> 
> CPU Marvell Armada 385 88F6820 | Switch  Marvell 88E6176
> 
> soft bridge br-lan enslaving DSA ports lan0 lan1 lan2
> 
> DSA master device eth1 (subsequent ip l exhibits slaves as lanX@eth1)
> ----------
> 
> After perusal of
> https://www.kernel.org/doc/Documentation/networking/switchdev.txt it is
> my understanding that offloading works only for static FDB entries,
> though not clear to me:
> 
> * what the logic is behind, and
> * why DSA ports are not static FDB entries by default (would only seem
> logical)

Hello

With DSA, we have two sets of tables. The switch performs address
learning, and the software bridge performs address learning. No
attempt is made to keep these dynamic FDB entries in sync. There is
not enough bandwidth over the MDIO link to keep the two tables in
sync. However, when you dump the FDB using the bridge command, you get
to see the combination of both tables. The hardware will perform
forwarding based on its table, and the software bridge based on its
table.. However, if there is no entry in the hardware table for a
given destination MAC address, it will forward the frame to the
software bridge, so it can decide what to do with it.

For static FDB entries which the user adds, they are first added to
the software bridge, and then pushed down to the switch.

    Andrew
