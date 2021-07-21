Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 388953D186A
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 22:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbhGUUNC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 21 Jul 2021 16:13:02 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:33054 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229675AbhGUUNA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 16:13:00 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-243-8fs3cIPQN2uXPNUECXN4gA-1; Wed, 21 Jul 2021 21:53:31 +0100
X-MC-Unique: 8fs3cIPQN2uXPNUECXN4gA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.23; Wed, 21 Jul 2021 21:53:30 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.023; Wed, 21 Jul 2021 21:53:30 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Yunsheng Lin' <linyunsheng@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
CC:     "nickhu@andestech.com" <nickhu@andestech.com>,
        "green.hu@gmail.com" <green.hu@gmail.com>,
        "deanbo422@gmail.com" <deanbo422@gmail.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "yury.norov@gmail.com" <yury.norov@gmail.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "ojeda@kernel.org" <ojeda@kernel.org>,
        "ndesaulniers@gooogle.com" <ndesaulniers@gooogle.com>,
        "joe@perches.com" <joe@perches.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: RE: [PATCH v2 3/4] tools headers UAPI: add cpu_relax() implementation
 for x86 and arm64
Thread-Topic: [PATCH v2 3/4] tools headers UAPI: add cpu_relax()
 implementation for x86 and arm64
Thread-Index: AQHXfQ/RMbMxcgsnGkW4/hrjrWfzM6tN6faQ
Date:   Wed, 21 Jul 2021 20:53:29 +0000
Message-ID: <5db490c6f264431e91bcdbb62fcf3be5@AcuMS.aculab.com>
References: <1626747709-34013-1-git-send-email-linyunsheng@huawei.com>
 <1626747709-34013-4-git-send-email-linyunsheng@huawei.com>
In-Reply-To: <1626747709-34013-4-git-send-email-linyunsheng@huawei.com>
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

From: Yunsheng Lin
> Sent: 20 July 2021 03:22
> 
> As x86 and arm64 is the two available systems that I can build
> and test the cpu_relax() implementation, so only add cpu_relax()
> implementation for x86 and arm64, other arches can be added easily
> when needed.
> 
...
> +#if defined(__i386__) || defined(__x86_64__)
> +/* REP NOP (PAUSE) is a good thing to insert into busy-wait loops. */
> +static __always_inline void rep_nop(void)
> +{
> +	asm volatile("rep; nop" ::: "memory");
> +}

Beware, Intel increased the stall for 'rep nop' in some recent
cpu to IIRC about 200 cycles.

They even document that this might have a detrimental effect.
It is basically far too long for the sort of thing it makes
sense to busy-wait for.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

