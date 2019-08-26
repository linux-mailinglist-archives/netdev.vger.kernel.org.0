Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1E739D609
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 20:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387422AbfHZSyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 14:54:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60540 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727559AbfHZSyV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Aug 2019 14:54:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=kMg9jo2+aYpxinBPCrA/TYwqW4S7g/A5UlAFqVagOUQ=; b=erZ8mhBubPFIsVncmO3w8aNL9C
        gMrNs54KZCvWdnlFzAoUCXAHWwEjQD/W641MZwGGJ9Q1c1Dv7Mws7xEav867mwI7CVSXrlQgeaqZR
        kEVzsGlKb7jfke5duLuKGPYlub3KK1QrZbwqwO1hgl41tLqC8viu5Gx6jA+5pJvCzJdg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i2K8A-0006Av-Tr; Mon, 26 Aug 2019 20:54:18 +0200
Date:   Mon, 26 Aug 2019 20:54:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Voon Weifeng <weifeng.voon@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jose Abreu <joabreu@synopsys.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: Re: [PATCH v1 net-next] net: phy: mdio_bus: make mdiobus_scan also
 cover PHY that only talks C45
Message-ID: <20190826185418.GG2168@lunn.ch>
References: <1566870769-9967-1-git-send-email-weifeng.voon@intel.com>
 <e9ece5ad-a669-6d6b-d050-c633cad15476@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9ece5ad-a669-6d6b-d050-c633cad15476@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 26, 2019 at 11:27:53AM -0700, Florian Fainelli wrote:
> On 8/26/19 6:52 PM, Voon Weifeng wrote:
> > From: Ong Boon Leong <boon.leong.ong@intel.com>
> > 
> > Make mdiobus_scan() to try harder to look for any PHY that only talks C45.
> If you are not using Device Tree or ACPI, and you are letting the MDIO
> bus be scanned, it sounds like there should be a way for you to provide
> a hint as to which addresses should be scanned (that's
> mii_bus::phy_mask) and possibly enhance that with a mask of possible C45
> devices?

Yes, i don't like this unconditional c45 scanning. A lot of MDIO bus
drivers don't look for the MII_ADDR_C45. They are going to do a C22
transfer, and maybe not mask out the MII_ADDR_C45 from reg, causing an
invalid register write. Bad things can then happen.

With DT and ACPI, we have an explicit indication that C45 should be
used, so we know on this platform C45 is safe to use. We need
something similar when not using DT or ACPI.

	  Andrew
