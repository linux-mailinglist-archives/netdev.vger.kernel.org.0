Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2E8269538
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 20:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725964AbgINS6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 14:58:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:59302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725951AbgINS6M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 14:58:12 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE9DF217BA;
        Mon, 14 Sep 2020 18:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600109892;
        bh=9UMbd/cHJQY5hBsrdbBfsN+gjj5y8x2CwkKN0gy6Db0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Vo4rqGmT+0R8qm3dn7oO5pqDmv1mGnwCCMlFqGrelcC36odvH4NBcq8A7wNVC5P9c
         6RQ+KTQ9y1WMFRk9bi1Rcah2kZ8PeDeOAtDajo4HZU+4vbRd9Fdcb5Ob+yQzXptd9w
         zVtR4A932qh9OvQsry0eHkE6ccTcDZ8kssTVqI0M=
Date:   Mon, 14 Sep 2020 11:58:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, mkubecek@suse.cz,
        michael.chan@broadcom.com, tariqt@nvidia.com, saeedm@nvidia.com,
        alexander.duyck@gmail.com
Subject: Re: [PATCH net-next v2 1/8] ethtool: add standard pause stats
Message-ID: <20200914115809.4eb6761c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200914171808.GB3485708@lunn.ch>
References: <20200911232853.1072362-1-kuba@kernel.org>
        <20200911232853.1072362-2-kuba@kernel.org>
        <20200914014840.GD3463198@lunn.ch>
        <20200914084810.36fc1f40@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200914171808.GB3485708@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Sep 2020 19:18:08 +0200 Andrew Lunn wrote:
> On Mon, Sep 14, 2020 at 08:48:10AM -0700, Jakub Kicinski wrote:
> > On Mon, 14 Sep 2020 03:48:40 +0200 Andrew Lunn wrote:  
> > > >  static int pause_prepare_data(const struct ethnl_req_info *req_base,
> > > > @@ -34,10 +36,17 @@ static int pause_prepare_data(const struct ethnl_req_info *req_base,
> > > >  
> > > >  	if (!dev->ethtool_ops->get_pauseparam)
> > > >  		return -EOPNOTSUPP;
> > > > +
> > > >  	ret = ethnl_ops_begin(dev);
> > > >  	if (ret < 0)
> > > >  		return ret;
> > > >  	dev->ethtool_ops->get_pauseparam(dev, &data->pauseparam);
> > > > +	if (req_base->flags & ETHTOOL_FLAG_STATS &&
> > > > +	    dev->ethtool_ops->get_pause_stats) {
> > > > +		memset(&data->pausestat, 0xff,
> > > > +		       sizeof(struct ethtool_pause_stats));    
> > > 
> > > Sorry, i missed v1 of these patches. Maybe this has been commented?
> > > 
> > > Filling with 0xff is odd. I don't know of any other code doing this.  
> > 
> > Are you saying it'd be clearer to assign ETHTOOL_STAT_NOT_SET in a loop?  
> 
> Yes. In the end i figured out this is what you intended. I knew there
> had to be more to it than what i was seeing. It would be much more
> readable to just set the two values to ETHTOOL_STAT_NOT_SET. And i
> doubt it makes any difference to the compile, it is probably rolling
> the loop and just doing two assignments anyway.

Good point, thanks!
