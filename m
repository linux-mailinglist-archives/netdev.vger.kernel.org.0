Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DDB0356046
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 02:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236665AbhDGA0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 20:26:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37144 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236599AbhDGA0M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 20:26:12 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lTw17-00FDi1-2A; Wed, 07 Apr 2021 02:25:57 +0200
Date:   Wed, 7 Apr 2021 02:25:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     hauke@hauke-m.de, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, linux@armlinux.org.uk,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH RFC net 1/2] net: dsa: lantiq_gswip: Don't use PHY auto
 polling
Message-ID: <YGz8FRBsj68xIbX/@lunn.ch>
References: <20210406203508.476122-1-martin.blumenstingl@googlemail.com>
 <20210406203508.476122-2-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406203508.476122-2-martin.blumenstingl@googlemail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 06, 2021 at 10:35:07PM +0200, Martin Blumenstingl wrote:
> PHY auto polling on the GSWIP hardware can be used so link changes
> (speed, link up/down, etc.) can be detected automatically. Internally
> GSWIP reads the PHY's registers for this functionality. Based on this
> automatic detection GSWIP can also automatically re-configure it's port
> settings. Unfortunately this auto polling (and configuration) mechanism
> seems to cause various issues observed by different people on different
> devices:
> - FritzBox 7360v2: the two Gbit/s ports (connected to the two internal
>   PHY11G instances) are working fine but the two Fast Ethernet ports
>   (using an AR8030 RMII PHY) are completely dead (neither RX nor TX are
>   received). It turns out that the AR8030 PHY sets the BMSR_ESTATEN bit
>   as well as the ESTATUS_1000_TFULL and ESTATUS_1000_XFULL bits. This
>   makes the PHY auto polling state machine (rightfully?) think that the
>   established link speed (when the other side is Gbit/s capable) is
>   1Gbit/s.
> - None of the Ethernet ports on the Zyxel P-2812HNU-F1 (two are
>   connected to the internal PHY11G GPHYs while the other three are
>   external RGMII PHYs) are working. Neither RX nor TX traffic was
>   observed. It is not clear which part of the PHY auto polling state-
>   machine caused this.
> - FritzBox 7412 (only one LAN port which is connected to one of the
>   internal GPHYs running in PHY22F / Fast Ethernet mode) was seeing
>   random disconnects (link down events could be seen). Sometimes all
>   traffic would stop after such disconnect. It is not clear which part
>   of the PHY auto polling state-machine cauased this.
> - TP-Link TD-W9980 (two ports are connected to the internal GPHYs
>   running in PHY11G / Gbit/s mode, the other two are external RGMII
>   PHYs) was affected by similar issues as the FritzBox 7412 just without
>   the "link down" events
> 
> Switch to software based configuration instead of PHY auto polling (and
> letting the GSWIP hardware configure the ports automatically) for the
> following link parameters:
> - link up/down
> - link speed
> - full/half duplex
> - flow control (RX / TX pause)
> 
> After a big round of manual testing by various people (who helped test
> this on OpenWrt) it turns out that this fixes all reported issues.
> 
> Additionally it can be considered more future proof because any
> "quirk" which is implemented for a PHY on the driver side can now be
> used with the GSWIP hardware as well because Linux is in control of the
> link parameters.
> 
> As a nice side-effect this also solves a problem where fixed-links were
> not supported previously because we were relying on the PHY auto polling
> mechanism, which cannot work for fixed-links as there's no PHY from
> where it can read the registers. Configuring the link settings on the
> GSWIP ports means that we now use the settings from device-tree also for
> ports with fixed-links.
> 
> Fixes: 14fceff4771e51 ("net: dsa: Add Lantiq / Intel DSA driver for vrx200")
> Fixes: 3e6fdeb28f4c33 ("net: dsa: lantiq_gswip: Let GSWIP automatically set the xMII clock")
> Cc: stable@vger.kernel.org
> Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Having the MAC polling the PHY is pretty much always a bad idea.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
