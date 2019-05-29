Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E041D2DC3E
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 13:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbfE2LzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 07:55:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:48286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726101AbfE2Ly7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 07:54:59 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D68820644;
        Wed, 29 May 2019 11:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559130898;
        bh=UgxvOXNnEgvEaS1KKNjcKQPXy8QHb1XXRse9Zsojooc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QzOGQhb6k9kItSLdE7seOeRrtSLzaBCtL5CZUOr5HkKMYXXPkHAb9oD9ZIyQneHlu
         gauPz2lC2Xq2pDprBuKdEyARdTGWlW5+9SmtfWF7WcRH7vLbdTGuEaNVQhUTSJB6DV
         U0V3xP9IiQ9mCyxogFsyS+pPkPOZzXaTY+SLLMPM=
Date:   Wed, 29 May 2019 14:54:53 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Doug Ledford <dledford@redhat.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Majd Dibbiny <majd@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next v2 17/17] RDMA/nldev: Allow get default counter
 statistics through RDMA netlink
Message-ID: <20190529115453.GY4633@mtr-leonro.mtl.com>
References: <20190429083453.16654-1-leon@kernel.org>
 <20190429083453.16654-18-leon@kernel.org>
 <20190522173011.GG15023@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522173011.GG15023@ziepe.ca>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 22, 2019 at 02:30:11PM -0300, Jason Gunthorpe wrote:
> On Mon, Apr 29, 2019 at 11:34:53AM +0300, Leon Romanovsky wrote:
> > From: Mark Zhang <markz@mellanox.com>
> >
> > This patch adds the ability to return the hwstats of per-port default
> > counters (which can also be queried through sysfs nodes).
> >
> > Signed-off-by: Mark Zhang <markz@mellanox.com>
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> >  drivers/infiniband/core/nldev.c | 101 +++++++++++++++++++++++++++++++-
> >  1 file changed, 99 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
> > index 53c1d2d82a06..cb2dd38f49f1 100644
> > +++ b/drivers/infiniband/core/nldev.c
> > @@ -1709,6 +1709,98 @@ static int nldev_stat_del_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
> >  	return ret;
> >  }
> >
> > +static int nldev_res_get_default_counter_doit(struct sk_buff *skb,
> > +					      struct nlmsghdr *nlh,
> > +					      struct netlink_ext_ack *extack,
> > +					      struct nlattr *tb[])
> > +{
> > +	struct rdma_hw_stats *stats;
> > +	struct nlattr *table_attr;
> > +	struct ib_device *device;
> > +	int ret, num_cnts, i;
> > +	struct sk_buff *msg;
> > +	u32 index, port;
> > +	u64 v;
> > +
> > +	if (!tb[RDMA_NLDEV_ATTR_DEV_INDEX] || !tb[RDMA_NLDEV_ATTR_PORT_INDEX])
> > +		return -EINVAL;
> > +
> > +	index = nla_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
> > +	device = ib_device_get_by_index(sock_net(skb->sk), index);
> > +	if (!device)
> > +		return -EINVAL;
> > +
> > +	if (!device->ops.alloc_hw_stats || !device->ops.get_hw_stats) {
> > +		ret = -EINVAL;
> > +		goto err;
> > +	}
> > +
> > +	port = nla_get_u32(tb[RDMA_NLDEV_ATTR_PORT_INDEX]);
> > +	if (!rdma_is_port_valid(device, port)) {
> > +		ret = -EINVAL;
> > +		goto err;
> > +	}
> > +
> > +	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
> > +	if (!msg) {
> > +		ret = -ENOMEM;
> > +		goto err;
> > +	}
> > +
> > +	nlh = nlmsg_put(msg, NETLINK_CB(skb).portid, nlh->nlmsg_seq,
> > +			RDMA_NL_GET_TYPE(RDMA_NL_NLDEV,
> > +					 RDMA_NLDEV_CMD_STAT_GET),
> > +			0, 0);
> > +
> > +	if (fill_nldev_handle(msg, device) ||
> > +	    nla_put_u32(msg, RDMA_NLDEV_ATTR_PORT_INDEX, port)) {
> > +		ret = -EMSGSIZE;
> > +		goto err_msg;
> > +	}
> > +
> > +	stats = device->ops.alloc_hw_stats(device, port);
> > +	if (!stats) {
> > +		ret = -ENOMEM;
> > +		goto err_msg;
> > +	}
>
> Why do we need yet another one of these to be allocated?

I would say that it is bug.

>
> > +	num_cnts = device->ops.get_hw_stats(device, stats, port, 0);
>
> Is '0' right here?

I think that "index" (third parameter) is not used at all.

>
> Jason
