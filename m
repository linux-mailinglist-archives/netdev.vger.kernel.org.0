Return-Path: <netdev+bounces-1058-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65E6D6FC078
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 09:30:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B5B91C20A93
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 07:30:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FA7B6121;
	Tue,  9 May 2023 07:30:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E27391
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 07:30:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB0DDC433D2;
	Tue,  9 May 2023 07:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683617438;
	bh=8muEFwwV/fMT6/BkEavYZNU3BkDJkYBlCsjz3eXYwpk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O0jAFc4AjkqBgTofQ2McerbR+WAzpALl8ybRyuubnlmPPpxizbGh1MIKqRmtNRqq7
	 9ceWpHWPT+BGtOfeP0uCDs/bJUzeLwoGZEC/rtta1Q/lRecyT9hyxOJOkVdd7vSKV/
	 qL7w/sZSD1pO2q951gMCjSfSK/mgNGW0t0CwgfU3ytKMJHdTDqGA2Tfav44OIzhI22
	 Nch1sC3hWOP7wnnmYcPo28MrMjgipYq5nyXocaHnzTWrHyuh5DmV9apWnPLxG2s38n
	 G/jftRhXkzunLll2ZowAs21Zd7ybw17SKst/TarQfbMnvBd3S0d+4GgiVo/6UbHl3d
	 EgfzlGd8XlbLA==
Date: Tue, 9 May 2023 10:30:34 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Long Li <longli@microsoft.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Ajay Sharma <sharmaajay@microsoft.com>,
	Dexuan Cui <decui@microsoft.com>, KY Srinivasan <kys@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] RDMA/mana_ib: Use v2 version of cfg_rx_steer_req to
 enable RX coalescing
Message-ID: <20230509073034.GA38143@unreal>
References: <1683312708-24872-1-git-send-email-longli@linuxonhyperv.com>
 <20230507081053.GD525452@unreal>
 <PH7PR21MB31168035C903BD666253BF70CA709@PH7PR21MB3116.namprd21.prod.outlook.com>
 <20230508060938.GA6195@unreal>
 <PH7PR21MB3116031E5E1B5B9B97AE71BCCA719@PH7PR21MB3116.namprd21.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH7PR21MB3116031E5E1B5B9B97AE71BCCA719@PH7PR21MB3116.namprd21.prod.outlook.com>

On Mon, May 08, 2023 at 02:45:44PM +0000, Haiyang Zhang wrote:
> 
> 
> > -----Original Message-----
> > From: Leon Romanovsky <leon@kernel.org>
> > Sent: Monday, May 8, 2023 2:10 AM
> > To: Haiyang Zhang <haiyangz@microsoft.com>
> > Cc: Long Li <longli@microsoft.com>; Jason Gunthorpe <jgg@ziepe.ca>; Ajay
> > Sharma <sharmaajay@microsoft.com>; Dexuan Cui <decui@microsoft.com>;
> > KY Srinivasan <kys@microsoft.com>; Wei Liu <wei.liu@kernel.org>; David S.
> > Miller <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>;
> > Jakub Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; linux-
> > rdma@vger.kernel.org; linux-hyperv@vger.kernel.org;
> > netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH] RDMA/mana_ib: Use v2 version of cfg_rx_steer_req to
> > enable RX coalescing
> > 
> > On Sun, May 07, 2023 at 09:39:27PM +0000, Haiyang Zhang wrote:
> > >
> > >
> > > > -----Original Message-----
> > > > From: Leon Romanovsky <leon@kernel.org>
> > > > Sent: Sunday, May 7, 2023 4:11 AM
> > > > To: Long Li <longli@microsoft.com>
> > > > Cc: Jason Gunthorpe <jgg@ziepe.ca>; Ajay Sharma
> > > > <sharmaajay@microsoft.com>; Dexuan Cui <decui@microsoft.com>; KY
> > > > Srinivasan <kys@microsoft.com>; Haiyang Zhang
> > <haiyangz@microsoft.com>;
> > > > Wei Liu <wei.liu@kernel.org>; David S. Miller <davem@davemloft.net>; Eric
> > > > Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>;
> > Paolo
> > > > Abeni <pabeni@redhat.com>; linux-rdma@vger.kernel.org; linux-
> > > > hyperv@vger.kernel.org; netdev@vger.kernel.org; linux-
> > > > kernel@vger.kernel.org
> > > > Subject: Re: [PATCH] RDMA/mana_ib: Use v2 version of cfg_rx_steer_req
> > to
> > > > enable RX coalescing
> > > >
> > > > On Fri, May 05, 2023 at 11:51:48AM -0700, longli@linuxonhyperv.com
> > > > wrote:
> > > > > From: Long Li <longli@microsoft.com>
> > > > >
> > > > > With RX coalescing, one CQE entry can be used to indicate multiple
> > packets
> > > > > on the receive queue. This saves processing time and PCI bandwidth over
> > > > > the CQ.
> > > > >
> > > > > Signed-off-by: Long Li <longli@microsoft.com>
> > > > > ---
> > > > >  drivers/infiniband/hw/mana/qp.c |  5 ++++-
> > > > >  include/net/mana/mana.h         | 17 +++++++++++++++++
> > > > >  2 files changed, 21 insertions(+), 1 deletion(-)
> > > >
> > > > Why didn't you change mana_cfg_vport_steering() too?
> > >
> > > The mana_cfg_vport_steering() is for mana_en (Enthernet) driver, not the
> > > mana_ib driver.
> > >
> > > The changes for mana_en will be done in a separate patch together with
> > > changes for mana_en RX code patch to support multiple packets / CQE.
> > 
> > I'm aware of the difference between mana_en and mana_ib.
> > 
> > The change you proposed doesn't depend on "support multiple packets /
> > CQE."
> > and works perfectly with one packet/CQE also, does it?
> 
> No.
> If we add the following setting to the mana_en / mana_cfg_vport_steering(),
> the NIC may put multiple packets in one CQE, so we need to have the changes
> for mana_en RX code path to support multiple packets / CQE.
> +	req->cqe_coalescing_enable = true;

You can leave "cqe_coalescing_enable = false" for ETH and still reuse
your new v2 struct.

H> 
> So we plan to set this cqe_coalescing_enable, and the changes for mana_en 
> RX code path to support multiple packets / CQE in another patch.

And how does it work with IB without changing anything except this
proposed patch?

Thanks

> 
> Thanks,
> - Haiyang
> 

