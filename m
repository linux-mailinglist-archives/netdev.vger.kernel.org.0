Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B97FD96C43
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 00:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731089AbfHTWdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 18:33:06 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37004 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731030AbfHTWdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 18:33:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=UEhLKkpgNH4KlH3PQrZsT7mf6194XuRDSRS50YMqg4s=; b=F/NoS4Q1PNdYd5f22AJfrkaupf
        tMh07YSXKcksyWRd4pzVm/3/xGI0ZbUjVR8Yuk7DKy71o52u3LBxEgNnUGU6aZBg7jHAR0nkwup83
        Zh4EuECGIXJyyDOAUXIzp3LbhexmseS/EtyB6EZFk7CYLgPXA1H6mQr5KVpERpG/Po3CQtQD2WT+J
        7tnp8EeLuebIwFanWDhwyLpxIB3ZOzmTsvGNfXzzd+vU2j3V7HG+gV0/4jQoUmox/hjIp4/EKGPgO
        KDOuxB5G9lE5cFOhjqqKOBMv2TNVEKdU+dkg6x4yiZ1QyGzqQcIDvNV5yR9lE7AZWRAPddTX/4mj1
        gujQg7NQ==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i0CgY-0005rj-Tm; Tue, 20 Aug 2019 22:33:02 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     netdev@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 23/38] cls_api: Convert tcf_net to XArray
Date:   Tue, 20 Aug 2019 15:32:44 -0700
Message-Id: <20190820223259.22348-24-willy@infradead.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190820223259.22348-1-willy@infradead.org>
References: <20190820223259.22348-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

This module doesn't use the allocating functionality; convert it to a
plain XArray instead of an allocating one.  I've left struct tcf_net
in place in case more objects are added to it in future, although
it now only contains an XArray.  We don't need to call xa_destroy()
if the array is empty, so I've removed the contents of tcf_net_exit()
-- if it can be called with entries still in place, then it shoud call
xa_destroy() instead.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 net/sched/cls_api.c | 27 ++++++---------------------
 1 file changed, 6 insertions(+), 21 deletions(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index e0d8b456e9f5..8392a7ef0ed4 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -19,7 +19,7 @@
 #include <linux/init.h>
 #include <linux/kmod.h>
 #include <linux/slab.h>
-#include <linux/idr.h>
+#include <linux/xarray.h>
 #include <linux/rhashtable.h>
 #include <net/net_namespace.h>
 #include <net/sock.h>
@@ -777,8 +777,7 @@ tcf_chain0_head_change_cb_del(struct tcf_block *block,
 }
 
 struct tcf_net {
-	spinlock_t idr_lock; /* Protects idr */
-	struct idr idr;
+	struct xarray blocks;
 };
 
 static unsigned int tcf_net_id;
@@ -787,25 +786,15 @@ static int tcf_block_insert(struct tcf_block *block, struct net *net,
 			    struct netlink_ext_ack *extack)
 {
 	struct tcf_net *tn = net_generic(net, tcf_net_id);
-	int err;
-
-	idr_preload(GFP_KERNEL);
-	spin_lock(&tn->idr_lock);
-	err = idr_alloc_u32(&tn->idr, block, &block->index, block->index,
-			    GFP_NOWAIT);
-	spin_unlock(&tn->idr_lock);
-	idr_preload_end();
 
-	return err;
+	return xa_insert(&tn->blocks, block->index, block, GFP_KERNEL);
 }
 
 static void tcf_block_remove(struct tcf_block *block, struct net *net)
 {
 	struct tcf_net *tn = net_generic(net, tcf_net_id);
 
-	spin_lock(&tn->idr_lock);
-	idr_remove(&tn->idr, block->index);
-	spin_unlock(&tn->idr_lock);
+	xa_erase(&tn->blocks, block->index);
 }
 
 static struct tcf_block *tcf_block_create(struct net *net, struct Qdisc *q,
@@ -839,7 +828,7 @@ static struct tcf_block *tcf_block_lookup(struct net *net, u32 block_index)
 {
 	struct tcf_net *tn = net_generic(net, tcf_net_id);
 
-	return idr_find(&tn->idr, block_index);
+	return xa_load(&tn->blocks, block_index);
 }
 
 static struct tcf_block *tcf_block_refcnt_get(struct net *net, u32 block_index)
@@ -3164,16 +3153,12 @@ static __net_init int tcf_net_init(struct net *net)
 {
 	struct tcf_net *tn = net_generic(net, tcf_net_id);
 
-	spin_lock_init(&tn->idr_lock);
-	idr_init(&tn->idr);
+	xa_init(&tn->blocks);
 	return 0;
 }
 
 static void __net_exit tcf_net_exit(struct net *net)
 {
-	struct tcf_net *tn = net_generic(net, tcf_net_id);
-
-	idr_destroy(&tn->idr);
 }
 
 static struct pernet_operations tcf_net_ops = {
-- 
2.23.0.rc1

