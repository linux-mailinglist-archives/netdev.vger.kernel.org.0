Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53DFB15ABB0
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 16:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728398AbgBLPHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 10:07:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59897 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727698AbgBLPHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 10:07:50 -0500
Received: from ip5f5bf7ec.dynamic.kabel-deutschland.de ([95.91.247.236] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1j1tcB-0006F3-Aq; Wed, 12 Feb 2020 15:07:47 +0000
Date:   Wed, 12 Feb 2020 16:07:43 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH net-next 05/10] sysfs: add sysfs_change_owner()
Message-ID: <20200212150743.zyubvz53unyevbkx@wittgenstein>
References: <20200212104321.43570-1-christian.brauner@ubuntu.com>
 <20200212104321.43570-6-christian.brauner@ubuntu.com>
 <20200212131808.GA1789899@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200212131808.GA1789899@kroah.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 12, 2020 at 05:18:08AM -0800, Greg Kroah-Hartman wrote:
> On Wed, Feb 12, 2020 at 11:43:16AM +0100, Christian Brauner wrote:
> > Add a helper to change the owner of sysfs objects.
> 
> Seems sane, but:
> 
> > The ownership of a sysfs object is determined based on the ownership of
> > the corresponding kobject, i.e. only if the ownership of a kobject is
> > changed will this function change the ownership of the corresponding
> > sysfs entry.
> 
> A "sysfs object" is a kobject.  So I don't understand this sentance,
> sorry.

I meant that only if you change the uid/gid the underlying kobject is
associated with will this function do anything, meaning that you can't
pass in uids/gids directly. I'll explain why I did this down below [1].
Sorry if that was confusing.

> 
> > This function will be used to correctly account for kobject ownership
> > changes, e.g. when moving network devices between network namespaces.
> > 
> > Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> > ---
> >  fs/sysfs/file.c       | 35 +++++++++++++++++++++++++++++++++++
> >  include/linux/sysfs.h |  6 ++++++
> >  2 files changed, 41 insertions(+)
> > 
> > diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
> > index 6239d9584f0b..6a0fe88061fd 100644
> > --- a/fs/sysfs/file.c
> > +++ b/fs/sysfs/file.c
> > @@ -642,3 +642,38 @@ int sysfs_file_change_owner(struct kobject *kobj, const char *name)
> >  	return error;
> >  }
> >  EXPORT_SYMBOL_GPL(sysfs_file_change_owner);
> > +
> > +/**
> > + *	sysfs_change_owner - change owner of the given object.
> > + *	@kobj:	object.
> > + */
> > +int sysfs_change_owner(struct kobject *kobj)
> 
> What does this change the owner of the given object _to_?

[1]:
So ownership only changes if the kobject's uid/gid have been changed.
So when to stick with the networking example, when a network device is
moved into a new network namespace, the uid/gid of the kobject will be
changed to the root user of the owning user namespace of that network
namespace. So when the move of the network device has completed and
kobject_get_ownership() is called it will now return a different
uid/gid.
So my reasoning was that ownership is determined dynamically that way. I
guess what you're hinting at is that we could simply add uid_t uid,
gid_t gid arguments to these sysfs helpers. That's fine with me too. It
means that callers are responsible to either retrieve the ownership from
the kobject (in case it was changed through another call) or the call to
syfs_change_owner(kobj, uid, gid) sets the new owner of the kobject. I
don't know what the best approach is. Maybe a hybrid whereby we allow
passing in uid/gid but also allow passing in ({g,u}id_t - 1) to indicate
that we want the ownership to be taken from the kobject itself (e.g.
when a network device has been updated by dev_change_net_namespace()).

> 
> > +{
> > +	int error;
> > +	const struct kobj_type *ktype;
> > +
> > +	if (!kobj->state_in_sysfs)
> > +		return -EINVAL;
> > +
> > +	error = sysfs_file_change_owner(kobj, NULL);
> 
> It passes NULL?

Which means, change the ownership of "kobj" itself and not lookup a file
relative to "kobj".

> 
> 
> > +	if (error)
> > +		return error;
> > +
> > +	ktype = get_ktype(kobj);
> > +	if (ktype) {
> > +		struct attribute **kattr;
> > +
> > +		for (kattr = ktype->default_attrs; kattr && *kattr; kattr++) {
> > +			error = sysfs_file_change_owner(kobj, (*kattr)->name);
> > +			if (error)
> > +				return error;
> > +		}
> > +
> > +		error = sysfs_groups_change_owner(kobj, ktype->default_groups);
> > +		if (error)
> > +			return error;
> > +	}
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(sysfs_change_owner);
> 
> I can understand wanting to change owners/groups/whatever of existing
> sysfs objects and their files, but I can't figure out how to call this
> function to set the attribute I want to change.
> 
> With only one parameter, how does this work?  It guesses?  :)

See [1]. :)
And sorry if that wasn't clear!

Thanks!
Christian
