Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7C2301986
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 05:48:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbhAXEqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 23:46:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:43358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726501AbhAXEpt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 Jan 2021 23:45:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBA3E22581;
        Sun, 24 Jan 2021 04:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611463508;
        bh=2W8S2/Nk3yt4aV2D4GRguNU0gmNFUxnpsmQZ+9VHVIA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=A6OpuQWmLV/02w5eZmM3dTbQ9aQ2PAB8Wxi6yP9dBqsuxiGtBaeU3a3vA5IXZPnft
         UyQGoGHXLWVKbFWuc0ed37lC5KkCsRfRgf00bggaoWPETCRnyY4a9QlbalCNpiHihN
         LyicNwjliUZNHLFsIgFmRC59R/JU6UKxIGaNPxiNpI96eAF2z5Ez9BN+iSlg2b23QJ
         bexk13MMtTmKUwcXmOQguXw28k/c2u8ez5Zj+Dl3SD8IvhluPAKOOvp+gbj1HUJPfi
         qQKb2kaUXCilnuyB35hvNbrUtFUbdXv3hJHb1W3WqIs4Igr/63pklP5MtD+iNNSvLe
         qDPNrQZAzKmdA==
Date:   Sat, 23 Jan 2021 20:45:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     Xie He <xie.he.0141@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v5] net: lapb: Add locking to the lapb module
Message-ID: <20210123204507.35c895db@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <b42575d44fb7f5c1253635a19c3e21e2@dev.tdt.de>
References: <20210121002129.93754-1-xie.he.0141@gmail.com>
        <b42575d44fb7f5c1253635a19c3e21e2@dev.tdt.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Jan 2021 10:07:05 +0100 Martin Schiller wrote:
> On 2021-01-21 01:21, Xie He wrote:
> > In the lapb module, the timers may run concurrently with other code in
> > this module, and there is currently no locking to prevent the code from
> > racing on "struct lapb_cb". This patch adds locking to prevent racing.
> > 
> > 1. Add "spinlock_t lock" to "struct lapb_cb"; Add "spin_lock_bh" and
> > "spin_unlock_bh" to APIs, timer functions and notifier functions.
> > 
> > 2. Add "bool t1timer_stop, t2timer_stop" to "struct lapb_cb" to make us
> > able to ask running timers to abort; Modify "lapb_stop_t1timer" and
> > "lapb_stop_t2timer" to make them able to abort running timers;
> > Modify "lapb_t2timer_expiry" and "lapb_t1timer_expiry" to make them
> > abort after they are stopped by "lapb_stop_t1timer", 
> > "lapb_stop_t2timer",
> > and "lapb_start_t1timer", "lapb_start_t2timer".
> > 
> > 3. Let lapb_unregister wait for other API functions and running timers
> > to stop.
> > 
> > 4. The lapb_device_event function calls lapb_disconnect_request. In
> > order to avoid trying to hold the lock twice, add a new function named
> > "__lapb_disconnect_request" which assumes the lock is held, and make
> > it called by lapb_disconnect_request and lapb_device_event.
> > 
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Cc: Martin Schiller <ms@dev.tdt.de>
> > Signed-off-by: Xie He <xie.he.0141@gmail.com>  
> 
> I don't have the opportunity to test this at the moment, but code looks
> reasonable so far. Have you tested this at runtime?

Are you okay with this being merged or would you like to review
further/test?

Nothing jumps out to me either (other than a few nit picks).

> > Change from v4:
> > Make lapb_unregister wait for other refs to "lapb" to drop, to ensure
> > that other LAPB API calls have all finished.
> > 
> > Change from v3:
> > In lapb_unregister make sure the self-restarting t1timer has really 
> > been
> > stopped.
> > 
> > Change from v2:
> > Create a new __lapb_disconnect_request function to reduce redundant 
> > code.
> > 
> > Change from v1:
> > Broke long lines to keep the line lengths within 80 characters.

> > @@ -178,11 +182,23 @@ int lapb_unregister(struct net_device *dev)
> >  		goto out;
> >  	lapb_put(lapb);
> > 
> > +	/* Wait for other refs to "lapb" to drop */
> > +	while (refcount_read(&lapb->refcnt) > 2)
> > +		;

Tight loop like this is a little scary, perhaps add a small
usleep_range() here?

> > +
> > +	spin_lock_bh(&lapb->lock);
> > +
> >  	lapb_stop_t1timer(lapb);
> >  	lapb_stop_t2timer(lapb);
> > 
> >  	lapb_clear_queues(lapb);
> > 
> > +	spin_unlock_bh(&lapb->lock);
> > +
> > +	/* Wait for running timers to stop */
> > +	del_timer_sync(&lapb->t1timer);
> > +	del_timer_sync(&lapb->t2timer);
> > +
> >  	__lapb_remove_cb(lapb);
> > 
> >  	lapb_put(lapb);

> > -int lapb_disconnect_request(struct net_device *dev)
> > +static int __lapb_disconnect_request(struct lapb_cb *lapb)
> >  {
> > -	struct lapb_cb *lapb = lapb_devtostruct(dev);
> > -	int rc = LAPB_BADTOKEN;
> > -
> > -	if (!lapb)
> > -		goto out;
> > -
> >  	switch (lapb->state) {
> >  	case LAPB_STATE_0:
> > -		rc = LAPB_NOTCONNECTED;
> > -		goto out_put;
> > +		return LAPB_NOTCONNECTED;
> > 
> >  	case LAPB_STATE_1:
> >  		lapb_dbg(1, "(%p) S1 TX DISC(1)\n", lapb->dev);
> > @@ -310,12 +328,10 @@ int lapb_disconnect_request(struct net_device 
> > *dev)
> >  		lapb_send_control(lapb, LAPB_DISC, LAPB_POLLON, LAPB_COMMAND);
> >  		lapb->state = LAPB_STATE_0;
> >  		lapb_start_t1timer(lapb);
> > -		rc = LAPB_NOTCONNECTED;
> > -		goto out_put;
> > +		return LAPB_NOTCONNECTED;
> > 
> >  	case LAPB_STATE_2:
> > -		rc = LAPB_OK;
> > -		goto out_put;
> > +		return LAPB_OK;
> >  	}
> > 
> >  	lapb_clear_queues(lapb);
> > @@ -328,8 +344,22 @@ int lapb_disconnect_request(struct net_device 
> > *dev)
> >  	lapb_dbg(1, "(%p) S3 DISC(1)\n", lapb->dev);
> >  	lapb_dbg(0, "(%p) S3 -> S2\n", lapb->dev);
> > 
> > -	rc = LAPB_OK;
> > -out_put:
> > +	return LAPB_OK;
> > +}

Since this is a fix for net, I'd advise against converting the goto
into direct returns (as much as I generally like such conversion).


