Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD3EA303EAA
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 14:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392531AbhAZN06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 08:26:58 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:40595 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391856AbhAZNZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 08:25:12 -0500
Received: from compute7.internal (compute7.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id A3F7B976;
        Tue, 26 Jan 2021 08:24:14 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute7.internal (MEProxy); Tue, 26 Jan 2021 08:24:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=SsmYjYgboRyfeb361FQir7mBhplbRgrqIi7i9Z5vqe4=; b=Ro6RlqJs
        meJIvvC3KrfIG/WjDHrfCKN/sPc2UFsrAr8E1XDYObvfbBxTtOqm2Dp+/1eYHFMK
        G8+lnLQJJMtk8DQJtUjB0ZYfHnPUvOnRMOF+00r10byFQVRNZ/iFu8pfEZDTreZR
        nWQ5v286YT9UQmVLC6E+fYFkYKScfgc1AneL6NBy2MW3V15XbxkLTCgqT3lbkpq7
        /7XG5iWuwk0HdyDX0OOSRWSzcYmD8ZjO/xPzzywctfJ0kxiNUAyoEG94Mta8tQLe
        frN6udQ6xULPJ41Xd2AlzO28RdG6Xos9fXMsPAR5+QCvKiabuuyoG0BHdbxH3q3t
        ecLRAPRus6W+yg==
X-ME-Sender: <xms:_hcQYCD6B1o32YafLQn9fdqbMuTqj8eWLcfPNQLowHMfVWK8c_1VTg>
    <xme:_hcQYMfAEz6HcRKPm9YgO6S00mU733bzH6wolxjIBnbZEHtTsGFIuyEiLcBkpqDjx
    YKlMphwz2p21Wo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehgdehudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheefrdeggeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:_hcQYCfUNBgqIg7Ra_sHWb49IvJtFXOY0ugtfGPU9VI_BqjfgXjdlA>
    <xmx:_hcQYIhLuOx39IYT83YZ90SmlllYafqYj_SHf-LNS1BZoiTFNgm6Ng>
    <xmx:_hcQYGRis_6I-l-A_xbpTFktmNXi44LmGz9QpgxgUNUMdWjinsZdIg>
    <xmx:_hcQYEVECEEK264emlcxmMxzw0ZTaSXH6p1tZwtwg4dBtjf4HWCkEg>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 964581080066;
        Tue, 26 Jan 2021 08:24:11 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        amcohen@nvidia.com, roopa@nvidia.com, sharpd@nvidia.com,
        bpoirier@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 01/10] netdevsim: fib: Convert the current occupancy to an atomic variable
Date:   Tue, 26 Jan 2021 15:23:02 +0200
Message-Id: <20210126132311.3061388-2-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210126132311.3061388-1-idosch@idosch.org>
References: <20210126132311.3061388-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

When route is added/deleted, the appropriate counter is increased/decreased
to maintain number of routes.

User can limit the number of routes and then according to the appropriate
counter, adding more routes than the limitation is forbidden.

Currently, there is one lock which protects hashtable, list and accounting.

Handling the counters will be performed from both atomic context and
non-atomic context, while the hashtable and the list will be used only from
non-atomic context and therefore will be protected by a separate lock.

