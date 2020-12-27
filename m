Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9C302E3082
	for <lists+netdev@lfdr.de>; Sun, 27 Dec 2020 09:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbgL0Ikr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Dec 2020 03:40:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:48250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726065AbgL0Ikq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Dec 2020 03:40:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2A5F217A0;
        Sun, 27 Dec 2020 08:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609058406;
        bh=N63WD7XNdILFskHLS2VaePJSBMJXjQ96d/JMS3jV5U0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kwFq5s2v0pXUY5/gW9Qt5AgO7pcpfORlWvZAprxvAYwt5F2gf3PP42lgCN1cSmp2I
         zAb39RctPK5qqESTYpnYnogj7qFWXowgyiDkxFtoTUMXbehUf5+eRJesKLNYLQb2zP
         Y5ZTxLMethmMMOCVD/OLbV74GBJeiFQyfiZVzYXSCaPPBYKTDHo9FmAkLFC0nWdgsz
         c8qiP/Dwc+ub24s9qJbC3tg30py7f+SllFz2VFJBPo4idnbA3UtBxcVqUYf+KzUdZ6
         WCVc1tfM6IjMkVPbnJnbwh4CE9Ucg5vCDCma8Ghe9TwfDog0QCNL+Xj9sx0FYsPCMn
         1WdO9f9xt9/KQ==
Date:   Sun, 27 Dec 2020 10:40:01 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Dinghao Liu <dinghao.liu@zju.edu.cn>
Cc:     kjlu@umn.edu, Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/mlx5e: Fix two double free cases
Message-ID: <20201227084001.GF4457@unreal>
References: <20201221085031.6591-1-dinghao.liu@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201221085031.6591-1-dinghao.liu@zju.edu.cn>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 21, 2020 at 04:50:31PM +0800, Dinghao Liu wrote:
> mlx5e_create_ttc_table_groups() frees ft->g on failure of
> kvzalloc(), but such failure will be caught by its caller
> in mlx5e_create_ttc_table() and ft->g will be freed again
> in mlx5e_destroy_flow_table(). The same issue also occurs
> in mlx5e_create_ttc_table_groups().
>
> Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_fs.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)

I'm not thrilled to see release in the error flow that will be done in
the different function. The missing piece is "ft->g = NULL" after kfree().

And also fixes lines are missing in all your patches.

Thanks
