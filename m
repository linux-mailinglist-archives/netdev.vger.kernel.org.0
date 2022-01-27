Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E92DD49DA8D
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 07:21:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236524AbiA0GVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 01:21:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233650AbiA0GVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 01:21:15 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1E59C061714;
        Wed, 26 Jan 2022 22:21:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 67B26CE20C7;
        Thu, 27 Jan 2022 06:21:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E7EC340E4;
        Thu, 27 Jan 2022 06:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643264471;
        bh=zJmqePyQdIm7Sgje3Ey2ITDd4JxuUQs0i9zCmzcmKqk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a2JAfcW4XzCtPzF+yYU7b3h58gvSzelMg4Nk652Q0RTwjtG2Yqo5zi9FYg1/0T1re
         boJ9N/zrHSZ6/i4IixqL/bjpxx8w0zGhC/JcEsoK8BEczNPlSy88xIfFI7L+K1/2/q
         i/jCaKC8FC/JUtrgvpCfaVEQT0FJ6U9J7m0zSIHe9jxoVXi7WMyzVZ5z65H2TE4gVe
         /dEA8E585CmE/qk4R/5xB11R2EllYk+OyLv0pzcE6hjq7DXjSSNx32ZNAQ91u1KCKp
         a4T+EBY4vCgKvEvJ+cNMJX1OSSo6UuvIQ1+THBJMy/WBc+Fb8haVVNcvtrQkluRNgg
         bIq0Gy3bC90nQ==
Date:   Thu, 27 Jan 2022 08:21:07 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, kgraul@linux.ibm.com,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 0/6] net/smc: Spread workload over multiple
 cores
Message-ID: <YfI50xqsv20KDpz9@unreal>
References: <20220114054852.38058-1-tonylu@linux.alibaba.com>
 <YePesYRnrKCh1vFy@unreal>
 <YfD26mhGkM9DFBV+@TonyMac-Alibaba>
 <20220126152806.GN8034@ziepe.ca>
 <YfIOHZ7hSfogeTyS@TonyMac-Alibaba>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfIOHZ7hSfogeTyS@TonyMac-Alibaba>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 11:14:37AM +0800, Tony Lu wrote:
> On Wed, Jan 26, 2022 at 11:28:06AM -0400, Jason Gunthorpe wrote:
> > On Wed, Jan 26, 2022 at 03:23:22PM +0800, Tony Lu wrote:
> > > On Sun, Jan 16, 2022 at 11:00:33AM +0200, Leon Romanovsky wrote:
> > > > 
> > > > Please CC RDMA mailing list next time.
> > > > 
> > > > Why didn't you use already existed APIs in drivers/infiniband/core/cq.c?
> > > > ib_cq_pool_get() will do most if not all of your open-coded CQ spreading
> > > > logic.
> > > 
> > > I am working on replacing with ib_cq_pool_get(), this need ib_poll_context
> > > to indicate the poller which provides by ib_poll_handler(). It's okay
> > > for now, but for the callback function. When it polled a ib_wc, it
> > > would call wc->wr_cqe->done(cq, wc), which is the union with wr_id. The
> > > wr_id is heavily used in SMC.
> > 
> > Part of using the new interface is converting to use wr_cqe, you
> > should just do that work instead of trying to duplicate a core API in
> > a driver.
> 
> Thanks for your advice. This patch set aims to improve performance with
> current API in SMC protocol, which is more urgent. 

This code existed from 2017, it is hard to agree with "urgent" claim.

Thanks
