Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A462235826B
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 13:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231502AbhDHLpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 07:45:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:40742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231239AbhDHLpA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 07:45:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D48766112F;
        Thu,  8 Apr 2021 11:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617882289;
        bh=TjrIkgZQbjjReS/wZilXRoKxeAAi6aZecpQthZRmjMY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B0g0EuNsq1pyoLvLtN5UoypzhkovR41PrPF28OpDwo22lYtUHv7Vc5WauSl027hRh
         1hw1nRf+ogbpmjOu6SJ+qcr7AEBI/D0Ua9dk/NDOzcAzNz2rm5yhpRcVdHcnD4Il9x
         XGOI46inyBU01krwXEesgdloToVdoK/ELtElJkZi4X/ewyZXdk4Hjpt/4D8oPWAHTM
         DP9SrnuldcH9c49RMwME15smb3KeSGYz/z47eIRAtfk5uP8BAtIbC78SOMMa8hjZEN
         T8fgfJyISrBcwNOxpPUqwA+uWmPLvyjEWDtBuFGTwAd7hH0XD64MCxFR1bFUDnr9Ze
         uo7CQ1zS7O52Q==
Date:   Thu, 8 Apr 2021 14:44:45 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Devesh Sharma <devesh.sharma@broadcom.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Doug Ledford <dledford@redhat.com>,
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
Message-ID: <YG7srVMi8IEjuLfF@unreal>
References: <20210401065715.565226-1-leon@kernel.org>
 <CANjDDBiuw_VNepewLAtYE58Eg2JEsvGbpxttWyjV6DYMQdY5Zw@mail.gmail.com>
 <YGhUjarXh+BEK1pW@unreal>
 <CANjDDBiC-8pL+-ma1c0n8vjMaorm-CasV_D+_8q2LGy-AYuTVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANjDDBiC-8pL+-ma1c0n8vjMaorm-CasV_D+_8q2LGy-AYuTVg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 08, 2021 at 05:06:24PM +0530, Devesh Sharma wrote:
> On Sat, Apr 3, 2021 at 5:12 PM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Sat, Apr 03, 2021 at 03:52:13PM +0530, Devesh Sharma wrote:
> > > On Thu, Apr 1, 2021 at 12:27 PM Leon Romanovsky <leon@kernel.org> wrote:
> > > >
> > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > >
> > > > Changelog:
> > > > v2:
> > > >  * kbuild spotted that I didn't delete all code in patch #5, so deleted
> > > >    even more ulp_ops derefences.
> > > > v1: https://lore.kernel.org/linux-rdma/20210329085212.257771-1-leon@kernel.org
> > > >  * Go much deeper and removed useless ULP indirection
> > > > v0: https://lore.kernel.org/linux-rdma/20210324142524.1135319-1-leon@kernel.org
> > > > -----------------------------------------------------------------------
> > > >
> > > > The following series fixes issue spotted in [1], where bnxt_re driver
> > > > messed with module reference counting in order to implement symbol
> > > > dependency of bnxt_re and bnxt modules. All of this is done, when in
> > > > upstream we have only one ULP user of that bnxt module. The simple
> > > > declaration of exported symbol would do the trick.
> > > >
> > > > This series removes that custom module_get/_put, which is not supposed
> > > > to be in the driver from the beginning and get rid of nasty indirection
> > > > logic that isn't relevant for the upstream code.
> > > >
> > > > Such small changes allow us to simplify the bnxt code and my hope that
> > > > Devesh will continue where I stopped and remove struct bnxt_ulp_ops too.
> > > >
> > > > Thanks
> > > >
> > > > [1] https://lore.kernel.org/linux-rdma/20210324142524.1135319-1-leon@kernel.org
> > > >
> > > > Leon Romanovsky (5):
> > > >   RDMA/bnxt_re: Depend on bnxt ethernet driver and not blindly select it
> > > >   RDMA/bnxt_re: Create direct symbolic link between bnxt modules
> > > >   RDMA/bnxt_re: Get rid of custom module reference counting
> > > >   net/bnxt: Remove useless check of non-existent ULP id
> > > >   net/bnxt: Use direct API instead of useless indirection
> > > >
> > > >  drivers/infiniband/hw/bnxt_re/Kconfig         |   4 +-
> > > >  drivers/infiniband/hw/bnxt_re/main.c          |  93 ++-----
> > > >  drivers/net/ethernet/broadcom/bnxt/bnxt.c     |   4 +-
> > > >  drivers/net/ethernet/broadcom/bnxt/bnxt.h     |   1 -
> > > >  drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c | 245 +++++++-----------
> > > >  drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h |  32 +--
> > > >  6 files changed, 119 insertions(+), 260 deletions(-)
> > >
> > > Hi Leon,
> > >
> > > After a couple of internal discussions we reached a conclusion to
> > > implement the Auxbus driver interface and fix the problem once and for
> > > all.
> >
> > Thanks Devesh,
> >
> > Jason, it looks like we can proceed with this patchset, because in
> > auxbus mode this module refcount and ULP indirection logics will be
> > removed anyway.
> >
> > Thanks
> Hi Leon,
> 
> In my internal testing, I am seeing a crash using the 3rd patch. I am
> spending a few cycles on debugging it. expect my input in a day or so.

Can you please post the kernel crash report here?
I don't see how function rename in patch #3 can cause to the crash.

Thanks

> >
> > > >
> > > > --
> > > > 2.30.2
> > > >
> > >
> > >
> > > --
> > > -Regards
> > > Devesh
> >
> >
> 
> 
> -- 
> -Regards
> Devesh


