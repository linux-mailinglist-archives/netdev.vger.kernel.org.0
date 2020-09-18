Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D13B326FD01
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 14:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbgIRMqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 08:46:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726753AbgIRMpy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 08:45:54 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29B81C06178A;
        Fri, 18 Sep 2020 05:45:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=7X3/qUs2y75UUlnvdA2vy1FAPs/IUNMhWXsjmEB0AzE=; b=asfKxViQlq1FD+ot58IVT8gZ94
        dLEzCslIpXlEHDVY3AVvzeQWEaxRhvHNXoigPkGAIjK5bFpDNasQOxqoNgyABCmM6qqkkt51q64Dy
        U/CK/Xw07dd/60lKM1KHzeS66iYZd7bcglc4ZdnqLXf8QC6JOmLB6SzsLsGPLZ4sGBlzYzOE9RXSt
        DxcJwzh9T4OKXpp4G4seXuWqwOoYAwiUhcD6w3brKbgCkdH84kpJRUaaIBc95IuKO6lijNRqToZbP
        HZ0MF5B2UTpvywzo+XWFmaKqS/cx8n+7oEw8/8/UxjpLmR3ZmNR4wU7av4yWOn2KaD4wu1ecjNXE6
        nQMpYohw==;
Received: from [80.122.85.238] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kJFlr-0008Us-Db; Fri, 18 Sep 2020 12:45:47 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        David Howells <dhowells@redhat.com>,
        linux-arm-kernel@lists.infradead.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        keyrings@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [PATCH 9/9] security/keys: remove compat_keyctl_instantiate_key_iov
Date:   Fri, 18 Sep 2020 14:45:33 +0200
Message-Id: <20200918124533.3487701-10-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200918124533.3487701-1-hch@lst.de>
References: <20200918124533.3487701-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that import_iovec handles compat iovecs, the native version of
keyctl_instantiate_key_iov can be used for the compat case as well.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 security/keys/compat.c   | 36 ++----------------------------------
 security/keys/internal.h |  5 -----
 security/keys/keyctl.c   |  2 +-
 3 files changed, 3 insertions(+), 40 deletions(-)

diff --git a/security/keys/compat.c b/security/keys/compat.c
index 7ae531db031cf8..1545efdca56227 100644
--- a/security/keys/compat.c
+++ b/security/keys/compat.c
@@ -11,38 +11,6 @@
 #include <linux/slab.h>
 #include "internal.h"
 
-/*
- * Instantiate a key with the specified compatibility multipart payload and
- * link the key into the destination keyring if one is given.
- *
- * The caller must have the appropriate instantiation permit set for this to
- * work (see keyctl_assume_authority).  No other permissions are required.
- *
- * If successful, 0 will be returned.
- */
-static long compat_keyctl_instantiate_key_iov(
-	key_serial_t id,
-	const struct compat_iovec __user *_payload_iov,
-	unsigned ioc,
-	key_serial_t ringid)
-{
-	struct iovec iovstack[UIO_FASTIOV], *iov = iovstack;
-	struct iov_iter from;
-	long ret;
-
-	if (!_payload_iov)
-		ioc = 0;
-
-	ret = import_iovec(WRITE, (const struct iovec __user *)_payload_iov,
-			   ioc, ARRAY_SIZE(iovstack), &iov, &from);
-	if (ret < 0)
-		return ret;
-
-	ret = keyctl_instantiate_key_common(id, &from, ringid);
-	kfree(iov);
-	return ret;
-}
-
 /*
  * The key control system call, 32-bit compatibility version for 64-bit archs
  */
@@ -113,8 +81,8 @@ COMPAT_SYSCALL_DEFINE5(keyctl, u32, option,
 		return keyctl_reject_key(arg2, arg3, arg4, arg5);
 
 	case KEYCTL_INSTANTIATE_IOV:
-		return compat_keyctl_instantiate_key_iov(
-			arg2, compat_ptr(arg3), arg4, arg5);
+		return keyctl_instantiate_key_iov(arg2, compat_ptr(arg3), arg4,
+						  arg5);
 
 	case KEYCTL_INVALIDATE:
 		return keyctl_invalidate_key(arg2);
diff --git a/security/keys/internal.h b/security/keys/internal.h
index 338a526cbfa516..9b9cf3b6fcbb4d 100644
--- a/security/keys/internal.h
+++ b/security/keys/internal.h
@@ -262,11 +262,6 @@ extern long keyctl_instantiate_key_iov(key_serial_t,
 				       const struct iovec __user *,
 				       unsigned, key_serial_t);
 extern long keyctl_invalidate_key(key_serial_t);
-
-struct iov_iter;
-extern long keyctl_instantiate_key_common(key_serial_t,
-					  struct iov_iter *,
-					  key_serial_t);
 extern long keyctl_restrict_keyring(key_serial_t id,
 				    const char __user *_type,
 				    const char __user *_restriction);
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index 9febd37a168fd0..e26bbccda7ccee 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -1164,7 +1164,7 @@ static int keyctl_change_reqkey_auth(struct key *key)
  *
  * If successful, 0 will be returned.
  */
-long keyctl_instantiate_key_common(key_serial_t id,
+static long keyctl_instantiate_key_common(key_serial_t id,
 				   struct iov_iter *from,
 				   key_serial_t ringid)
 {
-- 
2.28.0

