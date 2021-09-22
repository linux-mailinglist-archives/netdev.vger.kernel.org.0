Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F33EB414F1B
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 19:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236889AbhIVRcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 13:32:10 -0400
Received: from lizzy.crudebyte.com ([91.194.90.13]:46565 "EHLO
        lizzy.crudebyte.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236837AbhIVRcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 13:32:10 -0400
X-Greylist: delayed 2685 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Sep 2021 13:32:09 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=lizzy; h=Cc:To:Subject:Date:From:References:In-Reply-To:
        Message-Id:Content-Type:Content-Transfer-Encoding:MIME-Version:Content-ID:
        Content-Description; bh=Cqx/q/n6hrY5Ps1ipX2QJFZ34qH2P2+3lxddoYfsBeQ=; b=mS6zR
        z5uI18mxP9aneaQmW2ScNP5w9aJrE0brLyb0fF88Ano26r4RFmTqHe+OVNDntbY37Dxf3WGyIrfOj
        jCFfvJn117/nbx41ncBrYYL6ASfnQ7LRRVHcz0dJd5DFjDJieB8AfyT69VoZD8crr+pclNXNuLsok
        DV23p6ewKwIiw8oi0Xm8wUWP8IDJsxGNi+o6Mq+WVGcoiMNYPz2lo6GzA9C+b5bKKooDG8BxdZfcM
        UwkMk9dKbIq2iqBuyHBfC8YG5gWl2ySeDOuzpW9X42EPz1n52xyk7q724xhzbysqOvQM76m3rG0+Z
        eiIuC6INFp8Vkpnpz8N9bdqw9XJ1g==;
Message-Id: <925da76c58d67372307e5f516989600c96831c3a.1632327421.git.linux_oss@crudebyte.com>
In-Reply-To: <cover.1632327421.git.linux_oss@crudebyte.com>
References: <cover.1632327421.git.linux_oss@crudebyte.com>
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
Date:   Wed, 22 Sep 2021 18:00:21 +0200
Subject: [PATCH v3 1/7] net/9p: show error message if user 'msize' cannot be
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
 net/9p/client.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/9p/client.c b/net/9p/client.c
index 213f12ed76cd..4f4fd2098a30 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -1044,8 +1044,13 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
 	if (err)
 		goto put_trans;
 
-	if (clnt->msize > clnt->trans_mod->maxsize)
+	if (clnt->msize > clnt->trans_mod->maxsize) {
 		clnt->msize = clnt->trans_mod->maxsize;
+		pr_info("Limiting 'msize' to %d as this is the maximum "
+			"supported by transport %s\n",
+			clnt->msize, clnt->trans_mod->name
+		);
+	}
 
 	if (clnt->msize < 4096) {
 		p9_debug(P9_DEBUG_ERROR,
-- 
2.20.1

