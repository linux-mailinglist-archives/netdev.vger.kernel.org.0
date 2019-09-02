Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30A1FA59B1
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 16:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731678AbfIBOqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 10:46:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60948 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726382AbfIBOqL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Sep 2019 10:46:11 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 907FF10F23ED;
        Mon,  2 Sep 2019 14:46:10 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 02F89196B2;
        Mon,  2 Sep 2019 14:46:06 +0000 (UTC)
Date:   Mon, 2 Sep 2019 16:46:04 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 1/6] mdev: Introduce sha1 based mdev alias
Message-ID: <20190902164604.1d04614f.cohuck@redhat.com>
In-Reply-To: <AM0PR05MB48661F9608F284AB5C9BAEB5D1BD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190826204119.54386-1-parav@mellanox.com>
        <20190829111904.16042-1-parav@mellanox.com>
        <20190829111904.16042-2-parav@mellanox.com>
        <20190830111720.04aa54e9.cohuck@redhat.com>
        <AM0PR05MB48660877881F7A2D757A9C82D1BD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190830143927.163d13a7.cohuck@redhat.com>
        <AM0PR05MB486621283F935B673455DA63D1BD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190830160223.332fd81f.cohuck@redhat.com>
        <AM0PR05MB48661F9608F284AB5C9BAEB5D1BD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.66]); Mon, 02 Sep 2019 14:46:10 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Aug 2019 15:45:13 +0000
Parav Pandit <parav@mellanox.com> wrote:

> > > > > > This detour via the local variable looks weird to me. Can you
> > > > > > either create the alias directly in the mdev (would need to
> > > > > > happen later in the function, but I'm not sure why you generate
> > > > > > the alias before checking for duplicates anyway), or do an explicit copy?  
> > > > > Alias duplicate check is done after generating it, because
> > > > > duplicate alias are  
> > > > not allowed.  
> > > > > The probability of collision is rare.
> > > > > So it is speculatively generated without hold the lock, because
> > > > > there is no  
> > > > need to hold the lock.  
> > > > > It is compared along with guid while mutex lock is held in single loop.
> > > > > And if it is duplicate, there is no need to allocate mdev.
> > > > >
> > > > > It will be sub optimal to run through the mdev list 2nd time after
> > > > > mdev  
> > > > creation and after generating alias for duplicate check.
> > > >
> > > > Ok, but what about copying it? I find this "set local variable to
> > > > NULL after ownership is transferred" pattern a bit unintuitive.
> > > > Copying it to the mdev (and then unconditionally freeing it) looks more  
> > obvious to me.  
> > > Its not unconditionally freed.  
> > 
> > That's not what I have been saying :(
> >   
> Ah I see. You want to allocate alias memory twice; once inside mdev device and another one in _create() function.
> _create() one you want to free unconditionally.
> 
> Well, passing pointer is fine.

It's not that it doesn't work, but it feels fragile due to its
non-obviousness.

> mdev_register_device() has similar little tricky pattern that makes parent = NULL on __find_parent_device() finds duplicate one.

I don't think that the two are comparable.

> 
> Ownership transfer is more straight forward code.

I have to disagree here.

> 
> It is similar to device_initialize(), device init sequence code, where once device_initialize is done, freeing the device memory will be left to the put_device(), we don't call kfree() on mdev device.

This does not really look similar to me: devices are refcounted
structures, while strings aren't; you transfer a local pointer to a
refcounted structure and then discard the local reference.
