Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5295C481D32
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 15:42:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239842AbhL3OmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 09:42:07 -0500
Received: from lizzy.crudebyte.com ([91.194.90.13]:49973 "EHLO
        lizzy.crudebyte.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235784AbhL3OmH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 09:42:07 -0500
X-Greylist: delayed 4311 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Dec 2021 09:42:07 EST
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=lizzy; h=Cc:To:Subject:Date:From:References:In-Reply-To:
        Message-Id:Content-Type:Content-Transfer-Encoding:MIME-Version:Content-ID:
        Content-Description; bh=S1MxFhNkRqNtF8cNgTKG1aWD8I0cArSeeYZ1LCi9IyY=; b=gQuBI
        J/yh7So1jopa2gZ0eb5jM4PAnSZdsumbkSiw0C5+DNMByHFQvvQyuL9Go9VvqnMH0/AV5nwS1TIHi
        JV15/d4vrBSeRtCOTRj+PKzsbCDPODqkweC7xtGNUcJNWMaLXeR4714v9FzHMvejhIo6400+sbkOL
        mUci50A2igtc3Jyh5RL1OhPZQFt6ZwIR8xiWwFIfA25spfBXJxI2mXgtk23+UnvmYsXPkJ1kiyMe3
        ZGlp90tLmuOqDd4lcVsK8fZF4GkjYUP+YXGvlchS02FuNMKcPhHYy3oPlYk+Zq/vPFqaXaOafh+TM
        XLDaFl7eHRzxEU7iVZWnzdfULHW4w==;
Message-Id: <783ba37c1566dd715b9a67d437efa3b77e3cd1a7.1640870037.git.linux_oss@crudebyte.com>
In-Reply-To: <cover.1640870037.git.linux_oss@crudebyte.com>
References: <cover.1640870037.git.linux_oss@crudebyte.com>
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
Date:   Thu, 30 Dec 2021 14:23:18 +0100
Subject: [PATCH v4 01/12] net/9p: show error message if user 'msize' cannot be
 satisfied
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
index d062f1e5bfb0..8bba0d9cf975 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -1038,8 +1038,13 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
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
2.30.2

