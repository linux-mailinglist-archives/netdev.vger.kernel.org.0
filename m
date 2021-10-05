Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A30AE422444
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 13:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234574AbhJELC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 07:02:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:42920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234376AbhJELCA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 07:02:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B933861139;
        Tue,  5 Oct 2021 11:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633431609;
        bh=v5FbJo5qrVUlbMZ3ddNVAYvu1mAUooqD0BmTMDlbz5k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xqck704VhP00sB3C9xaIHqb0opFwk5rr4RrKGlmHwh0EWL6l8+WCC8JySWIaECkaK
         rrH/af/kA/hxkUStFGDoonuPFVPhGxcqDdIckeuUqoGLj1SxV3fWaUqh9X+Ol9N1XV
         XlcgxMLyorZsPoqNQCFsEXvrsqkuqaEWK/GOsQg1ISFdEHJm41gEQrFHLdalOtmYcy
         btM7o8bjeJBQShzOXbKOQ9CjDt26gDSenSgKqkmjR9FlMLAB4brYy5sKD1dqTSdFUp
         cbc7Dm9AtOmLHl37TiL/Nrrf3B57aCprbV/nEtPBd/3MZrvPWM0sVNrWA8jrxTFEea
         1F90rekWBDfJg==
Date:   Tue, 5 Oct 2021 14:00:05 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Doug Ledford <dledford@redhat.com>,
        Aharon Landau <aharonl@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Gal Pressman <galpress@amazon.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Mark Zhang <markzhang@nvidia.com>,
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
Subject: Re: [PATCH rdma-next v2 13/13] RDMA/nldev: Add support to get status
 of all counters
Message-ID: <YVwwNTiBBOl591nZ@unreal>
References: <cover.1632988543.git.leonro@nvidia.com>
 <e4f07e8ff4c79eabc12fd8cd859deb7b3c6391f0.1632988543.git.leonro@nvidia.com>
 <20211004180714.GE2515663@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004180714.GE2515663@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 04, 2021 at 03:07:14PM -0300, Jason Gunthorpe wrote:
> On Thu, Sep 30, 2021 at 11:02:29AM +0300, Leon Romanovsky wrote:
> > +static int stat_get_doit_default_counter(struct sk_buff *skb,
> > +					 struct nlmsghdr *nlh,
> > +					 struct netlink_ext_ack *extack,
> > +					 struct nlattr *tb[])
> > +{
> > +	struct rdma_hw_stats *stats;
> > +	struct ib_device *device;
> > +	u32 index, port;
> > +	int ret;
> > +
> > +	if (!tb[RDMA_NLDEV_ATTR_DEV_INDEX] || !tb[RDMA_NLDEV_ATTR_PORT_INDEX])
> > +		return -EINVAL;
> > +
> > +	index = nla_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
> > +	device = ib_device_get_by_index(sock_net(skb->sk), index);
> > +	if (!device)
> > +		return -EINVAL;
> > +
> > +	port = nla_get_u32(tb[RDMA_NLDEV_ATTR_PORT_INDEX]);
> > +	if (!rdma_is_port_valid(device, port)) {
> > +		ret = -EINVAL;
> > +		goto end;
> > +	}
> > +
> > +	stats = ib_get_hw_stats_port(device, port);
> > +	if (!stats) {
> > +		ret = -EINVAL;
> > +		goto end;
> > +	}
> > +
> > +	if (tb[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_DYNAMIC])
> > +		ret = stat_get_doit_stats_list(skb, nlh, extack, tb,
> > +					       device, port, stats);
> > +	else
> > +		ret = stat_get_doit_stats_values(skb, nlh, extack, tb, device,
> > +						 port, stats);
> 
> And this is still here - 'gets' do not act differently depending on
> inputs..

This patch shouldn't be sent at all. Sorry for the noise.

Thanks

> 
> Jason
