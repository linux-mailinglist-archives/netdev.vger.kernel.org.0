Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F08E434715
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 10:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbhJTImQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 20 Oct 2021 04:42:16 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:60332 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229600AbhJTImO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 04:42:14 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-26-9od0xuhxN2eU-4dqV5Rppg-1; Wed, 20 Oct 2021 09:39:58 +0100
X-MC-Unique: 9od0xuhxN2eU-4dqV5Rppg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.23; Wed, 20 Oct 2021 09:39:56 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.023; Wed, 20 Oct 2021 09:39:56 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Arnd Bergmann' <arnd@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
CC:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        "Nick Desaulniers" <ndesaulniers@google.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Aya Levin <ayal@nvidia.com>,
        "Eran Ben Elisha" <eranbe@nvidia.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>
Subject: RE: [PATCH] [v2] mlx5: stop warning for 64KB pages
Thread-Topic: [PATCH] [v2] mlx5: stop warning for 64KB pages
Thread-Index: AQHXwdhG9T7OOxgcJU2hLtnyJfvXJqvbl/VQ
Date:   Wed, 20 Oct 2021 08:39:56 +0000
Message-ID: <b12bfefcace143bd9aed95213e1bd8f1@AcuMS.aculab.com>
References: <20211015152056.2434853-1-arnd@kernel.org>
In-Reply-To: <20211015152056.2434853-1-arnd@kernel.org>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann
> Sent: 15 October 2021 16:21
> 
> From: Arnd Bergmann <arnd@arndb.de>
> 
> When building with 64KB pages, clang points out that xsk->chunk_size
> can never be PAGE_SIZE:
> 
> drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c:19:22: error: result of comparison of constant
> 65536 with expression of type 'u16' (aka 'unsigned short') is always false [-Werror,-Wtautological-
> constant-out-of-range-compare]
>         if (xsk->chunk_size > PAGE_SIZE ||
>             ~~~~~~~~~~~~~~~ ^ ~~~~~~~~~
> 
> In older versions of this code, using PAGE_SIZE was the only
> possibility, so this would have never worked on 64KB page kernels,
> but the patch apparently did not address this case completely.
> 
> As Maxim Mikityanskiy suggested, 64KB chunks are really not all that
> useful, so just shut up the warning by adding a cast.
> 
> Fixes: 282c0c798f8e ("net/mlx5e: Allow XSK frames smaller than a page")
> Link: https://lore.kernel.org/netdev/20211013150232.2942146-1-arnd@kernel.org/
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
> b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
> index 538bc2419bd8..228257010f32 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
> @@ -15,8 +15,10 @@ bool mlx5e_validate_xsk_param(struct mlx5e_params *params,
>  			      struct mlx5e_xsk_param *xsk,
>  			      struct mlx5_core_dev *mdev)
>  {
> -	/* AF_XDP doesn't support frames larger than PAGE_SIZE. */
> -	if (xsk->chunk_size > PAGE_SIZE ||
> +	/* AF_XDP doesn't support frames larger than PAGE_SIZE,
> +	 * and xsk->chunk_size is limited to 65535 bytes.
> +	 */
> +	if ((size_t)xsk->chunk_size > PAGE_SIZE ||
>  			xsk->chunk_size < MLX5E_MIN_XSK_CHUNK_SIZE)
>  		return false;

How much smaller does the kernel get if you change 'chunk_size' from
_u16 to 'unsigned int'. ?
Especially for a non-x86 build?
Or is it a hardware constrained size??

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

