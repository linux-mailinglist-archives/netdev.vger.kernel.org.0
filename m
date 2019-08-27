Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 757479E6D9
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 13:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728447AbfH0Lej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 07:34:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56382 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727270AbfH0Lej (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 07:34:39 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B36DC18C8917;
        Tue, 27 Aug 2019 11:34:38 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2A365600D1;
        Tue, 27 Aug 2019 11:34:35 +0000 (UTC)
Date:   Tue, 27 Aug 2019 13:34:32 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 3/4] mdev: Expose mdev alias in sysfs tree
Message-ID: <20190827133432.156f7db3.cohuck@redhat.com>
In-Reply-To: <AM0PR05MB4866BDA002F2C6566492244ED1A00@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190826204119.54386-1-parav@mellanox.com>
        <20190826204119.54386-4-parav@mellanox.com>
        <20190827124706.7e726794.cohuck@redhat.com>
        <AM0PR05MB4866BDA002F2C6566492244ED1A00@AM0PR05MB4866.eurprd05.prod.outlook.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.70]); Tue, 27 Aug 2019 11:34:38 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Aug 2019 11:07:37 +0000
Parav Pandit <parav@mellanox.com> wrote:

> > -----Original Message-----
> > From: Cornelia Huck <cohuck@redhat.com>
> > Sent: Tuesday, August 27, 2019 4:17 PM
> > To: Parav Pandit <parav@mellanox.com>
> > Cc: alex.williamson@redhat.com; Jiri Pirko <jiri@mellanox.com>;
> > kwankhede@nvidia.com; davem@davemloft.net; kvm@vger.kernel.org; linux-
> > kernel@vger.kernel.org; netdev@vger.kernel.org
> > Subject: Re: [PATCH 3/4] mdev: Expose mdev alias in sysfs tree
> > 
> > On Mon, 26 Aug 2019 15:41:18 -0500
> > Parav Pandit <parav@mellanox.com> wrote:

> > > +static ssize_t alias_show(struct device *device,
> > > +			  struct device_attribute *attr, char *buf) {
> > > +	struct mdev_device *dev = mdev_from_dev(device);
> > > +
> > > +	if (!dev->alias)
> > > +		return -EOPNOTSUPP;  
> > 
> > I'm wondering how to make this consumable by userspace in the easiest way.
> > - As you do now (userspace gets an error when trying to read)?
> > - Returning an empty value (nothing to see here, move along)?  
> No. This is confusing, to return empty value, because it says that there is an alias but it is some weird empty string.
> If there is alias, it shows exactly what it is.
> If no alias it returns an error code = unsupported -> inline with other widely used subsystem.
> 
> > - Or not creating the attribute at all? That would match what userspace
> >   sees on older kernels, so it needs to be able to deal with that  
> New sysfs files can appear. Tool cannot say that I was not expecting this file here.
> User space is supposed to work with the file they are off interest.
> Mdev interface has option to specify vendor specific files, though in usual manner it's not recommended.
> So there is no old user space, new kernel issue here.

I'm not talking about old userspace/new kernel, but new userspace/old
kernel. Code that wants to consume this attribute needs to be able to
cope with its absence anyway.

> 
> >   anyway.
> >   
> > > +
> > > +	return sprintf(buf, "%s\n", dev->alias); } static
> > > +DEVICE_ATTR_RO(alias);
> > > +
> > >  static const struct attribute *mdev_device_attrs[] = {
> > > +	&dev_attr_alias.attr,
> > >  	&dev_attr_remove.attr,
> > >  	NULL,
> > >  };  
> 

