Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB0B23A24E
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 00:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727900AbfFHWWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 18:22:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:44486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727777AbfFHWWZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Jun 2019 18:22:25 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FB96217F9;
        Sat,  8 Jun 2019 21:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560030827;
        bh=eyWZf3rRouZYpP+wjSLX82zWQnYTIl5DIdYa5T4YUq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KvA+vqdxTl3o/b7+C8uMLItnNse/ky1pUUSnk2U4xTLMskhLuddj4gDB3VKgspxCS
         tmXflaqFEbiLqmjvbWbwm2MRiQk1RGsC9XOL/v/+VBA8PfSvfvgC7aJ95CDfY1Ry1f
         t0L8+dra+5BMD6W4ulB/o4lyELkcZwnr1hILc7kw=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@mellanox.com, kafai@fb.com, weiwan@google.com,
        sbrivio@redhat.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH v4 net-next 14/20] nexthops: add support for replace
Date:   Sat,  8 Jun 2019 14:53:35 -0700
Message-Id: <20190608215341.26592-15-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190608215341.26592-1-dsahern@kernel.org>
References: <20190608215341.26592-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add support for atomically upating a nexthop config.

When updating a nexthop, walk the lists of associated fib entries and
verify the new config is valid. Replace is done by swapping nh_info
for single nexthops - new config is applied to old nexthop struct, and
old config is moved to new nexthop struct. For nexthop groups the same
applies but for nh_group. In addition for groups the nh_parent reference
needs to be updated. The old config is released by calling __remove_nexthop
on the 'new' nexthop which now has the old config. This is done to avoid
messing around with the list_heads that track which fib entries are
using the nexthop.

After the swap of config data, bump the sequence counters for FIB entries
to invalidate any dst entries and send notifications to userspace. The
notifications include the new nexthop spec as well as any fib entries
using the updated nexthop struct.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 net/ipv4/nexthop.c | 219 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 214 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 49e8adce5b96..5fe5a3981d43 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -548,6 +548,16 @@ int nexthop_for_each_fib6_nh(struct nexthop *nh,
 }
 EXPORT_SYMBOL_GPL(nexthop_for_each_fib6_nh);
 
