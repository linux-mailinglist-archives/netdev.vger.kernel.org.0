Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF3722650A
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 17:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731117AbgGTPuW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 20 Jul 2020 11:50:22 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:29989 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730669AbgGTPuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 11:50:20 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-258-sz9WrWQfOJC-d4mv7nHeLA-1; Mon, 20 Jul 2020 16:50:16 +0100
X-MC-Unique: sz9WrWQfOJC-d4mv7nHeLA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 20 Jul 2020 16:50:16 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 20 Jul 2020 16:50:16 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: Misaligned IPv6 addresses is SCTP socket options.
Thread-Topic: Misaligned IPv6 addresses is SCTP socket options.
Thread-Index: AdZeq3CoQr6UZTOvRHy9xmmfSyelxA==
Date:   Mon, 20 Jul 2020 15:50:16 +0000
Message-ID: <f380b70f54854d98a9c801c7ae6bc370@AcuMS.aculab.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Several of the structures in linux/uapi/linux/sctp.h are
marked __attribute__((packed, aligned(4))).

I believe this was done so that the UAPI structure was the
same on both 32 and 64bit systems.
The 'natural' alignment is that of 'u64' - so would differ
between 32 and 64 bit x86 cpus.

There are two horrible issues here:

1) I believe the natural alignment of u64 is actually 8
   bytes on some 32bit architectures.
   So the change would have broken binary compatibility
   for 32bit applications compiled before the alignment
   was added.

2) Inside the kernel the address of the structure member
   is 'blindly' passed through as if it were an aligned
   pointer.
   For instance I'm pretty sure is can get passed to
   inet_addr_is_any() (in net/core/utils.).
   Here it gets passed to memcmp().
   gcc will inline the memcmp() and almost certainly use 64bit
   accesses.
   These will fault on architectures (like sparc64).

No amount of casting can make gcc 'forget' the alignment
of a structure.
Passing to an external function as 'void *' will - but
even the LTO could track the alignment through.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

