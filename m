Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD02035DDE0
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 13:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243816AbhDMLiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 07:38:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:39432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238148AbhDMLiC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 07:38:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE12F61244;
        Tue, 13 Apr 2021 11:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618313862;
        bh=RGZNg9kftVpFHwueFM2mS//vQiDriFVB0rvxdE3Bj0M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CYsm5jHBjyHTSfNLz5owb3ZJx/uyb9g0CMlSlExbjZfOpEHTuqX9AfdRGSZB88/IE
         xDZ06U049Fhp93e3O0tjFrSdfHDN29lME/DZML2V7OVgdR46CqQ7xdNsepCOuPexbc
         ztk8pwLWq99C4cHjvkqMB+zJYkceDFFLC97f+2NB8UAn3wRddNSwtTs1FdHRUcrZiJ
         rS3tmYH0XmFL5wCtumSNJxwhkdBxx7ZpYeF2RJKBgKTaYQYvwPIgOR/FF6vRYfmzck
         lGFJMdYwkqFFqcS76tzby4Ov9VQIokDFF6cIzS2qNh3DMV5oeYZvSxqNyD0iJJua96
         SsOtTKaXBH56g==
Date:   Tue, 13 Apr 2021 14:37:38 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Haakon Bugge <haakon.bugge@oracle.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Doug Ledford <dledford@redhat.com>,
        OFED mailing list <linux-rdma@vger.kernel.org>,
        Parav Pandit <parav@nvidia.com>,
        Linux-Net <netdev@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH for-next v3 0/2] Introduce rdma_set_min_rnr_timer() and
 use it in RDS
Message-ID: <YHWCgmq4gOmAczq6@unreal>
References: <1617216194-12890-1-git-send-email-haakon.bugge@oracle.com>
 <20210412225847.GA1189461@nvidia.com>
 <YHU6VXP6kZABXIYA@unreal>
 <F450613D-9A52-4D21-A2D5-E27FA4EBDBBE@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <F450613D-9A52-4D21-A2D5-E27FA4EBDBBE@oracle.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 11:13:38AM +0000, Haakon Bugge wrote:
> 
> 
> > On 13 Apr 2021, at 08:29, Leon Romanovsky <leon@kernel.org> wrote:
> > 
> > On Mon, Apr 12, 2021 at 07:58:47PM -0300, Jason Gunthorpe wrote:
> >> On Wed, Mar 31, 2021 at 08:43:12PM +0200, Håkon Bugge wrote:
> >>> ib_modify_qp() is an expensive operation on some HCAs running
> >>> virtualized. This series removes two ib_modify_qp() calls from RDS.
> >>> 
> >>> I am sending this as a v3, even though it is the first sent to
> >>> net. This because the IB Core commit has reach v3.
> >>> 
> >>> Håkon Bugge (2):
> >>>  IB/cma: Introduce rdma_set_min_rnr_timer()
> >>>  rds: ib: Remove two ib_modify_qp() calls
> >> 
> >> Applied to rdma for-next, thanks
> > 
> > Jason,
> > 
> > It should be 
> > +	WARN_ON(id->qp_type != IB_QPT_RC && id->qp_type != IB_QPT_XRC_TGT);
> 
> With no return you will arm the setting of the timer and subsequently get an error from the modify_qp later.

The addition of WARN_ON() means that this is programmer error to get
such input. Historically, in-kernel API doesn't need to have protection
from other kernel developers.

Thanks

> 
> 
> Håkon
> 
> > 
> > and not
> > +	if (WARN_ON(id->qp_type != IB_QPT_RC && id->qp_type != IB_QPT_XRC_TGT))
> > +		return -EINVAL;
> > 
> > Thanks
> > 
> >> 
> >> Jason
> 
