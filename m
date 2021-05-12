Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35D3737BCA9
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 14:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232869AbhELMjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 08:39:43 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36870 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232856AbhELMjm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 08:39:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=OJJr8CZTbZhq52U3R30ulRa0ODzw83ZeiqAf+DqB3O0=; b=pacQotNKRZo+ykt5hJEFh1OaoN
        GBg7Cp2d0smTSvP5G8drNk4rVT5ZLyKMmExcrltDv/1Zr3Clt/HPshs4fG6paFM1OdlWG/d4bEMiE
        4cTXPN0A1vgNikU5CbHSmFwFsgFMKCLFh2iowTpzEsvJJ2ocGsCNY9xIFu88OxqlG094=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lgo89-003uFc-Dt; Wed, 12 May 2021 14:38:25 +0200
Date:   Wed, 12 May 2021 14:38:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Peter Geis <pgwipeout@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>
Subject: Re: [PATCH v2] net: phy: add driver for Motorcomm yt8511 phy
Message-ID: <YJvMQWPW1eT5Wo/4@lunn.ch>
References: <20210511225913.2951922-1-pgwipeout@gmail.com>
 <YJsl7rLVI6ShqZvI@lunn.ch>
 <CAMdYzYrbzk60=XvU4dEeb9QriKDXD1bDEbL86nD+yZjbik-E3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMdYzYrbzk60=XvU4dEeb9QriKDXD1bDEbL86nD+yZjbik-E3g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Peter

> A lot of items should be set up via the device tree, though it seems
> this is a relatively unused concept in the net phy subsystem.

Very little should be set up via device tree, since it does not
describe the hardware. The interface mode does describe the hardware,
so that is expected to be in DT, but not too much else.

> > Do you know which one of the four RGMII modes your setup needs? Is the
> > PHY adding the Rx and Tx delays? So "rgmii-id"?
> 
> By default it implements a 500ps delay internally on the txd clock and
> a 1.2 ns delay on the rx clock.
> The controller is the snps,dwmac-4.20a, and it implements a default
> delay as well.

O.K, that is confusing. We generally recommend that the MAC does not
add delays, the PHY does it. So maybe you can implement "rgmii-id" in
the PHY, and return -EOPNOTSUP for the other three RGMII modes, as a
minimum. However dwmac is one of the oddball drivers which does
sometime add the delays, and always sets the PHY to "rgmii" so it does
not add delays. Either way, is O.K, but please avoid having some of
the delay on one side, and the rest on the other.

	Andrew
