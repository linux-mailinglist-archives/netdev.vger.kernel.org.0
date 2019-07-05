Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E52B860BB8
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 21:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727350AbfGETNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 15:13:25 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44290 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbfGETNZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 15:13:25 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hjTe6-0000z1-OE; Fri, 05 Jul 2019 19:13:22 +0000
Date:   Fri, 5 Jul 2019 20:13:22 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: [PATCH] sockfs: switch to ->free_inode()
Message-ID: <20190705191322.GK17978@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

we do have an RCU-delayed part there already (freeing the wq),
so it's not like the pipe situation; moreover, it might be
worth considering coallocating wq with the rest of struct sock_alloc.
->sk_wq in struct sock would remain a pointer as it is, but
the object it normally points to would be coallocated with
struct socket...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 net/socket.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/socket.c b/net/socket.c
index d97b74f762e8..541719a2443d 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -258,12 +258,12 @@ static struct inode *sock_alloc_inode(struct super_block *sb)
 	return &ei->vfs_inode;
 }
 
-static void sock_destroy_inode(struct inode *inode)
+static void sock_free_inode(struct inode *inode)
 {
 	struct socket_alloc *ei;
 
 	ei = container_of(inode, struct socket_alloc, vfs_inode);
-	kfree_rcu(ei->socket.wq, rcu);
+	kfree(ei->socket.wq);
 	kmem_cache_free(sock_inode_cachep, ei);
 }
 
@@ -288,7 +288,7 @@ static void init_inodecache(void)
 
 static const struct super_operations sockfs_ops = {
 	.alloc_inode	= sock_alloc_inode,
-	.destroy_inode	= sock_destroy_inode,
+	.free_inode	= sock_free_inode,
 	.statfs		= simple_statfs,
 };
 
-- 
2.11.0

