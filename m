Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4B220FB05
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 19:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388845AbgF3Ru1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 13:50:27 -0400
Received: from alexa-out-sd-02.qualcomm.com ([199.106.114.39]:27199 "EHLO
        alexa-out-sd-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388802AbgF3Ru1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 13:50:27 -0400
Received: from unknown (HELO ironmsg04-sd.qualcomm.com) ([10.53.140.144])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 30 Jun 2020 10:50:25 -0700
Received: from stranche-lnx.qualcomm.com ([129.46.14.77])
  by ironmsg04-sd.qualcomm.com with ESMTP; 30 Jun 2020 10:50:24 -0700
Received: by stranche-lnx.qualcomm.com (Postfix, from userid 383980)
        id 2C8C54CCE; Tue, 30 Jun 2020 11:50:24 -0600 (MDT)
From:   Sean Tranchetti <stranche@codeaurora.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     xiyou.wangcong@gmail.com, johannes.berg@intel.com,
        subashab@codeaurora.org, Sean Tranchetti <stranche@codeaurora.org>
Subject: [PATCH net v2] genetlink: remove genl_bind
Date:   Tue, 30 Jun 2020 11:50:17 -0600
Message-Id: <1593539417-19973-1-git-send-email-stranche@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A potential deadlock can occur during registering or unregistering a
new generic netlink family between the main nl_table_lock and the
cb_lock where each thread wants the lock held by the other, as
demonstrated below.

1) Thread 1 is performing a netlink_bind() operation on a socket. As part
   of this call, it will call netlink_lock_table(), incrementing the
   nl_table_users count to 1.
2) Thread 2 is registering (or unregistering) a genl_family via the
   genl_(un)register_family() API. The cb_lock semaphore will be taken for
   writing.
3) Thread 1 will call genl_bind() as part of the bind operation to handle
   subscribing to GENL multicast groups at the request of the user. It will
   attempt to take the cb_lock semaphore for reading, but it will fail and
   be scheduled away, waiting for Thread 2 to finish the write.
4) Thread 2 will call netlink_table_grab() during the (un)registration
   call. However, as Thread 1 has incremented nl_table_users, it will not
   be able to proceed, and both threads will be stuck waiting for the
   other.

genl_bind() is a noop, unless a genl_family implements the mcast_bind()
function to handle setting up family-specific multicast operations. Since
no one in-tree uses this functionality as Cong pointed out, simply removing
the genl_bind() function will remove the possibility for deadlock, as there
is no attempt by Thread 1 above to take the cb_lock semaphore.

Fixes: c380d9a7afff ("genetlink: pass multicast bind/unbind to families")
Suggested-by: Cong Wang <xiyou.wangcong@gmail.com>
Acked-by: Johannes Berg <johannes.berg@intel.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Sean Tranchetti <stranche@codeaurora.org>
---
 include/net/genetlink.h |  8 --------
 net/netlink/genetlink.c | 49 -------------------------------------------------
 2 files changed, 57 deletions(-)

diff --git a/include/net/genetlink.h b/include/net/genetlink.h
index 7495066..4cf703d 100644
--- a/include/net/genetlink.h
+++ b/include/net/genetlink.h
@@ -35,12 +35,6 @@ struct genl_multicast_group {
  *	do additional, common, filtering and return an error
  * @post_doit: called after an operation's doit callback, it may
  *	undo operations done by pre_doit, for example release locks
- * @mcast_bind: a socket bound to the given multicast group (which
- *	is given as the offset into the groups array)
- * @mcast_unbind: a socket was unbound from the given multicast group.
- *	Note that unbind() will not be called symmetrically if the
- *	generic netlink family is removed while there are still open
- *	sockets.
  * @attrbuf: buffer to store parsed attributes (private)
  * @mcgrps: multicast groups used by this family
  * @n_mcgrps: number of multicast groups
@@ -64,8 +58,6 @@ struct genl_family {
 	void			(*post_doit)(const struct genl_ops *ops,
 					     struct sk_buff *skb,
 					     struct genl_info *info);
-	int			(*mcast_bind)(struct net *net, int group);
-	void			(*mcast_unbind)(struct net *net, int group);
 	struct nlattr **	attrbuf;	/* private */
 	const struct genl_ops *	ops;
 	const struct genl_multicast_group *mcgrps;
diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 55ee680..dfaaefb 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1166,60 +1166,11 @@ static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
 	.netnsok = true,
 };
 
-static int genl_bind(struct net *net, int group)
-{
-	struct genl_family *f;
-	int err = -ENOENT;
-	unsigned int id;
-
-	down_read(&cb_lock);
-
-	idr_for_each_entry(&genl_fam_idr, f, id) {
-		if (group >= f->mcgrp_offset &&
-		    group < f->mcgrp_offset + f->n_mcgrps) {
-			int fam_grp = group - f->mcgrp_offset;
-
-			if (!f->netnsok && net != &init_net)
-				err = -ENOENT;
-			else if (f->mcast_bind)
-				err = f->mcast_bind(net, fam_grp);
-			else
-				err = 0;
-			break;
-		}
-	}
-	up_read(&cb_lock);
-
-	return err;
-}
-
-static void genl_unbind(struct net *net, int group)
-{
-	struct genl_family *f;
-	unsigned int id;
-
-	down_read(&cb_lock);
-
-	idr_for_each_entry(&genl_fam_idr, f, id) {
-		if (group >= f->mcgrp_offset &&
-		    group < f->mcgrp_offset + f->n_mcgrps) {
-			int fam_grp = group - f->mcgrp_offset;
-
-			if (f->mcast_unbind)
-				f->mcast_unbind(net, fam_grp);
-			break;
-		}
-	}
-	up_read(&cb_lock);
-}
-
 static int __net_init genl_pernet_init(struct net *net)
 {
 	struct netlink_kernel_cfg cfg = {
 		.input		= genl_rcv,
 		.flags		= NL_CFG_F_NONROOT_RECV,
-		.bind		= genl_bind,
-		.unbind		= genl_unbind,
 	};
 
 	/* we'll bump the group number right afterwards */
-- 
1.9.1

