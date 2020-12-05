Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDB12CFCF1
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 19:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729139AbgLEST0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 13:19:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727874AbgLERsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Dec 2020 12:48:41 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 007B9C02B8F6
        for <netdev@vger.kernel.org>; Sat,  5 Dec 2020 07:45:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=jkMXp5WnOyY6Kw5gqxhLQokaXY0A9ffQ1/IWLgytZZA=; b=ZlkH3mcgmO4WXTkKe5SQevzWn
        ochQYUsLUBomEkEMYa/IZ+F2HeaM/+brB4C1pPbl6IbYTYG47E6gEVCxgIvN4G36svUh0FPKyROMu
        XAf3ZmBBllBgNcrNFA2mn6RBfTNKi680VPWIO22Yy01863fQw0oHD26kS/Ddczv/m1m89F9Yp4bR3
        SzTc/xS+e05066vl3L4aXwpikRs049FS2btbVmqkqyoXvy2CHTExgFFlbQJTlQ2+IriLfr38Ae0VS
        Nsn9ehHki+yMa91yJH5fA5hOWmNMfUbUcfFWvu/PCHTwgPXKqiY5Q+gqrOqlMDrgbI7srBjUEMbNs
        gBGaqjsVQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:40138)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1klZkZ-0005Va-6D; Sat, 05 Dec 2020 15:45:31 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1klZkY-0001mv-0s; Sat, 05 Dec 2020 15:45:30 +0000
Date:   Sat, 5 Dec 2020 15:45:29 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Network Development <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: vlan_filtering=1 breaks all traffic (was: Re: warnings from MTU
 setting on switch ports)
Message-ID: <20201205154529.GO1551@shell.armlinux.org.uk>
References: <b4adfc0b-cd48-b21d-c07f-ad35de036492@prevas.dk>
 <20201130160439.a7kxzaptt5m3jfyn@skbuf>
 <61a2e853-9d81-8c1a-80f0-200f5d8dc650@prevas.dk>
 <6424c14e-bd25-2a06-cf0b-f1a07f9a3604@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6424c14e-bd25-2a06-cf0b-f1a07f9a3604@prevas.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 05, 2020 at 03:49:02PM +0100, Rasmus Villemoes wrote:
> So, I found out that the problem disappers when I disable
> vlan_filtering, and googling then led me to Russell's patches from
> around March
> (https://patchwork.ozlabs.org/project/netdev/cover/20200218114515.GL18808@shell.armlinux.org.uk/).
> 
> But, unlike from what I gather from Russell's description, the problem
> is there whether or not the bridge is created with vlan_filtering
> enabled from the outset or not.

No. My problem is where the bridge is created _without_ vlan_filtering
enabled, and is subsequently enabled. That caused traffic to stop as
soon as vlan_filtering was enabled.

Note that if the bridge were created with vlan_filtering enabled from
the start, there would be no problem.

> Also, cherry-picking 517648c8d1 to
> 5.9.12 doesn't help. The problem also exists on 5.4.80, and (somewhat
> naively) backporting 54a0ed0df496 as well as 517648c8d1 doesn't change that.

I'm not sure what 517648c8d1 is - this isn't a mainline or net-next
commit ID.

54a0ed0df496 is a modification by Vladimir Oltean of my original patch
("net: dsa: mv88e6xxx: fix vlan setup") that fixed it for Marvell DSA,
dropping the Marvell DSA bits of the patch, thereby neutering it for
its intended purpose, while still mostly maintaining the commit
description which implies that it fixes Marvell DSA.

I'm afraid that I've now given up dealing with anything that involves
interaction with the impossible Vladimir Oltean - the problems you are
experiencing are a direct result of Vladimir Oltean's attitudes towards
fellow kernel developers.

You will, however, find that the problem was subsequently fixed by
1fb74191988f on top of 54a0ed0df496, which adds the part that
Vladimir Oltean failed to carry forward. It's all an unnecessary
horrible mess.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
