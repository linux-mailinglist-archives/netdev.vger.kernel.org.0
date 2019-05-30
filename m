Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46F0B2F7B4
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 09:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbfE3HEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 03:04:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:41652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbfE3HEn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 May 2019 03:04:43 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EA7B2490C;
        Thu, 30 May 2019 07:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559199882;
        bh=eoq/CCFOaTOc1Y+npMXpWpdlCz+pieNKsP4cMUXJZH4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qmdixH8lv1DVyOlJGrBCrfD5xwID1GKD9gIH+wY7qa1NRO7QRuD8PR90UIdY/U27Q
         8dwDCJKcCyiH/HRB8qFAZ7RBoEwxTptdjwZPwWtB/6Gr2wkRoPTlA5uHEEi7ZGSvgI
         6vcdh+eXrwjL+QEXAax8l4JlymW7KS+odnUzagME=
Date:   Thu, 30 May 2019 10:04:38 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Mark Zhang <markz@mellanox.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Majd Dibbiny <majd@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next v2 13/17] RDMA/core: Get sum value of all
 counters when perform a sysfs stat read
Message-ID: <20190530070438.GB6251@mtr-leonro.mtl.com>
References: <20190429083453.16654-1-leon@kernel.org>
 <20190429083453.16654-14-leon@kernel.org>
 <20190522172636.GF15023@ziepe.ca>
 <20190529110524.GU4633@mtr-leonro.mtl.com>
 <20190529154438.GB8567@ziepe.ca>
 <6e0b034c-b647-749f-fba7-2ac51a12d327@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e0b034c-b647-749f-fba7-2ac51a12d327@mellanox.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 30, 2019 at 06:01:46AM +0000, Mark Zhang wrote:
> On 5/29/2019 11:44 PM, Jason Gunthorpe wrote:
> > On Wed, May 29, 2019 at 02:05:24PM +0300, Leon Romanovsky wrote:
> >> On Wed, May 22, 2019 at 02:26:36PM -0300, Jason Gunthorpe wrote:
> >>> On Mon, Apr 29, 2019 at 11:34:49AM +0300, Leon Romanovsky wrote:
> >>>> diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
> >>>> index c56ffc61ab1e..8ae4906a60e7 100644
> >>>> +++ b/drivers/infiniband/core/device.c
> >>>> @@ -1255,7 +1255,11 @@ int ib_register_device(struct ib_device *device, const char *name)
> >>>>   		goto dev_cleanup;
> >>>>   	}
> >>>>
> >>>> -	rdma_counter_init(device);
> >>>> +	ret = rdma_counter_init(device);
> >>>> +	if (ret) {
> >>>> +		dev_warn(&device->dev, "Couldn't initialize counter\n");
> >>>> +		goto sysfs_cleanup;
> >>>> +	}
> >>>
> >>> Don't put this things randomly, if there is some reason it should be
> >>> after sysfs it needs a comment, otherwise if it is just allocating
> >>> memory it belongs earlier, and the unwind should be done in release.
> >>>
> >>> I also think it is very strange/wrong that both sysfs and counters are
> >>> allocating the same alloc_hw_stats object
> >>>
> >>> Why can't they share?
> >>
> >> They can, but we wanted to separate "legacy" counters which were exposed
> >> through sysfs and "new" counters which can be enabled/disable automatically.
> >
> > Is there any cross contamination through the hw_stats? If no they
> > should just share. >
>
> sysfs hw_stats holds the port counter, while this one holds the
> history value of all dynamically allocated counters. They can not share.
> port_counter =
>    default_counter + running_dynamic_counter + history_dynamic_counter

I'm not saying that it is right thing to do, but nothing prevents from you
to add extra field to port_counter exactly for that.

Thanks

>
> > Jason
> >
>
