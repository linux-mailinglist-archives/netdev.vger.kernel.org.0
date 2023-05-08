Return-Path: <netdev+bounces-786-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B1EF76F9F70
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 08:09:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DDC74280EB4
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 06:09:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C19AB13AE1;
	Mon,  8 May 2023 06:09:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2504C442B
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 06:09:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE66C433EF;
	Mon,  8 May 2023 06:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683526181;
	bh=DR9ESMaKwm8NsHUBK4z/TFCX3IDQUJxokLl7RszMNZk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=clpL97EK1OY4BMwKvAvSWx4MZl136IHuQy/dFELAzOAo1G4EjBD6LZkugfuNKw6Ld
	 IYQheXg0amnlyfWvRZaITSBTUGzWcWIOzEJf8pK9jGdwncgLIOFiPIfeVdlhsXgK4k
	 0aPV/sRclXYRdqrJUxe84i4Vdy2ERRru8Gd07uQz7MKv5T0sId42mVzu6VeOV/aY7I
	 SScnoxYjSRuKWjXqaRkoTU7lp9iifllM4h6U0G3vwP7r/IiJ+AQS7by6X16iZZ9kgv
	 xex9BGquDw5kFSog46z/srIce7pSx4585PC0lSi7C61/nNX69xka6ekqzwdBPX0x6R
	 W/LSfWBh9i8kw==
Date: Mon, 8 May 2023 09:09:38 +0300
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
Message-ID: <20230508060938.GA6195@unreal>
References: <1683312708-24872-1-git-send-email-longli@linuxonhyperv.com>
 <20230507081053.GD525452@unreal>
 <PH7PR21MB31168035C903BD666253BF70CA709@PH7PR21MB3116.namprd21.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH7PR21MB31168035C903BD666253BF70CA709@PH7PR21MB3116.namprd21.prod.outlook.com>

On Sun, May 07, 2023 at 09:39:27PM +0000, Haiyang Zhang wrote:
> 
> 
> > -----Original Message-----
> > From: Leon Romanovsky <leon@kernel.org>
> > Sent: Sunday, May 7, 2023 4:11 AM
> > To: Long Li <longli@microsoft.com>
> > Cc: Jason Gunthorpe <jgg@ziepe.ca>; Ajay Sharma
> > <sharmaajay@microsoft.com>; Dexuan Cui <decui@microsoft.com>; KY
> > Srinivasan <kys@microsoft.com>; Haiyang Zhang <haiyangz@microsoft.com>;
> > Wei Liu <wei.liu@kernel.org>; David S. Miller <davem@davemloft.net>; Eric
> > Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo
> > Abeni <pabeni@redhat.com>; linux-rdma@vger.kernel.org; linux-
> > hyperv@vger.kernel.org; netdev@vger.kernel.org; linux-
> > kernel@vger.kernel.org
> > Subject: Re: [PATCH] RDMA/mana_ib: Use v2 version of cfg_rx_steer_req to
> > enable RX coalescing
> > 
> > On Fri, May 05, 2023 at 11:51:48AM -0700, longli@linuxonhyperv.com
> > wrote:
> > > From: Long Li <longli@microsoft.com>
> > >
> > > With RX coalescing, one CQE entry can be used to indicate multiple packets
> > > on the receive queue. This saves processing time and PCI bandwidth over
> > > the CQ.
> > >
> > > Signed-off-by: Long Li <longli@microsoft.com>
> > > ---
> > >  drivers/infiniband/hw/mana/qp.c |  5 ++++-
> > >  include/net/mana/mana.h         | 17 +++++++++++++++++
> > >  2 files changed, 21 insertions(+), 1 deletion(-)
> > 
> > Why didn't you change mana_cfg_vport_steering() too?
> 
> The mana_cfg_vport_steering() is for mana_en (Enthernet) driver, not the
> mana_ib driver.
> 
> The changes for mana_en will be done in a separate patch together with
> changes for mana_en RX code patch to support multiple packets / CQE.

I'm aware of the difference between mana_en and mana_ib.

The change you proposed doesn't depend on "support multiple packets / CQE."
and works perfectly with one packet/CQE also, does it?

Thanks

> 
> Thanks,
> - Haiyang
> 

