Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E25CE5720C8
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 18:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234364AbiGLQ0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 12:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234369AbiGLQZ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 12:25:56 -0400
Received: from lizzy.crudebyte.com (lizzy.crudebyte.com [91.194.90.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B75CB461
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 09:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=lizzy; h=Cc:To:Subject:Date:From:References:In-Reply-To:
        Message-Id:Content-Type:Content-Transfer-Encoding:MIME-Version:Content-ID:
        Content-Description; bh=H+YFkN5zYmDJB9nb0gMFBm80RECXkAIY9geDJBmYEKU=; b=DbZR6
        6mJVSSQo4/g7zVqMaYjlTGpl1wkQbuLWnGu5dQ1AUY02znx2Q3nB0G48axQ8Wlw8Iyk4jAmS0mted
        cGN77eCvebPdm2P4yjm3sg2qpjvsw2zPdfG/x41MX1a1fO+tCX0SN+KpkJ14ebxXKhGx/TOHAsrz7
        Pp9VNjBXX1XVIDm8XdVAFW1GKYPbIjLyowx0h6pTeA1Wg8OnxgN1kPmwSayhpbEf6FFlj2APT9rwm
        1CJX/tuCZGPJscwAVjC3Ktt+vppMSiivzms7KYa2DQg8IsHkxyyEIfG8rpqSoPLe36S6zkkgoDA2r
        kp1zJzTLD1cID6P+7XEfZqZ03UdUg==;
Message-Id: <5fb0bcc402e032cbc0779f428be5797cddfd291c.1657636554.git.linux_oss@crudebyte.com>
In-Reply-To: <cover.1657636554.git.linux_oss@crudebyte.com>
References: <cover.1657636554.git.linux_oss@crudebyte.com>
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
Date:   Tue, 12 Jul 2022 16:31:36 +0200
Subject: [PATCH v5 11/11] net/9p: allocate appropriate reduced message buffers
To:     v9fs-developer@lists.sourceforge.net
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Nikolay Kichukov <nikolay@oldum.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So far 'msize' was simply used for all 9p message types, which is far
too much and slowed down performance tremendously with large values
for user configurable 'msize' option.

Let's stop this waste by using the new p9_msg_buf_size() function for
allocating more appropriate, smaller buffers according to what is
actually sent over the wire.

Only exception: RDMA transport is currently excluded from this, as
it would not cope with it. [1]

Link: https://lore.kernel.org/all/YkmVI6pqTuMD8dVi@codewreck.org/ [1]
Signed-off-by: Christian Schoenebeck <linux_oss@crudebyte.com>
---

Is the !strcmp(c->trans_mod->name, "rdma") check in this patch maybe a bit
too hack-ish? Should there rather be transport API extension instead?

 net/9p/client.c | 39 ++++++++++++++++++++++++++++++++-------
 1 file changed, 32 insertions(+), 7 deletions(-)

diff --git a/net/9p/client.c b/net/9p/client.c
index 56be1658870d..dc1a7b26fab4 100644
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
 
@@ -731,9 +750,15 @@ p9_client_rpc(struct p9_client *c, int8_t type, const char *fmt, ...)
 	int sigpending, err;
 	unsigned long flags;
 	struct p9_req_t *req;
+	/* Passing zero to p9_client_prepare_req() tells it to auto determine an
+	 * appropriate (small) request/response size according to actual message
+	 * data being sent. Currently RDMA transport is excluded from this message
+	 * size optimization, as it would not be able to cope with it.
+	 */
+	const uint max_size = !strcmp(c->trans_mod->name, "rdma") ? c->msize : 0;
 
 	va_start(ap, fmt);
-	req = p9_client_prepare_req(c, type, c->msize, c->msize, fmt, ap);
+	req = p9_client_prepare_req(c, type, max_size, max_size, fmt, ap);
 	va_end(ap);
 	if (IS_ERR(req))
 		return req;
-- 
2.30.2

