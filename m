Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2448B6E0DB2
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 14:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbjDMMth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 08:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbjDMMtg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 08:49:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 822D79741;
        Thu, 13 Apr 2023 05:49:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19AF76152E;
        Thu, 13 Apr 2023 12:49:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D59C433EF;
        Thu, 13 Apr 2023 12:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681390173;
        bh=hl2z3VQRd2gHDfpU3684uq8PUQrhWsZX8vPo+MGJYmw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qgz2dn/NnxJFjaA8hJhGDw5y3Qvg2LkpVx/BTL78zd1lYhH0XU/xKW4unpwHdeAhD
         eBnKAueNAFNCswdjd0k+ox2m7RVOIgFrnEEtdl8w9YTP2DFqJjBDFlJYY1pHTUn7pY
         se9Auk2WbgunltG/BzpyckiusXOFDmlFo9wJw+OaypC/4KnwiUua8WZmao7j+txjkp
         Upo1x4Iv2JY6xvk7f5AZfhndIhD7cBLemsOqPLlZgrEGq1b5L1Zew1fWQrDgUcwJGu
         aqmfIG/MbsVrdPoHXho4hkUQr8ppCMwyZBO5ZvTSGgSEkDS+PvWBnQGhoIY6j3rzp2
         J7wBzn5/amvYA==
Date:   Thu, 13 Apr 2023 15:49:29 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Avihai Horon <avihaih@nvidia.com>, Aya Levin <ayal@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Meir Lichtinger <meirl@mellanox.com>,
        Michael Guralnik <michaelgur@mellanox.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Shay Drory <shayd@nvidia.com>
Subject: Re: [PATCH rdma-next 0/4] Allow relaxed ordering read in VFs and VMs
Message-ID: <20230413124929.GN17993@unreal>
References: <cover.1681131553.git.leon@kernel.org>
 <ZDVoH0W27xo6mAbW@nvidia.com>
 <7c5eb785-0fe7-e0e5-8232-403e1d3538ac@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c5eb785-0fe7-e0e5-8232-403e1d3538ac@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 04:21:09PM -0700, Jacob Keller wrote:
> 
> 
> On 4/11/2023 7:01 AM, Jason Gunthorpe wrote:
> > On Mon, Apr 10, 2023 at 04:07:49PM +0300, Leon Romanovsky wrote:
> >> From: Leon Romanovsky <leonro@nvidia.com>
> >>
> >> From Avihai,
> >>
> >> Currently, Relaxed Ordering (RO) can't be used in VFs directly and in
> >> VFs assigned to QEMU, even if the PF supports RO. This is due to issues
> >> in reporting/emulation of PCI config space RO bit and due to current
> >> HCA capability behavior.
> >>
> >> This series fixes it by using a new HCA capability and by relying on FW
> >> to do the "right thing" according to the PF's PCI config space RO value.
> >>
> >> Allowing RO in VFs and VMs is valuable since it can greatly improve
> >> performance on some setups. For example, testing throughput of a VF on
> >> an AMD EPYC 7763 and ConnectX-6 Dx setup showed roughly 60% performance
> >> improvement.
> >>
> >> Thanks
> >>
> >> Avihai Horon (4):
> >>   RDMA/mlx5: Remove pcie_relaxed_ordering_enabled() check for RO write
> >>   RDMA/mlx5: Check pcie_relaxed_ordering_enabled() in UMR
> >>   net/mlx5: Update relaxed ordering read HCA capabilities
> >>   RDMA/mlx5: Allow relaxed ordering read in VFs and VMs
> > 
> > This looks OK, but the patch structure is pretty confusing.
> > 
> > It seems to me there are really only two patches here, the first is to
> > add some static inline
> > 
> > 'mlx5 supports read ro'
> > 
> > which supports both the cap bits described in
> > the PRM, with a little comment to explain that old devices only set
> > the old cap.
> > 
> > And a second patch to call it in all the places we need to check before
> > setting the mkc ro read bit.
> > 
> > Maybe a final third patch to sort out that mistake in the write side.
> > 
> > But this really doesn't have anything to do with VFs and VMs, this is
> > adjusting the code to follow the current PRM because the old one was
> > mis-desgined.
> > 
> > Jason
> 
> FWIW I think Jason's outline here makes sense too and might be slightly
> better. However, reading through the series I was reasonably able to
> understand things enough that I think its fine as-is.
> 
> In some sense its not about VF or VM, but fixing this has the result
> that it fixes a setup with VF and VM, so I think thats an ok thing to
> call out as the goal.

VF or VM came from user perspective of where this behavior is not
correct. Avihai saw this in QEMU, so he described it in terms which
are more clear to the end user.

Thanks
