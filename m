Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA6845DECF
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 17:54:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241554AbhKYQ5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 11:57:25 -0500
Received: from dispatch1-eu1.ppe-hosted.com ([185.132.181.8]:47962 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231615AbhKYQzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 11:55:24 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR03-DB5-obe.outbound.protection.outlook.com (mail-db5eur03lp2055.outbound.protection.outlook.com [104.47.10.55])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id CB04180072;
        Thu, 25 Nov 2021 16:52:10 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RJkUCglsII8L2q5Uefcj3S2ANsWKIrhG086353Ov4uGCB2vitOjCwggk3xAYc80X6i3RzClhC+TPQ/HAmzWteg0yfk1acF7ZHPAGm8WTFRV+tTCj0QFW/pDzMehLP37GvZQQ9zinAnmFx/DLHqAyYJyDH3k5+GawxT4GdrEtquqIdqkwiUsv56Bu86HJtmynnZRQuFqcEz6A3tmCFNuzWptwJoraOgQwd576+ofbTIhjkkTCvCrNQZgpv737bEMCM66adBgXMtzLtQrTzNDyDGotyvf+Z53SfZoFLN9Ci3KnSguF/q1MkyOpjTJouHDzQ7V90xFvCJpmd7FLnpgWLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/OyMI8xoiotFxROw/Oq+pv3uH7YTlS6HBa3q6QvU6aY=;
 b=K0llmc+OmJWinwKAQGHVR/GnblYIUik5WEhanxWxhaVII3RHJihDA9Gq7LNUhf6yyvzu5NFgUNNGzQZSikshQPTMBmTSvsYw5BIO3aDUv+5fPDeJ5rMSY9nXhF1ZfsX8rI/NOBYaTXxyrewSFvNybZBQWqhLL3+jKLHAuMvq020aVsNUB07Q/Ajmnwc/Z23awLpHnw35l8z56fREnhBh+KtrGbbmNepU8qgN68pUNLqUQcSLIhMMi00VuNXNEwBn6IpgfkLJ3tPIJr9LdyBHf+eFnr9rcon6g1dbZbqpox/ogzx0tQrZ8WkxjWfLfF079Lgq+QuGs0eM3c++9sHPHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/OyMI8xoiotFxROw/Oq+pv3uH7YTlS6HBa3q6QvU6aY=;
 b=W191XEFee+Vd6wvm98Unpwdhelzhbi8Ue0BwtaTuUMZ0YU15Zcbv1PNnWpeu5NuJZb5jbVHpbloa6g0xq6mXpwMHagTlpQwL9oBgOEUU9jcU6JBqTpF98cD1UCkkI+Khl8KyQD4ki5Pi+kE//sAqyTF7dzSC+yJ8eyQvTWOgx8U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=drivenets.com;
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com (2603:10a6:803:7a::23)
 by VI1PR08MB2686.eurprd08.prod.outlook.com (2603:10a6:802:18::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.24; Thu, 25 Nov
 2021 16:51:56 +0000
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::7484:9ec:6c6e:752d]) by VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::7484:9ec:6c6e:752d%6]) with mapi id 15.20.4713.027; Thu, 25 Nov 2021
 16:51:56 +0000
From:   Lahav Schlesinger <lschlesinger@drivenets.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, dsahern@gmail.com
Subject: [PATCH net-next v3] rtnetlink: Support fine-grained netdevice bulk deletion
Date:   Thu, 25 Nov 2021 18:51:46 +0200
Message-Id: <20211125165146.21298-1-lschlesinger@drivenets.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0032.eurprd04.prod.outlook.com
 (2603:10a6:208:122::45) To VI1PR08MB3518.eurprd08.prod.outlook.com
 (2603:10a6:803:7a::23)
