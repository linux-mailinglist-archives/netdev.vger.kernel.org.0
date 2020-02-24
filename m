Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7433616A724
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 14:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727421AbgBXNSX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 08:18:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:49625 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727275AbgBXNSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 08:18:23 -0500
Received: from ip5f5bf7ec.dynamic.kabel-deutschland.de ([95.91.247.236] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1j6Dcq-0005Wj-K9; Mon, 24 Feb 2020 13:18:20 +0000
Date:   Mon, 24 Feb 2020 14:18:19 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH net-next v3 5/9] device: add device_change_owner()
Message-ID: <20200224131819.gos6xlqwlrnqc7gt@wittgenstein>
References: <20200218162943.2488012-1-christian.brauner@ubuntu.com>
 <20200218162943.2488012-6-christian.brauner@ubuntu.com>
 <20200220112513.GH3374196@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200220112513.GH3374196@kroah.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 20, 2020 at 12:25:13PM +0100, Greg Kroah-Hartman wrote:
> On Tue, Feb 18, 2020 at 05:29:39PM +0100, Christian Brauner wrote:
> > Add a helper to change the owner of a device's sysfs entries. This
> > needs to happen when the ownership of a device is changed, e.g. when
> > moving network devices between network namespaces.
> > This function will be used to correctly account for ownership changes,
> > e.g. when moving network devices between network namespaces.
> > 
> > Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> > ---
> > /* v2 */
> > unchanged
> > 
> > /* v3 */
> > -  Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
> >    - Add explicit uid/gid parameters.
> > ---
> >  drivers/base/core.c    | 80 ++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/device.h |  1 +
> >  2 files changed, 81 insertions(+)
> > 
> > diff --git a/drivers/base/core.c b/drivers/base/core.c
> > index 42a672456432..ec0d5e8cfd0f 100644
> > --- a/drivers/base/core.c
> > +++ b/drivers/base/core.c
> > @@ -3458,6 +3458,86 @@ int device_move(struct device *dev, struct device *new_parent,
> >  }
> >  EXPORT_SYMBOL_GPL(device_move);
> >  
> > +static int device_attrs_change_owner(struct device *dev, kuid_t kuid,
> > +				     kgid_t kgid)
> > +{
> > +	struct kobject *kobj = &dev->kobj;
> > +	struct class *class = dev->class;
> > +	const struct device_type *type = dev->type;
> > +	int error;
> > +
> > +	if (class) {
> > +		error = sysfs_groups_change_owner(kobj, class->dev_groups, kuid,
> > +						  kgid);
> > +		if (error)
> > +			return error;
> > +	}
> > +
> > +	if (type) {
> > +		error = sysfs_groups_change_owner(kobj, type->groups, kuid,
> > +						  kgid);
> > +		if (error)
> > +			return error;
> > +	}
> > +
> > +	error = sysfs_groups_change_owner(kobj, dev->groups, kuid, kgid);
> > +	if (error)
> > +		return error;
> > +
> > +	if (device_supports_offline(dev) && !dev->offline_disabled) {
> > +		error = sysfs_file_change_owner_by_name(
> > +			kobj, dev_attr_online.attr.name, kuid, kgid);
> > +		if (error)
> > +			return error;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +/**
> > + * device_change_owner - change the owner of an existing device.
> 
> The "owner" and what else gets changed here?  Please document this
> better.
> 
> 
> > + * @dev: device.
> > + * @kuid: new owner's kuid
> > + * @kgid: new owner's kgid
> > + */
> > +int device_change_owner(struct device *dev, kuid_t kuid, kgid_t kgid)
> > +{
> > +	int error;
> > +	struct kobject *kobj = &dev->kobj;
> > +
> > +	dev = get_device(dev);
> > +	if (!dev)
> > +		return -EINVAL;
> > +
> > +	error = sysfs_change_owner(kobj, kuid, kgid);
> 
> the kobject of the device is changed, good.
> 
> > +	if (error)
> > +		goto out;
> > +
> > +	error = sysfs_file_change_owner_by_name(kobj, dev_attr_uevent.attr.name,
> > +						kuid, kgid);
> 
> Why call out the uevent file explicitly here?

This again, mirrors the creation of a kobject in sysfs. The uevent file
is created separately and thus should be chowned separately.

> 
> > +	if (error)
> > +		goto out;
> > +
> > +	error = device_attrs_change_owner(dev, kuid, kgid);
> > +	if (error)
> > +		goto out;
> 
> Doesn't this also change the uevent file?

No, not as far as I can tell. The uevent file is created in an extra
step when the kobject/sysfs entries are created.

> 
> > +
> > +#ifdef CONFIG_BLOCK
> > +	if (sysfs_deprecated && dev->class == &block_class)
> > +		goto out;
> > +#endif
> 
> Ugh, we still need this?

Yeah, apparently. It's what I gather from how a device is added.

> 
> > +
> > +	error = sysfs_link_change_owner(&dev->class->p->subsys.kobj, &dev->kobj,
> > +					dev_name(dev), kuid, kgid);
> 
> Now what is this changing?

So, this changed the ownership of the class link for the device to match
the directory entry for that device, so e.g. given a network device
symlink (or any other type) that points to the actual directory entry
for that device:

/sys/class/net/my-dev -> ../../devices/virtual/net/my-dev

it makes my-dev show the same permissions as the directory my-dev has.
If we don't do this this will look weird, because the symlink will show
different permissions than the target it is pointoing to.

> 
> Again, more documentation please as to exactly what is being changed in
> this function is needed.

Sure!
