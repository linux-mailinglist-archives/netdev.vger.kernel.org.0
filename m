Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91B5A2B05B3
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 14:01:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728549AbgKLNBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 08:01:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32430 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728367AbgKLM6x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 07:58:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605185930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HPWihtbjJWUbWPVbAr1/ioOfbP8rP3X1VCCFWfzZRq4=;
        b=DuAmM2AE96ae1pej4vshSahg2UeIWvnio1UlQNF5uyJWUvDDJ77Bv6vNGFOVF7AteDh3w3
        gjlt6GcRLkVQ3IyVFmhUlY7pmRrCrbUB9VpWV5+sZ9pF78juJk375x65qqUFM/FjavXGK2
        kuWWGK9YU/r2VYaGfWEXVB+0ROVM/DY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-322-PyE3nt7zNTyv5KaVKob2SA-1; Thu, 12 Nov 2020 07:58:46 -0500
X-MC-Unique: PyE3nt7zNTyv5KaVKob2SA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 427B0101AFB6;
        Thu, 12 Nov 2020 12:58:45 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-115-47.rdu2.redhat.com [10.10.115.47])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 214485B4AD;
        Thu, 12 Nov 2020 12:58:42 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 07/18] crypto/krb5: Implement the AES enctypes from rfc3962
From:   David Howells <dhowells@redhat.com>
To:     herbert@gondor.apana.org.au, bfields@fieldses.org
Cc:     dhowells@redhat.com, trond.myklebust@hammerspace.com,
        linux-crypto@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 12 Nov 2020 12:58:42 +0000
Message-ID: <160518592226.2277919.16458400030521324547.stgit@warthog.procyon.org.uk>
In-Reply-To: <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk>
References: <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the aes128-cts-hmac-sha1-96 and aes256-cts-hmac-sha1-96 enctypes
from rfc3962, using the rfc3961 kerberos 5 simplified crypto scheme.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/krb5/Makefile      |    3 +
 crypto/krb5/internal.h    |    6 ++
 crypto/krb5/main.c        |    2 +
 crypto/krb5/rfc3962_aes.c |  140 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 150 insertions(+), 1 deletion(-)
 create mode 100644 crypto/krb5/rfc3962_aes.c

diff --git a/crypto/krb5/Makefile b/crypto/krb5/Makefile
index 67824c44aac3..b81e2efac3c8 100644
--- a/crypto/krb5/Makefile
+++ b/crypto/krb5/Makefile
@@ -6,6 +6,7 @@
 krb5-y += \
 	kdf.o \
 	main.o \
-	rfc3961_simplified.o
+	rfc3961_simplified.o \
+	rfc3962_aes.o
 
 obj-$(CONFIG_CRYPTO_KRB5) += krb5.o
diff --git a/crypto/krb5/internal.h b/crypto/krb5/internal.h
index 20b506327491..5d55a574536e 100644
--- a/crypto/krb5/internal.h
+++ b/crypto/krb5/internal.h
@@ -120,3 +120,9 @@ int rfc3961_verify_mic(const struct krb5_enctype *krb5,
 		       struct scatterlist *sg, unsigned nr_sg,
 		       size_t *_offset, size_t *_len,
 		       int *_error_code);
