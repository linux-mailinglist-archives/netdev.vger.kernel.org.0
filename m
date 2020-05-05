Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10B381C4FEF
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 10:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728549AbgEEILe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 04:11:34 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:1847 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726568AbgEEIL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 04:11:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1588666290; x=1620202290;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=l/C3b9DCnuqlbf12vX7TbBNdmk3bR5sHrCa2DPOGmdI=;
  b=ABosggn8sdi88sjhuPpyMo8Pn/k2chAOxUv1zxknW/0azjfNlXqc78Mu
   vEiSDC16QdM4iWrdGg3WxM5wiaChoW5ZDhVU+Ofm5SvST+ShMXtMF0DMz
   z8mAmhqSm2hwrH6BsaJzkXCrSdhQt8U5JH79JAzWeSNaDn8gADWyBrB1x
   o=;
IronPort-SDR: Q0fnFkKi3rRl3HOVQyIb+jpegaGV3s/ezIwGaBW9LEjXF7XnBEthihR+MnjZSVL7Kb328TM0I2
 Yt+ssf1Zu6bQ==
X-IronPort-AV: E=Sophos;i="5.73,354,1583193600"; 
   d="scan'208";a="30084469"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 05 May 2020 08:11:29 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com (Postfix) with ESMTPS id 5C2E6A1EE8;
        Tue,  5 May 2020 08:11:28 +0000 (UTC)
Received: from EX13D31EUA001.ant.amazon.com (10.43.165.15) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 5 May 2020 08:11:27 +0000
Received: from u886c93fd17d25d.ant.amazon.com (10.43.160.92) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 5 May 2020 08:11:23 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     <davem@davemloft.net>
CC:     <viro@zeniv.linux.org.uk>, <kuba@kernel.org>,
        <gregkh@linuxfoundation.org>, <edumazet@google.com>,
        <sj38.park@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, SeongJae Park <sjpark@amazon.de>
Subject: [PATCH net v2 2/2] Revert "sockfs: switch to ->free_inode()"
Date:   Tue, 5 May 2020 10:10:35 +0200
Message-ID: <20200505081035.7436-3-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200505081035.7436-1-sjpark@amazon.com>
References: <20200505081035.7436-1-sjpark@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.92]
X-ClientProxiedBy: EX13P01UWA003.ant.amazon.com (10.43.160.197) To
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

Fixes: 6d7855c54e1e ("sockfs: switch to ->free_inode()")
Fixes: 333f7909a857 ("coallocate socket_sq with socket itself")
Signed-off-by: SeongJae Park <sjpark@amazon.de>
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

