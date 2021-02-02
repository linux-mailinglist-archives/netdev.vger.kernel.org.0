Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8498830C43E
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 16:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235752AbhBBPoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 10:44:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:39394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235250AbhBBPOk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 10:14:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E24664F90;
        Tue,  2 Feb 2021 15:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612278447;
        bh=kkuZsHwqzc4z7kCdNJC1MHWPAAFDjtUbT5OsrPAX6yA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BzTMACtY5wfHnQhiMnNjjOBoeg0y1KMDbYxUctUkJ0l88Mw8mPDBtkjyWWDC1Ddwx
         Rn4gZO3a7xcHPzOkQn/KaIemF36vV84vpAcF2H2yt0eHY4n+owBtkhcW94o8DRnAmd
         4ZSmsNeFnnThkxv7l/VnV590m8vnHRNCYubPaCLIGOzOyXRIEzx36iRGTOodbuDoki
         8dg5xcksHoBrrRE6+ncnS/jGenJBrCcYjmwbt9oBVA+FLkLfKw6npevUvtWvAP4VCB
         g1K/77arHRiEQdyp3+9cqXwR6EO6UXCmFsA8M+r4pENIkcNicNZbkJFrm28N+tokOb
         QztWMOHn1/u1Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dave Wysochanski <dwysocha@redhat.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 09/10] SUNRPC: Move simple_get_bytes and simple_get_netobj into private header
Date:   Tue,  2 Feb 2021 10:07:13 -0500
Message-Id: <20210202150715.1864614-9-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210202150715.1864614-1-sashal@kernel.org>
References: <20210202150715.1864614-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Wysochanski <dwysocha@redhat.com>

[ Upstream commit ba6dfce47c4d002d96cd02a304132fca76981172 ]

Remove duplicated helper functions to parse opaque XDR objects
and place inside new file net/sunrpc/auth_gss/auth_gss_internal.h.
In the new file carry the license and copyright from the source file
net/sunrpc/auth_gss/auth_gss.c.  Finally, update the comment inside
include/linux/sunrpc/xdr.h since lockd is not the only user of
struct xdr_netobj.

Signed-off-by: Dave Wysochanski <dwysocha@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sunrpc/xdr.h              |  3 +-
 net/sunrpc/auth_gss/auth_gss.c          | 30 +-----------------
 net/sunrpc/auth_gss/auth_gss_internal.h | 42 +++++++++++++++++++++++++
 net/sunrpc/auth_gss/gss_krb5_mech.c     | 31 ++----------------
 4 files changed, 46 insertions(+), 60 deletions(-)
 create mode 100644 net/sunrpc/auth_gss/auth_gss_internal.h

diff --git a/include/linux/sunrpc/xdr.h b/include/linux/sunrpc/xdr.h
index 2bd68177a442e..33580cc72a43d 100644
--- a/include/linux/sunrpc/xdr.h
+++ b/include/linux/sunrpc/xdr.h
@@ -26,8 +26,7 @@ struct rpc_rqst;
 #define XDR_QUADLEN(l)		(((l) + 3) >> 2)
 
 /*
- * Generic opaque `network object.' At the kernel level, this type
- * is used only by lockd.
+ * Generic opaque `network object.'
  */
 #define XDR_MAX_NETOBJ		1024
 struct xdr_netobj {
diff --git a/net/sunrpc/auth_gss/auth_gss.c b/net/sunrpc/auth_gss/auth_gss.c
index 8cb7d812ccb82..e61c48c1b37d6 100644
--- a/net/sunrpc/auth_gss/auth_gss.c
+++ b/net/sunrpc/auth_gss/auth_gss.c
@@ -53,6 +53,7 @@
 #include <linux/uaccess.h>
 #include <linux/hashtable.h>
 
+#include "auth_gss_internal.h"
 #include "../netns.h"
 
 static const struct rpc_authops authgss_ops;
@@ -147,35 +148,6 @@ gss_cred_set_ctx(struct rpc_cred *cred, struct gss_cl_ctx *ctx)
 	clear_bit(RPCAUTH_CRED_NEW, &cred->cr_flags);
 }
 
