Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB9743E6C6
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 19:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbhJ1RII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 13:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbhJ1RIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 13:08:07 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC07C061570;
        Thu, 28 Oct 2021 10:05:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=HkGYfxxVPcWMTGp2R4d/RlpWmLG/2/mcfu/24wT0+fg=; b=to/pZlYy6m8mMy7hBJXsH3C0Ou
        fxSKKQTtUakArGZtAGa5ys+DJrPdBTJZcpNXIwa3DVmtRgKCefy7QjNeNYRN5nYQ/t5eQkfigrGJk
        52UnMW2/NsapzYaw87FM2O0QOhdW7OmefsyVogazJVeDhO7p6MpObUwh3AFYykFLq8QFbVOMeGY9j
        stJAREGqeV/4RyXvBk3AD+vL+9gHm6UNz2tcMKrJx3WX8t23RfrUthb7rdIaONo0hNTVyfPykv43T
        +2BkSB4NLEEKnmK/swvviYIGcDCRfbfqa0eXfiljoNn9kY+tt562+LPcoF3KHGXmFc8JXxOGPD9Zg
        HhTuf56w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55358)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mg8qQ-0007oe-64; Thu, 28 Oct 2021 18:05:38 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mg8qO-0000VT-Qj; Thu, 28 Oct 2021 18:05:36 +0100
Date:   Thu, 28 Oct 2021 18:05:36 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, olteanv@gmail.com,
        robh+dt@kernel.org, UNGLinuxDriver@microchip.com,
        Woojung.Huh@microchip.com, hkallweit1@gmail.com,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v5 net-next 06/10] net: dsa: microchip: add support for
 phylink management
Message-ID: <YXrYYL7+NRgUtvN3@shell.armlinux.org.uk>
References: <20211028164111.521039-1-prasanna.vengateshan@microchip.com>
 <20211028164111.521039-7-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211028164111.521039-7-prasanna.vengateshan@microchip.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 28, 2021 at 10:11:07PM +0530, Prasanna Vengateshan wrote:
> Support for phylink_validate() and reused KSZ commmon API for
> phylink_mac_link_down() operation
> 
> lan937x_phylink_mac_config configures the interface using
> lan937x_mac_config and lan937x_phylink_mac_link_up configures
> the speed/duplex/flow control.
> 
> Currently SGMII & in-band neg are not supported & it will be
> added later.
> 
> Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>

Hi,

I've just sent "net: dsa: populate supported_interfaces member"
which adds a hook to allow DSA to populate the newly introduced
supported_interfaces member of phylink_config. Once this patch is
merged, it would be great to see any new drivers setting this
member.

Essentially, the phylink_get_interfaces method is called with the
DSA switch and port number, and a pointer to the supported_interfaces
member - which is a bitmap of PHY_INTERFACE_MODEs that are supported
by this port.

When you have set any bit in the supported interfaces, phylink's
behaviour when calling your lan937x_phylink_validate changes - it will
no longer call it with PHY_INTERFACE_MODE_NA, but will instead do a
bitwalk over the bitmap, and call it for each supported interface type
instead.

When phylink has a specific interface mode, it will continue to make a
single call - but only if the interface mode is indicated as supported
in the supported interfaces bitmap.

Please keep an eye on "net: dsa: populate supported_interfaces member"
and if you need to respin this series after that patch has been merged,
please update in regards of this.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
