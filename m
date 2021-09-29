Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFA1941C4BA
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 14:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343740AbhI2M30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 08:29:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:39726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343663AbhI2M3Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 08:29:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C6716136A;
        Wed, 29 Sep 2021 12:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632918464;
        bh=04PK2e2owAZsxYw/jgzamWIUpNBuQ0xgeox+J3/mX0A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fLP9Yty4qIQb/fvdLQ77tf9nUbVl7Pd5vfVAKthYszuAHVLLsTOdpjjD4hkEzUiW4
         TMe3fF+7OiWSGBSqm70CNM3mV4STJzdrgg7fPUPzmVJcPYovOnk6njkyBHO+jbhgJ2
         0VYQkvEhodFrv3r7okLkikMUUX8mwGeddn+vCvw6z5Hd7atd7G4f1ZFZ8jqANr1Qcl
         lw4Zu1qsJABX+LfRkrM4hFOTT7y7cDQRY5Yfd8y+qvdPY80K8v9u7b0VI/8UnluZTZ
         mhGn9xB9Jq5ktEOsO7yNth1w8BdLeESoC9L9O8D4AwxYvZ1QiiiBhw92h9yjD0XS+Q
         4Oh6IDFVZOVVQ==
Date:   Wed, 29 Sep 2021 15:27:39 +0300
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
Subject: Re: [PATCH rdma-next v1 07/11] RDMA/nldev: Allow optional-counter
 status configuration through RDMA netlink
Message-ID: <YVRbu37xbRgEXTlX@unreal>
References: <cover.1631660727.git.leonro@nvidia.com>
 <ed88592c676c5926195a6f89926146acaa466641.1631660727.git.leonro@nvidia.com>
 <20210927172006.GC1529966@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210927172006.GC1529966@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 27, 2021 at 02:20:06PM -0300, Jason Gunthorpe wrote:
> On Wed, Sep 15, 2021 at 02:07:26AM +0300, Leon Romanovsky wrote:
> > -		return -EINVAL;
> > +		need_enable = false;
> > +		disabled = test_bit(i, stats->is_disabled);
> > +		nla_for_each_nested(entry_attr,
> > +				    tb[RDMA_NLDEV_ATTR_STAT_HWCOUNTERS], rem) {
> > +			index = nla_get_u32(entry_attr);
> > +			if (index >= stats->num_counters)
> > +				return -EINVAL;
> > +			if (i == index) {
> > +				need_enable = true;
> > +				break;
> > +			}
> > +		}
> >  
> > -	port = nla_get_u32(tb[RDMA_NLDEV_ATTR_PORT_INDEX]);
> > -	if (!rdma_is_port_valid(device, port)) {
> > -		ret = -EINVAL;
> > -		goto err;
> > +		if (disabled && need_enable)
> > +			ret = rdma_counter_modify(device, port, i, true);
> > +		else if (!disabled && !need_enable)
> > +			ret = rdma_counter_modify(device, port, i, false);
> 
> This disabled check looks racy, I would do the no-change optimization inside
> rdma_counter_modify()
> 
> Also, this is a O(N^2) algorithm, why not do it in one pass with a
> small memory allocation for the target state bitmap?

We don't have many counters. Is this optimization really worth it?

Thanks

> 
> Jason
