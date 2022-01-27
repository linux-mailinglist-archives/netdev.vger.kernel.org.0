Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A05049DCDA
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 09:47:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237887AbiA0IrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 03:47:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232313AbiA0IrP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 03:47:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE456C061714;
        Thu, 27 Jan 2022 00:47:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CE4861AB2;
        Thu, 27 Jan 2022 08:47:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD585C340E4;
        Thu, 27 Jan 2022 08:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643273233;
        bh=Vqj4kJhryEB3C0HY4xanpLMqJUDI3jiL25mY25paqXM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Oemla7QPMr24bjHij7Sy91t/GpPOUnDWHsFCQ4is+b70Ka3lGNrxfcVYCnawqIB9V
         rm+c6otNtdrDb1hP+1vOkjt1FgLaoh6VVGFewCK648lR0W2Z6A8MV/ZiITrRUak+zZ
         A4uwjRWIEgRqAzH36GX3koKosIo/8Z0X4jPt0drgwHBYSYFajCtPp86ruS5Epvp/qN
         66vtreAtteT9sRyCFEnxSqXb+YAAzHKXlX7VPN48LPaDK0somtJOzs5BK2lupJmEKK
         lL+scG52lcveEe69UPXoHGz0XcMETEV8t3n4LgDTCbDhSpCgPBe4giqHO+RWjVISOK
         O5sxVvgmn8tXQ==
Date:   Thu, 27 Jan 2022 10:47:09 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, kgraul@linux.ibm.com,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 0/6] net/smc: Spread workload over multiple
 cores
Message-ID: <YfJcDfkBZfeYA1Z/@unreal>
References: <20220114054852.38058-1-tonylu@linux.alibaba.com>
 <YePesYRnrKCh1vFy@unreal>
 <YfD26mhGkM9DFBV+@TonyMac-Alibaba>
 <20220126152806.GN8034@ziepe.ca>
 <YfIOHZ7hSfogeTyS@TonyMac-Alibaba>
 <YfI50xqsv20KDpz9@unreal>
 <YfJQ6AwYMA/i4HvH@TonyMac-Alibaba>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfJQ6AwYMA/i4HvH@TonyMac-Alibaba>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 03:59:36PM +0800, Tony Lu wrote:
> On Thu, Jan 27, 2022 at 08:21:07AM +0200, Leon Romanovsky wrote:
> > On Thu, Jan 27, 2022 at 11:14:37AM +0800, Tony Lu wrote:
> > > On Wed, Jan 26, 2022 at 11:28:06AM -0400, Jason Gunthorpe wrote:
> > > > On Wed, Jan 26, 2022 at 03:23:22PM +0800, Tony Lu wrote:
> > > > > On Sun, Jan 16, 2022 at 11:00:33AM +0200, Leon Romanovsky wrote:
> > > > > > 
> > > > > > Please CC RDMA mailing list next time.
> > > > > > 
> > > > > > Why didn't you use already existed APIs in drivers/infiniband/core/cq.c?
> > > > > > ib_cq_pool_get() will do most if not all of your open-coded CQ spreading
> > > > > > logic.
> > > > > 
> > > > > I am working on replacing with ib_cq_pool_get(), this need ib_poll_context
> > > > > to indicate the poller which provides by ib_poll_handler(). It's okay
> > > > > for now, but for the callback function. When it polled a ib_wc, it
> > > > > would call wc->wr_cqe->done(cq, wc), which is the union with wr_id. The
> > > > > wr_id is heavily used in SMC.
> > > > 
> > > > Part of using the new interface is converting to use wr_cqe, you
> > > > should just do that work instead of trying to duplicate a core API in
> > > > a driver.
> > > 
> > > Thanks for your advice. This patch set aims to improve performance with
> > > current API in SMC protocol, which is more urgent. 
> > 
> > This code existed from 2017, it is hard to agree with "urgent" claim.
> 
> Yes, I agree with you that the code is old. I think there are two
> problems, one for performance issue, the other one for API refactor.
> 
> We are running into the performance issues mentioned in patches in our
> cloud environment. So I think it is more urgent for a real world issue.
> 
> The current modification is less intrusive to the code. This makes
> changes simpler. And current implement works for now, this is why I put
> refactor behind.

We are not requesting to refactor the code, but properly use existing
in-kernel API, while implementing new feature ("Spread workload over
multiple cores").

Thanks

> 
> Thank you,
> Tony Lu
