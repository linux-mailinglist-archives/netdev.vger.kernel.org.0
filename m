Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47B1CFCB0
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 17:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbfD3PXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 11:23:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53026 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfD3PXZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 11:23:25 -0400
Received: from 162-237-133-238.lightspeed.rcsntx.sbcglobal.net ([162.237.133.238] helo=lindsey)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <tyhicks@canonical.com>)
        id 1hLUbG-0006rZ-5q; Tue, 30 Apr 2019 15:23:18 +0000
Date:   Tue, 30 Apr 2019 10:23:13 -0500
From:   Tyler Hicks <tyhicks@canonical.com>
To:     "Tobin C. Harding" <tobin@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Wang Hai <wanghai26@huawei.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] bridge: Fix error path for kobject_init_and_add()
Message-ID: <20190430152312.GB13709@lindsey>
References: <20190430002817.10785-1-tobin@kernel.org>
 <20190430002817.10785-2-tobin@kernel.org>
 <20190430151437.GA13709@lindsey>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190430151437.GA13709@lindsey>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-04-30 10:14:37, Tyler Hicks wrote:
> On 2019-04-30 10:28:15, Tobin C. Harding wrote:
> > Currently error return from kobject_init_and_add() is not followed by a
> > call to kobject_put().  This means there is a memory leak.
> > 
> > Add call to kobject_put() in error path of kobject_init_and_add().
> > 
> > Signed-off-by: Tobin C. Harding <tobin@kernel.org>
> > ---
> >  net/bridge/br_if.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
> > index 41f0a696a65f..e5c8c9941c51 100644
> > --- a/net/bridge/br_if.c
> > +++ b/net/bridge/br_if.c
> > @@ -607,8 +607,10 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
> >  
> >  	err = kobject_init_and_add(&p->kobj, &brport_ktype, &(dev->dev.kobj),
> >  				   SYSFS_BRIDGE_PORT_ATTR);
> > -	if (err)
> > +	if (err) {
> > +		kobject_put(&p->kobj);
> >  		goto err1;
> > +	}
> 
> I think this is duplicating the code under the err2 label and doing so
> in a way that would introduce a double free.
> 
> If the refcount hits 0 in the kobject_put(), release_nbp() is called
> which calls kfree() on the p pointer. However, the p pointer is never
> set to NULL like what's done under the err2 label. Once we're back in
> br_add_if(), kfree() is called on the p pointer again just before
> returning.
> 
> I think it would be better if you just jumped to the err2 label instead
> of err1. err1 will no longer be used so, unfortunately, you'll have to
> refactor all the labels at the same time.

I noticed that the last paragraph is bad advice after looking at patch
#2 in this series. I guess you'd be better off calling kobject_put(),
setting p to NULL (the only thing that's missing), and jumping to err1
in this patch.

Tyler

> 
> Tyler
> 
> >  
> >  	err = br_sysfs_addif(p);
> >  	if (err)
> > -- 
> > 2.21.0
> > 
