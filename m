Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D53D96C57
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 00:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731147AbfHTWda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 18:33:30 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37012 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731037AbfHTWdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 18:33:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=sHuOTj6qRq5wn9jrT09ZSXvKOfU9IbBW913FBxatEZM=; b=R9h8E/BkQDGiBlsQWSBwWOEphM
        RVqBq5FOtkzFxScLv4EgLCFDyApHvVd1GJ+sHyAeiVML9eO+VqcFh1gaK8+QGwpkpWqxb4ThzVjW4
        m5V2SXdmxr+q78nZEjwX1YzqXA9lMt2qoOFIvP7fY+HyyJTFmJt8qBpGigczKtFhtuUQMfKbRtb1O
        uDqMj9aKUzv3xRlQepgcl1H49pp0D/YQuFqjRFcRFEdMjHH00VaDDHb92efbjYBWiTaa6PDHnalj8
        jrjHZxog2SU2PM8erRVVbVqhk7eNC5fzMmv8EeZSh6Zya9qrkkzh1jBuaIGtPSSx6Ap4Ir77g6NDc
        Pzx7V7/g==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i0CgZ-0005s8-4E; Tue, 20 Aug 2019 22:33:03 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     netdev@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 27/38] cls_bpf: Remove list of programs
Date:   Tue, 20 Aug 2019 15:32:48 -0700
Message-Id: <20190820223259.22348-28-willy@infradead.org>
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

Use the XArray for all this functionality.  Saves two pointers per
program and it's faster to iterate over an XArray than a linked list.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 net/sched/cls_bpf.c | 38 ++++++++++++++------------------------
 1 file changed, 14 insertions(+), 24 deletions(-)

diff --git a/net/sched/cls_bpf.c b/net/sched/cls_bpf.c
index 9a794f557861..295baabdc683 100644
--- a/net/sched/cls_bpf.c
+++ b/net/sched/cls_bpf.c
@@ -29,14 +29,12 @@ MODULE_DESCRIPTION("TC BPF based classifier");
 	(TCA_CLS_FLAGS_SKIP_HW | TCA_CLS_FLAGS_SKIP_SW)
 
 struct cls_bpf_head {
-	struct list_head plist;
 	struct xarray progs;
 	struct rcu_head rcu;
 };
 
 struct cls_bpf_prog {
 	struct bpf_prog *filter;
-	struct list_head link;
 	struct tcf_result res;
 	bool exts_integrated;
 	u32 gen_flags;
@@ -81,13 +79,14 @@ static int cls_bpf_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 			    struct tcf_result *res)
 {
 	struct cls_bpf_head *head = rcu_dereference_bh(tp->root);
+	XA_STATE(xas, &head->progs, 0);
 	bool at_ingress = skb_at_tc_ingress(skb);
 	struct cls_bpf_prog *prog;
 	int ret = -1;
 
 	/* Needed here for accessing maps. */
 	rcu_read_lock();
-	list_for_each_entry_rcu(prog, &head->plist, link) {
+	xas_for_each(&xas, prog, ULONG_MAX) {
 		int filter_res;
 
 		qdisc_skb_cb(skb)->tc_classid = prog->res.classid;
@@ -241,7 +240,6 @@ static int cls_bpf_init(struct tcf_proto *tp)
 	if (head == NULL)
 		return -ENOBUFS;
 
-	INIT_LIST_HEAD_RCU(&head->plist);
 	xa_init_flags(&head->progs, XA_FLAGS_ALLOC1);
 	rcu_assign_pointer(tp->root, head);
 
@@ -285,7 +283,6 @@ static void __cls_bpf_delete(struct tcf_proto *tp, struct cls_bpf_prog *prog,
 
 	xa_erase(&head->progs, prog->handle);
 	cls_bpf_stop_offload(tp, prog, extack);
-	list_del_rcu(&prog->link);
 	tcf_unbind_filter(tp, &prog->res);
 	if (tcf_exts_get_net(&prog->exts))
 		tcf_queue_work(&prog->rwork, cls_bpf_delete_prog_work);
@@ -299,7 +296,7 @@ static int cls_bpf_delete(struct tcf_proto *tp, void *arg, bool *last,
 	struct cls_bpf_head *head = rtnl_dereference(tp->root);
 
 	__cls_bpf_delete(tp, arg, extack);
-	*last = list_empty(&head->plist);
+	*last = xa_empty(&head->progs);
 	return 0;
 }
 
@@ -307,26 +304,20 @@ static void cls_bpf_destroy(struct tcf_proto *tp, bool rtnl_held,
 			    struct netlink_ext_ack *extack)
 {
 	struct cls_bpf_head *head = rtnl_dereference(tp->root);
-	struct cls_bpf_prog *prog, *tmp;
+	struct cls_bpf_prog *prog;
+	unsigned long handle;
 
-	list_for_each_entry_safe(prog, tmp, &head->plist, link)
+	xa_for_each(&head->progs, handle, prog)
 		__cls_bpf_delete(tp, prog, extack);
 
-	xa_destroy(&head->progs);
 	kfree_rcu(head, rcu);
 }
 
 static void *cls_bpf_get(struct tcf_proto *tp, u32 handle)
 {
 	struct cls_bpf_head *head = rtnl_dereference(tp->root);
-	struct cls_bpf_prog *prog;
 
-	list_for_each_entry(prog, &head->plist, link) {
-		if (prog->handle == handle)
-			return prog;
-	}
-
-	return NULL;
+	return xa_load(&head->progs, handle);
 }
 
 static int cls_bpf_prog_from_ops(struct nlattr **tb, struct cls_bpf_prog *prog)
@@ -509,12 +500,9 @@ static int cls_bpf_change(struct net *net, struct sk_buff *in_skb,
 
 	if (oldprog) {
 		xa_store(&head->progs, handle, prog, 0);
-		list_replace_rcu(&oldprog->link, &prog->link);
 		tcf_unbind_filter(tp, &oldprog->res);
 		tcf_exts_get_net(&oldprog->exts);
 		tcf_queue_work(&oldprog->rwork, cls_bpf_delete_prog_work);
-	} else {
-		list_add_rcu(&prog->link, &head->plist);
 	}
 
 	*arg = prog;
@@ -636,15 +624,16 @@ static void cls_bpf_walk(struct tcf_proto *tp, struct tcf_walker *arg,
 {
 	struct cls_bpf_head *head = rtnl_dereference(tp->root);
 	struct cls_bpf_prog *prog;
+	unsigned long handle;
+
+	arg->count = arg->skip;
 
-	list_for_each_entry(prog, &head->plist, link) {
-		if (arg->count < arg->skip)
-			goto skip;
+	xa_for_each_start(&head->progs, handle, prog, arg->cookie) {
 		if (arg->fn(tp, prog, arg) < 0) {
 			arg->stop = 1;
 			break;
 		}
-skip:
+		arg->cookie = handle + 1;
 		arg->count++;
 	}
 }
@@ -656,9 +645,10 @@ static int cls_bpf_reoffload(struct tcf_proto *tp, bool add, flow_setup_cb_t *cb
 	struct tcf_block *block = tp->chain->block;
 	struct tc_cls_bpf_offload cls_bpf = {};
 	struct cls_bpf_prog *prog;
+	unsigned long handle;
 	int err;
 
-	list_for_each_entry(prog, &head->plist, link) {
+	xa_for_each(&head->progs, handle, prog) {
 		if (tc_skip_hw(prog->gen_flags))
 			continue;
 
-- 
2.23.0.rc1

