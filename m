Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2254F1E4F4A
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 22:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728799AbgE0U1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 16:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728356AbgE0U1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 16:27:12 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EDB2C05BD1E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 13:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:To:From:Date:Reply-To:Cc:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=UmfSvcEvY7Xh1gr3KBdJrkUiNtcLc1+s02FTv9S+B8s=; b=ctEfPZu8Sm1IlhLpPQiSXmq9X
        5WMSTwaLRXjkfbq1dS4XY0ovVJPsOF8bU+IFMdcXfN4XDWAWivkAInB0kMBD/izMJuLJ4QpBFKPSd
        JphXTdP+i9U0og0v2x95JwKePBML0NPzHk/4uw2PZYfTtH98QwWCOhDoYFTiB/lHdGUQ5TyggNeR3
        bC8kshHBZ0UtvLjgu3rYfCkYRfA4ku1e9aAjYgehF3Or0R9pYXYNuYSJ0OIrLWeGOQ1IkE9QdUE6m
        xDrw5zk64sQ78xCjWBZP/NwesuWhe3CAVmWffGobr73h39SVWrGt5qY6tI9WPWLuD5ty//AVcmedy
        MRXjkEe6Q==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:45864)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1je2dl-0003br-0H; Wed, 27 May 2020 21:27:05 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1je2di-0006jY-9b; Wed, 27 May 2020 21:27:02 +0100
Date:   Wed, 27 May 2020 21:27:02 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: Weird bridge behaviour - suddenly dropping vlan packets
Message-ID: <20200527202702.GR1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I've just had a weird problem on my network - I have a clearfogbase
(ARM) platform which has three network ports, running 5.6.  These
three network ports are bridged together, and the bridge has vlan
filtering enabled.

I need two ports (eno0 and eno1) to forward VLAN V between them, so
I've added that in the interfaces file:

iface brlan inet static
	...
	bridge-ports eno0 eno1 eno2
	bridge-wait 0
	...
        up ip link set $IFACE type bridge vlan_filtering 1
	up bridge vlan add vid V dev eno0
	up bridge vlan add vid V dev eno1

This vlan is used for WiFi.

This worked fine for some time, until recently (possibly this
evening) when someone complained that they couldn't connect to the
wifi.

Debugging using tcpdump revealed that native traffic was passing
through the bridge fine, but the bridge was blocking all VLAN V
traffic - I could see packets (mostly ARPs being broadcast for
IPs on either side of the bridge) arriving on both interfaces, but
not leaving.

Anything beyind the vlan configuration on the bridge should be fine
otherwise I would have expected problems with the untagged LAN
traffic.

The fdb entries seemed to be correct; I tried flushing them with
"ip li set brlan type bridge fdb_flush" - no apparent effect.  It
seemed to learn the MAC addresses on either side and associate them
with the vlan.

I tried adding the vlan to the brlan interface too, which was
successfully added, but no, there were no vlan packets there either
despite plenty of activity on the incoming interfaces for that vlan.

It basically seems that the Linux software bridge decided on its own
accord that it would drop all the vlan packets on the floor with no
explanation what so ever.

I tried turning vlan filtering off - even that didn't help.

Having tried a number of other things (including removing the vids
from each interface and adding them back) I decided that the only way
to get the network working again was to reboot the machine.  Hey
presto, things started working again.

This now means that there's nothing to debug, because the problem
has gone away.  However, I suspect it may return in another 49 or
so days.

It could have been some weird network driver issue, but I don't see
how that could produce valid vlan packets to tcpdump but prevent
the bridge from forwarding them.

It isn't some accidental reconfiguration; the machine has not had
anyone logged in to be able to make any changes for the last month
and it certainly has worked during that period - and there is no
other way to make changes other than being logged in (it has a
minimal debian stable install.)

Has anyone seen this kind of behaviour?

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up