Protect accounting by using an atomic variable, so lock is not needed.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/netdevsim/fib.c | 56 ++++++++++++++++++-------------------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index 45d8a7790bd5..3f48c0883225 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -31,7 +31,7 @@
 
 struct nsim_fib_entry {
 	u64 max;
-	u64 num;
+	atomic64_t num;
 };
 
 struct nsim_per_fib_data {
@@ -46,7 +46,7 @@ struct nsim_fib_data {
 	struct nsim_fib_entry nexthops;
 	struct rhashtable fib_rt_ht;
 	struct list_head fib_rt_list;
-	spinlock_t fib_lock;	/* Protects hashtable, list and accounting */
+	spinlock_t fib_lock;	/* Protects hashtable and list */
 	struct notifier_block nexthop_nb;
 	struct rhashtable nexthop_ht;
 	struct devlink *devlink;
@@ -128,7 +128,7 @@ u64 nsim_fib_get_val(struct nsim_fib_data *fib_data,
 		return 0;
 	}
 
-	return max ? entry->max : entry->num;
+	return max ? entry->max : atomic64_read(&entry->num);
 }
 
 static void nsim_fib_set_max(struct nsim_fib_data *fib_data,
@@ -165,14 +165,12 @@ static int nsim_fib_rule_account(struct nsim_fib_entry *entry, bool add,
 	int err = 0;
 
 	if (add) {
-		if (entry->num < entry->max) {
-			entry->num++;
-		} else {
+		if (!atomic64_add_unless(&entry->num, 1, entry->max)) {
 			err = -ENOSPC;
 			NL_SET_ERR_MSG_MOD(extack, "Exceeded number of supported fib rule entries");
 		}
 	} else {
-		entry->num--;
+		atomic64_dec_if_positive(&entry->num);
 	}
 
 	return err;
@@ -202,14 +200,12 @@ static int nsim_fib_account(struct nsim_fib_entry *entry, bool add,
 	int err = 0;
 
 	if (add) {
-		if (entry->num < entry->max) {
-			entry->num++;
-		} else {
+		if (!atomic64_add_unless(&entry->num, 1, entry->max)) {
 			err = -ENOSPC;
 			NL_SET_ERR_MSG_MOD(extack, "Exceeded number of supported fib entries");
 		}
 	} else {
-		entry->num--;
+		atomic64_dec_if_positive(&entry->num);
 	}
 
 	return err;
@@ -769,25 +765,22 @@ static int nsim_fib_event_nb(struct notifier_block *nb, unsigned long event,
 	struct fib_notifier_info *info = ptr;
 	int err = 0;
 
-	/* IPv6 routes can be added via RAs from softIRQ. */
-	spin_lock_bh(&data->fib_lock);
-
 	switch (event) {
 	case FIB_EVENT_RULE_ADD:
 	case FIB_EVENT_RULE_DEL:
 		err = nsim_fib_rule_event(data, info,
 					  event == FIB_EVENT_RULE_ADD);
 		break;
-
 	case FIB_EVENT_ENTRY_REPLACE:
 	case FIB_EVENT_ENTRY_APPEND:
 	case FIB_EVENT_ENTRY_DEL:
+		/* IPv6 routes can be added via RAs from softIRQ. */
+		spin_lock_bh(&data->fib_lock);
 		err = nsim_fib_event(data, info, event);
+		spin_unlock_bh(&data->fib_lock);
 		break;
 	}
 
-	spin_unlock_bh(&data->fib_lock);
-
 	return notifier_from_errno(err);
 }
 
@@ -847,8 +840,8 @@ static void nsim_fib_dump_inconsistent(struct notifier_block *nb)
 		nsim_fib_rt_free(fib_rt, data);
 	}
 
-	data->ipv4.rules.num = 0ULL;
-	data->ipv6.rules.num = 0ULL;
+	atomic64_set(&data->ipv4.rules.num, 0ULL);
+	atomic64_set(&data->ipv6.rules.num, 0ULL);
 }
 
 static struct nsim_nexthop *nsim_nexthop_create(struct nsim_fib_data *data,
@@ -889,22 +882,29 @@ static void nsim_nexthop_destroy(struct nsim_nexthop *nexthop)
 static int nsim_nexthop_account(struct nsim_fib_data *data, u64 occ,
 				bool add, struct netlink_ext_ack *extack)
 {
-	int err = 0;
+	int i, err = 0;
 
 	if (add) {
-		if (data->nexthops.num + occ <= data->nexthops.max) {
-			data->nexthops.num += occ;
-		} else {
-			err = -ENOSPC;
-			NL_SET_ERR_MSG_MOD(extack, "Exceeded number of supported nexthops");
-		}
+		for (i = 0; i < occ; i++)
+			if (!atomic64_add_unless(&data->nexthops.num, 1,
+						 data->nexthops.max)) {
+				err = -ENOSPC;
+				NL_SET_ERR_MSG_MOD(extack, "Exceeded number of supported nexthops");
+				goto err_num_decrease;
+			}
 	} else {
-		if (WARN_ON(occ > data->nexthops.num))
+		if (WARN_ON(occ > atomic64_read(&data->nexthops.num)))
 			return -EINVAL;
-		data->nexthops.num -= occ;
+		atomic64_sub(occ, &data->nexthops.num);
 	}
 
 	return err;
+
+err_num_decrease:
+	for (i--; i >= 0; i--)
+		atomic64_dec(&data->nexthops.num);
+	return err;
+
 }
 
 static int nsim_nexthop_add(struct nsim_fib_data *data,
-- 
2.29.2

