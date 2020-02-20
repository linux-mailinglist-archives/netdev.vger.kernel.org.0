Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD755166827
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 21:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729067AbgBTUOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 15:14:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56396 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728556AbgBTUOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 15:14:00 -0500
Received: from ip5f5bf7ec.dynamic.kabel-deutschland.de ([95.91.247.236] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1j4sCp-0007qP-UM; Thu, 20 Feb 2020 20:13:56 +0000
Date:   Thu, 20 Feb 2020 21:13:54 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH net-next v3 4/9] sysfs: add sysfs_change_owner()
Message-ID: <20200220201354.j7yenup7unknqpih@wittgenstein>
References: <20200218162943.2488012-1-christian.brauner@ubuntu.com>
 <20200218162943.2488012-5-christian.brauner@ubuntu.com>
 <20200220112314.GG3374196@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200220112314.GG3374196@kroah.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 20, 2020 at 12:23:14PM +0100, Greg Kroah-Hartman wrote:
> On Tue, Feb 18, 2020 at 05:29:38PM +0100, Christian Brauner wrote:
> > Add a helper to change the owner of sysfs objects.
> > This function will be used to correctly account for kobject ownership
> > changes, e.g. when moving network devices between network namespaces.
> > 
> > Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> > ---
> > /* v2 */
> > -  Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
> >    - Add comment how ownership of sysfs object is changed.
> > 
> > /* v3 */
> > -  Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
> >    - Add explicit uid/gid parameters.
> > ---
> >  fs/sysfs/file.c       | 39 +++++++++++++++++++++++++++++++++++++++
> >  include/linux/sysfs.h |  6 ++++++
> >  2 files changed, 45 insertions(+)
> > 
> > diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
> > index df5107d7b3fd..02f7e852aad4 100644
> > --- a/fs/sysfs/file.c
> > +++ b/fs/sysfs/file.c
> > @@ -665,3 +665,42 @@ int sysfs_file_change_owner(struct kobject *kobj, kuid_t kuid, kgid_t kgid)
> >  	return error;
> >  }
> >  EXPORT_SYMBOL_GPL(sysfs_file_change_owner);
> > +
> > +/**
> > + *	sysfs_change_owner - change owner of the given object.
> 
> "and all of the files associated with this kobject", right?
> 
> > + *	@kobj:	object.
> > + *	@kuid:	new owner's kuid
> > + *	@kgid:	new owner's kgid
> > + */
> > +int sysfs_change_owner(struct kobject *kobj, kuid_t kuid, kgid_t kgid)
> > +{
> > +	int error;
> > +	const struct kobj_type *ktype;
> > +
> > +	if (!kobj->state_in_sysfs)
> > +		return -EINVAL;
> > +
> > +	error = sysfs_file_change_owner(kobj, kuid, kgid);
> 
> Ok, this changes the attributes of the sysfs directory for the kobject
> itself.

Yes.

> 
> > +	if (error)
> > +		return error;
> > +
> > +	ktype = get_ktype(kobj);
> > +	if (ktype) {
> > +		struct attribute **kattr;
> > +
> > +		for (kattr = ktype->default_attrs; kattr && *kattr; kattr++) {
> > +			error = sysfs_file_change_owner_by_name(
> > +				kobj, (*kattr)->name, kuid, kgid);
> > +			if (error)
> > +				return error;
> > +		}
> 
> And here you change all of the files of the kobject.

This changes the default attributes associated with that ktype (if any)
and mirrors how a kobject is registered in sysfs.

> 
> But what about files that have a subdir?  Does that also happen here?

Maybe that was all to brief on my end, sorry:
So all of this mirrors how a kobject is added through driver core which
in its guts is done via kobject_add_internal() which in summary does:
- create the main directory via create_dir()
- populate the directory with the groups associated with that ktype (if any)
- populate the directory with the basic attributes associated with that
  ktype (if any)
These are the basic steps that are associated with adding a kobject in
sysfs.
Any additional properties are added by the specific subsystem
itself (not by driver core) after it has registered the device. So for
the example of network devices, a network device will e.g. register a
queue subdirectory under the basic sysfs directory for the network
device and than further subdirectories within that queues subdirectory.
But that is all specific to network devices and they call the
corresponding sysfs functions to do that directly when they create those
queue objects. So anything that a subsystem adds outside of what driver
core does must also be changed by them (That's already true for removal
of files it created outside of driver core.) and it's the same for
ownership changes. :)

I'll document that.

> 
> > +
> > +		error = sysfs_groups_change_owner(kobj, ktype->default_groups,
> > +						  kuid, kgid);
> 
> Then what are you changing here?

So this changes the default groups associated with the ktype for that
kobject and again mirrors how a kobject is registered in sysfs.

> 
> I think the kerneldoc needs a lot more explaination as to what is going
> on in this function and why you would call it, and not some of the other
> functions you are adding.

Will do for sure.

Thanks!
Christian
