Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB73C96C58
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 00:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731160AbfHTWdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 18:33:35 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37014 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731043AbfHTWdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 18:33:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=6a2tD7DIilf7AYFLI2WX9DEIZxQUUKdBQ7/PCwcAvSs=; b=IJ0TwFhFdenIR72U0rlao6e6Uk
        znLYckV+9RyC401eWA6AWize81J+zClhruLs/PFKzk+rlURT29nSH5CeDPZT5RQ/IKvGPDCLtPeSt
        fUkNNcKB/rwnACiFdOGcIfCbD4eK5kjkQCmpq1O0Ny//apDqI0NvFOXQOaQ+xaaDM1EEeI6kuaRIw
        HvDFWN5Fs267zoSQpYhgx46T0Wusz7xAjiljDunpBNLOg7NkvlH/ACcyqidA8B346TDQ4hx4n+97x
        e5igubMOmP6vAMAF20nwGPa6nhTIHmrlsC2zRi3CWztYUmad3PlMc58+mP2QwxxcFu5PD8olaKrin
        YISUHYjA==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i0CgZ-0005sE-5a; Tue, 20 Aug 2019 22:33:03 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     netdev@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 28/38] cls_bpf: Use XArray marks to accelerate re-offload
Date:   Tue, 20 Aug 2019 15:32:49 -0700
Message-Id: <20190820223259.22348-29-willy@infradead.org>
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

Propagate the skip_hw flag from the cls_bpf_prog structure into one of
the XArray mark bits which lets us skip examining the unwanted programs.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 net/sched/cls_bpf.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/sched/cls_bpf.c b/net/sched/cls_bpf.c
index 295baabdc683..4dcab41b25b5 100644
--- a/net/sched/cls_bpf.c
+++ b/net/sched/cls_bpf.c
@@ -33,6 +33,8 @@ struct cls_bpf_head {
 	struct rcu_head rcu;
 };
 
+#define HW_FILTER	XA_MARK_1
+
 struct cls_bpf_prog {
 	struct bpf_prog *filter;
 	struct tcf_result res;
@@ -505,6 +507,11 @@ static int cls_bpf_change(struct net *net, struct sk_buff *in_skb,
 		tcf_queue_work(&oldprog->rwork, cls_bpf_delete_prog_work);
 	}
 
+	if (!tc_skip_hw(prog->gen_flags))
+		xa_set_mark(&head->progs, prog->handle, HW_FILTER);
+	else if (oldprog)
+		xa_clear_mark(&head->progs, prog->handle, HW_FILTER);
+
 	*arg = prog;
 	return 0;
 
@@ -648,10 +655,7 @@ static int cls_bpf_reoffload(struct tcf_proto *tp, bool add, flow_setup_cb_t *cb
 	unsigned long handle;
 	int err;
 
-	xa_for_each(&head->progs, handle, prog) {
-		if (tc_skip_hw(prog->gen_flags))
-			continue;
-
+	xa_for_each_marked(&head->progs, handle, prog, HW_FILTER) {
 		tc_cls_common_offload_init(&cls_bpf.common, tp, prog->gen_flags,
 					   extack);
 		cls_bpf.command = TC_CLSBPF_OFFLOAD;
-- 
2.23.0.rc1

