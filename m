Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1DB840EADA
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 21:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232944AbhIPTcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 15:32:14 -0400
Received: from lizzy.crudebyte.com ([91.194.90.13]:59309 "EHLO
        lizzy.crudebyte.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232968AbhIPTcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 15:32:13 -0400
X-Greylist: delayed 1666 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Sep 2021 15:32:13 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=lizzy; h=Cc:To:Subject:Date:From:References:In-Reply-To:
        Message-Id:Content-Type:Content-Transfer-Encoding:MIME-Version:Content-ID:
        Content-Description; bh=MalCTXy4Amqsr7Q1glzzLRVpX1FSq0ykfLndkSutSgY=; b=ICtcv
        jh7xonqeY0f6VKo0Ad/xKiz+lX7IjK3Gcr0mOBRKDlXIbZ/RWIuD79IQZ95yhNjw+lBuvk3/UA4R6
        qQHHmHvSxF9V0VKY6Z8r0tWbMCOuYuhqSbNffCCsh17dZwCn2gsmUgqj1GFIGNAckA0c2/J8amZai
        88mYNWCh3wAanqDIzcWIomMnzOtMHmoRKztNIcgPmu2BBKlym1jTE1ktY7PLClRbX2NB/vGG4VWSg
        pFfQ/W6atIHiCR4EoX0DGoaBTSeNyoVfaAE6KMzRwuwlcfPNs/wEws3T87rSOMWo4AfKePzCR18S9
        vL6fVsFkGa1O+U33LD9TzK9c5erhg==;
Message-Id: <634f2aabd957966c7e576d769ad6bb96dbd4bfae.1631816768.git.linux_oss@crudebyte.com>
In-Reply-To: <cover.1631816768.git.linux_oss@crudebyte.com>
References: <cover.1631816768.git.linux_oss@crudebyte.com>
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
Date:   Thu, 16 Sep 2021 20:25:10 +0200
Subject: [PATCH 5/7] net/9p: add trans_maxsize to struct p9_client
To:     v9fs-developer@lists.sourceforge.net
Cc:     netdev@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Greg Kurz <groug@kaod.org>, Vivek Goyal <vgoyal@redhat.com>
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
index e1c308d8d288..e48c4cdf9be0 100644
--- a/include/net/9p/client.h
+++ b/include/net/9p/client.h
@@ -89,6 +89,7 @@ struct p9_req_t {
  * struct p9_client - per client instance state
  * @lock: protect @fids and @reqs
  * @msize: maximum data size negotiated by protocol
+ * @trans_maxsize: actual maximum msize supported by transport channel
  * @proto_version: 9P protocol version to use
  * @trans_mod: module API instantiated with this client
  * @status: connection state
@@ -103,6 +104,7 @@ struct p9_req_t {
 struct p9_client {
 	spinlock_t lock;
 	unsigned int msize;
+	unsigned int trans_maxsize;
 	unsigned char proto_version;
 	struct p9_trans_module *trans_mod;
 	enum p9_trans_status status;
diff --git a/net/9p/client.c b/net/9p/client.c
index fa2afeaf1394..6e699ede069e 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -1037,6 +1037,14 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
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
 
@@ -1044,8 +1052,8 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
 	if (err)
 		goto put_trans;
 
-	if (clnt->msize > clnt->trans_mod->maxsize) {
-		clnt->msize = clnt->trans_mod->maxsize;
+	if (clnt->msize > clnt->trans_maxsize) {
+		clnt->msize = clnt->trans_maxsize;
 		p9_debug(P9_DEBUG_ERROR,
 			 "Limiting 'msize' to %d as this is the maximum "
 			 "supported by transport %s\n",
-- 
2.20.1

