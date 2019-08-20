Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5EDF96C52
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 00:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731141AbfHTWd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 18:33:29 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37010 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731033AbfHTWdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 18:33:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ioKlwlL0Fkrp5tdX1wXdEK4+mq9ypmkS0RhHRrBuboU=; b=TSaVjwZ50MwjJJPQygfu+J1nY/
        11HPYALV/tCoGfn3KxXGiAU/AnXOYhHFG9J8L6sb+Aj5RXGbXLEs9sj+1ebgmY1TS6MN3EU+tTQwg
        nlSJS1GBna1VCkYvRTjWwLVf+DDubKRNWi0pbYCLl94BbsaxcBbxWDspGf5w9J7XskczqT5es/gm1
        uk04+OtBGmlc4yhagVvCajTohNbrrq0wPSQnAVSXpk/28cTH+KmwvYNZT72pEHQVEEv8ZO/i4mcc6
        UqV6pxpCo14Thlj7zjk5gDrU9FsfETBAGixen2RoMHfzKayG5N0fSp4KuM+qXJcIZyuGxeEMjrbAM
        KjS2mxAQ==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i0CgZ-0005s2-2Z; Tue, 20 Aug 2019 22:33:03 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     netdev@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 26/38] cls_bpf: Convert handle_idr to XArray
Date:   Tue, 20 Aug 2019 15:32:47 -0700
Message-Id: <20190820223259.22348-27-willy@infradead.org>
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

Rename it to 'progs' as this is what's stored there.  The locking is
unchanged, so access to this XArray is protected by both the rtnl lock
and the XArray spinlock.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 net/sched/cls_bpf.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/net/sched/cls_bpf.c b/net/sched/cls_bpf.c
index 3f7a9c02b70c..9a794f557861 100644
--- a/net/sched/cls_bpf.c
+++ b/net/sched/cls_bpf.c
@@ -14,7 +14,7 @@
 #include <linux/skbuff.h>
 #include <linux/filter.h>
 #include <linux/bpf.h>
-#include <linux/idr.h>
+#include <linux/xarray.h>
 
 #include <net/rtnetlink.h>
 #include <net/pkt_cls.h>
@@ -30,7 +30,7 @@ MODULE_DESCRIPTION("TC BPF based classifier");
 
 struct cls_bpf_head {
 	struct list_head plist;
-	struct idr handle_idr;
+	struct xarray progs;
 	struct rcu_head rcu;
 };
 
@@ -242,7 +242,7 @@ static int cls_bpf_init(struct tcf_proto *tp)
 		return -ENOBUFS;
 
 	INIT_LIST_HEAD_RCU(&head->plist);
-	idr_init(&head->handle_idr);
+	xa_init_flags(&head->progs, XA_FLAGS_ALLOC1);
 	rcu_assign_pointer(tp->root, head);
 
 	return 0;
@@ -283,7 +283,7 @@ static void __cls_bpf_delete(struct tcf_proto *tp, struct cls_bpf_prog *prog,
 {
 	struct cls_bpf_head *head = rtnl_dereference(tp->root);
 
-	idr_remove(&head->handle_idr, prog->handle);
+	xa_erase(&head->progs, prog->handle);
 	cls_bpf_stop_offload(tp, prog, extack);
 	list_del_rcu(&prog->link);
 	tcf_unbind_filter(tp, &prog->res);
@@ -312,7 +312,7 @@ static void cls_bpf_destroy(struct tcf_proto *tp, bool rtnl_held,
 	list_for_each_entry_safe(prog, tmp, &head->plist, link)
 		__cls_bpf_delete(tp, prog, extack);
 
-	idr_destroy(&head->handle_idr);
+	xa_destroy(&head->progs);
 	kfree_rcu(head, rcu);
 }
 
@@ -484,23 +484,21 @@ static int cls_bpf_change(struct net *net, struct sk_buff *in_skb,
 		}
 	}
 
+	prog->handle = handle;
 	if (handle == 0) {
-		handle = 1;
-		ret = idr_alloc_u32(&head->handle_idr, prog, &handle,
-				    INT_MAX, GFP_KERNEL);
+		ret = xa_alloc(&head->progs, &prog->handle, prog, xa_limit_31b,
+				GFP_KERNEL);
 	} else if (!oldprog) {
-		ret = idr_alloc_u32(&head->handle_idr, prog, &handle,
-				    handle, GFP_KERNEL);
+		ret = xa_insert(&head->progs, handle, prog, GFP_KERNEL);
 	}
 
 	if (ret)
 		goto errout;
-	prog->handle = handle;
 
 	ret = cls_bpf_set_parms(net, tp, prog, base, tb, tca[TCA_RATE], ovr,
 				extack);
 	if (ret < 0)
-		goto errout_idr;
+		goto errout_prog;
 
 	ret = cls_bpf_offload(tp, prog, oldprog, extack);
 	if (ret)
@@ -510,7 +508,7 @@ static int cls_bpf_change(struct net *net, struct sk_buff *in_skb,
 		prog->gen_flags |= TCA_CLS_FLAGS_NOT_IN_HW;
 
 	if (oldprog) {
-		idr_replace(&head->handle_idr, prog, handle);
+		xa_store(&head->progs, handle, prog, 0);
 		list_replace_rcu(&oldprog->link, &prog->link);
 		tcf_unbind_filter(tp, &oldprog->res);
 		tcf_exts_get_net(&oldprog->exts);
@@ -524,9 +522,9 @@ static int cls_bpf_change(struct net *net, struct sk_buff *in_skb,
 
 errout_parms:
 	cls_bpf_free_parms(prog);
-errout_idr:
+errout_prog:
 	if (!oldprog)
-		idr_remove(&head->handle_idr, prog->handle);
+		xa_erase(&head->progs, prog->handle);
 errout:
 	tcf_exts_destroy(&prog->exts);
 	kfree(prog);
-- 
2.23.0.rc1

