Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE40F35E630
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 20:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345212AbhDMSVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 14:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236781AbhDMSVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 14:21:22 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B20F3C061574;
        Tue, 13 Apr 2021 11:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=3otjJQDVclfQj5OeeGQgP+vjqVTeV1bgt2xz5IPGlUY=; b=oOsRD55o9UzcX64qjjMjCl4pu
        LdnP66oNAWYVDC8XDJ+ofIYFK9RNMGzxNlc7bY4CoVkvOrOz12US0g2638j8k4PCcez2GZkQ7cb0i
        d4P5MRqjIss+D00phTLxhupN+015rN9ri5O8oYiFkoXGPSKEXgNetgUFnedVKvE0w6zwA9mOu7c66
        ESuBnDSSoHmXBIbXddM/MVAqXO/s2g/0++9z1atqQLB+xz1nzD9vpxptzFgBRpiXkcH7GLVlYrIjV
        0VKASTdAmWpRqnSz2tHs8/81zHam6aWmIfG1nk99jxhNOcJcYcfTnk1gFDWBQ+6R+3EQZuLb//uy5
        n2GYalQnw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52396)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lWNed-0005sb-Ul; Tue, 13 Apr 2021 19:20:51 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lWNed-0008Nb-AH; Tue, 13 Apr 2021 19:20:51 +0100
Date:   Tue, 13 Apr 2021 19:20:51 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ben Whitten <ben.whitten@gmail.com>, Dan Murphy <dmurphy@ti.com>
Cc:     linux-leds@vger.kernel.org, netdev@vger.kernel.org
Subject: leds: netdev trigger - misleading link state indication at boot
Message-ID: <20210413182051.GR1463@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I'm seeing some odd behaviour with the netdev trigger and some WiFi
interfaces.

When the WiFi interface has never been brought up (so is in an
operationally disabled state), if I bind a LED to the netdev
trigger, setting the device_name to the WiFi interface name and
enable the "link" property, the LED illuminates, indicating that
the WiFi device has link - but it's disabled.

If I up/down the WiFi interface, thereby returning it to the
original state, the link LED goes out.

I suspect ledtrig-netdev.c needs to check that the device is both
up (dev->flags & IFF_UP) and netif_carrier_ok(dev) both return true,
rather than just relying on netif_carrier_ok(). I don't think using
netif_running() is appropriate, as that will return true before
ndo_open() has been called to initialise the carrier state.

Agreed?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
