Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6804B40AB4B
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 12:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbhINKCM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 06:02:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:60556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229907AbhINKCL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 06:02:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED44260F6F;
        Tue, 14 Sep 2021 10:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631613654;
        bh=pZUSS9S3DMUdKd4LLunWNq3d1MGWJxWPskZEYvmtq5Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D4MWB45jttLoOf0lNoWeyDZ2kdsHnaBljoR0+3HPaqRWe0aFZw15u2flVIFica7eJ
         h7mPpiqsKFC8QQuYiiMcYovECW/3+K6y/cRSnP+edtUsmFm1zmNdqJFqs9pn2WYp1N
         VcknSmhogxPtF/7S1qWc43wT80zAnoQpr2k6WQz7wjJEcGm5NTgjSdxAZZ9AEltOMP
         CCELJpHx+coIGnkAWSy6Cm2lQg5kuKO35xw4U/dpLo1mpR/c8oE2txX2+TVk2AqFT2
         5lwc2IY8nHTGyhKL3vahUgcVPDSRcHffWQ4m4Sh81GjLsNAWq3UxTCs+NF7KlZ6HBL
         1CW5Jp98WaYAw==
Date:   Tue, 14 Sep 2021 13:00:50 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Shai Malin <smalin@marvell.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>, Ariel Elior <aelior@marvell.com>,
        "malin1024@gmail.com" <malin1024@gmail.com>,
        Michal Kalderon <mkalderon@marvell.com>
Subject: Re: [PATCH net] qed: rdma - don't wait for resources under hw error
 recovery flow
Message-ID: <YUBy0iu4p+a0lsb1@unreal>
References: <SJ0PR18MB3882BDDFA81A7FD3A541C282CCDA9@SJ0PR18MB3882.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ0PR18MB3882BDDFA81A7FD3A541C282CCDA9@SJ0PR18MB3882.namprd18.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 14, 2021 at 06:23:02AM +0000, Shai Malin wrote:
> On Mon, Sep 13, 2021 at 5:45:00PM +0300, Leon Romanovsky wrote:
> > On Mon, Sep 13, 2021 at 03:14:42PM +0300, Shai Malin wrote:
> > > If the HW device is during recovery, the HW resources will never return,
> > > hence we shouldn't wait for the CID (HW context ID) bitmaps to clear.
> > > This fix speeds up the error recovery flow.
> > >
> > > Fixes: 64515dc899df ("qed: Add infrastructure for error detection and
> > recovery")
> > > Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> > > Signed-off-by: Ariel Elior <aelior@marvell.com>
> > > Signed-off-by: Shai Malin <smalin@marvell.com>
> > > ---
> > >  drivers/net/ethernet/qlogic/qed/qed_iwarp.c | 7 +++++++
> > >  drivers/net/ethernet/qlogic/qed/qed_roce.c  | 7 +++++++
> > >  2 files changed, 14 insertions(+)
> > >
> > > diff --git a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
> > b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
> > > index fc8b3e64f153..4967e383c31a 100644
> > > --- a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
> > > +++ b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
> > > @@ -1323,6 +1323,13 @@ static int qed_iwarp_wait_for_all_cids(struct
> > qed_hwfn *p_hwfn)
> > >  	int rc;
> > >  	int i;
> > >
> > > +	/* If the HW device is during recovery, all resources are immediately
> > > +	 * reset without receiving a per-cid indication from HW. In this case
> > > +	 * we don't expect the cid_map to be cleared.
> > > +	 */
> > > +	if (p_hwfn->cdev->recov_in_prog)
> > > +		return 0;
> > 
> > How do you ensure that this doesn't race with recovery flow?
> 
> The HW recovery will start with the management FW which will detect and report
> the problem to the driver and it also set "cdev->recov_in_prog = ture" for all 
> the devices on the same HW.
> The qedr recovery flow is actually the qedr_remove flow but if 
> "cdev->recov_in_prog = true" it will "ignore" the FW/HW resources.
> The changes introduced with this patch are part of this qedr remove flow.
> The cdev->recov_in_prog will be set to false only as part of the following 
> probe and after the HW was re-initialized.

I asked how do you make sure that recov_in_prog is not changing to be
"true" right after your "if ..." check?

Thanks

> 
> > 
> > > +
> > >  	rc = qed_iwarp_wait_cid_map_cleared(p_hwfn,
> > >  					    &p_hwfn->p_rdma_info-
> > >tcp_cid_map);
> > >  	if (rc)
> > > diff --git a/drivers/net/ethernet/qlogic/qed/qed_roce.c
> > b/drivers/net/ethernet/qlogic/qed/qed_roce.c
> > > index f16a157bb95a..aff5a2871b8f 100644
> > > --- a/drivers/net/ethernet/qlogic/qed/qed_roce.c
> > > +++ b/drivers/net/ethernet/qlogic/qed/qed_roce.c
> > > @@ -71,6 +71,13 @@ void qed_roce_stop(struct qed_hwfn *p_hwfn)
> > >  	struct qed_bmap *rcid_map = &p_hwfn->p_rdma_info->real_cid_map;
> > >  	int wait_count = 0;
> > >
> > > +	/* If the HW device is during recovery, all resources are immediately
> > > +	 * reset without receiving a per-cid indication from HW. In this case
> > > +	 * we don't expect the cid bitmap to be cleared.
> > > +	 */
> > > +	if (p_hwfn->cdev->recov_in_prog)
> > > +		return;
> > > +
> > >  	/* when destroying a_RoCE QP the control is returned to the user after
> > >  	 * the synchronous part. The asynchronous part may take a little longer.
> > >  	 * We delay for a short while if an async destroy QP is still expected.
> > > --
> > > 2.22.0
> > >
