Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EDE126B37E
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 01:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbgIOXEF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 15 Sep 2020 19:04:05 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:22882 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727347AbgIOOzZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 10:55:25 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-228-UwHUunUMNimNqcwZQRPI5A-1; Tue, 15 Sep 2020 15:55:21 +0100
X-MC-Unique: UwHUunUMNimNqcwZQRPI5A-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 15 Sep 2020 15:55:20 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 15 Sep 2020 15:55:20 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 4/9 next] fs/io_uring Don't use the return value from
 import_iovec().
Thread-Topic: [PATCH 4/9 next] fs/io_uring Don't use the return value from
 import_iovec().
Thread-Index: AdaLbe1b5RzSfSnfQoqJG9wxedvDFg==
Date:   Tue, 15 Sep 2020 14:55:20 +0000
Message-ID: <0dc67994b6b2478caa3d96a9e24d2bfb@AcuMS.aculab.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0.001
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


This is the only code that relies on import_iovec() returning
iter.count on success.
This allows a better interface to import_iovec().

Signed-off-by: David Laight <david.laight@aculab.com>
---
 fs/io_uring.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3790c7fe9fee..0df43882e4b3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2824,7 +2824,7 @@ static ssize_t __io_import_iovec(int rw, struct io_kiocb *req,
 
 		ret = import_single_range(rw, buf, sqe_len, *iovec, iter);
 		*iovec = NULL;
-		return ret < 0 ? ret : sqe_len;
+		return ret;
 	}
 
 	if (req->flags & REQ_F_BUFFER_SELECT) {
@@ -2853,7 +2853,7 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 	if (!req->io)
 		return __io_import_iovec(rw, req, iovec, iter, needs_lock);
 	*iovec = NULL;
-	return iov_iter_count(&req->io->rw.iter);
+	return 0;
 }
 
 static inline loff_t *io_kiocb_ppos(struct kiocb *kiocb)
@@ -3123,7 +3123,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 	if (ret < 0)
 		return ret;
 	iov_count = iov_iter_count(iter);
-	io_size = ret;
+	io_size = iov_count;
 	req->result = io_size;
 	ret = 0;
 
@@ -3246,7 +3246,7 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
 	if (ret < 0)
 		return ret;
 	iov_count = iov_iter_count(iter);
-	io_size = ret;
+	io_size = iov_count;
 	req->result = io_size;
 
 	/* Ensure we clear previously set non-block flag */
-- 
2.25.1

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

