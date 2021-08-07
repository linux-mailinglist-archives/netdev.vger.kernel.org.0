Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 460703E32AE
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 04:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbhHGCSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 22:18:21 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37756 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229510AbhHGCSU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Aug 2021 22:18:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=DVXxVGh8uutr6sPk3F12TA8iv2EQY2P3e5OzaARwm2Y=; b=lb0m7SPTvZlcq8XOa2yyjAzxrc
        PD6ycoJTHmsvoxXJ6OHrk0B8pszYN2/n1RmlmEwUnuIL0Dgppgz6ndnlM+t3eGvbHgpi6JLW8ybWT
        solriqFb89KrRMeAsH2+/S4BCALmpUBNo3ybRjgHV/xST1XrjuJr+oHgsjg3ytTk9/5s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mCBuP-00GRzI-Ir; Sat, 07 Aug 2021 04:17:57 +0200
Date:   Sat, 7 Aug 2021 04:17:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Fei Qin <fei.qin@corigine.com>,
        Louis Peens <louis.peens@corigine.com>
Subject: Re: [PATCH net] nfp: update ethtool reporting of pauseframe control
Message-ID: <YQ3tVX0CSUad9M1B@lunn.ch>
References: <20210803103911.22639-1-simon.horman@corigine.com>
 <YQlaxfef22GxTF9r@lunn.ch>
 <20210803155023.GC17597@corigine.com>
 <20210806093856.GA28022@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210806093856.GA28022@corigine.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 06, 2021 at 11:38:57AM +0200, Simon Horman wrote:
> On Tue, Aug 03, 2021 at 05:50:26PM +0200, Simon Horman wrote:
> > On Tue, Aug 03, 2021 at 05:03:33PM +0200, Andrew Lunn wrote:
> > > On Tue, Aug 03, 2021 at 12:39:11PM +0200, Simon Horman wrote:
> > > > From: Fei Qin <fei.qin@corigine.com>
> > > > 
> > > > Pauseframe control is set to symmetric mode by default on the NFP.
> > > > Pause frames can not be configured through ethtool now, but ethtool can
> > > > report the supported mode.
> > > > 
> > > > Fixes: 265aeb511bd5 ("nfp: add support for .get_link_ksettings()")
> > > > Signed-off-by: Fei Qin <fei.qin@corigine.com>
> > > > Signed-off-by: Louis Peens <louis.peens@corigine.com>
> > > > Signed-off-by: Simon Horman <simon.horman@corigine.com>
> > > > ---
> > > >  drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c | 2 ++
> > > >  1 file changed, 2 insertions(+)
> > > > 
> > > > diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
> > > > index 1b482446536d..8803faadd302 100644
> > > > --- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
> > > > +++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
> > > > @@ -286,6 +286,8 @@ nfp_net_get_link_ksettings(struct net_device *netdev,
> > > >  
> > > >  	/* Init to unknowns */
> > > >  	ethtool_link_ksettings_add_link_mode(cmd, supported, FIBRE);
> > > > +	ethtool_link_ksettings_add_link_mode(cmd, supported, Pause);
> > > > +	ethtool_link_ksettings_add_link_mode(cmd, advertising, Pause);
> > > 
> > > Hi Simon
> > > 
> > > Does it act on the results of the pause auto-neg? If the link peer
> > > says it does not support pause, will it turn pause off?
> > 
> > Thanks Andrew,
> > 
> > I'll try and get an answer to that question for you.
> 
> Hi Andrew,
> 
> The simple answer to those questions is no.

Hi Simon

Then please send a patch removing Pause from advertising, and ensure
your PHY, SERDES etc, does not advertise it.

It seems like all the smart NICs get pause wrong.

   Andrew
