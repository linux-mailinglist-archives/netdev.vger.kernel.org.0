Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B876354993
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 02:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242919AbhDFAJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 20:09:57 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34912 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241639AbhDFAJ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 20:09:56 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lTZHf-00F0hM-Mm; Tue, 06 Apr 2021 02:09:31 +0200
Date:   Tue, 6 Apr 2021 02:09:31 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Grant Grundler <grundler@chromium.org>
Cc:     Oliver Neukum <oneukum@suse.com>, Jakub Kicinski <kuba@kernel.org>,
        Roland Dreier <roland@kernel.org>,
        nic_swsd <nic_swsd@realtek.com>, netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v4 0/4] usbnet: speed reporting for devices
 without MDIO
Message-ID: <YGumuzcPl+9l5ZHV@lunn.ch>
References: <20210405231344.1403025-1-grundler@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210405231344.1403025-1-grundler@chromium.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 05, 2021 at 04:13:40PM -0700, Grant Grundler wrote:
> This series introduces support for USB network devices that report
> speed as a part of their protocol, not emulating an MII to be accessed
> over MDIO.
> 
> v2: rebased on recent upstream changes
> v3: incorporated hints on naming and comments
> v4: fix misplaced hunks; reword some commit messages;
>     add same change for cdc_ether
> v4-repost: added "net-next" to subject and Andrew Lunn's Reviewed-by
> 
> I'm reposting Oliver Neukum's <oneukum@suse.com> patch series with
> fix ups for "misplaced hunks" (landed in the wrong patches).
> Please fixup the "author" if "git am" fails to attribute the
> patches 1-3 (of 4) to Oliver.
> 
> I've tested v4 series with "5.12-rc3+" kernel on Intel NUC6i5SYB
> and + Sabrent NT-S25G. Google Pixelbook Go (chromeos-4.4 kernel)
> + Alpha Network AUE2500C were connected directly to the NT-S25G
> to get 2.5Gbps link rate:
> # ethtool enx002427880815
> Settings for enx002427880815:
>         Supported ports: [  ]
>         Supported link modes:   Not reported
>         Supported pause frame use: No
>         Supports auto-negotiation: No
>         Supported FEC modes: Not reported
>         Advertised link modes:  Not reported
>         Advertised pause frame use: No
>         Advertised auto-negotiation: No
>         Advertised FEC modes: Not reported
>         Speed: 2500Mb/s
>         Duplex: Half
>         Auto-negotiation: off
>         Port: Twisted Pair
>         PHYAD: 0
>         Transceiver: internal
>         MDI-X: Unknown
>         Current message level: 0x00000007 (7)
>                                drv probe link
>         Link detected: yes
> 
> 
> "Duplex" is a lie since we get no information about it.

You can ask the PHY. At least those using mii or phylib.  If you are
using mii, then mii_ethtool_get_link_ksettings() should set it
correctly. If you are using phylib, phy_ethtool_get_link_ksettings()
will correctly set it. If you are not using either of these, you are
on your own.

Speed: 2500Mb/s and Duplex: Half is very unlikely. You really only
ever see 10 Half and occasionally 100 Half. Anything above that will
be full duplex.

It is probably best to admit the truth and use DUPLEX_UNKNOWN.

> I expect "Auto-Negotiation" is always true for cdc_ncm and
> cdc_ether devices and perhaps someone knows offhand how
> to have ethtool report "true" instead.

ethtool_link_ksettings contains three bitmaps:

supported: The capabilities of this device.
advertising: What this device is telling the link peer it can do.
lp_advertising: What the link peer is telling us it can do.

So to get Supports auto-negotiation to be true you need to set bit
ETHTOOL_LINK_MODE_Autoneg_BIT in supported.
For Advertised auto-negotiation: you need to set the same bit in
advertising. 

Auto-negotiation: off is i think from base.autoneg.

	Andrew
