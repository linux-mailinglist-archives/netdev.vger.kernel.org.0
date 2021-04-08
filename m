Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2A6A357D5D
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 09:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbhDHHaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 03:30:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:52274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229566AbhDHHaT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 03:30:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69BDA61104;
        Thu,  8 Apr 2021 07:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617867009;
        bh=xHvEEbDy+GdrYbsrArw4v1nl5+OHtHrx9LgIr/6WA/U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mh2lPsagCload/kIKR2Tf9SGYVpG1Cv4H4D5sp6hR6SRor2EgtERiU8Wk+u8H1X/m
         LN8hufh8IpniDP+NCvJNwjqozCZw/7r9omXTjx08vbUeuHQB0M+9btF0NG6jzgN94b
         Fe+vpk0uuSqX8DJ0dwZ/JN6MimgnZ20OF9HhdKh3BqiILuRcfgfpoxuKQyl89NHwwP
         j6agvgXuMKxauSK2OjTl8AMv90aIgNFOxdcQp/rRVhY6wSt3KCmObOrMLdz7u1RoLP
         Mc6/M2ydfUa2utitlGbfQx859QRI9x+cal/L6wMKAdGhIaxGdeI8uxjaZVquvlK2Wm
         fLcDnDAD7yWRQ==
Date:   Thu, 8 Apr 2021 10:14:47 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH v4 01/23] iidc: Introduce iidc.h
Message-ID: <YG6tZ/iRFpt3OELK@unreal>
References: <20210406210125.241-1-shiraz.saleem@intel.com>
 <20210406210125.241-2-shiraz.saleem@intel.com>
 <20210407154430.GA502757@nvidia.com>
 <1e61169b83ac458aa9357298ecfab846@intel.com>
 <20210407224324.GH282464@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210407224324.GH282464@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 07, 2021 at 07:43:24PM -0300, Jason Gunthorpe wrote:
> On Wed, Apr 07, 2021 at 08:58:49PM +0000, Saleem, Shiraz wrote:
> > > Subject: Re: [PATCH v4 01/23] iidc: Introduce iidc.h
> > > 
> > > On Tue, Apr 06, 2021 at 04:01:03PM -0500, Shiraz Saleem wrote:
> > > 
> > > > +/* Following APIs are implemented by core PCI driver */ struct
> > > > +iidc_core_ops {
> > > > +	/* APIs to allocate resources such as VEB, VSI, Doorbell queues,
> > > > +	 * completion queues, Tx/Rx queues, etc...
> > > > +	 */
> > > > +	int (*alloc_res)(struct iidc_core_dev_info *cdev_info,
> > > > +			 struct iidc_res *res,
> > > > +			 int partial_acceptable);
> > > > +	int (*free_res)(struct iidc_core_dev_info *cdev_info,
> > > > +			struct iidc_res *res);
> > > > +
> > > > +	int (*request_reset)(struct iidc_core_dev_info *cdev_info,
> > > > +			     enum iidc_reset_type reset_type);
> > > > +
> > > > +	int (*update_vport_filter)(struct iidc_core_dev_info *cdev_info,
> > > > +				   u16 vport_id, bool enable);
> > > > +	int (*vc_send)(struct iidc_core_dev_info *cdev_info, u32 vf_id, u8 *msg,
> > > > +		       u16 len);
> > > > +};
> > > 
> > > What is this? There is only one implementation:
> > > 
> > > static const struct iidc_core_ops ops = {
> > > 	.alloc_res			= ice_cdev_info_alloc_res,
> > > 	.free_res			= ice_cdev_info_free_res,
> > > 	.request_reset			= ice_cdev_info_request_reset,
> > > 	.update_vport_filter		= ice_cdev_info_update_vsi_filter,
> > > 	.vc_send			= ice_cdev_info_vc_send,
> > > };
> > > 
> > > So export and call the functions directly.
> > 
> > No. Then we end up requiring ice to be loaded even when just want to
> > use irdma with x722 [whose ethernet driver is "i40e"].
> 
> So what? What does it matter to load a few extra kb of modules?

And if user cares about it, he will blacklist that module anyway.

Thanks
