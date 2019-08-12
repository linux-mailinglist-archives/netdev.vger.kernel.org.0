Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69257898E5
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 10:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727275AbfHLIm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 04:42:59 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:44714 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727245AbfHLIm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 04:42:58 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hx5up-0008K3-U1; Mon, 12 Aug 2019 10:42:55 +0200
From:   Florian Westphal <fw@strlen.de>
To:     steffen.klassert@secunet.com
Cc:     <netdev@vger.kernel.org>, syzkaller-bugs@googlegroups.com,
        Florian Westphal <fw@strlen.de>,
        syzbot+8cc27ace5f6972910b31@syzkaller.appspotmail.com
Subject: [PATCH ipsec] xfrm: policy: avoid warning splat when merging nodes
Date:   Mon, 12 Aug 2019 10:32:13 +0200
Message-Id: <20190812083213.5010-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <000000000000a585f2058f9dc7b3@google.com>
References: <000000000000a585f2058f9dc7b3@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot reported a splat:
 xfrm_policy_inexact_list_reinsert+0x625/0x6e0 net/xfrm/xfrm_policy.c:877
 CPU: 1 PID: 6756 Comm: syz-executor.1 Not tainted 5.3.0-rc2+ #57
 Call Trace:
  xfrm_policy_inexact_node_reinsert net/xfrm/xfrm_policy.c:922 [inline]
  xfrm_policy_inexact_node_merge net/xfrm/xfrm_policy.c:958 [inline]
  xfrm_policy_inexact_insert_node+0x537/0xb50 net/xfrm/xfrm_policy.c:1023
  xfrm_policy_inexact_alloc_chain+0x62b/0xbd0 net/xfrm/xfrm_policy.c:1139
  xfrm_policy_inexact_insert+0xe8/0x1540 net/xfrm/xfrm_policy.c:1182
  xfrm_policy_insert+0xdf/0xce0 net/xfrm/xfrm_policy.c:1574
  xfrm_add_policy+0x4cf/0x9b0 net/xfrm/xfrm_user.c:1670
  xfrm_user_rcv_msg+0x46b/0x720 net/xfrm/xfrm_user.c:2676
  netlink_rcv_skb+0x1f0/0x460 net/netlink/af_netlink.c:2477
  xfrm_netlink_rcv+0x74/0x90 net/xfrm/xfrm_user.c:2684
  netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
  netlink_unicast+0x809/0x9a0 net/netlink/af_netlink.c:1328
  netlink_sendmsg+0xa70/0xd30 net/netlink/af_netlink.c:1917
  sock_sendmsg_nosec net/socket.c:637 [inline]
  sock_sendmsg net/socket.c:657 [inline]

There is no reproducer, however, the warning can be reproduced
by adding rules with ever smaller prefixes.

The sanity check ("does the policy match the node") uses the prefix value
of the node before its updated to the smaller value.

To fix this, update the prefix earlier.  The bug has no impact on tree
correctness, this is only to prevent a false warning.

Reported-by: syzbot+8cc27ace5f6972910b31@syzkaller.appspotmail.com
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/xfrm/xfrm_policy.c                     | 6 ++++--
 tools/testing/selftests/net/xfrm_policy.sh | 7 +++++++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 8ca637a72697..0fa7c5ce3b2c 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -912,6 +912,7 @@ static void xfrm_policy_inexact_node_reinsert(struct net *net,
 		} else if (delta > 0) {
 			p = &parent->rb_right;
 		} else {
+			bool same_prefixlen = node->prefixlen == n->prefixlen;
 			struct xfrm_policy *tmp;
 
 			hlist_for_each_entry(tmp, &n->hhead, bydst) {
@@ -919,9 +920,11 @@ static void xfrm_policy_inexact_node_reinsert(struct net *net,
 				hlist_del_rcu(&tmp->bydst);
 			}
 
+			node->prefixlen = prefixlen;
+
 			xfrm_policy_inexact_list_reinsert(net, node, family);
 
-			if (node->prefixlen == n->prefixlen) {
+			if (same_prefixlen) {
 				kfree_rcu(n, rcu);
 				return;
 			}
@@ -929,7 +932,6 @@ static void xfrm_policy_inexact_node_reinsert(struct net *net,
 			rb_erase(*p, new);
 			kfree_rcu(n, rcu);
 			n = node;
-			n->prefixlen = prefixlen;
 			goto restart;
 		}
 	}
diff --git a/tools/testing/selftests/net/xfrm_policy.sh b/tools/testing/selftests/net/xfrm_policy.sh
index 5445943bf07f..7a1bf94c5bd3 100755
--- a/tools/testing/selftests/net/xfrm_policy.sh
+++ b/tools/testing/selftests/net/xfrm_policy.sh
@@ -106,6 +106,13 @@ do_overlap()
     #
     # 10.0.0.0/24 and 10.0.1.0/24 nodes have been merged as 10.0.0.0/23.
     ip -net $ns xfrm policy add src 10.1.0.0/24 dst 10.0.0.0/23 dir fwd priority 200 action block
+
+    # similar to above: add policies (with partially random address), with shrinking prefixes.
+    for p in 29 28 27;do
+      for k in $(seq 1 32); do
+       ip -net $ns xfrm policy add src 10.253.1.$((RANDOM%255))/$p dst 10.254.1.$((RANDOM%255))/$p dir fwd priority $((200+k)) action block 2>/dev/null
+      done
+    done
 }
 
 do_esp_policy_get_check() {
-- 
2.21.0