-static const void *
-simple_get_bytes(const void *p, const void *end, void *res, size_t len)
-{
-	const void *q = (const void *)((const char *)p + len);
-	if (unlikely(q > end || q < p))
-		return ERR_PTR(-EFAULT);
-	memcpy(res, p, len);
-	return q;
-}
-
-static inline const void *
-simple_get_netobj(const void *p, const void *end, struct xdr_netobj *dest)
-{
-	const void *q;
-	unsigned int len;
-
-	p = simple_get_bytes(p, end, &len, sizeof(len));
-	if (IS_ERR(p))
-		return p;
-	q = (const void *)((const char *)p + len);
-	if (unlikely(q > end || q < p))
-		return ERR_PTR(-EFAULT);
-	dest->data = kmemdup(p, len, GFP_NOFS);
-	if (unlikely(dest->data == NULL))
-		return ERR_PTR(-ENOMEM);
-	dest->len = len;
-	return q;
-}
-
 static struct gss_cl_ctx *
 gss_cred_get_ctx(struct rpc_cred *cred)
 {
diff --git a/net/sunrpc/auth_gss/auth_gss_internal.h b/net/sunrpc/auth_gss/auth_gss_internal.h
new file mode 100644
index 0000000000000..c5603242b54bf
--- /dev/null
+++ b/net/sunrpc/auth_gss/auth_gss_internal.h
@@ -0,0 +1,42 @@
+// SPDX-License-Identifier: BSD-3-Clause
+/*
+ * linux/net/sunrpc/auth_gss/auth_gss_internal.h
+ *
+ * Internal definitions for RPCSEC_GSS client authentication
+ *
+ * Copyright (c) 2000 The Regents of the University of Michigan.
+ * All rights reserved.
+ *
+ */
+#include <linux/err.h>
+#include <linux/string.h>
+#include <linux/sunrpc/xdr.h>
+
+static inline const void *
+simple_get_bytes(const void *p, const void *end, void *res, size_t len)
+{
+	const void *q = (const void *)((const char *)p + len);
+	if (unlikely(q > end || q < p))
+		return ERR_PTR(-EFAULT);
+	memcpy(res, p, len);
+	return q;
+}
+
+static inline const void *
+simple_get_netobj(const void *p, const void *end, struct xdr_netobj *dest)
+{
+	const void *q;
+	unsigned int len;
+
+	p = simple_get_bytes(p, end, &len, sizeof(len));
+	if (IS_ERR(p))
+		return p;
+	q = (const void *)((const char *)p + len);
+	if (unlikely(q > end || q < p))
+		return ERR_PTR(-EFAULT);
+	dest->data = kmemdup(p, len, GFP_NOFS);
+	if (unlikely(dest->data == NULL))
+		return ERR_PTR(-ENOMEM);
+	dest->len = len;
+	return q;
+}
diff --git a/net/sunrpc/auth_gss/gss_krb5_mech.c b/net/sunrpc/auth_gss/gss_krb5_mech.c
index 7bb2514aadd9d..14f2823ad6c20 100644
--- a/net/sunrpc/auth_gss/gss_krb5_mech.c
+++ b/net/sunrpc/auth_gss/gss_krb5_mech.c
@@ -46,6 +46,8 @@
 #include <linux/sunrpc/xdr.h>
 #include <linux/sunrpc/gss_krb5_enctypes.h>
 
+#include "auth_gss_internal.h"
+
 #if IS_ENABLED(CONFIG_SUNRPC_DEBUG)
 # define RPCDBG_FACILITY	RPCDBG_AUTH
 #endif
@@ -187,35 +189,6 @@ get_gss_krb5_enctype(int etype)
 	return NULL;
 }
 
-static const void *
-simple_get_bytes(const void *p, const void *end, void *res, int len)
-{
-	const void *q = (const void *)((const char *)p + len);
-	if (unlikely(q > end || q < p))
-		return ERR_PTR(-EFAULT);
-	memcpy(res, p, len);
-	return q;
-}
-
-static const void *
-simple_get_netobj(const void *p, const void *end, struct xdr_netobj *res)
-{
-	const void *q;
-	unsigned int len;
-
-	p = simple_get_bytes(p, end, &len, sizeof(len));
-	if (IS_ERR(p))
-		return p;
-	q = (const void *)((const char *)p + len);
-	if (unlikely(q > end || q < p))
-		return ERR_PTR(-EFAULT);
-	res->data = kmemdup(p, len, GFP_NOFS);
-	if (unlikely(res->data == NULL))
-		return ERR_PTR(-ENOMEM);
-	res->len = len;
-	return q;
-}
-
 static inline const void *
 get_key(const void *p, const void *end,
 	struct krb5_ctx *ctx, struct crypto_skcipher **res)
-- 
2.27.0

