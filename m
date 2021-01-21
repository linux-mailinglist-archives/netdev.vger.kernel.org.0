Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C25BD2FE6EB
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 11:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728652AbhAUJ6n convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 21 Jan 2021 04:58:43 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:47605 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728834AbhAUJ5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 04:57:42 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-50-BiZH3I-eOfKtG3gChttRXQ-1; Thu, 21 Jan 2021 09:53:10 +0000
X-MC-Unique: BiZH3I-eOfKtG3gChttRXQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 21 Jan 2021 09:53:08 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 21 Jan 2021 09:53:08 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Kevin Hao' <haokexin@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Subbaraya Sundeep <sbhatta@marvell.com>
CC:     Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        hariprasad <hkelam@marvell.com>
Subject: RE: [PATCH] net: octeontx2: Make sure the buffer is 128 byte aligned
Thread-Topic: [PATCH] net: octeontx2: Make sure the buffer is 128 byte aligned
Thread-Index: AQHW78WQsJtm4aM3QESXw4OsFIZftKox1iqw
Date:   Thu, 21 Jan 2021 09:53:08 +0000
Message-ID: <8a9fdef33fd54340a9b36182fd8dc88e@AcuMS.aculab.com>
References: <20210121070906.25380-1-haokexin@gmail.com>
In-Reply-To: <20210121070906.25380-1-haokexin@gmail.com>
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

From: Kevin Hao
> Sent: 21 January 2021 07:09
> 
> The octeontx2 hardware needs the buffer to be 128 byte aligned.
> But in the current implementation of napi_alloc_frag(), it can't
> guarantee the return address is 128 byte aligned even the request size
> is a multiple of 128 bytes, so we have to request an extra 128 bytes and
> use the PTR_ALIGN() to make sure that the buffer is aligned correctly.
> 
> Fixes: 7a36e4918e30 ("octeontx2-pf: Use the napi_alloc_frag() to alloc the pool buffers")
> Reported-by: Subbaraya Sundeep <sbhatta@marvell.com>
> Signed-off-by: Kevin Hao <haokexin@gmail.com>
> ---
>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> index bdfa2e293531..5ddedc3b754d 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> @@ -488,10 +488,11 @@ dma_addr_t __otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool)
>  	dma_addr_t iova;
>  	u8 *buf;
> 
> -	buf = napi_alloc_frag(pool->rbsize);
> +	buf = napi_alloc_frag(pool->rbsize + OTX2_ALIGN);
>  	if (unlikely(!buf))
>  		return -ENOMEM;
> 
> +	buf = PTR_ALIGN(buf, OTX2_ALIGN);
>  	iova = dma_map_single_attrs(pfvf->dev, buf, pool->rbsize,
>  				    DMA_FROM_DEVICE, DMA_ATTR_SKIP_CPU_SYNC);
>  	if (unlikely(dma_mapping_error(pfvf->dev, iova))) {
> --
> 2.29.2

Doesn't that break the 'free' code ?
Surely it needs the original pointer.

It isn't obvious that page_frag_free() it correct when the
allocator is napi_alloc_frag() either.
I'd have thought it ought to be returned to the pool.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

