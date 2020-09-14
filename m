Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0942692E2
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 19:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbgINRTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 13:19:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33868 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726055AbgINRSU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 13:18:20 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kHs7E-00Ednt-3S; Mon, 14 Sep 2020 19:18:08 +0200
Date:   Mon, 14 Sep 2020 19:18:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, mkubecek@suse.cz,
        michael.chan@broadcom.com, tariqt@nvidia.com, saeedm@nvidia.com,
        alexander.duyck@gmail.com
Subject: Re: [PATCH net-next v2 1/8] ethtool: add standard pause stats
Message-ID: <20200914171808.GB3485708@lunn.ch>
References: <20200911232853.1072362-1-kuba@kernel.org>
 <20200911232853.1072362-2-kuba@kernel.org>
 <20200914014840.GD3463198@lunn.ch>
 <20200914084810.36fc1f40@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200914084810.36fc1f40@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 08:48:10AM -0700, Jakub Kicinski wrote:
> On Mon, 14 Sep 2020 03:48:40 +0200 Andrew Lunn wrote:
> > >  static int pause_prepare_data(const struct ethnl_req_info *req_base,
> > > @@ -34,10 +36,17 @@ static int pause_prepare_data(const struct ethnl_req_info *req_base,
> > >  
> > >  	if (!dev->ethtool_ops->get_pauseparam)
> > >  		return -EOPNOTSUPP;
> > > +
> > >  	ret = ethnl_ops_begin(dev);
> > >  	if (ret < 0)
> > >  		return ret;
> > >  	dev->ethtool_ops->get_pauseparam(dev, &data->pauseparam);
> > > +	if (req_base->flags & ETHTOOL_FLAG_STATS &&
> > > +	    dev->ethtool_ops->get_pause_stats) {
> > > +		memset(&data->pausestat, 0xff,
> > > +		       sizeof(struct ethtool_pause_stats));  
> > 
> > Sorry, i missed v1 of these patches. Maybe this has been commented?
> > 
> > Filling with 0xff is odd. I don't know of any other code doing this.
> 
> Are you saying it'd be clearer to assign ETHTOOL_STAT_NOT_SET in a loop?

Yes. In the end i figured out this is what you intended. I knew there
had to be more to it than what i was seeing. It would be much more
readable to just set the two values to ETHTOOL_STAT_NOT_SET. And i
doubt it makes any difference to the compile, it is probably rolling
the loop and just doing two assignments anyway.

    Andrew
