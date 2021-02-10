Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C872031695C
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 15:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbhBJOot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 09:44:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:40342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231744AbhBJOo1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 09:44:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8658164E2A;
        Wed, 10 Feb 2021 14:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612968225;
        bh=+gcJQP3Q3QPLaS1QDZI1mHleedi6QwiLduc28JeZ5Fg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oE+ICw7iLQtppxi3haFaulCSsjIDAToXvQ3Tz1S4IJtdTttOPLRYjo6iC3+E2N2nz
         2gZzt8jnI0Do4YbxDqG2qDcldfPTW8bSWofVbr1n8A3p5tk9SrrKV5YnGduEQAR9Bb
         HAVuYwQi++9dyVUKQRHzW7R6l07OofyMkAdaZYDBUc9FxJilncEddDKx9b4xzau61o
         rcyEniORask6La09v9jcR7/6Z0Kh0mGVI4cXsFNs5tiyu646NVF9LvLqmk0qKeFRd2
         G4EfUaVRefH1bM9DuZ9YWqLp4NjT3ICMrdOLLOcVlTVU3RcDNQkqiISYmcwLtibFaY
         x5foW1aN2UoKg==
Date:   Wed, 10 Feb 2021 16:43:41 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     vladbu@nvidia.com, linux-rdma@vger.kernel.org,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [bug report] net/mlx5e: E-Switch, Maintain vhca_id to vport_num
 mapping
Message-ID: <20210210144341.GC741034@unreal>
References: <YCOep5XDMt5IM/PV@mwanda>
 <20210210114820.GA741034@unreal>
 <20210210122801.GW20820@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210210122801.GW20820@kadam>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 03:28:01PM +0300, Dan Carpenter wrote:
> On Wed, Feb 10, 2021 at 01:48:20PM +0200, Leon Romanovsky wrote:
> > On Wed, Feb 10, 2021 at 11:51:51AM +0300, Dan Carpenter wrote:
> > > Hello Vlad Buslov,
> > >
> > > The patch 84ae9c1f29c0: "net/mlx5e: E-Switch, Maintain vhca_id to
> > > vport_num mapping" from Sep 23, 2020, leads to the following static
> > > checker warning:
> > >
> > > 	drivers/net/ethernet/mellanox/mlx5/core/vport.c:1170 mlx5_vport_get_other_func_cap()
> > > 	warn: odd binop '0x0 & 0x1'
> > >
> > > drivers/net/ethernet/mellanox/mlx5/core/vport.c
> > >   1168  int mlx5_vport_get_other_func_cap(struct mlx5_core_dev *dev, u16 function_id, void *out)
> > >   1169  {
> > >   1170          u16 opmod = (MLX5_CAP_GENERAL << 1) | (HCA_CAP_OPMOD_GET_MAX & 0x01);
> > >
> > > HCA_CAP_OPMOD_GET_MAX is zero.  The 0x01 is a magical number.
> > >
> > >   1171          u8 in[MLX5_ST_SZ_BYTES(query_hca_cap_in)] = {};
> > >   1172
> > >   1173          MLX5_SET(query_hca_cap_in, in, opcode, MLX5_CMD_OP_QUERY_HCA_CAP);
> > >   1174          MLX5_SET(query_hca_cap_in, in, op_mod, opmod);
> > >   1175          MLX5_SET(query_hca_cap_in, in, function_id, function_id);
> > >   1176          MLX5_SET(query_hca_cap_in, in, other_function, true);
> > >   1177          return mlx5_cmd_exec_inout(dev, query_hca_cap, in, out);
> > >   1178  }
> >
> > Dan,
> >
> > I'm running smatch which is based on 6193b3b71beb ("extra: fix some error pointer handling")
> > and I don't see this error. Should I run something special?
> >
>
> This check is too crap to publish.
>
> The heuristic was "a bitwise AND which always results in zero" but a lot
> of code does stuff like:  "data = 0x00 << 0 | 0x04 << 8 | 0x12 << 16;"
> I could never figure out a way to make the check useful enough to
> publish.

But you can warn about simple cases like above, which is constant zero
AND something.

Thanks

>
> regards,
> dan carpenter
>
