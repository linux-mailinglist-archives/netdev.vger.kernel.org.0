Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74C873140CD
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 21:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233524AbhBHUpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 15:45:50 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:13274 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233050AbhBHUoa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 15:44:30 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6021a2770000>; Mon, 08 Feb 2021 12:43:35 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 8 Feb
 2021 20:43:35 +0000
Received: from yaviefel.local (172.20.145.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 8 Feb 2021
 20:43:31 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [RFC PATCH 04/13] nexthop: Add implementation of resilient next-hop groups
Date:   Mon, 8 Feb 2021 21:42:47 +0100
Message-ID: <dec388d80b682213ed2897d9f4ae40c2c2dd9eb8.1612815058.git.petrm@nvidia.com>
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
        t=1612817015; bh=4OgyQJRX0IKQP6rob5VbwJ6jK52nCjoqGSLWUC8OXPI=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=lhLNTAMHRt0m0guY9VQSMU6xpkE6XGBYeOVvWZMGd7wuntsKw+iSIUPdkrEQAOn5n
         2gn3Va+jTdj2N+z0XfhWOEvgjGyNt+yTvDZn6Vg3JOCerHWYo2soymD3bXCnvggBRN
         bkznntmK/Ik7pxoAC0akEQXJafBxGwD0lkC7YRoziSip3flZNOjxIDQ7gwhC8w6Ivr
         FQCr/a59wHGbI1kpkVGJaquiWvBoCfPNaVhJNDY04ja+GiOEIN6D/Zxsggg9KnDvc+
         BIGqpJta3EP+S1kxJ3nmiByz1dJXWWTaANU+wUaJawMXO+NmDtnsKWKnHDZmSDsy/U
         dcd+W3vFxhWEg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At this moment, there is only one type of next-hop group: an mpath group,
which implements the hash-threshold algorithm.

To select a next hop, hash-threshold algorithm first assigns a range of
hashes to each next hop in the group, and then selects the next hop by
comparing the SKB hash with the individual ranges. When a next hop is
removed from the group, the ranges are recomputed, which leads to
reassignment of parts of hash space from one next hop to another. While
there will usually be some overlap between the previous and the new
distribution, some traffic flows change the next hop that they resolve to.
That causes problems e.g. as established TCP connections are reset, because
the traffic is forwarded to a server that is not familiar with the
connection.

Resilient hashing is a technique to address the above problem. Resilient
next-hop group has another layer of indirection between the group itself
and its constituent next hops: a hash table. The selection algorithm uses a
straightforward modulo operation to choose a hash bucket, and then reads
the next hop that this bucket contains, and forwards traffic there.

This indirection brings an important feature. In the hash-threshold
algorithm, the range of hashes associated with a next hop must be
continuous. With a hash table, mapping between the hash table buckets and
the individual next hops is arbitrary. Therefore when a next hop is deleted
the buckets that held it are simply reassigned to other next hops. When
weights of next hops in a group are altered, it may be possible to choose a
subset of buckets that are currently not used for forwarding traffic, and
use those to satisfy the new next-hop distribution demands, keeping the
"busy" buckets intact. This way, established flows are ideally kept being
forwarded to the same endpoints through the same paths as before the
next-hop group change.

In a nutshell, the algorithm works as follows. Each next hop has a number
of buckets that it wants to have, according to its weight and the number of
buckets in the hash table. In case of an event that might cause bucket
allocation change, the numbers for individual next hops are updated,
similarly to how ranges are updated for mpath group next hops. Following
that, a new "upkeep" algorithm runs, and for idle buckets that belong to a
next hop that is currently occupying more buckets than it wants (it is
"overweight"), it migrates the buckets to one of the next hops that has
fewer buckets than it wants (it is "underweight"). If, after this, there
are still underweight next hops, another upkeep run is scheduled to a
future time.

Chances are there are not enough "idle" buckets to satisfy the new demands.
The algorithm has knobs to select both what it means for a bucket to be
idle, and for whether and when to forcefully migrate buckets if there keeps
being an insufficient number of idle buckets.

There are three users of the resilient data structures.

- The forwarding code accesses them under RCU, and does not modify them
  except for updating the time a selected bucket was last used.

- Netlink code, running under RTNL, which may modify the data.

- The delayed upkeep code, which may modify the data. This runs unlocked,
  and mutual exclusion between the RTNL code and the delayed upkeep is
  maintained by canceling the delayed work synchronously before the RTNL
  code touches anything. Later it restarts the delayed work if necessary.

The RTNL code has to implement next-hop group replacement, next hop
removal, etc. For removal, the mpath code uses a neat trick of having a
backup next hop group structure, doing the necessary changes offline, and
then RCU-swapping them in. However, the hash tables for resilient hashing
are about an order of magnitude larger than the groups themselves (the size
might be e.g. 4K entries), and it was felt that keeping two of them is an
overkill. Both the primary next-hop group and the spare therefore use the
same resilient table, and writers are careful to keep all references valid
for the forwarding code. The hash table references next-hop group entries
from the next-hop group that is currently in the primary role (i.e. not
spare). During the transition from primary to spare, the table references a
mix of both the primary group and the spare. When a next hop is deleted,
the corresponding buckets are not set to NULL, but instead marked as empty,
so that the pointer is valid and can be used by the forwarding code. The
buckets are then migrated to a new next-hop group entry during upkeep. The
only times that the hash table is invalid is the very beginning and very
end of its lifetime. Between those points, it is always kept valid.

This patch introduces the core support code itself. It does not handle
notifications towards drivers, which are kept as if the group were an mpath
one. It does not handle netlink either. The only bit currently exposed to
user space is the new next-hop group type, and that is currently bounced.
There is therefore no way to actually access this code.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 include/net/nexthop.h |  48 +++-
 net/ipv4/nexthop.c    | 521 ++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 551 insertions(+), 18 deletions(-)

diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index 7bc057aee40b..f748431218d9 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -40,6 +40,12 @@ struct nh_config {
=20
 	struct nlattr	*nh_grp;
 	u16		nh_grp_type;
+	u32		nh_grp_res_num_buckets;
+	unsigned long	nh_grp_res_idle_timer;
+	unsigned long	nh_grp_res_unbalanced_timer;
+	bool		nh_grp_res_has_num_buckets;
+	bool		nh_grp_res_has_idle_timer;
+	bool		nh_grp_res_has_unbalanced_timer;
=20
 	struct nlattr	*nh_encap;
 	u16		nh_encap_type;
@@ -63,6 +69,32 @@ struct nh_info {
 	};
 };
=20
+struct nh_res_bucket {
+	struct nh_grp_entry __rcu *nh_entry;
+	atomic_long_t		used_time;
+	unsigned long		migrated_time;
+	bool			occupied;
+	u8			nh_flags;
+};
+
+struct nh_res_table {
+	struct net		*net;
+	u32			nhg_id;
+	struct delayed_work	upkeep_dw;
+
+	/* List of NHGEs that have too few buckets ("uw" for underweight).
+	 * Reclaimed buckets will be given to entries in this list.
+	 */
+	struct list_head	uw_nh_entries;
+	unsigned long		unbalanced_since;
+
+	u32			idle_timer;
+	u32			unbalanced_timer;
+
+	u32			num_nh_buckets;
+	struct nh_res_bucket	nh_buckets[];
+};
+
 struct nh_grp_entry {
 	struct nexthop	*nh;
 	u8		weight;
@@ -71,6 +103,13 @@ struct nh_grp_entry {
 		struct {
 			atomic_t	upper_bound;
 		} mpath;
+		struct {
+			/* Member on uw_nh_entries. */
+			struct list_head	uw_nh_entry;
+
+			u32			count_buckets;
+			u32			wants_buckets;
+		} res;
 	};
=20
 	struct list_head nh_list;
@@ -81,8 +120,11 @@ struct nh_group {
 	struct nh_group		*spare; /* spare group for removals */
 	u16			num_nh;
 	bool			mpath;
+	bool			resilient;
 	bool			fdb_nh;
 	bool			has_v4;
+
+	struct nh_res_table __rcu *res_table;
 	struct nh_grp_entry	nh_entries[];
 };
=20
@@ -212,7 +254,7 @@ static inline bool nexthop_is_multipath(const struct ne=
xthop *nh)
 		struct nh_group *nh_grp;
=20
 		nh_grp =3D rcu_dereference_rtnl(nh->nh_grp);
-		return nh_grp->mpath;
+		return nh_grp->mpath || nh_grp->resilient;
 	}
 	return false;
 }
