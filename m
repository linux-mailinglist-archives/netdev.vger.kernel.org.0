Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D78EC3010B1
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 00:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729191AbhAVXL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 18:11:58 -0500
Received: from 95-165-96-9.static.spd-mgts.ru ([95.165.96.9]:39558 "EHLO
        blackbox.su" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1729039AbhAVXLd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 18:11:33 -0500
Received: from metabook.localnet (metabook.metanet [192.168.2.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by blackbox.su (Postfix) with ESMTPSA id 37B8C82100;
        Sat, 23 Jan 2021 02:10:48 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=blackbox.su; s=mail;
        t=1611357048; bh=szJplrdwZI5qtsaxsaDEZdCTefVXT4yOCufVbPNzFZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cR2MZZOSmrGsHP2aZhvBql74T4W2FjcQM1pEe4QZH66h8EAqZ3LnDARU1rndHp8EE
         yrDjZwuTJ/xAzVKtMN0VoHh8oS7Ffo3OQj+APepu4ujP+kTYSRZdzm1ij7sHjJzdLQ
         zkVmvRBcYPYjH6pE9FbIeJanKM3U5r835lbv5sAAwrfP89bm84xAggsvI/Ws3EFXx/
         j6n+lbupQPFXpN2QpKrMRaz4ubmS4ead0g9uyLSHWzISMRnCSmBLdL/OWArWeTR7NO
         X/9/uBYy98kUd/8a/w1MjbUB0JTxfUJUXxmW9LHinHs8YGtaSlVvoSvqUpAE0QV7C1
         kosy2ILaNJBcw==
From:   Sergej Bauer <sbauer@blackbox.su>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com,
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
Date:   Sat, 23 Jan 2021 02:09:56 +0300
Message-ID: <21783568.4JFRnjC3Rk@metabook>
In-Reply-To: <YAtMw5Yk1QYp28rJ@lunn.ch>
References: <20210122214247.6536-1-sbauer@blackbox.su> <YAtMw5Yk1QYp28rJ@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Saturday, January 23, 2021 1:08:03 AM MSK Andrew Lunn wrote:
> On Sat, Jan 23, 2021 at 12:42:41AM +0300, Sergej Bauer wrote:
> > From: sbauer@blackbox.su
> > 
> > v1->v2:
> > 	switch to using of fixed_phy as was suggested by Andrew and Florian
> > 	also features-related parts are removed
> 
> This is not using fixed_phy, at least not in the normal way.
> 
> Take a look at bgmac_phy_connect_direct() for example. Call
> fixed_phy_register(), and then phy_connect_direct() with the
> phydev. End of story. Done.
> 
> > +int lan743x_set_link_ksettings(struct net_device *netdev,
> > +			       const struct ethtool_link_ksettings *cmd)
> > +{
> > +	if (!netdev->phydev)
> > +		return -ENETDOWN;
> > +
> > +	return phy_is_pseudo_fixed_link(netdev->phydev) ?
> > +			lan743x_set_virtual_link_ksettings(netdev, cmd)
> > +			: phy_ethtool_set_link_ksettings(netdev, cmd);
> > +}
> 
> There should not be any need to do something different. The whole
> point of fixed_phy is it looks like a PHY. So calling
> phy_ethtool_set_link_ksettings() should work, nothing special needed.
> 
> > @@ -1000,8 +1005,10 @@ static void lan743x_phy_close(struct
> > lan743x_adapter *adapter)> 
> >  	struct net_device *netdev = adapter->netdev;
> >  	
> >  	phy_stop(netdev->phydev);
> > 
> > -	phy_disconnect(netdev->phydev);
> > -	netdev->phydev = NULL;
> > +	if (phy_is_pseudo_fixed_link(netdev->phydev))
> > +		lan743x_virtual_phy_disconnect(netdev->phydev);
> > +	else
> > +		phy_disconnect(netdev->phydev);
> 
> phy_disconnect() should work. You might want to call
Andrew, this is why I was playing with my own _connect/_disconnect 
realizations
It should work but it don't.
modprobe lan743x
rmmod lan743x
modprobe lan743x
leads to
"net eth7: could not add device link to fixed-0:06 err -17"
in dmesg (it does not removes corresponding phydev file in /sysfs)
moreover phy_disconnect leads to kernel panic
[82363.976726] BUG: kernel NULL pointer dereference, address: 00000000000003c4
[82363.977402] #PF: supervisor read access in kernel mode
[82363.978077] #PF: error_code(0x0000) - not-present page
[82363.978588] PGD 0 P4D 0 
[82363.978588] Oops: 0000 [#1] SMP NOPTI
[82363.978588] CPU: 3 PID: 2634 Comm: ifconfig Tainted: G           O      
5.11.0-rc4net-next-virtual_phy+ #3
[82363.978588] Hardware name: Gigabyte Technology Co., Ltd. H110-D3/H110-D3-
CF, BIOS F24 04/11/2018
[82363.978588] RIP: 0010:lan743x_phy_close.isra.26+0x28/0x40 [lan743x]
[82363.978588] Code: c3 90 0f 1f 44 00 00 53 48 89 fb 48 8b bf 28 08 00 00 e8 
ab 5e 86 ff 48 8b bb 28 08 00 00 e8 4f 92 86 ff 48 8b bb 28 08 00 00 <f6> 87 c4 
03 00 00 04 75 02 5b c3 5b e9 f7 35 ea ff 0f 1f 80 00 00
[82363.982448] RSP: 0018:ffffa528c04c7c38 EFLAGS: 00010246
[82363.982448] RAX: 000000000000000f RBX: ffff991a47e38000 RCX: 0000000000000027
[82363.982448] RDX: 0000000000000000 RSI: ffff991c76d98b30 RDI: 0000000000000000
[82363.982448] RBP: 0000000000000001 R08: 0000000000000000 R09: c0000000ffffefff
[82363.982448] R10: 0000000000000001 R11: ffffa528c04c7a48 R12: ffff991a47e388c0
[82363.986855] R13: ffff991a47e390b8 R14: ffff991a47e39050 R15: ffff991a47e388c0
[82363.986855] FS:  00007f7c3ebd6540(0000) GS:ffff991c76d80000(0000) knlGS:
0000000000000000
[82363.986855] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[82363.986855] CR2: 00000000000003c4 CR3: 000000001b2ac005 CR4: 
00000000003706e0
[82363.986855] Call Trace:
[82363.986855]  lan743x_netdev_close+0x223/0x250 [lan743x]
...

> fixed_phy_unregister() afterwards, so you do not leak memory.
> 
> > +		if (phy_is_pseudo_fixed_link(phydev)) {
> > +			ret = phy_connect_direct(netdev, phydev,
> > +						 lan743x_virtual_phy_status_change,
> > +						 PHY_INTERFACE_MODE_MII);
> > +		} else {
> > +			ret = phy_connect_direct(netdev, phydev,
> > +						 lan743x_phy_link_status_change,
> 
> There should not be any need for a special link change
> callback. lan743x_phy_link_status_change() should work fine, the MAC
> should have no idea it is using a fixed_phy.
> 
> > +						 PHY_INTERFACE_MODE_GMII);
> > +		}
> > +
> > 
> >  		if (ret)
> >  		
> >  			goto return_error;
> >  	
> >  	}
> > 
> > @@ -1031,6 +1049,15 @@ static int lan743x_phy_open(struct lan743x_adapter
> > *adapter)> 
> >  	/* MAC doesn't support 1000T Half */
> >  	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
> > 
> > +	if (phy_is_pseudo_fixed_link(phydev)) {
> > +		phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_TP_BIT);
> > +		linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT_Full_BIT,
> > +				 phydev->supported);
> > +		linkmode_set_bit(ETHTOOL_LINK_MODE_100baseT_Full_BIT,
> > +				 phydev->supported);
> > +		phy_advertise_supported(phydev);
> > +	}
> 
> The fixed PHY driver will set these bits depending on the speed it has
> been configured for. No need to change them. The MAC should also not
> care if it is TP, AUI, Fibre or smoke signals.
It was to make ethtool show full set of supported speeds and MII only in
supported ports (without TP and the no any ports in the bare card).

> 
>      Andrew

I think I should reproduce the panic with clean version of net-net

--
                                Regards,
                                    Sergej.



