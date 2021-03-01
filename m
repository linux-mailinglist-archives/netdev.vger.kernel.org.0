Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4634C327B65
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 11:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234389AbhCAJ7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 04:59:40 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:1745 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234210AbhCAJ7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 04:59:04 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B603cbabe0000>; Mon, 01 Mar 2021 01:58:22 -0800
Received: from reg-r-vrt-018-180.nvidia.com (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 1 Mar 2021 09:58:18 +0000
References: <20210225125501.1792072-1-arnd@kernel.org>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Arnd Bergmann <arnd@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>
CC:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dmytro Linkin <dlinkin@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        Eli Britstein <elibr@mellanox.com>,
        Eli Cohen <eli@mellanox.com>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net/mlx5e: fix mlx5e_tc_tun_update_header_ipv6 dummy
 definition
In-Reply-To: <20210225125501.1792072-1-arnd@kernel.org>
Message-ID: <ygnho8g3gprp.fsf@nvidia.com>
Date:   Mon, 1 Mar 2021 11:57:30 +0200
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614592702; bh=5gphWubhgnY39oqs/H/cdG90CAjjo6DZUJCuo5ulKcw=;
        h=References:User-agent:From:To:CC:Subject:In-Reply-To:Message-ID:
         Date:MIME-Version:Content-Type:X-Originating-IP:X-ClientProxiedBy;
        b=ikSRmb9kBasfdP27ka5KWc6SaAXE2tRd8CYF4zIQto2Bt9M1/p7jadQt+qbLO2nM1
         1QbAarK2Mqj1kZAh5t6jnwQcGrZ+cWUixalxFj3cZePSI7p7nZEun8IHva8i9ZLDLZ
         /uP/TTY23lk9a4AatQoXVWwjvN+d8AWHBR2wHSscWat2uNwtTtqxSENYtHL2jMvxsN
         P8EQGMnSJ511DFxHuMFR/DeozGC1kMYqAuodKX/bXHqGKV1Pm3pjOCnthlg8xb6E77
         PM6pEPCQxGZr+jnuU5rm6S3EVRkmSwJO7dNAUBbIgqgQiZHBOdZzue+BtNAn9+6RzU
         cFFBE5ZzvlHSw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 25 Feb 2021 at 14:54, Arnd Bergmann <arnd@kernel.org> wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>
> The alternative implementation of this function in a header file
> is declared as a global symbol, and gets added to every .c file
> that includes it, which leads to a link error:
>
> arm-linux-gnueabi-ld: drivers/net/ethernet/mellanox/mlx5/core/en_rx.o: in function `mlx5e_tc_tun_update_header_ipv6':
> en_rx.c:(.text+0x0): multiple definition of `mlx5e_tc_tun_update_header_ipv6'; drivers/net/ethernet/mellanox/mlx5/core/en_main.o:en_main.c:(.text+0x0): first defined here
>
> Mark it 'static inline' like the other functions here.
>
> Fixes: c7b9038d8af6 ("net/mlx5e: TC preparation refactoring for routing update event")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
> index 67de2bf36861..89d5ca91566e 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
> @@ -76,10 +76,12 @@ int mlx5e_tc_tun_update_header_ipv6(struct mlx5e_priv *priv,
>  static inline int
>  mlx5e_tc_tun_create_header_ipv6(struct mlx5e_priv *priv,
>  				struct net_device *mirred_dev,
> -				struct mlx5e_encap_entry *e) { return -EOPNOTSUPP; }
> -int mlx5e_tc_tun_update_header_ipv6(struct mlx5e_priv *priv,
> -				    struct net_device *mirred_dev,
> -				    struct mlx5e_encap_entry *e)
> +				struct mlx5e_encap_entry *e)
> +{ return -EOPNOTSUPP; }
> +static inline int
> +mlx5e_tc_tun_update_header_ipv6(struct mlx5e_priv *priv,
> +				struct net_device *mirred_dev,
> +				struct mlx5e_encap_entry *e)
>  { return -EOPNOTSUPP; }
>  #endif
>  int mlx5e_tc_tun_route_lookup(struct mlx5e_priv *priv,

Thanks Arnd!

Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
