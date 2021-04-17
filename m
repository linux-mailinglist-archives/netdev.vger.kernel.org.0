Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 838E3363276
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 23:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237126AbhDQVT2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 17 Apr 2021 17:19:28 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:35820 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237092AbhDQVT2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Apr 2021 17:19:28 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-261-JBH8CRNiMlWoKO_dEnAufg-1; Sat, 17 Apr 2021 22:18:58 +0100
X-MC-Unique: JBH8CRNiMlWoKO_dEnAufg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Sat, 17 Apr 2021 22:18:57 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.015; Sat, 17 Apr 2021 22:18:57 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Matthew Wilcox' <willy@infradead.org>,
        "brouer@redhat.com" <brouer@redhat.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "mcroce@linux.microsoft.com" <mcroce@linux.microsoft.com>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        "arnd@kernel.org" <arnd@kernel.org>, "hch@lst.de" <hch@lst.de>,
        "linux-snps-arc@lists.infradead.org" 
        <linux-snps-arc@lists.infradead.org>,
        "mhocko@kernel.org" <mhocko@kernel.org>,
        "mgorman@suse.de" <mgorman@suse.de>
Subject: RE: [PATCH 1/2] mm: Fix struct page layout on 32-bit systems
Thread-Topic: [PATCH 1/2] mm: Fix struct page layout on 32-bit systems
Thread-Index: AQHXMzO/f1yRrc3ugkWz9MvyD1ZvgKq5Nwpg
Date:   Sat, 17 Apr 2021 21:18:57 +0000
Message-ID: <386d009232dc42bdaf83d4cc36b13864@AcuMS.aculab.com>
References: <20210416230724.2519198-1-willy@infradead.org>
 <20210416230724.2519198-2-willy@infradead.org>
 <20210417024522.GP2531743@casper.infradead.org>
In-Reply-To: <20210417024522.GP2531743@casper.infradead.org>
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
> Sent: 17 April 2021 03:45
> 
> Replacement patch to fix compiler warning.
...
>  static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
>  {
> -	return page->dma_addr;
> +	dma_addr_t ret = page->dma_addr[0];
> +	if (sizeof(dma_addr_t) > sizeof(unsigned long))
> +		ret |= (dma_addr_t)page->dma_addr[1] << 16 << 16;

Ugly as well.

Why not just replace the (dma_addr_t) cast with a (u64) one?
Looks better than the double shift.

Same could be done for the '>> 32'.
Is there an upper_32_bits() that could be used??

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