+
+/*
+ * rfc3962_aes.c
+ */
+extern const struct krb5_enctype krb5_aes128_cts_hmac_sha1_96;
+extern const struct krb5_enctype krb5_aes256_cts_hmac_sha1_96;
diff --git a/crypto/krb5/main.c b/crypto/krb5/main.c
index 97b28e40f6d7..bce47580c33f 100644
--- a/crypto/krb5/main.c
+++ b/crypto/krb5/main.c
@@ -18,6 +18,8 @@ MODULE_AUTHOR("Red Hat, Inc.");
 MODULE_LICENSE("GPL");
 
 static const struct krb5_enctype *const krb5_supported_enctypes[] = {
+	&krb5_aes128_cts_hmac_sha1_96,
+	&krb5_aes256_cts_hmac_sha1_96,
 };
 
 /**
diff --git a/crypto/krb5/rfc3962_aes.c b/crypto/krb5/rfc3962_aes.c
new file mode 100644
index 000000000000..99297a698178
--- /dev/null
+++ b/crypto/krb5/rfc3962_aes.c
@@ -0,0 +1,140 @@
+/* rfc3962 Advanced Encryption Standard (AES) Encryption for Kerberos 5
+ *
+ * Parts borrowed from net/sunrpc/auth_gss/.
+ */
+/*
+ * COPYRIGHT (c) 2008
+ * The Regents of the University of Michigan
+ * ALL RIGHTS RESERVED
+ *
+ * Permission is granted to use, copy, create derivative works
+ * and redistribute this software and such derivative works
+ * for any purpose, so long as the name of The University of
+ * Michigan is not used in any advertising or publicity
+ * pertaining to the use of distribution of this software
+ * without specific, written prior authorization.  If the
+ * above copyright notice or any other identification of the
+ * University of Michigan is included in any copy of any
+ * portion of this software, then the disclaimer below must
+ * also be included.
+ *
+ * THIS SOFTWARE IS PROVIDED AS IS, WITHOUT REPRESENTATION
+ * FROM THE UNIVERSITY OF MICHIGAN AS TO ITS FITNESS FOR ANY
+ * PURPOSE, AND WITHOUT WARRANTY BY THE UNIVERSITY OF
+ * MICHIGAN OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING
+ * WITHOUT LIMITATION THE IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
+ * REGENTS OF THE UNIVERSITY OF MICHIGAN SHALL NOT BE LIABLE
+ * FOR ANY DAMAGES, INCLUDING SPECIAL, INDIRECT, INCIDENTAL, OR
+ * CONSEQUENTIAL DAMAGES, WITH RESPECT TO ANY CLAIM ARISING
+ * OUT OF OR IN CONNECTION WITH THE USE OF THE SOFTWARE, EVEN
+ * IF IT HAS BEEN OR IS HEREAFTER ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGES.
+ */
+
+/*
+ * Copyright (C) 1998 by the FundsXpress, INC.
+ *
+ * All rights reserved.
+ *
+ * Export of this software from the United States of America may require
+ * a specific license from the United States Government.  It is the
+ * responsibility of any person or organization contemplating export to
+ * obtain such a license before exporting.
+ *
+ * WITHIN THAT CONSTRAINT, permission to use, copy, modify, and
+ * distribute this software and its documentation for any purpose and
+ * without fee is hereby granted, provided that the above copyright
+ * notice appear in all copies and that both that copyright notice and
+ * this permission notice appear in supporting documentation, and that
+ * the name of FundsXpress. not be used in advertising or publicity pertaining
+ * to distribution of the software without specific, written prior
+ * permission.  FundsXpress makes no representations about the suitability of
+ * this software for any purpose.  It is provided "as is" without express
+ * or implied warranty.
+ *
+ * THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ */
+
+/*
+ * RxGK bits:
+ * Copyright (C) 2020 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <crypto/skcipher.h>
+#include <crypto/hash.h>
+#include <linux/net.h>
+#include <linux/skbuff.h>
+#include <linux/key-type.h>
+#include <linux/slab.h>
+#include <linux/lcm.h>
+#include <linux/ctype.h>
+#include "internal.h"
+
+/*
+ * AES random-to-key function.  For AES, this is an identity operation.
+ */
+static int rfc3962_random_to_key(const struct krb5_enctype *krb5,
+				 const struct krb5_buffer *randombits,
+				 struct krb5_buffer *result)
+{
+	if (randombits->len != 16 && randombits->len != 32)
+		return -EINVAL;
+
+	if (result->len != randombits->len)
+		return -EINVAL;
+
+	memcpy(result->data, randombits->data, randombits->len);
+	return 0;
+}
+
+const struct krb5_enctype krb5_aes128_cts_hmac_sha1_96 = {
+	.etype		= KRB5_ENCTYPE_AES128_CTS_HMAC_SHA1_96,
+	.ctype		= KRB5_CKSUMTYPE_HMAC_SHA1_96_AES128,
+	.name		= "aes128-cts-hmac-sha1-96",
+	.encrypt_name	= "cts(cbc(aes))",
+	.cksum_name	= "hmac(sha1)",
+	.hash_name	= "sha1",
+	.key_bytes	= 16,
+	.key_len	= 16,
+	.Kc_len		= 16,
+	.Ke_len		= 16,
+	.Ki_len		= 16,
+	.block_len	= 16,
+	.conf_len	= 16,
+	.cksum_len	= 12,
+	.hash_len	= 20,
+	.prf_len	= 16,
+	.keyed_cksum	= true,
+	.pad		= true,
+	.random_to_key	= rfc3962_random_to_key,
+	.profile	= &rfc3961_simplified_profile,
+};
+
+const struct krb5_enctype krb5_aes256_cts_hmac_sha1_96 = {
+	.etype		= KRB5_ENCTYPE_AES256_CTS_HMAC_SHA1_96,
+	.ctype		= KRB5_CKSUMTYPE_HMAC_SHA1_96_AES256,
+	.name		= "aes256-cts-hmac-sha1-96",
+	.encrypt_name	= "cts(cbc(aes))",
+	.cksum_name	= "hmac(sha1)",
+	.hash_name	= "sha1",
+	.key_bytes	= 32,
+	.key_len	= 32,
+	.Kc_len		= 32,
+	.Ke_len		= 32,
+	.Ki_len		= 32,
+	.block_len	= 16,
+	.conf_len	= 16,
+	.cksum_len	= 12,
+	.hash_len	= 20,
+	.prf_len	= 16,
+	.keyed_cksum	= true,
+	.pad		= true,
+	.random_to_key	= rfc3962_random_to_key,
+	.profile	= &rfc3961_simplified_profile,
+};