MIME-Version: 1.0
Received: from kgollan-pc.dev.drivenets.net (82.166.105.36) by AM0PR04CA0032.eurprd04.prod.outlook.com (2603:10a6:208:122::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20 via Frontend Transport; Thu, 25 Nov 2021 16:51:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3180c361-44c9-4c24-0994-08d9b033e3ab
X-MS-TrafficTypeDiagnostic: VI1PR08MB2686:
X-Microsoft-Antispam-PRVS: <VI1PR08MB268684DC1D98D4F3F27855B0CC629@VI1PR08MB2686.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NRIBt7fgTKD9tCvZpye3p6Bs+0hihcbEZGP0z6fwKYlJipXkrnFYMaeg5vKotK9tEI04YzVTr3OTgv8T60R1rf1LG8MtVwM3ZkqQoEgMuJXoYkIvw+ielaFuy5gbxDmrkwkJWj8RENq9YqauHRjjj+ZCFKxL6cfeOypOuA3O5OXKLTW7FO1mf0LkAaXS1qs17Xf53/0M/fQL08HY388dYKjeiprFKzVSjBUJ42gDXdRHE5hVLgkqTTIIN6PwfTOAzemzUcKX4dlDKaRllTikTacnPAkuY5p+Vrcq5wLaQ0mTl43qsT/QJIrCIB1zHGtoXovh+lWMrUWJPhN0soh+JyFvnCHZ5OOzjfcvo3/Lzne5qQCtsSmpkNMmWrrMKk9kNWeSKftxMG3aiwKZsY7AQCLB8qTJsEG3bFJiGx/Q1nbsxwtTtIj+J0IXW5/bcbnxWW+2ffGmfTGWdI5hW6eTcdmPxWrNMJQEPjfMJwZZY3U1TNwWnqJ+a8F5IVZZWYV/PSgGaoahEeFpGk+t43PkRwn2J02kxrvQrWcwjML9QZ3c8MFzMWBxo0VaLlwd6UnIUfBBfuVNsId8Tao3wHVotR7QqPD7hVGMbvgibf+0OrrUbX/NWeKzTidKlSOxFwrlhSmwbkyhjk8FXpy6nz442Db3sTvcyZxN6qcWCbH1OaBBAG4AO4ErWxIlVevXej4evWNkqB0zw0IcW4glbA1WKjtRpMWv/XhQp6rna4KXT4A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3518.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(186003)(66574015)(5660300002)(6506007)(508600001)(4326008)(52116002)(86362001)(1076003)(36756003)(38100700002)(8936002)(6512007)(2906002)(66476007)(956004)(2616005)(38350700002)(66946007)(316002)(66556008)(6486002)(83380400001)(8676002)(6916009)(6666004)(16060500005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?htR7tqBts70OOAQ8c5yf8K8aSvxaUtRhiltq0FZUN72j+LTUmeIxAMrVOTGM?=
 =?us-ascii?Q?Vp2WGQDhSe4XlLevVmmJhkj5xy6oSIwrpYeDrx1zpi8g3oDUptHttlKhEEUF?=
 =?us-ascii?Q?c8ZxPe5YE6D8W1e7oMAbJL8xZzXSAXZew6/Zq7JPzDGpzlqSrIaTfofQaufW?=
 =?us-ascii?Q?CqDoJYkRORGAiY0nCDp9YjAkmKd9a8P1G9UNhjNDe4tC5f2fR4/xqZP9lEHe?=
 =?us-ascii?Q?1QUVkhK4WHi3XHs57xfsHuVui6405mJkwfoTkbhdIb7CreLDNUup2QjjkBjA?=
 =?us-ascii?Q?bX7z9Pyb44oLetw7KsjBy5DKSmp1KBL1+7gxN7KnWJSCQSQEDX56qwa/NaAZ?=
 =?us-ascii?Q?07muPOb4XQBb0T+agF1jNdG0JY6lMPMDK39Id0yYSVs5hLegJAfnKVKcOFUm?=
 =?us-ascii?Q?vWpx+Z88/je6iZKtApFr2XwvJER8VdO0jLQ1LAB5AlwS07PdhPgwNL0BB4zc?=
 =?us-ascii?Q?y6GGCFfUl5XIhJG+OImPAfLeZbyjIdE+qH071OM1C/RuDzfX23z0FCIw4d0B?=
 =?us-ascii?Q?OCw4X1HS9+pAGvRBUxOLj5thLuffoO7JJWGPDYr1167w8erZiJQQapne3mE/?=
 =?us-ascii?Q?KTSmb9FqEUPHTSbcdPRa0ggzftexcJuib0innK4fafGkLFPPlzoy9+nVrjjB?=
 =?us-ascii?Q?3JIw473VZnfx4EoLv18xgYRqi5f1qZ4HRd9ogOR7LLw6ePCUnlL4p+t2J2cU?=
 =?us-ascii?Q?k8Gk+o1D9Kc8+PHNPM9fAriFZVIM8O5GtmbjgUTpq+WRaEj11aFtiBNO9/y2?=
 =?us-ascii?Q?GUrlKPTx/GMdewDe4HSyrj8d8PywwCfs8gsARXoiY9aUp4Vk+Qvrrab8ZF3a?=
 =?us-ascii?Q?cp13eza49AlUS2LBYkvf8Uu9CUkCuJxw+qSJJTp+O4P3V2qPZMRUFcq9+Dj/?=
 =?us-ascii?Q?yk0Uhu7yvC+YcqLrIblqjUVP8dz5plG+ENK8GS/Sg+P+bbrZhAv42x19mbZk?=
 =?us-ascii?Q?nCU5mtNOSsa4U6Q46S5BcCAdqa6CzvFRDFvSIxkeBfAXmGXXo3ZcR7JX1Qq/?=
 =?us-ascii?Q?f5kNknAh928EjAqe2c5mFtq1pqjNGr+Tqw78a8W6kvFOg8ZIJ1P6LY5uj3pO?=
 =?us-ascii?Q?0lBlYfuXt8Wk5mlBJp9wsm7y2TdXQyCg2NSnMRDbtROJ58O3OkacCriifvGo?=
 =?us-ascii?Q?v3aWXCd8GKGKQfenzgGMn0eGd/VkpWLLhuiYVC3UuOhadFN/mHDBfcLLBkPt?=
 =?us-ascii?Q?yP15QDGWXvzuF5Onww/FrzVgZzHVwJHGl3O55GfrkS0diJvkWmzw4ZtDlaU0?=
 =?us-ascii?Q?MIfLXZgSOpquYzqztOiSzg96BLTYxBLxs+9TrU2D8EI7h0u7jaQ5rP7umJw1?=
 =?us-ascii?Q?Ua9Ybb/4oSDL2Rd80qAkYPQw6pkNjDzTf7F2J8XEFU9/2R1APK5V1Y8zhFjr?=
 =?us-ascii?Q?vBJkVN6sIzqOnV8qL73WB3/fNVKkAsC+OSFlo0BgZq4csXTaXlKf6BaxIy4X?=
 =?us-ascii?Q?bxUiui0Q0RsdaAyzv1es792kCVNs4GYY0PpGbXl8J/1KBvG7+gtcjOBkWc1I?=
 =?us-ascii?Q?7tg96a8UGfsGW4T9Z7fCksREJU2d8Ycq82kx//4hS/rLRPcSOILy8q66Ufwv?=
 =?us-ascii?Q?ysZuMLTAPE1Y2bLv+rdCJlsx2wRPqTPh4Xy5f1PPv5r7KG3+xpwKeKPp0VOK?=
 =?us-ascii?Q?NVCfqzmaPn4cWM8Ecldz57RTq3l5t7xr/U078KID0IDjrphgXQSSwtYWbytQ?=
 =?us-ascii?Q?Y8qFCw=3D=3D?=
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3180c361-44c9-4c24-0994-08d9b033e3ab
X-MS-Exchange-CrossTenant-AuthSource: VI1PR08MB3518.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2021 16:51:56.0862
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TNJZ0iJJcBbwbTudS8C43U3Weaor5Yu29H5ITPd56ru39U5JKop6pZrpUgoHWxLi5usWHPoLoQXoSGNSwtQELsWgKKyUurwvKqrO7jG2fpQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB2686
X-MDID: 1637859131-ggka9v57_T41
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Under large scale, some routers are required to support tens of thousands
of devices at once, both physical and virtual (e.g. loopbacks, tunnels,
vrfs, etc).
At times such routers are required to delete massive amounts of devices
at once, such as when a factory reset is performed on the router (causing
a deletion of all devices), or when a configuration is restored after an
upgrade, or as a request from an operator.

Currently there are 2 means of deleting devices using Netlink:
1. Deleting a single device (either by ifindex using ifinfomsg::ifi_index,
or by name using IFLA_IFNAME)
2. Delete all device that belong to a group (using IFLA_GROUP)

Deletion of devices one-by-one has poor performance on large scale of
devices compared to "group deletion":
After all device are handled, netdev_run_todo() is called which
calls rcu_barrier() to finish any outstanding RCU callbacks that were
registered during the deletion of the device, then wait until the
refcount of all the devices is 0, then perform final cleanups.

However, calling rcu_barrier() is a very costly operation, each call
taking in the order of 10s of milliseconds.

When deleting a large number of device one-by-one, rcu_barrier()
will be called for each device being deleted.
As an example, following benchmark deletes 10K loopback devices,
all of which are UP and with only IPv6 LLA being configured:

1. Deleting one-by-one using 1 thread : 243 seconds
2. Deleting one-by-one using 10 thread: 70 seconds
3. Deleting one-by-one using 50 thread: 54 seconds
4. Deleting all using "group deletion": 30 seconds

Note that even though the deletion logic takes place under the rtnl
lock, since the call to rcu_barrier() is outside the lock we gain
some improvements.

But, while "group deletion" is the fastest, it is not suited for
deleting large number of arbitrary devices which are unknown a head of
time. Furthermore, moving large number of devices to a group is also a
costly operation.

This patch adds support for passing an arbitrary list of ifindex of
devices to delete with a new IFLA_IFINDEX_LIST attribute.
This gives a more fine-grained control over which devices to delete,
while still resulting in rcu_barrier() being called only once.
Indeed, the timings of using this new API to delete 10K devices is
the same as using the existing "group" deletion.

The size constraints on the attribute means the API can delete at most
16382 devices in a single request.

Signed-off-by: Lahav Schlesinger <lschlesinger@drivenets.com>
---
v2 -> v3
 - Rename 'ifindex_list' to 'ifindices', and pass it as int*
 - Clamp 'ops' variable in second loop.

v1 -> v2
 - Unset 'len' of IFLA_IFINDEX_LIST in policy.
 - Use __dev_get_by_index() instead of n^2 loop.
 - Return -ENODEV if any ifindex is not present.
 - Saved devices in an array.
 - Fix formatting.

 include/uapi/linux/if_link.h |  1 +
 net/core/rtnetlink.c         | 50 ++++++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index eebd3894fe89..f950bf6ed025 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -348,6 +348,7 @@ enum {
 	IFLA_PARENT_DEV_NAME,
 	IFLA_PARENT_DEV_BUS_NAME,
 
+	IFLA_IFINDEX_LIST,
 	__IFLA_MAX
 };
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index fd030e02f16d..49d1a3954a01 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1880,6 +1880,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
 	[IFLA_PROTO_DOWN_REASON] = { .type = NLA_NESTED },
 	[IFLA_NEW_IFINDEX]	= NLA_POLICY_MIN(NLA_S32, 1),
 	[IFLA_PARENT_DEV_NAME]	= { .type = NLA_NUL_STRING },
+	[IFLA_IFINDEX_LIST]	= { .type = NLA_BINARY },
 };
 
 static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
@@ -3050,6 +3051,52 @@ static int rtnl_group_dellink(const struct net *net, int group)
 	return 0;
 }
 
