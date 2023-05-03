Return-Path: <netdev+bounces-95-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F9846F523B
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 09:50:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 030671C20BCE
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 07:50:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3AF063B1;
	Wed,  3 May 2023 07:49:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A720B63AA
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 07:49:57 +0000 (UTC)
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 331A63C3C;
	Wed,  3 May 2023 00:49:54 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
	id 78366C023; Wed,  3 May 2023 09:49:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
	t=1683100193; bh=JLVZ2qr0aADxwht3HhrKMBGu5TWbkRKBfSfnYvYN75k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=jV4yOO4QsLylfiKRa07f0uak6kW/yEilPPdwH4NcdIUwtTUyO3yIUMpNWqXc7kXC5
	 k6ezhDZrrvjHzGzpBQ2Y9EzEJDGtFo/IVs8t7riTsKl0FzbyTqEGJxqa7Pgpcm3V0g
	 HdumY7jHOjS/Zezvn33VNDC6blUsksP1uPQBxpMVl3ZN0xCLY8YNYwJI1QQAXt/Ujr
	 8bBXrJ5vdtVXDr8iqsMv+dSv/l4kgAf85Y9UeBmwfkByoHcJJ3XyGLeRiCjLGi43OC
	 uwizkyxemtpA62dEe4HCIS9U7g2KcFyjBHkfUTjvJHOgcYF4XkJB6x0lK8ll9jIk+H
	 GWaUq5R71aNxA==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
	by nautica.notk.org (Postfix) with ESMTPS id C2E6BC01B;
	Wed,  3 May 2023 09:49:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
	t=1683100192; bh=JLVZ2qr0aADxwht3HhrKMBGu5TWbkRKBfSfnYvYN75k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=S73ApCJN611o1b3HAaqBGFo4q24SoUEsRPJnIcVNEF991guUmTu0NcSUEscdakiyA
	 LCiDz8rM9Zg8WPnDBOxNBk2sRzXQhzXA2YlFFZMOVItzRnxw76HY7iC6EKXzF7+8sI
	 Cto+uL6+P8B/6bPxrB0+n2car+BqyM7Xl0UhHbMYXclGK5fvODIBCi06D36QUCocmB
	 IRRcx2+8vD7Qh8bXN7in030rOPYCAXab4KAu6tiSe5tjeRQcUuiuZawxK0mWhtwvx8
	 1PqqF5YiFASfQ9RpAqUEPoJo4qzLHwDUyCrdKsQ86BiMCy+3h1ZXFLLCXOTfeOVReI
	 6INwuviA9PFdQ==
Received: from [127.0.0.2] (localhost [::1])
	by odin.codewreck.org (OpenSMTPD) with ESMTP id fc1d14d5;
	Wed, 3 May 2023 07:49:37 +0000 (UTC)
From: Dominique Martinet <asmadeus@codewreck.org>
Date: Wed, 03 May 2023 16:49:25 +0900
Subject: [PATCH v2 1/5] 9p: fix ignored return value in v9fs_dir_release
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230427-scan-build-v2-1-bb96a6e6a33b@codewreck.org>
References: <20230427-scan-build-v2-0-bb96a6e6a33b@codewreck.org>
In-Reply-To: <20230427-scan-build-v2-0-bb96a6e6a33b@codewreck.org>
To: Eric Van Hensbergen <ericvh@gmail.com>, 
 Latchesar Ionkov <lucho@ionkov.net>, 
 Christian Schoenebeck <linux_oss@crudebyte.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <simon.horman@corigine.com>, v9fs@lists.linux.dev, 
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
 Dominique Martinet <asmadeus@codewreck.org>
