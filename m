Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D69DA481CCB
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 15:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239809AbhL3OMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 09:12:14 -0500
Received: from lizzy.crudebyte.com ([91.194.90.13]:37057 "EHLO
        lizzy.crudebyte.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239798AbhL3OMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 09:12:13 -0500
X-Greylist: delayed 2521 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Dec 2021 09:12:13 EST
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=lizzy; h=Cc:To:Subject:Date:From:References:In-Reply-To:
        Message-Id:Content-Type:Content-Transfer-Encoding:MIME-Version:Content-ID:
        Content-Description; bh=uZFzuHVsW9bTvGYFZ5r4LS0YJPrnwxn1A5YEmCqKBXY=; b=BrRO1
        HJTeJ6iQrZzlzkcE4NYROqhLo9tAP30o3VGlvhOOqLApJs/b4gdHwh8cKNrdUBAb/N4/W1PSlx8ZN
        z2HZ+05Bg4GaeTnOBKgKLXJUprO1FikVXHA23JkAIFtpkWMnUrCHXYnaw13yALG6UckZGbZFycP2F
        xYhX2vDByNjtT+GJV/2Cgf6N0gjklYzDgUUX2DZtt8pfpxD3fqFT9U8v73M7qrQd6MMkmjozeqSh+
        Q3/vkcgJeFXVo6MLg5WtBRTQAp/QrNwYwcZWA/EMMqC5uvDbfOEClVhdzbwuRHxOVHAUzqDg1ZHsb
        ot/8DoxOxj/X1FK0gcjM5PELiKczg==;
Message-Id: <8c305df4646b65218978fc6474aa0f5f29b216a0.1640870037.git.linux_oss@crudebyte.com>
In-Reply-To: <cover.1640870037.git.linux_oss@crudebyte.com>
References: <cover.1640870037.git.linux_oss@crudebyte.com>
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
Date:   Thu, 30 Dec 2021 14:23:18 +0100
Subject: [PATCH v4 12/12] net/9p: allocate appropriate reduced message buffers
To:     v9fs-developer@lists.sourceforge.net
Cc:     netdev@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Greg Kurz <groug@kaod.org>, Vivek Goyal <vgoyal@redhat.com>,
        Nikolay Kichukov <nikolay@oldum.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So far 'msize' was simply used for all 9p message types, which is far
too much and slowed down performance tremendously with large values
for user configurable 'msize' option.

Let's stop this waste by using the new p9_msg_buf_size() function for
allocating more appropriate, smaller buffers according to what is
actually sent over the wire.

Signed-off-by: Christian Schoenebeck <linux_oss@crudebyte.com>
---
 net/9p/client.c | 33 ++++++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

diff --git a/net/9p/client.c b/net/9p/client.c
index 56be1658870d..773915c95219 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -255,19 +255,35 @@ static struct kmem_cache *p9_req_cache;
  * p9_tag_alloc - Allocate a new request.
  * @c: Client session.
  * @type: Transaction type.
- * @t_size: Buffer size for holding this request.
- * @r_size: Buffer size for holding server's reply on this request.
+ * @t_size: Buffer size for holding this request
+ * (automatic calculation by format template if 0).
+ * @r_size: Buffer size for holding server's reply on this request
+ * (automatic calculation by format template if 0).
+ * @fmt: Format template for assembling 9p request message
+ * (see p9pdu_vwritef).
+ * @ap: Variable arguments to be fed to passed format template
+ * (see p9pdu_vwritef).
  *
  * Context: Process context.
  * Return: Pointer to new request.
  */
 static struct p9_req_t *
-p9_tag_alloc(struct p9_client *c, int8_t type, uint t_size, uint r_size)
+p9_tag_alloc(struct p9_client *c, int8_t type, uint t_size, uint r_size,
+	      const char *fmt, va_list ap)
 {
 	struct p9_req_t *req = kmem_cache_alloc(p9_req_cache, GFP_NOFS);
-	int alloc_tsize = min(c->msize, t_size);
-	int alloc_rsize = min(c->msize, r_size);
+	int alloc_tsize;
+	int alloc_rsize;
 	int tag;
+	va_list apc;
+
+	va_copy(apc, ap);
+	alloc_tsize = min_t(size_t, c->msize,
+			    t_size ?: p9_msg_buf_size(c, type, fmt, apc));
+	va_end(apc);
+
+	alloc_rsize = min_t(size_t, c->msize,
+			    r_size ?: p9_msg_buf_size(c, type + 1, fmt, ap));
 
 	if (!req)
 		return ERR_PTR(-ENOMEM);
@@ -685,6 +701,7 @@ static struct p9_req_t *p9_client_prepare_req(struct p9_client *c,
 {
 	int err;
 	struct p9_req_t *req;
+	va_list apc;
 
 	p9_debug(P9_DEBUG_MUX, "client %p op %d\n", c, type);
 
@@ -696,7 +713,9 @@ static struct p9_req_t *p9_client_prepare_req(struct p9_client *c,
 	if (c->status == BeginDisconnect && type != P9_TCLUNK)
 		return ERR_PTR(-EIO);
 
-	req = p9_tag_alloc(c, type, t_size, r_size);
+	va_copy(apc, ap);
+	req = p9_tag_alloc(c, type, t_size, r_size, fmt, apc);
+	va_end(apc);
 	if (IS_ERR(req))
 		return req;
 
@@ -733,7 +752,7 @@ p9_client_rpc(struct p9_client *c, int8_t type, const char *fmt, ...)
 	struct p9_req_t *req;
 
 	va_start(ap, fmt);
-	req = p9_client_prepare_req(c, type, c->msize, c->msize, fmt, ap);
+	req = p9_client_prepare_req(c, type, 0, 0, fmt, ap);
 	va_end(ap);
 	if (IS_ERR(req))
 		return req;
-- 
2.30.2

