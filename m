Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA953DDD06
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 18:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbhHBQCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 12:02:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:58122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229792AbhHBQCe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 12:02:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73D79610FF;
        Mon,  2 Aug 2021 16:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627920144;
        bh=l+akjJ+8krD6JnE9932c7S0YGq1yRExifzXP5UNYj8w=;
        h=From:To:Cc:Subject:Date:From;
        b=Etkc0y/pPBgH+QfkmffjrqAq97Cs4IgEZ3LpAwSbQijQtooiS57GkNlHEh5GdALjg
         CptgybbUaeLA1evb2SrOVCScD84HLNSSXPn5oB7SCFYPNBp3ApjypjGiBpRMfouzkL
         UtWGoKgkk7xxXnWrIBiOJimEhtZOJ0W+ruRj87meOTq5DhVYQMbUa9LQQ/rPLTdHzu
         KN+F9vnTK1YbpGFuh7CM2Q6N+RsB7g6sZ0007OqnAis4XNzvlBrRBfpVAsz+G4wnYO
         4ufVTQXB/q6NZL2MW9UK8GbzcjDknznoiFio/GNBxTJ7S8d4xEiepdZwxPQhEO8TgP
         hVsXK52VCniog==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net
Cc:     ciorneiioana@gmail.com, David Ahern <dsahern@kernel.org>,
        Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH net-next] ipv4: Fix refcount warning for new fib_info
Date:   Mon,  2 Aug 2021 10:02:21 -0600
Message-Id: <20210802160221.27263-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ioana reported a refcount warning when booting over NFS:

[    5.042532] ------------[ cut here ]------------
[    5.047184] refcount_t: addition on 0; use-after-free.
[    5.052324] WARNING: CPU: 7 PID: 1 at lib/refcount.c:25 refcount_warn_saturate+0xa4/0x150
...
[    5.167201] Call trace:
[    5.169635]  refcount_warn_saturate+0xa4/0x150
[    5.174067]  fib_create_info+0xc00/0xc90
[    5.177982]  fib_table_insert+0x8c/0x620
[    5.181893]  fib_magic.isra.0+0x110/0x11c
[    5.185891]  fib_add_ifaddr+0xb8/0x190
[    5.189629]  fib_inetaddr_event+0x8c/0x140

fib_treeref needs to be set after kzalloc. The old code had a ++ which
led to the confusion when the int was replaced by a refcount_t.

Fixes: 79976892f7ea ("net: convert fib_treeref from int to refcount_t")
Signed-off-by: David Ahern <dsahern@kernel.org>
Reported-by: Ioana Ciornei <ciorneiioana@gmail.com>
Cc: Yajun Deng <yajun.deng@linux.dev>
---
 net/ipv4/fib_semantics.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index fa19f4cdf3a4..f29feb7772da 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -1551,7 +1551,7 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
 		return ofi;
 	}
 
-	refcount_inc(&fi->fib_treeref);
+	refcount_set(&fi->fib_treeref, 1);
 	refcount_set(&fi->fib_clntref, 1);
 	spin_lock_bh(&fib_info_lock);
 	hlist_add_head(&fi->fib_hash,
-- 
2.24.3 (Apple Git-128)