X-Mailer: b4 0.13-dev-f371f
X-Developer-Signature: v=1; a=openpgp-sha256; l=1482;
 i=asmadeus@codewreck.org; h=from:subject:message-id;
 bh=0Kq8S/nnqbpqwe978W0kzTTDeACeZdS8gRGbd2pgoBE=;
 b=owEBbQKS/ZANAwAIAatOm+xqmOZwAcsmYgBkUhIRABowPIT/YRnhXuUjF/JKwf1Rhl8HnsZ3d
 RAj/XP3goqJAjMEAAEIAB0WIQT8g9txgG5a3TOhiE6rTpvsapjmcAUCZFISEQAKCRCrTpvsapjm
 cDqZD/9qztEcOW4BpCi02ViD151aL+3siB2XfsyF95CQjJMkFTzuDLB7SOA2U87gnE33YLj0LsD
 l8oB1n9tGObYUxQnpCbHe+VpuV17GKjjqufv/LVfBlEiY31zE9Me6NfEJEfuCk12yufD0ZXxn35
 dZuPv91FmF7nyAvnqOROvKR7R0FVuUEODkXWtpeExcOi2OxtxAkc8aSNiZKPTB+Q0cdQvq7XDGI
 4chlb83pSqstnJ1N4qWhco8lr8s+Wln3mb4BAhMYljrDiv0dKeiIPv94ARu2iFbzVpFBgG7kooW
 2dMWhyn7xqpRML/FlQZE+pQjzzTbjyBSMzqehmlKNR3AF2qyDcPNlzi757KAlgYVQXus+QqQDa0
 2Hl8fh+rLFNkbQ6cQB1BrwnMLi2p1lq0TttJ2DqUfSnFptxU0C8TGYINtGUCDd8TATWXd3kHGw8
 KXFGKvnce/arS9E0l2uB9y4DzXvHg5TK2bXrHiLWpWYX+e2WCMWgdZWbOC7LWHv0hExPuSAEnlJ
 EAxiApQezhQMY9fo4mB3Bdhq3RHFG2jusW4H9c2toT2qBnBV+ZccQAcinul9y1MHIgV6mwKhcoO
 Pw4NPf8VkmjYJTZ60RH9HZBIvqZPLWoc90hszRp/Aah4hOlWk4KN1rHXagWPzTLrMzj+dInSjiY
 T3mHOzvkCMwdZHQ==
X-Developer-Key: i=asmadeus@codewreck.org; a=openpgp;
 fpr=B894379F662089525B3FB1B9333F1F391BBBB00A

retval from filemap_fdatawrite was immediately overwritten by the
following p9_fid_put: preserve any error in fdatawrite if there
was any first.

This fixes the following scan-build warning:
fs/9p/vfs_dir.c:220:4: warning: Value stored to 'retval' is never read [deadcode.DeadStores]
                        retval = filemap_fdatawrite(inode->i_mapping);
                        ^        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Fixes: d9bc0d11e33b ("fs/9p: Consolidate file operations and add readahead and writeback")
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
---
 fs/9p/vfs_dir.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/9p/vfs_dir.c b/fs/9p/vfs_dir.c
index 289b58cb896e..54bb99f12390 100644
--- a/fs/9p/vfs_dir.c
+++ b/fs/9p/vfs_dir.c
@@ -209,7 +209,7 @@ int v9fs_dir_release(struct inode *inode, struct file *filp)
 	struct p9_fid *fid;
 	__le32 version;
 	loff_t i_size;
-	int retval = 0;
+	int retval = 0, put_err;
 
 	fid = filp->private_data;
 	p9_debug(P9_DEBUG_VFS, "inode: %p filp: %p fid: %d\n",
@@ -222,7 +222,8 @@ int v9fs_dir_release(struct inode *inode, struct file *filp)
 		spin_lock(&inode->i_lock);
 		hlist_del(&fid->ilist);
 		spin_unlock(&inode->i_lock);
-		retval = p9_fid_put(fid);
+		put_err = p9_fid_put(fid);
+		retval = retval < 0 ? retval : put_err;
 	}
 
 	if ((filp->f_mode & FMODE_WRITE)) {

-- 
2.39.2


