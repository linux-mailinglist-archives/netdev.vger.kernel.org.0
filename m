Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C01B6DDD4E
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 16:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbjDKOJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 10:09:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbjDKOJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 10:09:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD9E3E5B;
        Tue, 11 Apr 2023 07:09:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 658D061EFB;
        Tue, 11 Apr 2023 14:09:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DC5AC433EF;
        Tue, 11 Apr 2023 14:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681222157;
        bh=XLeiHPPRb/DwYmY4IBd0MVrFHsxO0fJj1f0QxrYLR24=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R8EM/gO6CfvkM2z21W6oah1Mh0wQ77bweO/mwgGAKCWomuvswyMeTF76B/n5GhLp7
         3rQLIAiequ+vbzOD9iW/ThKe8iiOjMaWixCcJMOkLQwgnzj+Jt+pN3OEmybd60+EQy
         4V6iffG+KC0Mlac01oXgJBTp+Su4XLfmjtnv4xVqNHU05ONwsnjJLvQOF2mLHcTfhg
         Y2DpiP3EnFa7VPPhb+H4b+d+DfXUYwfwJf+80eTiRpIEb87YPk6IYskltd8nNoA4tS
         oE1hy1zN9KLR81eZrzdQpjMO7XERLTOqCrXn0pqJTFvKB7SkV/Ud2VIMqfmsmpIveb
         vdOnoWPeiQjqQ==
Date:   Tue, 11 Apr 2023 17:09:12 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Avihai Horon <avihaih@nvidia.com>, Aya Levin <ayal@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Meir Lichtinger <meirl@mellanox.com>,
        Michael Guralnik <michaelgur@mellanox.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Shay Drory <shayd@nvidia.com>
Subject: Re: [PATCH rdma-next 0/4] Allow relaxed ordering read in VFs and VMs
Message-ID: <20230411140912.GZ182481@unreal>
References: <cover.1681131553.git.leon@kernel.org>
 <ZDVoH0W27xo6mAbW@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDVoH0W27xo6mAbW@nvidia.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 11:01:03AM -0300, Jason Gunthorpe wrote:
> On Mon, Apr 10, 2023 at 04:07:49PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > From Avihai,
> > 
> > Currently, Relaxed Ordering (RO) can't be used in VFs directly and in
> > VFs assigned to QEMU, even if the PF supports RO. This is due to issues
> > in reporting/emulation of PCI config space RO bit and due to current
> > HCA capability behavior.
> > 
> > This series fixes it by using a new HCA capability and by relying on FW
> > to do the "right thing" according to the PF's PCI config space RO value.
> > 
> > Allowing RO in VFs and VMs is valuable since it can greatly improve
> > performance on some setups. For example, testing throughput of a VF on
> > an AMD EPYC 7763 and ConnectX-6 Dx setup showed roughly 60% performance
> > improvement.
> > 
> > Thanks
> > 
> > Avihai Horon (4):
> >   RDMA/mlx5: Remove pcie_relaxed_ordering_enabled() check for RO write
> >   RDMA/mlx5: Check pcie_relaxed_ordering_enabled() in UMR
> >   net/mlx5: Update relaxed ordering read HCA capabilities
> >   RDMA/mlx5: Allow relaxed ordering read in VFs and VMs
> 
> This looks OK, but the patch structure is pretty confusing.
> 
> It seems to me there are really only two patches here, the first is to
> add some static inline

I asked from Avihai to align all pcie_relaxed_ordering_enabled() calls
to be relevant for RO only. This is how we came to first two patches.

Thanks

> 
> 'mlx5 supports read ro'
> 
> which supports both the cap bits described in
> the PRM, with a little comment to explain that old devices only set
> the old cap.
> 
> And a second patch to call it in all the places we need to check before
> setting the mkc ro read bit.
> 
> Maybe a final third patch to sort out that mistake in the write side.
> 
> But this really doesn't have anything to do with VFs and VMs, this is
> adjusting the code to follow the current PRM because the old one was
> mis-desgined.
> 
> Jason
