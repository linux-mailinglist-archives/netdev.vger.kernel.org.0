Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 072752DB5C
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 13:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbfE2LFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 07:05:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:51696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725894AbfE2LFa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 07:05:30 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DD9B2081C;
        Wed, 29 May 2019 11:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559127930;
        bh=d8Wg5qum0LUcV0enNkmMhaOk2M6kAgT05EFGw3NSd98=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wTaB+C9E+jZ5LUul54SyUPKoQOQgIrzCoNKQG+EwB7D5IjfbjZml0BOhkorZrVfzg
         doMz6bzzZj5MUbckJRyyzrv7mtz9hbT7gOTxKf6in7JKibsSYDoN5qqOf5kNF0eiOP
         kAXZTMeojuzyB6G0HxDpBYVbJe+r/pw+u+8mvIIc=
Date:   Wed, 29 May 2019 14:05:24 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Doug Ledford <dledford@redhat.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Majd Dibbiny <majd@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next v2 13/17] RDMA/core: Get sum value of all
 counters when perform a sysfs stat read
Message-ID: <20190529110524.GU4633@mtr-leonro.mtl.com>
References: <20190429083453.16654-1-leon@kernel.org>
 <20190429083453.16654-14-leon@kernel.org>
 <20190522172636.GF15023@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522172636.GF15023@ziepe.ca>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 22, 2019 at 02:26:36PM -0300, Jason Gunthorpe wrote:
> On Mon, Apr 29, 2019 at 11:34:49AM +0300, Leon Romanovsky wrote:
> > diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
> > index c56ffc61ab1e..8ae4906a60e7 100644
> > +++ b/drivers/infiniband/core/device.c
> > @@ -1255,7 +1255,11 @@ int ib_register_device(struct ib_device *device, const char *name)
> >  		goto dev_cleanup;
> >  	}
> >
> > -	rdma_counter_init(device);
> > +	ret = rdma_counter_init(device);
> > +	if (ret) {
> > +		dev_warn(&device->dev, "Couldn't initialize counter\n");
> > +		goto sysfs_cleanup;
> > +	}
>
> Don't put this things randomly, if there is some reason it should be
> after sysfs it needs a comment, otherwise if it is just allocating
> memory it belongs earlier, and the unwind should be done in release.
>
> I also think it is very strange/wrong that both sysfs and counters are
> allocating the same alloc_hw_stats object
>
> Why can't they share?

They can, but we wanted to separate "legacy" counters which were exposed
through sysfs and "new" counters which can be enabled/disable automatically.

Thanks

>
> Jason