+static int check_src_addr(const struct in6_addr *saddr,
+			  struct netlink_ext_ack *extack)
+{
+	if (!ipv6_addr_any(saddr)) {
+		NL_SET_ERR_MSG(extack, "IPv6 routes using source address can not use nexthop objects");
+		return -EINVAL;
+	}
+	return 0;
+}
+
 int fib6_check_nexthop(struct nexthop *nh, struct fib6_config *cfg,
 		       struct netlink_ext_ack *extack)
 {
@@ -559,10 +569,8 @@ int fib6_check_nexthop(struct nexthop *nh, struct fib6_config *cfg,
 	 * routing it can not use nexthop objects. mlxsw also does not allow
 	 * fib6_src on routes.
 	 */
-	if (!ipv6_addr_any(&cfg->fc_src)) {
-		NL_SET_ERR_MSG(extack, "IPv6 routes using source address can not use nexthop objects");
+	if (cfg && check_src_addr(&cfg->fc_src, extack) < 0)
 		return -EINVAL;
-	}
 
 	if (nh->is_group) {
 		struct nh_group *nhg;
@@ -583,6 +591,25 @@ int fib6_check_nexthop(struct nexthop *nh, struct fib6_config *cfg,
 }
 EXPORT_SYMBOL_GPL(fib6_check_nexthop);
 
+/* if existing nexthop has ipv6 routes linked to it, need
+ * to verify this new spec works with ipv6
+ */
+static int fib6_check_nh_list(struct nexthop *old, struct nexthop *new,
+			      struct netlink_ext_ack *extack)
+{
+	struct fib6_info *f6i;
+
+	if (list_empty(&old->f6i_list))
+		return 0;
+
+	list_for_each_entry(f6i, &old->f6i_list, nh_list) {
+		if (check_src_addr(&f6i->fib6_src.addr, extack) < 0)
+			return -EINVAL;
+	}
+
+	return fib6_check_nexthop(new, NULL, extack);
+}
+
 static int nexthop_check_scope(struct nexthop *nh, u8 scope,
 			       struct netlink_ext_ack *extack)
 {
@@ -631,6 +658,21 @@ int fib_check_nexthop(struct nexthop *nh, u8 scope,
 	return err;
 }
 
+static int fib_check_nh_list(struct nexthop *old, struct nexthop *new,
+			     struct netlink_ext_ack *extack)
+{
+	struct fib_info *fi;
+
+	list_for_each_entry(fi, &old->fi_list, nh_list) {
+		int err;
+
+		err = fib_check_nexthop(new, fi->fib_scope, extack);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
 static void nh_group_rebalance(struct nh_group *nhg)
 {
 	int total = 0;
@@ -723,6 +765,7 @@ static void remove_nexthop_group(struct nexthop *nh, struct nl_info *nlinfo)
 	}
 }
 
+/* not called for nexthop replace */
 static void __remove_nexthop_fib(struct net *net, struct nexthop *nh)
 {
 	struct fib6_info *f6i, *tmp;
@@ -777,10 +820,171 @@ static void remove_nexthop(struct net *net, struct nexthop *nh,
 	nexthop_put(nh);
 }
 
+/* if any FIB entries reference this nexthop, any dst entries
+ * need to be regenerated
+ */
+static void nh_rt_cache_flush(struct net *net, struct nexthop *nh)
+{
+	struct fib6_info *f6i;
+
+	if (!list_empty(&nh->fi_list))
+		rt_cache_flush(net);
+
+	list_for_each_entry(f6i, &nh->f6i_list, nh_list)
+		ipv6_stub->fib6_update_sernum(net, f6i);
+}
+
+static int replace_nexthop_grp(struct net *net, struct nexthop *old,
+			       struct nexthop *new,
+			       struct netlink_ext_ack *extack)
+{
+	struct nh_group *oldg, *newg;
+	int i;
+
+	if (!new->is_group) {
+		NL_SET_ERR_MSG(extack, "Can not replace a nexthop group with a nexthop.");
+		return -EINVAL;
+	}
+
+	oldg = rtnl_dereference(old->nh_grp);
+	newg = rtnl_dereference(new->nh_grp);
+
+	/* update parents - used by nexthop code for cleanup */
+	for (i = 0; i < newg->num_nh; i++)
+		newg->nh_entries[i].nh_parent = old;
+
+	rcu_assign_pointer(old->nh_grp, newg);
+
+	for (i = 0; i < oldg->num_nh; i++)
+		oldg->nh_entries[i].nh_parent = new;
+
+	rcu_assign_pointer(new->nh_grp, oldg);
+
+	return 0;
+}
+
+static int replace_nexthop_single(struct net *net, struct nexthop *old,
+				  struct nexthop *new,
+				  struct netlink_ext_ack *extack)
+{
+	struct nh_info *oldi, *newi;
+
+	if (new->is_group) {
+		NL_SET_ERR_MSG(extack, "Can not replace a nexthop with a nexthop group.");
+		return -EINVAL;
+	}
+
+	oldi = rtnl_dereference(old->nh_info);
+	newi = rtnl_dereference(new->nh_info);
+
+	newi->nh_parent = old;
+	oldi->nh_parent = new;
+
+	old->protocol = new->protocol;
+	old->nh_flags = new->nh_flags;
+
+	rcu_assign_pointer(old->nh_info, newi);
+	rcu_assign_pointer(new->nh_info, oldi);
+
+	return 0;
+}
+
+static void __nexthop_replace_notify(struct net *net, struct nexthop *nh,
+				     struct nl_info *info)
+{
+	struct fib6_info *f6i;
+
+	if (!list_empty(&nh->fi_list)) {
+		struct fib_info *fi;
+
+		/* expectation is a few fib_info per nexthop and then
+		 * a lot of routes per fib_info. So mark the fib_info
+		 * and then walk the fib tables once
+		 */
+		list_for_each_entry(fi, &nh->fi_list, nh_list)
+			fi->nh_updated = true;
+
+		fib_info_notify_update(net, info);
+
+		list_for_each_entry(fi, &nh->fi_list, nh_list)
+			fi->nh_updated = false;
+	}
+
+	list_for_each_entry(f6i, &nh->f6i_list, nh_list)
+		ipv6_stub->fib6_rt_update(net, f6i, info);
+}
+
+/* send RTM_NEWROUTE with REPLACE flag set for all FIB entries
+ * linked to this nexthop and for all groups that the nexthop
+ * is a member of
+ */
+static void nexthop_replace_notify(struct net *net, struct nexthop *nh,
+				   struct nl_info *info)
+{
+	struct nh_grp_entry *nhge;
+
+	__nexthop_replace_notify(net, nh, info);
+
+	list_for_each_entry(nhge, &nh->grp_list, nh_list)
+		__nexthop_replace_notify(net, nhge->nh_parent, info);
+}
+
 static int replace_nexthop(struct net *net, struct nexthop *old,
 			   struct nexthop *new, struct netlink_ext_ack *extack)
 {
-	return -EEXIST;
+	bool new_is_reject = false;
+	struct nh_grp_entry *nhge;
+	int err;
+
+	/* check that existing FIB entries are ok with the
+	 * new nexthop definition
+	 */
+	err = fib_check_nh_list(old, new, extack);
+	if (err)
+		return err;
+
+	err = fib6_check_nh_list(old, new, extack);
+	if (err)
+		return err;
+
+	if (!new->is_group) {
+		struct nh_info *nhi = rtnl_dereference(new->nh_info);
+
+		new_is_reject = nhi->reject_nh;
+	}
+
+	list_for_each_entry(nhge, &old->grp_list, nh_list) {
+		/* if new nexthop is a blackhole, any groups using this
+		 * nexthop cannot have more than 1 path
+		 */
+		if (new_is_reject &&
+		    nexthop_num_path(nhge->nh_parent) > 1) {
+			NL_SET_ERR_MSG(extack, "Blackhole nexthop can not be a member of a group with more than one path");
+			return -EINVAL;
+		}
+
+		err = fib_check_nh_list(nhge->nh_parent, new, extack);
+		if (err)
+			return err;
+
+		err = fib6_check_nh_list(nhge->nh_parent, new, extack);
+		if (err)
+			return err;
+	}
+
+	if (old->is_group)
+		err = replace_nexthop_grp(net, old, new, extack);
+	else
+		err = replace_nexthop_single(net, old, new, extack);
+
+	if (!err) {
+		nh_rt_cache_flush(net, old);
+
+		__remove_nexthop(net, new, NULL);
+		nexthop_put(new);
+	}
+
+	return err;
 }
 
 /* called with rtnl_lock held */
@@ -792,6 +996,7 @@ static int insert_nexthop(struct net *net, struct nexthop *new_nh,
 	bool replace = !!(cfg->nlflags & NLM_F_REPLACE);
 	bool create = !!(cfg->nlflags & NLM_F_CREATE);
 	u32 new_id = new_nh->id;
+	int replace_notify = 0;
 	int rc = -EEXIST;
 
 	pp = &root->rb_node;
@@ -811,8 +1016,10 @@ static int insert_nexthop(struct net *net, struct nexthop *new_nh,
 			pp = &next->rb_right;
 		} else if (replace) {
 			rc = replace_nexthop(net, nh, new_nh, extack);
-			if (!rc)
+			if (!rc) {
 				new_nh = nh; /* send notification with old nh */
+				replace_notify = 1;
+			}
 			goto out;
 		} else {
 			/* id already exists and not a replace */
@@ -833,6 +1040,8 @@ static int insert_nexthop(struct net *net, struct nexthop *new_nh,
 	if (!rc) {
 		nh_base_seq_inc(net);
 		nexthop_notify(RTM_NEWNEXTHOP, new_nh, &cfg->nlinfo);
+		if (replace_notify)
+			nexthop_replace_notify(net, new_nh, &cfg->nlinfo);
 	}
 
 	return rc;
-- 
2.11.0

