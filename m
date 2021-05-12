Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1808F37B36C
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 03:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbhELBXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 21:23:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36330 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230160AbhELBXS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 21:23:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=V+QU720r/geJ3p2g/reVdhvDx7qmxUNQjNqPPL7tBkA=; b=JU/JIWaWZksnzdbA1cXNFH2rVu
        EDe5htfrBswMx4i5/5nqPdnTgg7lUKVIpYIp8FepVoYt0EIiY65wkYZgLqKoEaxl4ewdXg2bPUC+K
        zfbFMAdWkJoMmuZx0/gIARWsdR4h+ugcCbog2bfZk4+LM5PMZ3M4z4Fe4D36XXiBaxaM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lgdZd-003qVC-9C; Wed, 12 May 2021 03:22:05 +0200
Date:   Wed, 12 May 2021 03:22:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: forcedeth: Give bot handlers a helping hand
 understanding the code
Message-ID: <YJstvUmKGp5Nr5yS@lunn.ch>
References: <20210511124330.891694-1-andrew@lunn.ch>
 <e267c38d-5ddd-244a-d083-9dbe4ed9973c@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e267c38d-5ddd-244a-d083-9dbe4ed9973c@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 11, 2021 at 09:48:11PM +0800, Leizhen (ThunderTown) wrote:
> 
> 
> On 2021/5/11 20:43, Andrew Lunn wrote:
> > Bots handlers repeatedly fail to understand nv_update_linkspeed() and
> > submit patches unoptimizing it for the human reader. Add a comment to
> > try to prevent this in the future.
> > 
> > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> > ---
> >  drivers/net/ethernet/nvidia/forcedeth.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
> > index 8724d6a9ed02..0822b28f3b6a 100644
> > --- a/drivers/net/ethernet/nvidia/forcedeth.c
> > +++ b/drivers/net/ethernet/nvidia/forcedeth.c
> > @@ -3475,6 +3475,9 @@ static int nv_update_linkspeed(struct net_device *dev)
> >  		newls = NVREG_LINKSPEED_FORCE|NVREG_LINKSPEED_10;
> >  		newdup = 0;
> >  	} else {
> > +		/* Default to the same as 10/Half if we cannot
> > +		 * determine anything else.
> > +		 */
> I think it would be better to remove the if branch above and then add comments here.
> Otherwise, it becomes more and more redundant.

I kind of agree with you. However, we have seen at least four times,
that bots and their master are incapable of understanding this code
and try to unoptimize its readabilty/understandability. So we need to
add redundancy so hopefully the masters of these bots will understand
this code, see that it is correct, and leave it alone.

The other option is to work on the bot. Look at all the cases it got
it wrong, the code is in fact correct, but the bot could not see
why. Figure out the common pattern for why it got it wrong, and fix
the bot.

Or we can also add tools to aid the master. We know the bot gets it
wrong sometimes. The master also seems to get it wrong, and blindly
changes the code without understanding it. The maintainers then reject
it. That rejection is logged, it is available in lore. A tool which
can search lore for a similar patch which has been rejected before
seems like it would be useful for all bots. It would cut down on
wasted time of bot masters generating wrong patches and maintainers
rejecting them.

    Andrew
