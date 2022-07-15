Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53D58576AE4
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 01:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbiGOXzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 19:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbiGOXzk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 19:55:40 -0400
X-Greylist: delayed 1800 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 15 Jul 2022 16:55:39 PDT
Received: from lizzy.crudebyte.com (lizzy.crudebyte.com [91.194.90.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DA64904DA
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 16:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=lizzy; h=Cc:To:Subject:Date:From:References:In-Reply-To:
        Message-Id:Content-Type:Content-Transfer-Encoding:MIME-Version:Content-ID:
        Content-Description; bh=gw/5dTt+zFJer6MtkKY4HaQ+BoasfQwu/DcrdqeK2lI=; b=Y+u4p
        eVFmiPv7PPxsK5HwO9/FxSp5ivNhCpn4ajIyLeA10WIMFAvGxsyMmyKLCge0UeL6A3+M5X1z7ptAe
        jqErQJDA+9B8uqI7E87MGcmWm3ebi/ahlj+ovcEpyBI9sVh2rPcnR6qWWfL208zWub2rgHDrsMopJ
        F8c3t1qBT5nI2gtpF5cTUqV0RK2UIxe0BNtczX9Ed6Xqw5JbNNaAfiuB0uUaSqx1vPnJHG948x0zb
        +/Px3qUmJc4gv+hMZlH1CVPLrQWZDOGmqqkwJgb1rth9PzuzB5sMBB2BzIHl/FZZlDG5X9BVytfI0
        HzLav/lYqeBU3q25HUgLq5SPfgMxQ==;
Message-Id: <3f51590535dc96ed0a165b8218c57639cfa5c36c.1657920926.git.linux_oss@crudebyte.com>
In-Reply-To: <cover.1657920926.git.linux_oss@crudebyte.com>
References: <cover.1657920926.git.linux_oss@crudebyte.com>
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
Date:   Fri, 15 Jul 2022 23:33:56 +0200
Subject: [PATCH v6 11/11] net/9p: allocate appropriate reduced message buffers
To:     v9fs-developer@lists.sourceforge.net
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Nikolay Kichukov <nikolay@oldum.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
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

Only exception: RDMA transport is currently excluded from this message
size optimization - for its response buffers that is - as RDMA transport
would not cope with it, due to its response buffers being pulled from a
shared pool. [1]

Link: https://lore.kernel.org/all/Ys3jjg52EIyITPua@codewreck.org/ [1]
Signed-off-by: Christian Schoenebeck <linux_oss@crudebyte.com>
---
 net/9p/client.c | 42 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 35 insertions(+), 7 deletions(-)

diff --git a/net/9p/client.c b/net/9p/client.c
index 32a8f2f43479..f068f4b656b5 100644
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
 
@@ -731,9 +750,18 @@ p9_client_rpc(struct p9_client *c, int8_t type, const char *fmt, ...)
 	int sigpending, err;
 	unsigned long flags;
 	struct p9_req_t *req;
+	/* Passing zero for tsize/rsize to p9_client_prepare_req() tells it to
+	 * auto determine an appropriate (small) request/response size
+	 * according to actual message data being sent. Currently RDMA
+	 * transport is excluded from this response message size optimization,
+	 * as it would not cope with it, due to its pooled response buffers
+	 * (using an optimized request size for RDMA as well though).
+	 */
+	const uint tsize = 0;
+	const uint rsize = c->trans_mod->pooled_rbuffers ? c->msize : 0;
 
 	va_start(ap, fmt);
-	req = p9_client_prepare_req(c, type, c->msize, c->msize, fmt, ap);
+	req = p9_client_prepare_req(c, type, tsize, rsize, fmt, ap);
 	va_end(ap);
 	if (IS_ERR(req))
 		return req;
-- 
2.30.2

