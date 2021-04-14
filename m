Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6657835F876
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 18:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352485AbhDNPxT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 14 Apr 2021 11:53:19 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:29643 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1352426AbhDNPwp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 11:52:45 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-15-m9cXnC2KMlaJybEViQCuIg-1; Wed, 14 Apr 2021 16:52:18 +0100
X-MC-Unique: m9cXnC2KMlaJybEViQCuIg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Wed, 14 Apr 2021 16:52:16 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.012; Wed, 14 Apr 2021 16:52:16 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Matthew Wilcox' <willy@infradead.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Arnd Bergmann <arnd@kernel.org>,
        "Christoph Hellwig" <hch@lst.de>
Subject: RE: [PATCH 1/1] mm: Fix struct page layout on 32-bit systems
Thread-Topic: [PATCH 1/1] mm: Fix struct page layout on 32-bit systems
Thread-Index: AQHXMSRrwdfrgigLI0exh4xFUSZq9Kq0J1eg
Date:   Wed, 14 Apr 2021 15:52:16 +0000
Message-ID: <7f6cee3dcf1749fbb7b54eaf129141e7@AcuMS.aculab.com>
References: <20210410205246.507048-1-willy@infradead.org>
 <20210410205246.507048-2-willy@infradead.org>
 <20210411114307.5087f958@carbon>
 <20210411103318.GC2531743@casper.infradead.org>
 <20210412011532.GG2531743@casper.infradead.org>
 <20210414101044.19da09df@carbon>
 <20210414115052.GS2531743@casper.infradead.org>
In-Reply-To: <20210414115052.GS2531743@casper.infradead.org>
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

> Doing this fixes it:
> 
> +++ b/include/linux/types.h
> @@ -140,7 +140,7 @@ typedef u64 blkcnt_t;
>   * so they don't care about the size of the actual bus addresses.
>   */
>  #ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
> -typedef u64 dma_addr_t;
> +typedef u64 __attribute__((aligned(sizeof(void *)))) dma_addr_t;
>  #else
>  typedef u32 dma_addr_t;
>  #endif

I hate __packed so much I've been checking what it does!

If you add __packed to the dma_addr_t field inside the union
then gcc (at least) removes the pad from before it, but also
'remembers' the alignment that is enforced by other members
of the structure.

So you don't need the extra aligned(sizeof (void *)) since
that is implicit.

So in this case __packed probably has no side effects.
(Unless a 32bit arch has instructions for a 64bit read
that must not be on an 8n+4 boundary and the address is taken).

It also doesn't affect 64bit - since the previous field
forces 64bit alignment.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

