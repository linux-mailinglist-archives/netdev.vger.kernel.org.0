Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02C7C3EFCBF
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 08:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238388AbhHRGaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 02:30:12 -0400
Received: from dispatch1-eu1.ppe-hosted.com ([185.132.181.8]:56896 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237947AbhHRGaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 02:30:11 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05lp2171.outbound.protection.outlook.com [104.47.17.171])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id D81A474007B;
        Wed, 18 Aug 2021 06:29:34 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NPMVeC+NKkpwn/jofz6DqJadInlw80sgAXToXl72A+p2Esa0FTpN5c3u7twrOrSbfXaJNSOsn+XOkUBY+B6KbMkeePJmUswezmsdF2+YLVtTy3U3Mej102JqTH7e03BhIFVuedvpy9h1OkET3MzbgCbziDkvo0/h8XoLPEqQTrOUfQt9YbPEzm6Dh/xYH2gdFbrQo6t6OXe6cTvhT1svDNJDoalu1ltPow7TdrmzgYEC745xVuztRZJKNj5oRRnLM8kWwXXqKvX8lAQGe2akfHxvMdNv2tjtXn/v1JMsOrBQpmRwai/2DpHm9hUxtMeIsJsA5/gD+km8ZwD+sguL1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ERaW5NzS2W0tNIZ05ikd0oacPJpX3gm0H4DR7j3GvEI=;
 b=WHTGPoF4ax1LyE6UghkEFo6+Sct21AeZ8z038xNDFPIMV8K4IDAh0VnBeTyDMqD2KykvkDyPccX6RTZH9nVuDCvaa0bcffjGLX1L7gzYWiTgxCYCKWAWo9MC67cyhZYcqZzqeXK8uPpMMvXQPhm+Xs1D7eqjja8BgBQ989wTTuzIztefTTT8OAIbyv9jNgR+aFMt2q+04hzXk+PZ6sSbebtZ0gqViTbDuQuP9n1UVh+2BNpUVfyIpj565zlaIV/FkDS4x2J6oqo+9gcOtDCilzT/DlrSPTaAWARpwGkZvDfyeDpkAf2z6Jk/XeuR4rYmnwenaHXN50x8aWnzuI5XlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ERaW5NzS2W0tNIZ05ikd0oacPJpX3gm0H4DR7j3GvEI=;
 b=WWBhWRPwC5t9BS5hIcwrET87mCplq6Y7ja/Ngq57pHHQ6XFbID4SJ2yYU9qg4MPdQlzB27q2rJSVz/wckFZvRfRI8vOob+o3FaKiaRFd2/iAak3wf8jf9V0tLbcbgdv/aGFKumDsPTLcqw7ExZ9wPE+oiHFNDrSqcxCi+9Y8KeU=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none
 header.from=drivenets.com;
