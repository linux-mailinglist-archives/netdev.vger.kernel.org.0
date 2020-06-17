Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 659631FD5FD
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 22:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbgFQUZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 16:25:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726758AbgFQUZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 16:25:02 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D94B3C06174E;
        Wed, 17 Jun 2020 13:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=dvRlFCNZ5WqBJoYVHQscJZfIgwl7qkr7xPvAM2TJ7JI=; b=slSTfydKereZYoUl7eRXHy/lx
        /tj9poDu6lkttVRXTZTNqdn/bcNnY7CrUgkVU3Xb70f/2qKRYmqNTY/RJs7bSYgOcu85ZQJl1RrjM
        u8lhMacg+PY3rsqpB7yENX73lo12IBBvz00iy7gFEwxQ+DCj4FC0Ko+L8S+bDeb5j7tg0Mfr+HTKO
        nCCx81ZJNcF6ii3IcgzttY9N3nOOv+syjgDfKjZ11jID3o9K+DLJYZLZupQ5PglkIiHir18dm8H7v
        FZJdWvSQ5IECEnzbmLd0gPm9ojfBmnuuBWMsGiSmxEUNHqPzQY17FDK4RWPADBfcqQVuZG7GDTeAS
        WyB0/hkhw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58624)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jlecB-00042o-0W; Wed, 17 Jun 2020 21:24:55 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jlec6-000427-N7; Wed, 17 Jun 2020 21:24:50 +0100
Date:   Wed, 17 Jun 2020 21:24:50 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Dejin Zheng <zhengdejin5@gmail.com>, f.fainelli@gmail.com,
        hkallweit1@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kevin Groeneveld <kgroeneveld@gmail.com>
Subject: Re: [PATCH net v1] net: phy: smsc: fix printing too many logs
Message-ID: <20200617202450.GX1551@shell.armlinux.org.uk>
References: <20200617153340.17371-1-zhengdejin5@gmail.com>
 <20200617161925.GE205574@lunn.ch>
 <20200617175039.GA18631@nuc8i5>
 <20200617184334.GA240559@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200617184334.GA240559@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 08:43:34PM +0200, Andrew Lunn wrote:
> You have explained what the change does. But not why it is
> needed. What exactly is happening. To me, the key thing is
> understanding why we get -110, and why it is not an actual error we
> should be reporting as an error. That is what needs explaining.

The patch author really ought to be explaining this... but let me
have a go.  It's worth pointing out that the comments in the file
aren't good English either, so don't really describe what is going
on.

When this PHY is in EDPD mode, it doesn't always detect a connected
cable.  The workaround for it involves, when the link is down, and
at each read_status() call:

- disable EDPD mode, forcing the PHY out of low-power mode
- waiting 640ms to see if we have any energy detected from the media
- re-enable entry to EDPD mode

This is presumably enough to allow the PHY to notice that a cable is
connected, and resume normal operations to negotiate with the partner.

The problem is that when no media is detected, the 640ms wait times
out (as it should, we don't want to wait forever) and the kernel
prints a warning.

This bug was introduced by an inappropriate conversion of:

                /* Wait max 640 ms to detect energy */
-               for (i = 0; i < 64; i++) {
-                       /* Sleep to allow link test pulses to be sent */
-                       msleep(10);
-                       rc = phy_read(phydev, MII_LAN83C185_CTRL_STATUS);
-                       if (rc < 0)
-                               return rc;
-                       if (rc & MII_LAN83C185_ENERGYON)
-                               break;
-               }

to phy_read_poll_timeout() in the belief that it was "cleaning up"
the code, but it actually results in a functional change of printing
an error at the end of the 640ms window which wasn't there before.
The patch that does this even states that it's about "simplifying"
the code, yet it introduced a bug by doing so - that being the
extra kernel log message.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
