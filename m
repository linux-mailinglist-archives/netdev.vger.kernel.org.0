Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 474BC13DD7
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 08:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727356AbfEEGW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 02:22:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:59542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726237AbfEEGW4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 May 2019 02:22:56 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AB9320644;
        Sun,  5 May 2019 06:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557037375;
        bh=asbmlY+vrT0BEESfBu94E7n5cdnH4bf1PXYThT4BiDI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Wz+whTWieue87PBAHMJ36qI+QaiyojG8R+IHXpMbxlZevj9yNIfdC7kQpX1p5v1dU
         C3n9s1N9SxLgq5nI4Cl5mMyChBD8yqorvChH+pHsuFt9d5NmbBXfbgNwwDQTpwfL58
         Lz4Km6lX2dm+n8pj2yXew0t9wVAy58JLb6oCBLvY=
Date:   Sun, 5 May 2019 09:22:50 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Moni Shoua <monis@mellanox.com>
Subject: Re: [net-next][PATCH v2 2/2] rds: add sysctl for rds support of
 On-Demand-Paging
Message-ID: <20190505062250.GA6938@mtr-leonro.mtl.com>
References: <1556581040-4812-1-git-send-email-santosh.shilimkar@oracle.com>
 <1556581040-4812-3-git-send-email-santosh.shilimkar@oracle.com>
 <20190501074500.GC7676@mtr-leonro.mtl.com>
 <81e6e4c1-a57c-0f66-75ad-90f75417cc4a@oracle.com>
 <20190502061800.GL7676@mtr-leonro.mtl.com>
 <6560f4e5-8ded-6fb3-dd2b-d4733633addc@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6560f4e5-8ded-6fb3-dd2b-d4733633addc@oracle.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 02, 2019 at 10:59:58AM -0700, Santosh Shilimkar wrote:
>
>
> On 5/1/2019 11:18 PM, Leon Romanovsky wrote:
> > On Wed, May 01, 2019 at 10:54:50AM -0700, Santosh Shilimkar wrote:
> > > On 5/1/2019 12:45 AM, Leon Romanovsky wrote:
> > > > On Mon, Apr 29, 2019 at 04:37:20PM -0700, Santosh Shilimkar wrote:
> > > > > RDS doesn't support RDMA on memory apertures that require On Demand
> > > > > Paging (ODP), such as FS DAX memory. A sysctl is added to indicate
> > > > > whether RDMA requiring ODP is supported.
> > > > >
> > > > > Reviewed-by: H??kon Bugge <haakon.bugge@oracle.com>
> > > > > Reviewed-tested-by: Zhu Yanjun <yanjun.zhu@oracle.com>
> > > > > Signed-off-by: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
> > > > > Signed-off-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
> > > > > ---
> > > > >    net/rds/ib.h        | 1 +
> > > > >    net/rds/ib_sysctl.c | 8 ++++++++
> > > > >    2 files changed, 9 insertions(+)
> > > >
> > > > This sysctl is not needed at all
> > > >
> > > Its needed for application to check the support of the ODP support
> > > feature which in progress. Failing the RDS_GET_MR was just one path
> > > and we also support inline MR registration along with message request.
> > >
> > > Basically application runs on different kernel versions and to be
> > > portable, it will check if underneath RDS support ODP and then only
> > > use RDMA. If not it will fallback to buffer copy mode. Hope
> > > it clarifies.
> >
> > Using ODP sysctl to determine if to use RDMA or not, looks like very
> > problematic approach. How old applications will work in such case
> > without knowledge of such sysctl?
> > How new applications will distinguish between ODP is not supported, but
> > RDMA works?
> >
> Actually this is not ODP sysctl but really whether RDS supports
> RDMA on fs_dax memory or not. I had different name for sysctl but
> in internal review it got changed.
>
> Ignoring the name of the sysctl, here is the application logic.
> - If fs_dax sysctl path doesn't exist, no RDMA on FS DAX memory(this
> will cover all the older kernels, which doesn't have this patch)
> - If fs_dax sysctl path exist and its value is 0, no RDMA on FS
> DAX. This will cover kernels which this patch but don't have
> actual support for ODP based registration.
> - If fs_dax sysctl path exist and its value is 1, RDMA can be
> issued on FS DAX memory. This sysctl will be updated to value 1
> once the support gets added.
>
> Hope it clarifies better now.

Santosh,

Thanks for explanation, I have one more question,

If I'm author of hostile application and write code to disregard that
new sysctl, will any of combinations of kernel/application cause to
kernel panic? If not, we don't really need to expose this information,
if yes, this sysctl is not enough.

Thanks

>
> Regards,
> Santosh
