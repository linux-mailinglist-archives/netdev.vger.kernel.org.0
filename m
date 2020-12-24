Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A50572E27FE
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 17:02:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728563AbgLXPz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Dec 2020 10:55:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32090 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727861AbgLXPzZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Dec 2020 10:55:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608825238;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GjtaVVAF5nnoSxuy7Ms1ARXMm/Xb437giz7owYFFRkE=;
        b=gqob6Pl5/SmzSj/b6qs+Boa94fI4lkbLCaqXCbii21CWoIqyjJcyIUxyTR6+B9PTxUbKRr
        psRAO2cAQ84m3JyG+Y7+Ysi3hBhyUHRKLuVz+QELwjyDJ3G0l9hv3HxuV/f07TVMDLDJj4
        1x2pa8avUCXUb2qE5RYOzr19k2I65kE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-iv9wu0s8N9S9_vrVNZxDGw-1; Thu, 24 Dec 2020 10:53:57 -0500
X-MC-Unique: iv9wu0s8N9S9_vrVNZxDGw-1
Received: by mail-wm1-f72.google.com with SMTP id w204so843765wmb.1
        for <netdev@vger.kernel.org>; Thu, 24 Dec 2020 07:53:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GjtaVVAF5nnoSxuy7Ms1ARXMm/Xb437giz7owYFFRkE=;
        b=N44Vg+AxNs9s/7uR1vOsbM0c0GcZYfX4BoeFJKUWXpgWKEMUdvxFpHtTMaxLkx3FBK
         kP8ssRCC9+F0HhtBpeuS3h55I/HBh1YEMKNuQAsp3YFGsaIRV373WfNPR2SR/PVx7EB+
         ymljMcuF412QJTKB6b55K95xloqHQqmY/Q/U6l9r/Pl8lx0OYnjMXtI8W2YJJU6nUuML
         vaoin2vAAJudG0suYoB5zOeJ9CTzgLotTcBCrTZp1SUQ3fj9Qw6fLx20pMP43bEIhxQm
         UxUYIeolhxzBdifiIWiaehVueTNEfRfEj7fZX3Le8G0xPxakEdNMuzbH1VwnaP1M8Mkj
         KE+Q==
X-Gm-Message-State: AOAM531kgUq0AI7xcUWVIZt5wACPd8C51TVIJkJrB55fGlTvpfl+U8cH
        4o0PVX/Agat5VZ3Ra6uHV5YstaI5npg6YEhofSyLCUdDYHyk+2rSCHvn5z82fUJH36IBEKdru5y
        cyo2z9c9X371Q12B6
X-Received: by 2002:a1c:5447:: with SMTP id p7mr4918576wmi.116.1608825235501;
        Thu, 24 Dec 2020 07:53:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzP9s404OsRRgxDhML0vgL7bOSA+M+LAp78A2PvOHbB9CxfBUt5zfte4Xu2lzE2keWQnQAmyQ==
X-Received: by 2002:a1c:5447:: with SMTP id p7mr4918559wmi.116.1608825235241;
        Thu, 24 Dec 2020 07:53:55 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id z8sm3784823wmg.17.2020.12.24.07.53.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Dec 2020 07:53:54 -0800 (PST)
Date:   Thu, 24 Dec 2020 16:53:52 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Tom Parkin <tparkin@katalix.com>
Cc:     netdev@vger.kernel.org, jchapman@katalix.com
Subject: Re: [PATCH net] ppp: hold mutex when unbridging channels in
 unregister path
Message-ID: <20201224155352.GB27423@linux.home>
References: <20201223184730.30057-1-tparkin@katalix.com>
 <20201224102818.GA27423@linux.home>
 <20201224142431.GA4594@katalix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201224142431.GA4594@katalix.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 24, 2020 at 02:24:32PM +0000, Tom Parkin wrote:
> On  Thu, Dec 24, 2020 at 11:28:18 +0100, Guillaume Nault wrote:
> > On Wed, Dec 23, 2020 at 06:47:30PM +0000, Tom Parkin wrote:
> > > Channels are bridged using the PPPIOCBRIDGECHAN ioctl, which executes
> > > with the ppp_mutex held.
> > > 
> > > Unbridging may occur in two code paths: firstly an explicit
> > > PPPIOCUNBRIDGECHAN ioctl, and secondly on channel unregister.  The
> > > latter may occur when closing the /dev/ppp instance or on teardown of
> > > the channel itself.
> > > 
> > > This opens up a refcount underflow bug if ppp_bridge_channels called via.
> > > ioctl races with ppp_unbridge_channels called via. file release.
> > > 
> > > The race is triggered by ppp_unbridge_channels taking the error path
> > 
> > This is actually ppp_bridge_channels.
> > 
> 
> Will fix, thanks.
> 
> > > through the 'err_unset' label.  In this scenario, pch->bridge has been
> > > set, but no reference will be taken on pch->file because the function
> > > errors out.  Therefore, if ppp_unbridge_channels is called in the window
> > > between pch->bridge being set and pch->bridge being unset, it will
> > > erroneously drop the reference on pch->file and cause a refcount
> > > underflow.
> > > 
> > > To avoid this, hold the ppp_mutex while calling ppp_unbridge_channels in
> > > the shutdown path.  This serialises the unbridge operation with any
> > > concurrently executing ioctl.
> > > 
> > > Signed-off-by: Tom Parkin <tparkin@katalix.com>
> > > ---
> > >  drivers/net/ppp/ppp_generic.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > > 
> > > diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
> > > index 09c27f7773f9..e87a05fee2db 100644
> > > --- a/drivers/net/ppp/ppp_generic.c
> > > +++ b/drivers/net/ppp/ppp_generic.c
> > > @@ -2938,7 +2938,9 @@ ppp_unregister_channel(struct ppp_channel *chan)
> > >  	list_del(&pch->list);
> > >  	spin_unlock_bh(&pn->all_channels_lock);
> > >  
> > > +	mutex_lock(&ppp_mutex);
> > >  	ppp_unbridge_channels(pch);
> > > +	mutex_unlock(&ppp_mutex);
> > >  
> > >  	pch->file.dead = 1;
> > >  	wake_up_interruptible(&pch->file.rwait);
> > > -- 
> > > 2.17.1
> > > 
> > 
> > The problem is that assigning ->bridge and taking a reference on that
> > channel isn't atomic. Holding ppp_mutex looks like a workaround for
> > this problem.
> 
> You're quite right -- that is the underlying issue.
> 
> > I think the refcount should be taken before unlocking ->upl in
> > ppp_bridge_channels().
> 
> Aye, that's the other option :-)
> 
> I wasn't sure whether it was better to use the same locking structure
> as the ioctl call, or to rework the code to make the two things
> effectively atomic as you suggest.

ppp_mutex was added by commit 15fd0cd9a2ad ("net: autoconvert trivial
BKL users to private mutex") as a replacement for the big kernel lock.
We should head towards removing it, rather than expanding its usage
(locking dependencies are already complex enough in ppp_generic).

Also, as a refcount marks a dependency to another object, it's important
to take it before the dependency becomes visible to external entities.

> I'll try this approach.
> 
> Thanks for your review!
> 
> > 
> > Something like this (completely untested):
> > 
> > ---- 8< ----
> >  static int ppp_bridge_channels(struct channel *pch, struct channel *pchb)
> >  {
> >  	write_lock_bh(&pch->upl);
> >  	if (pch->ppp ||
> >  	    rcu_dereference_protected(pch->bridge, lockdep_is_held(&pch->upl))) {
> >  		write_unlock_bh(&pch->upl);
> >  		return -EALREADY;
> >  	}
> > +
> > +	refcount_inc(&pchb->file.refcnt);
> >  	rcu_assign_pointer(pch->bridge, pchb);
> >  	write_unlock_bh(&pch->upl);
> > 
> > 	write_lock_bh(&pchb->upl);
> > 	if (pchb->ppp ||
> > 	    rcu_dereference_protected(pchb->bridge, lockdep_is_held(&pchb->upl))) {
> > 		write_unlock_bh(&pchb->upl);
> > 		goto err_unset;
> > 	}
> > +
> > +	refcount_inc(&pch->file.refcnt);
> > 	rcu_assign_pointer(pchb->bridge, pch);
> > 	write_unlock_bh(&pchb->upl);
> > 
> > -	refcount_inc(&pch->file.refcnt);
> > -	refcount_inc(&pchb->file.refcnt);
> > -
> > 	return 0;
> > 
> > err_unset:
> > 	write_lock_bh(&pch->upl);
> > 	RCU_INIT_POINTER(pch->bridge, NULL);
> > 	write_unlock_bh(&pch->upl);
> > 	synchronize_rcu();
> > +
> > +	if (refcount_dec_and_test(&pchb->file.refcnt))
> > +		ppp_destroy_channel(pchb);
> > +
> > 	return -EALREADY;
> > }
> > 


