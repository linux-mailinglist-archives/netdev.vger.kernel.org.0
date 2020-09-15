Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7B6126A79F
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 16:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbgIOO4h convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 15 Sep 2020 10:56:37 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:29387 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727354AbgIOOz3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 10:55:29 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-37-dfVtB9cCPvahLiPigLatfA-1; Tue, 15 Sep 2020 15:55:25 +0100
X-MC-Unique: dfVtB9cCPvahLiPigLatfA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 15 Sep 2020 15:55:24 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 15 Sep 2020 15:55:24 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 5/9 next] scsi: Use iovec_import() instead of import_iovec().
Thread-Topic: [PATCH 5/9 next] scsi: Use iovec_import() instead of
 import_iovec().
Thread-Index: AdaLbdBrrJnvb+q4Sa6RtPibF1KBcw==
Date:   Tue, 15 Sep 2020 14:55:24 +0000
Message-ID: <27be46ece36c42d6a7dabf62c6ac7a98@AcuMS.aculab.com>
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


iovec_import() has a safer calling convention than import_iovec().

Signed-off-by: David Laight <david.laight@aculab.com>
---
 block/scsi_ioctl.c | 14 ++++++++------
 drivers/scsi/sg.c  | 14 +++++++-------
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index ef722f04f88a..0343918a84d3 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -331,20 +331,22 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
 	ret = 0;
 	if (hdr->iovec_count) {
 		struct iov_iter i;
-		struct iovec *iov = NULL;
+		struct iovec *iov;
 
 #ifdef CONFIG_COMPAT
 		if (in_compat_syscall())
-			ret = compat_import_iovec(rq_data_dir(rq),
+			iov = compat_iovec_import(rq_data_dir(rq),
 				   hdr->dxferp, hdr->iovec_count,
-				   0, &iov, &i);
+				   NULL, &i);
 		else
 #endif
-			ret = import_iovec(rq_data_dir(rq),
+			iov = iovec_import(rq_data_dir(rq),
 				   hdr->dxferp, hdr->iovec_count,
-				   0, &iov, &i);
-		if (ret < 0)
+				   NULL, &i);
+		if (IS_ERR(iov)) {
+			ret = PTR_ERR(iov);
 			goto out_free_cdb;
+		}
 
 		/* SG_IO howto says that the shorter of the two wins */
 		iov_iter_truncate(&i, hdr->dxfer_len);
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 20472aaaf630..1dbc0a74add5 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1817,19 +1817,19 @@ sg_start_req(Sg_request *srp, unsigned char *cmd)
 	}
 
 	if (iov_count) {
-		struct iovec *iov = NULL;
+		struct iovec *iov;
 		struct iov_iter i;
 
 #ifdef CONFIG_COMPAT
 		if (in_compat_syscall())
-			res = compat_import_iovec(rw, hp->dxferp, iov_count,
-						  0, &iov, &i);
+			iov = compat_iovec_import(rw, hp->dxferp, iov_count,
+						  NULL, &i);
 		else
 #endif
-			res = import_iovec(rw, hp->dxferp, iov_count,
-					   0, &iov, &i);
-		if (res < 0)
-			return res;
+			iov = iovec_import(rw, hp->dxferp, iov_count,
+					   NULL, &i);
+		if (IS_ERR(iov))
+			return PTR_ERR(iov);
 
 		iov_iter_truncate(&i, hp->dxfer_len);
 		if (!iov_iter_count(&i)) {
-- 
2.25.1

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

