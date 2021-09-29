Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE4D341C466
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 14:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343724AbhI2MQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 08:16:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:58334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245720AbhI2MQV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 08:16:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D363613D1;
        Wed, 29 Sep 2021 12:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632917680;
        bh=Gk5L1HO79jr/JO19wYKh1z/Tzn+nTQ0k9HT+5hhX858=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jG+uzh7KqpR3d2Dl/n6y4EInRtz0NPTN6gMkdo3y88cIBH1wGZk7xwLT5VTJ/HoeY
         vH8r/dbGc3iZ43XmxOBCEhU1JlEOj+lQ/x9GozdXnY5ZV/9arRP7aVpG0EMC5oF66n
         NZNcj/gY2f1gPnhOOJePuImq78ydHkhSgDR/KzN2HflgTncwOi+AyFwNKH8OOyAmSq
         6l1ipIL5R+lg2pfxA0+Q+nIb7cbTeVDGvkFe0PcDxtSqyqK+0W7m5xKVw96FeZOLiz
         bXFAWsapEUZOERtnSRUp18n1xhHZjGmwxW+nt/yZLAbIwPrGUM0K+agFomX6rK2TU7
         FTw53oIpjSl5g==
Date:   Wed, 29 Sep 2021 15:14:36 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Mark Zhang <markzhang@nvidia.com>,
        Doug Ledford <dledford@redhat.com>,
        Aharon Landau <aharonl@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Gal Pressman <galpress@amazon.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        Neta Ostrovsky <netao@nvidia.com>, netdev@vger.kernel.org,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: Re: [PATCH rdma-next v1 05/11] RDMA/counter: Add optional counter
 support
Message-ID: <YVRYrNRkWokr3Xsc@unreal>
References: <cover.1631660727.git.leonro@nvidia.com>
 <04bd7354c6a375e684712d79915f7eb816efee92.1631660727.git.leonro@nvidia.com>
 <20210927170318.GB1529966@nvidia.com>
 <d9cd401a-b5fe-65ea-21c4-6d4c037fd641@nvidia.com>
 <20210928115135.GG964074@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210928115135.GG964074@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 08:51:35AM -0300, Jason Gunthorpe wrote:
> On Tue, Sep 28, 2021 at 05:03:24PM +0800, Mark Zhang wrote:
> > On 9/28/2021 1:03 AM, Jason Gunthorpe wrote:
> > > On Wed, Sep 15, 2021 at 02:07:24AM +0300, Leon Romanovsky wrote:
> > > > +int rdma_counter_modify(struct ib_device *dev, u32 port, int index, bool enable)
> > > > +{
> > > > +	struct rdma_hw_stats *stats;
> > > > +	int ret;
> > > > +
> > > > +	if (!dev->ops.modify_hw_stat)
> > > > +		return -EOPNOTSUPP;
> > > > +
> > > > +	stats = ib_get_hw_stats_port(dev, port);
> > > > +	if (!stats)
> > > > +		return -EINVAL;
> > > > +
> > > > +	mutex_lock(&stats->lock);
> > > > +	ret = dev->ops.modify_hw_stat(dev, port, index, enable);
> > > > +	if (!ret)
> > > > +		enable ? clear_bit(index, stats->is_disabled) :
> > > > +			set_bit(index, stats->is_disabled);
> > > 
> > > This is not a kernel coding style write out the if, use success
> > > oriented flow
> > > 
> > > Also, shouldn't this logic protect the driver from being called on
> > > non-optional counters?
> > 
> > We leave it to driver, driver would return failure if modify is not
> > supported. Is it good?
> 
> I think the core code should do it
> 
> > > >   	for (i = 0; i < data->stats->num_counters; i++) {
> > > > -		attr = &data->attrs[i];
> > > > +		if (data->stats->descs[i].flags & IB_STAT_FLAG_OPTIONAL)
> > > > +			continue;
> > > > +		attr = &data->attrs[pos];
> > > >   		sysfs_attr_init(&attr->attr.attr);
> > > >   		attr->attr.attr.name = data->stats->descs[i].name;
> > > >   		attr->attr.attr.mode = 0444;
> > > >   		attr->attr.show = hw_stat_device_show;
> > > >   		attr->show = show_hw_stats;
> > > > -		data->group.attrs[i] = &attr->attr.attr;
> > > > +		data->group.attrs[pos] = &attr->attr.attr;
> > > > +		pos++;
> > > >   	}
> > > 
> > > This isn't OK, the hw_stat_device_show() computes the stat index like
> > > this:
> > > 
> > > 	return stat_attr->show(ibdev, ibdev->hw_stats_data->stats,
> > > 			       stat_attr - ibdev->hw_stats_data->attrs, 0, buf);
> > > 
> > > Which assumes the stats are packed contiguously. This only works
> > > because mlx5 is always putting the optional stats at the end.
> > 
> > Yes you are right, thanks. Maybe we can add an "index" field in struct
> > hw_stats_device/port_attribute, then set it in setup and use it in show.
> 
> You could just add a WARN_ON check that optional stats are at the end
> I suppose

Everyone adds their counters to the end, last example is bnxt_re
9a381f7e5aa2 ("RDMA/bnxt_re: Add extended statistics counters")

Thanks

> 
> Jason
