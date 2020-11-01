Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 777B52A1D7B
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 12:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbgKALCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 06:02:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:59192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726145AbgKALCQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Nov 2020 06:02:16 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAFDA2074F;
        Sun,  1 Nov 2020 11:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604228535;
        bh=5XNFiqjH2oN7J9GEbY/PVlCdxYv+WtUQcnEnB0t38U0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iLUHj0ReecjaVs/FH15VZkcACz93cXzUIe3yZNkNdBUr8gyqp8kffHcGoaXIjuhYV
         N9ikhsDGmQwSl+SDDhK8JQxo5kfRSd3yYqsj6Q+fHdsp36JALoEnanuKgSS0oZ+1sL
         XJ+lxSMYHpN9KEaTP59VrktOFwzIB9snxzHysrAc=
Date:   Sun, 1 Nov 2020 12:02:58 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Anmol Karn <anmol.karan123@gmail.com>
Cc:     ralf@linux-mips.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        linux-kernel@vger.kernel.org,
        syzbot+a1c743815982d9496393@syzkaller.appspotmail.com,
        linux-hams@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [Linux-kernel-mentees] [PATCH] net: rose: Fix Null pointer
 dereference in rose_send_frame()
Message-ID: <20201101110258.GA2925745@kroah.com>
References: <20201015001712.72976-1-anmol.karan123@gmail.com>
 <20201015051225.GA404970@kroah.com>
 <20201015141012.GB77038@Thinkpad>
 <20201015155051.GB66528@kroah.com>
 <20201030105413.GA32091@Thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201030105413.GA32091@Thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 30, 2020 at 04:24:13PM +0530, Anmol Karn wrote:
> On Thu, Oct 15, 2020 at 05:50:51PM +0200, Greg KH wrote:
> > On Thu, Oct 15, 2020 at 07:40:12PM +0530, Anmol Karn wrote:
> > > On Thu, Oct 15, 2020 at 07:12:25AM +0200, Greg KH wrote:
> > > > On Thu, Oct 15, 2020 at 05:47:12AM +0530, Anmol Karn wrote:
> > > > > In rose_send_frame(), when comparing two ax.25 addresses, it assigns rose_call to 
> > > > > either global ROSE callsign or default port, but when the former block triggers and 
> > > > > rose_call is assigned by (ax25_address *)neigh->dev->dev_addr, a NULL pointer is 
> > > > > dereferenced by 'neigh' when dereferencing 'dev'.
> > > > > 
> > > > > - net/rose/rose_link.c
> > > > > This bug seems to get triggered in this line:
> > > > > 
> > > > > rose_call = (ax25_address *)neigh->dev->dev_addr;
> > > > > 
> > > > > Prevent it by checking NULL condition for neigh->dev before comparing addressed for 
> > > > > rose_call initialization.
> > > > > 
> > > > > Reported-by: syzbot+a1c743815982d9496393@syzkaller.appspotmail.com 
> > > > > Link: https://syzkaller.appspot.com/bug?id=9d2a7ca8c7f2e4b682c97578dfa3f236258300b3 
> > > > > Signed-off-by: Anmol Karn <anmol.karan123@gmail.com>
> > > > > ---
> > > > > I am bit sceptical about the error return code, please suggest if anything else is 
> > > > > appropriate in place of '-ENODEV'.
> > > > > 
> > > > >  net/rose/rose_link.c | 3 +++
> > > > >  1 file changed, 3 insertions(+)
> > > > > 
> > > > > diff --git a/net/rose/rose_link.c b/net/rose/rose_link.c
> > > > > index f6102e6f5161..92ea6a31d575 100644
> > > > > --- a/net/rose/rose_link.c
> > > > > +++ b/net/rose/rose_link.c
> > > > > @@ -97,6 +97,9 @@ static int rose_send_frame(struct sk_buff *skb, struct rose_neigh *neigh)
> > > > >  	ax25_address *rose_call;
> > > > >  	ax25_cb *ax25s;
> > > > >  
> > > > > +	if (!neigh->dev)
> > > > > +		return -ENODEV;
> > > > 
> > > > How can ->dev not be set at this point in time?  Shouldn't that be
> > > > fixed, because it could change right after you check this, right?
> > > > 
> > > > thanks,
> > > > 
> > > > greg k-h
> > > 
> > > Hello Sir,
> > > 
> > > Thanks for the review,
> > > After following the call trace i thought, if neigh->dev is NULL it should
> > > be checked, but I will figure out what is going on with the crash reproducer,
> > > and I think rose_loopback_timer() is the place where problem started. 
> > > 
> > > Also, I have created a diff for checking neigh->dev before assigning ROSE callsign
> > > , please give your suggestions on this.
> > > 
> > > 
> > > diff --git a/net/rose/rose_link.c b/net/rose/rose_link.c
> > > index f6102e6f5161..2ddd5e559442 100644
> > > --- a/net/rose/rose_link.c
> > > +++ b/net/rose/rose_link.c
> > > @@ -97,10 +97,14 @@ static int rose_send_frame(struct sk_buff *skb, struct rose_neigh *neigh)
> > >         ax25_address *rose_call;
> > >         ax25_cb *ax25s;
> > >  
> > > -       if (ax25cmp(&rose_callsign, &null_ax25_address) == 0)
> > > -               rose_call = (ax25_address *)neigh->dev->dev_addr;
> > > -       else
> > > -               rose_call = &rose_callsign;
> > > +       if (neigh->dev) {
> > > +               if (ax25cmp(&rose_callsign, &null_ax25_address) == 0)
> > > +                       rose_call = (ax25_address *)neigh->dev->dev_addr;
> > > +               else
> > > +                       rose_call = &rose_callsign;
> > > +       } else {
> > > +               return -ENODEV;
> > > +       }
> > 
> > The point I am trying to make is that if someone else is setting ->dev
> > to NULL in some other thread/context/whatever, while this is running,
> > checking for it like this will not work.
> > 
> > What is the lifetime rules of that pointer?  Who initializes it, and who
> > sets it to NULL.  Figure that out first please to determine how to check
> > for this properly.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Hello All,
> 
> I investigated further on this,
> 
> Here is some things i noticed:
> 
> When I followed the call trace,
> 
> [ 84.241331][ C3] Call Trace:
> [ 84.241331][ C3] rose_transmit_clear_request ($SOURCE/net/rose/rose_link.c:255)
> [ 84.241331][ C3] ? lockdep_hardirqs_on ($SOURCE/kernel/locking/lockdep.c:4161)
> [ 84.241331][ C3] rose_rx_call_request ($SOURCE/net/rose/af_rose.c:999)
> [ 84.241331][ C3] ? rose_release ($SOURCE/net/rose/af_rose.c:970)
> [ 84.241331][ C3] rose_loopback_timer ($SOURCE/net/rose/rose_loopback.c:100)
> [ 84.241331][ C3] ? rose_transmit_link ($SOURCE/net/rose/rose_loopback.c:60)
> 
> in the rose_send_frame() it dereferenced `neigh->dev` when called from 
> rose_transmit_clear_request(), and the first occurance of the `neigh`
> is in rose_loopback_timer() as `rose_loopback_neigh`, and it is initialized 
> in rose_add_loopback_neighh() as NULL.
> 
> - net/rose/rose_route.c:381
> 
> void rose_add_loopback_neigh(void)
> {
> 	struct rose_neigh *sn;
> 
> 	rose_loopback_neigh = kmalloc(sizeof(struct rose_neigh), GFP_KERNEL);
> 	if (!rose_loopback_neigh)
> 		return;
> 	sn = rose_loopback_neigh;
> 
> 	sn->callsign  = null_ax25_address;
> 	sn->digipeat  = NULL;
> 	sn->ax25      = NULL;
> 	sn->dev       = NULL;
> 	^^^^^^^^^^^^^^^^^^^^^
> 
> i.e when `rose_loopback_neigh` used in rose_loopback_timer() its `->dev` was
> still NULL and rose_loopback_timer() was calling rose_rx_call_request() 
> without checking for NULL.
> 
> 
> I have created the following patch to check for NULL pointer.
> 
> diff --git a/net/rose/rose_loopback.c b/net/rose/rose_loopback.c
> index 7b094275ea8b..cd7774cb1d07 100644
> --- a/net/rose/rose_loopback.c
> +++ b/net/rose/rose_loopback.c
> @@ -96,7 +96,7 @@ static void rose_loopback_timer(struct timer_list *unused)
>                 }
>  
>                 if (frametype == ROSE_CALL_REQUEST) {
> -                       if ((dev = rose_dev_get(dest)) != NULL) {
> +                       if (rose_loopback_neigh->dev && (dev = rose_dev_get(dest)) != NULL) {
>                                 if (rose_rx_call_request(skb, dev, rose_loopback_neigh, lci_o) == 0)
>                                         kfree_skb(skb);
>                         } else {
> 
> 
> 
> Please, review it and give me suggestions whether i am going right or not.

That seems better, does it solve the syzbot test?

thanks,

greg k-h
