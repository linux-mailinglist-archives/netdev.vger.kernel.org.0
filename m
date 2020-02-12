Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7FB815ACAE
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 17:04:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728676AbgBLQEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 11:04:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:53926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726728AbgBLQEE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Feb 2020 11:04:04 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26EFD2082F;
        Wed, 12 Feb 2020 16:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581523443;
        bh=xU2rLIEhWXbj7R8laJx0IdOIdIu2LUAcXTPhXJVEGts=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s2wmDc2m/nLk75G4YSx5bHyDiFUbZLlVFIIXygs098A1skc2j+utskUCrOA66qQl9
         7jGPPvqRTxjMSKJI4frmiE3XkvpjPDGb/qSUUdl6X3x7jT6kc/DQxsph1C3AF0veK7
         Y5inDoL9lP0tLIbht/gumou5mEGOejK6bkPVT/ng=
Date:   Wed, 12 Feb 2020 08:04:02 -0800
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH net-next 05/10] sysfs: add sysfs_change_owner()
Message-ID: <20200212160402.GA1799124@kroah.com>
References: <20200212104321.43570-1-christian.brauner@ubuntu.com>
 <20200212104321.43570-6-christian.brauner@ubuntu.com>
 <20200212131808.GA1789899@kroah.com>
 <20200212150743.zyubvz53unyevbkx@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200212150743.zyubvz53unyevbkx@wittgenstein>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 12, 2020 at 04:07:43PM +0100, Christian Brauner wrote:
> On Wed, Feb 12, 2020 at 05:18:08AM -0800, Greg Kroah-Hartman wrote:
> > On Wed, Feb 12, 2020 at 11:43:16AM +0100, Christian Brauner wrote:
> > > Add a helper to change the owner of sysfs objects.
> > 
> > Seems sane, but:
> > 
> > > The ownership of a sysfs object is determined based on the ownership of
> > > the corresponding kobject, i.e. only if the ownership of a kobject is
> > > changed will this function change the ownership of the corresponding
> > > sysfs entry.
> > 
> > A "sysfs object" is a kobject.  So I don't understand this sentance,
> > sorry.
> 
> I meant that only if you change the uid/gid the underlying kobject is
> associated with will this function do anything, meaning that you can't
> pass in uids/gids directly. I'll explain why I did this down below [1].
> Sorry if that was confusing.
> 
> > 
> > > This function will be used to correctly account for kobject ownership
> > > changes, e.g. when moving network devices between network namespaces.
> > > 
> > > Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> > > ---
> > >  fs/sysfs/file.c       | 35 +++++++++++++++++++++++++++++++++++
> > >  include/linux/sysfs.h |  6 ++++++
> > >  2 files changed, 41 insertions(+)
> > > 
> > > diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
> > > index 6239d9584f0b..6a0fe88061fd 100644
> > > --- a/fs/sysfs/file.c
> > > +++ b/fs/sysfs/file.c
> > > @@ -642,3 +642,38 @@ int sysfs_file_change_owner(struct kobject *kobj, const char *name)
> > >  	return error;
> > >  }
> > >  EXPORT_SYMBOL_GPL(sysfs_file_change_owner);
> > > +
> > > +/**
> > > + *	sysfs_change_owner - change owner of the given object.
> > > + *	@kobj:	object.
> > > + */
> > > +int sysfs_change_owner(struct kobject *kobj)
> > 
> > What does this change the owner of the given object _to_?
> 
> [1]:
> So ownership only changes if the kobject's uid/gid have been changed.
> So when to stick with the networking example, when a network device is
> moved into a new network namespace, the uid/gid of the kobject will be
> changed to the root user of the owning user namespace of that network
> namespace. So when the move of the network device has completed and
> kobject_get_ownership() is called it will now return a different
> uid/gid.

Ok, then this needs to say "change the uid/gid of the kobject to..." in
order to explain what it is now being set to.  Otherwise this is really
confusing if you only read the kerneldoc, right?

> So my reasoning was that ownership is determined dynamically that way. I
> guess what you're hinting at is that we could simply add uid_t uid,
> gid_t gid arguments to these sysfs helpers. That's fine with me too.

It's fine if you want to set it to the "root owner", just say that
somewhere :)

> It
> means that callers are responsible to either retrieve the ownership from
> the kobject (in case it was changed through another call) or the call to
> syfs_change_owner(kobj, uid, gid) sets the new owner of the kobject. I
> don't know what the best approach is. Maybe a hybrid whereby we allow
> passing in uid/gid but also allow passing in ({g,u}id_t - 1) to indicate
> that we want the ownership to be taken from the kobject itself (e.g.
> when a network device has been updated by dev_change_net_namespace()).
> 
> > 
> > > +{
> > > +	int error;
> > > +	const struct kobj_type *ktype;
> > > +
> > > +	if (!kobj->state_in_sysfs)
> > > +		return -EINVAL;
> > > +
> > > +	error = sysfs_file_change_owner(kobj, NULL);
> > 
> > It passes NULL?
> 
> Which means, change the ownership of "kobj" itself and not lookup a file
> relative to "kobj".

Ok, that's totally not obvious at all :(

Better naming please, I know it's hard, but it matters.

thanks,

greg k-h
