Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A281E3613EE
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 23:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235806AbhDOVMY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 15 Apr 2021 17:12:24 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:60993 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234439AbhDOVMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 17:12:23 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-157-edG-rOXuODirktZxzgM_1A-1; Thu, 15 Apr 2021 22:11:57 +0100
X-MC-Unique: edG-rOXuODirktZxzgM_1A-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Thu, 15 Apr 2021 22:11:56 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.012; Thu, 15 Apr 2021 22:11:56 +0100
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
Thread-Index: AQHXMXYmwdfrgigLI0exh4xFUSZq9Kq0jZ3ggAFYFFmAAC15oA==
Date:   Thu, 15 Apr 2021 21:11:56 +0000
Message-ID: <5179a01a462f43d6951a65de2a299070@AcuMS.aculab.com>
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
 <20210415182155.GD2531743@casper.infradead.org>
In-Reply-To: <20210415182155.GD2531743@casper.infradead.org>
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

From: Matthew Wilcox <willy@infradead.org>
> Sent: 15 April 2021 19:22
> 
> On Thu, Apr 15, 2021 at 08:08:32PM +0200, Jesper Dangaard Brouer wrote:
> > +static inline
> > +dma_addr_t page_pool_dma_addr_read(dma_addr_t dma_addr)
> > +{
> > +	/* Workaround for storing 64-bit DMA-addr on 32-bit machines in struct
> > +	 * page.  The page->dma_addr share area with page->compound_head which
> > +	 * use bit zero to mark compound pages. This is okay, as DMA-addr are
> > +	 * aligned pointers which have bit zero cleared.
> > +	 *
> > +	 * In the 32-bit case, page->compound_head is 32-bit.  Thus, when
> > +	 * dma_addr_t is 64-bit it will be located in top 32-bit.  Solve by
> > +	 * swapping dma_addr 32-bit segments.
> > +	 */
> > +#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
> 
> #if defined(CONFIG_ARCH_DMA_ADDR_T_64BIT) && defined(__BIG_ENDIAN)
> otherwise you'll create the problem on ARM that you're avoiding on PPC ...
> 
> I think you want to delete the word '_read' from this function name because
> you're using it for both read and write.

I think I'd use explicit dma_addr_hi and dma_addr_lo and
separate read/write functions just to make absolutely sure
nothing picks up the swapped value.

Isn't it possible to move the field down one long?
This might require an explicit zero - but this is not a common
code path - the extra write will be noise.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

