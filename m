Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF9B5CDDD
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 12:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbfGBKts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 06:49:48 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:42196 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725767AbfGBKts (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 06:49:48 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hiGM5-00046J-4i; Tue, 02 Jul 2019 12:49:45 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com,
        Florian Westphal <fw@strlen.de>,
        syzbot+0165480d4ef07360eeda@syzkaller.appspotmail.com
Subject: [PATCH ipsec] xfrm: policy: fix bydst hlist corruption on hash rebuild
Date:   Tue,  2 Jul 2019 12:46:00 +0200
Message-Id: <20190702104600.9744-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <000000000000db481c058c462e4c@google.com>
References: <000000000000db481c058c462e4c@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot reported following spat:

BUG: KASAN: use-after-free in __write_once_size include/linux/compiler.h:221
BUG: KASAN: use-after-free in hlist_del_rcu include/linux/rculist.h:455
BUG: KASAN: use-after-free in xfrm_hash_rebuild+0xa0d/0x1000 net/xfrm/xfrm_policy.c:1318
Write of size 8 at addr ffff888095e79c00 by task kworker/1:3/8066
Workqueue: events xfrm_hash_rebuild
Call Trace:
 __write_once_size include/linux/compiler.h:221 [inline]
 hlist_del_rcu include/linux/rculist.h:455 [inline]
 xfrm_hash_rebuild+0xa0d/0x1000 net/xfrm/xfrm_policy.c:1318
 process_one_work+0x814/0x1130 kernel/workqueue.c:2269
Allocated by task 8064:
 __kmalloc+0x23c/0x310 mm/slab.c:3669
 kzalloc include/linux/slab.h:742 [inline]
 xfrm_hash_alloc+0x38/0xe0 net/xfrm/xfrm_hash.c:21
 xfrm_policy_init net/xfrm/xfrm_policy.c:4036 [inline]
 xfrm_net_init+0x269/0xd60 net/xfrm/xfrm_policy.c:4120
 ops_init+0x336/0x420 net/core/net_namespace.c:130
 setup_net+0x212/0x690 net/core/net_namespace.c:316

The faulting address is the address of the old chain head,
free'd by xfrm_hash_resize().

In xfrm_hash_rehash(), chain heads get re-initialized without
any hlist_del_rcu:

 for (i = hmask; i >= 0; i--)
    INIT_HLIST_HEAD(odst + i);

Then, hlist_del_rcu() gets called on the about to-be-reinserted policy
when iterating the per-net list of policies.

hlist_del_rcu() will then make chain->first be nonzero again:

static inline void __hlist_del(struct hlist_node *n)
{
   struct hlist_node *next = n->next;   // address of next element in list
   struct hlist_node **pprev = n->pprev;// location of previous elem, this
                                        // can point at chain->first
        WRITE_ONCE(*pprev, next);       // chain->first points to next elem
        if (next)
                next->pprev = pprev;

Then, when we walk chainlist to find insertion point, we may find a
non-empty list even though we're supposedly reinserting the first
policy to an empty chain.

To fix this first unlink all exact and inexact policies instead of
zeroing the list heads.

Add the commands equivalent to the syzbot reproducer to xfrm_policy.sh,
without fix KASAN catches the corruption as it happens, SLUB poisoning
detects it a bit later.

Reported-by: syzbot+0165480d4ef07360eeda@syzkaller.appspotmail.com
Fixes: 1548bc4e0512 ("xfrm: policy: delete inexact policies from inexact list on hash rebuild")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/xfrm/xfrm_policy.c                     | 12 ++++++----
 tools/testing/selftests/net/xfrm_policy.sh | 27 +++++++++++++++++++++-
 2 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index b1694d5d15d3..82be7780bbe8 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -1280,13 +1280,17 @@ static void xfrm_hash_rebuild(struct work_struct *work)
 
 		hlist_for_each_entry_safe(policy, n,
 					  &net->xfrm.policy_inexact[dir],
-					  bydst_inexact_list)
+					  bydst_inexact_list) {
+			hlist_del_rcu(&policy->bydst);
 			hlist_del_init(&policy->bydst_inexact_list);
+		}
 
 		hmask = net->xfrm.policy_bydst[dir].hmask;
 		odst = net->xfrm.policy_bydst[dir].table;
-		for (i = hmask; i >= 0; i--)
-			INIT_HLIST_HEAD(odst + i);
+		for (i = hmask; i >= 0; i--) {
+			hlist_for_each_entry_safe(policy, n, odst + i, bydst)
+				hlist_del_rcu(&policy->bydst);
+		}
 		if ((dir & XFRM_POLICY_MASK) == XFRM_POLICY_OUT) {
 			/* dir out => dst = remote, src = local */
 			net->xfrm.policy_bydst[dir].dbits4 = rbits4;
@@ -1315,8 +1319,6 @@ static void xfrm_hash_rebuild(struct work_struct *work)
 		chain = policy_hash_bysel(net, &policy->selector,
 					  policy->family, dir);
 
-		hlist_del_rcu(&policy->bydst);
-
 		if (!chain) {
 			void *p = xfrm_policy_inexact_insert(policy, dir, 0);
 
diff --git a/tools/testing/selftests/net/xfrm_policy.sh b/tools/testing/selftests/net/xfrm_policy.sh
index 71d7fdc513c1..5445943bf07f 100755
--- a/tools/testing/selftests/net/xfrm_policy.sh
+++ b/tools/testing/selftests/net/xfrm_policy.sh
@@ -257,6 +257,29 @@ check_exceptions()
 	return $lret
 }
 
+check_hthresh_repeat()
+{
+	local log=$1
+	i=0
+
+	for i in $(seq 1 10);do
+		ip -net ns1 xfrm policy update src e000:0001::0000 dst ff01::0014:0000:0001 dir in tmpl src :: dst :: proto esp mode tunnel priority 100 action allow || break
+		ip -net ns1 xfrm policy set hthresh6 0 28 || break
+
+		ip -net ns1 xfrm policy update src e000:0001::0000 dst ff01::01 dir in tmpl src :: dst :: proto esp mode tunnel priority 100 action allow || break
+		ip -net ns1 xfrm policy set hthresh6 0 28 || break
+	done
+
+	if [ $i -ne 10 ] ;then
+		echo "FAIL: $log" 1>&2
+		ret=1
+		return 1
+	fi
+
+	echo "PASS: $log"
+	return 0
+}
+
 #check for needed privileges
 if [ "$(id -u)" -ne 0 ];then
 	echo "SKIP: Need root privileges"
@@ -404,7 +427,9 @@ for n in ns3 ns4;do
 	ip -net $n xfrm policy set hthresh4 32 32 hthresh6 128 128
 	sleep $((RANDOM%5))
 done
-check_exceptions "exceptions and block policies after hresh change to normal"
+check_exceptions "exceptions and block policies after htresh change to normal"
+
+check_hthresh_repeat "policies with repeated htresh change"
 
 for i in 1 2 3 4;do ip netns del ns$i;done
 
-- 
2.21.0

