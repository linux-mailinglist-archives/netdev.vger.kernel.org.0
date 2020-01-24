Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52346148B6B
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 16:46:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389220AbgAXPqK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 24 Jan 2020 10:46:10 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:34175 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388702AbgAXPqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 10:46:10 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-80-p_Wlfi7TNA2BKLOS9TLtLQ-1; Fri, 24 Jan 2020 15:46:07 +0000
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 24 Jan 2020 15:46:06 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 24 Jan 2020 15:46:06 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: [PATCH 3/3] Optimise kfree() of memory used for large user iovecs.
Thread-Topic: [PATCH 3/3] Optimise kfree() of memory used for large user
 iovecs.
Thread-Index: AdXSzPQ0ktkYmEzMTdeKhYNPUylYdw==
Date:   Fri, 24 Jan 2020 15:46:06 +0000
Message-ID: <92b426959a1b4ecba8539006572bf21d@AcuMS.aculab.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: p_Wlfi7TNA2BKLOS9TLtLQ-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Although kfree(NULL) is valid it is slower that checking in the
calling code.
Most of the time passing NULL is unusual, but in the code that
is reading iovecs from the user NULL is the normal case
(only large SG vectors require kmalloc()).
Add a check in the callers before calling kfree().

Signed-off-by: David Laight <david.laight@aculab.com>
---

Note this patch probably needs splitting in 3.

 fs/read_write.c        | 12 ++++++++----
 fs/splice.c            |  6 ++++--
 net/socket.c           |  3 ++-
 security/keys/compat.c |  3 ++-
 security/keys/keyctl.c |  3 ++-
 5 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 0241d68..8f77982 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -995,7 +995,8 @@ ssize_t vfs_readv(struct file *file, const struct iovec __user *vec,
 	ret = import_iovec(READ, vec, vlen, &iov, &iter);
 	if (ret >= 0) {
 		ret = do_iter_read(file, &iter, pos, flags);
-		kfree(iov);
+		if (unlikely(iov))
+			kfree(iov);
 	}
 
 	return ret;
@@ -1014,7 +1015,8 @@ static ssize_t vfs_writev(struct file *file, const struct iovec __user *vec,
 		file_start_write(file);
 		ret = do_iter_write(file, &iter, pos, flags);
 		file_end_write(file);
-		kfree(iov);
+		if (unlikely(iov))
+			kfree(iov);
 	}
 	return ret;
 }
@@ -1184,7 +1186,8 @@ static size_t compat_readv(struct file *file,
 	ret = compat_import_iovec(READ, vec, vlen, &iov, &iter);
 	if (ret >= 0) {
 		ret = do_iter_read(file, &iter, pos, flags);
-		kfree(iov);
+		if (unlikely(iov))
+			kfree(iov);
 	}
 	if (ret > 0)
 		add_rchar(current, ret);
@@ -1294,7 +1297,8 @@ static size_t compat_writev(struct file *file,
 		file_start_write(file);
 		ret = do_iter_write(file, &iter, pos, flags);
 		file_end_write(file);
-		kfree(iov);
+		if (unlikely(iov))
+			kfree(iov);
 	}
 	if (ret > 0)
 		add_wchar(current, ret);
diff --git a/fs/splice.c b/fs/splice.c
index ef919db..c2787d2 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1368,7 +1368,8 @@ static long do_vmsplice(struct file *f, struct iov_iter *iter, unsigned int flag
 	error = import_iovec(type, uiov, nr_segs, &iov, &iter);
 	if (error >= 0) {
 		error = do_vmsplice(f.file, &iter, flags);
-		kfree(iov);
+		if (unlikely(iov))
+			kfree(iov);
 	}
 	fdput(f);
 	return error;
@@ -1393,7 +1394,8 @@ static long do_vmsplice(struct file *f, struct iov_iter *iter, unsigned int flag
 	error = compat_import_iovec(type, iov32, nr_segs, &iov, &iter);
 	if (error >= 0) {
 		error = do_vmsplice(f.file, &iter, flags);
-		kfree(iov);
+		if (unlikely(iov))
+			kfree(iov);
 	}
 	fdput(f);
 	return error;
diff --git a/net/socket.c b/net/socket.c
index cb67d82..249d743 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2324,7 +2324,8 @@ static int ___sys_sendmsg(struct socket *sock, struct user_msghdr __user *msg,
 	if (ctl_buf != ctl)
 		sock_kfree_s(sock->sk, ctl_buf, ctl_len);
 out_freeiov:
-	kfree(iov);
+	if (unlikely(iov))
+		kfree(iov);
 	return err;
 }
 
diff --git a/security/keys/compat.c b/security/keys/compat.c
index d5ddf80..e73c009 100644
--- a/security/keys/compat.c
+++ b/security/keys/compat.c
@@ -38,7 +38,8 @@ static long compat_keyctl_instantiate_key_iov(
 		return ret;
 
 	ret = keyctl_instantiate_key_common(id, &from, ringid);
-	kfree(iov);
+	if (unlikely(iov))
+		kfree(iov);
 	return ret;
 }
 
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index ee26360..74aeb32 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -1219,7 +1219,8 @@ long keyctl_instantiate_key_iov(key_serial_t id,
 	if (ret < 0)
 		return ret;
 	ret = keyctl_instantiate_key_common(id, &from, ringid);
-	kfree(iov);
+	if (unlikely(iov))
+		kfree(iov);
 	return ret;
 }
 
-- 
1.8.1.2

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

