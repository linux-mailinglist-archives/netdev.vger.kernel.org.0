Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97F889E6AE
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 13:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfH0LYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 07:24:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15173 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725912AbfH0LYM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 07:24:12 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4E160C057E9F;
        Tue, 27 Aug 2019 11:24:11 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 81BCA3CCC;
        Tue, 27 Aug 2019 11:24:07 +0000 (UTC)
Date:   Tue, 27 Aug 2019 13:24:04 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/4] mdev: Introduce sha1 based mdev alias
Message-ID: <20190827132404.483a74ad.cohuck@redhat.com>
In-Reply-To: <AM0PR05MB4866B68C9E60E42359BE1F4DD1A00@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190826204119.54386-1-parav@mellanox.com>
        <20190826204119.54386-2-parav@mellanox.com>
        <20190827122428.37442fe1.cohuck@redhat.com>
        <AM0PR05MB4866B68C9E60E42359BE1F4DD1A00@AM0PR05MB4866.eurprd05.prod.outlook.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Tue, 27 Aug 2019 11:24:11 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Aug 2019 11:12:23 +0000
Parav Pandit <parav@mellanox.com> wrote:

> > -----Original Message-----
> > From: Cornelia Huck <cohuck@redhat.com>
> > Sent: Tuesday, August 27, 2019 3:54 PM
> > To: Parav Pandit <parav@mellanox.com>
> > Cc: alex.williamson@redhat.com; Jiri Pirko <jiri@mellanox.com>;
> > kwankhede@nvidia.com; davem@davemloft.net; kvm@vger.kernel.org; linux-
> > kernel@vger.kernel.org; netdev@vger.kernel.org
> > Subject: Re: [PATCH 1/4] mdev: Introduce sha1 based mdev alias
> > 
> > On Mon, 26 Aug 2019 15:41:16 -0500
> > Parav Pandit <parav@mellanox.com> wrote:
> >   
> > > Whenever a parent requests to generate mdev alias, generate a mdev
> > > alias.
> > > It is an optional attribute that parent can request to generate for
> > > each of its child mdev.
> > > mdev alias is generated using sha1 from the mdev name.  
> > 
> > Maybe add some motivation here as well?
> > 
> > "Some vendor drivers want an identifier for an mdev device that is shorter than
> > the uuid, due to length restrictions in the consumers of that identifier.
> > 
> > Add a callback that allows a vendor driver to request an alias of a specified
> > length to be generated (via sha1) for an mdev device. If generated, that alias is
> > checked for collisions."
> >   
> I did described the motivation in the cover letter with example and this design discussion thread.

Yes, but adding it to the patch description makes it available in the
git history.

> I will include above summary in v1.
>  
> > What about:
> > 
> > * @get_alias_length: optional callback to specify length of the alias to create
> > *                    Returns unsigned integer: length of the alias to be created,
> > *                                              0 to not create an alias
> >   
> Ack.
> 
> > I also think it might be beneficial to add a device parameter here now (rather
> > than later); that seems to be something that makes sense.
> >   
> Without showing the use, it shouldn't be added.

It just feels like an omission: Why should the vendor driver only be
able to return one value here, without knowing which device it is for?
If a driver supports different devices, it may have different
requirements for them.

> 
> > >   * Parent device that support mediated device should be registered with  
> > mdev  
> > >   * module with mdev_parent_ops structure.
> > >   **/
> > > @@ -92,6 +95,7 @@ struct mdev_parent_ops {
> > >  	long	(*ioctl)(struct mdev_device *mdev, unsigned int cmd,
> > >  			 unsigned long arg);
> > >  	int	(*mmap)(struct mdev_device *mdev, struct vm_area_struct  
> > *vma);  
> > > +	unsigned int (*get_alias_length)(void);
> > >  };
> > >
> > >  /* interface for exporting mdev supported type attributes */  
> 

