Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D01CE41C4B5
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 14:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343829AbhI2M2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 08:28:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:38838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343801AbhI2M2K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 08:28:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7A7D6134F;
        Wed, 29 Sep 2021 12:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632918389;
        bh=koikjoePa7AY6dydALCEgN1Mu+kNaM/UxhhdxgxoFB8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G+pdHb7OjDKhePfUMG41+ZYS0MuoT2n8aX0GJhjUa8TaGytboes4QUP1fumUJIZ0w
         tQ3RhI+OGb7IPQDGng/EMauWFIW6DqUOooKAkLTIPWbAYx3ZUSEA4Ff0WzHj7I4rc7
         44Ou3seNoPI9FCcPPYeNKnjbDFsXbYry++6sBMC0fagrklbA+Bb+B04824a+1p2lN+
         Wb8T5gdLTRIqSolYo9FSxVFh3FIBfCkIYNpWsn5hh/PpTGjwH1JlomyWsce3QVWYB5
         noxTaH1y+tBcn6+anr10yZnryCnizoaBkNs5IAigfvBpVu5m8O2vZRdx0g/jiL9CBi
         mdfV8c1AbRnRQ==
Date:   Wed, 29 Sep 2021 15:26:25 +0300
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
Subject: Re: [PATCH rdma-next v1 06/11] RDMA/nldev: Add support to get status
 of all counters
Message-ID: <YVRbcXJL/LBaSLLJ@unreal>
References: <cover.1631660727.git.leonro@nvidia.com>
 <86b8a508d7e782b003d60acb06536681f0d4c721.1631660727.git.leonro@nvidia.com>
 <20210927173001.GD1529966@nvidia.com>
 <d812f553-1fc5-f228-18cb-07dce02eeb85@nvidia.com>
 <20210928115217.GI964074@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210928115217.GI964074@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 08:52:17AM -0300, Jason Gunthorpe wrote:
> On Tue, Sep 28, 2021 at 05:12:39PM +0800, Mark Zhang wrote:
> > On 9/28/2021 1:30 AM, Jason Gunthorpe wrote:
> > > On Wed, Sep 15, 2021 at 02:07:25AM +0300, Leon Romanovsky wrote:
> > > > +static int stat_get_doit_default_counter(struct sk_buff *skb,
> > > > +					 struct nlmsghdr *nlh,
> > > > +					 struct netlink_ext_ack *extack,
> > > > +					 struct nlattr *tb[])
> > > > +{
> > > > +	struct rdma_hw_stats *stats;
> > > > +	struct ib_device *device;
> > > > +	u32 index, port;
> > > > +	int ret;
> > > > +
> > > > +	if (!tb[RDMA_NLDEV_ATTR_DEV_INDEX] || !tb[RDMA_NLDEV_ATTR_PORT_INDEX])
> > > > +		return -EINVAL;
> > > > +
> > > > +	index = nla_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
> > > > +	device = ib_device_get_by_index(sock_net(skb->sk), index);
> > > > +	if (!device)
> > > > +		return -EINVAL;
> > > > +
> > > > +	port = nla_get_u32(tb[RDMA_NLDEV_ATTR_PORT_INDEX]);
> > > > +	if (!rdma_is_port_valid(device, port)) {
> > > > +		ret = -EINVAL;
> > > > +		goto end;
> > > > +	}
> > > > +
> > > > +	stats = ib_get_hw_stats_port(device, port);
> > > > +	if (!stats) {
> > > > +		ret = -EINVAL;
> > > > +		goto end;
> > > > +	}
> > > > +
> > > > +	if (tb[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_DYNAMIC])
> > > > +		ret = stat_get_doit_stats_list(skb, nlh, extack, tb,
> > > > +					       device, port, stats);
> > > > +	else
> > > > +		ret = stat_get_doit_stats_values(skb, nlh, extack, tb, device,
> > > > +						 port, stats);
> > > 
> > > This seems strange, why is the output of a get contingent on a ignored
> > > input attribute? Shouldn't the HWCOUNTER_DYNAMIC just always be
> > > emitted?
> > 
> > The CMD_STAT_GET is originally used to get the default hwcounter statistic
> > (the value of all hwstats), now we also want to use this command to get a
> > list of counters (just name and status), so kernel differentiates these 2
> > cases based on HWCOUNTER_DYNAMIC attr.
> 
> Don't do that, it is not how netlink works. Either the whole attribute
> should be returned or you need a new get command

The netlink way is to be independent on returned parameter, if it not
supported, this parameter won't be available at all. This makes HWCOUNTER_DYNAMIC
to work exactly as netlink would do.

Thanks

> 
> Jason 