@@ -227,7 +269,7 @@ static inline unsigned int nexthop_num_path(const struc=
t nexthop *nh)
 		struct nh_group *nh_grp;
=20
 		nh_grp =3D rcu_dereference_rtnl(nh->nh_grp);
-		if (nh_grp->mpath)
+		if (nh_grp->mpath || nh_grp->resilient)
 			rc =3D nh_grp->num_nh;
 	}
=20
@@ -308,7 +350,7 @@ struct fib_nh_common *nexthop_fib_nhc(struct nexthop *n=
h, int nhsel)
 		struct nh_group *nh_grp;
=20
 		nh_grp =3D rcu_dereference_rtnl(nh->nh_grp);
-		if (nh_grp->mpath) {
+		if (nh_grp->mpath || nh_grp->resilient) {
 			nh =3D nexthop_mpath_select(nh_grp, nhsel);
 			if (!nh)
 				return NULL;
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 5d560d381070..4ce282b0a65f 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -183,6 +183,30 @@ static int call_nexthop_notifiers(struct net *net,
 	return notifier_to_errno(err);
 }
=20
+/* There are three users of RES_TABLE, and NHs etc. referenced from there:
+ *
+ * 1) a collection of callbacks for NH maintenance. This operates under
+ *    RTNL,
+ * 2) the delayed work that gradually balances the resilient table,
+ * 3) and nexthop_select_path(), operating under RCU.
+ *
+ * Both the delayed work and the RTNL block are writers, and need to
+ * maintain mutual exclusion. Since there are only two and well-known
+ * writers for each table, the RTNL code can make sure it has exclusive
+ * access thus:
+ *
+ * - Have the DW operate without locking;
+ * - synchronously cancel the DW;
+ * - do the writing;
+ * - if the write was not actually a delete, call upkeep, which schedules
+ *   DW again if necessary.
+ *
+ * The functions that are always called from the RTNL context use
+ * rtnl_dereference(). The functions that can also be called from the DW d=
o
+ * a raw dereference and rely on the above mutual exclusion scheme.
+ */
+#define nh_res_dereference(p) (rcu_dereference_raw(p))
+
 static int call_nexthop_notifier(struct notifier_block *nb, struct net *ne=
t,
 				 enum nexthop_event_type event_type,
 				 struct nexthop *nh,
@@ -241,6 +265,9 @@ static void nexthop_free_group(struct nexthop *nh)
=20
 	WARN_ON(nhg->spare =3D=3D nhg);
=20
+	if (nhg->resilient)
+		vfree(rcu_dereference_raw(nhg->res_table));
+
 	kfree(nhg->spare);
 	kfree(nhg);
 }
@@ -299,6 +326,30 @@ static struct nh_group *nexthop_grp_alloc(u16 num_nh)
 	return nhg;
 }
=20
+static void nh_res_table_upkeep_dw(struct work_struct *work);
+
+static struct nh_res_table *
+nexthop_res_table_alloc(struct net *net, u32 nhg_id, struct nh_config *cfg=
)
+{
+	const u32 num_nh_buckets =3D cfg->nh_grp_res_num_buckets;
+	struct nh_res_table *res_table;
+	unsigned long size;
+
+	size =3D struct_size(res_table, nh_buckets, num_nh_buckets);
+	res_table =3D __vmalloc(size, GFP_KERNEL | __GFP_ZERO | __GFP_NOWARN);
+	if (!res_table)
+		return NULL;
+
+	res_table->net =3D net;
+	res_table->nhg_id =3D nhg_id;
+	INIT_DELAYED_WORK(&res_table->upkeep_dw, &nh_res_table_upkeep_dw);
+	INIT_LIST_HEAD(&res_table->uw_nh_entries);
+	res_table->idle_timer =3D cfg->nh_grp_res_idle_timer;
+	res_table->unbalanced_timer =3D cfg->nh_grp_res_unbalanced_timer;
+	res_table->num_nh_buckets =3D num_nh_buckets;
+	return res_table;
+}
+
 static void nh_base_seq_inc(struct net *net)
 {
 	while (++net->nexthop.seq =3D=3D 0)
@@ -347,6 +398,13 @@ static u32 nh_find_unused_id(struct net *net)
 	return 0;
 }
=20
+static void nh_res_time_set_deadline(unsigned long next_time,
+				     unsigned long *deadline)
+{
+	if (time_before(next_time, *deadline))
+		*deadline =3D next_time;
+}
+
 static int nla_put_nh_group(struct sk_buff *skb, struct nh_group *nhg)
 {
 	struct nexthop_grp *p;
@@ -540,20 +598,62 @@ static void nexthop_notify(int event, struct nexthop =
*nh, struct nl_info *info)
 		rtnl_set_sk_err(info->nl_net, RTNLGRP_NEXTHOP, err);
 }
=20
+static unsigned long nh_res_bucket_used_time(const struct nh_res_bucket *b=
ucket)
+{
+	return (unsigned long)atomic_long_read(&bucket->used_time);
+}
+
+static unsigned long
+nh_res_bucket_idle_point(const struct nh_res_table *res_table,
+			 const struct nh_res_bucket *bucket,
+			 unsigned long now)
+{
+	unsigned long time =3D nh_res_bucket_used_time(bucket);
+
+	/* Bucket was not used since it was migrated. The idle time is now. */
+	if (time =3D=3D bucket->migrated_time)
+		return now;
+
+	return time + res_table->idle_timer;
+}
+
+static unsigned long
+nh_res_table_unb_point(const struct nh_res_table *res_table)
+{
+	return res_table->unbalanced_since + res_table->unbalanced_timer;
+}
+
+static void nh_res_bucket_set_idle(const struct nh_res_table *res_table,
+				   struct nh_res_bucket *bucket)
+{
+	unsigned long now =3D jiffies;
+
+	atomic_long_set(&bucket->used_time, (long)now);
+	bucket->migrated_time =3D now;
+}
+
+static void nh_res_bucket_set_busy(struct nh_res_bucket *bucket)
+{
+	atomic_long_set(&bucket->used_time, (long)jiffies);
+}
+
 static bool valid_group_nh(struct nexthop *nh, unsigned int npaths,
 			   bool *is_fdb, struct netlink_ext_ack *extack)
 {
 	if (nh->is_group) {
 		struct nh_group *nhg =3D rtnl_dereference(nh->nh_grp);
=20
-		/* nested multipath (group within a group) is not
-		 * supported
-		 */
+		/* Nesting groups within groups is not supported. */
 		if (nhg->mpath) {
 			NL_SET_ERR_MSG(extack,
 				       "Multipath group can not be a nexthop within a group");
 			return false;
 		}
+		if (nhg->resilient) {
+			NL_SET_ERR_MSG(extack,
+				       "Resilient group can not be a nexthop within a group");
+			return false;
+		}
 		*is_fdb =3D nhg->fdb_nh;
 	} else {
 		struct nh_info *nhi =3D rtnl_dereference(nh->nh_info);
@@ -734,6 +834,22 @@ static struct nexthop *nexthop_select_path_mp(struct n=
h_group *nhg, int hash)
 	return rc;
 }
=20
+static struct nexthop *nexthop_select_path_res(struct nh_group *nhg, int h=
ash)
+{
+	struct nh_res_table *res_table =3D rcu_dereference(nhg->res_table);
+	u32 bucket_index =3D hash % res_table->num_nh_buckets;
+	struct nh_res_bucket *bucket;
+	struct nh_grp_entry *nhge;
+
+	/* nexthop_select_path() is expected to return a non-NULL value, so
+	 * skip protocol validation and just hand out whatever there is.
+	 */
+	bucket =3D &res_table->nh_buckets[bucket_index];
+	nh_res_bucket_set_busy(bucket);
+	nhge =3D rcu_dereference(bucket->nh_entry);
+	return nhge->nh;
+}
+
 struct nexthop *nexthop_select_path(struct nexthop *nh, int hash)
 {
 	struct nh_group *nhg;
@@ -744,6 +860,8 @@ struct nexthop *nexthop_select_path(struct nexthop *nh,=
 int hash)
 	nhg =3D rcu_dereference(nh->nh_grp);
 	if (nhg->mpath)
 		return nexthop_select_path_mp(nhg, hash);
+	else if (nhg->resilient)
+		return nexthop_select_path_res(nhg, hash);
=20
 	/* Unreachable. */
 	return NULL;
@@ -926,7 +1044,289 @@ static int fib_check_nh_list(struct nexthop *old, st=
ruct nexthop *new,
 	return 0;
 }
=20
-static void nh_group_rebalance(struct nh_group *nhg)
+static bool nh_res_nhge_is_balanced(const struct nh_grp_entry *nhge)
+{
+	return nhge->res.count_buckets =3D=3D nhge->res.wants_buckets;
+}
+
+static bool nh_res_nhge_is_ow(const struct nh_grp_entry *nhge)
+{
+	return nhge->res.count_buckets > nhge->res.wants_buckets;
+}
+
+static bool nh_res_nhge_is_uw(const struct nh_grp_entry *nhge)
+{
+	return nhge->res.count_buckets < nhge->res.wants_buckets;
+}
+
+static bool nh_res_table_is_balanced(const struct nh_res_table *res_table)
+{
+	return list_empty(&res_table->uw_nh_entries);
+}
+
+static void nh_res_bucket_unset_nh(struct nh_res_bucket *bucket)
+{
+	struct nh_grp_entry *nhge;
+
+	if (bucket->occupied) {
+		nhge =3D nh_res_dereference(bucket->nh_entry);
+		nhge->res.count_buckets--;
+		bucket->occupied =3D false;
+	}
+}
+
+static void nh_res_bucket_set_nh(struct nh_res_bucket *bucket,
+				 struct nh_grp_entry *nhge)
+{
+	nh_res_bucket_unset_nh(bucket);
+
+	bucket->occupied =3D true;
+	rcu_assign_pointer(bucket->nh_entry, nhge);
+	nhge->res.count_buckets++;
+}
+
+static bool nh_res_bucket_should_migrate(struct nh_res_table *res_table,
+					 struct nh_res_bucket *bucket,
+					 unsigned long *deadline, bool *force)
+{
+	unsigned long now =3D jiffies;
+	struct nh_grp_entry *nhge;
+	unsigned long idle_point;
+
+	if (!bucket->occupied) {
+		/* The bucket is not occupied, its NHGE pointer is either
+		 * NULL or obsolete. We _have to_ migrate: set force.
+		 */
+		*force =3D true;
+		return true;
+	}
+
+	nhge =3D nh_res_dereference(bucket->nh_entry);
+
+	/* If the bucket is populated by an underweight or balanced
+	 * nexthop, do not migrate.
+	 */
+	if (!nh_res_nhge_is_ow(nhge))
+		return false;
+
+	/* At this point we know that the bucket is populated with an
+	 * overweight nexthop. It needs to be migrated to a new nexthop if
+	 * the idle timer of unbalanced timer expired.
+	 */
+
+	idle_point =3D nh_res_bucket_idle_point(res_table, bucket, now);
+	if (time_after_eq(now, idle_point)) {
+		/* The bucket is idle. We _can_ migrate: unset force. */
+		*force =3D false;
+		return true;
+	}
+
+	/* Unbalanced timer of 0 means "never force". */
+	if (res_table->unbalanced_timer) {
+		unsigned long unb_point;
+
+		unb_point =3D nh_res_table_unb_point(res_table);
+		if (time_after(now, unb_point)) {
+			/* The bucket is not idle, but the unbalanced timer
+			 * expired. We _can_ migrate, but set force anyway,
+			 * so that drivers know to ignore activity reports
+			 * from the HW.
+			 */
+			*force =3D true;
+			return true;
+		}
+
+		nh_res_time_set_deadline(unb_point, deadline);
+	}
+
+	nh_res_time_set_deadline(idle_point, deadline);
+	return false;
+}
+
+static bool nh_res_bucket_migrate(struct nh_res_table *res_table,
+				  u32 bucket_index, bool force)
+{
+	struct nh_res_bucket *bucket =3D &res_table->nh_buckets[bucket_index];
+	struct nh_grp_entry *new_nhge;
+
+	new_nhge =3D list_first_entry_or_null(&res_table->uw_nh_entries,
+					    struct nh_grp_entry,
+					    res.uw_nh_entry);
+	if (WARN_ON_ONCE(!new_nhge))
+		/* If this function is called, "bucket" is either not
+		 * occupied, or it belongs to a next hop that is
+		 * overweight. In either case, there ought to be a
+		 * corresponding underweight next hop.
+		 */
+		return false;
+
+	nh_res_bucket_set_nh(bucket, new_nhge);
+	nh_res_bucket_set_idle(res_table, bucket);
+
+	if (nh_res_nhge_is_balanced(new_nhge))
+		list_del(&new_nhge->res.uw_nh_entry);
+	return true;
+}
+
+#define NH_RES_UPKEEP_DW_MINIMUM_INTERVAL (HZ / 2)
+
+static void nh_res_table_upkeep(struct nh_res_table *res_table)
+{
+	unsigned long now =3D jiffies;
+	unsigned long deadline;
+	u32 i;
+
+	/* Deadline is the next time that upkeep should be run. It is the
+	 * earliest time at which one of the buckets might be migrated.
+	 * Start at the most pessimistic estimate: either unbalanced_timer
+	 * from now, or if there is none, idle_timer from now. For each
+	 * encountered time point, call nh_res_time_set_deadline() to
+	 * refine the estimate.
+	 */
+	if (res_table->unbalanced_timer)
+		deadline =3D now + res_table->unbalanced_timer;
+	else
+		deadline =3D now + res_table->idle_timer;
+
+	for (i =3D 0; i < res_table->num_nh_buckets; i++) {
+		struct nh_res_bucket *bucket =3D &res_table->nh_buckets[i];
+		bool force;
+
+		if (nh_res_bucket_should_migrate(res_table, bucket,
+						 &deadline, &force)) {
+			if (!nh_res_bucket_migrate(res_table, i, force)) {
+				unsigned long idle_point;
+
+				/* A driver can override the migration
+				 * decision if it the HW reports that the
+				 * bucket is actually not idle. Therefore
+				 * remark the bucket as busy again and
+				 * update the deadline.
+				 */
+				nh_res_bucket_set_busy(bucket);
+				idle_point =3D nh_res_bucket_idle_point(res_table,
+								      bucket,
+								      now);
+				nh_res_time_set_deadline(idle_point, &deadline);
+			}
+		}
+	}
+
+	/* If the group is still unbalanced, schedule the next upkeep to
+	 * either the deadline computed above, or the minimum deadline,
+	 * whichever comes later.
+	 */
+	if (!nh_res_table_is_balanced(res_table)) {
+		unsigned long now =3D jiffies;
+		unsigned long min_deadline;
+
+		min_deadline =3D now + NH_RES_UPKEEP_DW_MINIMUM_INTERVAL;
+		if (time_before(deadline, min_deadline))
+			deadline =3D min_deadline;
+
+		queue_delayed_work(system_power_efficient_wq,
+				   &res_table->upkeep_dw, deadline - now);
+	}
+}
+
+static void nh_res_table_upkeep_dw(struct work_struct *work)
+{
+	struct delayed_work *dw =3D to_delayed_work(work);
+	struct nh_res_table *res_table;
+
+	res_table =3D container_of(dw, struct nh_res_table, upkeep_dw);
+	nh_res_table_upkeep(res_table);
+}
+
+static void nh_res_table_cancel_upkeep(struct nh_res_table *res_table)
+{
+	cancel_delayed_work_sync(&res_table->upkeep_dw);
+}
+
+static void nh_res_group_rebalance(struct nh_group *nhg,
+				   struct nh_res_table *res_table)
+{
+	int prev_upper_bound =3D 0;
+	int total =3D 0;
+	int w =3D 0;
+	int i;
+
+	INIT_LIST_HEAD(&res_table->uw_nh_entries);
+
+	for (i =3D 0; i < nhg->num_nh; ++i)
+		total +=3D nhg->nh_entries[i].weight;
+
+	for (i =3D 0; i < nhg->num_nh; ++i) {
+		struct nh_grp_entry *nhge =3D &nhg->nh_entries[i];
+		int upper_bound;
+
+		w +=3D nhge->weight;
+		upper_bound =3D DIV_ROUND_CLOSEST(res_table->num_nh_buckets * w,
+						total);
+		nhge->res.wants_buckets =3D upper_bound - prev_upper_bound;
+		prev_upper_bound =3D upper_bound;
+
+		if (nh_res_nhge_is_uw(nhge)) {
+			if (list_empty(&res_table->uw_nh_entries))
+				res_table->unbalanced_since =3D jiffies;
+			list_add(&nhge->res.uw_nh_entry,
+				 &res_table->uw_nh_entries);
+		}
+	}
+}
+
+/* Migrate buckets in res_table so that they reference NHGE's from NHG wit=
h
+ * the right NH ID. Set those buckets that do not have a corresponding NHG=
E
+ * entry in NHG as not occupied.
+ */
+static void nh_res_table_migrate_buckets(struct nh_res_table *res_table,
+					 struct nh_group *nhg)
+{
+	u32 i;
+
+	for (i =3D 0; i < res_table->num_nh_buckets; i++) {
+		struct nh_res_bucket *bucket =3D &res_table->nh_buckets[i];
+		u32 id =3D rtnl_dereference(bucket->nh_entry)->nh->id;
+		bool found =3D false;
+		int j;
+
+		for (j =3D 0; j < nhg->num_nh; j++) {
+			struct nh_grp_entry *nhge =3D &nhg->nh_entries[j];
+
+			if (nhge->nh->id =3D=3D id) {
+				nh_res_bucket_set_nh(bucket, nhge);
+				found =3D true;
+				break;
+			}
+		}
+
+		if (!found)
+			nh_res_bucket_unset_nh(bucket);
+	}
+}
+
+static void replace_nexthop_grp_res(struct nh_group *oldg,
+				    struct nh_group *newg)
+{
+	/* For NH group replacement, the new NHG might only have a stub
+	 * hash table with 0 buckets, because the number of buckets was not
+	 * specified. For NH removal, oldg and newg both reference the same
+	 * res_table. So in any case, in the following, we want to work
+	 * with oldg->res_table.
+	 */
+	struct nh_res_table *old_res_table =3D rtnl_dereference(oldg->res_table);
+	unsigned long prev_unbalanced_since =3D old_res_table->unbalanced_since;
+	bool prev_has_uw =3D !list_empty(&old_res_table->uw_nh_entries);
+
+	nh_res_table_cancel_upkeep(old_res_table);
+	nh_res_table_migrate_buckets(old_res_table, newg);
+	nh_res_group_rebalance(newg, old_res_table);
+	if (prev_has_uw && !list_empty(&old_res_table->uw_nh_entries))
+		old_res_table->unbalanced_since =3D prev_unbalanced_since;
+	nh_res_table_upkeep(old_res_table);
+}
+
+static void nh_mp_group_rebalance(struct nh_group *nhg)
 {
 	int total =3D 0;
 	int w =3D 0;
@@ -968,6 +1368,7 @@ static void remove_nh_grp_entry(struct net *net, struc=
t nh_grp_entry *nhge,
=20
 	newg->has_v4 =3D false;
 	newg->mpath =3D nhg->mpath;
+	newg->resilient =3D nhg->resilient;
 	newg->fdb_nh =3D nhg->fdb_nh;
 	newg->num_nh =3D nhg->num_nh;
=20
@@ -995,7 +1396,11 @@ static void remove_nh_grp_entry(struct net *net, stru=
ct nh_grp_entry *nhge,
 		j++;
 	}
=20
-	nh_group_rebalance(newg);
+	if (newg->mpath)
+		nh_mp_group_rebalance(newg);
+	else if (newg->resilient)
+		replace_nexthop_grp_res(nhg, newg);
+
 	rcu_assign_pointer(nhp->nh_grp, newg);
=20
 	list_del(&nhge->nh_list);
@@ -1024,6 +1429,7 @@ static void remove_nexthop_from_groups(struct net *ne=
t, struct nexthop *nh,
 static void remove_nexthop_group(struct nexthop *nh, struct nl_info *nlinf=
o)
 {
 	struct nh_group *nhg =3D rcu_dereference_rtnl(nh->nh_grp);
+	struct nh_res_table *res_table;
 	int i, num_nh =3D nhg->num_nh;
=20
 	for (i =3D 0; i < num_nh; ++i) {
@@ -1034,6 +1440,11 @@ static void remove_nexthop_group(struct nexthop *nh,=
 struct nl_info *nlinfo)
=20
 		list_del_init(&nhge->nh_list);
 	}
+
+	if (nhg->resilient) {
+		res_table =3D rtnl_dereference(nhg->res_table);
+		nh_res_table_cancel_upkeep(res_table);
+	}
 }
=20
 /* not called for nexthop replace */
@@ -1112,6 +1523,9 @@ static int replace_nexthop_grp(struct net *net, struc=
t nexthop *old,
 			       struct nexthop *new, const struct nh_config *cfg,
 			       struct netlink_ext_ack *extack)
 {
+	struct nh_res_table *tmp_table =3D NULL;
+	struct nh_res_table *new_res_table;
+	struct nh_res_table *old_res_table;
 	struct nh_group *oldg, *newg;
 	int i, err;
=20
@@ -1120,19 +1534,57 @@ static int replace_nexthop_grp(struct net *net, str=
uct nexthop *old,
 		return -EINVAL;
 	}
=20
-	err =3D call_nexthop_notifiers(net, NEXTHOP_EVENT_REPLACE, new, extack);
-	if (err)
-		return err;
-
 	oldg =3D rtnl_dereference(old->nh_grp);
 	newg =3D rtnl_dereference(new->nh_grp);
=20
+	if (newg->mpath !=3D oldg->mpath) {
+		NL_SET_ERR_MSG(extack, "Can not replace a nexthop group with one of a di=
fferent type.");
+		return -EINVAL;
+	}
+
+	if (newg->mpath) {
+		err =3D call_nexthop_notifiers(net, NEXTHOP_EVENT_REPLACE, new,
+					     extack);
+		if (err)
+			return err;
+	} else if (newg->resilient) {
+		new_res_table =3D rtnl_dereference(newg->res_table);
+		old_res_table =3D rtnl_dereference(oldg->res_table);
+
+		/* Accept if num_nh_buckets was not given, but if it was
+		 * given, demand that the value be correct.
+		 */
+		if (cfg->nh_grp_res_has_num_buckets &&
+		    cfg->nh_grp_res_num_buckets !=3D
+		    old_res_table->num_nh_buckets) {
+			NL_SET_ERR_MSG(extack, "Can not change number of buckets of a resilient=
 nexthop group.");
+			return -EINVAL;
+		}
+
+		if (cfg->nh_grp_res_has_idle_timer)
+			old_res_table->idle_timer =3D cfg->nh_grp_res_idle_timer;
+		if (cfg->nh_grp_res_has_unbalanced_timer)
+			old_res_table->unbalanced_timer =3D
+				cfg->nh_grp_res_unbalanced_timer;
+
+		replace_nexthop_grp_res(oldg, newg);
+
+		tmp_table =3D new_res_table;
+		rcu_assign_pointer(newg->res_table, old_res_table);
+		rcu_assign_pointer(newg->spare->res_table, old_res_table);
+	}
+
 	/* update parents - used by nexthop code for cleanup */
 	for (i =3D 0; i < newg->num_nh; i++)
 		newg->nh_entries[i].nh_parent =3D old;
=20
 	rcu_assign_pointer(old->nh_grp, newg);
=20
+	if (newg->resilient) {
+		rcu_assign_pointer(oldg->res_table, tmp_table);
+		rcu_assign_pointer(oldg->spare->res_table, tmp_table);
+	}
+
 	for (i =3D 0; i < oldg->num_nh; i++)
 		oldg->nh_entries[i].nh_parent =3D new;
=20
@@ -1382,6 +1834,27 @@ static int insert_nexthop(struct net *net, struct ne=
xthop *new_nh,
 		goto out;
 	}
=20
+	if (new_nh->is_group) {
+		struct nh_group *nhg =3D rtnl_dereference(new_nh->nh_grp);
+		struct nh_res_table *res_table;
+
+		if (nhg->resilient) {
+			res_table =3D rtnl_dereference(nhg->res_table);
+
+			/* Not passing the number of buckets is OK when
+			 * replacing, but not when creating a new group.
+			 */
+			if (!cfg->nh_grp_res_has_num_buckets) {
+				NL_SET_ERR_MSG(extack, "Number of buckets not specified for nexthop gr=
oup insertion");
+				rc =3D -EINVAL;
+				goto out;
+			}
+
+			nh_res_group_rebalance(nhg, res_table);
+			nh_res_table_upkeep(res_table);
+		}
+	}
+
 	rb_link_node_rcu(&new_nh->rb_node, parent, pp);
 	rb_insert_color(&new_nh->rb_node, root);
=20
@@ -1440,6 +1913,7 @@ static struct nexthop *nexthop_create_group(struct ne=
t *net,
 	u16 num_nh =3D nla_len(grps_attr) / sizeof(*entry);
 	struct nh_group *nhg;
 	struct nexthop *nh;
+	int err;
 	int i;
=20
 	if (WARN_ON(!num_nh))
@@ -1471,8 +1945,10 @@ static struct nexthop *nexthop_create_group(struct n=
et *net,
 		struct nh_info *nhi;
=20
 		nhe =3D nexthop_find_by_id(net, entry[i].id);
-		if (!nexthop_get(nhe))
+		if (!nexthop_get(nhe)) {
+			err =3D -ENOENT;
 			goto out_no_nh;
+		}
=20
 		nhi =3D rtnl_dereference(nhe->nh_info);
 		if (nhi->family =3D=3D AF_INET)
@@ -1484,15 +1960,30 @@ static struct nexthop *nexthop_create_group(struct =
net *net,
 		nhg->nh_entries[i].nh_parent =3D nh;
 	}
=20
-	if (cfg->nh_grp_type =3D=3D NEXTHOP_GRP_TYPE_MPATH)
+	if (cfg->nh_grp_type =3D=3D NEXTHOP_GRP_TYPE_MPATH) {
 		nhg->mpath =3D 1;
-	else if (cfg->nh_grp_type =3D=3D NEXTHOP_GRP_TYPE_RES)
+	} else if (cfg->nh_grp_type =3D=3D NEXTHOP_GRP_TYPE_RES) {
+		struct nh_res_table *res_table;
+
+		/* Bounce resilient groups for now. */
+		err =3D -EINVAL;
 		goto out_no_nh;
=20
-	WARN_ON_ONCE(nhg->mpath !=3D 1);
+		res_table =3D nexthop_res_table_alloc(net, cfg->nh_id, cfg);
+		if (!res_table) {
+			err =3D -ENOMEM;
+			goto out_no_nh;
+		}
+
+		rcu_assign_pointer(nhg->spare->res_table, res_table);
+		rcu_assign_pointer(nhg->res_table, res_table);
+		nhg->resilient =3D true;
+	}
+
+	WARN_ON_ONCE(nhg->mpath + nhg->resilient !=3D 1);
=20
 	if (nhg->mpath)
-		nh_group_rebalance(nhg);
+		nh_mp_group_rebalance(nhg);
=20
 	if (cfg->nh_fdb)
 		nhg->fdb_nh =3D 1;
@@ -1511,7 +2002,7 @@ static struct nexthop *nexthop_create_group(struct ne=
t *net,
 	kfree(nhg);
 	kfree(nh);
=20
-	return ERR_PTR(-ENOENT);
+	return ERR_PTR(err);
 }
=20
 static int nh_create_ipv4(struct net *net, struct nexthop *nh,
--=20
2.26.2

