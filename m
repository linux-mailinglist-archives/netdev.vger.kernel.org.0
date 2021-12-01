Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F268464A96
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 10:27:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346657AbhLAJbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 04:31:12 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:33598 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhLAJbL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 04:31:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B9924CE1D7B;
        Wed,  1 Dec 2021 09:27:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24DDEC53FCC;
        Wed,  1 Dec 2021 09:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638350867;
        bh=s9Akk1OT239Bo15JKdrJKndvg/rtEOE78yKO3lL6oxg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Th+EqJo9VbjQqbUY0Sfhn5wLVzSIYqA4BDPVPjpB8TTuH6pGArmD0oFAuH1gNP81h
         DMMCNagjVg+mK0pDcQZyOpN1ZgG8OwPQ6EeStLzAwgRQT6eF6n9Mmk/r9onXH3h3pN
         MSl+DKGsk5nVafITitBEQsY8MH3SBV7BxwGmIQmKfwgg1DM2q75sb91hHjHn/RTnOd
         hPRlda42wHpAhyhvgv0FJ8+rbe8V1XNdZGoB83UIWVPiKigqNxOxPf297YVSZTzkgI
         UDhAs81fJEjbgjoUK+LojAkl+dW9Gebun9XyMIQGT0C05+17aEMsBCcoOtE6ixWp/d
         slvW5EhOz4utA==
Date:   Wed, 1 Dec 2021 11:27:43 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Zhou Qingyang <zhou1615@umn.edu>
Cc:     kjlu@umn.edu, Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eugenia Emantayev <eugenia@mellanox.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/mlx4_en: Fix an use-after-free bug in
 mlx4_en_try_alloc_resources()
Message-ID: <YadAD+x2C9ZHh03e@unreal>
References: <20211130164438.190591-1-zhou1615@umn.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211130164438.190591-1-zhou1615@umn.edu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 01, 2021 at 12:44:38AM +0800, Zhou Qingyang wrote:
> In mlx4_en_try_alloc_resources(), mlx4_en_copy_priv() is called and
> tmp->tx_cq will be freed on the error path of mlx4_en_copy_priv().
> After that mlx4_en_alloc_resources() is called and there is a dereference
> of &tmp->tx_cq[t][i] in mlx4_en_alloc_resources(), which could lead to
> a use after free problem on failure of mlx4_en_copy_priv().
> 
> Fix this bug by adding a check of mlx4_en_copy_priv()
> 
> This bug was found by a static analyzer. The analysis employs
> differential checking to identify inconsistent security operations
> (e.g., checks or kfrees) between two code paths and confirms that the
> inconsistent operations are not recovered in the current function or
> the callers, so they constitute bugs.
> 
> Note that, as a bug found by static analysis, it can be a false
> positive or hard to trigger. Multiple researchers have cross-reviewed
> the bug.
> 
> Builds with CONFIG_MLX4_EN=m show no new warnings,
> and our static analyzer no longer warns about this code.
> 
> Fixes: ec25bc04ed8e ("net/mlx4_en: Add resilience in low memory systems")
> Signed-off-by: Zhou Qingyang <zhou1615@umn.edu>
> ---
>  drivers/net/ethernet/mellanox/mlx4/en_netdev.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
