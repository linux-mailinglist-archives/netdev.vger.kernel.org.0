Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22CAA41E56A
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 02:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350135AbhJAAMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 20:12:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:59190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347868AbhJAAMg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 20:12:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87EE9615A4;
        Fri,  1 Oct 2021 00:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633047053;
        bh=vtOoBhIbAnRqc6pw1GncBQvvEU05vrvvAM/j4K7pALg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kGQCKMHuzZv6ex5zKxnT29z6AHEvJHTMDLmysUW7Vxkg/rn4Rswr4RbMN5DG/Ac1G
         SwyI595hauQ2aZ3peg6SUcyw9HA9Ca9Lin66SeSC1kBDUjNzEAgd0Y5jl3NxZFNlbz
         yTOPbYRydmiC//nLqOIzf0SsCmYvfiiOPraNOgkNV2UtBM0lbyUe7DqRvyQfE9pgKs
         DG8Dt5Iuh/pOF6Blr84buYABTmClF2BGqItk/gmgQfpaLa+ME1R9ch2V4ezbmkjH6e
         bRfj0YqQi9roMv0DQDTEUc/gao++CeJK11VxMaV2EyQu8SOs+jyJJxgl2ZnKP21G2x
         5LCFN+1tq0fJQ==
Date:   Thu, 30 Sep 2021 17:10:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH net-next] net/mlx4_en: avoid one cache line miss to ring
 doorbell
Message-ID: <20210930171052.30660edb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210930194031.3181989-1-eric.dumazet@gmail.com>
References: <20210930194031.3181989-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Sep 2021 12:40:31 -0700 Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> This patch caches doorbell address directly in struct mlx4_en_tx_ring.
> 
> This removes the need to bring in cpu caches whole struct mlx4_uar
> in fast path.
> 
> Note that mlx4_uar is not guaranteed to be on a local node,
> because mlx4_bf_alloc() uses a single free list (priv->bf_list)
> regardless of its node parameter.
> 
> This kind of change does matter in presence of light/moderate traffic.
> In high stress, this read-only line would be kept hot in caches.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Tariq Toukan <tariqt@nvidia.com>

>  	/* Following part should be mostly read */
> +	void			*doorbell_address;

We'll need to make sparse happy before applying:

drivers/net/ethernet/mellanox/mlx4/en_tx.c:133:32: warning: incorrect type in assignment (different address spaces)
drivers/net/ethernet/mellanox/mlx4/en_tx.c:133:32:    expected void *doorbell_address
drivers/net/ethernet/mellanox/mlx4/en_tx.c:133:32:    got void [noderef] __iomem *
drivers/net/ethernet/mellanox/mlx4/en_tx.c:757:56: warning: incorrect type in argument 2 (different address spaces)
drivers/net/ethernet/mellanox/mlx4/en_tx.c:757:56:    expected void [noderef] __iomem *
drivers/net/ethernet/mellanox/mlx4/en_tx.c:757:56:    got void *doorbell_address
