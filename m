Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E41863628A5
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 21:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235667AbhDPT3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 15:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231510AbhDPT3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 15:29:50 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9047C061574
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 12:29:23 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lXU9X-00058I-G4; Fri, 16 Apr 2021 21:29:19 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sean Tranchetti <stranche@codeaurora.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net] netlink: don't call ->netlink_bind with table lock held
Date:   Fri, 16 Apr 2021 21:29:13 +0200
Message-Id: <20210416192913.6139-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When I added support to allow generic netlink multicast groups to be
restricted to subscribers with CAP_NET_ADMIN I was unaware that a
genl_bind implementation already existed in the past.

It was reverted due to ABBA deadlock:

1. ->netlink_bind gets called with the table lock held.
2. genetlink bind callback is invoked, it grabs the genl lock.

But when a new genl subsystem is (un)registered, these two locks are
taken in reverse order.

One solution would be to revert again and add a comment in genl
referring 1e82a62fec613, "genetlink: remove genl_bind").

This would need a second change in mptcp to not expose the raw token
value anymore, e.g.  by hashing the token with a secret key so userspace
can still associate subflow events with the correct mptcp connection.

However, Paolo Abeni reminded me to double-check why the netlink table is
locked in the first place.

I can't find one.  netlink_bind() is already called without this lock
when userspace joins a group via NETLINK_ADD_MEMBERSHIP setsockopt.
Same holds for the netlink_unbind operation.

Digging through the history, commit f773608026ee1
("netlink: access nlk groups safely in netlink bind and getname")
expanded the lock scope.

commit 3a20773beeeeade ("net: netlink: cap max groups which will be considered in netlink_bind()")
... removed the nlk->ngroups access that the lock scope
extension was all about.

Reduce the lock scope again and always call ->netlink_bind without
the table lock.

The Fixes tag should be vs. the patch mentioned in the link below,
but that one got squash-merged into the patch that came earlier in the
series.

Fixes: 4d54cc32112d8d ("mptcp: avoid lock_fast usage in accept path")
Link: https://lore.kernel.org/mptcp/20210213000001.379332-8-mathew.j.martineau@linux.intel.com/T/#u
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Xin Long <lucien.xin@gmail.com>
Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Sean Tranchetti <stranche@codeaurora.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netlink/af_netlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index dd488938447f..3a62f97acf39 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1019,7 +1019,6 @@ static int netlink_bind(struct socket *sock, struct sockaddr *addr,
 			return -EINVAL;
 	}
 
-	netlink_lock_table();
 	if (nlk->netlink_bind && groups) {
 		int group;
 
@@ -1031,13 +1030,14 @@ static int netlink_bind(struct socket *sock, struct sockaddr *addr,
 			if (!err)
 				continue;
 			netlink_undo_bind(group, groups, sk);
-			goto unlock;
+			return err;
 		}
 	}
 
 	/* No need for barriers here as we return to user-space without
 	 * using any of the bound attributes.
 	 */
+	netlink_lock_table();
 	if (!bound) {
 		err = nladdr->nl_pid ?
 			netlink_insert(sk, nladdr->nl_pid) :
-- 
2.26.3

