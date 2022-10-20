Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D507605F74
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 13:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiJTLyw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 07:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbiJTLyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 07:54:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25BFA1D0D2;
        Thu, 20 Oct 2022 04:54:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC1D0B82712;
        Thu, 20 Oct 2022 11:54:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF3EC433C1;
        Thu, 20 Oct 2022 11:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666266873;
        bh=gPDeLlGv5sanaXqP06t21wZhZ1fAuLnrnAmtJV6iA58=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GhZ6QyQ5tb4dmwBop9SC8Z/qz+f5cyTHmznzuS+QQY8rKScu9UsxyLGGzseSYIXuG
         c3eSuAehlwnKttfeEvsfx8BPmiUGyI5HMMMAPYBTQwKOPOId2Zlgx5LJLwszL6/xTQ
         wP+3RBlcXzM2bY81DPSnMn9+ZzGZbZBYRSvd3guGB1HKPbm2HNRYpbal4oxNtRignZ
         nrwAl90UDHYK0d9ryEJNXPEAZwzZ+PUl7tgtKOWDvb7u7IaTXgvi+pdVQHYE+lHuKY
         gU66JD2KGcTH6XvIWaZWgTpzQjwAomzg+pHWlVEKRgeo1gkvokt84XR0kYJAZdI8HZ
         oF5BPoIpGg+cg==
Date:   Thu, 20 Oct 2022 14:54:30 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Aru <aru.kolappan@oracle.com>
Cc:     jgg@ziepe.ca, saeedm@nvidia.com, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        manjunath.b.patil@oracle.com, rama.nichanamatlu@oracle.com
Subject: Re: [PATCH 1/1] net/mlx5: add dynamic logging for mlx5_dump_err_cqe
Message-ID: <Y1E29kg8yuZjCV4v@unreal>
References: <1665618772-11048-1-git-send-email-aru.kolappan@oracle.com>
 <Y0frx6g/iadBBYgQ@unreal>
 <a7fad299-6df5-e79b-960a-c85c7ea4235a@oracle.com>
 <Y05aGuXSEtSt2aS2@unreal>
 <60899818-61fc-3d1e-e908-fb595cac1940@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <60899818-61fc-3d1e-e908-fb595cac1940@oracle.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 20, 2022 at 01:24:54AM -0700, Aru wrote:
> On 10/18/22 12:47 AM, Leon Romanovsky wrote:
> > On Fri, Oct 14, 2022 at 12:12:36PM -0700, Aru wrote:
> > > Hi Leon,
> > > 
> > > Thank you for reviewing the patch.
> > > 
> > > The method you mentioned disables the dump permanently for the kernel.
> > > We thought vendor might have enabled it for their consumption when needed.
> > > Hence we made it dynamic, so that it can be enabled/disabled at run time.
> > > 
> > > Especially, in a production environment, having the option to turn this log
> > > on/off
> > > at runtime will be helpful.
> > While you are interested on/off this specific warning, your change will
> > cause "to hide" all syndromes as it is unlikely that anyone runs in
> > production with debug prints.
> > 
> >   -   mlx5_ib_warn(dev, "dump error cqe\n");
> >   +   mlx5_ib_dbg(dev, "dump error cqe\n");
> > 
> > Something like this will do the trick without interrupting to the others.
> > 
> > diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
> > index 457f57b088c6..966206085eb3 100644
> > --- a/drivers/infiniband/hw/mlx5/cq.c
> > +++ b/drivers/infiniband/hw/mlx5/cq.c
> > @@ -267,10 +267,29 @@ static void handle_responder(struct ib_wc *wc, struct mlx5_cqe64 *cqe,
> >   	wc->wc_flags |= IB_WC_WITH_NETWORK_HDR_TYPE;
> >   }
> > -static void dump_cqe(struct mlx5_ib_dev *dev, struct mlx5_err_cqe *cqe)
> > +static void dump_cqe(struct mlx5_ib_dev *dev, struct mlx5_err_cqe *cqe,
> > +		     struct ib_wc *wc, int dump)
> >   {
> > -	mlx5_ib_warn(dev, "dump error cqe\n");
> > -	mlx5_dump_err_cqe(dev->mdev, cqe);
> > +	const char *level;
> > +
> > +	if (!dump)
> > +		return;
> > +
> > +	mlx5_ib_warn(dev, "WC error: %d, Message: %s\n", wc->status,
> > +		     ib_wc_status_msg(wc->status));
> > +
> > +	if (dump == 1) {
> > +		mlx5_ib_warn(dev, "dump error cqe\n");
> > +		level = KERN_WARNING;
> > +	}
> > +
> > +	if (dump == 2) {
> > +		mlx5_ib_dbg(dev, "dump error cqe\n");
> > +		level = KERN_DEBUG;
> > +	}
> > +
> > +	print_hex_dump(level, "", DUMP_PREFIX_OFFSET, 16, 1, cqe, sizeof(*cqe),
> > +		       false);
> >   }
> Hi Leon,
> 
> Thank you for the reply and your suggested method to handle this debug
> logging.
> 
> We set 'dump=2' for the syndromes applicable to our scenario: 
> MLX5_CQE_SYNDROME_REMOTE_ACCESS_ERR,
> MLX5_CQE_SYNDROME_REMOTE_OP_ERR and MLX5_CQE_SYNDROME_LOCAL_PROT_ERR.
> We verified this code change and by default, the dump_cqe is not printed to
> syslog until
> the level is changed to KERN_DEBUG level. This works as expected.
> 
> I will send out another email with the patch using your method.
> 
> Is it fine with you If I add your name in the 'suggested-by' field in the
> new patch?

Whatever works for you.

Thanks
