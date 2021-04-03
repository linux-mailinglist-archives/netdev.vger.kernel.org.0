Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE703533CB
	for <lists+netdev@lfdr.de>; Sat,  3 Apr 2021 13:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236568AbhDCLmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Apr 2021 07:42:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:34190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231681AbhDCLmL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 3 Apr 2021 07:42:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3505E6121F;
        Sat,  3 Apr 2021 11:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617450128;
        bh=YA5nuoidOSoOvabVtom8gDnVF1POHXLlq0870eRpN9k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DDA2cuseS25NYcma8idcu1Zc4dYTR/YYmwepsba6Ppl7hH1ZXCer4H7fOfyaUEgyl
         0ih4Sm6R6AxWIyQzDB0jyoSHzPeUVM4srGy402zAxOgdV2K923qwpCdEn6kBLvHWqE
         pm24QDsZ9ZtMoN06s+ZgXWflb2tCTFtL2YZoR9ZDgyGOi6AZ3nuW/EOPwgN0Dj7Hbe
         GYs4TnjlfsRkS2lk6hMsuh3l6AMnUeICOfiXsoL3yjyMyyOaKTU2xftCskL18uIwaS
         crglPhg4lTdf/y7WF0N3j4eBLFIKWGRIQ4xoln1CDV7csn2oW1+iKbpRXBAZCr46UB
         C6nngR6zTqj4Q==
Date:   Sat, 3 Apr 2021 14:42:05 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Devesh Sharma <devesh.sharma@broadcom.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Doug Ledford <dledford@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        Netdev <netdev@vger.kernel.org>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Subject: Re: [PATCH rdma-next v2 0/5] Get rid of custom made module dependency
Message-ID: <YGhUjarXh+BEK1pW@unreal>
References: <20210401065715.565226-1-leon@kernel.org>
 <CANjDDBiuw_VNepewLAtYE58Eg2JEsvGbpxttWyjV6DYMQdY5Zw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANjDDBiuw_VNepewLAtYE58Eg2JEsvGbpxttWyjV6DYMQdY5Zw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 03, 2021 at 03:52:13PM +0530, Devesh Sharma wrote:
> On Thu, Apr 1, 2021 at 12:27 PM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > From: Leon Romanovsky <leonro@nvidia.com>
> >
> > Changelog:
> > v2:
> >  * kbuild spotted that I didn't delete all code in patch #5, so deleted
> >    even more ulp_ops derefences.
> > v1: https://lore.kernel.org/linux-rdma/20210329085212.257771-1-leon@kernel.org
> >  * Go much deeper and removed useless ULP indirection
> > v0: https://lore.kernel.org/linux-rdma/20210324142524.1135319-1-leon@kernel.org
> > -----------------------------------------------------------------------
> >
> > The following series fixes issue spotted in [1], where bnxt_re driver
> > messed with module reference counting in order to implement symbol
> > dependency of bnxt_re and bnxt modules. All of this is done, when in
> > upstream we have only one ULP user of that bnxt module. The simple
> > declaration of exported symbol would do the trick.
> >
> > This series removes that custom module_get/_put, which is not supposed
> > to be in the driver from the beginning and get rid of nasty indirection
> > logic that isn't relevant for the upstream code.
> >
> > Such small changes allow us to simplify the bnxt code and my hope that
> > Devesh will continue where I stopped and remove struct bnxt_ulp_ops too.
> >
> > Thanks
> >
> > [1] https://lore.kernel.org/linux-rdma/20210324142524.1135319-1-leon@kernel.org
> >
> > Leon Romanovsky (5):
> >   RDMA/bnxt_re: Depend on bnxt ethernet driver and not blindly select it
> >   RDMA/bnxt_re: Create direct symbolic link between bnxt modules
> >   RDMA/bnxt_re: Get rid of custom module reference counting
> >   net/bnxt: Remove useless check of non-existent ULP id
> >   net/bnxt: Use direct API instead of useless indirection
> >
> >  drivers/infiniband/hw/bnxt_re/Kconfig         |   4 +-
> >  drivers/infiniband/hw/bnxt_re/main.c          |  93 ++-----
> >  drivers/net/ethernet/broadcom/bnxt/bnxt.c     |   4 +-
> >  drivers/net/ethernet/broadcom/bnxt/bnxt.h     |   1 -
> >  drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c | 245 +++++++-----------
> >  drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h |  32 +--
> >  6 files changed, 119 insertions(+), 260 deletions(-)
> 
> Hi Leon,
> 
> After a couple of internal discussions we reached a conclusion to
> implement the Auxbus driver interface and fix the problem once and for
> all.

Thanks Devesh,

Jason, it looks like we can proceed with this patchset, because in
auxbus mode this module refcount and ULP indirection logics will be
removed anyway.

Thanks

> >
> > --
> > 2.30.2
> >
> 
> 
> -- 
> -Regards
> Devesh


