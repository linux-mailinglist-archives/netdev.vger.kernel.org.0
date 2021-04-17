Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8C18362F64
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 12:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236104AbhDQK7o convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 17 Apr 2021 06:59:44 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:21505 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229972AbhDQK7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Apr 2021 06:59:41 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-153-fX_eEiD9OBC36ZMNcm5hsg-1; Sat, 17 Apr 2021 11:59:11 +0100
X-MC-Unique: fX_eEiD9OBC36ZMNcm5hsg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Sat, 17 Apr 2021 11:59:10 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.015; Sat, 17 Apr 2021 11:59:10 +0100
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
Thread-Index: AQHXMXYmwdfrgigLI0exh4xFUSZq9Kq0jZ3ggAK59KGAAUYTcA==
Date:   Sat, 17 Apr 2021 10:59:09 +0000
Message-ID: <a9db4abd89624c698e86a527b93efbf6@AcuMS.aculab.com>
References: <20210410205246.507048-2-willy@infradead.org>
 <20210411114307.5087f958@carbon>
 <20210411103318.GC2531743@casper.infradead.org>
 <20210412011532.GG2531743@casper.infradead.org>
 <20210414101044.19da09df@carbon>
 <20210414115052.GS2531743@casper.infradead.org>
 <20210414211322.3799afd4@carbon>
 <20210414213556.GY2531743@casper.infradead.org>
 <a50c3156fe8943ef964db4345344862f@AcuMS.aculab.com>
 <20210415200832.32796445@carbon>
 <20210416152755.GL2531743@casper.infradead.org>
In-Reply-To: <20210416152755.GL2531743@casper.infradead.org>
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

From: Matthew Wilcox
> Sent: 16 April 2021 16:28
> 
> On Thu, Apr 15, 2021 at 08:08:32PM +0200, Jesper Dangaard Brouer wrote:
> > See below patch.  Where I swap32 the dma address to satisfy
> > page->compound having bit zero cleared. (It is the simplest fix I could
> > come up with).
> 
> I think this is slightly simpler, and as a bonus code that assumes the
> old layout won't compile.

Always a good plan.

...
>  static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
>  {
> -	return page->dma_addr;
> +	dma_addr_t ret = page->dma_addr[0];
> +	if (sizeof(dma_addr_t) > sizeof(unsigned long))
> +		ret |= (dma_addr_t)page->dma_addr[1] << 32;
> +	return ret;
> +}

Won't some compiler/option combinations generate an
error for the '<< 32' when dma_addr_t is 32bit?

You might need to use a (u64) cast.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