+static int rtnl_list_dellink(struct net *net, int *ifindices, int size)
+{
+	const int num_devices = size / sizeof(int);
+	struct net_device **dev_list;
+	LIST_HEAD(list_kill);
+	int i, ret;
+
+	if (size <= 0 || size % sizeof(int))
+		return -EINVAL;
+
+	dev_list = kmalloc_array(num_devices, sizeof(*dev_list), GFP_KERNEL);
+	if (!dev_list)
+		return -ENOMEM;
+
+	for (i = 0; i < num_devices; i++) {
+		const struct rtnl_link_ops *ops;
+		struct net_device *dev;
+
+		ret = -ENODEV;
+		dev = __dev_get_by_index(net, ifindices[i]);
+		if (!dev)
+			goto out_free;
+
+		ret = -EOPNOTSUPP;
+		ops = dev->rtnl_link_ops;
+		if (!ops || !ops->dellink)
+			goto out_free;
+
+		dev_list[i] = dev;
+	}
+
+	for (i = 0; i < num_devices; i++) {
+		struct net_device *dev = dev_list[i];
+
+		dev->rtnl_link_ops->dellink(dev, &list_kill);
+	}
+
+	unregister_netdevice_many(&list_kill);
+
+	ret = 0;
+
+out_free:
+	kfree(dev_list);
+	return ret;
+}
+
 int rtnl_delete_link(struct net_device *dev)
 {
 	const struct rtnl_link_ops *ops;
@@ -3102,6 +3149,9 @@ static int rtnl_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
 				   tb[IFLA_ALT_IFNAME], NULL);
 	else if (tb[IFLA_GROUP])
 		err = rtnl_group_dellink(tgt_net, nla_get_u32(tb[IFLA_GROUP]));
+	else if (tb[IFLA_IFINDEX_LIST])
+		err = rtnl_list_dellink(tgt_net, nla_data(tb[IFLA_IFINDEX_LIST]),
+					nla_len(tb[IFLA_IFINDEX_LIST]));
 	else
 		goto out;
 
-- 
2.25.1

