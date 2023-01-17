Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5664366E0D5
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 15:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbjAQOfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 09:35:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232766AbjAQOeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 09:34:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F84A25D;
        Tue, 17 Jan 2023 06:34:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B723D6147F;
        Tue, 17 Jan 2023 14:34:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86555C433EF;
        Tue, 17 Jan 2023 14:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673966061;
        bh=Fz/P1XZDGupDtqAJSEnp0rEfUZAKbWxcCPbBc58E86o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Zd/8A4ZSHTYkosiDKj1TO0FVHt7VXMMtyD28nA+OIKNWV0uToO4VZUsV04f+85zsK
         NPAqR1E4a1Q0CqivGIOi81y5puPNQKSjGzt83iuk9+arxT2fS1FYGXhGrqyY0pos+Z
         OcLCxPp7ys9ubCVCxeMxzYmYNy77ccvTqq24OSgfB3I1ANleDm9EcAC5SJFVPc92BV
         82ZrOmcDrcd12x/w57ND2bTpnoX2P/SLRY7hVBHhu05Shda5VwcyAjC1oJ0Zq2EiV+
         jmFS5CVk+gGXWQSHF1NbuqizTD6yrXxEWa4GU13nqxj7Wk2j8qhBhnUxjl4nGJ/QXE
         mk7N0mBa6Ynxg==
Date:   Tue, 17 Jan 2023 16:34:17 +0200
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
Message-ID: <Y8ax6ZD6hhyD41pA@unreal>
References: <cover.1673873422.git.leon@kernel.org>
 <6e46859a58645d9f16a63ff76592487aabc9971d.1673873422.git.leon@kernel.org>
 <Y8WL2gQqqeZdMvr6@nvidia.com>
 <Y8aOe68Q49lvsjv8@unreal>
 <Y8anaBBZDOGF471q@nvidia.com>
 <Y8atPjQ1x75tBdib@unreal>
 <Y8au3ni8NVBPI5hu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8au3ni8NVBPI5hu@nvidia.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 17, 2023 at 10:21:18AM -0400, Jason Gunthorpe wrote:
> On Tue, Jan 17, 2023 at 04:14:22PM +0200, Leon Romanovsky wrote:
> > On Tue, Jan 17, 2023 at 09:49:28AM -0400, Jason Gunthorpe wrote:
> > > On Tue, Jan 17, 2023 at 02:03:07PM +0200, Leon Romanovsky wrote:
> > > > On Mon, Jan 16, 2023 at 01:39:38PM -0400, Jason Gunthorpe wrote:
> > > > > On Mon, Jan 16, 2023 at 03:05:50PM +0200, Leon Romanovsky wrote:
> > > > > 
> > > > > > diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
> > > > > > index 17fee1e73a45..c553bf0eb257 100644
> > > > > > --- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
> > > > > > +++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
> > > > > > @@ -184,7 +184,7 @@ enum mlx4_ib_qp_flags {
> > > > > >  	/* Mellanox specific flags start from IB_QP_CREATE_RESERVED_START */
> > > > > >  	MLX4_IB_ROCE_V2_GSI_QP = MLX4_IB_QP_CREATE_ROCE_V2_GSI,
> > > > > >  	MLX4_IB_SRIOV_TUNNEL_QP = 1 << 30,
> > > > > > -	MLX4_IB_SRIOV_SQP = 1 << 31,
> > > > > > +	MLX4_IB_SRIOV_SQP = 1ULL << 31,
> > > > > >  };
> > > > > 
> > > > > These should be moved to a uapi if we are saying they are userspace
> > > > > available
> > > > > 
> > > > > But I'm not sure they are?
> > > > 
> > > > I don't think so.
> > > 
> > > Then they should be > 32 bits right?
> > 
> > Right now, they are in reserved range:
> >         /* reserve bits 26-31 for low level drivers' internal use */
> >         IB_QP_CREATE_RESERVED_START             = 1 << 26,
> >         IB_QP_CREATE_RESERVED_END               = 1ULL << 31,
> > 
> > If we move them to kernel part, we will need to define reserved range
> > there too. So we just "burn" extra bits just for mlx4, also I don't see
> > any reason to promote mlx4 bits to be general ones.
> 
> Is the reserved range kernel only? It would be nice to clarify that
> detail
> 
> If yes we should move it so that userspace cannot set it. Do we have a
> bug here already?

No, we always checked that users can't provide these bits and fail create QP.

It means that we can safely move that range too.

Thanks

> 
> Jason
