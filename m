Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF5357817B
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 14:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234609AbiGRMDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 08:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234508AbiGRMDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 08:03:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E9C237DA;
        Mon, 18 Jul 2022 05:03:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E56361456;
        Mon, 18 Jul 2022 12:03:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0D80C341C0;
        Mon, 18 Jul 2022 12:03:05 +0000 (UTC)
Date:   Mon, 18 Jul 2022 15:03:02 +0300
From:   Leon Romanovsky <leon@ikernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH rdma-next 5/5] RDMA/mlx5: Expose steering anchor to
 userspace
Message-ID: <YtVL9tsoGELwoly/@unreal>
References: <20220703205407.110890-1-saeed@kernel.org>
 <20220703205407.110890-6-saeed@kernel.org>
 <20220713223133.gbbt4fbphzpc42hx@sx1>
 <YtEgbZh63bs7w0v3@nvidia.com>
 <20220717195229.padt5g6bl23eha3v@sx1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220717195229.padt5g6bl23eha3v@sx1>
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 17, 2022 at 12:52:29PM -0700, Saeed Mahameed wrote:
> On 15 Jul 05:08, Jason Gunthorpe wrote:
> > On Wed, Jul 13, 2022 at 03:31:33PM -0700, Saeed Mahameed wrote:
> > > On 03 Jul 13:54, Saeed Mahameed wrote:
> > > > From: Mark Bloch <mbloch@nvidia.com>
> > > >
> > > > Expose a steering anchor per priority to allow users to re-inject
> > > > packets back into default NIC pipeline for additional processing.
> > > >
> > > > MLX5_IB_METHOD_STEERING_ANCHOR_CREATE returns a flow table ID which
> > > > a user can use to re-inject packets at a specific priority.
> > > >
> > > > A FTE (flow table entry) can be created and the flow table ID
> > > > used as a destination.
> > > >
> > > > When a packet is taken into a RDMA-controlled steering domain (like
> > > > software steering) there may be a need to insert the packet back into
> > > > the default NIC pipeline. This exposes a flow table ID to the user that can
> > > > be used as a destination in a flow table entry.
> > > >
> > > > With this new method priorities that are exposed to users via
> > > > MLX5_IB_METHOD_FLOW_MATCHER_CREATE can be reached from a non-zero UID.
> > > >
> > > > As user-created flow tables (via RDMA DEVX) are created with a non-zero UID
> > > > thus it's impossible to point to a NIC core flow table (core driver flow tables
> > > > are created with UID value of zero) from userspace.
> > > > Create flow tables that are exposed to users with the shared UID, this
> > > > allows users to point to default NIC flow tables.
> > > >
> > > > Steering loops are prevented at FW level as FW enforces that no flow
> > > > table at level X can point to a table at level lower than X.
> > > >
> > > > Signed-off-by: Mark Bloch <mbloch@nvidia.com>
> > > > Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
> > > > Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> > > > ---
> > > > drivers/infiniband/hw/mlx5/fs.c          | 138 ++++++++++++++++++++++-
> > > > drivers/infiniband/hw/mlx5/mlx5_ib.h     |   6 +
> > > > include/uapi/rdma/mlx5_user_ioctl_cmds.h |  17 +++
> > > 
> > > Jason, Can you ack/nack ? This has uapi.. I need to move forward with this
> > > submission.
> > 
> > Yes, it looks fine, can you update the shared branch?
> > 
> 
> Applied to mlx5-next, you may pull.

The last two patches "RDMA/ ..." are not supposed to be in mlx5-next
branch. Especially the last one that has uapi changes.

Unless that branch wasn't pulled by netdev, can you please delete them?

Thanks

> 
> > Jason
