Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5A3A4288E5
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 10:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235023AbhJKIha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 04:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235036AbhJKIh2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 04:37:28 -0400
X-Greylist: delayed 1071 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 11 Oct 2021 01:35:29 PDT
Received: from the.earth.li (the.earth.li [IPv6:2a00:1098:86:4d:c0ff:ee:15:900d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F341C061570;
        Mon, 11 Oct 2021 01:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=earth.li;
         s=the; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject
        :Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=TYZ7CwTRqEK9lxCyhZgva6Vn0NU/a/+4iDV6XZLG43c=; b=e8afmPJT+DmeXOoXTW3z2NUdGx
        5do9JWJIJpr7rk1F7F9New19qmGhY4HT45WT2obHDr4ceXihutgcxtedgphoCSdO7kswGDLvkLGz3
        8XQvpyzrOMZq9twcx0YoUYoZjswRudgUBppexqXGehMJE4aI+D+OyrZdPhfaqfr1hShDr9QP/0wbE
        ezp1AelwpXfUJeA/NFiPnS694aVr6uIDNFr1T2JTo6+sUXqi52xdwYVg9ZoI9UZQtwaB4PxYNa/f3
        0md5JAdltYhYLQtgHEnQb5syCaZVNR/MhBut7fOGeVyyiyioBfLPXT+qvLVh6IhGjC8Mv6T6uKe8N
        BaQ73stg==;
Received: from noodles by the.earth.li with local (Exim 4.92)
        (envelope-from <noodles@earth.li>)
        id 1mZqUz-0001JQ-Kk; Mon, 11 Oct 2021 09:17:29 +0100
Date:   Mon, 11 Oct 2021 09:17:29 +0100
From:   Jonathan McDowell <noodles@earth.li>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH v4 04/13] drivers: net: dsa: qca8k: add support
 for cpu port 6
Message-ID: <20211011081729.GV2705@earth.li>
References: <20211010111556.30447-1-ansuelsmth@gmail.com>
 <20211010111556.30447-5-ansuelsmth@gmail.com>
 <20211010124243.lhbh46pkwribztrl@skbuf>
 <YWLpKRaz0dQ4Y+Nn@Ansuel-xps.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YWLpKRaz0dQ4Y+Nn@Ansuel-xps.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 10, 2021 at 03:22:49PM +0200, Ansuel Smith wrote:
> On Sun, Oct 10, 2021 at 03:42:43PM +0300, Vladimir Oltean wrote:
> > On Sun, Oct 10, 2021 at 01:15:47PM +0200, Ansuel Smith wrote:
> > > Currently CPU port is always hardcoded to port 0. This switch have 2 CPU
> > > port. The original intention of this driver seems to be use the
> > > mac06_exchange bit to swap MAC0 with MAC6 in the strange configuration
> > > where device have connected only the CPU port 6. To skip the
> > > introduction of a new binding, rework the driver to address the
> > > secondary CPU port as primary and drop any reference of hardcoded port.
> > > With configuration of mac06 exchange, just skip the definition of port0
> > > and define the CPU port as a secondary. The driver will autoconfigure
> > > the switch to use that as the primary CPU port.
...
> > If I were to trust the documentation, that DSA headers are enabled on
> > port 0 when the driver does this:
> > 
> > 	/* Enable CPU Port */
> > 	ret = qca8k_reg_set(priv, QCA8K_REG_GLOBAL_FW_CTRL0,
> > 			    QCA8K_GLOBAL_FW_CTRL0_CPU_PORT_EN);
> > 
> > doesn't that mean that using port 0 as a user port is double-broken,
> > since this would implicitly enable DSA headers on it?
> > 
> > Or is the idea of using port 6 as the CPU port to be able to use SGMII,
> > which is not available on port 0? Jonathan McDowell did some SGMII
> > configuration for the CPU port in commit f6dadd559886 ("net: dsa: qca8k:
> > Improve SGMII interface handling"). If the driver supports only port 0
> > as CPU port, and SGMII is only available on port 6, how did he do it?
> > 
> 
> I think the dotted thing in the diagram about sgmii is about the fact
> that you can use sgmii for both port0 or port6. (the switch configuration
> support only ONE sgmii) We have device that have such configuration
> (port0 set to sgmii) without the mac06 exchange bit set.

That's certainly the case for my device; the SGMII connection is treated
as port 0 (and connected to the CPU via that) and then port 6 uses its
own RGMII connection (both port0 + port6 have their own dedicated RGMII
pins on the chip, and then the SGMII is shared and selectable).

J.

-- 
If plugging it in doesn't help, turn it on.
