Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBD40304B57
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 22:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727680AbhAZErS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 23:47:18 -0500
Received: from 95-165-96-9.static.spd-mgts.ru ([95.165.96.9]:57708 "EHLO
        blackbox.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726159AbhAYJPX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 04:15:23 -0500
Received: from metabook.localnet (metabook.metanet [192.168.2.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by blackbox.su (Postfix) with ESMTPSA id 02E5682102;
        Mon, 25 Jan 2021 11:58:49 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=blackbox.su; s=mail;
        t=1611565129; bh=M5T8IVEuH9uBT6rA34kAGJxS5Tq8grPx+kUaZQ66ui0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JQTcv+8fFv/j0Eh4Hlq23VBnUHR1TdsKHqkXHbaxwZIa0SNtu438xVWhgFbeJCpm+
         CkiBOTHRNhih3+ahC5/YwsvOdAa/IFVspj71B36UMJhZwX7ltgX3MvRqPgbcC6RoWW
         WDCEqTCje0pt+JRMozRNncst7ayCH/LbhUkoQ5ql2Ax1K6v/5svT3HCXI6Fr957jN7
         QG1QPMH4jqJgG103Mv3GBdlx92bWPkaRL2iuyIE1Rryy0CC345mI7b6GOlayRmmw+J
         VRdTeVIgbyiHtOb9fAbmmTxfvAYqhdvOs6DojNInzJTPB3hrB4AuoEAqbL2LzVvFts
         fuuX8OJdhCaMw==
From:   Sergej Bauer <sbauer@blackbox.su>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Simon Horman <simon.horman@netronome.com>,
        Mark Einon <mark.einon@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Masahiro Yamada <masahiroy@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] lan743x: add virtual PHY for PHY-less devices
Date:   Mon, 25 Jan 2021 11:57:54 +0300
Message-ID: <4225841.iQuhppFpKy@metabook>
In-Reply-To: <cce7fdd0-2b75-26f5-ce25-ca8803ffccc5@gmail.com>
References: <20210122214247.6536-1-sbauer@blackbox.su> <4496952.bab7Homqhv@metabook> <cce7fdd0-2b75-26f5-ce25-ca8803ffccc5@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Saturday, January 23, 2021 4:39:47 AM MSK Florian Fainelli wrote:
> On 1/22/2021 5:01 PM, Sergej Bauer wrote:
> > On Saturday, January 23, 2021 3:01:47 AM MSK Florian Fainelli wrote:
> >> On 1/22/2021 3:58 PM, Sergej Bauer wrote:
> >>> On Saturday, January 23, 2021 2:23:25 AM MSK Andrew Lunn wrote:
> >>>>>>> @@ -1000,8 +1005,10 @@ static void lan743x_phy_close(struct
> >>>>>>> lan743x_adapter *adapter)>
> >>>>>>> 
> >>>>>>>  	struct net_device *netdev = adapter->netdev;
> >>>>>>>  	
> >>>>>>>  	phy_stop(netdev->phydev);
> >>>>>>> 
> >>>>>>> -	phy_disconnect(netdev->phydev);
> >>>>>>> -	netdev->phydev = NULL;
> >>>>>>> +	if (phy_is_pseudo_fixed_link(netdev->phydev))
> >>>>>>> +		lan743x_virtual_phy_disconnect(netdev->phydev);
> >>>>>>> +	else
> >>>>>>> +		phy_disconnect(netdev->phydev);
> >>>>>> 
> >>>>>> phy_disconnect() should work. You might want to call
> >>>> 
> >>>> There are drivers which call phy_disconnect() on a fixed_link. e.g.
> >>>> 
> >>>> https://elixir.bootlin.com/linux/v5.11-rc4/source/drivers/net/usb/lan78
> >>>> xx
> >>>> .c# L3555.
> >>>> 
> >>>> 
> >>>> It could be your missing call to fixed_phy_unregister() is leaving
> >>>> behind bad state.
> >>> 
> >>> lan743x_virtual_phy_disconnect removes sysfs-links and calls
> >>> fixed_phy_unregister()
> >>> and the reason was phydev in sysfs.
> >>> 
> >>>>> It was to make ethtool show full set of supported speeds and MII only
> >>>>> in
> >>>>> supported ports (without TP and the no any ports in the bare card).
> >>>> 
> >>>> But fixed link does not support the full set of speed. It is fixed. It
> >>>> supports only one speed it is configured with.
> >>> 
> >>> That's why I "re-implemented the fixed PHY driver" as Florian said.
> >>> The goal of virtual phy was to make an illusion of real device working
> >>> in
> >>> loopback mode. So I could use ethtool and ioctl's to switch speed of
> >>> device.>
> >>> 
> >>>> And by setting it
> >>>> wrongly, you are going to allow the user to do odd things, like use
> >>>> ethtool force the link speed to a speed which is not actually
> >>>> supported.
> >>> 
> >>> I have lan743x only and in loopback mode it allows to use speeds
> >>> 10/100/1000MBps
> >>> in full-duplex mode only. But the highest speed I have achived was
> >>> something near
> >>> 752Mbps...
> >>> And I can switch speed on the fly, without reloading the module.
> >>> 
> >>> May by I should limit the list of acceptable devices?
> >> 
> >> It is not clear what your use case is so maybe start with explaining it
> >> and we can help you define something that may be acceptable for upstream
> >> inclusion.
> > 
> > it migth be helpful for developers work on userspace networking tools with
> > PHY-less lan743x (the interface even could not be brought up)
> > of course, there nothing much to do without TP port but the difference is
> > representative.
> 
> You are still not explaining why fixed PHY is not a suitable emulation
> and what is different, providing the output of ethtool does not tell me
> how you are using it.
> 
> Literally everyone using Ethernet switches or MAC to MAC Ethernet
> connections uses fixed PHY and is reasonably happy with it.

Florian, the key idea is to make virtual phy device which acts as real 802.11
standard  phy.

original fixed_phy and swphy are little bit useless as they do not support
write operation. in contrast of them virtual_phy supports write to all
registers. and can change the speed of interface by means of SIOCSMIIREG ioctl
call either ethtool.
changing of appropriate bits in register 0 will change speed reflecting in 
ethtool
and vise versa.


-- 
                                Regards,
                                        Sergej



