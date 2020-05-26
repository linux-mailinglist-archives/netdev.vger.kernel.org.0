Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8B0B1E2739
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 18:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729707AbgEZQju convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 26 May 2020 12:39:50 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:21958 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728339AbgEZQju (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 12:39:50 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-181-6VB_yeiiNfKP9dF58f0TAw-1; Tue, 26 May 2020 17:39:45 +0100
X-MC-Unique: 6VB_yeiiNfKP9dF58f0TAw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 26 May 2020 17:39:44 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 26 May 2020 17:39:44 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Vlad Yasevich' <vyasevich@gmail.com>,
        'Neil Horman' <nhorman@tuxdriver.com>,
        "'David S. Miller'" <davem@davemloft.net>,
        "'Jakub Kicinski'" <kuba@kernel.org>,
        "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>,
        'Christoph Hellwig' <hch@lst.de>,
        "'Marcelo Ricardo Leitner'" <marcelo.leitner@gmail.com>
Subject: [PATCH v3 net-next 0/1] sctp: Pull the user copies out of the
 individual sockopt functions.
Thread-Topic: [PATCH v3 net-next 0/1] sctp: Pull the user copies out of the
 individual sockopt functions.
Thread-Index: AdYzesqv+HQT3q1/TBSaB1FzuCxCCg==
Date:   Tue, 26 May 2020 16:39:44 +0000
Message-ID: <dd5b77de1c264cc6955d45a25c870512@AcuMS.aculab.com>
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

This patch series moves all the copy_to/from_user() out of the
individual socket option functions into the outer wrapper.

It also adds separate wrappers that use kernel buffers and could be
exported to other modules.

Because of the way SCTP 'abuses' socket options, the getsockopt() 
has to do a full read-modify-write operation on the buffer.

There are also both setsockopt() and getsockopt() functions that
need to return positive values (probably used internally in libc).
SCTP_SOCKOPT_CONNECTX3 also needs to update the user buffer and
return an errno value.

SCTP_SOCKOPT_CONNECTX3 is the only option that contains an indirect
pointer. So cannot be called from within the kernel.
Other calls provide the same functionality.

There is also real fubar of SCTP_GET_LOCAL_ADDRS which has to
return the wrong length 'for historic compatibility'.
Although I'm not sure how portable that makes applications.

I've managed to split the patch into 8 fragments.
Some of the intermediate files aren't nice - but do compile.

Commit 5960cefab (which limited some of the memdup_user() calls)
can be reverted (one part is actually too generous), and a
check added to the memdup_user() in SCTP_SOCKOPT_CONNECTX3
which was ommitted previosly.

I tried making the buffer to kernel_sctp_setsockopt() 'const'
but that is probably a larger patch than this one!

Patches 1-3 setsockopt:
    1: Rename some local variables to avoid clashing with structure members.
    2: Pull the copies out of sctp_setsockopt().
       This uses some '#define foo (*foo)' to limit the changes.
    3: Expand the #defines. This generates the same object code.
Patches 4-6 getsockopt:
    4: Rename some local variables to avoid clashing with structure members.
    5: Pull the copies out of sctp_getsockopt().
       This uses some '#define foo (*foo)' to limit the changes.
    6: Expand the #defines. This generates the same object code.
Patches 7-8 tidyup:
    7: Replace most 'goto out' with 'return -Exxxxx'.
    8: Code alignment.

Changes for v3:
- Split into 8 patches.
- Use memzero_explicit() at the end of sctp_setsockopt_auth_key()
- Correct the length check in sctp_setsockopt_paddr_thresholds().
- Increase the maximum user buffer size to 256k (128k might not
  be enough.)

Changes for v2;
- Add missing 'static'.
- Increase maximum user buffer size from 64k to 128k to allow for some
  maximal length buffers.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

