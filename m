Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1805347DA8
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 17:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235721AbhCXQ1V convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 24 Mar 2021 12:27:21 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:39295 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235114AbhCXQ1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 12:27:12 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-36-mooNmgT4MtSKVwTw4DWRzg-1; Wed, 24 Mar 2021 16:27:10 +0000
X-MC-Unique: mooNmgT4MtSKVwTw4DWRzg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Wed, 24 Mar 2021 16:27:09 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.012; Wed, 24 Mar 2021 16:27:09 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Alex Elder' <elder@linaro.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>,
        "evgreen@chromium.org" <evgreen@chromium.org>,
        "cpratapa@codeaurora.org" <cpratapa@codeaurora.org>,
        "subashab@codeaurora.org" <subashab@codeaurora.org>,
        "elder@kernel.org" <elder@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next] net: ipa: avoid 64-bit modulus
Thread-Topic: [PATCH net-next] net: ipa: avoid 64-bit modulus
Thread-Index: AQHXH4CsHuvM6SpiNkO+MERkTuT8kKqTVWfg
Date:   Wed, 24 Mar 2021 16:27:09 +0000
Message-ID: <f77f12f117934e9d9e3b284ed37e87a7@AcuMS.aculab.com>
References: <20210323010505.2149882-1-elder@linaro.org>
In-Reply-To: <20210323010505.2149882-1-elder@linaro.org>
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

From: Alex Elder
> Sent: 23 March 2021 01:05
> It is possible for a 32 bit x86 build to use a 64 bit DMA address.
> 
> There are two remaining spots where the IPA driver does a modulo
> operation to check alignment of a DMA address, and under certain
> conditions this can lead to a build error on i386 (at least).
> 
> The alignment checks we're doing are for power-of-2 values, and this
> means the lower 32 bits of the DMA address can be used.  This ensures
> both operands to the modulo operator are 32 bits wide.
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>  drivers/net/ipa/gsi.c       | 11 +++++++----
>  drivers/net/ipa/ipa_table.c |  9 ++++++---
>  2 files changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
> index 7f3e338ca7a72..b6355827bf900 100644
> --- a/drivers/net/ipa/gsi.c
> +++ b/drivers/net/ipa/gsi.c
> @@ -1436,15 +1436,18 @@ static void gsi_evt_ring_rx_update(struct gsi_evt_ring *evt_ring, u32 index)
>  /* Initialize a ring, including allocating DMA memory for its entries */
>  static int gsi_ring_alloc(struct gsi *gsi, struct gsi_ring *ring, u32 count)
>  {
> -	size_t size = count * GSI_RING_ELEMENT_SIZE;
> +	u32 size = count * GSI_RING_ELEMENT_SIZE;
>  	struct device *dev = gsi->dev;
>  	dma_addr_t addr;
> 
> -	/* Hardware requires a 2^n ring size, with alignment equal to size */
> +	/* Hardware requires a 2^n ring size, with alignment equal to size.
> +	 * The size is a power of 2, so we can check alignment using just
> +	 * the bottom 32 bits for a DMA address of any size.
> +	 */
>  	ring->virt = dma_alloc_coherent(dev, size, &addr, GFP_KERNEL);

Doesn't dma_alloc_coherent() guarantee that alignment?
I doubt anywhere else checks?

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

