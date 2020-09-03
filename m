Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7518525CE12
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 00:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729557AbgICWq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 18:46:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:41086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729580AbgICWqM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Sep 2020 18:46:12 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 933C420791;
        Thu,  3 Sep 2020 22:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599173171;
        bh=iN6DxkLC83wzjVGOJNd7nNWsmFV986AstgMH79lhd1s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=t6/TZGp/9NDFqq3m84NYYsUDsH+jQ2ru4gf/B7wEZZj1I1GvOo1KmWpPdEEuAX4GR
         5ipawN1kHdwm2BL1HZdZ1ehREC9VTt8rxeQxphRfHaoMMzUyL9b+FrPJDjgMhmVQ/c
         ssoNRc+XJc3AsojX6jUx65Aajj182vXkNEF2o2Yc=
Date:   Thu, 3 Sep 2020 15:46:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        "Tariq Toukan" <tariqt@mellanox.com>
Subject: Re: [net-next 06/10] net/mlx5e: Support multiple SKBs in a TX WQE
Message-ID: <20200903154609.363e8c00@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200903210022.22774-7-saeedm@nvidia.com>
References: <20200903210022.22774-1-saeedm@nvidia.com>
        <20200903210022.22774-7-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Sep 2020 14:00:18 -0700 Saeed Mahameed wrote:
> +static inline void mlx5e_tx_wi_consume_fifo_skbs(struct mlx5e_txqsq *sq,
> +						 struct mlx5e_tx_wqe_info *wi,
> +						 struct mlx5_cqe64 *cqe,
> +						 int napi_budget)
> +{
> +	int i;
> +
> +	for (i = 0; i < wi->num_fifo_pkts; i++) {
> +		struct sk_buff *skb = mlx5e_skb_fifo_pop(sq);
> +
> +		mlx5e_consume_skb(sq, skb, cqe, napi_budget);
> +	}
> +}

The compiler was not inlining this one either?
