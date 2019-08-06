Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8AF82C2F
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 09:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731977AbfHFHAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 03:00:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:33218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731735AbfHFHAD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Aug 2019 03:00:03 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CA4D20B1F;
        Tue,  6 Aug 2019 07:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565074802;
        bh=NHXSXNOhcukgOBIw2+t1RdqqbL8a+wF17UGBnsCwGWw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uEDO/vfE69v6yPrGRGjKu0hop5bMB1qrJSxijrDd6TYv552kGPvGsYu2myE/4d05Y
         99L1C/Htis4Bvv+AtLMz/0+vSJflB3nyYp5hLzutbBA8jP9x1n6U2UfBSOWKvbWd+O
         TdTpUO//vyfvLUrRDF1gL44fMSAi6dsKQpNZ+KeQ=
Date:   Tue, 6 Aug 2019 09:59:58 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "hslester96@gmail.com" <hslester96@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] net/mlx5e: Use refcount_t for refcount
Message-ID: <20190806065958.GQ4832@mtr-leonro.mtl.com>
References: <20190802164828.20243-1-hslester96@gmail.com>
 <20190804125858.GJ4832@mtr-leonro.mtl.com>
 <CANhBUQ2H5MU0m2xM0AkJGPf7+MJBZ3Eq5rR0kgeOoKRi4q1j6Q@mail.gmail.com>
 <20190805061320.GN4832@mtr-leonro.mtl.com>
 <CANhBUQ0tUTXQKq__zvhNCUxXTFfDyr2xKF+Cwupod9xmvSrw2A@mail.gmail.com>
 <b19b7cd49d373cc51d3e745a6444b27166b88304.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b19b7cd49d373cc51d3e745a6444b27166b88304.camel@mellanox.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 05, 2019 at 08:06:36PM +0000, Saeed Mahameed wrote:
> On Mon, 2019-08-05 at 14:55 +0800, Chuhong Yuan wrote:
> > On Mon, Aug 5, 2019 at 2:13 PM Leon Romanovsky <leon@kernel.org>
> > wrote:
> > > On Sun, Aug 04, 2019 at 10:44:47PM +0800, Chuhong Yuan wrote:
> > > > On Sun, Aug 4, 2019 at 8:59 PM Leon Romanovsky <leon@kernel.org>
> > > > wrote:
> > > > > On Sat, Aug 03, 2019 at 12:48:28AM +0800, Chuhong Yuan wrote:
> > > > > > refcount_t is better for reference counters since its
> > > > > > implementation can prevent overflows.
> > > > > > So convert atomic_t ref counters to refcount_t.
> > > > >
> > > > > I'm not thrilled to see those automatic conversion patches,
> > > > > especially
> > > > > for flows which can't overflow. There is nothing wrong in using
> > > > > atomic_t
> > > > > type of variable, do you have in mind flow which will cause to
> > > > > overflow?
> > > > >
> > > > > Thanks
> > > >
> > > > I have to say that these patches are not done automatically...
> > > > Only the detection of problems is done by a script.
> > > > All conversions are done manually.
> > >
> > > Even worse, you need to audit usage of atomic_t and replace there
> > > it can overflow.
> > >
> > > > I am not sure whether the flow can cause an overflow.
> > >
> > > It can't.
> > >
> > > > But I think it is hard to ensure that a data path is impossible
> > > > to have problems in any cases including being attacked.
> > >
> > > It is not data path, and I doubt that such conversion will be
> > > allowed
> > > in data paths without proving that no performance regression is
> > > introduced.
> > > > So I think it is better to do this minor revision to prevent
> > > > potential risk, just like we have done in mlx5/core/cq.c.
> > >
> > > mlx5/core/cq.c is a different beast, refcount there means actual
> > > users
> > > of CQ which are limited in SW, so in theory, they have potential
> > > to be overflown.
> > >
> > > It is not the case here, there your are adding new port.
> > > There is nothing wrong with atomic_t.
> > >
> >
> > Thanks for your explanation!
> > I will pay attention to this point in similar cases.
> > But it seems that the semantic of refcount is not always as clear as
> > here...
> >
>
> Semantically speaking, there is nothing wrong with moving to refcount_t
> in the case of vxlan ports.. it also seems more accurate and will
> provide the type protection, even if it is not necessary. Please let me
> know what is the verdict here, i can apply this patch to net-next-mlx5.

There is no verdict here, it is up to you., if you like code churn, go
for it.

Thanks

>
> Thanks,
> Saeed.
