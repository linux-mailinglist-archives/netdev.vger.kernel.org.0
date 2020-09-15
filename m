Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4E126B371
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 01:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbgIOXDC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 15 Sep 2020 19:03:02 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:55849 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727154AbgIOOzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 10:55:50 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-58-hE9Q3gdSNFe5XdWmGMGaOw-1; Tue, 15 Sep 2020 15:55:28 +0100
X-MC-Unique: hE9Q3gdSNFe5XdWmGMGaOw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 15 Sep 2020 15:55:27 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 15 Sep 2020 15:55:27 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 6/9 next] security/keys: Use iovec_import() instead of
 import_iovec().
Thread-Topic: [PATCH 6/9 next] security/keys: Use iovec_import() instead of
 import_iovec().
Thread-Index: AdaLbbVb64qzHlH6QG+P0w/qtCnTtA==
Date:   Tue, 15 Sep 2020 14:55:27 +0000
Message-ID: <4cea8bac469142118b996f62294de6ef@AcuMS.aculab.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0.002
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
 security/keys/compat.c | 11 +++++------
 security/keys/keyctl.c | 10 +++++-----
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/security/keys/compat.c b/security/keys/compat.c
index 6ee9d8f6a4a5..c8b6cc77028b 100644
--- a/security/keys/compat.c
+++ b/security/keys/compat.c
@@ -26,18 +26,17 @@ static long compat_keyctl_instantiate_key_iov(
 	unsigned ioc,
 	key_serial_t ringid)
 {
-	struct iovec iovstack[UIO_FASTIOV], *iov = iovstack;
+	struct iovec_cache cache;
 	struct iov_iter from;
+	struct iovec *iov;
 	long ret;
 
 	if (!_payload_iov)
 		ioc = 0;
 
-	ret = compat_import_iovec(WRITE, _payload_iov, ioc,
-				  ARRAY_SIZE(iovstack), &iov,
-				  &from);
-	if (ret < 0)
-		return ret;
+	iov = compat_iovec_import(WRITE, _payload_iov, ioc, &cache, &from);
+	if (IS_ERR(iov))
+		return PTR_ERR(iov);
 
 	ret = keyctl_instantiate_key_common(id, &from, ringid);
 	kfree(iov);
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index 9febd37a168f..9a90b89ef24b 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -1276,17 +1276,17 @@ long keyctl_instantiate_key_iov(key_serial_t id,
 				unsigned ioc,
 				key_serial_t ringid)
 {
-	struct iovec iovstack[UIO_FASTIOV], *iov = iovstack;
+	struct iovec_cache cache;
 	struct iov_iter from;
+	struct iovec *iov;
 	long ret;
 
 	if (!_payload_iov)
 		ioc = 0;
 
-	ret = import_iovec(WRITE, _payload_iov, ioc,
-				    ARRAY_SIZE(iovstack), &iov, &from);
-	if (ret < 0)
-		return ret;
+	iov = iovec_import(WRITE, _payload_iov, ioc, &cache, &from);
+	if (IS_ERR(iov))
+		return PTR_ERR(iov);
 	ret = keyctl_instantiate_key_common(id, &from, ringid);
 	kfree(iov);
 	return ret;
-- 
2.25.1

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

