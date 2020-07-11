Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4705521C5EA
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 21:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728735AbgGKTXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 15:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728695AbgGKTXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jul 2020 15:23:11 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49965C08C5DD
        for <netdev@vger.kernel.org>; Sat, 11 Jul 2020 12:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=SEaVB7JyH0FFGSUj3D9BerhCD49boICke7IEgSbXBW8=; b=fOUaUjN6GiMmUNAECKhT/0mQ8
        108S6Q2yZvOtYOtSbNi7RFAijiiiVxPfhkUZI06OoWPKVmt4p4ILAj2hAkaxKyzJQxOsd9rSChhT5
        QmBHKsd7f8Jb6fDJVOJollxKk+OR1yGKxOMLevuJ/Q2OKrYzh1/H3pmPAVuHhb9PjcxTA827nZ3dg
        puudNEo2Da7yHT2WBv7YG2mRAMeDpsevJbRY7PiHhu3mbyCRkyGnlE3VxEorjU68MTlDgQ25643u4
        FhpeBV56/IKNSk1BUlAvJJOU7V+igxNvc8QqD7AYZz278Ao7V6In2l+M47DVgzYOY2ZryVf12B3Gj
        UO+x0WE6g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:38254)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1juL5O-0002hQ-3z; Sat, 11 Jul 2020 20:22:58 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1juL5L-0004Wn-Mo; Sat, 11 Jul 2020 20:22:55 +0100
Date:   Sat, 11 Jul 2020 20:22:55 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Martin Rowe <martin.p.rowe@gmail.com>, netdev@vger.kernel.org,
        davem@davemloft.net, vivien.didelot@gmail.com
Subject: Re: bug: net: dsa: mv88e6xxx: unable to tx or rx with Clearfog GT 8K
 (with git bisect)
Message-ID: <20200711192255.GO1551@shell.armlinux.org.uk>
References: <CAOAjy5T63wDzDowikwZXPTC5fCnPL1QbH9P1v+MMOfydegV30w@mail.gmail.com>
 <20200711162349.GL1014141@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200711162349.GL1014141@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 11, 2020 at 06:23:49PM +0200, Andrew Lunn wrote:
> So i'm guessing it is the connection between the CPU and the switch.
> Could you confirm this? Create a bridge, add two ports of the switch
> to the bridge, and then see if packets can pass between switch ports.
> 
> If it is the connection between the CPU and the switch, i would then
> be thinking about the comphy and the firmware. We have seen issues
> where the firmware is too old. That is not something i've debugged
> myself, so i don't know where the version information is, or what
> version is required.

However, in the report, Martin said that reverting the problem commit
from April 14th on a kernel from July 6th caused everything to work
again.  That is quite conclusive that 34b5e6a33c1a is the cause of
the breakage.

The question is how - I don't get it.  None of the GT8k DSA ports are
fixed-links, not even the CPU port (which no longer even uses phylink.)
However, the MVPP2 is using a fixed-link on the port that faces the
DSA switch, which doesn't sound like a good idea to me to have
dis-similar configurations at either end.  So the addition of
"|| mode == MLO_AN_FIXED" shouldn't make any difference.

I think some debug printks would be needed to work out what's going on.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
