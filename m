Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97BC323AE58
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 22:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728557AbgHCUnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 16:43:32 -0400
Received: from mail-eopbgr150087.outbound.protection.outlook.com ([40.107.15.87]:25987
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728531AbgHCUnc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 16:43:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U7BU+ptCX5UYvW7688OLABudvleEqtB9BXReZvU9UTRwJYuEEUZusYkFvSPJsgSAQu5s3OyBg6Z8hCik/1fBTHbQJumF1t+PWbx5jfi7CZweDiYKSRKds6qTDTWMjtJqcfpoBHFKeKCdFYgAh5/USUDolOmJwHbdlZM7/9Okdh59gtBEfdsjvSYR6xzdXnkMYSUONC5Rx2GP32vWjNSWzrh8XkumfvvmOrduwMBqduou2Eia7FUyAjslODPaVtLSNT2dZuNqjGXMMUETyHEHrk78EVv8ShvDS/kDHpBZCZbnnePe64f9m5FOkGvU0Xfc50/Qo81lmsbdIYjq4L178Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SC+vgicRrMfZA1rUk1G4EIvguFzlIkDZ10YIjOUxQqA=;
 b=BeLmhOxhajFTOnJTYcZZc6aV8Ptyat8U7MYwdAj0q/lSkVZnApLwxfICRphjZ4OJSTch+vIjtksNN5ytDGlGy3a4v0gdDeSj3D2z+iMOfJEJT1CvTuiA2o7ESmjY9w1AvRLYQiMq1uWsQmFnA3D3Ft97WKCNBCVQ0lMpI742Pa8vBfvxiTDpY5UROkLx7sqh605zyu8ekKseIkJtJSP5ZHemviRDp6MLQO6+MA5C5sMIYl4oELG9/85q1AHSGzVacr9Ok5QyJ5nAZ2wijE2DtDedTknjB1x7FUlqUa7+zPPvabfkH7j8GSWWPJtKqrK65RGKRac0Gio+Ky1s8ahdLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SC+vgicRrMfZA1rUk1G4EIvguFzlIkDZ10YIjOUxQqA=;
 b=OaBGiwN3sLVwPlmUgcJKWij8nz/Hkwi1xYuS99V43XlD/jGOLTvvP8dEzvJNnoNcNZamMKKbu4dXfUjJWg/SH8JLgJ9tCpKaztdoI4ZAiC8bOV2Yn9PvVI4dqV8zRbc1MTaWDfcfnmxVDyooDHjYAD/ChXatM8yCFyrwQvMfByY=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VE1PR05MB7311.eurprd05.prod.outlook.com (2603:10a6:800:1a3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.21; Mon, 3 Aug
 2020 20:42:57 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2dde:902e:3a19:4366]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2dde:902e:3a19:4366%5]) with mapi id 15.20.3239.021; Mon, 3 Aug 2020
 20:42:57 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 3/5] udp_tunnel: add the ability to hard-code IANA VXLAN
