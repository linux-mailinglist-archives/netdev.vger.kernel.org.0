Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF18302245
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 07:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbhAYGzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 01:55:24 -0500
Received: from mxout70.expurgate.net ([194.37.255.70]:50531 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727145AbhAYGrn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 01:47:43 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1l3vcN-0007HZ-DA; Mon, 25 Jan 2021 07:44:55 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1l3vcM-0007H5-BC; Mon, 25 Jan 2021 07:44:54 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id EBA88240041;
        Mon, 25 Jan 2021 07:44:53 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 793EE240040;
        Mon, 25 Jan 2021 07:44:53 +0100 (CET)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id D3BCE2064A;
        Mon, 25 Jan 2021 07:44:52 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 25 Jan 2021 07:44:52 +0100
From:   Martin Schiller <ms@dev.tdt.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Xie He <xie.he.0141@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v5] net: lapb: Add locking to the lapb module
Organization: TDT AG
In-Reply-To: <20210123204507.35c895db@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210121002129.93754-1-xie.he.0141@gmail.com>
 <b42575d44fb7f5c1253635a19c3e21e2@dev.tdt.de>
 <20210123204507.35c895db@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Message-ID: <4eed4c14ad7065c902c4de8f6d86b58e@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.16
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
X-purgate: clean
X-purgate-ID: 151534::1611557094-00000D41-25A4B177/0/0
X-purgate-type: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-01-24 05:45, Jakub Kicinski wrote:
> On Fri, 22 Jan 2021 10:07:05 +0100 Martin Schiller wrote:
>> On 2021-01-21 01:21, Xie He wrote:
>> > In the lapb module, the timers may run concurrently with other code in
>> > this module, and there is currently no locking to prevent the code from
>> > racing on "struct lapb_cb". This patch adds locking to prevent racing.
>> >
>> > 1. Add "spinlock_t lock" to "struct lapb_cb"; Add "spin_lock_bh" and
>> > "spin_unlock_bh" to APIs, timer functions and notifier functions.
>> >
>> > 2. Add "bool t1timer_stop, t2timer_stop" to "struct lapb_cb" to make us
>> > able to ask running timers to abort; Modify "lapb_stop_t1timer" and
>> > "lapb_stop_t2timer" to make them able to abort running timers;
>> > Modify "lapb_t2timer_expiry" and "lapb_t1timer_expiry" to make them
>> > abort after they are stopped by "lapb_stop_t1timer",
>> > "lapb_stop_t2timer",
>> > and "lapb_start_t1timer", "lapb_start_t2timer".
>> >
>> > 3. Let lapb_unregister wait for other API functions and running timers
>> > to stop.
>> >
>> > 4. The lapb_device_event function calls lapb_disconnect_request. In
>> > order to avoid trying to hold the lock twice, add a new function named
>> > "__lapb_disconnect_request" which assumes the lock is held, and make
>> > it called by lapb_disconnect_request and lapb_device_event.
>> >
>> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>> > Cc: Martin Schiller <ms@dev.tdt.de>
>> > Signed-off-by: Xie He <xie.he.0141@gmail.com>
>> 
>> I don't have the opportunity to test this at the moment, but code 
>> looks
>> reasonable so far. Have you tested this at runtime?
> 
> Are you okay with this being merged or would you like to review
> further/test?
> 
> Nothing jumps out to me either (other than a few nit picks).

Adding a small delay in the while loop is a good idea.
Otherwise: Yes, I agree with merging this.

> 
>> > Change from v4:
>> > Make lapb_unregister wait for other refs to "lapb" to drop, to ensure
>> > that other LAPB API calls have all finished.
>> >
>> > Change from v3:
>> > In lapb_unregister make sure the self-restarting t1timer has really
>> > been
>> > stopped.
>> >
>> > Change from v2:
>> > Create a new __lapb_disconnect_request function to reduce redundant
>> > code.
>> >
>> > Change from v1:
>> > Broke long lines to keep the line lengths within 80 characters.
> 
>> > @@ -178,11 +182,23 @@ int lapb_unregister(struct net_device *dev)
>> >  		goto out;
>> >  	lapb_put(lapb);
>> >
>> > +	/* Wait for other refs to "lapb" to drop */
>> > +	while (refcount_read(&lapb->refcnt) > 2)
>> > +		;
> 
> Tight loop like this is a little scary, perhaps add a small
> usleep_range() here?
> 
>> > +
>> > +	spin_lock_bh(&lapb->lock);
>> > +
>> >  	lapb_stop_t1timer(lapb);
>> >  	lapb_stop_t2timer(lapb);
>> >
>> >  	lapb_clear_queues(lapb);
>> >
>> > +	spin_unlock_bh(&lapb->lock);
>> > +
>> > +	/* Wait for running timers to stop */
>> > +	del_timer_sync(&lapb->t1timer);
>> > +	del_timer_sync(&lapb->t2timer);
>> > +
>> >  	__lapb_remove_cb(lapb);
>> >
>> >  	lapb_put(lapb);
> 
>> > -int lapb_disconnect_request(struct net_device *dev)
>> > +static int __lapb_disconnect_request(struct lapb_cb *lapb)
>> >  {
>> > -	struct lapb_cb *lapb = lapb_devtostruct(dev);
>> > -	int rc = LAPB_BADTOKEN;
>> > -
>> > -	if (!lapb)
>> > -		goto out;
>> > -
>> >  	switch (lapb->state) {
>> >  	case LAPB_STATE_0:
>> > -		rc = LAPB_NOTCONNECTED;
>> > -		goto out_put;
>> > +		return LAPB_NOTCONNECTED;
>> >
>> >  	case LAPB_STATE_1:
>> >  		lapb_dbg(1, "(%p) S1 TX DISC(1)\n", lapb->dev);
>> > @@ -310,12 +328,10 @@ int lapb_disconnect_request(struct net_device
>> > *dev)
>> >  		lapb_send_control(lapb, LAPB_DISC, LAPB_POLLON, LAPB_COMMAND);
>> >  		lapb->state = LAPB_STATE_0;
>> >  		lapb_start_t1timer(lapb);
>> > -		rc = LAPB_NOTCONNECTED;
>> > -		goto out_put;
>> > +		return LAPB_NOTCONNECTED;
>> >
>> >  	case LAPB_STATE_2:
>> > -		rc = LAPB_OK;
>> > -		goto out_put;
>> > +		return LAPB_OK;
>> >  	}
>> >
>> >  	lapb_clear_queues(lapb);
>> > @@ -328,8 +344,22 @@ int lapb_disconnect_request(struct net_device
>> > *dev)
>> >  	lapb_dbg(1, "(%p) S3 DISC(1)\n", lapb->dev);
>> >  	lapb_dbg(0, "(%p) S3 -> S2\n", lapb->dev);
>> >
>> > -	rc = LAPB_OK;
>> > -out_put:
>> > +	return LAPB_OK;
>> > +}
> 
> Since this is a fix for net, I'd advise against converting the goto
> into direct returns (as much as I generally like such conversion).
