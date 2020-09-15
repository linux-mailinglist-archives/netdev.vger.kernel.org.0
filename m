Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BAF326B35E
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 01:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727416AbgIOXCI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 15 Sep 2020 19:02:08 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:48142 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727309AbgIOOzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 10:55:50 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id uk-mta-5-ZlNQaq51PdSjWG-hec5MQA-1;
 Tue, 15 Sep 2020 15:55:31 +0100
X-MC-Unique: ZlNQaq51PdSjWG-hec5MQA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 15 Sep 2020 15:55:31 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 15 Sep 2020 15:55:31 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 7/9 next] mm/process_vm_access: Use iovec_import() instead of
 import_iovec().
Thread-Topic: [PATCH 7/9 next] mm/process_vm_access: Use iovec_import()
 instead of import_iovec().
Thread-Index: AdaLbliE1LQuFgQoRvuMh1ueXN8hpw==
Date:   Tue, 15 Sep 2020 14:55:30 +0000
Message-ID: <a8fbbfe542af48ee9bcd2d9c835e5c32@AcuMS.aculab.com>
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
 mm/process_vm_access.c | 81 ++++++++++++++++++++++--------------------
 1 file changed, 42 insertions(+), 39 deletions(-)

diff --git a/mm/process_vm_access.c b/mm/process_vm_access.c
index 1cc3d6f66b31..048637944d47 100644
--- a/mm/process_vm_access.c
+++ b/mm/process_vm_access.c
@@ -260,10 +260,10 @@ static ssize_t process_vm_rw(pid_t pid,
 			     unsigned long riovcnt,
 			     unsigned long flags, int vm_write)
 {
-	struct iovec iovstack_l[UIO_FASTIOV];
-	struct iovec iovstack_r[UIO_FASTIOV];
-	struct iovec *iov_l = iovstack_l;
-	struct iovec *iov_r = iovstack_r;
+	struct iovec_cache cache_l;
+	struct iovec_cache cache_r;
+	struct iovec *iov_l;
+	struct iovec *iov_r;
 	struct iov_iter iter_l, iter_r;
 	ssize_t rc;
 	int dir = vm_write ? WRITE : READ;
@@ -272,24 +272,25 @@ static ssize_t process_vm_rw(pid_t pid,
 		return -EINVAL;
 
 	/* Check iovecs */
-	rc = import_iovec(dir, lvec, liovcnt, UIO_FASTIOV, &iov_l, &iter_l);
-	if (rc < 0)
-		return rc;
-	if (!iov_iter_count(&iter_l))
-		goto free_iovecs;
-
-	rc = import_iovec(CHECK_IOVEC_ONLY, rvec, riovcnt, UIO_FASTIOV, &iov_r, &iter_r);
-	if (rc <= 0)
-		goto free_iovecs;
-
-	rc = process_vm_rw_core(pid, &iter_l, iter_r.iov, iter_r.nr_segs,
-				flags, vm_write);
+	iov_l = iovec_import(dir, lvec, liovcnt, &cache_l, &iter_l);
+	if (IS_ERR(iov_l))
+		return PTR_ERR(iov_l);
+	if (!iov_iter_count(&iter_l)) {
+		rc = 0;
+		goto free_iovec_l;
+	}
 
-free_iovecs:
-	if (iov_r != iovstack_r)
+	iov_r = iovec_import(CHECK_IOVEC_ONLY, rvec, riovcnt, &cache_r, &iter_r);
+	if (IS_ERR(iov_r)) {
+		rc = PTR_ERR(iov_r);
+	} else {
+		rc = process_vm_rw_core(pid, &iter_l, iter_r.iov,
+				iter_r.nr_segs, flags, vm_write);
 		kfree(iov_r);
-	if (iov_l != iovstack_l)
-		kfree(iov_l);
+	}
+
+free_iovec_l:
+	kfree(iov_l);
 
 	return rc;
 }
@@ -319,10 +320,10 @@ compat_process_vm_rw(compat_pid_t pid,
 		     unsigned long riovcnt,
 		     unsigned long flags, int vm_write)
 {
-	struct iovec iovstack_l[UIO_FASTIOV];
-	struct iovec iovstack_r[UIO_FASTIOV];
-	struct iovec *iov_l = iovstack_l;
-	struct iovec *iov_r = iovstack_r;
+	struct iovec_cache cache_l;
+	struct iovec_cache cache_r;
+	struct iovec *iov_l;
+	struct iovec *iov_r;
 	struct iov_iter iter_l, iter_r;
 	ssize_t rc = -EFAULT;
 	int dir = vm_write ? WRITE : READ;
@@ -330,23 +331,25 @@ compat_process_vm_rw(compat_pid_t pid,
 	if (flags != 0)
 		return -EINVAL;
 
-	rc = compat_import_iovec(dir, lvec, liovcnt, UIO_FASTIOV, &iov_l, &iter_l);
-	if (rc < 0)
-		return rc;
-	if (!iov_iter_count(&iter_l))
-		goto free_iovecs;
-	rc = compat_import_iovec(0, rvec, riovcnt, UIO_FASTIOV, &iov_r, &iter_r);
-	if (rc <= 0)
-		goto free_iovecs;
-
-	rc = process_vm_rw_core(pid, &iter_l, iter_r.iov, iter_r.nr_segs,
-				flags, vm_write);
+	iov_l = compat_iovec_import(dir, lvec, liovcnt, &cache_l, &iter_l);
+	if (IS_ERR(iov_l))
+		return PTR_ERR(iov_l);
+	if (!iov_iter_count(&iter_l)) {
+		rc = 0;
+		goto free_iovec_l;
+	}
 
-free_iovecs:
-	if (iov_r != iovstack_r)
+	iov_r = compat_iovec_import(0, rvec, riovcnt, &cache_r, &iter_r);
+	if (IS_ERR(iov_r)) {
+		rc = PTR_ERR(iov_r);
+	} else {
+		rc = process_vm_rw_core(pid, &iter_l, iter_r.iov,
+				iter_r.nr_segs, flags, vm_write);
 		kfree(iov_r);
-	if (iov_l != iovstack_l)
-		kfree(iov_l);
+	}
+
+free_iovec_l:
+	kfree(iov_l);
 	return rc;
 }
 
-- 
2.25.1

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

