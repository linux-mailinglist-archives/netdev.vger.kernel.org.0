Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB88939AC39
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 23:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbhFCVEj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 3 Jun 2021 17:04:39 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:24132 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229576AbhFCVEi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 17:04:38 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-170-SExHqgrMNI6o2dMbOIlPQg-1; Thu, 03 Jun 2021 22:02:51 +0100
X-MC-Unique: SExHqgrMNI6o2dMbOIlPQg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.18; Thu, 3 Jun 2021 22:02:50 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.018; Thu, 3 Jun 2021 22:02:50 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Saeed Mahameed' <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>, Aya Levin <ayal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: RE: [net 1/8] net/mlx5e: Fix incompatible casting
Thread-Topic: [net 1/8] net/mlx5e: Fix incompatible casting
Thread-Index: AQHXV0/fcOLeBvLXMkGlhwJRIRNuoqsCyIFQ
Date:   Thu, 3 Jun 2021 21:02:50 +0000
Message-ID: <7166b5e6ebc44198bbbec5afdcb699f5@AcuMS.aculab.com>
References: <20210602013723.1142650-1-saeed@kernel.org>
 <20210602013723.1142650-2-saeed@kernel.org>
In-Reply-To: <20210602013723.1142650-2-saeed@kernel.org>
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

From: Saeed Mahameed
> Sent: 02 June 2021 02:37
> 
> Device supports setting of a single fec mode at a time, enforce this
> by bitmap_weight == 1. Input from fec command is in u32, avoid cast to
> unsigned long and use bitmap_from_arr32 to populate bitmap safely.
> 
...
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
> b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
> index 8360289813f0..c4724742eef1 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
> @@ -1624,12 +1624,13 @@ static int mlx5e_set_fecparam(struct net_device *netdev,
>  {
>  	struct mlx5e_priv *priv = netdev_priv(netdev);
>  	struct mlx5_core_dev *mdev = priv->mdev;
> +	unsigned long fec_bitmap;
>  	u16 fec_policy = 0;
>  	int mode;
>  	int err;
> 
> -	if (bitmap_weight((unsigned long *)&fecparam->fec,
> -			  ETHTOOL_FEC_LLRS_BIT + 1) > 1)
> +	bitmap_from_arr32(&fec_bitmap, &fecparam->fec, sizeof(fecparam->fec) * BITS_PER_BYTE);
> +	if (bitmap_weight(&fec_bitmap, ETHTOOL_FEC_LLRS_BIT + 1) > 1)
>  		return -EOPNOTSUPP;

What is wrong with:
	if (fecparam->fec & (fecparam->fec - 1))
		return -EOPNOTSUPP;

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

