Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E89027B0E1
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 17:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgI1PZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 11:25:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:53074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726551AbgI1PZP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 11:25:15 -0400
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7106721548;
        Mon, 28 Sep 2020 15:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601306714;
        bh=Y5Ub2xv8hNZsIQy3oWS45CA0uMtcTCWQi4O+rzdpU6U=;
        h=Date:From:To:Cc:Subject:From;
        b=tfT/+hlnhE7JaNttiS8A6Uoocg4ekcP9vFIU/yj+HwgAspZ/plPOQrGW3/h7rMOPC
         ucJ8Vd1R2ptvavkLt+O81tLm0W9vnchjmj5DfwI3pR4u2ZDWJQaU74p8m/oMZJ29q1
         W5ShXaOTYRSGN5SDMgKnJCSekEmjp+kNIXK8gqxQ=
Date:   Mon, 28 Sep 2020 10:30:52 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH][next] net/sched: cls_u32: Replace one-element array with
 flexible-array member
Message-ID: <20200928153052.GA17317@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a regular need in the kernel to provide a way to declare having
a dynamically sized set of trailing elements in a structure. Kernel code
should always use “flexible array members”[1] for these cases. The older
style of one-element or zero-length arrays should no longer be used[2].

Refactor the code according to the use of a flexible-array member in
struct tc_u_hnode and use the struct_size() helper to calculate the
size for the allocations. Commit 5778d39d070b ("net_sched: fix struct
tc_u_hnode layout in u32") makes it clear that the code is expected to
dynamically allocate divisor + 1 entries for ->ht[] in tc_uhnode. Also,
based on other observations, as the piece of code below:

1232                 for (h = 0; h <= ht->divisor; h++) {
1233                         for (n = rtnl_dereference(ht->ht[h]);
1234                              n;
1235                              n = rtnl_dereference(n->next)) {
1236                                 if (tc_skip_hw(n->flags))
1237                                         continue;
1238
1239                                 err = u32_reoffload_knode(tp, n, add, cb,
1240                                                           cb_priv, extack);
1241                                 if (err)
1242                                         return err;
1243                         }
1244                 }

we can assume that, in general, the code is actually expecting to allocate
that extra space for the one-element array in tc_uhnode, everytime it
allocates memory for instances of tc_uhnode or tc_u_common structures.
That's the reason for passing '1' as the last argument for struct_size()
in the allocation for _root_ht_ and _tp_c_, and 'divisor + 1' in the
allocation code for _ht_.

[1] https://en.wikipedia.org/wiki/Flexible_array_member
[2] https://www.kernel.org/doc/html/v5.9-rc1/process/deprecated.html#zero-length-and-one-element-arrays

Tested-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/lkml/5f7062af.z3T9tn9yIPv6h5Ny%25lkp@intel.com/
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 net/sched/cls_u32.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index 7b69ab1993ba..54209a18d7fe 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -79,7 +79,7 @@ struct tc_u_hnode {
 	/* The 'ht' field MUST be the last field in structure to allow for
 	 * more entries allocated at end of structure.
 	 */
-	struct tc_u_knode __rcu	*ht[1];
+	struct tc_u_knode __rcu	*ht[];
 };
 
 struct tc_u_common {
@@ -353,7 +353,7 @@ static int u32_init(struct tcf_proto *tp)
 	void *key = tc_u_common_ptr(tp);
 	struct tc_u_common *tp_c = tc_u_common_find(key);
 
-	root_ht = kzalloc(sizeof(*root_ht), GFP_KERNEL);
+	root_ht = kzalloc(struct_size(root_ht, ht, 1), GFP_KERNEL);
 	if (root_ht == NULL)
 		return -ENOBUFS;
 
@@ -364,7 +364,7 @@ static int u32_init(struct tcf_proto *tp)
 	idr_init(&root_ht->handle_idr);
 
 	if (tp_c == NULL) {
-		tp_c = kzalloc(sizeof(*tp_c), GFP_KERNEL);
+		tp_c = kzalloc(struct_size(tp_c, hlist->ht, 1), GFP_KERNEL);
 		if (tp_c == NULL) {
 			kfree(root_ht);
 			return -ENOBUFS;
@@ -933,7 +933,7 @@ static int u32_change(struct net *net, struct sk_buff *in_skb,
 			NL_SET_ERR_MSG_MOD(extack, "Divisor can only be used on a hash table");
 			return -EINVAL;
 		}
-		ht = kzalloc(sizeof(*ht) + divisor*sizeof(void *), GFP_KERNEL);
+		ht = kzalloc(struct_size(ht, ht, divisor + 1), GFP_KERNEL);
 		if (ht == NULL)
 			return -ENOBUFS;
 		if (handle == 0) {
-- 
2.27.0

