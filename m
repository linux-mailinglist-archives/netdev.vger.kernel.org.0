Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42CFD576AE2
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 01:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbiGOXzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 19:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbiGOXzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 19:55:35 -0400
X-Greylist: delayed 1785 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 15 Jul 2022 16:55:34 PDT
Received: from lizzy.crudebyte.com (lizzy.crudebyte.com [91.194.90.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E7D8904EA
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 16:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=lizzy; h=Cc:To:Subject:Date:From:References:In-Reply-To:
        Message-Id:Content-Type:Content-Transfer-Encoding:MIME-Version:Content-ID:
        Content-Description; bh=HRgmsvyQc5R1HqZKiatrCeJDIA/6CkbTdpYiY2zKJhY=; b=Rq8Ur
        FXiEZjgbvLBKHRYMhXFkV36zqPA0exg1NpNzlek1Qkbup154jUInbQ9KzFnnAy1DZXMM0f6Zdih1H
        yEatOg4iZF+fb66Ivo+CwYQC5E1xXOs7j5SzlJdTACI3dNU5CKPefBhW+oZ8gWbhvw9kr+D51TTnD
        RpSY+x6d03BH0xsxW1urFLmbBUXcDxa1vlf35WynvV4nTzlxKEcUQCf6S8ViCVsajA6H1QV4mWpCK
        RkGrHAdsXxZW5nsXy1Qz8wHhoaN/vwXuA6e8AXh2nG8TdI7eFBvQzme4idLIRfeoxXWGL0IkVOQ2Q
        64hJ8faeq+AMHRjCE8Uzta1nrbiOQ==;
Message-Id: <ce9d58cc48a3bb65d4ed5b906eb5f0311030fddd.1657920926.git.linux_oss@crudebyte.com>
In-Reply-To: <cover.1657920926.git.linux_oss@crudebyte.com>
References: <cover.1657920926.git.linux_oss@crudebyte.com>
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
Date:   Fri, 15 Jul 2022 23:32:20 +0200
Subject: [PATCH v6 04/11] net/9p: add trans_maxsize to struct p9_client
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

This new field 'trans_maxsize' optionally allows transport to
update it to reflect the actual maximum msize supported by
allocated transport channel.

Signed-off-by: Christian Schoenebeck <linux_oss@crudebyte.com>
---
 include/net/9p/client.h |  2 ++
 net/9p/client.c         | 12 ++++++++++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/net/9p/client.h b/include/net/9p/client.h
index ec1d1706f43c..f5718057fca4 100644
--- a/include/net/9p/client.h
+++ b/include/net/9p/client.h
@@ -87,6 +87,7 @@ struct p9_req_t {
  * struct p9_client - per client instance state
  * @lock: protect @fids and @reqs
  * @msize: maximum data size negotiated by protocol
+ * @trans_maxsize: actual maximum msize supported by transport channel
  * @proto_version: 9P protocol version to use
  * @trans_mod: module API instantiated with this client
  * @status: connection state
@@ -101,6 +102,7 @@ struct p9_req_t {
 struct p9_client {
 	spinlock_t lock;
 	unsigned int msize;
+	unsigned int trans_maxsize;
 	unsigned char proto_version;
 	struct p9_trans_module *trans_mod;
 	enum p9_trans_status status;
diff --git a/net/9p/client.c b/net/9p/client.c
index 8bba0d9cf975..20054addd81b 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -1031,6 +1031,14 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
 		goto free_client;
 	}
 
+	/*
+	 * transport will get a chance to increase trans_maxsize (if
+	 * necessary) and it may update trans_maxsize in create() function
+	 * below accordingly to reflect the actual maximum size supported by
+	 * the allocated transport channel
+	 */
+	clnt->trans_maxsize = clnt->trans_mod->maxsize;
+
 	p9_debug(P9_DEBUG_MUX, "clnt %p trans %p msize %d protocol %d\n",
 		 clnt, clnt->trans_mod, clnt->msize, clnt->proto_version);
 
@@ -1038,8 +1046,8 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
 	if (err)
 		goto put_trans;
 
-	if (clnt->msize > clnt->trans_mod->maxsize) {
-		clnt->msize = clnt->trans_mod->maxsize;
+	if (clnt->msize > clnt->trans_maxsize) {
+		clnt->msize = clnt->trans_maxsize;
 		pr_info("Limiting 'msize' to %d as this is the maximum "
 			"supported by transport %s\n",
 			clnt->msize, clnt->trans_mod->name
-- 
2.30.2

