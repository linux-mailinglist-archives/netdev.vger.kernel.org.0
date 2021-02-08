Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EEA93140DB
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 21:48:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233443AbhBHUsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 15:48:12 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:13290 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231781AbhBHUog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 15:44:36 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6021a27d0000>; Mon, 08 Feb 2021 12:43:41 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 8 Feb
 2021 20:43:41 +0000
Received: from yaviefel.local (172.20.145.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 8 Feb 2021
 20:43:38 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [RFC PATCH 06/13] nexthop: Implement notifiers for resilient nexthop groups
Date:   Mon, 8 Feb 2021 21:42:49 +0100
Message-ID: <4664eeb381eefcc74bb1ff1e8a0f4da329bbf000.1612815058.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1612815057.git.petrm@nvidia.com>
References: <cover.1612815057.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612817021; bh=dCyyIZWT/WQEA/xUZSXhSAaeUQy/ZKB4Dqr6+xP36YQ=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=jtGcbuzTcNeOt75CX8TsBflUaWy7g1LA11buz2VU+uG6uo5lRQIGtcJcE8Z8suri/
         nqpjRKPlvUk7WoFa9BtSEH6vg5JGe5X0N77zwPYoSnoHTmx2sm6pawSdpRtnsx4M4G
         RF5qqEs7y7Ih1+whSa0jmNd4nY4DoGjfbyx87jBJ8kA4nDUm41YypGT96MNfqC9M8c
         jvG2f/N96jpcWe/uKAbB9X/AY3Dsq+dNEC8pzeOGn1eNgGDsZ+jPBzPJhg/0C1kttd
         QitWlJPHQDMzLno7UZRJ6lucaP/vwt7mUXI1IgnsqqCamNdwqMxMdqr8mNnH6F7OGd
         EuXl6TrrW++MA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the following notifications towards drivers:

- NEXTHOP_EVENT_REPLACE, when a resilient nexthop group is created.

- NEXTHOP_EVENT_BUCKET_REPLACE any time there is a change in assignment of
  next hops to hash table buckets. That includes replacements, deletions,
  and delayed upkeep cycles. Some bucket notifications can be vetoed by the
  driver, to make it possible to propagate bucket busy-ness flags from the
  HW back to the algorithm. Some are however forced, e.g. if a next hop is
  deleted, all buckets that use this next hop simply must be migrated,
  whether the HW wishes so or not.

- NEXTHOP_EVENT_RES_TABLE_PRE_REPLACE, before a resilient nexthop group is
  replaced. Usually the driver will get the bucket notifications as well,
  and could veto those. But in some cases, a bucket may not be migrated
  immediately, but during delayed upkeep, and that is too late to roll the
  transaction back. This notification allows the driver to take a look and
  veto the new proposed group up front, before anything is committed.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv4/nexthop.c | 320 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 308 insertions(+), 12 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 4ce282b0a65f..fe91f3a0fb1e 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -115,6 +115,37 @@ static int nh_notifier_mp_info_init(struct nh_notifier=
_info *info,
 	return 0;
 }
=20
+static int nh_notifier_res_table_info_init(struct nh_notifier_info *info,
+					   struct nh_group *nhg)
+{
+	struct nh_res_table *res_table =3D rtnl_dereference(nhg->res_table);
+	u32 num_nh_buckets =3D res_table->num_nh_buckets;
+	unsigned long size;
+	u32 i;
+
+	info->type =3D NH_NOTIFIER_INFO_TYPE_RES_TABLE;
+	size =3D struct_size(info->nh_res_table, nhs, num_nh_buckets);
+	info->nh_res_table =3D __vmalloc(size, GFP_KERNEL | __GFP_ZERO |
+				       __GFP_NOWARN);
+	if (!info->nh_res_table)
+		return -ENOMEM;
+
+	info->nh_res_table->num_nh_buckets =3D num_nh_buckets;
+
+	for (i =3D 0; i < num_nh_buckets; i++) {
+		struct nh_res_bucket *bucket =3D &res_table->nh_buckets[i];
+		struct nh_grp_entry *nhge;
+		struct nh_info *nhi;
+
+		nhge =3D rtnl_dereference(bucket->nh_entry);
+		nhi =3D rtnl_dereference(nhge->nh->nh_info);
+		__nh_notifier_single_info_init(&info->nh_res_table->nhs[i],
+					       nhi);
+	}
+
+	return 0;
+}
+
 static int nh_notifier_grp_info_init(struct nh_notifier_info *info,
 				     const struct nexthop *nh)
 {
@@ -122,6 +153,8 @@ static int nh_notifier_grp_info_init(struct nh_notifier=
_info *info,
=20
 	if (nhg->mpath)
 		return nh_notifier_mp_info_init(info, nhg);
+	else if (nhg->resilient)
+		return nh_notifier_res_table_info_init(info, nhg);
 	return -EINVAL;
 }
=20
@@ -132,6 +165,8 @@ static void nh_notifier_grp_info_fini(struct nh_notifie=
r_info *info,
=20
 	if (nhg->mpath)
 		kfree(info->nh_grp);
+	else if (nhg->resilient)
+		vfree(info->nh_res_table);
 }
=20
 static int nh_notifier_info_init(struct nh_notifier_info *info,
@@ -183,6 +218,107 @@ static int call_nexthop_notifiers(struct net *net,
 	return notifier_to_errno(err);
 }
=20
+static int
+nh_notifier_res_bucket_idle_timer_get(const struct nh_notifier_info *info,
+				      bool force, unsigned int *p_idle_timer_ms)
+{
+	struct nh_res_table *res_table;
+	struct nh_group *nhg;
+	struct nexthop *nh;
+	int err =3D 0;
+
+	/* When 'force' is false, nexthop bucket replacement is performed
+	 * because the bucket was deemed to be idle. In this case, capable
+	 * listeners can choose to perform an atomic replacement: The bucket is
+	 * only replaced if it is inactive. However, if the idle timer interval
+	 * is smaller than the interval in which a listener is querying
+	 * buckets' activity from the device, then atomic replacement should
+	 * not be tried. Pass the idle timer value to listeners, so that they
+	 * could determine which type of replacement to perform.
+	 */
+	if (force) {
+		*p_idle_timer_ms =3D 0;
+		return 0;
+	}
+
+	rcu_read_lock();
+
+	nh =3D nexthop_find_by_id(info->net, info->id);
+	if (!nh) {
+		err =3D -EINVAL;
+		goto out;
+	}
+
+	nhg =3D rcu_dereference(nh->nh_grp);
+	res_table =3D rcu_dereference(nhg->res_table);
+	*p_idle_timer_ms =3D jiffies_to_msecs(res_table->idle_timer);
+
+out:
+	rcu_read_unlock();
+
+	return err;
+}
+
+static int nh_notifier_res_bucket_info_init(struct nh_notifier_info *info,
+					    u32 bucket_index, bool force,
+					    struct nh_info *oldi,
+					    struct nh_info *newi)
+{
+	unsigned int idle_timer_ms;
+	int err;
+
+	err =3D nh_notifier_res_bucket_idle_timer_get(info, force,
+						    &idle_timer_ms);
+	if (err)
+		return err;
+
+	info->type =3D NH_NOTIFIER_INFO_TYPE_RES_BUCKET;
+	info->nh_res_bucket =3D kzalloc(sizeof(*info->nh_res_bucket),
+				      GFP_KERNEL);
+	if (!info->nh_res_bucket)
+		return -ENOMEM;
+
+	info->nh_res_bucket->bucket_index =3D bucket_index;
+	info->nh_res_bucket->idle_timer_ms =3D idle_timer_ms;
+	info->nh_res_bucket->force =3D force;
+	__nh_notifier_single_info_init(&info->nh_res_bucket->old_nh, oldi);
+	__nh_notifier_single_info_init(&info->nh_res_bucket->new_nh, newi);
+	return 0;
+}
+
+static void nh_notifier_res_bucket_info_fini(struct nh_notifier_info *info=
)
+{
+	kfree(info->nh_res_bucket);
+}
+
+static int __call_nexthop_res_bucket_notifiers(struct net *net, u32 nhg_id=
,
+					       u32 bucket_index, bool force,
+					       struct nh_info *oldi,
+					       struct nh_info *newi,
+					       struct netlink_ext_ack *extack)
+{
+	struct nh_notifier_info info =3D {
+		.net =3D net,
+		.extack =3D extack,
+		.id =3D nhg_id,
+	};
+	int err;
+
+	if (nexthop_notifiers_is_empty(net))
+		return 0;
+
+	err =3D nh_notifier_res_bucket_info_init(&info, bucket_index, force,
+					       oldi, newi);
+	if (err)
+		return err;
+
+	err =3D blocking_notifier_call_chain(&net->nexthop.notifier_chain,
+					   NEXTHOP_EVENT_BUCKET_REPLACE, &info);
+	nh_notifier_res_bucket_info_fini(&info);
+
+	return notifier_to_errno(err);
+}
+
 /* There are three users of RES_TABLE, and NHs etc. referenced from there:
  *
  * 1) a collection of callbacks for NH maintenance. This operates under
@@ -207,6 +343,53 @@ static int call_nexthop_notifiers(struct net *net,
  */
 #define nh_res_dereference(p) (rcu_dereference_raw(p))
=20
+static int call_nexthop_res_bucket_notifiers(struct net *net, u32 nhg_id,
+					     u32 bucket_index, bool force,
+					     struct nexthop *old_nh,
+					     struct nexthop *new_nh,
+					     struct netlink_ext_ack *extack)
+{
+	struct nh_info *oldi =3D nh_res_dereference(old_nh->nh_info);
+	struct nh_info *newi =3D nh_res_dereference(new_nh->nh_info);
+
+	return __call_nexthop_res_bucket_notifiers(net, nhg_id, bucket_index,
+						   force, oldi, newi, extack);
+}
+
+static int call_nexthop_res_table_notifiers(struct net *net, struct nextho=
p *nh,
+					    struct netlink_ext_ack *extack)
+{
+	struct nh_notifier_info info =3D {
+		.net =3D net,
+		.extack =3D extack,
+	};
+	struct nh_group *nhg;
+	int err;
+
+	ASSERT_RTNL();
+
+	if (nexthop_notifiers_is_empty(net))
+		return 0;
+
+	/* At this point, the nexthop buckets are still not populated. Only
+	 * emit a notification with the logical nexthops, so that a listener
+	 * could potentially veto it in case of unsupported configuration.
+	 */
+	nhg =3D rtnl_dereference(nh->nh_grp);
+	err =3D nh_notifier_mp_info_init(&info, nhg);
+	if (err) {
+		NL_SET_ERR_MSG(extack, "Failed to initialize nexthop notifier info");
+		return err;
+	}
+
+	err =3D blocking_notifier_call_chain(&net->nexthop.notifier_chain,
+					   NEXTHOP_EVENT_RES_TABLE_PRE_REPLACE,
+					   &info);
+	kfree(info.nh_grp);
+
+	return notifier_to_errno(err);
+}
+
 static int call_nexthop_notifier(struct notifier_block *nb, struct net *ne=
t,
 				 enum nexthop_event_type event_type,
 				 struct nexthop *nh,
@@ -1144,10 +1327,12 @@ static bool nh_res_bucket_should_migrate(struct nh_=
res_table *res_table,
 }
=20
 static bool nh_res_bucket_migrate(struct nh_res_table *res_table,
-				  u32 bucket_index, bool force)
+				  u32 bucket_index, bool notify, bool force)
 {
 	struct nh_res_bucket *bucket =3D &res_table->nh_buckets[bucket_index];
 	struct nh_grp_entry *new_nhge;
+	struct netlink_ext_ack extack;
+	int err;
=20
 	new_nhge =3D list_first_entry_or_null(&res_table->uw_nh_entries,
 					    struct nh_grp_entry,
@@ -1160,6 +1345,28 @@ static bool nh_res_bucket_migrate(struct nh_res_tabl=
e *res_table,
 		 */
 		return false;
=20
+	if (notify) {
+		struct nh_grp_entry *old_nhge;
+
+		old_nhge =3D nh_res_dereference(bucket->nh_entry);
+		err =3D call_nexthop_res_bucket_notifiers(res_table->net,
+							res_table->nhg_id,
+							bucket_index, force,
+							old_nhge->nh,
+							new_nhge->nh, &extack);
+		if (err) {
+			pr_err_ratelimited("%s\n", extack._msg);
+			if (!force)
+				return false;
+			/* It is not possible to veto a forced replacement, so
+			 * just clear the hardware flags from the nexthop
+			 * bucket to indicate to user space that this bucket is
+			 * not correctly populated in hardware.
+			 */
+			bucket->nh_flags &=3D ~(RTNH_F_OFFLOAD | RTNH_F_TRAP);
+		}
+	}
+
 	nh_res_bucket_set_nh(bucket, new_nhge);
 	nh_res_bucket_set_idle(res_table, bucket);
=20
@@ -1170,7 +1377,7 @@ static bool nh_res_bucket_migrate(struct nh_res_table=
 *res_table,
=20
 #define NH_RES_UPKEEP_DW_MINIMUM_INTERVAL (HZ / 2)
=20
-static void nh_res_table_upkeep(struct nh_res_table *res_table)
+static void nh_res_table_upkeep(struct nh_res_table *res_table, bool notif=
y)
 {
 	unsigned long now =3D jiffies;
 	unsigned long deadline;
@@ -1194,7 +1401,8 @@ static void nh_res_table_upkeep(struct nh_res_table *=
res_table)
=20
 		if (nh_res_bucket_should_migrate(res_table, bucket,
 						 &deadline, &force)) {
-			if (!nh_res_bucket_migrate(res_table, i, force)) {
+			if (!nh_res_bucket_migrate(res_table, i, notify,
+						   force)) {
 				unsigned long idle_point;
=20
 				/* A driver can override the migration
@@ -1235,7 +1443,7 @@ static void nh_res_table_upkeep_dw(struct work_struct=
 *work)
 	struct nh_res_table *res_table;
=20
 	res_table =3D container_of(dw, struct nh_res_table, upkeep_dw);
-	nh_res_table_upkeep(res_table);
+	nh_res_table_upkeep(res_table, true);
 }
=20
 static void nh_res_table_cancel_upkeep(struct nh_res_table *res_table)
@@ -1323,7 +1531,7 @@ static void replace_nexthop_grp_res(struct nh_group *=
oldg,
 	nh_res_group_rebalance(newg, old_res_table);
 	if (prev_has_uw && !list_empty(&old_res_table->uw_nh_entries))
 		old_res_table->unbalanced_since =3D prev_unbalanced_since;
-	nh_res_table_upkeep(old_res_table);
+	nh_res_table_upkeep(old_res_table, true);
 }
=20
 static void nh_mp_group_rebalance(struct nh_group *nhg)
@@ -1406,9 +1614,15 @@ static void remove_nh_grp_entry(struct net *net, str=
uct nh_grp_entry *nhge,
 	list_del(&nhge->nh_list);
 	nexthop_put(nhge->nh);
=20
-	err =3D call_nexthop_notifiers(net, NEXTHOP_EVENT_REPLACE, nhp, &extack);
-	if (err)
-		pr_err("%s\n", extack._msg);
+	/* Removal of a NH from a resilient group is notified through
+	 * bucket notifications.
+	 */
+	if (newg->mpath) {
+		err =3D call_nexthop_notifiers(net, NEXTHOP_EVENT_REPLACE, nhp,
+					     &extack);
+		if (err)
+			pr_err("%s\n", extack._msg);
+	}
=20
 	if (nlinfo)
 		nexthop_notify(RTM_NEWNEXTHOP, nhp, nlinfo);
@@ -1561,6 +1775,16 @@ static int replace_nexthop_grp(struct net *net, stru=
ct nexthop *old,
 			return -EINVAL;
 		}
=20
+		/* Emit a pre-replace notification so that listeners could veto
+		 * a potentially unsupported configuration. Otherwise,
+		 * individual bucket replacement notifications would need to be
+		 * vetoed, which is something that should only happen if the
+		 * bucket is currently active.
+		 */
+		err =3D call_nexthop_res_table_notifiers(net, new, extack);
+		if (err)
+			return err;
+
 		if (cfg->nh_grp_res_has_idle_timer)
 			old_res_table->idle_timer =3D cfg->nh_grp_res_idle_timer;
 		if (cfg->nh_grp_res_has_unbalanced_timer)
@@ -1610,6 +1834,71 @@ static void nh_group_v4_update(struct nh_group *nhg)
 	nhg->has_v4 =3D has_v4;
 }
=20
+static int replace_nexthop_single_notify_res(struct net *net,
+					     struct nh_res_table *res_table,
+					     struct nexthop *old,
+					     struct nh_info *oldi,
+					     struct nh_info *newi,
+					     struct netlink_ext_ack *extack)
+{
+	u32 nhg_id =3D res_table->nhg_id;
+	int err;
+	u32 i;
+
+	for (i =3D 0; i < res_table->num_nh_buckets; i++) {
+		struct nh_res_bucket *bucket =3D &res_table->nh_buckets[i];
+		struct nh_grp_entry *nhge;
+
+		nhge =3D rtnl_dereference(bucket->nh_entry);
+		if (nhge->nh =3D=3D old) {
+			err =3D __call_nexthop_res_bucket_notifiers(net, nhg_id,
+								  i, true,
+								  oldi, newi,
+								  extack);
+			if (err)
+				goto err_notify;
+		}
+	}
+
+	return 0;
+
+err_notify:
+	while (i-- > 0) {
+		struct nh_res_bucket *bucket =3D &res_table->nh_buckets[i];
+		struct nh_grp_entry *nhge;
+
+		nhge =3D rtnl_dereference(bucket->nh_entry);
+		if (nhge->nh =3D=3D old)
+			__call_nexthop_res_bucket_notifiers(net, nhg_id, i,
+							    true, newi, oldi,
+							    extack);
+	}
+	return err;
+}
+
+static int replace_nexthop_single_notify(struct net *net,
+					 struct nexthop *group_nh,
+					 struct nexthop *old,
+					 struct nh_info *oldi,
+					 struct nh_info *newi,
+					 struct netlink_ext_ack *extack)
+{
+	struct nh_group *nhg =3D rtnl_dereference(group_nh->nh_grp);
+	struct nh_res_table *res_table;
+
+	if (nhg->mpath) {
+		return call_nexthop_notifiers(net, NEXTHOP_EVENT_REPLACE,
+					      group_nh, extack);
+	} else if (nhg->resilient) {
+		res_table =3D rtnl_dereference(nhg->res_table);
+		return replace_nexthop_single_notify_res(net, res_table,
+							 old, oldi, newi,
+							 extack);
+	}
+
+	return -EINVAL;
+}
+
 static int replace_nexthop_single(struct net *net, struct nexthop *old,
 				  struct nexthop *new,
 				  struct netlink_ext_ack *extack)
@@ -1652,8 +1941,8 @@ static int replace_nexthop_single(struct net *net, st=
ruct nexthop *old,
 	list_for_each_entry(nhge, &old->grp_list, nh_list) {
 		struct nexthop *nhp =3D nhge->nh_parent;
=20
-		err =3D call_nexthop_notifiers(net, NEXTHOP_EVENT_REPLACE, nhp,
-					     extack);
+		err =3D replace_nexthop_single_notify(net, nhp, old, oldi, newi,
+						    extack);
 		if (err)
 			goto err_notify;
 	}
@@ -1683,7 +1972,7 @@ static int replace_nexthop_single(struct net *net, st=
ruct nexthop *old,
 	list_for_each_entry_continue_reverse(nhge, &old->grp_list, nh_list) {
 		struct nexthop *nhp =3D nhge->nh_parent;
=20
-		call_nexthop_notifiers(net, NEXTHOP_EVENT_REPLACE, nhp, extack);
+		replace_nexthop_single_notify(net, nhp, old, newi, oldi, NULL);
 	}
 	call_nexthop_notifiers(net, NEXTHOP_EVENT_REPLACE, old, extack);
 	return err;
@@ -1851,13 +2140,20 @@ static int insert_nexthop(struct net *net, struct n=
exthop *new_nh,
 			}
=20
 			nh_res_group_rebalance(nhg, res_table);
-			nh_res_table_upkeep(res_table);
+
+			/* Do not send bucket notifications, we do full
+			 * notification below.
+			 */
+			nh_res_table_upkeep(res_table, false);
 		}
 	}
=20
 	rb_link_node_rcu(&new_nh->rb_node, parent, pp);
 	rb_insert_color(&new_nh->rb_node, root);
=20
+	/* The initial insertion is a full notification for mpath as well
+	 * as resilient groups.
+	 */
 	rc =3D call_nexthop_notifiers(net, NEXTHOP_EVENT_REPLACE, new_nh, extack)=
;
 	if (rc)
 		rb_erase(&new_nh->rb_node, &net->nexthop.rb_root);
--=20
2.26.2

