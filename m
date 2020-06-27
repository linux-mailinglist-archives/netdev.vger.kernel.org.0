Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C68D20BD7C
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 02:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726000AbgF0Abl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 20:31:41 -0400
Received: from alexa-out-sd-02.qualcomm.com ([199.106.114.39]:29794 "EHLO
        alexa-out-sd-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725821AbgF0Abl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 20:31:41 -0400
Received: from unknown (HELO ironmsg05-sd.qualcomm.com) ([10.53.140.145])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 26 Jun 2020 17:31:40 -0700
Received: from stranche-lnx.qualcomm.com ([129.46.14.77])
  by ironmsg05-sd.qualcomm.com with ESMTP; 26 Jun 2020 17:31:39 -0700
Received: by stranche-lnx.qualcomm.com (Postfix, from userid 383980)
        id 848504CBD; Fri, 26 Jun 2020 18:31:39 -0600 (MDT)
From:   Sean Tranchetti <stranche@codeaurora.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Sean Tranchetti <stranche@codeaurora.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: [PATCH net] genetlink: take netlink table lock when (un)registering
Date:   Fri, 26 Jun 2020 18:31:03 -0600
Message-Id: <1593217863-2964-1-git-send-email-stranche@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A potential deadlock can occur during registering or unregistering a new
generic netlink family between the main nl_table_lock and the cb_lock where
each thread wants the lock held by the other, as demonstrated below.

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

To avoid this scenario, the locks should be acquired in the same order by
both threads. Since both the register and unregister functions need to take
the nl_table_lock in their processing, it makes sense to explicitly acquire
them before they lock the genl_mutex and the cb_lock. In unregistering, no
other change is needed aside from this locking change.

Registering a family requires more ancilary operations, such as memory
allocation. Unfortunately, much of this allocation must be performed inside
of the genl locks to ensure internal synchronization, so they must also be
performed inside of the nl_table_lock where sleeping is not allowed. As a
result, the allocation types must be changed to GFP_ATOMIC.

Fixes: def3117493ea ("genl: Allow concurrent genl callbacks")
Cc: Pravin B Shelar <pshelar@ovn.org>
Cc: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Signed-off-by: Sean Tranchetti <stranche@codeaurora.org>
---
 net/netlink/genetlink.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 55ee680..79e3b1b 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -155,14 +155,14 @@ static int genl_allocate_reserve_groups(int n_groups, int *first_id)
 			size_t nlen = new_longs * sizeof(unsigned long);
 
 			if (mc_groups == &mc_group_start) {
-				new_groups = kzalloc(nlen, GFP_KERNEL);
+				new_groups = kzalloc(nlen, GFP_ATOMIC);
 				if (!new_groups)
 					return -ENOMEM;
 				mc_groups = new_groups;
 				*mc_groups = mc_group_start;
 			} else {
 				new_groups = krealloc(mc_groups, nlen,
-						      GFP_KERNEL);
+						      GFP_ATOMIC);
 				if (!new_groups)
 					return -ENOMEM;
 				mc_groups = new_groups;
@@ -229,7 +229,6 @@ static int genl_validate_assign_mc_groups(struct genl_family *family)
 	if (family->netnsok) {
 		struct net *net;
 
-		netlink_table_grab();
 		rcu_read_lock();
 		for_each_net_rcu(net) {
 			err = __netlink_change_ngroups(net->genl_sock,
@@ -245,10 +244,9 @@ static int genl_validate_assign_mc_groups(struct genl_family *family)
 			}
 		}
 		rcu_read_unlock();
-		netlink_table_ungrab();
 	} else {
-		err = netlink_change_ngroups(init_net.genl_sock,
-					     mc_groups_longs * BITS_PER_LONG);
+		err = __netlink_change_ngroups(init_net.genl_sock,
+					       mc_groups_longs * BITS_PER_LONG);
 	}
 
 	if (groups_allocated && err) {
@@ -264,7 +262,6 @@ static void genl_unregister_mc_groups(const struct genl_family *family)
 	struct net *net;
 	int i;
 
-	netlink_table_grab();
 	rcu_read_lock();
 	for_each_net_rcu(net) {
 		for (i = 0; i < family->n_mcgrps; i++)
@@ -328,6 +325,10 @@ int genl_register_family(struct genl_family *family)
 	if (err)
 		return err;
 
+	/* Acquire netlink table lock before any GENL-specific locks to ensure
+	 * sync with any netlink operations making calls into the GENL code.
+	 */
+	netlink_table_grab();
 	genl_lock_all();
 
 	if (genl_family_find_byname(family->name)) {
@@ -354,7 +355,7 @@ int genl_register_family(struct genl_family *family)
 	if (family->maxattr && !family->parallel_ops) {
 		family->attrbuf = kmalloc_array(family->maxattr + 1,
 						sizeof(struct nlattr *),
-						GFP_KERNEL);
+						GFP_ATOMIC);
 		if (family->attrbuf == NULL) {
 			err = -ENOMEM;
 			goto errout_locked;
@@ -363,7 +364,7 @@ int genl_register_family(struct genl_family *family)
 		family->attrbuf = NULL;
 
 	family->id = idr_alloc_cyclic(&genl_fam_idr, family,
-				      start, end + 1, GFP_KERNEL);
+				      start, end + 1, GFP_ATOMIC);
 	if (family->id < 0) {
 		err = family->id;
 		goto errout_free;
@@ -374,6 +375,7 @@ int genl_register_family(struct genl_family *family)
 		goto errout_remove;
 
 	genl_unlock_all();
+	netlink_table_ungrab();
 
 	/* send all events */
 	genl_ctrl_event(CTRL_CMD_NEWFAMILY, family, NULL, 0);
@@ -389,6 +391,7 @@ int genl_register_family(struct genl_family *family)
 	kfree(family->attrbuf);
 errout_locked:
 	genl_unlock_all();
+	netlink_table_ungrab();
 	return err;
 }
 EXPORT_SYMBOL(genl_register_family);
@@ -403,13 +406,21 @@ int genl_register_family(struct genl_family *family)
  */
 int genl_unregister_family(const struct genl_family *family)
 {
+	/* Acquire netlink table lock before any GENL-specific locks to ensure
+	 * sync with any netlink operations making calls into the GENL code.
+	 */
+	netlink_table_grab();
 	genl_lock_all();
 
 	if (!genl_family_find_byid(family->id)) {
 		genl_unlock_all();
+		netlink_table_ungrab();
 		return -ENOENT;
 	}
 
+	/* Netlink table lock will be removed by this function. No other
+	 * functions that require it should be placed after this point.
+	 */
 	genl_unregister_mc_groups(family);
 
 	idr_remove(&genl_fam_idr, family->id);
-- 
1.9.1

