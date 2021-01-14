Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86FE02F6766
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 18:23:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbhANRUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 12:20:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:58486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726442AbhANRUZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 12:20:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 250F023B31;
        Thu, 14 Jan 2021 17:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610644784;
        bh=3yRB9zTBm8PskaFuKrT1QxttDuA1ZGkQjvLqAKWmyVU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MeuQB6SuFG3OW7EHqAtnb6IiJiMemyxN8jaNckYUxPWjZQiMu8FKY1EVkKNngMv9I
         1aOIc9D2vg9EPxNQGkCfkuEmHqqG61a4hWLf8vXdrny+HcqRXaXTm0m9miPHjS3zMg
         GCKhnngKjYb4pu1467/DGoNh+nfZ2RSHxotuhAAmMOfnW0bHBQUyLwprzzfIKWXKTF
         vP1wrDwscQtBPJ8+Fd0rINAeRIgbAAMRRRkNqcuOIgx4+NqH1jSkTBx9AdC0/ov3K8
         zX56BUl09THOInzBpcPxI0QCXhrIW1O+lYvoy6h0Lopxa5MM2mi+nrRa3BFGAD7+4J
         1GAMbdqikBemg==
Date:   Thu, 14 Jan 2021 09:19:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v4 net-next 08/10] net: mscc: ocelot: register devlink
 ports
Message-ID: <20210114091943.3236215f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210114102743.etmvn7jq5jcgiqxk@skbuf>
References: <20210111174316.3515736-1-olteanv@gmail.com>
        <20210111174316.3515736-9-olteanv@gmail.com>
        <20210113193033.77242881@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210114102743.etmvn7jq5jcgiqxk@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jan 2021 12:27:43 +0200 Vladimir Oltean wrote:
> On Wed, Jan 13, 2021 at 07:30:33PM -0800, Jakub Kicinski wrote:
> > On Mon, 11 Jan 2021 19:43:14 +0200 Vladimir Oltean wrote:  
> > > +struct ocelot_devlink_private {
> > > +	struct ocelot *ocelot;
> > > +};  
> > 
> > I don't think you ever explained to me why you don't put struct ocelot
> > in the priv.
> > 
> > -	ocelot = devm_kzalloc(&pdev->dev, sizeof(*ocelot), GFP_KERNEL);
> > -	if (!ocelot)
> > +	devlink = devlink_alloc(&ocelot_devlink_ops, sizeof(*ocelot));
> > +	if (!devlink)
> >                  return -ENOMEM;
> > +	ocelot = devlink_priv(ocelot->devlink);  
> 
> Because that's not going to be all? The error path handling and teardown
> all need to change, because I no longer use device-managed allocation,
> and I wanted to avoid that.

Come on, is it really hard enough to warrant us exchanging multiple
emails? Having driver structure in devlink priv is the standard way
of handling this, there's value in uniformity.
