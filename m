Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0FF1267660
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 01:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725905AbgIKXK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 19:10:57 -0400
Received: from mail.nic.cz ([217.31.204.67]:60790 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725856AbgIKXKv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 19:10:51 -0400
Received: from localhost (unknown [IPv6:2a0e:b107:ae1:0:3e97:eff:fe61:c680])
        by mail.nic.cz (Postfix) with ESMTPSA id E3B751409C6;
        Sat, 12 Sep 2020 01:10:45 +0200 (CEST)
Date:   Sat, 12 Sep 2020 01:10:45 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        netdev@vger.kernel.org, linux-leds@vger.kernel.org,
        Dan Murphy <dmurphy@ti.com>,
        =?UTF-8?B?T25k?= =?UTF-8?B?xZllag==?= Jirman 
        <megous@megous.com>, linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Yet another ethernet PHY LED control proposal
Message-ID: <20200912011045.35bad071@nic.cz>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WELCOMELIST,USER_IN_WHITELIST shortcircuit=ham
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I have been thinking about another way to implement ABI for HW control
of ethernet PHY connected LEDs.

This proposal is inspired by the fact that for some time there is a
movement in the kernel to do transparent HW offloading of things (DSA
is an example of that).

So currently we have the `netdev` trigger. When this is enabled for a
LED, new files will appear in that LED's sysfs directory:
  - `device_name` where user is supposed to write interface name
  - `link` if set to 1, the LED will be ON if the interface is linked
  - `rx` if set to 1, the LED will blink on receive event
  - `tx` if set to 1, the LED will blink on transmit event
  - `interval` specifies duration of the LED blink

Now what is interesting is that almost all combinations of link/rx/tx
settings are offloadable to a Marvell PHY! (Not to all LEDs, though...)

So what if we abandoned the idea of a `hw` trigger, and instead just
allowed a LED trigger to be offloadable, if that specific LED supports
it?

For the HW mode for different speed we can just expand the `link` sysfs
file ABI, so that if user writes a specific speed to this file, instead
of just "1", the LED will be on if the interface is linked on that
specific speed. Or maybe another sysfs file could be used for "light on
N mbps" setting...

Afterwards we can figure out other possible modes.

What do you think?

Marek
