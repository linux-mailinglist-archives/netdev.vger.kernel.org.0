Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A03A235B3D0
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 13:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235594AbhDKLsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 07:48:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:38740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235580AbhDKLst (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Apr 2021 07:48:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2993B601FC;
        Sun, 11 Apr 2021 11:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618141710;
        bh=nmI+qlXljKnruABgp1DWerUhyqhgxhVfzsamG8frCJ8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VEwYER+uUom3Y/F9J9eA0+Zzq3D5fJ/24n76eWfWyzluIUdLeMb+ebXKqCfpT7fDb
         QpxCBmCdy/Yt0ylPaygrqfxeSmiP9dMj2Le/2o+BD2XuHWT3DTSX0NLJWxA90tr/xk
         +LaaBCMDtkRvCRmmpQNlJ01w0lTSGAyHvZtfuoeiKjdZqu57Gz0O/gC9cvJE8Svhqi
         Y6AQQoNp2U0AodFt9ce9o61SlFtaZfWXccFd3z0Pqap23P6m7qqwFjX+6mUdwl/M56
         MGHatZDE8ZM9HGjyxyezl9+n65l87Kp2jMISqXSjIP2W0WLIC+WeOlGfi0NNQBdzbC
         N972/nkSnvvuA==
Date:   Sun, 11 Apr 2021 14:48:27 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH v4 01/23] iidc: Introduce iidc.h
Message-ID: <YHLiC7+ftNqLVMKn@unreal>
References: <20210406210125.241-1-shiraz.saleem@intel.com>
 <20210406210125.241-2-shiraz.saleem@intel.com>
 <20210407154430.GA502757@nvidia.com>
 <1e61169b83ac458aa9357298ecfab846@intel.com>
 <20210407224324.GH282464@nvidia.com>
 <YG6tZ/iRFpt3OELK@unreal>
 <61852f3ff556421c9fd89edc0ee50417@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61852f3ff556421c9fd89edc0ee50417@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 09, 2021 at 01:38:37AM +0000, Saleem, Shiraz wrote:
> > Subject: Re: [PATCH v4 01/23] iidc: Introduce iidc.h
> > 
> > On Wed, Apr 07, 2021 at 07:43:24PM -0300, Jason Gunthorpe wrote:
> > > On Wed, Apr 07, 2021 at 08:58:49PM +0000, Saleem, Shiraz wrote:
> > > > > Subject: Re: [PATCH v4 01/23] iidc: Introduce iidc.h
> > > > >
> > > > > On Tue, Apr 06, 2021 at 04:01:03PM -0500, Shiraz Saleem wrote:
> > > > >
> > > > > > +/* Following APIs are implemented by core PCI driver */ struct
> > > > > > +iidc_core_ops {
> > > > > > +	/* APIs to allocate resources such as VEB, VSI, Doorbell queues,
> > > > > > +	 * completion queues, Tx/Rx queues, etc...
> > > > > > +	 */
> > > > > > +	int (*alloc_res)(struct iidc_core_dev_info *cdev_info,
> > > > > > +			 struct iidc_res *res,
> > > > > > +			 int partial_acceptable);
> > > > > > +	int (*free_res)(struct iidc_core_dev_info *cdev_info,
> > > > > > +			struct iidc_res *res);
> > > > > > +
> > > > > > +	int (*request_reset)(struct iidc_core_dev_info *cdev_info,
> > > > > > +			     enum iidc_reset_type reset_type);
> > > > > > +
> > > > > > +	int (*update_vport_filter)(struct iidc_core_dev_info *cdev_info,
> > > > > > +				   u16 vport_id, bool enable);
> > > > > > +	int (*vc_send)(struct iidc_core_dev_info *cdev_info, u32 vf_id, u8
> > *msg,
> > > > > > +		       u16 len);
> > > > > > +};
> > > > >
> > > > > What is this? There is only one implementation:
> > > > >
> > > > > static const struct iidc_core_ops ops = {
> > > > > 	.alloc_res			= ice_cdev_info_alloc_res,
> > > > > 	.free_res			= ice_cdev_info_free_res,
> > > > > 	.request_reset			= ice_cdev_info_request_reset,
> > > > > 	.update_vport_filter		= ice_cdev_info_update_vsi_filter,
> > > > > 	.vc_send			= ice_cdev_info_vc_send,
> > > > > };
> > > > >
> > > > > So export and call the functions directly.
> > > >
> > > > No. Then we end up requiring ice to be loaded even when just want to
> > > > use irdma with x722 [whose ethernet driver is "i40e"].
> > >
> > > So what? What does it matter to load a few extra kb of modules?
> > 
> > And if user cares about it, he will blacklist that module anyway.
> > 
>  blacklist ice when you just have an x722 card? How does that solve anything? You wont be able to load irdma then.

You will blacklist i40e if you want solely irdma functionality.

Thanks

> 
> Shiraz
