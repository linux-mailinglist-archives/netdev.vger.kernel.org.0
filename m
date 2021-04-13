Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7403035D9E4
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 10:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242822AbhDMIVd convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 13 Apr 2021 04:21:33 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:50980 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229585AbhDMIVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 04:21:31 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-153-fsM8gFBuPMKJZMZap9THCQ-1; Tue, 13 Apr 2021 09:21:08 +0100
X-MC-Unique: fsM8gFBuPMKJZMZap9THCQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Tue, 13 Apr 2021 09:21:07 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.012; Tue, 13 Apr 2021 09:21:07 +0100
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
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Arnd Bergmann <arnd@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: RE: [PATCH 1/1] mm: Fix struct page layout on 32-bit systems
Thread-Topic: [PATCH 1/1] mm: Fix struct page layout on 32-bit systems
Thread-Index: AQHXL8kRwdfrgigLI0exh4xFUSZq9KqyF7dg
Date:   Tue, 13 Apr 2021 08:21:07 +0000
Message-ID: <e88c6b601ad644a88e3f758f53f1060c@AcuMS.aculab.com>
References: <20210410205246.507048-1-willy@infradead.org>
 <20210410205246.507048-2-willy@infradead.org>
 <20210411114307.5087f958@carbon>
 <20210412182354.GN2531743@casper.infradead.org>
In-Reply-To: <20210412182354.GN2531743@casper.infradead.org>
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
> Sent: 12 April 2021 19:24
> 
> On Sun, Apr 11, 2021 at 11:43:07AM +0200, Jesper Dangaard Brouer wrote:
> > Could you explain your intent here?
> > I worry about @index.
> >
> > As I mentioned in other thread[1] netstack use page_is_pfmemalloc()
> > (code copy-pasted below signature) which imply that the member @index
> > have to be kept intact. In above, I'm unsure @index is untouched.
> 
> Well, I tried three different approaches.  Here's the one I hated the least.
> 
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> Date: Sat, 10 Apr 2021 16:12:06 -0400
> Subject: [PATCH] mm: Fix struct page layout on 32-bit systems
> 
> 32-bit architectures which expect 8-byte alignment for 8-byte integers
> and need 64-bit DMA addresses (arc, arm, mips, ppc) had their struct
> page inadvertently expanded in 2019.  When the dma_addr_t was added,
> it forced the alignment of the union to 8 bytes, which inserted a 4 byte
> gap between 'flags' and the union.
> 
> We could fix this by telling the compiler to use a smaller alignment
> for the dma_addr, but that seems a little fragile.  Instead, move the
> 'flags' into the union.  That causes dma_addr to shift into the same
> bits as 'mapping', which causes problems with page_mapping() called from
> set_page_dirty() in the munmap path.  To avoid this, insert three words
> of padding and use the same bits as ->index and ->private, neither of
> which have to be cleared on free.

This all looks horribly fragile and is bound to get broken again.
Are there two problems?
1) The 'folio' structure needs to match 'rcu' part of the page
   so that it can use the same rcu list to free items.
2) Various uses of 'struct page' need to overlay fields to save space.

For (1) the rcu bit should probably be a named structure in an
anonymous union - probably in both structures.

For (2) is it worth explicitly defining the word number for each field?
So you end up with something like:
#define F(offset, member) struct { long _pad_##offset[offset]; member; }
struct page [
	union {
		struct page_rcu;
		unsigned long flags;
		F(1, unsigned long xxx);
		F(2, unsigned long yyy);
	etc.


		
...
>  		struct {	/* page_pool used by netstack */
> -			/**
> -			 * @dma_addr: might require a 64-bit value even on
> -			 * 32-bit architectures.
> -			 */
> -			dma_addr_t dma_addr;
> +			unsigned long _pp_flags;
> +			unsigned long pp_magic;
> +			unsigned long xmi;
> +			unsigned long _pp_mapping_pad;
> +			dma_addr_t dma_addr;	/* might be one or two words */
>  		};

Isn't that 6 words?

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

