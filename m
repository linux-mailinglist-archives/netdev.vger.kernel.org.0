Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE83943530B
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 20:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbhJTSws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 14:52:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49292 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231328AbhJTSwr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 14:52:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=F34CO4kJ2wlEtjVzrikO0cx1FdgTWcUmymX9zm/E3dc=; b=5ngATRZbztJzzNL+dFEJjjk3JB
        YmVvg796mdYlh7ep4ayNoCLyGGCchsBx9XZUjOeooNBzUYhts+VG1sUMzEHt8+wUdRVd0Fq71P29Y
        rQXQr04skMBB70z1LToITrVa+zFx1wfvrwLgBSDkF2wcVMt3zbnnzX28P2oADYZ/IDEg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mdGfS-00BDIQ-4A; Wed, 20 Oct 2021 20:50:26 +0200
Date:   Wed, 20 Oct 2021 20:50:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: fec: defer probe if PHY on external MDIO bus is not
 available
Message-ID: <YXBk8gwuCqrxDbVY@lunn.ch>
References: <20211014113043.3518-1-matthias.schiffer@ew.tq-group.com>
 <YW7SWKiUy8LfvSkl@lunn.ch>
 <aae9573f89560a32da0786dc90cb7be0331acad4.camel@ew.tq-group.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aae9573f89560a32da0786dc90cb7be0331acad4.camel@ew.tq-group.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > I've not looked at the details yet, just back from vacation. But this
> > seems wrong. I would of expected phylib to of returned -EPRODE_DEFER
> > at some point, when asked for a PHY which does not exist yet. All the
> > driver should need to do is make sure it returns the
> > -EPRODE_DEFER.
> 
> This is what I expected as well, however there are a few complications:
> 
> - At the moment the first time the driver does anything with the PHY is
>   in fec_enet_open(), not in fec_probe() - way too late to defer
>   anything

O.K. Right. Are you using NFS root? For normal user space opening of
the interface, this has all been sorted out by the time user space
does anything. The NFS root changes the time in a big way.

Anyway, i would say some bits of code need moving from open to probe
so EPROBE_DEFER can be used.

We already have:

        phy_node = of_parse_phandle(np, "phy-handle", 0);
        if (!phy_node && of_phy_is_fixed_link(np)) {
                ret = of_phy_register_fixed_link(np);
                if (ret < 0) {
                        dev_err(&pdev->dev,
                                "broken fixed-link specification\n");
                        goto failed_phy;
                }
                phy_node = of_node_get(np);
        }
        fep->phy_node = phy_node;

Go one step further. If fep->phy_node is not NULL, we know there
should be a PHY. So call of_phy_find_device(). If it returns NULL,
then -EPROBE_DEFER. Otherwise store the phydev into fep, and use it in
open.

You will need to move the call to fec_enet_mii_init(pdev) earlier, so
the MDIO bus is available.

    Andrew
