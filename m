Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA8140EADB
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 21:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233191AbhIPTcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 15:32:17 -0400
Received: from lizzy.crudebyte.com ([91.194.90.13]:52197 "EHLO
        lizzy.crudebyte.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232971AbhIPTcP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 15:32:15 -0400
X-Greylist: delayed 1697 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Sep 2021 15:32:14 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=lizzy; h=Cc:To:Subject:Date:From:References:In-Reply-To:
        Message-Id:Content-Type:Content-Transfer-Encoding:MIME-Version:Content-ID:
        Content-Description; bh=QPWFanfpCBF2qhY8OC7p/jDdXs1FdUBjf7+Y+u2GJu8=; b=WMiIx
        B7BEmGI8Oka1l3oOmiaoLDtwgZxI10DZpnBDwu6RRSf+ZV+LfOor/dFeFsT0tDosgdUbmdE2Khugq
        rSIi1a3p6jp71f0iV0ig8l/3HzMXDGmQXr8WJg4gqQy3ef10l6sj1a5g8OjouGBfDDSeifztcrTrd
        f5rvRrVhlWL/YP8LQ7fANmz6ERNJdWxHdvywMBzfzX1jwZJzZN5XheBzJHxJqVrMcqJt0nrkVjfiC
        qPe0M7IG2siiO0FKvtMmik8BfxVaewswnCp/TPjxdftjS4qU1HgEJGlpQdWD6MAynuaPhWDcwNm/n
        /2xqQYVxcR/lBHlZJwClTIE6cRk1g==;
Message-Id: <c9492a713e9fde483700c8eba2cb62d36f88f918.1631816768.git.linux_oss@crudebyte.com>
In-Reply-To: <cover.1631816768.git.linux_oss@crudebyte.com>
References: <cover.1631816768.git.linux_oss@crudebyte.com>
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
Date:   Thu, 16 Sep 2021 20:24:24 +0200
Subject: [PATCH 1/7] net/9p: show error message if user 'msize' cannot be
 satisfied
To:     v9fs-developer@lists.sourceforge.net
Cc:     netdev@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Greg Kurz <groug@kaod.org>, Vivek Goyal <vgoyal@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If user supplied a large value with the 'msize' option, then
client would silently limit that 'msize' value to the maximum
value supported by transport. That's a bit confusing for users
of not having any indication why the preferred 'msize' value
could not be satisfied.

Reported-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Christian Schoenebeck <linux_oss@crudebyte.com>
---
 net/9p/client.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/9p/client.c b/net/9p/client.c
index 213f12ed76cd..fa2afeaf1394 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -1044,8 +1044,14 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
 	if (err)
 		goto put_trans;
 
-	if (clnt->msize > clnt->trans_mod->maxsize)
+	if (clnt->msize > clnt->trans_mod->maxsize) {
 		clnt->msize = clnt->trans_mod->maxsize;
+		p9_debug(P9_DEBUG_ERROR,
+			 "Limiting 'msize' to %d as this is the maximum "
+			 "supported by transport %s\n",
+			 clnt->msize, clnt->trans_mod->name
+		);
+	}
 
 	if (clnt->msize < 4096) {
 		p9_debug(P9_DEBUG_ERROR,
-- 
2.20.1