Received: from AM6PR08MB4118.eurprd08.prod.outlook.com (2603:10a6:20b:aa::25)
 by AS8PR08MB6616.eurprd08.prod.outlook.com (2603:10a6:20b:319::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Wed, 18 Aug
 2021 06:29:34 +0000
Received: from AM6PR08MB4118.eurprd08.prod.outlook.com
 ([fe80::39dd:5002:3465:46ce]) by AM6PR08MB4118.eurprd08.prod.outlook.com
 ([fe80::39dd:5002:3465:46ce%4]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 06:29:34 +0000
From:   Gilad Naaman <gnaaman@drivenets.com>
To:     davem@davemloft.net, kuba@kernel.org, luwei32@huawei.com,
        gnaaman@drivenets.com, wangxiongfeng2@huawei.com,
        ap420073@gmail.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH v2 1/1] net-next: Improve perf of bond/vlans modification
Date:   Wed, 18 Aug 2021 09:29:10 +0300
Message-Id: <20210818062910.344660-1-gnaaman@drivenets.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210817110447.267678-1-gnaaman@drivenets.com>
References: <20210817110447.267678-1-gnaaman@drivenets.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P123CA0108.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:139::23) To AM6PR08MB4118.eurprd08.prod.outlook.com
 (2603:10a6:20b:aa::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from gnaaman-pc.dev.drivenets.net (199.203.244.232) by LO2P123CA0108.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:139::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 06:29:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 05f631ea-9bba-4f05-f498-08d962118b26
X-MS-TrafficTypeDiagnostic: AS8PR08MB6616:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AS8PR08MB6616229133F6308664D728CFBEFF9@AS8PR08MB6616.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vwmq0sB+rqCWMvvJTjeieldbJ9Rs6t/ufK6ge2iRwHU61VJgtrC3OKmIwBzF8jcXIun5ukts8eZVyq50AqB8ft2UMp7AFUSFygv8z4LKmGjwyEXbAVjIqP4/Rb2suUO+GtAZ5IHjgqrZtn1xssjasSKLZxbD6RZgiSypcVckG1Tn8yv5G0c2PsN7d+CgKfkbADOor+ORxUqDQlMa0ABhDUWgbc3RdEeIcPXlVC+Rveneh40mmQpzLnJA3h3XCfEvQa7yCQ5KG5Itwr1RQlwxZSKtRkACXFqAH8bN4vAbh0bzP9YgGhEl3MvsTRWfQlbab3P1/5ifNxt7+q/Qpe9FDdVFxW9pGDWYQWP1TJMcdOJ9zCvwNlR9bvJozrX1zj+9zyfgfPomp7d72MEbmVtvN/FAz9LsDSDDmoPR/bfI5oFBF3+IKzef/jK49S7S3rxQN0rhu6JSz0gnZHDC+cY/VW5dyerxYhzJn8xQBlBOGcKEZN4XjTIeRody5rSi7V4QnesrygDbknBafMzPGWJvWL0MRU4IT8BizgCbOurX0KOp6IYKYZmnncaP/o9BER/WlaziWqCJfScQi/1SZ09nCbOC1aZi/wSp1L5LdPoG/sLGQpTXpNK4/K0woEAlQvCS4A6hDuKUTyz/o2I7cGRO47XaiH0MzAV3vbrfUINbC9sR1+HTE2P98J3/Hi0WskpvupzIsx+4pTwHem56PKpzdKI1g3g1uRGyBUG7CW0aTYM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4118.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39840400004)(396003)(346002)(366004)(376002)(30864003)(1076003)(66556008)(66946007)(66476007)(2906002)(86362001)(6666004)(5660300002)(52116002)(83380400001)(36756003)(2616005)(38350700002)(38100700002)(8936002)(4326008)(8676002)(26005)(6486002)(478600001)(186003)(6512007)(6506007)(316002)(956004)(16060500005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Roh9sUO7eeb+O5ccSrWucevmi0S5721aNoRcIm9t+WFAxA//7SVce5NIm/Wz?=
 =?us-ascii?Q?ejzgKagNegUJWYlxfCB54Ook4EMOVLMQZE4aFB+qkJxbgSBDIYXiO/0QSp57?=
 =?us-ascii?Q?gf8ZhOQr64Fwp1ttryIRW7Ay3W9urBcQ1mqYQb0vnJrP5Ebnvp4mbLTek/yo?=
 =?us-ascii?Q?0qPXKIH7KV9GcsabKmrPA9ARGs8irrxU0VO1diFGrXNSbTCRAVpRDYQpMpYb?=
 =?us-ascii?Q?q5gLi+ANPaDwiPLdh+jjfjh//Nj/82pXteB4CrmFxvWf4VA9UhQHRnUuFRyK?=
 =?us-ascii?Q?izep3Na9kQDMuStAJeEvLRBhOw+gJ9HZ4Dm4nDwRMvbtdbnBiPVBRAyr9BzW?=
 =?us-ascii?Q?NNhWI/c6GuxWaPF0pPKQ/ufi9Ox1AVcHpBaFNADbtCe/h+r4eVMkuZVHvw7l?=
 =?us-ascii?Q?dSRX20UmhLPbx0NAbjBblIsjRnt6G/rkwFc8pDv+85EreueSyQ4kTFwRwSSD?=
 =?us-ascii?Q?0bFumHhgctVX9T/ONWHTebcr0LnjXBEtJV26FikxUc4XvYm5ZWtNvUWmI3Sv?=
 =?us-ascii?Q?Cn84Gk0cKwFBpN0+ysp055L3DYI8rSIc9ZN2hQ58LXU0xw10tXUQGCO+wm06?=
 =?us-ascii?Q?xb5i0yCF3aL1Rk9JjpiZwfZj/mb5RsWuDXA0GZqFGPNl79joTpw5HxmkL68/?=
 =?us-ascii?Q?Tt0dSZgSjZyP1fNsbFVLliziaP41Zq8dUYqpscorJsM8BRlf6pyRmBeQq3tF?=
 =?us-ascii?Q?kjuG5Ev/5NwPkaYLrsbounNFgqNkNt2p89tLf2E5aeCe0OUqifwX0Ob1108R?=
 =?us-ascii?Q?luBEkKkPQ9QbHtMr6+UWMis4pAUycjfeTPCFbzT8fVkoHZbHoSR2q2o2FEbY?=
 =?us-ascii?Q?9Ur6pmQScen4rm/vxUL5jb4fS85Tj5FlBM22IY7wIu75LApyHocinuqhgyrA?=
 =?us-ascii?Q?kkAhikJg5YpgpH81kgpnSe8v7Xtj1SyUXkLMJLRLgxNNJlUcZcnIZSgMxXL3?=
 =?us-ascii?Q?RndbeiIkGj5ztjNoXJak4m0xjB1EI+4bFPnf4lNvhlPjjglSv1RIbF8b+9mp?=
 =?us-ascii?Q?M9k3/UVOOaxWSw1iXHPmOpb23j5OOH9hHnbtFOfIBVrrhQ9XNPI99nmJVXt9?=
 =?us-ascii?Q?jKlBuyCufOAvz6dKV1bSzLiwqmAczPwnuejxUIRMUApi4X2PfH+x6FK0Kpvr?=
 =?us-ascii?Q?0Hm/LDTifgZiVsMgxW1EDPWNsmpDequhtBmaCWbsnrjIO2WQu8Tu0/iMsfFE?=
 =?us-ascii?Q?xGyK5wxSORht+UDoeiLp04ETnazFQJs5HJvxBvcmLRYOvuNy36rbCx295fze?=
 =?us-ascii?Q?UiN8C765gP/H/5c3/zH6XChfwY8FU5FzIXriadtEGGhCXBLHiFz3OH7kiU/L?=
 =?us-ascii?Q?jhtUaJgy/4L/3FfHYI2qM+2H?=
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05f631ea-9bba-4f05-f498-08d962118b26
X-MS-Exchange-CrossTenant-AuthSource: AM6PR08MB4118.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 06:29:34.0096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MGeMmE10JleZ57KAcSfsJtu/UzT1eA1Uy4fOUgSzmn+wXy1slBzDDUHUpDKaSSz2+VGheu9NHP85mPdt+wHp8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6616
X-MDID: 1629268175-9etKkIp2LCll
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a bond have a massive amount of VLANs with IPv6 addresses,
performance of changing link state, attaching a VRF, changing an IPv6
address, etc. go down dramtically.

The source of most of the slow down is the `dev_addr_lists.c` module,
which mainatins a linked list of HW addresses.
When using IPv6, this list grows for each IPv6 address added on a
VLAN, since each IPv6 address has a multicast HW address associated with
it.

When performing any modification to the involved links, this list is
traversed many times, often for nothing, all while holding the RTNL
lock.

Instead, this patch adds an auxilliary rbtree which cuts down
traversal time significantly.

Performance can be seen with the following script:

	#!/bin/bash
	ip netns del test || true 2>/dev/null
	ip netns add test

	echo 1 | ip netns exec test tee /proc/sys/net/ipv6/conf/all/keep_addr_on_down > /dev/null

	set -e

	ip -n test link add foo type veth peer name bar
	ip -n test link add b1 type bond
	ip -n test link add florp type vrf table 10

	ip -n test link set bar master b1
	ip -n test link set foo up
	ip -n test link set bar up
	ip -n test link set b1 up
	ip -n test link set florp up

	VLAN_COUNT=1500
	BASE_DEV=b1

	echo Creating vlans
	ip netns exec test time -p bash -c "for i in \$(seq 1 $VLAN_COUNT);
	do ip -n test link add link $BASE_DEV name foo.\$i type vlan id \$i; done"

	echo Bringing them up
	ip netns exec test time -p bash -c "for i in \$(seq 1 $VLAN_COUNT);
	do ip -n test link set foo.\$i up; done"

	echo Assiging IPv6 Addresses
	ip netns exec test time -p bash -c "for i in \$(seq 1 $VLAN_COUNT);
	do ip -n test address add dev foo.\$i 2000::\$i/64; done"

	echo Attaching to VRF
	ip netns exec test time -p bash -c "for i in \$(seq 1 $VLAN_COUNT);
	do ip -n test link set foo.\$i master florp; done"

On an Intel(R) Xeon(R) CPU E5-2650 v3 @ 2.30GHz machine, the performance
before the patch is (truncated):

	Creating vlans
	real 108.35
	Bringing them up
	real 4.96
	Assiging IPv6 Addresses
	real 19.22
	Attaching to VRF
	real 458.84

After the patch:

	Creating vlans
	real 5.59
	Bringing them up
	real 5.07
	Assiging IPv6 Addresses
	real 5.64
	Attaching to VRF
	real 25.37

Cc: David S. Miller <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Lu Wei <luwei32@huawei.com>
Cc: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Cc: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Gilad Naaman <gnaaman@drivenets.com>
---
 include/linux/netdevice.h |   5 ++
 net/core/dev_addr_lists.c | 161 ++++++++++++++++++++++++++++----------
 2 files changed, 124 insertions(+), 42 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index eaf5bb008aa9..8ae56a25661b 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -47,6 +47,7 @@
 #include <uapi/linux/if_bonding.h>
 #include <uapi/linux/pkt_cls.h>
 #include <linux/hashtable.h>
+#include <linux/rbtree.h>
 
 struct netpoll_info;
 struct device;
@@ -218,12 +219,16 @@ struct netdev_hw_addr {
 	int			sync_cnt;
 	int			refcount;
 	int			synced;
+	struct rb_node		node;
 	struct rcu_head		rcu_head;
 };
 
 struct netdev_hw_addr_list {
 	struct list_head	list;
 	int			count;
+
+	/* Auxiliary tree for faster lookup when modifying the structure. */
+	struct rb_root		tree_root;
 };
 
 #define netdev_hw_addr_list_count(l) ((l)->count)
diff --git a/net/core/dev_addr_lists.c b/net/core/dev_addr_lists.c
index 45ae6eeb2964..7fd73b905790 100644
--- a/net/core/dev_addr_lists.c
+++ b/net/core/dev_addr_lists.c
@@ -12,6 +12,70 @@
 #include <linux/export.h>
 #include <linux/list.h>
 
+/* Lookup for an address in the list using the rbtree.
+ * The return value is always a valid pointer.
+ * If the address exists, `*ret` is non-null and the address can be retrieved using
+ *
+ *     container_of(*ret, struct netdev_hw_addr, node)
+ *
+ * Otherwise, `ret` can be used with `parent` as an insertion point
+ * when calling `__hw_addr_insert_address_to_tree`.
+ *
+ * Must only be called when holding the netdevice's spinlock.
+ *
+ * @ignore_zero_addr_type if true and `addr_type` is zero,
+ *                        disregard addr_type when matching;
+ */
+static struct rb_node **__hw_addr_tree_address_lookup(struct netdev_hw_addr_list *list,
+					  const unsigned char *addr,
+					  int addr_len,
+					  unsigned char addr_type,
+					  bool ignore_zero_addr_type,
+					  struct rb_node **parent)
+{
+	struct rb_node **node = &list->tree_root.rb_node, *_parent;
+
+	while (*node) {
+		struct netdev_hw_addr *data = container_of(*node, struct netdev_hw_addr, node);
+		int result;
+
+		result = memcmp(addr, data->addr, addr_len);
+
+		if (!result && (ignore_zero_addr_type && !addr_type))
+			result = memcmp(&addr_type, &data->type, sizeof(addr_type));
+
+		_parent = *node;
+		if (result < 0)
+			node = &(*node)->rb_left;
+		else if (result > 0)
+			node = &(*node)->rb_right;
+		else
+			break;
+	}
+
+	if (parent)
+		*parent = _parent;
+	return node;
+}
+
+
+static int __hw_addr_insert_address_to_tree(struct netdev_hw_addr_list *list,
+				  struct netdev_hw_addr *ha,
+				  int addr_len,
+				  struct rb_node **insertion_point,
+				  struct rb_node *parent)
+{
+	/* Figure out where to put new node */
+	if (!insertion_point || !parent)
+		insertion_point = __hw_addr_tree_address_lookup(list, ha->addr, addr_len, ha->type, false, &parent);
+
+	/* Add new node and rebalance tree. */
+	rb_link_node(&ha->node, parent, insertion_point);
+	rb_insert_color(&ha->node, &list->tree_root);
+
+	return true;
+}
+
 /*
  * General list handling functions
  */
@@ -19,7 +83,9 @@
 static int __hw_addr_create_ex(struct netdev_hw_addr_list *list,
 			       const unsigned char *addr, int addr_len,
 			       unsigned char addr_type, bool global,
-			       bool sync)
+			       bool sync,
+			       struct rb_node **insertion_point,
+			       struct rb_node *parent)
 {
 	struct netdev_hw_addr *ha;
 	int alloc_size;
@@ -36,6 +102,10 @@ static int __hw_addr_create_ex(struct netdev_hw_addr_list *list,
 	ha->global_use = global;
 	ha->synced = sync ? 1 : 0;
 	ha->sync_cnt = 0;
+
+	/* Insert node to hash table for quicker lookups during modification */
+	__hw_addr_insert_address_to_tree(list, ha, addr_len, insertion_point, parent);
+
 	list_add_tail_rcu(&ha->list, &list->list);
 	list->count++;
 
@@ -47,34 +117,36 @@ static int __hw_addr_add_ex(struct netdev_hw_addr_list *list,
 			    unsigned char addr_type, bool global, bool sync,
 			    int sync_count)
 {
+	struct rb_node *insert_parent = NULL;
 	struct netdev_hw_addr *ha;
+	struct rb_node **ha_node;
 
 	if (addr_len > MAX_ADDR_LEN)
 		return -EINVAL;
 
-	list_for_each_entry(ha, &list->list, list) {
-		if (ha->type == addr_type &&
-		    !memcmp(ha->addr, addr, addr_len)) {
-			if (global) {
-				/* check if addr is already used as global */
-				if (ha->global_use)
-					return 0;
-				else
-					ha->global_use = true;
-			}
-			if (sync) {
-				if (ha->synced && sync_count)
-					return -EEXIST;
-				else
-					ha->synced++;
-			}
-			ha->refcount++;
-			return 0;
+	ha_node = __hw_addr_tree_address_lookup(list, addr, addr_len,
+						addr_type, false, &insert_parent);
+	if (*ha_node) {
+		ha = container_of(*ha_node, struct netdev_hw_addr, node);
+		if (global) {
+			/* check if addr is already used as global */
+			if (ha->global_use)
+				return 0;
+			else
+				ha->global_use = true;
 		}
+		if (sync) {
+			if (ha->synced && sync_count)
+				return -EEXIST;
+			else
+				ha->synced++;
+		}
+		ha->refcount++;
+		return 0;
 	}
 
 	return __hw_addr_create_ex(list, addr, addr_len, addr_type, global,
-				   sync);
+				   sync, ha_node, insert_parent);
 }
 
 static int __hw_addr_add(struct netdev_hw_addr_list *list,
@@ -103,6 +175,8 @@ static int __hw_addr_del_entry(struct netdev_hw_addr_list *list,
 
 	if (--ha->refcount)
 		return 0;
+
+	rb_erase(&ha->node, &list->tree_root);
 	list_del_rcu(&ha->list);
 	kfree_rcu(ha, rcu_head);
 	list->count--;
@@ -114,13 +188,14 @@ static int __hw_addr_del_ex(struct netdev_hw_addr_list *list,
 			    unsigned char addr_type, bool global, bool sync)
 {
 	struct netdev_hw_addr *ha;
+	struct rb_node **ha_node;
 
-	list_for_each_entry(ha, &list->list, list) {
-		if (!memcmp(ha->addr, addr, addr_len) &&
-		    (ha->type == addr_type || !addr_type))
-			return __hw_addr_del_entry(list, ha, global, sync);
-	}
-	return -ENOENT;
+	ha_node = __hw_addr_tree_address_lookup(list, addr, addr_len, addr_type, true, NULL);
+	if (*ha_node == NULL)
+		return -ENOENT;
+
+	ha = container_of(*ha_node, struct netdev_hw_addr, node);
+	return __hw_addr_del_entry(list, ha, global, sync);
 }
 
 static int __hw_addr_del(struct netdev_hw_addr_list *list,
@@ -418,6 +493,7 @@ void __hw_addr_init(struct netdev_hw_addr_list *list)
 {
 	INIT_LIST_HEAD(&list->list);
 	list->count = 0;
+	list->tree_root = RB_ROOT;
 }
 EXPORT_SYMBOL(__hw_addr_init);
 
@@ -552,19 +628,20 @@ EXPORT_SYMBOL(dev_addr_del);
  */
 int dev_uc_add_excl(struct net_device *dev, const unsigned char *addr)
 {
-	struct netdev_hw_addr *ha;
+	struct rb_node *insert_parent = NULL;
+	struct rb_node **ha_node = NULL;
 	int err;
 
 	netif_addr_lock_bh(dev);
-	list_for_each_entry(ha, &dev->uc.list, list) {
-		if (!memcmp(ha->addr, addr, dev->addr_len) &&
-		    ha->type == NETDEV_HW_ADDR_T_UNICAST) {
-			err = -EEXIST;
-			goto out;
-		}
+	ha_node = __hw_addr_tree_address_lookup(&dev->uc, addr, dev->addr_len,
+						NETDEV_HW_ADDR_T_UNICAST, false, &insert_parent);
+	if (*ha_node) {
+		err = -EEXIST;
+		goto out;
 	}
+
 	err = __hw_addr_create_ex(&dev->uc, addr, dev->addr_len,
-				  NETDEV_HW_ADDR_T_UNICAST, true, false);
+				  NETDEV_HW_ADDR_T_UNICAST, true, false, ha_node, insert_parent);
 	if (!err)
 		__dev_set_rx_mode(dev);
 out:
@@ -745,19 +822,19 @@ EXPORT_SYMBOL(dev_uc_init);
  */
 int dev_mc_add_excl(struct net_device *dev, const unsigned char *addr)
 {
-	struct netdev_hw_addr *ha;
+	struct rb_node *insert_parent = NULL;
+	struct rb_node **ha_node;
 	int err;
 
 	netif_addr_lock_bh(dev);
-	list_for_each_entry(ha, &dev->mc.list, list) {
-		if (!memcmp(ha->addr, addr, dev->addr_len) &&
-		    ha->type == NETDEV_HW_ADDR_T_MULTICAST) {
-			err = -EEXIST;
-			goto out;
-		}
+	ha_node = __hw_addr_tree_address_lookup(&dev->mc, addr, dev->addr_len,
+						NETDEV_HW_ADDR_T_MULTICAST, false, &insert_parent);
+	if (*ha_node) {
+		err = -EEXIST;
+		goto out;
 	}
 	err = __hw_addr_create_ex(&dev->mc, addr, dev->addr_len,
-				  NETDEV_HW_ADDR_T_MULTICAST, true, false);
+				  NETDEV_HW_ADDR_T_MULTICAST, true, false, ha_node, insert_parent);
 	if (!err)
 		__dev_set_rx_mode(dev);
 out:
-- 
2.25.1

