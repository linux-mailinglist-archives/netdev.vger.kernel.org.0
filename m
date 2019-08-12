Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B38B589859
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 09:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbfHLHzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 03:55:42 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:36973 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbfHLHzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 03:55:42 -0400
X-Originating-IP: 86.250.200.211
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 362F1240003;
        Mon, 12 Aug 2019 07:55:40 +0000 (UTC)
Date:   Mon, 12 Aug 2019 09:55:39 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Matt Pelland <mpelland@starry.com>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, maxime.chevallier@bootlin.com
Subject: Re: [PATCH v2 net-next 2/2] net: mvpp2: support multiple comphy lanes
Message-ID: <20190812075539.GA3698@kwain>
References: <20190808230606.7900-1-mpelland@starry.com>
 <20190808230606.7900-3-mpelland@starry.com>
 <20190809083250.GB3516@kwain>
 <20190809222028.GB1320@cohiba>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190809222028.GB1320@cohiba>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Matt,

On Fri, Aug 09, 2019 at 06:20:28PM -0400, Matt Pelland wrote:
> On Fri, Aug 09, 2019 at 10:32:50AM +0200, Antoine Tenart wrote:
> > On Thu, Aug 08, 2019 at 07:06:06PM -0400, Matt Pelland wrote:
> > > @@ -5084,14 +5107,38 @@ static int mvpp2_port_probe(struct platform_device *pdev,
> > >  		goto err_free_netdev;
> > >  	}
> > >  
> > > +	port = netdev_priv(dev);
> > > +
> > >  	if (port_node) {
> > > -		comphy = devm_of_phy_get(&pdev->dev, port_node, NULL);
> > > -		if (IS_ERR(comphy)) {
> > > -			if (PTR_ERR(comphy) == -EPROBE_DEFER) {
> > > -				err = -EPROBE_DEFER;
> > > -				goto err_free_netdev;
> > > +		for (i = 0, ncomphys = 0; i < ARRAY_SIZE(port->comphys); i++) {
> > > +			port->comphys[i] = devm_of_phy_get_by_index(&pdev->dev,
> > > +								    port_node,
> > > +								    i);
> > > +			if (IS_ERR(port->comphys[i])) {
> > > +				err = PTR_ERR(port->comphys[i]);
> > > +				port->comphys[i] = NULL;
> > > +				if (err == -EPROBE_DEFER)
> > > +					goto err_free_netdev;
> > > +				err = 0;
> > > +				break;
> > >  			}
> > > -			comphy = NULL;
> > > +
> > > +			++ncomphys;
> > > +		}
> > > +
> > > +		if (phy_mode == PHY_INTERFACE_MODE_XAUI)
> > > +			nrequired_comphys = 4;
> > > +		else if (phy_mode == PHY_INTERFACE_MODE_RXAUI)
> > > +			nrequired_comphys = 2;
> > > +		else
> > > +			nrequired_comphys = 1;
> > > +
> > > +		if (ncomphys < nrequired_comphys) {
> > > +			dev_err(&pdev->dev,
> > > +				"not enough comphys to support %s\n",
> > > +				phy_modes(phy_mode));
> > > +			err = -EINVAL;
> > > +			goto err_free_netdev;
> > 
> > The comphy is optional and could not be described (some SoC do not have
> > a driver for their comphy, and some aren't described at all). In such
> > cases we do rely on the bootloader/firmware configuration. Also, I'm not
> > sure how that would work with dynamic reconfiguration of the mode if the
> > n# of lanes used changes (I'm not sure that is possible though).
> > 
> 
> I'm new to this space, but, from my limited experience it seems unlikely that
> some hardware configuration would require dynamically reconfiguring the number
> of comphy lanes used depending on the phy mode. Unless you disagree, instead of
> removing this check or making things really complicated to support this
> scenario, I propose extending the conditional above to disable sanity checking
> if no comphys were parsed out of the device tree. Something like:
> 
> if (ncomphys != 0 && ncomphys < nrequired_comphys)
> 
> This would cover Maxime's request for sanity checking, which I think is
> valuable, while also maintaining compatibility with platforms that have no
> comphy drivers or some other issue that prevents properly defining comphy nodes
> in the device tree. Does that sound reasonable?

That sounds good.

Thanks!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
