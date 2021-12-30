Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9500D481D38
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 15:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240360AbhL3OmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 09:42:19 -0500
Received: from lizzy.crudebyte.com ([91.194.90.13]:32911 "EHLO
        lizzy.crudebyte.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240346AbhL3OmT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 09:42:19 -0500
X-Greylist: delayed 1796 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Dec 2021 09:42:19 EST
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=lizzy; h=Cc:To:Subject:Date:From:References:In-Reply-To:
        Message-Id:Content-Type:Content-Transfer-Encoding:MIME-Version:Content-ID:
        Content-Description; bh=wsH0zZJH3P8YpigJb796yoZLuqDz5KinnqHSkWbAOGs=; b=TQcZk
        M9zTyYEputBDZYa14c6KLLvLrmzfQEQjT3SVAGXBLhpgLwQeGmAOs6qeVDzZzB2lY/vOrNP6rgJsf
        OqivDL2zUCFjP/sKfIL3QmeWiWMQ2riOhU9j1xgWUgDRAiSNpB8o8WDVjbUYO7dmoZn6ooZkKcL77
        vGFkAK35SXZ7LeZMtEQ2LfaQx5soU2RmQHFbZJRC4kvePl+fJP12oVPYDRcN4y27oEd0g40IPWZh0
        V8xCEiYnHB7i84eDZD0t4Yrhk+T7sAsDKX94AM9sWmYAZ20j2XRuNTZbOpnqpy/jUwSQIxXEb569R
        LAtgGRe2/n35pmzXAHNcof1jKlKyA==;
Message-Id: <39f81db5e5b25a1e4f94ad3b05552044209aff21.1640870037.git.linux_oss@crudebyte.com>
In-Reply-To: <cover.1640870037.git.linux_oss@crudebyte.com>
References: <cover.1640870037.git.linux_oss@crudebyte.com>
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
Date:   Thu, 30 Dec 2021 14:23:18 +0100
Subject: [PATCH v4 08/12] net/9p: limit 'msize' to KMALLOC_MAX_SIZE for all
 transports
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

This 9p client implementation is yet using linear message buffers for
most message types, i.e. they use kmalloc() et al. for allocating
continuous physical memory pages, which is usually limited to 4MB
buffers. Use KMALLOC_MAX_SIZE though instead of a hard coded 4MB for
constraining this more safely.

Unfortunately we cannot simply replace the existing kmalloc() calls by
vmalloc() ones, because that would yield in non-logical kernel addresses
(for any vmalloc(>4MB) that is) which are in general not accessible by
hosts like QEMU.

In future we would replace those linear buffers by scatter/gather lists
to eventually get rid of this limit (struct p9_fcall's sdata member by
p9_fcall_init() and struct p9_fid's rdir member by
v9fs_alloc_rdir_buf()).

Signed-off-by: Christian Schoenebeck <linux_oss@crudebyte.com>
---
 net/9p/client.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/9p/client.c b/net/9p/client.c
index 20054addd81b..fab939541c81 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -1042,6 +1042,17 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
 	p9_debug(P9_DEBUG_MUX, "clnt %p trans %p msize %d protocol %d\n",
 		 clnt, clnt->trans_mod, clnt->msize, clnt->proto_version);
 
+	/*
+	 * due to linear message buffers being used by client ATM
+	 */
+	if (clnt->msize > KMALLOC_MAX_SIZE) {
+		clnt->msize = KMALLOC_MAX_SIZE;
+		pr_info("Limiting 'msize' to %zu as this is the maximum "
+			"supported by this client version.\n",
+			(size_t) KMALLOC_MAX_SIZE
+		);
+	}
+
 	err = clnt->trans_mod->create(clnt, dev_name, options);
 	if (err)
 		goto put_trans;
-- 
2.30.2

