Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7C2E166786
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 20:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729024AbgBTTvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 14:51:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55785 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728448AbgBTTvw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 14:51:52 -0500
Received: from ip5f5bf7ec.dynamic.kabel-deutschland.de ([95.91.247.236] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1j4rrS-0006UR-54; Thu, 20 Feb 2020 19:51:50 +0000
Date:   Thu, 20 Feb 2020 20:51:49 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH net-next v3 2/9] sysfs: add sysfs_link_change_owner()
Message-ID: <20200220195149.xha7jltmfzs3xs7g@wittgenstein>
References: <20200218162943.2488012-1-christian.brauner@ubuntu.com>
 <20200218162943.2488012-3-christian.brauner@ubuntu.com>
 <20200220111443.GD3374196@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200220111443.GD3374196@kroah.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 20, 2020 at 12:14:43PM +0100, Greg Kroah-Hartman wrote:
> On Tue, Feb 18, 2020 at 05:29:36PM +0100, Christian Brauner wrote:
> > Add a helper to change the owner of a sysfs link.
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
> >  fs/sysfs/file.c       | 40 ++++++++++++++++++++++++++++++++++++++++
> >  include/linux/sysfs.h | 10 ++++++++++
> >  2 files changed, 50 insertions(+)
> > 
> > diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
> > index 32bb04b4d9d9..df5107d7b3fd 100644
> > --- a/fs/sysfs/file.c
> > +++ b/fs/sysfs/file.c
> > @@ -570,6 +570,46 @@ static int internal_change_owner(struct kernfs_node *kn, struct kobject *kobj,
> >  	return kernfs_setattr(kn, &newattrs);
> >  }
> >  
> > +/**
> > + *	sysfs_link_change_owner - change owner of a link.
> > + *	@kobj:	object of the kernfs_node the symlink is located in.
> > + *	@targ:	object of the kernfs_node the symlink points to.
> > + *	@name:	name of the link.
> > + *	@kuid:	new owner's kuid
> > + *	@kgid:	new owner's kgid
> > + */
> > +int sysfs_link_change_owner(struct kobject *kobj, struct kobject *targ,
> > +			    const char *name, kuid_t kuid, kgid_t kgid)
> > +{
> > +	struct kernfs_node *parent, *kn = NULL;
> > +	int error;
> > +
> > +	if (!kobj)
> > +		parent = sysfs_root_kn;
> > +	else
> > +		parent = kobj->sd;
> 
> I don't understand this, why would (!kobj) ever be a valid situation?

Yeah, a caller could just pass in "sysfs_root_kn" itself if they for
some reason needed to.

> 
> > +	if (!targ->state_in_sysfs)
> > +		return -EINVAL;
> 
> Should you also check kobj->state_in_sysfs as well?

Probably. I'll take a closer look now.

Thanks!
Christian
