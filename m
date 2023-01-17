Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2557266E01E
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 15:14:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbjAQOOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 09:14:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232034AbjAQOOe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 09:14:34 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABFA13CE0D;
        Tue, 17 Jan 2023 06:14:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 01F3FCE1393;
        Tue, 17 Jan 2023 14:14:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2B4BC433D2;
        Tue, 17 Jan 2023 14:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673964866;
        bh=oO6yTThzMkNKYiBtaWdm5Lzb8UxNpLOg1Jp0NdlEpAY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H7za2Vaq0l6xcNEV0SarMt/DnMBLCzeBWWHimgfSvI2ImwcbagaDOKiGoYjIiVBn2
         Z5/XYNfZU0JPPb5lQk9Fyqx3urt7Z2rVUrJIrDl3SwLQ675XBE66cmf/6EaOs2Bfwy
         YDS/ocT+Z2a0yNJKgZyHAD1NwgcBptZIwjtCrGqY0QlxkBtjqN+NVcWibOoDKYrV21
         HO3Fy2Oxv8suZVnjpwcLAzWp+8wz57WX6dw1iyjFG+85UVZpuAi+TwcjOte50kjEDw
         I1qmrajJrx7UtP5YnXQFOm2l/gT5fh0RLuTYHRhbhKshd1vTmU43lOWdH+f/4/6aHs
         g78xEoge90KtQ==
Date:   Tue, 17 Jan 2023 16:14:22 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Israel Rukshin <israelr@nvidia.com>,
        Bryan Tan <bryantan@vmware.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Jens Axboe <axboe@fb.com>,
        Keith Busch <kbusch@kernel.org>, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vishnu Dasa <vdasa@vmware.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH rdma-next 03/13] RDMA: Split kernel-only create QP flags
 from uverbs create QP flags
Message-ID: <Y8atPjQ1x75tBdib@unreal>
References: <cover.1673873422.git.leon@kernel.org>
 <6e46859a58645d9f16a63ff76592487aabc9971d.1673873422.git.leon@kernel.org>
 <Y8WL2gQqqeZdMvr6@nvidia.com>
 <Y8aOe68Q49lvsjv8@unreal>
 <Y8anaBBZDOGF471q@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8anaBBZDOGF471q@nvidia.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 17, 2023 at 09:49:28AM -0400, Jason Gunthorpe wrote:
> On Tue, Jan 17, 2023 at 02:03:07PM +0200, Leon Romanovsky wrote:
> > On Mon, Jan 16, 2023 at 01:39:38PM -0400, Jason Gunthorpe wrote:
> > > On Mon, Jan 16, 2023 at 03:05:50PM +0200, Leon Romanovsky wrote:
> > > 
> > > > diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
> > > > index 17fee1e73a45..c553bf0eb257 100644
> > > > --- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
> > > > +++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
> > > > @@ -184,7 +184,7 @@ enum mlx4_ib_qp_flags {
> > > >  	/* Mellanox specific flags start from IB_QP_CREATE_RESERVED_START */
> > > >  	MLX4_IB_ROCE_V2_GSI_QP = MLX4_IB_QP_CREATE_ROCE_V2_GSI,
> > > >  	MLX4_IB_SRIOV_TUNNEL_QP = 1 << 30,
> > > > -	MLX4_IB_SRIOV_SQP = 1 << 31,
> > > > +	MLX4_IB_SRIOV_SQP = 1ULL << 31,
> > > >  };
> > > 
> > > These should be moved to a uapi if we are saying they are userspace
> > > available
> > > 
> > > But I'm not sure they are?
> > 
> > I don't think so.
> 
> Then they should be > 32 bits right?

Right now, they are in reserved range:
        /* reserve bits 26-31 for low level drivers' internal use */
        IB_QP_CREATE_RESERVED_START             = 1 << 26,
        IB_QP_CREATE_RESERVED_END               = 1ULL << 31,

If we move them to kernel part, we will need to define reserved range
there too. So we just "burn" extra bits just for mlx4, also I don't see
any reason to promote mlx4 bits to be general ones.

Thanks

> 
> Jason
