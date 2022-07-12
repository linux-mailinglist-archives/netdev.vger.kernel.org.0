Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 529185720CD
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 18:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233696AbiGLQ0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 12:26:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbiGLQ0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 12:26:18 -0400
X-Greylist: delayed 1817 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 12 Jul 2022 09:26:07 PDT
Received: from lizzy.crudebyte.com (lizzy.crudebyte.com [91.194.90.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45409CD3E2;
        Tue, 12 Jul 2022 09:26:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=lizzy; h=Cc:To:Subject:Date:From:References:In-Reply-To:
        Message-Id:Content-Type:Content-Transfer-Encoding:MIME-Version:Content-ID:
        Content-Description; bh=JMpUBU0faqNlIU1d4S3Q7wytCNCfKZ32SXUnAyXuU0s=; b=l5jMp
        ahtD82dcoJIxOpadC+7Ya05P5Y6jrL3x9n2/0e5x/mJMHr3LXQZYJrrSTRS9QZi2LMVR3n83jBXa+
        UgAGM5H1snVgtfqbTycQK9AzR0z/2le+ktS8UZYrvkIXqaq2RXX1UkiciUM/i+1Um1XvKzyPoGjht
        Yt00ON/MNJmgRiTQ0YYLUbO+FyFeqeA7zV4IHttRmr6fcvH3IKOvrt5EfgQ7Xn3ra4SezWh3chPtw
        bd0NO3sSX1H7YTkM3vhzezsCd03KneFG3dimkAtVVqNDYz1WJnDcNhCeYOP+7ST+WiF39sZ1wwSg/
        Xpv6NIA7JAUvFSjJq7mVjLqKuhqbQ==;
Message-Id: <13a7181ea6264264923effcbc8eb5691892731b8.1657636554.git.linux_oss@crudebyte.com>
In-Reply-To: <cover.1657636554.git.linux_oss@crudebyte.com>
References: <cover.1657636554.git.linux_oss@crudebyte.com>
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
Date:   Tue, 12 Jul 2022 16:31:28 +0200
Subject: [PATCH v5 08/11] net/9p: split message size argument into 't_size'
 and 'r_size' pair
To:     v9fs-developer@lists.sourceforge.net
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Nikolay Kichukov <nikolay@oldum.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor 'max_size' argument of p9_tag_alloc() and 'req_size' argument
of p9_client_prepare_req() both into a pair of arguments 't_size' and
'r_size' respectively to allow handling the buffer size for request and
reply separately from each other.

Signed-off-by: Christian Schoenebeck <linux_oss@crudebyte.com>
---
 net/9p/client.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/net/9p/client.c b/net/9p/client.c
index fab939541c81..56be1658870d 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -255,24 +255,26 @@ static struct kmem_cache *p9_req_cache;
  * p9_tag_alloc - Allocate a new request.
  * @c: Client session.
  * @type: Transaction type.
- * @max_size: Maximum packet size for this request.
+ * @t_size: Buffer size for holding this request.
+ * @r_size: Buffer size for holding server's reply on this request.
  *
  * Context: Process context.
  * Return: Pointer to new request.
  */
 static struct p9_req_t *
-p9_tag_alloc(struct p9_client *c, int8_t type, unsigned int max_size)
+p9_tag_alloc(struct p9_client *c, int8_t type, uint t_size, uint r_size)
 {
 	struct p9_req_t *req = kmem_cache_alloc(p9_req_cache, GFP_NOFS);
-	int alloc_msize = min(c->msize, max_size);
+	int alloc_tsize = min(c->msize, t_size);
+	int alloc_rsize = min(c->msize, r_size);
 	int tag;
 
 	if (!req)
 		return ERR_PTR(-ENOMEM);
 
-	if (p9_fcall_init(c, &req->tc, alloc_msize))
+	if (p9_fcall_init(c, &req->tc, alloc_tsize))
 		goto free_req;
-	if (p9_fcall_init(c, &req->rc, alloc_msize))
+	if (p9_fcall_init(c, &req->rc, alloc_rsize))
 		goto free;
 
 	p9pdu_reset(&req->tc);
@@ -678,7 +680,7 @@ static int p9_client_flush(struct p9_client *c, struct p9_req_t *oldreq)
 }
 
 static struct p9_req_t *p9_client_prepare_req(struct p9_client *c,
-					      int8_t type, int req_size,
+					      int8_t type, uint t_size, uint r_size,
 					      const char *fmt, va_list ap)
 {
 	int err;
@@ -694,7 +696,7 @@ static struct p9_req_t *p9_client_prepare_req(struct p9_client *c,
 	if (c->status == BeginDisconnect && type != P9_TCLUNK)
 		return ERR_PTR(-EIO);
 
-	req = p9_tag_alloc(c, type, req_size);
+	req = p9_tag_alloc(c, type, t_size, r_size);
 	if (IS_ERR(req))
 		return req;
 
@@ -731,7 +733,7 @@ p9_client_rpc(struct p9_client *c, int8_t type, const char *fmt, ...)
 	struct p9_req_t *req;
 
 	va_start(ap, fmt);
-	req = p9_client_prepare_req(c, type, c->msize, fmt, ap);
+	req = p9_client_prepare_req(c, type, c->msize, c->msize, fmt, ap);
 	va_end(ap);
 	if (IS_ERR(req))
 		return req;
@@ -829,7 +831,7 @@ static struct p9_req_t *p9_client_zc_rpc(struct p9_client *c, int8_t type,
 	/* We allocate a inline protocol data of only 4k bytes.
 	 * The actual content is passed in zero-copy fashion.
 	 */
-	req = p9_client_prepare_req(c, type, P9_ZC_HDR_SZ, fmt, ap);
+	req = p9_client_prepare_req(c, type, P9_ZC_HDR_SZ, P9_ZC_HDR_SZ, fmt, ap);
 	va_end(ap);
 	if (IS_ERR(req))
 		return req;
-- 
2.30.2

