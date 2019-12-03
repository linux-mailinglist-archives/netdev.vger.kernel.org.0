Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCE0C10FEC3
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 14:27:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbfLCN1k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 08:27:40 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35120 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726086AbfLCN1j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Dec 2019 08:27:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=eJyah7dYBX5u0LYEhSimzhwPDy/5Lpv50W9F2mk/SS4=; b=C+pXhVT8PUGcoJlnv3HYAff5f1
        XowwDMrr+z2qLllhbeyjUcC1hA4hHNgGKyq0KZUdTFOQDQDiZkuo1lj6O3TKlOZf2ZHgc/RQSavrD
        XoKAFQdLGBgy0HdviZKTkFfklGO2nhRZbWYvhXaFACF507hffcHzonPwVehoDiDaSPdg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ic8DC-0005YA-Qg; Tue, 03 Dec 2019 14:27:30 +0100
Date:   Tue, 3 Dec 2019 14:27:30 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sam Lewis <sam.vr.lewis@gmail.com>
Cc:     Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org
Subject: Re: PROBLEM: smsc95xx loses config on link down/up
Message-ID: <20191203132730.GC1234@lunn.ch>
References: <CA+ZLECteuEZJM_4gtbxiEAAKbKnJ_3UfGN4zg_m2EVxk_9=WiA@mail.gmail.com>
 <20191202134606.GA1234@lunn.ch>
 <CA+ZLECv7AcQSa1VZeeiOFJ43Vh=nfn_ptMB6XwXsfbRSz9VJ6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+ZLECv7AcQSa1VZeeiOFJ43Vh=nfn_ptMB6XwXsfbRSz9VJ6A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Basically it looks as though doing a BMCR_RESET does, in fact, reset
> every PHY R/W register bit except for those marked as "Not Affected by
> Software Reset" (NASR). This means it will reset, to the default
> value:
> 
> - Autonegotiation
> - Speed
> - Duplex
> - Auto MDIX
> - Energy Detect Power-Down
> - Auto Negotiation Advertisement
> - PHY Identification (although I don't know why you'd change this?)
> - Power down
> - Loopback
> 
> I tested this by checking the value of the BMCR register before and
> after doing a BMCR_RESET and it did reset the BMCR register to its
> default values.

O.K, not what we want.

So there are two different paths here you can follow:

1) Moving the reset out of open and into bind.
2) Re-write the driver to make use of the core phylib support.

1) is probably the quick and simple solution, but watch out for
suspend/resume.

2) is more work, but brings the driver into line with other MAC
drivers. phylib would then program the PHY, maybe via PHY driver. It
would do this during open, using state information. So it should
correctly handle state change while the interface is down, or
suspended etc.

The USB-ethernet drivers lan78xx and ax88172a both use phylib.  They
can give you ideas how this should work.

drivers/net/phy/smsc.c might be a good basis for a PHY driver, but it
looks like you will need to extend it for MDIX, etc.

      Andrew
