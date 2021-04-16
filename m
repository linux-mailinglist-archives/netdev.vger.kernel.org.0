Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60984361AA9
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 09:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239641AbhDPHdH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 16 Apr 2021 03:33:07 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:33716 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239527AbhDPHdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 03:33:04 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-212-Pz1ohOP9MbWLWc7zHXrlbA-1; Fri, 16 Apr 2021 08:32:36 +0100
X-MC-Unique: Pz1ohOP9MbWLWc7zHXrlbA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Fri, 16 Apr 2021 08:32:35 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.012; Fri, 16 Apr 2021 08:32:35 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Matthew Wilcox' <willy@infradead.org>
CC:     Jesper Dangaard Brouer <brouer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
Thread-Index: AQHXMXYmwdfrgigLI0exh4xFUSZq9Kq0jZ3ggAFYFFmAAC15oIAABLSAgACoXgA=
Date:   Fri, 16 Apr 2021 07:32:35 +0000
Message-ID: <f51e1aa98cb94880a236d58c75c20994@AcuMS.aculab.com>
References: <20210411103318.GC2531743@casper.infradead.org>
 <20210412011532.GG2531743@casper.infradead.org>
 <20210414101044.19da09df@carbon>
 <20210414115052.GS2531743@casper.infradead.org>
 <20210414211322.3799afd4@carbon>
 <20210414213556.GY2531743@casper.infradead.org>
 <a50c3156fe8943ef964db4345344862f@AcuMS.aculab.com>
 <20210415200832.32796445@carbon>
 <20210415182155.GD2531743@casper.infradead.org>
 <5179a01a462f43d6951a65de2a299070@AcuMS.aculab.com>
 <20210415222211.GG2531743@casper.infradead.org>
In-Reply-To: <20210415222211.GG2531743@casper.infradead.org>
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
> Sent: 15 April 2021 23:22
> 
> On Thu, Apr 15, 2021 at 09:11:56PM +0000, David Laight wrote:
> > Isn't it possible to move the field down one long?
> > This might require an explicit zero - but this is not a common
> > code path - the extra write will be noise.
> 
> Then it overlaps page->mapping.  See emails passim.

The rules on overlaps make be wonder if every 'long'
should be in its own union.
The comments would need to say when each field is used.
It would, at least, make these errors less common.

That doesn't solve the 64bit dma_addr though.

Actually rather that word-swapping dma_addr on 32bit BE
could you swap over the two fields it overlays with.
That might look messy in the .h, but it doesn't require
an accessor function to do the swap - easily missed.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