Date:   Mon,  3 Aug 2020 13:41:49 -0700
Message-Id: <20200803204151.120802-4-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200803204151.120802-1-saeedm@mellanox.com>
References: <20200803204151.120802-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR10CA0017.namprd10.prod.outlook.com
 (2603:10b6:a03:255::22) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY3PR10CA0017.namprd10.prod.outlook.com (2603:10b6:a03:255::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17 via Frontend Transport; Mon, 3 Aug 2020 20:42:55 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ffead50b-da0c-430b-a9c3-08d837edcd85
X-MS-TrafficTypeDiagnostic: VE1PR05MB7311:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR05MB7311AD4480824AFCFECFDBA7BE4D0@VE1PR05MB7311.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FlGg1wDGZi1yr4Oe0J4/kHA6Ekw09M19vKt3qoEEp17bXQdYGRw5aOMmwUU8hq5SxvBk8orJRL7j5Gp9SpdzB82HLiYy/4haHUEfTsUFIN+olpg8rEJfyK7ZlzDalGN6i/A4zKiG+VsZddPo9J+O0LvNo7XObhZHuzkODnI+9h7CrCsNULTzh6plBCHRkaUD2waKnCK6Kr04Cc4rRljdKS+hBCT6YYhFMQ7ywHNIRXqlCgPlDcv2mTizxNyCtkWpNNFFINVSvmMUlygbFQ9pwVlZn/VPZXN59Q4PrLqCk1zEJZshqn6piu/sXwCsnvvtRIGRlBl8NeBgik2ryI1O533ghS+MQYFKyPJxufdUZN/yguXcoE8xUoMjwKo6on/W
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(376002)(366004)(346002)(39860400002)(956004)(1076003)(478600001)(110136005)(8936002)(5660300002)(2906002)(6666004)(2616005)(86362001)(316002)(16526019)(66946007)(66476007)(66556008)(6486002)(36756003)(6506007)(26005)(8676002)(107886003)(83380400001)(52116002)(6512007)(4326008)(186003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: zMQA1NbzKrkFhheEHsRdX0kTLvVIrUlHNDgT5lv3I9R1KHdtuR79U/iwI43Kg1lyiZap5S+4hobFlXU/nB4q8El/+kms9qYOGuUBbRdaz49tJ1rYyg8SjKe0weBecr2Hc8bT/HtMs5AUJ8jJKsKVv7o8PYbkKSZq1q+yvZp+aYwx6PGhZKs+J8BqbNmH2MXaghP1PTnZU+wONkNFB+NvbRahE4Izg+OPevVDn+y4fi46R+Ojm6dTfwk3SMsuP7RxwuygP1gGoKWt2mwSiXCMLaeZQuhhnHRgO6hXLBC/mk+hvAwV8riRbpbsu9UwjjNsqYYMXA/QbiqXDmVQBWjT4kehbeZYK6ImXl4+MhSzRr2OCUdtUVs+Uy5gU0BBsS/EC0pNkfeW2XUk53j0rCXTSYG725FCweimbspi7OZ1Xp2LvhsH2x5D7dXco2VHRQxfsWojQQ/f8PiM0s/uQ1fSU2lvGeE92e5dBddY1KwZgQKE5AVtIy1NRwaf5SXpZtWbfeNpUnfnQ1e12QGid8Q5dVct5wRBBlg6YbibyqyW+G+zn5jRwQ997/1OrAd/h+zvAlsBm1IlUZqKiYU8s7YekrD3loXgIDN8hu6XYAf99cUMETxQz8iynzydeNxfmkntQKth+mXmKSfHzDb1mRqAyQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffead50b-da0c-430b-a9c3-08d837edcd85
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2020 20:42:57.3387
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WgMA+FF4D4gADIAnIYznC/93pQi5f4ZKioifJPZXtdkeLyD2Jjzd27wV0t8K8YjmR/lXyqCJC4Cxx6wSpflb5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR05MB7311
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

mlx5 has the IANA VXLAN port (4789) hard coded by the device,
instead of being added dynamically when tunnels are created.

To support this add a workaround flag to struct udp_tunnel_nic_info.
Skipping updates for the port is fairly trivial, dumping the hard
coded port via ethtool requires some code duplication. The port
is not a part of any real table, we dump it in a special table
which has no tunnel types supported and only one entry.

This is the last known workaround / hack needed to convert
all drivers to the new infra.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 Documentation/networking/ethtool-netlink.rst |  3 +
 include/net/udp_tunnel.h                     |  5 ++
 net/ethtool/tunnels.c                        | 69 +++++++++++++++++---
 net/ipv4/udp_tunnel_nic.c                    |  7 ++
 4 files changed, 76 insertions(+), 8 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 7d75f1e32152d..d53bcb31645a4 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -1263,6 +1263,9 @@ Kernel response contents:
  | | | | ``ETHTOOL_A_TUNNEL_UDP_ENTRY_TYPE``   | u32    | tunnel type         |
  +-+-+-+---------------------------------------+--------+---------------------+
 
+For UDP tunnel table empty ``ETHTOOL_A_TUNNEL_UDP_TABLE_TYPES`` indicates that
+the table contains static entries, hard-coded by the NIC.
+
 Request translation
 ===================
 
diff --git a/include/net/udp_tunnel.h b/include/net/udp_tunnel.h
index dd20ce99740c8..94bb7a8822507 100644
--- a/include/net/udp_tunnel.h
+++ b/include/net/udp_tunnel.h
@@ -193,6 +193,11 @@ enum udp_tunnel_nic_info_flags {
 	UDP_TUNNEL_NIC_INFO_OPEN_ONLY	= BIT(1),
 	/* Device supports only IPv4 tunnels */
 	UDP_TUNNEL_NIC_INFO_IPV4_ONLY	= BIT(2),
+	/* Device has hard-coded the IANA VXLAN port (4789) as VXLAN.
+	 * This port must not be counted towards n_entries of any table.
+	 * Driver will not receive any callback associated with port 4789.
+	 */
+	UDP_TUNNEL_NIC_INFO_STATIC_IANA_VXLAN	= BIT(3),
 };
 
 /**
diff --git a/net/ethtool/tunnels.c b/net/ethtool/tunnels.c
index 6b89255f12319..84f23289475bc 100644
--- a/net/ethtool/tunnels.c
+++ b/net/ethtool/tunnels.c
@@ -2,6 +2,7 @@
 
 #include <linux/ethtool_netlink.h>
 #include <net/udp_tunnel.h>
+#include <net/vxlan.h>
 
 #include "bitset.h"
 #include "common.h"
@@ -18,6 +19,20 @@ static_assert(ETHTOOL_UDP_TUNNEL_TYPE_GENEVE == ilog2(UDP_TUNNEL_TYPE_GENEVE));
 static_assert(ETHTOOL_UDP_TUNNEL_TYPE_VXLAN_GPE ==
 	      ilog2(UDP_TUNNEL_TYPE_VXLAN_GPE));
 
+static ssize_t ethnl_udp_table_reply_size(unsigned int types, bool compact)
+{
+	ssize_t size;
+
+	size = ethnl_bitset32_size(&types, NULL, __ETHTOOL_UDP_TUNNEL_TYPE_CNT,
+				   udp_tunnel_type_names, compact);
+	if (size < 0)
+		return size;
+
+	return size +
+		nla_total_size(0) + /* _UDP_TABLE */
+		nla_total_size(sizeof(u32)); /* _UDP_TABLE_SIZE */
+}
+
 static ssize_t
 ethnl_tunnel_info_reply_size(const struct ethnl_req_info *req_base,
 			     struct netlink_ext_ack *extack)
@@ -25,8 +40,8 @@ ethnl_tunnel_info_reply_size(const struct ethnl_req_info *req_base,
 	bool compact = req_base->flags & ETHTOOL_FLAG_COMPACT_BITSETS;
 	const struct udp_tunnel_nic_info *info;
 	unsigned int i;
+	ssize_t ret;
 	size_t size;
-	int ret;
 
 	info = req_base->dev->udp_tunnel_nic_info;
 	if (!info) {
@@ -39,13 +54,10 @@ ethnl_tunnel_info_reply_size(const struct ethnl_req_info *req_base,
 
 	for (i = 0; i < UDP_TUNNEL_NIC_MAX_TABLES; i++) {
 		if (!info->tables[i].n_entries)
-			return size;
+			break;
 
-		size += nla_total_size(0); /* _UDP_TABLE */
-		size +=	nla_total_size(sizeof(u32)); /* _UDP_TABLE_SIZE */
-		ret = ethnl_bitset32_size(&info->tables[i].tunnel_types, NULL,
-					  __ETHTOOL_UDP_TUNNEL_TYPE_CNT,
-					  udp_tunnel_type_names, compact);
+		ret = ethnl_udp_table_reply_size(info->tables[i].tunnel_types,
+						 compact);
 		if (ret < 0)
 			return ret;
 		size += ret;
@@ -53,6 +65,17 @@ ethnl_tunnel_info_reply_size(const struct ethnl_req_info *req_base,
 		size += udp_tunnel_nic_dump_size(req_base->dev, i);
 	}
 
+	if (info->flags & UDP_TUNNEL_NIC_INFO_STATIC_IANA_VXLAN) {
+		ret = ethnl_udp_table_reply_size(0, compact);
+		if (ret < 0)
+			return ret;
+		size += ret;
+
+		size += nla_total_size(0) +		 /* _TABLE_ENTRY */
+			nla_total_size(sizeof(__be16)) + /* _ENTRY_PORT */
+			nla_total_size(sizeof(u32));	 /* _ENTRY_TYPE */
+	}
+
 	return size;
 }
 
@@ -62,7 +85,7 @@ ethnl_tunnel_info_fill_reply(const struct ethnl_req_info *req_base,
 {
 	bool compact = req_base->flags & ETHTOOL_FLAG_COMPACT_BITSETS;
 	const struct udp_tunnel_nic_info *info;
-	struct nlattr *ports, *table;
+	struct nlattr *ports, *table, *entry;
 	unsigned int i;
 
 	info = req_base->dev->udp_tunnel_nic_info;
@@ -97,10 +120,40 @@ ethnl_tunnel_info_fill_reply(const struct ethnl_req_info *req_base,
 		nla_nest_end(skb, table);
 	}
 
+	if (info->flags & UDP_TUNNEL_NIC_INFO_STATIC_IANA_VXLAN) {
+		u32 zero = 0;
+
+		table = nla_nest_start(skb, ETHTOOL_A_TUNNEL_UDP_TABLE);
+		if (!table)
+			goto err_cancel_ports;
+
+		if (nla_put_u32(skb, ETHTOOL_A_TUNNEL_UDP_TABLE_SIZE, 1))
+			goto err_cancel_table;
+
+		if (ethnl_put_bitset32(skb, ETHTOOL_A_TUNNEL_UDP_TABLE_TYPES,
+				       &zero, NULL,
+				       __ETHTOOL_UDP_TUNNEL_TYPE_CNT,
+				       udp_tunnel_type_names, compact))
+			goto err_cancel_table;
+
+		entry = nla_nest_start(skb, ETHTOOL_A_TUNNEL_UDP_TABLE_ENTRY);
+
+		if (nla_put_be16(skb, ETHTOOL_A_TUNNEL_UDP_ENTRY_PORT,
+				 htons(IANA_VXLAN_UDP_PORT)) ||
+		    nla_put_u32(skb, ETHTOOL_A_TUNNEL_UDP_ENTRY_TYPE,
+				ilog2(UDP_TUNNEL_TYPE_VXLAN)))
+			goto err_cancel_entry;
+
+		nla_nest_end(skb, entry);
+		nla_nest_end(skb, table);
+	}
+
 	nla_nest_end(skb, ports);
 
 	return 0;
 
+err_cancel_entry:
+	nla_nest_cancel(skb, entry);
 err_cancel_table:
 	nla_nest_cancel(skb, table);
 err_cancel_ports:
diff --git a/net/ipv4/udp_tunnel_nic.c b/net/ipv4/udp_tunnel_nic.c
index f0dbd9905a531..69962165c0e8a 100644
--- a/net/ipv4/udp_tunnel_nic.c
+++ b/net/ipv4/udp_tunnel_nic.c
@@ -7,6 +7,7 @@
 #include <linux/types.h>
 #include <linux/workqueue.h>
 #include <net/udp_tunnel.h>
+#include <net/vxlan.h>
 
 enum udp_tunnel_nic_table_entry_flags {
 	UDP_TUNNEL_NIC_ENTRY_ADD	= BIT(0),
@@ -504,6 +505,12 @@ __udp_tunnel_nic_add_port(struct net_device *dev, struct udp_tunnel_info *ti)
 		return;
 	if (!netif_running(dev) && info->flags & UDP_TUNNEL_NIC_INFO_OPEN_ONLY)
 		return;
+	if (info->flags & UDP_TUNNEL_NIC_INFO_STATIC_IANA_VXLAN &&
+	    ti->port == htons(IANA_VXLAN_UDP_PORT)) {
+		if (ti->type != UDP_TUNNEL_TYPE_VXLAN)
+			netdev_warn(dev, "device assumes port 4789 will be used by vxlan tunnels\n");
+		return;
+	}
 
 	if (!udp_tunnel_nic_is_capable(dev, utn, ti))
 		return;
-- 
2.26.2

