Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3169A479C00
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 19:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbhLRSW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 13:22:28 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:33528 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229729AbhLRSW1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Dec 2021 13:22:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=H/9RDnpb8mmM9JwlxdlNZiqy6DXEGBl7PHoLNnXSigQ=; b=jgDQmX8FLp2sFbde4B8BuBJi9a
        RWvTI1+hEwC5H0A+gAECdJQ0NudykSsxZ3JL0AmItUhYkrpgxQcjOmQZZ5IeS4y+tKu5B5DNIzgqT
        21uFzlOxYn7A6fnM27QeRL2AjQfuU/dN1jepctzgY1UHh6JkDYTppSqyFBdMDdByI3Y0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1myeLf-00Guva-7s; Sat, 18 Dec 2021 19:22:23 +0100
Date:   Sat, 18 Dec 2021 19:22:23 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Gabriel Hojda <ghojda@yo2urs.ro>
Cc:     Martyn Welch <martyn.welch@collabora.com>, netdev@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Markus Reichl <m.reichl@fivetechno.de>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, stable@kernel.org
Subject: Re: Issues with smsc95xx driver since a049a30fc27c
Message-ID: <Yb4m3xms1zMf5C3T@lunn.ch>
References: <199eebbd6b97f52b9119c9fa4fd8504f8a34de18.camel@collabora.com>
 <Yb4QFDQ0rFfFsT+Y@lunn.ch>
 <36f765d8450ba08cb3f8aecab0cadd89@yo2urs.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36f765d8450ba08cb3f8aecab0cadd89@yo2urs.ro>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> hi Andrew,
> 
> on my odroid-u3, with all kernel versions since 5.15.6 (where the patch was
> applied) and also with 5.16.y if tcpdump is running the network works. when
> tcpdump process is killed/stopped, networking stops working.

O.K, thanks for confirming this. It is a clue to the problem, but i
have 0 idea what it actually means, yet.

> 2.1. kernel 5.15.5 - "mii-tool -vvv eth0"
> 
> Using SIOCGMIIPHY=0x8947
> eth0: negotiated 1000baseT-HD flow-control, link ok
>   registers for MII PHY 1:
>     3100 782d 0007 c101 01e1 45e1 0001 ffff
>     ffff ffff ffff ffff ffff 0000 0000 0000
>     0040 0002 00e1 ffff 0000 0000 0000 0000
>     0b9d 0000 0000 000a 0000 00c8 0000 1058
>   product info: vendor 00:01:f0, model 16 rev 1
>   basic mode:   autonegotiation enabled
>   basic status: autonegotiation complete, link ok
>   capabilities: 1000baseT-HD 1000baseT-FD 100baseTx-FD 100baseTx-HD
> 10baseT-FD 10baseT-HD
>   advertising:  1000baseT-HD 1000baseT-FD 100baseTx-FD 100baseTx-HD
> 10baseT-FD 10baseT-HD
>   link partner: 1000baseT-HD 1000baseT-FD 100baseTx-FD 100baseTx-HD
> 10baseT-FD 10baseT-HD flow-control
> 
> 2.2. kernel 5.15.8 - "mii-tool -vvv eth0"
> 
> Using SIOCGMIIPHY=0x8947
> eth0: negotiated 1000baseT-HD flow-control, link ok
>   registers for MII PHY 1:
>     3100 782d 0007 c101 01e1 45e1 0003 ffff

                                       ^ 3 vs 1.

but otherwise, they look the same. And it has completed autoneg, and
got the same results. So i would say, the PHY is not the problem, it
is a MAC problem.

> [   23.261816] Generic PHY usb-001:002:01: attached PHY driver
> (mii_bus:phy_addr=usb-001:002:01, irq=POLL)
> 
> 3.1 kernel 5.15.8 - "dmesg | grep -i phy"
> 
> [   11.742916] Generic PHY usb-001:002:01: attached PHY driver

genphy for both.

O.K, stab in the dark. Does the hardware need to be programmed with
the MAC address? When does this happen? If this is going wrong, it
could explain the promisc mode. If the MAC address has not been
programmed, it has no idea what packets are for itself. Put it into
promisc mode, and it will receive everything, including what it is
supposed to receive. But looking at the offending patch, it is not
obvious how it has anything to do with MAC addresses. The only
unbalanced change in that patch is that smsc95xx_reset(dev) has
disappeared, not moved to somewhere else.

	Andrew
