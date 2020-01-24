Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFB52148B6E
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 16:46:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389239AbgAXPqS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 24 Jan 2020 10:46:18 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:56218 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389064AbgAXPqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 10:46:04 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-112-9-3BgZ-WNk6HIrS3qU3ecA-1; Fri, 24 Jan 2020 15:46:01 +0000
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 24 Jan 2020 15:46:00 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 24 Jan 2020 15:46:00 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: [PATCH 2/3] Use _copy_from_user() to read SG iovec array.
Thread-Topic: [PATCH 2/3] Use _copy_from_user() to read SG iovec array.
Thread-Index: AdXSzKSRXs42kspQS5CbFYOlJPFGSg==
Date:   Fri, 24 Jan 2020 15:46:00 +0000
Message-ID: <04fbf8632f83496d819f27bb353dbf39@AcuMS.aculab.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: 9-3BgZ-WNk6HIrS3qU3ecA-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The code has either just validated that the size fits in a caller supplied
fixed size buffer or has used kmalloc() to allocate a buffer.
So avoid the non-trivial cost of the HARDENED_USERCOPY checks by
calling _copy_from_user() instead of copy_from_user().

Signed-off-by: David Laight <david.laight@aculab.com>
---
 fs/read_write.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 441d9ca..0241d68 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -795,7 +795,7 @@ ssize_t rw_copy_check_uvector(int type, const struct iovec __user * uvector,
 			goto out;
 		}
 	}
-	if (copy_from_user(iov, uvector, nr_segs*sizeof(*uvector))) {
+	if (_copy_from_user(iov, uvector, nr_segs*sizeof(*uvector))) {
 		ret = -EFAULT;
 		goto out;
 	}
-- 
1.8.1.2

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

