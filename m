Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB2FB3A3A4D
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 05:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbhFKDhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 23:37:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58080 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230479AbhFKDhV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 23:37:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=jrzkXDGoUHtqmy4odHiE/JuI9qwK6iCvH8gOoN3YBxM=; b=rdBay5upgW2U5MUQkDPt/P/0m4
        e0+qnNrHQjb2a4L1mdjD/jl5w8Pjjdsod6QAgbV6ZKohmvrOWsQvAUUrw+jbLOKT8Z2mVH+2aloFX
        uxCsCfHkdYHE93UT+jlbJLAxYIbJ1Q43gCtbmXJOxMHrSb2GA757/is7qgp+vnoGqi60=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lrXx4-008mbn-7z; Fri, 11 Jun 2021 05:35:22 +0200
Date:   Fri, 11 Jun 2021 05:35:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH net-next] net: mdio: mscc-miim: Use
 devm_platform_get_and_ioremap_resource()
Message-ID: <YMLZ+k0rjlZY9+7b@lunn.ch>
References: <20210610091154.4141911-1-yangyingliang@huawei.com>
 <YMI3VsR/jnVVhmsh@lunn.ch>
 <fd9cbc9c-478e-85c8-62ec-58a8baf4333c@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd9cbc9c-478e-85c8-62ec-58a8baf4333c@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 09:35:04AM +0800, Yang Yingliang wrote:
> Hi,
> 
> On 2021/6/11 0:01, Andrew Lunn wrote:
> > > -	dev->regs = devm_ioremap_resource(&pdev->dev, res);
> > > +	dev->regs = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
> > >   	if (IS_ERR(dev->regs)) {
> > Here, only dev->regs is considered.
> > 
> > >   		dev_err(&pdev->dev, "Unable to map MIIM registers\n");
> > >   		return PTR_ERR(dev->regs);
> > >   	}
> > 
> > 
> > > +	dev->phy_regs = devm_platform_get_and_ioremap_resource(pdev, 1, &res);
> > > +	if (res && IS_ERR(dev->phy_regs)) {
> > Here you look at both res and dev->phy_regs.
> > 
> > This seems inconsistent. Can devm_platform_get_and_ioremap_resource()
> > return success despite res being NULL?
> No, if res is NULL, devm_platform_get_and_ioremap_resource() returns failed.
> But, before this patch, if the internal phy res is NULL, it doesn't return
> error
> code, so I checked the res to make sure it doesn't change the origin code
> logic.

O.K, so IORESOURCE_MEM, 1 is optional. By making this change, i think
you have made this less clear. So i would say it is O.K. to change the
first platform_get_resource(pdev, IORESOURCE_MEM, 0) and
devm_ioremap_resource(&pdev->dev, res) to one call, but i would leave
the second pair alone.

    Andrew
