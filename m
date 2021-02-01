Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24B1530B0D0
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 20:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232768AbhBATvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 14:51:41 -0500
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:55215 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231868AbhBATtr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 14:49:47 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 363A8580436;
        Mon,  1 Feb 2021 14:48:41 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 01 Feb 2021 14:48:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=Fnl4B91G1tjsob2Ju8/a/wq2zj1vfaoTlf0/Nw3FNL8=; b=rLS7RMjt
        dKBrTjkHUfAbfqHGCZjBZmNtQGO1ncgInDewtV3l01zdEWO6HupiRiT/0YUQZVeU
        0daAtBLtrrXZynBsfu2GiQPv2c/2XAPM663qSa4JTQ88XxCVuZ0AilP9rXhVIQYU
        P5lrJOUna+a70xwz1eypFXRsfT/RxeVVBTQsxfg16cVVDAE7QuYvU7kqL145GdEz
        WjpQOL1C/anFddsvYeO0gFr9/evBU4+4fNIKur/xuxe3IpYHls7v6FSCIuI5Kl61
        GgryZUmkalmnhgtJDNRNrmcm3ejvQvHtmNgau/yo5+BzNhKrlkJOj80zVdXfMOAM
        JwT6Ci5tbxBLNw==
X-ME-Sender: <xms:GVsYYKb3Ecy5RD22dlJhY-25X15cSwd_dzPR-nAoTYEAI6w4p8gyoQ>
    <xme:GVsYYNaxI5Gyh_ITGkLcuGuyp0P46ty85ipKA8rme8hC5mzW2P7QfrPNQvZKK8RgE
    A6wzrJg7JMe7nY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeekgddufedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:GVsYYE9UoVoyG8ekOu6pHMbUEmrMkr01DrNK-ZUXA3RWjl80Z9P9Ag>
    <xmx:GVsYYMpLJwhscmLQQtLb7Kshc94nUHuhVxEQdfSUOrHme5lT1PpYlw>
    <xmx:GVsYYFqFTg1jo5V_wqQrBJclqYOXPz4zHwcVYzZx8Icw0-GCa1NO5g>
    <xmx:GVsYYJfuGVG16jjScxuGNKwuGxkpMPKQ_ST3KCRtwDZrB-MrF2PQyA>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5882924005C;
        Mon,  1 Feb 2021 14:48:38 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        yoshfuji@linux-ipv6.org, jiri@nvidia.com, amcohen@nvidia.com,
        roopa@nvidia.com, bpoirier@nvidia.com, sharpd@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 01/10] netdevsim: fib: Convert the current occupancy to an atomic variable
Date:   Mon,  1 Feb 2021 21:47:48 +0200
Message-Id: <20210201194757.3463461-2-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210201194757.3463461-1-idosch@idosch.org>
References: <20210201194757.3463461-1-idosch@idosch.org>
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

v2:
* Use atomic64_sub() in nsim_nexthop_account()'s error path

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/netdevsim/fib.c | 55 ++++++++++++++++++-------------------
 1 file changed, 27 insertions(+), 28 deletions(-)

diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index f140bbca98c5..7be603e06769 100644
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
@@ -894,22 +887,28 @@ static void nsim_nexthop_destroy(struct nsim_nexthop *nexthop)
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
+	atomic64_sub(i, &data->nexthops.num);
+	return err;
+
 }
 
 static int nsim_nexthop_add(struct nsim_fib_data *data,
-- 
2.29.2

