Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7256728F624
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 17:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389869AbgJOPuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 11:50:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:45400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389852AbgJOPuU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 11:50:20 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7102C22254;
        Thu, 15 Oct 2020 15:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602777018;
        bh=Nbeh2o2J1dywpTUez/hZlzk3LDJQpKjMNnmMx7aK6l0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Amo6QXY5T5qCo7ziLFz224ScCkVpzyK15Ee9X170kSqUpVe89THSC8mVUywyi6k48
         jKfo7BSfCdEyux5Uux3nU0soWase4UBKU3TBduCo2h1yPrn+HaX4ZLeh167VsqO0oi
         2ft147Aa5V5yUIMStKZbruC5jVmj6plrubcWSzPU=
Date:   Thu, 15 Oct 2020 17:50:51 +0200
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
Message-ID: <20201015155051.GB66528@kroah.com>
References: <20201015001712.72976-1-anmol.karan123@gmail.com>
 <20201015051225.GA404970@kroah.com>
 <20201015141012.GB77038@Thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015141012.GB77038@Thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 15, 2020 at 07:40:12PM +0530, Anmol Karn wrote:
> On Thu, Oct 15, 2020 at 07:12:25AM +0200, Greg KH wrote:
> > On Thu, Oct 15, 2020 at 05:47:12AM +0530, Anmol Karn wrote:
> > > In rose_send_frame(), when comparing two ax.25 addresses, it assigns rose_call to 
> > > either global ROSE callsign or default port, but when the former block triggers and 
> > > rose_call is assigned by (ax25_address *)neigh->dev->dev_addr, a NULL pointer is 
> > > dereferenced by 'neigh' when dereferencing 'dev'.
> > > 
> > > - net/rose/rose_link.c
> > > This bug seems to get triggered in this line:
> > > 
> > > rose_call = (ax25_address *)neigh->dev->dev_addr;
> > > 
> > > Prevent it by checking NULL condition for neigh->dev before comparing addressed for 
> > > rose_call initialization.
> > > 
> > > Reported-by: syzbot+a1c743815982d9496393@syzkaller.appspotmail.com 
> > > Link: https://syzkaller.appspot.com/bug?id=9d2a7ca8c7f2e4b682c97578dfa3f236258300b3 
> > > Signed-off-by: Anmol Karn <anmol.karan123@gmail.com>
> > > ---
> > > I am bit sceptical about the error return code, please suggest if anything else is 
> > > appropriate in place of '-ENODEV'.
> > > 
> > >  net/rose/rose_link.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > > 
> > > diff --git a/net/rose/rose_link.c b/net/rose/rose_link.c
> > > index f6102e6f5161..92ea6a31d575 100644
> > > --- a/net/rose/rose_link.c
> > > +++ b/net/rose/rose_link.c
> > > @@ -97,6 +97,9 @@ static int rose_send_frame(struct sk_buff *skb, struct rose_neigh *neigh)
> > >  	ax25_address *rose_call;
> > >  	ax25_cb *ax25s;
> > >  
> > > +	if (!neigh->dev)
> > > +		return -ENODEV;
> > 
> > How can ->dev not be set at this point in time?  Shouldn't that be
> > fixed, because it could change right after you check this, right?
> > 
> > thanks,
> > 
> > greg k-h
> 
> Hello Sir,
> 
> Thanks for the review,
> After following the call trace i thought, if neigh->dev is NULL it should
> be checked, but I will figure out what is going on with the crash reproducer,
> and I think rose_loopback_timer() is the place where problem started. 
> 
> Also, I have created a diff for checking neigh->dev before assigning ROSE callsign
> , please give your suggestions on this.
> 
> 
> diff --git a/net/rose/rose_link.c b/net/rose/rose_link.c
> index f6102e6f5161..2ddd5e559442 100644
> --- a/net/rose/rose_link.c
> +++ b/net/rose/rose_link.c
> @@ -97,10 +97,14 @@ static int rose_send_frame(struct sk_buff *skb, struct rose_neigh *neigh)
>         ax25_address *rose_call;
>         ax25_cb *ax25s;
>  
> -       if (ax25cmp(&rose_callsign, &null_ax25_address) == 0)
> -               rose_call = (ax25_address *)neigh->dev->dev_addr;
> -       else
> -               rose_call = &rose_callsign;
> +       if (neigh->dev) {
> +               if (ax25cmp(&rose_callsign, &null_ax25_address) == 0)
> +                       rose_call = (ax25_address *)neigh->dev->dev_addr;
> +               else
> +                       rose_call = &rose_callsign;
> +       } else {
> +               return -ENODEV;
> +       }

The point I am trying to make is that if someone else is setting ->dev
to NULL in some other thread/context/whatever, while this is running,
checking for it like this will not work.

What is the lifetime rules of that pointer?  Who initializes it, and who
sets it to NULL.  Figure that out first please to determine how to check
for this properly.

thanks,

greg k-h
