Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27F7E1C4F13
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 09:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728341AbgEEH32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 03:29:28 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:51258 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725320AbgEEH31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 03:29:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1588663766; x=1620199766;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=Dy5GnfEjGnJjJR9G7/r4lahXKQYYs/PILtEzR0YenFs=;
  b=p8d81vvPmILMDDDJWCeejpWnszuZBZKj8XUapdaD6vHEaFb3Udl1yATM
   PMZrV2eZ2PvhRUPQmrYBLdRIQCQAx6utEdKLBVqzE935X0U71AwTRjAMU
   ashB/SdHMTHqjfYgcV5KB3If/QWcJdJaeUA4vR/hdvdK7unOgVcjvbtwR
   Q=;
IronPort-SDR: wiFJuqrdmzV+svAi58Tshev5UQb3eCtzreDDcALkcPEXaMHn2+5Rw/TWukgwUi9CXW1XE0Ztou
 tYxNj/pStu2Q==
X-IronPort-AV: E=Sophos;i="5.73,354,1583193600"; 
   d="scan'208";a="28646179"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 05 May 2020 07:29:13 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com (Postfix) with ESMTPS id 8B250C5D95;
        Tue,  5 May 2020 07:29:12 +0000 (UTC)
Received: from EX13D31EUA001.ant.amazon.com (10.43.165.15) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 5 May 2020 07:29:11 +0000
Received: from u886c93fd17d25d.ant.amazon.com (10.43.160.180) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 5 May 2020 07:29:07 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     <davem@davemloft.net>
CC:     <viro@zeniv.linux.org.uk>, <kuba@kernel.org>,
        <gregkh@linuxfoundation.org>, <edumazet@google.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        SeongJae Park <sjpark@amazon.de>
Subject: [PATCH net 2/2] Revert "sockfs: switch to ->free_inode()"
Date:   Tue, 5 May 2020 09:28:41 +0200
Message-ID: <20200505072841.25365-3-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200505072841.25365-1-sjpark@amazon.com>
References: <20200505072841.25365-1-sjpark@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.180]
X-ClientProxiedBy: EX13D20UWC003.ant.amazon.com (10.43.162.18) To
 EX13D31EUA001.ant.amazon.com (10.43.165.15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: SeongJae Park <sjpark@amazon.de>

This reverts commit 6d7855c54e1e269275d7c504f8f62a0b7a5b3f18.

The commit 6d7855c54e1e ("sockfs: switch to ->free_inode()") made the
deallocation of 'socket_alloc' to be done asynchronously using RCU, as
same to 'sock.wq'.

The change made 'socket_alloc' live longer than before.  As a result,
user programs intensively repeating allocations and deallocations of
sockets could cause memory pressure on recent kernels.

To avoid the problem, this commit reverts the change.
---
 net/socket.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/socket.c b/net/socket.c
index e274ae4b45e4..27174021f47f 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -273,12 +273,12 @@ static struct inode *sock_alloc_inode(struct super_block *sb)
 	return &ei->vfs_inode;
 }
 
-static void sock_free_inode(struct inode *inode)
+static void sock_destroy_inode(struct inode *inode)
 {
 	struct socket_alloc *ei;
 
 	ei = container_of(inode, struct socket_alloc, vfs_inode);
-	kfree(ei->socket.wq);
+	kfree_rcu(ei->socket.wq, rcu);
 	kmem_cache_free(sock_inode_cachep, ei);
 }
 
@@ -303,7 +303,7 @@ static void init_inodecache(void)
 
 static const struct super_operations sockfs_ops = {
 	.alloc_inode	= sock_alloc_inode,
-	.free_inode	= sock_free_inode,
+	.destroy_inode	= sock_destroy_inode,
 	.statfs		= simple_statfs,
 };
 
-- 
2.17.1

