Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1F7B4F22A4
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 07:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbiDEFpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 01:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiDEFpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 01:45:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EE417F239;
        Mon,  4 Apr 2022 22:43:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B54261138;
        Tue,  5 Apr 2022 05:43:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B612C340EE;
        Tue,  5 Apr 2022 05:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649137402;
        bh=sYFlsSIWnWY7H6pXl64UUXZKTyvh2XfqGMJOM5IlQgc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fcp+rxuW3kUhrT6QyWAoWbVm4gtx9v6BPIBnRjhjNOWlk+PBQBEZq7U+8GTSJmqi6
         O1yMuk569h4MA00+xc8GC6bj8yJvWHlBNLNa17/FMWGwLaHe6eUDrxeFWtIbqbeoe2
         /YFEdgjmtbULiQelaDiH+dN85wYw6G8xBoNi6tVJ8m0bBzMwR0FesakeprBPHK0V3P
         vE9NLKMEb3UveWniUIBkqPzY+dECo7GWpw8Br2Xrz1w6G+QP/GfCjZRuzxYi0bSu8E
         yw6AW1mc+F+rgEdKcAsllPObIToNnrzM6er3UxBbQk+F6K1hANQQoc7lNACvyFgKYG
         xe48pp/+sL5tw==
Date:   Tue, 5 Apr 2022 08:43:17 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH mlx5-next 4/5] net/mlx5: Remove tls vs. ktls separation
 as it is the same
Message-ID: <YkvW9SNJeb5VPmeg@unreal>
References: <cover.1649073691.git.leonro@nvidia.com>
 <67e596599edcffb0de43f26551208dfd34ac777e.1649073691.git.leonro@nvidia.com>
 <20220405003322.afko7uo527w5j3zu@sx1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220405003322.afko7uo527w5j3zu@sx1>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 04, 2022 at 05:33:22PM -0700, Saeed Mahameed wrote:
> On 04 Apr 15:08, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > After removal FPGA TLS, we can remove tls->ktls indirection too,
> > as it is the same thing.
> > 
> > Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> > .../net/ethernet/mellanox/mlx5/core/Makefile  |  2 +-
> > .../ethernet/mellanox/mlx5/core/en/params.c   |  2 +-
> > .../mellanox/mlx5/core/en_accel/en_accel.h    | 11 +--
> > .../mellanox/mlx5/core/en_accel/ktls.c        | 22 ++++-
> > .../mellanox/mlx5/core/en_accel/ktls.h        | 32 +++++++
> > .../mellanox/mlx5/core/en_accel/ktls_rx.c     |  2 +-
> > .../en_accel/{tls_stats.c => ktls_stats.c}    | 38 ++++-----
> > .../mellanox/mlx5/core/en_accel/ktls_tx.c     | 18 +++-
> > .../mellanox/mlx5/core/en_accel/ktls_txrx.h   | 28 +++++-
> > .../mellanox/mlx5/core/en_accel/tls.c         | 70 ---------------
> > .../mellanox/mlx5/core/en_accel/tls.h         | 85 -------------------
> > .../mellanox/mlx5/core/en_accel/tls_rxtx.c    | 70 ---------------
> > .../mellanox/mlx5/core/en_accel/tls_rxtx.h    | 85 -------------------
> > .../net/ethernet/mellanox/mlx5/core/en_main.c |  8 +-
> > .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  5 +-
> > .../ethernet/mellanox/mlx5/core/en_stats.c    |  8 +-
> > 16 files changed, 130 insertions(+), 356 deletions(-)
> > rename drivers/net/ethernet/mellanox/mlx5/core/en_accel/{tls_stats.c => ktls_stats.c} (76%)
> 
> Why not ktls_*.c => tls_*.c ?

Mostly because other drivers use _ktls_ name for this type of functionality.
Plus internally, Tariq suggested to squash everything into ktls.

> 
> Since we now have one TLS implementation, it would've been easier to maybe
> repurpose TLS to be KTLS only and avoid renaming every TLS to KTLS in all
> functions and files.
> 
> So just keep tls.c and all mlx5_tls_xyz functions and implement ktls
> directly in them, the renaming will be done only on the ktls implementation
> part of the code rather than in every caller.

Should I do it or keep this patch as is?

Thanks

> 
> > delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
> > delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h
> > delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
> > delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h
> > 
> 
