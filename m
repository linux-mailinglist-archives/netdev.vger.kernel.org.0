Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4B349EC68
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 17:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730278AbfH0PXw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 27 Aug 2019 11:23:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52920 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730196AbfH0PXt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 11:23:49 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D3FE410F23EB;
        Tue, 27 Aug 2019 15:23:48 +0000 (UTC)
Received: from x1.home (ovpn-116-99.phx2.redhat.com [10.3.116.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6523D1E0;
        Tue, 27 Aug 2019 15:23:47 +0000 (UTC)
Date:   Tue, 27 Aug 2019 09:23:46 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     Mark Bloch <markb@mellanox.com>, Jiri Pirko <jiri@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 2/4] mdev: Make mdev alias unique among all mdevs
Message-ID: <20190827092346.66bb73f1@x1.home>
In-Reply-To: <AM0PR05MB4866BB4736D265EF28280014D1A00@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190826204119.54386-1-parav@mellanox.com>
        <20190826204119.54386-3-parav@mellanox.com>
        <6601940a-4832-08d2-e0f6-f9ac24758cdc@mellanox.com>
        <AM0PR05MB4866BB4736D265EF28280014D1A00@AM0PR05MB4866.eurprd05.prod.outlook.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.66]); Tue, 27 Aug 2019 15:23:48 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Aug 2019 04:28:37 +0000
Parav Pandit <parav@mellanox.com> wrote:

> Hi Mark,
> 
> > -----Original Message-----
> > From: Mark Bloch <markb@mellanox.com>
> > Sent: Tuesday, August 27, 2019 4:32 AM
> > To: Parav Pandit <parav@mellanox.com>; alex.williamson@redhat.com; Jiri
> > Pirko <jiri@mellanox.com>; kwankhede@nvidia.com; cohuck@redhat.com;
> > davem@davemloft.net
> > Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> > netdev@vger.kernel.org
> > Subject: Re: [PATCH 2/4] mdev: Make mdev alias unique among all mdevs
> > 
> > 
> > 
> > On 8/26/19 1:41 PM, Parav Pandit wrote:  
> > > Mdev alias should be unique among all the mdevs, so that when such
> > > alias is used by the mdev users to derive other objects, there is no
> > > collision in a given system.
> > >
> > > Signed-off-by: Parav Pandit <parav@mellanox.com>
> > > ---
> > >  drivers/vfio/mdev/mdev_core.c | 5 +++++
> > >  1 file changed, 5 insertions(+)
> > >
> > > diff --git a/drivers/vfio/mdev/mdev_core.c
> > > b/drivers/vfio/mdev/mdev_core.c index e825ff38b037..6eb37f0c6369
> > > 100644
> > > --- a/drivers/vfio/mdev/mdev_core.c
> > > +++ b/drivers/vfio/mdev/mdev_core.c
> > > @@ -375,6 +375,11 @@ int mdev_device_create(struct kobject *kobj,  
> > struct device *dev,  
> > >  			ret = -EEXIST;
> > >  			goto mdev_fail;
> > >  		}
> > > +		if (tmp->alias && strcmp(tmp->alias, alias) == 0) {  
> > 
> > alias can be NULL here no?
> >   
> If alias is NULL, tmp->alias would also be null because for given parent either we have alias or we don’t.
> So its not possible to have tmp->alias as null and alias as non null.
> But it may be good/defensive to add check for both.

mdev_list is a global list of all mdev devices, how can we make any
assumptions that an element has the same parent?  Thanks,

Alex
 
> > > +			mutex_unlock(&mdev_list_lock);
> > > +			ret = -EEXIST;
> > > +			goto mdev_fail;
> > > +		}
> > >  	}
> > >
> > >  	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
> > >  
> > 
> > Mark  

