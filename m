Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7E261D55B8
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 18:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbgEOQSq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 15 May 2020 12:18:46 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:35586 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726162AbgEOQSq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 12:18:46 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-64-xLdHqa84Oru2iytaNYoJxg-1; Fri, 15 May 2020 17:18:43 +0100
X-MC-Unique: xLdHqa84Oru2iytaNYoJxg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 15 May 2020 17:18:42 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 15 May 2020 17:18:42 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [RFC 0/n] Pass kernel buffers to sock->ops->[sg]et_sockopt()
 functions
Thread-Topic: [RFC 0/n] Pass kernel buffers to sock->ops->[sg]et_sockopt()
 functions
Thread-Index: AdYq0ltzCnHwB5qDRP6yLe0S3yNcwg==
Date:   Fri, 15 May 2020 16:18:42 +0000
Message-ID: <eb0fe14364cd4b12a29f03e37b680788@AcuMS.aculab.com>
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

There are a few code paths (including BPF intercept) that
currently use set_fs(KERNEL_DS) prior to actioning
[sg]et_sockopt() in order toget kernel buffers accessed by
copy_to/from_user().

The 32bit compat code also has to allocate buffer space
on the user stack to copy out translated requests so that
the 64bit code can read them back from userspace.

All the code that processes the requests also has to
call copy_to/from_user() all over the place and check for
failures.

This can all be simplified if the system call entry code
handles the copy_to/from_user() and all the rest of the
code just processes the kernel buffer.

Now, when getsockopt() was first implemented the kernel
code just assumed that the user buffer was long enough.
But some time later the length parameter was made read/update.
So the __sys_getsockopt() knows how big a kernel buffer
is required (in spite of the comment above the entry point).

This patch sequence (to be written) does the following:

Patch 1: Change __sys_setsockopt() to allocate a kernel buffer,
         copy the data into it then call set_fs(KERNEL_DS).
         An on-stack buffer (say 64 bytes) will be used for
         small transfers.

Patch 2: The same for __sys_getsockopt().

Patch 3: Compat setsockopt.

Patch 4: Compat getsockopt.

Patch 5: Remove the user copies from the global socket options code.

Patches 6 to n-1; Remove the user copies from the per-protocol code.

Patch n: Remove the set_fs(KERNEL_DS) from the entry points.

This should be bisectable.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

